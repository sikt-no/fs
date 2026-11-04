-- Sjekker testdataene for den eksterne akseptansetesten av tidlig opptak og tilbudsgaranti.
-- Bare lesing. Kjøres som superbruker (tabellene har RLS). Gir én tabell, med én rad per sjekk:
-- ok = true når tilstanden er som den skal.
-- Skrevet mot fs-plattform origin/main 2026-11-03.
--
-- Før testen skal alle radene være ok, og alle søkerne «ikke brukt».
-- Under og etter testen viser søkerradene hvor langt hver søker har kommet, og hvem som behandler saken.

WITH
sokere (navn, fnr) AS (
  VALUES ('ØKOLOGISK BADERING', '22820998719'), ('GRETTEN PEDAL', '15841298656'),
         ('TRIST RYGG', '21921199411'), ('FORMBAR JUICE', '16870999619'),
         ('TRU KJETTING', '04811199368'), ('UROMANTISK PLASMA', '21891499547'),
         ('UFORNUFTIG GRAF', '04919097138'), ('AKUSTISK ELG', '17880999990'),
         ('VOKAL ADRESSAT', '23908596919'), ('OVEREKSPONERT STOKK', '04901298462'),
         ('FIKTIV MOTVIND', '03911098481'), ('UVITENDE BJØRNUNGE', '25811398082'),
         ('MUNTER JORDBÆR', '12811398266'), ('RØD NATTERGAL', '03840998958')
),
-- «Velg testsøker» i Min kompetanse viser de første 999 personene (antatt rekkefølge: person_id).
valgbar AS (
  SELECT p.person_id, row_number() OVER (ORDER BY p.person_id) AS nr_i_lista
    FROM tilgangskontroll.person p
),
soker AS (
  SELECT s.navn, s.fnr, pi.person_id, v.nr_i_lista, sk.soker_id
    FROM sokere s
    LEFT JOIN tilgangskontroll.personidentifikasjon pi
      ON pi.identifikator = s.fnr AND pi.personidentifikasjon_type_kode = 'FØDSELSNUMMER'
    LEFT JOIN valgbar v ON v.person_id = pi.person_id
    LEFT JOIN soknad_v2.soker sk ON sk.person_id = pi.person_id
),
soknad AS (
  SELECT so.navn, s.soknadsnummer, s.tidligopptak_begrunnelsetype_kode,
         string_agg(a.prioritet || '. ' || u.studieprogram_navn, ', ' ORDER BY a.prioritet) AS studieonsker
    FROM soker so
    JOIN soknad_v2.soknad s ON s.soker_id = so.soker_id AND s.opptak_kode = 34
    LEFT JOIN soknad_v2.soknadsalternativ a
      ON a.soker_id = s.soker_id AND a.opptak_kode = s.opptak_kode AND a.slettet IS NULL
    LEFT JOIN opptak_v2.utdanningstilbud u
      ON u.opptak_kode = a.opptak_kode AND u.utdanningstilbudsnr = a.utdanningstilbudsnr
   GROUP BY so.navn, s.soknadsnummer, s.tidligopptak_begrunnelsetype_kode
),
behandler AS (
  SELECT so.navn, string_agg(DISTINCT ssa.organisasjonskode_behandler::text, ', ') AS organisasjoner
    FROM soker so
    JOIN saksbehandling.sak_soknadsalternativ ssa ON ssa.soker_id = so.soker_id AND ssa.opptak_kode = 34
   GROUP BY so.navn
),
frist AS (
  SELECT opptakshendelsestype_kode, hendelse_tidspunkt
    FROM opptak_v2.opptakshendelse
   WHERE opptak_kode = 34
),
tilbud (navn, organisasjonskode, tidlig) AS (
  VALUES ('Automasjon, ingeniør - bachelor (ordinær, y-vei)', '186', true),       -- UiT
         ('Elektronisk systemingeniør - bachelor i ingeniørfag', '194', true),    -- NTNU
         ('Bachelor i ingeniørfag, allmenn maskinteknikk', '203', false)          -- HVL
)
-- Opptaket
SELECT 'Opptak 34: tidlig opptak er slått på, og lenken er satt' AS sjekk,
       format('tidlig_opptak=%s, lenke=%s', o.tidlig_opptak, coalesce(o.tidlig_opptak_lenke, '–')) AS faktisk,
       o.tidlig_opptak AND o.tidlig_opptak_lenke IS NOT NULL AS ok
  FROM opptak_v2.opptak o WHERE o.opptak_kode = 34
