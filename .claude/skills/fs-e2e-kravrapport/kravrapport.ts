/**
 * Kravrapport fra e2e-testene i fs-admin: lister alle kravene i krav/ med status, og kobler dem
 * mot krav-taggene på Playwright-testene i results.json fra test-e2e-jobbene i en pipeline.
 *
 *   node .claude/skills/fs-e2e-kravrapport/kravrapport.ts [--mr 2996] [--pipeline <id>] [--krav krav] [--domene OPT] [--ut fil.md]
 *
 * Uten --pipeline brukes den nyeste ferdige pipelinen (success eller failed) for MR-en i fs-admin.
 * Uten --krav leses krav/ i dette repoet. Krever Node 24 eller nyere, `glab` innlogget mot
 * gitlab.sikt.no, og `unzip`.
 */

import { execFileSync, type ExecFileSyncOptions } from "node:child_process";
import {
  mkdtempSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
  existsSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";
import { parseArgs } from "node:util";

const PROSJEKT = "studieadm%2Ffs-admin";
const KRAV_ID = /@([A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-\d{3})\b/;
const STATUSER = [
  "draft",
  "planned",
  "in-progress",
  "implemented",
  "deprecated",
] as const;
const PRIORITETER = ["must", "should", "could", "wont"] as const;

const { values: arg } = parseArgs({
  options: {
    mr: { type: "string", default: "2996" },
    pipeline: { type: "string" },
    krav: {
      type: "string",
      default: fileURLToPath(new URL("../../../krav", import.meta.url)),
    },
    domene: { type: "string" },
    ut: { type: "string" },
  },
});

type Resultat = "grønn" | "rød" | "ustabil" | "ikke kjørt";

type Test = {
  fil: string;
  tittel: string;
  tagger: string[];
  resultat: Resultat;
  profiler: string[];
};

type Del = { type: string; tittel: string; status: string; linje: number };

type Krav = {
  id: string;
  tittel: string;
  fil: string;
  status?: string;
  prioritet?: string;
  // Regler og scenarioer med egen status som ikke er levert, i et krav som er levert.
  deler: Del[];
};

function glab<T>(sti: string): T {
  return JSON.parse(
    execFileSync("glab", ["api", sti], {
      encoding: "utf8",
      maxBuffer: 1 << 26,
    }),
  );
}

function velgPipeline(): {
  id: number;
  status: string;
  sha: string;
  web_url: string;
} {
  if (arg.pipeline)
    return glab(`projects/${PROSJEKT}/pipelines/${arg.pipeline}`);
  const pipelines = glab<
    { id: number; status: string; sha: string; web_url: string }[]
  >(`projects/${PROSJEKT}/merge_requests/${arg.mr}/pipelines?per_page=20`);
  // Kjørende pipelines har ingen artefakter ennå.
  const ferdig = pipelines.find(
    (p) => p.status === "success" || p.status === "failed",
  );
  if (!ferdig) throw new Error(`Fant ingen ferdig pipeline for MR !${arg.mr}`);
  return ferdig;
}

// Playwright: expected = som forventet, unexpected = feilet, flaky = feilet først og besto på retry.
function tilResultat(status: string): Resultat {
  if (status === "expected") return "grønn";
  if (status === "unexpected") return "rød";
  if (status === "flaky") return "ustabil";
  return "ikke kjørt";
}

type Suite = {
  specs?: {
    file: string;
    title: string;
    tags: string[];
    tests: { status: string }[];
  }[];
  suites?: Suite[];
};

function lesResultater(
  json: { suites: Suite[] },
  profil: string,
  tester: Map<string, Test>,
) {
  const gå = (suite: Suite) => {
    for (const spec of suite.specs ?? []) {
      for (const t of spec.tests) {
        const nøkkel = `${spec.file}|${spec.title}`;
        const resultat = tilResultat(t.status);
        const finnes = tester.get(nøkkel);
        if (!finnes) {
          tester.set(nøkkel, {
            fil: spec.file,
            tittel: spec.title,
            tagger: spec.tags,
            resultat,
            profiler: [profil],
          });
          continue;
        }
        // Samme test i flere profiler (felles/): det verste resultatet gjelder.
        finnes.profiler.push(profil);
        finnes.resultat = verst([finnes.resultat, resultat]);
      }
    }
    suite.suites?.forEach(gå);
  };
  json.suites.forEach(gå);
}

const RANGERING: Resultat[] = ["rød", "ikke kjørt", "ustabil", "grønn"];
const verst = (r: Resultat[]) =>
  RANGERING.find((x) => r.includes(x)) ?? "grønn";

function hentTester(pipelineId: number) {
  const jobber = glab<{ id: number; name: string; status: string }[]>(
    `projects/${PROSJEKT}/pipelines/${pipelineId}/jobs?per_page=100`,
  ).filter((j) => j.name.startsWith("test-e2e"));
  const tester = new Map<string, Test>();
  const manglerResultater: string[] = [];
  const tmp = mkdtempSync(join(tmpdir(), "kravrapport-"));
  try {
    for (const jobb of jobber) {
      const profil = jobb.name.match(/\[(.+)\]/)?.[1] ?? jobb.name;
      const zip = join(tmp, `${jobb.id}.zip`);
      const mappe = join(tmp, String(jobb.id));
      try {
        const stille: ExecFileSyncOptions = {
          stdio: ["ignore", "pipe", "ignore"],
          maxBuffer: 1 << 28,
        };
        writeFileSync(
          zip,
          execFileSync(
            "glab",
            ["api", `projects/${PROSJEKT}/jobs/${jobb.id}/artifacts`],
            stille,
          ),
        );
        execFileSync(
          "unzip",
          ["-q", "-o", zip, "test-results/results.json", "-d", mappe],
          stille,
        );
      } catch {
        manglerResultater.push(`${profil} (jobben er ${jobb.status})`);
        continue;
      }
      lesResultater(
        JSON.parse(
          readFileSync(join(mappe, "test-results/results.json"), "utf8"),
        ),
        profil,
        tester,
      );
    }
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
  return { jobber, tester: [...tester.values()], manglerResultater };
}

function featurefiler(mappe: string): string[] {
  return readdirSync(mappe, { withFileTypes: true, recursive: true })
    .filter((f) => f.isFile() && f.name.endsWith(".feature"))
    .map((f) => join(f.parentPath, f.name));
}

const LEVERT = ["implemented", "deprecated"];
const finnStatus = (tagger: string) =>
  STATUSER.find((t) => new RegExp(`@${t}(\\s|$)`).test(tagger));

// Taggene står på linjene rett over nøkkelordet.
function taggerOver(linjer: string[], i: number): string {
  const tagger: string[] = [];
  for (let j = i - 1; j >= 0 && linjer[j].trim().startsWith("@"); j--)
    tagger.push(linjer[j]);
  return tagger.join(" ");
}

// En regel arver status fra egenskapen og et scenario fra regelen, hvis de ikke har sin egen.
function ikkeLeverteDeler(
  linjer: string[],
  egenskap: number,
  status?: string,
): Del[] {
  if (!status || !LEVERT.includes(status)) return [];
  const deler: Del[] = [];
  let regelstatus = status;
  for (let i = egenskap + 1; i < linjer.length; i++) {
    const treff = linjer[i].match(
      /^\s*(Regel|Rule|Scenario|Scenariomal|Eksempel):\s*(.*)$/,
    );
    if (!treff) continue;
    const [, type, tittel] = treff;
    const egen = finnStatus(taggerOver(linjer, i));
    const regel = type === "Regel" || type === "Rule";
    const arvet = regel ? status : regelstatus;
    if (regel) regelstatus = egen ?? status;
    if (egen && !LEVERT.includes(egen) && LEVERT.includes(arvet))
      deler.push({ type, tittel: tittel.trim(), status: egen, linje: i + 1 });
  }
  return deler;
}

// Status og prioritet leses fra taggene på Egenskap-nivå: linjene med tagger før `Egenskap:`/`Feature:`.
function lesKrav(rot: string) {
  const krav = new Map<string, Krav>();
  const duplikater: string[] = [];
  const utenId: string[] = [];
  for (const fil of featurefiler(rot)) {
    const linjer = readFileSync(fil, "utf8").split("\n");
    const egenskap = linjer.findIndex((l) => /^\s*(Egenskap|Feature):/.test(l));
    if (egenskap === -1) continue;
    const tagger = linjer
      .slice(0, egenskap)
      .filter((l) => l.trim().startsWith("@"))
      .join(" ");
    const id = tagger.match(KRAV_ID)?.[1];
    const sti = relative(rot, fil);
    if (!id) {
      utenId.push(sti);
      continue;
    }
    if (krav.has(id)) {
      duplikater.push(`${id}: ${krav.get(id)!.fil} og ${sti}`);
      continue;
    }
    krav.set(id, {
      id,
      tittel: linjer[egenskap].replace(/^\s*(Egenskap|Feature):\s*/, "").trim(),
      fil: sti,
      status: finnStatus(tagger),
      prioritet: PRIORITETER.find((t) =>
        new RegExp(`@${t}(\\s|$)`).test(tagger),
      ),
      deler: ikkeLeverteDeler(linjer, egenskap, finnStatus(tagger)),
    });
  }
  return { krav, duplikater, utenId };
}

if (!existsSync(arg.krav))
  throw new Error(
    `Fant ikke kravene i ${arg.krav}. Bruk --krav <sti til krav/>.`,
  );

const pipeline = velgPipeline();
const { jobber, tester, manglerResultater } = hentTester(pipeline.id);
const git = (...args: string[]) => {
  try {
    return execFileSync("git", ["-C", arg.krav, ...args], {
      encoding: "utf8",
    }).trim();
  } catch {
    return undefined;
  }
};
const commit = git("rev-parse", "--short", "HEAD");
const kravkilde = `\`${relative(process.cwd(), arg.krav) || "."}\`${commit ? ` (${git("rev-parse", "--abbrev-ref", "HEAD")}@${commit})` : ""}`;
const { krav, duplikater, utenId } = lesKrav(arg.krav);

const testerPerKrav = new Map<string, Test[]>();
for (const test of tester) {
  for (const tag of test.tagger) {
    const id = tag.replace(/^@/, "");
    testerPerKrav.set(id, [...(testerPerKrav.get(id) ?? []), test]);
  }
}

const iDomenet = (id: string) =>
  !arg.domene || id.startsWith(`${arg.domene.toUpperCase()}-`);
const ukjenteTagger = [...testerPerKrav.keys()].filter(
  (id) => !krav.has(id) && iDomenet(id),
);
// Oppsett (seeding, persona) er ikke tester av noe krav.
const utenTag = tester.filter(
  (t) => t.tagger.length === 0 && t.fil.startsWith("tester/"),
);

type Rad = Krav & { tester: Test[]; resultat?: Resultat };
const rader: Rad[] = [...krav.values()]
  .filter((k) => iDomenet(k.id))
  .sort((a, b) => a.id.localeCompare(b.id, "nb"))
  .map((k) => {
    const t = testerPerKrav.get(k.id) ?? [];
    return {
      ...k,
      tester: t,
      resultat: t.length ? verst(t.map((x) => x.resultat)) : undefined,
    };
  });

const levert = (k: Krav) => LEVERT.includes(k.status ?? "");
const e2e = (r: Rad) => r.resultat ?? "uten test";
const kode = (s: string) => `\`${s}\``;
const testliste = (t: Test[]) =>
  t
    .map(
      (x) => `${x.tittel}${x.resultat === "grønn" ? "" : ` (${x.resultat})`}`,
    )
    .join("<br>");
// Én rad per verdi i rekkefølgen, uten verdier som ikke forekommer.
const telling = (verdier: string[], rekkefølge: string[]) =>
  rekkefølge
    .map((v) => [v, verdier.filter((x) => x === v).length] as const)
    .filter(([, antall]) => antall > 0)
    .map(([v, antall]) => `| ${v} | ${antall} |`);

const ut: string[] = [];
ut.push(`# Kravrapport fra e2e-testene`, "");
ut.push(
  `- **Pipeline:** [${pipeline.id}](${pipeline.web_url}) (${pipeline.status}, ${pipeline.sha.slice(0, 8)})`,
);
if (!arg.pipeline) ut.push(`- **MR:** !${arg.mr}`);
ut.push(
  `- **Jobber:** ${jobber.map((j) => `${j.name} (${j.status})`).join(", ") || "ingen test-e2e-jobber"}`,
);
ut.push(
  `- **Krav:** ${kravkilde}${arg.domene ? `, domene ${arg.domene.toUpperCase()}` : ""}`,
);
if (manglerResultater.length)
  ut.push(
    `- **Mangler results.json:** ${manglerResultater.join(", ")}. Rapporten er ufullstendig: krav som testes i disse profilene, står som uten test.`,
  );

ut.push("", "## Oppsummering", "", `${rader.length} krav.`, "");
ut.push("| Kravstatus | Krav |", "| --- | ---: |");
ut.push(
  ...telling(
    rader.map((r) => r.status ?? "mangler"),
    [...STATUSER, "mangler"],
  ),
);
ut.push("", "| E2e-resultat | Krav |", "| --- | ---: |");
ut.push(...telling(rader.map(e2e), [...RANGERING, "uten test"]));

const tabell = (
  overskrift: string,
  forklaring: string,
  utvalg: Rad[],
  medTester: boolean,
) => {
  if (!utvalg.length) return;
  ut.push("", `## ${overskrift}`, "", forklaring, "");
  ut.push(
    `| Krav | Tittel | Status | Prioritet | E2e |${medTester ? " Tester |" : ""}`,
    `| --- | --- | --- | --- | --- |${medTester ? " --- |" : ""}`,
  );
  for (const r of utvalg)
    ut.push(
      `| ${kode(r.id)} | ${r.tittel} | ${r.status ?? "mangler"} | ${r.prioritet ?? "–"} | ${e2e(r)} |${medTester ? ` ${testliste(r.tester)} |` : ""}`,
    );
};

tabell(
  "Rød",
  "Minst én test for kravet feilet.",
  rader.filter((r) => r.resultat === "rød"),
  true,
);
tabell(
  "Ustabil eller ikke kjørt",
  "En test besto først på retry, eller ble hoppet over (i en seriell suite fordi et steg før feilet).",
  rader.filter((r) => r.resultat === "ustabil" || r.resultat === "ikke kjørt"),
  true,
);
tabell(
  "Grønn",
  "Alle testene for kravet besto.",
  rader.filter((r) => r.resultat === "grønn"),
  true,
);
tabell(
  "Ikke implementert",
  "Alle krav som ikke er `@implemented` eller `@deprecated`, også dem som har en e2e-test.",
  rader.filter((r) => !levert(r)),
  false,
);

const deler = rader.flatMap((r) => r.deler.map((d) => ({ ...d, krav: r })));
if (deler.length) {
  ut.push(
    "",
    "## Ikke implementerte deler av implementerte krav",
    "",
    "Regler og scenarioer med egen status (for eksempel `@draft`) i et krav som ellers er levert.",
    "",
  );
  ut.push("| Krav | Del | Status | Fil |", "| --- | --- | --- | --- |");
  for (const d of deler)
    ut.push(
      `| ${kode(d.krav.id)} | ${d.type}: ${d.tittel} | ${d.status} | ${kode(`${d.krav.fil}:${d.linje}`)} |`,
    );
}

tabell(
  "Implementert, uten e2e-test",
  "Kravet er `@implemented` eller `@deprecated`, men ingen test har ID-en som tag.",
  rader.filter((r) => levert(r) && !r.resultat),
  false,
);

ut.push("", "## Alle krav", "");
ut.push(
  "| Krav | Tittel | Status | Prioritet | E2e | Fil |",
  "| --- | --- | --- | --- | --- | --- |",
);
for (const r of rader)
  ut.push(
    `| ${kode(r.id)} | ${r.tittel} | ${r.status ?? "mangler"} | ${r.prioritet ?? "–"} | ${e2e(r)} | ${kode(r.fil)} |`,
  );

const avvik = [
  ...ukjenteTagger.map(
    (id) =>
      `Taggen ${kode(id)} på ${testliste(testerPerKrav.get(id)!)} finnes ikke i kravene.`,
  ),
  ...duplikater.map((d) => `Samme ID i to filer: ${d}.`),
  ...utenId.map((f) => `Uten krav-ID: ${kode(f)}.`),
];
if (avvik.length) ut.push("", "## Avvik", "", ...avvik.map((a) => `- ${a}`));

ut.push("", `## Tester uten krav-tag`, "");
ut.push(
  utenTag.length
    ? utenTag.map((t) => `- ${t.fil}: ${t.tittel} (${t.resultat})`).join("\n")
    : "Ingen.",
);

const rapport = ut.join("\n") + "\n";
if (arg.ut) {
  writeFileSync(arg.ut, rapport);
  console.error(`Skrev ${arg.ut}`);
} else {
  process.stdout.write(rapport);
}
