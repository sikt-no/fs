-- Finner verdiene til miljøfila (cdp-tester/_Miljøer/test.md) for testene av «Gi tilbudsgaranti ved tidlig opptak».
-- Bare lesing. Kjøres som superbruker (tabellene har RLS). Skrevet mot fs-plattform origin/main 2026-11-09.
-- Fire spørringer, hver med sin tabell. Kjør dem én og én, eller alle og les resultatene etter tur.

-- 1. Tilbudsgarantitypene i opptak 34.
--    Kategori F = tidlig opptak, S = reservert studieplass (TidligopptakTilbudsgarantiService).
--    tilbudsgarantitype-tidlig-opptak:              F, tilbudsgivende, aktiv, forvalter (nøyaktig én)
--    tilbudsgarantitype-tilbyder-tidligopptakstilbud: F, tilbudsgivende, aktiv, tilbyder
--    tilbudsgarantitype-forvalter-gir-tilbud:       ikke F eller S, tilbudsgivende, aktiv, forvalter
--    tilbudsgarantitype-forvalter-gir-ikke-tilbud:  ikke tilbudsgivende, aktiv, forvalter
--    tilbudsgarantitype-reservert-studieplass:      S, aktiv, behandler og forvalter
SELECT t.tilbudsgarantitype_kode AS kode, s.navn, t.tilbudsgarantikategori_kode AS kategori,
       t.er_tilbudsgivende AS gir_tilbud, t.er_aktiv AS aktiv,
       t.kan_brukes_av_behandler AS behandler, t.kan_brukes_av_forvalter AS forvalter,
       t.kan_brukes_av_tilbyder AS tilbyder
  FROM opptak_v2.tilbudsgarantitype t
  LEFT JOIN opptak_v2.tilbudsgarantitype_sprak s
    ON s.opptak_kode = t.opptak_kode AND s.tilbudsgarantitype_kode = t.tilbudsgarantitype_kode
   AND s.sprakkode IN ('nb', 'nob')
 WHERE t.opptak_kode = 34
 ORDER BY t.tilbudsgarantikategori_kode NULLS LAST, t.tilbudsgarantitype_kode;

-- 2. Utdanningstilbudene i opptak 34 som tilbyr tidlig opptak, med poenggrensen og medianen fra forrige opptak
--    (samme oppslag som fjoraretsMedianPoengsum i UtdanningstilbudV2Service).
--    utdanningstilbud-tidlig-opptak-med-median:  median er satt
--    utdanningstilbud-tidlig-opptak-uten-median: median er tom
--    Poenggrensen settes av oppsettet, så den kan stå med en verdi her.
SELECT u.utdanningstilbudsnr AS nr, u.studieprogram_navn AS navn, u.organisasjonskode AS org,
       u.tidlig_opptak_poenggrense AS poenggrense,
       (SELECT ts.median_poengsum
          FROM opptak_v2.tidligere_studium ts
          JOIN opptak_v2.opptak o ON o.opptakstype_kode = ts.opptakstype_kode
         WHERE o.opptak_kode = u.opptak_kode
           AND ts.organisasjonskode = u.organisasjonskode
           AND ts.studietypenr = u.studietypenr
           AND ts.arstall = (SELECT max(n.arstall) FROM opptak_v2.tidligere_studium n
                              WHERE n.opptakstype_kode = ts.opptakstype_kode)) AS median
  FROM opptak_v2.utdanningstilbud u
 WHERE u.opptak_kode = 34 AND NOT u.er_kansellert AND u.tilbyr_tidlig_opptak
 ORDER BY median IS NULL, u.studieprogram_navn;

