-- Gjør grunnlaget «Avvikle virksomheten» (AVVIKLE) for tidlig opptak inaktivt i opptak 34.
-- Kjøres før den interne akseptansetesten av «Søke om tidlig opptak»: testcase 3.1 venter at
-- et grunnlag som ikke er aktivt, ikke vises for søkeren. Det gjelder hele opptak 34.
-- Settes tilbake med etter-testen-gjor-grunnlag-aktivt.sql etter testen.
-- Kjøres som superbruker: tabellen har RLS.

-- Før: ventet er_aktiv = true for alle fem
SELECT tidligopptak_begrunnelsetype_kode, er_aktiv
FROM opptak_v2.tidligopptak_begrunnelsetype
WHERE opptak_kode = 34
ORDER BY tidligopptak_begrunnelsetype_kode;

BEGIN;

UPDATE opptak_v2.tidligopptak_begrunnelsetype
SET er_aktiv = false
WHERE opptak_kode = 34
  AND tidligopptak_begrunnelsetype_kode = 'AVVIKLE';

-- Etter: AVVIKLE er false, de andre fire er true
SELECT tidligopptak_begrunnelsetype_kode, er_aktiv
FROM opptak_v2.tidligopptak_begrunnelsetype
WHERE opptak_kode = 34
ORDER BY tidligopptak_begrunnelsetype_kode;

COMMIT;