UNION ALL
SELECT 'Opptak 34: søknadsfristen for tidlig opptak og den ordinære fristen er ikke ute',
       (SELECT string_agg(opptakshendelsestype_kode || ' ' || hendelse_tidspunkt::date, ', ') FROM frist
         WHERE opptakshendelsestype_kode IN ('SØKNADSFRIST_TIDLIG_OPPTAK', 'SØKNADSFRIST_ORDINÆR')),
       (SELECT count(*) = 2 AND bool_and(hendelse_tidspunkt > now()) FROM frist
         WHERE opptakshendelsestype_kode IN ('SØKNADSFRIST_TIDLIG_OPPTAK', 'SØKNADSFRIST_ORDINÆR'))
UNION ALL
-- Grunnlaget søkeren velger i 1b («Jeg er i jobb og har oppsigelsestid, eller må søke permisjon»).
-- Den teksten er det søkeren ser, ikke navnet på grunnlaget, så sjekken bruker koden.
SELECT 'Opptak 34: grunnlaget søkeren velger i 1b (I_JOBB) er aktivt',
       coalesce((SELECT string_agg(b.tidligopptak_begrunnelsetype_kode || ' aktiv=' || b.er_aktiv
                                   || coalesce(' «' || s.navn || '»', ''), ', ')
          FROM opptak_v2.tidligopptak_begrunnelsetype b
          LEFT JOIN opptak_v2.tidligopptak_begrunnelsetype_sprak s
            ON s.opptak_kode = b.opptak_kode
           AND s.tidligopptak_begrunnelsetype_kode = b.tidligopptak_begrunnelsetype_kode
           AND s.sprakkode IN ('nb', 'nob')
         WHERE b.opptak_kode = 34 AND b.tidligopptak_begrunnelsetype_kode = 'I_JOBB'), 'finnes ikke'),
       coalesce((SELECT bool_or(b.er_aktiv)
          FROM opptak_v2.tidligopptak_begrunnelsetype b
         WHERE b.opptak_kode = 34 AND b.tidligopptak_begrunnelsetype_kode = 'I_JOBB'), false)
UNION ALL
SELECT 'Opptak 34: konklusjonen «Kan få tidligopptak, har godkjent grunn.» er aktiv (2c)',
       (SELECT string_agg(k.tidligopptak_konklusjon_kode || ' aktiv=' || k.er_aktiv, ', ')
          FROM opptak_v2.tidligopptak_konklusjon k
          JOIN opptak_v2.tidligopptak_konklusjon_sprak s
            ON s.opptak_kode = k.opptak_kode AND s.tidligopptak_konklusjon_kode = k.tidligopptak_konklusjon_kode
         WHERE k.opptak_kode = 34 AND s.navn = 'Kan få tidligopptak, har godkjent grunn.'),
       coalesce((SELECT bool_or(k.er_aktiv)
          FROM opptak_v2.tidligopptak_konklusjon k
          JOIN opptak_v2.tidligopptak_konklusjon_sprak s
            ON s.opptak_kode = k.opptak_kode AND s.tidligopptak_konklusjon_kode = k.tidligopptak_konklusjon_kode
         WHERE k.opptak_kode = 34 AND s.navn = 'Kan få tidligopptak, har godkjent grunn.'), false)
