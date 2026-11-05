-- Sjekker at testdataene for den interne akseptansetesten av «Tilbudsgaranti i saksbehandlingen 2027»
-- er klare. Bare lesing. Kjøres som superbruker, fordi tabellene har RLS.
-- Gir ett resultat, med én rad per sjekk: ok = true når tilstanden er som den skal.

WITH
soknad AS (
  SELECT s.soker_id, s.opptak_kode, s.soknadsnummer, s.utdanningsbakgrunn_type_kode
  FROM soknad_v2.soknad s
  WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
),
alternativ AS (
  SELECT a.prioritet, u.studieprogram_navn, ssa.organisasjonskode_behandler,
         ssa.tilbudsgarantitype_kode_fra_behandler AS fra_behandler,
         ssa.tilbudsgarantitype_kode_fra_tilbyder  AS fra_tilbyder,
         ssa.tilbudsgarantitype_kode_fra_forvalter AS fra_forvalter
  FROM soknad s
  JOIN soknad_v2.soknadsalternativ a
    ON a.soker_id = s.soker_id AND a.opptak_kode = s.opptak_kode AND a.slettet IS NULL
  JOIN opptak_v2.utdanningstilbud u
    ON u.opptak_kode = a.opptak_kode AND u.utdanningstilbudsnr = a.utdanningstilbudsnr
  LEFT JOIN saksbehandling.sak_soknadsalternativ ssa
    ON ssa.soker_id = a.soker_id AND ssa.opptak_kode = a.opptak_kode
   AND ssa.utdanningstilbudsnr = a.utdanningstilbudsnr
),
elektronisk AS (
  SELECT * FROM alternativ
  WHERE studieprogram_navn = 'Elektronisk systemingeniør - bachelor i ingeniørfag'
)
-- Tilbudsgarantitypene
SELECT 'Opptak 34: KLA, RES, REA og FOR finnes og er aktive' AS sjekk,
       coalesce((SELECT string_agg(tilbudsgarantitype_kode || '=' || er_aktiv, ', ' ORDER BY tilbudsgarantitype_kode)
                   FROM opptak_v2.tilbudsgarantitype
                  WHERE opptak_kode = 34 AND tilbudsgarantitype_kode IN ('KLA', 'RES', 'REA', 'FOR')), 'ingen') AS faktisk,
       (SELECT count(*) FILTER (WHERE er_aktiv) = 4
          FROM opptak_v2.tilbudsgarantitype
         WHERE opptak_kode = 34 AND tilbudsgarantitype_kode IN ('KLA', 'RES', 'REA', 'FOR')) AS ok
UNION ALL
SELECT 'Opptak 34: TEL finnes ikke (1.10), men finnes i opptak 1',
       format('opptak 34: %s, opptak 1: %s',
              EXISTS (SELECT 1 FROM opptak_v2.tilbudsgarantitype WHERE opptak_kode = 34 AND tilbudsgarantitype_kode = 'TEL'),
              EXISTS (SELECT 1 FROM opptak_v2.tilbudsgarantitype WHERE opptak_kode = 1  AND tilbudsgarantitype_kode = 'TEL')),
       NOT EXISTS (SELECT 1 FROM opptak_v2.tilbudsgarantitype WHERE opptak_kode = 34 AND tilbudsgarantitype_kode = 'TEL')
       AND EXISTS (SELECT 1 FROM opptak_v2.tilbudsgarantitype WHERE opptak_kode = 1  AND tilbudsgarantitype_kode = 'TEL')
UNION ALL
-- Behandlertildelingen (1.18)
SELECT 'Opptak 34: unntaket ORD + UTLAND går til forvalteren av opptaket (1.18)',
       coalesce((SELECT string_agg(r.behandlertildelingsregel_kode || ' + ' || r.utdanningsbakgrunn_type_kode
                                   || ' → ' || r.organisasjonskode_behandler, ', ')
                   FROM regelverk.behandlertildelingsregel_utdanningsbakgrunn r
                  WHERE r.opptak_kode = 34), 'ingen unntak')
       || ' (forvalter ' || (SELECT organisasjonskode FROM opptak_v2.opptak WHERE opptak_kode = 34) || ')',
       EXISTS (SELECT 1
                 FROM regelverk.behandlertildelingsregel_utdanningsbakgrunn r
                 JOIN opptak_v2.opptak o ON o.opptak_kode = r.opptak_kode
                WHERE r.opptak_kode = 34 AND r.behandlertildelingsregel_kode = 'ORD'
                  AND r.utdanningsbakgrunn_type_kode = 'UTLAND'
                  AND r.organisasjonskode_behandler = o.organisasjonskode)
UNION ALL
-- Søknad 1000836
SELECT 'Søknad 1000836: utdanningsbakgrunnen er ikke overstyrt, og søkerens egen er ikke UTLAND',
       coalesce((SELECT format('fra søker=%s, overstyrt=%s', s.utdanningsbakgrunn_type_kode,
                               coalesce(ss.utdanningsbakgrunn_type_kode_overstyr, '–'))
                   FROM soknad s
                   LEFT JOIN saksbehandling.sak_soknad ss
                     ON ss.soker_id = s.soker_id AND ss.opptak_kode = s.opptak_kode), 'søknaden finnes ikke'),
       coalesce((SELECT ss.utdanningsbakgrunn_type_kode_overstyr IS NULL
                        AND s.utdanningsbakgrunn_type_kode IS DISTINCT FROM 'UTLAND'
                   FROM soknad s
                   LEFT JOIN saksbehandling.sak_soknad ss
                     ON ss.soker_id = s.soker_id AND ss.opptak_kode = s.opptak_kode), false)
UNION ALL
SELECT 'Søknad 1000836: alle søknadsalternativene behandles av 194 (NTNU)',
       coalesce((SELECT string_agg(coalesce(organisasjonskode_behandler::text, 'ingen sak') || ': ' || antall, ', ')
                   FROM (SELECT organisasjonskode_behandler, count(*) AS antall
                           FROM alternativ GROUP BY 1) t), 'ingen søknadsalternativer'),
       coalesce((SELECT bool_and(organisasjonskode_behandler::text = '194') FROM alternativ), false)
UNION ALL
SELECT 'Søknad 1000836: «Elektronisk systemingeniør …» er prioritet 1',
       coalesce((SELECT 'prioritet ' || prioritet FROM elektronisk), 'ikke i søknaden'),
       coalesce((SELECT prioritet = 1 FROM elektronisk), false)
UNION ALL
SELECT 'Søknad 1000836: «Elektronisk systemingeniør …» har ingen tilbudsgaranti når testen starter',
       coalesce((SELECT format('behandler=%s, tilbyder=%s, forvalter=%s',
                               coalesce(fra_behandler, '–'), coalesce(fra_tilbyder, '–'), coalesce(fra_forvalter, '–'))
                   FROM elektronisk), 'ikke i søknaden'),
       coalesce((SELECT fra_behandler IS NULL AND fra_tilbyder IS NULL AND fra_forvalter IS NULL
                   FROM elektronisk), false);
