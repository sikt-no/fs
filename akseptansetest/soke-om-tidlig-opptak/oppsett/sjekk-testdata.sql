-- Sjekker at testdataene for den interne akseptansetesten av «Søke om tidlig opptak» er klare.
-- Bare lesing. Gir ett resultat, med én rad per sjekk: ok = true når tilstanden er som den skal.

WITH
sokere (tb, fnr, opptak_kode) AS (
  VALUES (1, '10830798485', 34),   -- Samtidig Sild
         (2, '05849540000', 34),   -- Heidi Lykke
         (3, '05849509715', 34),   -- Frisk Frosk
         (4, '31900699630', 2)     -- Ullen Bikkje
),
soker AS (
  SELECT s.tb, s.opptak_kode, sk.soker_id
  FROM sokere s
  JOIN tilgangskontroll.personidentifikasjon pi
    ON pi.identifikator = s.fnr AND pi.personidentifikasjon_type_kode = 'FØDSELSNUMMER'
  JOIN soknad_v2.soker sk ON sk.person_id = pi.person_id
),
soknad AS (
  SELECT so.tb, s.soknadsnummer, s.tidligopptak_begrunnelsetype_kode,
         count(a.*) FILTER (WHERE u.tilbyr_tidlig_opptak)     AS tilbyr_tidlig,
         count(a.*) FILTER (WHERE NOT u.tilbyr_tidlig_opptak) AS tilbyr_ikke,
         string_agg(u.studieprogram_navn, ', ' ORDER BY a.prioritet) AS alternativer
  FROM soker so
  JOIN soknad_v2.soknad s ON s.soker_id = so.soker_id AND s.opptak_kode = so.opptak_kode
  LEFT JOIN soknad_v2.soknadsalternativ a
    ON a.soker_id = s.soker_id AND a.opptak_kode = s.opptak_kode AND a.slettet IS NULL
  LEFT JOIN opptak_v2.utdanningstilbud u
    ON u.opptak_kode = a.opptak_kode AND u.utdanningstilbudsnr = a.utdanningstilbudsnr
  GROUP BY so.tb, s.soknadsnummer, s.tidligopptak_begrunnelsetype_kode
),
frist AS (
  SELECT opptak_kode, hendelse_tidspunkt
  FROM opptak_v2.opptakshendelse
  WHERE opptakshendelsestype_kode = 'SØKNADSFRIST_TIDLIG_OPPTAK'
)
-- Opptak 34
SELECT 'Opptak 34: tidlig opptak er slått på, og lenken er satt' AS sjekk,
       format('tidlig_opptak=%s, lenke=%s', o.tidlig_opptak, coalesce(o.tidlig_opptak_lenke, '–')) AS faktisk,
       o.tidlig_opptak AND o.tidlig_opptak_lenke IS NOT NULL AS ok
FROM opptak_v2.opptak o WHERE o.opptak_kode = 34
UNION ALL
SELECT 'Opptak 34: søknadsfristen for tidlig opptak er ikke ute',
       coalesce((SELECT hendelse_tidspunkt::text FROM frist WHERE opptak_kode = 34), 'ingen frist'),
       coalesce((SELECT hendelse_tidspunkt > now() FROM frist WHERE opptak_kode = 34), false)
UNION ALL
SELECT 'Opptak 34: «Avvikle virksomheten» (AVVIKLE) er inaktivt',
       coalesce((SELECT 'er_aktiv=' || er_aktiv FROM opptak_v2.tidligopptak_begrunnelsetype
                 WHERE opptak_kode = 34 AND tidligopptak_begrunnelsetype_kode = 'AVVIKLE'), 'finnes ikke'),
       coalesce((SELECT NOT er_aktiv FROM opptak_v2.tidligopptak_begrunnelsetype
                 WHERE opptak_kode = 34 AND tidligopptak_begrunnelsetype_kode = 'AVVIKLE'), false)
UNION ALL
SELECT 'Opptak 34: de fire andre grunnlagene er aktive',
       (SELECT count(*) FILTER (WHERE er_aktiv) || ' av ' || count(*) || ' aktive'
          FROM opptak_v2.tidligopptak_begrunnelsetype
         WHERE opptak_kode = 34 AND tidligopptak_begrunnelsetype_kode <> 'AVVIKLE'),
       (SELECT count(*) FILTER (WHERE er_aktiv) = 4
          FROM opptak_v2.tidligopptak_begrunnelsetype
         WHERE opptak_kode = 34 AND tidligopptak_begrunnelsetype_kode <> 'AVVIKLE')