-- 3. Andre opptak med tidlig opptak slått på, og hvor mange tilbudsgarantityper gjennomføringen kan bruke.
--    opptak-tidlig-opptak-uten-tilbudsgarantitype: kandidater = 0
--    opptak-tidlig-opptak-to-tilbudsgarantityper:  kandidater = 2
--    Begge må forvaltes av HK-dir (forvalter = organisasjonen til opptak-forvalter-forvaltende) og ha minst ett
--    utdanningstilbud med tidlig opptak.
SELECT o.opptak_kode, o.navn, o.organisasjonskode AS forvalter, o.opptaksstatus_kode AS status,
       (SELECT count(*) FROM opptak_v2.tilbudsgarantitype t
         WHERE t.opptak_kode = o.opptak_kode AND t.tilbudsgarantikategori_kode = 'F'
           AND t.er_tilbudsgivende AND t.er_aktiv AND t.kan_brukes_av_forvalter) AS kandidater,
       (SELECT count(*) FROM opptak_v2.utdanningstilbud u
         WHERE u.opptak_kode = o.opptak_kode AND NOT u.er_kansellert AND u.tilbyr_tidlig_opptak) AS tilbud_med_tidlig_opptak
  FROM opptak_v2.opptak o
 WHERE o.tidlig_opptak
 ORDER BY kandidater, o.opptak_kode;

-- 4. Søkerne i opptak 34 som har søkt tidlig opptak, med en aktiv sak hos UiT (186): statusen på saken,
--    konklusjonen og tilbudsgarantien fra forvalter. En søker kan brukes i testene når saken ikke er behandlet,
--    ikke har konklusjon og ikke har tilbudsgaranti fra forvalter.
--    Kvalifiseringen og poengsummen står ikke her: se saken i FS Admin.
SELECT sak.soker_id, sak.soknadsnummer, sak.saksnummer, sak.statustype_kode AS status,
       coalesce(sak.tidligopptak_konklusjon_kode, '–') AS konklusjon,
       (SELECT string_agg(DISTINCT coalesce(ssa.tilbudsgarantitype_kode_fra_forvalter, '–'), ', ')
          FROM saksbehandling.sak_soknadsalternativ ssa
         WHERE ssa.soker_id = sak.soker_id AND ssa.opptak_kode = sak.opptak_kode
           AND ssa.organisasjonskode_behandler = sak.organisasjonskode) AS garanti_forvalter
  FROM saksbehandling.sak sak
  JOIN soknad_v2.soknad s ON s.soker_id = sak.soker_id AND s.opptak_kode = sak.opptak_kode
 WHERE sak.opptak_kode = 34 AND sak.er_aktiv AND sak.organisasjonskode = 186
   AND s.tidligopptak_begrunnelsetype_kode IS NOT NULL
 ORDER BY sak.statustype_kode <> 'BEHANDLET' DESC, sak.soknadsnummer;

-- 5. Ubrukte søkere: personer «Velg testsøker» i Min kompetanse viser (de første 999 i tilgangskontroll.person,
--    antatt rekkefølge person_id, som i den eksterne testen av tidlig opptak), med fødselsnummer, og uten søknad
--    i opptak 34. Dette er spørringen fra 2026-11-03, skrevet på nytt.
--    Se over lista før den brukes: ta ut fødselsnumre som ser ekte ut, og navn som ligner ekte personer.
WITH valgbar AS (
  SELECT p.person_id, p.fornavn, p.etternavn, row_number() OVER (ORDER BY p.person_id) AS nr_i_lista
    FROM tilgangskontroll.person p
)
SELECT v.nr_i_lista, upper(v.fornavn || ' ' || v.etternavn) AS navn, pi.identifikator AS fodselsnummer
  FROM valgbar v
  JOIN tilgangskontroll.personidentifikasjon pi
    ON pi.person_id = v.person_id AND pi.personidentifikasjon_type_kode = 'FØDSELSNUMMER'
 WHERE v.nr_i_lista <= 999
   AND NOT EXISTS (
     SELECT 1 FROM soknad_v2.soker sk
       JOIN soknad_v2.soknad s ON s.soker_id = sk.soker_id AND s.opptak_kode = 34
      WHERE sk.person_id = v.person_id)
 ORDER BY v.nr_i_lista;