UNION ALL
SELECT 'Opptak 34: «Tilbudsgaranti etter ny vurdering» kan brukes av saksbehandler (3a)',
       (SELECT string_agg(t.tilbudsgarantitype_kode || ' aktiv=' || t.er_aktiv || ' behandler=' || t.kan_brukes_av_behandler, ', ')
          FROM opptak_v2.tilbudsgarantitype t
          JOIN opptak_v2.tilbudsgarantitype_sprak s
            ON s.opptak_kode = t.opptak_kode AND s.tilbudsgarantitype_kode = t.tilbudsgarantitype_kode
         WHERE t.opptak_kode = 34 AND s.navn = 'Tilbudsgaranti etter ny vurdering'),
       coalesce((SELECT bool_or(t.er_aktiv AND t.kan_brukes_av_behandler)
          FROM opptak_v2.tilbudsgarantitype t
          JOIN opptak_v2.tilbudsgarantitype_sprak s
            ON s.opptak_kode = t.opptak_kode AND s.tilbudsgarantitype_kode = t.tilbudsgarantitype_kode
         WHERE t.opptak_kode = 34 AND s.navn = 'Tilbudsgaranti etter ny vurdering'), false)
UNION ALL
SELECT 'Opptak 34: «Tilbudsgaranti, forhåndsløfte» kan brukes av opptaksforvalter (3b)',
       (SELECT string_agg(t.tilbudsgarantitype_kode || ' aktiv=' || t.er_aktiv || ' forvalter=' || t.kan_brukes_av_forvalter, ', ')
          FROM opptak_v2.tilbudsgarantitype t
          JOIN opptak_v2.tilbudsgarantitype_sprak s
            ON s.opptak_kode = t.opptak_kode AND s.tilbudsgarantitype_kode = t.tilbudsgarantitype_kode
         WHERE t.opptak_kode = 34 AND s.navn = 'Tilbudsgaranti, forhåndsløfte'),
       coalesce((SELECT bool_or(t.er_aktiv AND t.kan_brukes_av_forvalter)
          FROM opptak_v2.tilbudsgarantitype t
          JOIN opptak_v2.tilbudsgarantitype_sprak s
            ON s.opptak_kode = t.opptak_kode AND s.tilbudsgarantitype_kode = t.tilbudsgarantitype_kode
         WHERE t.opptak_kode = 34 AND s.navn = 'Tilbudsgaranti, forhåndsløfte'), false)
UNION ALL
-- Studiene
SELECT 'Opptak 34: «' || t.navn || '» finnes én gang, ' || CASE WHEN t.tidlig THEN 'tilbyr' ELSE 'tilbyr ikke' END || ' tidlig opptak',
       coalesce((SELECT string_agg(format('nr %s, tidlig=%s', u.utdanningstilbudsnr, u.tilbyr_tidlig_opptak), '; ')
                   FROM opptak_v2.utdanningstilbud u
                  WHERE u.opptak_kode = 34 AND NOT u.er_kansellert
                    AND u.studieprogram_navn = t.navn AND u.organisasjonskode::text = t.organisasjonskode), 'finnes ikke'),
       (SELECT count(*) = 1 AND bool_and(u.tilbyr_tidlig_opptak = t.tidlig)
          FROM opptak_v2.utdanningstilbud u
         WHERE u.opptak_kode = 34 AND NOT u.er_kansellert
           AND u.studieprogram_navn = t.navn AND u.organisasjonskode::text = t.organisasjonskode)
  FROM tilbud t
UNION ALL
-- Søkerne: før testen «ikke brukt». Etter testcase 0 skal saken behandles av UiT (186).
SELECT 'Søker ' || so.navn,
       CASE
         WHEN so.person_id IS NULL THEN 'finnes ikke'
         WHEN so.nr_i_lista > 999 THEN format('nr %s i lista, vises ikke i «Velg testsøker»', so.nr_i_lista)
         WHEN s.soknadsnummer IS NULL THEN 'ikke brukt'
         ELSE format('søknad %s: %s · søkt tidlig opptak=%s · behandles av %s',
                     s.soknadsnummer, coalesce(s.studieonsker, 'ingen studieønsker'),
                     s.tidligopptak_begrunnelsetype_kode IS NOT NULL, coalesce(b.organisasjoner, 'ingen sak'))
       END,
       so.person_id IS NOT NULL AND so.nr_i_lista <= 999
       AND (s.soknadsnummer IS NULL OR b.organisasjoner = '186')
  FROM soker so
  LEFT JOIN soknad s ON s.navn = so.navn
  LEFT JOIN behandler b ON b.navn = so.navn;