UNION ALL
-- Opptak 2
SELECT 'Opptak 2: tidlig opptak er slått på, og søknadsfristen for tidlig opptak er ute',
       format('tidlig_opptak=%s, frist=%s', o.tidlig_opptak,
              coalesce((SELECT hendelse_tidspunkt::text FROM frist WHERE opptak_kode = 2), 'ingen')),
       o.tidlig_opptak AND coalesce((SELECT hendelse_tidspunkt < now() FROM frist WHERE opptak_kode = 2), false)
FROM opptak_v2.opptak o WHERE o.opptak_kode = 2
UNION ALL
-- Testbruker 1
SELECT 'Testbruker 1 (Samtidig Sild): sendt søknad, ikke søkt, studieønsker både med og uten tidlig opptak',
       coalesce((SELECT format('søknad %s: %s (tidlig %s, ikke %s), søkt=%s', soknadsnummer, alternativer,
                               tilbyr_tidlig, tilbyr_ikke, tidligopptak_begrunnelsetype_kode IS NOT NULL)
                   FROM soknad WHERE tb = 1), 'ingen sendt søknad'),
       coalesce((SELECT tilbyr_tidlig > 0 AND tilbyr_ikke > 0 AND tidligopptak_begrunnelsetype_kode IS NULL
                   FROM soknad WHERE tb = 1), false)
UNION ALL
-- Testbruker 2
SELECT 'Testbruker 2 (Heidi Lykke): sendt søknad der ingen studieønsker tilbyr tidlig opptak',
       coalesce((SELECT format('søknad %s: %s (tidlig %s, ikke %s)', soknadsnummer, alternativer,
                               tilbyr_tidlig, tilbyr_ikke)
                   FROM soknad WHERE tb = 2), 'ingen sendt søknad'),
       coalesce((SELECT tilbyr_tidlig = 0 AND tilbyr_ikke > 0 FROM soknad WHERE tb = 2), false)
UNION ALL
-- Testbruker 3: soker er tom når personen ikke er søker ennå, og da er sjekken også ok.
-- Kladden blir liggende når studieønsket fjernes, men uten studieønsker vises den ikke i Min kompetanse.
SELECT 'Testbruker 3 (Frisk Frosk): ingen søknad i opptak 34, heller ikke en som ikke er sendt',
       format('kladd=%s, studieønsker=%s, sendt=%s',
              EXISTS (SELECT 1 FROM soker so JOIN soknad_v2.soknadskladd k
                        ON k.soker_id = so.soker_id AND k.opptak_kode = so.opptak_kode WHERE so.tb = 3),
              (SELECT count(*) FROM soker so JOIN soknad_v2.soknadsalternativ a
                 ON a.soker_id = so.soker_id AND a.opptak_kode = so.opptak_kode
                WHERE so.tb = 3 AND a.slettet IS NULL),
              EXISTS (SELECT 1 FROM soknad WHERE tb = 3)),
       NOT EXISTS (SELECT 1 FROM soker so JOIN soknad_v2.soknadsalternativ a
                     ON a.soker_id = so.soker_id AND a.opptak_kode = so.opptak_kode
                    WHERE so.tb = 3 AND a.slettet IS NULL)
       AND NOT EXISTS (SELECT 1 FROM soknad WHERE tb = 3)
UNION ALL
-- Testbruker 4
SELECT 'Testbruker 4 (Ullen Bikkje): sendt søknad i opptak 2, ikke søkt, minst ett studieønske med tidlig opptak',
       coalesce((SELECT format('søknad %s: %s (tidlig %s), søkt=%s', soknadsnummer, alternativer,
                               tilbyr_tidlig, tidligopptak_begrunnelsetype_kode IS NOT NULL)
                   FROM soknad WHERE tb = 4), 'ingen sendt søknad'),
       coalesce((SELECT tilbyr_tidlig > 0 AND tidligopptak_begrunnelsetype_kode IS NULL
                   FROM soknad WHERE tb = 4), false);
