-- Setter tilbudsgarantitypene i opptak 34 lik typene med tekster i opptak 1, unntatt TEL.
-- Typene som finnes i opptak 34 fra før, slettes først, så vi vet nøyaktig hva som ligger der.
-- TEL («Tilbudsgaranti gitt etter telefonsamtale») skal bare finnes i opptak 1: den interne
-- akseptansetesten av tilbudsgaranti (testcase 1.10) sjekker at en type fra et annet opptak
-- ikke kan velges. Testcasene bruker KLA, RES (saksbehandler), REA (tilbyder) og FOR (opptaksforvalter).
-- Kjøres som superbruker: tabellene har RLS. Opptak 34 må finnes i opptak_v2.opptak.
-- Kategoriene er felles for alle opptak og ligger der fra migreringene.
--
-- Sakene i opptak 34 kan bruke typene (saksbehandling.sak_soknadsalternativ og
-- saksbehandling.tidligopptak_resultat). Fremmednøklene sjekkes først ved COMMIT, så en type
-- som slettes og legges inn igjen, er i orden. Brukes en type som ikke legges inn igjen (TEL,
-- eller en type som bare fantes i opptak 34), feiler COMMIT, og ingenting er endret.
-- Kjør spørringen under først for å se om det gjelder noen saker.

-- Før: typer som brukes i opptak 34, men som ikke legges inn igjen
SELECT kode, count(*) AS antall
  FROM (SELECT tilbudsgarantitype_kode_fra_behandler AS kode FROM saksbehandling.sak_soknadsalternativ WHERE opptak_kode = 34
        UNION ALL
        SELECT tilbudsgarantitype_kode_fra_tilbyder FROM saksbehandling.sak_soknadsalternativ WHERE opptak_kode = 34
        UNION ALL
        SELECT tilbudsgarantitype_kode_fra_forvalter FROM saksbehandling.sak_soknadsalternativ WHERE opptak_kode = 34
        UNION ALL
        SELECT tilbudsgarantitype_kode FROM saksbehandling.tidligopptak_resultat WHERE opptak_kode = 34) brukt
 WHERE kode IS NOT NULL
   AND kode NOT IN (SELECT tilbudsgarantitype_kode
                      FROM opptak_v2.tilbudsgarantitype
                     WHERE opptak_kode = 1 AND tilbudsgarantitype_kode <> 'TEL')
 GROUP BY kode
 ORDER BY kode;

BEGIN;

SET CONSTRAINTS ALL DEFERRED;

DELETE FROM opptak_v2.tilbudsgarantitype_sprak WHERE opptak_kode = 34;
DELETE FROM opptak_v2.tilbudsgarantitype      WHERE opptak_kode = 34;

INSERT INTO opptak_v2.tilbudsgarantitype (opptak_kode, tilbudsgarantitype_kode, tilbudsgarantikategori_kode,
    er_tilbudsgivende, er_aktiv, kan_brukes_av_behandler, kan_brukes_av_forvalter, kan_brukes_av_tilbyder)
SELECT 34, tilbudsgarantitype_kode, tilbudsgarantikategori_kode,
       er_tilbudsgivende, er_aktiv, kan_brukes_av_behandler, kan_brukes_av_forvalter, kan_brukes_av_tilbyder
  FROM opptak_v2.tilbudsgarantitype
 WHERE opptak_kode = 1
   AND tilbudsgarantitype_kode <> 'TEL';

INSERT INTO opptak_v2.tilbudsgarantitype_sprak (opptak_kode, tilbudsgarantitype_kode, sprakkode, navn, tekst)
SELECT 34, tilbudsgarantitype_kode, sprakkode, navn, tekst
  FROM opptak_v2.tilbudsgarantitype_sprak
 WHERE opptak_kode = 1
   AND tilbudsgarantitype_kode <> 'TEL';

COMMIT;

-- Etter: opptak 34 har én type og ett sett tekster mindre enn opptak 1 (TEL)
SELECT opptak_kode, count(*) FROM opptak_v2.tilbudsgarantitype      WHERE opptak_kode IN (1, 34) GROUP BY 1 ORDER BY 1;
SELECT opptak_kode, count(*) FROM opptak_v2.tilbudsgarantitype_sprak WHERE opptak_kode IN (1, 34) GROUP BY 1 ORDER BY 1;

-- Typene testcasene bruker: KLA og RES for saksbehandler, REA for tilbyder, FOR for opptaksforvalter, og ingen TEL.
SELECT tilbudsgarantitype_kode, kan_brukes_av_behandler, kan_brukes_av_tilbyder, kan_brukes_av_forvalter
  FROM opptak_v2.tilbudsgarantitype
 WHERE opptak_kode = 34 AND tilbudsgarantitype_kode IN ('KLA', 'RES', 'REA', 'FOR', 'TEL')
 ORDER BY 1;
