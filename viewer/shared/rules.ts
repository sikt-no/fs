// Konvensjonsreglene parseren sjekker (server/parse.ts), med tekstene avviksdashbordet viser.
// Holdes i synk med reglene merket «(sjekkes i vieweren)» i krav/README.md.

export type Severity = 'error' | 'warning';

export interface RuleDef {
  id: string;
  label: string;
  /** Kort etikett til kolonnene i «Regel × mappe»; \u00ad (myk bindestrek) viser hvor et langt ord kan deles */
  short: string;
  sev: Severity;
  /** Overskriften i krav/README.md der regelen står */
  section: string;
  desc: string;
}

export const RULES: RuleDef[] = [
  { id: 'missing-status', label: 'Mangler status', short: 'Mangler status', sev: 'error', section: 'Implementasjonsstatus',
    desc: 'Hver Egenskap skal ha én statustag: @draft, @planned, @in-progress eller @implemented. Uten status vises fila som «ingen status» i treet.' },
  { id: 'multiple-statuses', label: 'Flere statustagger', short: 'Flere statuser', sev: 'error', section: 'Implementasjonsstatus',
    desc: 'En Egenskap har nøyaktig én statustag. Ikke sett to samtidig.' },
  { id: 'status-on-part', label: 'Statustag på del', short: 'Status på del', sev: 'warning', section: 'Implementasjonsstatus',
    desc: 'Status settes på Egenskap. På Regel og Scenario brukes bare @draft, for deler som ikke er avklart.' },
  { id: 'retired-levert', label: '@levert (utgått)', short: '@levert', sev: 'error', section: 'Implementasjonsstatus',
    desc: 'Taggen @levert er erstattet av @implemented.' },
  { id: 'wrong-level', label: 'Feil mappenivå', short: 'Feil mappe\u00adnivå', sev: 'error', section: 'Mappestruktur',
    desc: 'Feature-filer ligger bare på kapabilitetsnivå: domene / sub-domene / kapabilitet.' },
  { id: 'folder-numbering', label: 'Mappenummerering', short: 'Mappe\u00adnummer', sev: 'error', section: 'Mappestruktur',
    desc: 'Sub-domener og kapabiliteter har nummer foran navnet. Sub-domener nummereres fra 10, kapabiliteter fra 01.' },
  { id: 'same-name', label: 'Sub-domene = kapabilitet', short: 'Samme navn', sev: 'warning', section: 'Tverrgående kapabiliteter: hva vs. hvordan',
    desc: 'Unngå å kalle sub-domenet og kapabiliteten det samme (f.eks. Søk/Søk). Bruk et navn som skiller nivåene.' },
  { id: 'examples-without-outline', label: 'Scenario: med Eksempler:', short: 'Scenario med Eksem\u00adpler', sev: 'error', section: 'Språk',
    desc: 'Eksempler: brukes bare sammen med Scenariomal:, ikke med vanlig Scenario:.' },
  { id: 'missing-language', label: 'Mangler # language: no', short: 'language', sev: 'error', section: 'Språk',
    desc: 'Hver feature-fil starter med «# language: no».' },
  { id: 'missing-id', label: 'Mangler ID', short: 'Mangler ID', sev: 'error', section: 'Feature-ID',
    desc: 'Hver Egenskap skal ha en unik feature-ID på formen @DOM-SUB-KAP-NNN.' },
  { id: 'multiple-ids', label: 'Flere feature-ID-er', short: 'Flere ID-er', sev: 'error', section: 'Feature-ID',
    desc: 'En Egenskap har én feature-ID.' },
  { id: 'multiple-priorities', label: 'Flere prioriteter', short: 'Flere prioriteter', sev: 'error', section: 'Prioritet (MoSCoW)',
    desc: 'En Egenskap har høyst én prioritet: @must, @should, @could eller @wont.' },
  { id: 'not-snake-case', label: 'Filnavn ikke i snake_case', short: 'snake_\u00adcase', sev: 'warning', section: 'Filnavn',
    desc: 'Filnavn skrives med små bokstaver og understrek, for eksempel se_søknad.feature.' },
  { id: 'missing-description', label: 'Mangler beskrivelse', short: 'Beskriv\u00adelse', sev: 'warning', section: 'Gode scenarioer',
    desc: 'Under Egenskap: står en beskrivelse av hva featuren gjør og hvilken verdi den gir.' },
  { id: 'step-order', label: 'Feil stegrekkefølge', short: 'Steg\u00adrekke\u00adfølge', sev: 'warning', section: 'Gode scenarioer',
    desc: 'Stegene står i rekkefølgen Gitt, Når, Så. Det er lov med flere av hvert, men aldri i en annen rekkefølge.' },
  { id: 'redundant-draft', label: 'Overflødig @draft', short: 'Over\u00adflødig @draft', sev: 'warning', section: 'Delvis utkast',
    desc: '@draft på en Regel eller et Scenario er overflødig når hele Egenskap allerede er @draft.' },
  { id: 'draft-without-openquestion', label: '@draft uten @openquestion', short: '@draft uten spm.', sev: 'warning', section: 'Delvis utkast',
    desc: 'En del som er @draft tagges @draft @openquestion, med en «# ÅPNE SPØRSMÅL:»-kommentar. Uten @openquestion er delen ikke gjennomgått.' },
  { id: 'openquestion-on-feature', label: '@openquestion på Egenskap', short: '@openquestion på Egenskap', sev: 'error', section: 'Oppfølging',
    desc: '@openquestion står på Regel eller Scenario. Er hele kravet uavklart, bruk @draft på Egenskap.' },
  { id: 'openquestion-without-comment', label: '@openquestion uten spørsmål', short: 'Uten spørsmål', sev: 'error', section: 'Åpne spørsmål',
    desc: '@openquestion følges alltid av en «# ÅPNE SPØRSMÅL:»-kommentar som beskriver spørsmålet.' },
  { id: 'todo-comment', label: '# TODO: for spørsmål', short: '# TODO', sev: 'error', section: 'Åpne spørsmål',
    desc: 'Åpne spørsmål skrives under «# ÅPNE SPØRSMÅL:», ikke som «# TODO:».' },
  { id: 'focus-tag', label: '@only / @focus i kravfil', short: '@only', sev: 'warning', section: 'Type',
    desc: '@only gjør scenarioet om til test.only i playwright-bdd, så resten av testene hoppes over. @focus har ingen virkning i playwright-bdd. Ingen av dem skal sjekkes inn i en kravfil.' },
];

export const RULE: Record<string, RuleDef> = Object.fromEntries(RULES.map(r => [r.id, r]));
