-- Gjør grunnlaget «Avvikle virksomheten» (AVVIKLE) for tidlig opptak aktivt igjen i opptak 34,
-- etter den interne akseptansetesten av «Søke om tidlig opptak».
-- Motsatt av for-testen-gjor-grunnlag-inaktivt.sql.
-- Kjøres som superbruker: tabellen har RLS.

BEGIN;

UPDATE opptak_v2.tidligopptak_begrunnelsetype
SET er_aktiv = true
WHERE opptak_kode = 34
  AND tidligopptak_begrunnelsetype_kode = 'AVVIKLE';

-- Etter: ventet er_aktiv = true for alle fem
SELECT tidligopptak_begrunnelsetype_kode, er_aktiv
FROM opptak_v2.tidligopptak_begrunnelsetype
WHERE opptak_kode = 34
ORDER BY tidligopptak_begrunnelsetype_kode;

COMMIT;
