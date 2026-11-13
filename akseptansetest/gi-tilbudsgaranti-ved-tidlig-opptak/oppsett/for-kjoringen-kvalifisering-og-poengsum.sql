-- UTKAST (2026-11-09). Setter kvalifiseringen og poengsummen på sakene til søkerne i fordeling-sokere.md,
-- så de er i tilstanden listene i miljøfila krever (sak-tidlig-opptak-…). Søknaden og søknaden om tidlig
-- opptak lages først i Min kompetanse: skriptet lager ikke søknader eller saker, det skriver bare det
-- poengberegningen og kvalifiseringen ellers ville skrevet fra vitnemålene.
--
-- Kjøres som superbruker (tabellene har RLS), i én transaksjon. Skrevet mot fs-plattform origin/main
-- 2026-11-09 og eksempeldataene 20261109_035001_UTC (opptak 34, regelverksamling 20827/UHGTEST2026).
--
-- Det tidligopptaket leser (TidligopptakTilbudsgarantiService):
--   kvalifisering: saksbehandling.sak_kvalifikasjonsgrunnlag.er_kvalifisert per kompetanseregelverk
--                  (ett kvalifisert grunnlag holder; alle nei = ikke kvalifisert; null eller ingen = ikke vurdert)
--   poengsum:      max(saksbehandling.sak_poengsum.poengsum) i kvoter der sak_kvote.skal_kvoteplasseres er
--                  sann, for tilbudets kompetanse- og rangeringsregelverk og et rangerbart grunnlag
-- Skriptet rører ikke saksstatusen eller konklusjonen for tidlig opptak: det gjør testene selv (Klargjøring K).
-- Radene får la_staa = true der tabellen har det, så en automatisk behandling ikke skriver over dem.
--
-- Utdanningstilbudene (opptak 34): 99 Datateknikk ingeniør (UiT, HING/RHING), 111 Elektronisk systemingeniør
-- (NTNU, HING/RHINGK), 100 Paramedisin (UiT, PREHOS/RGENS, median 47,8), 101 Medisin (UiT, MEROD/RMEROD).
-- Grunnlaget er VES (rangerbart for alle fire), og VOV som grunnlag nummer to. Kvotene er ORD (garantikvoten)
-- og ORDF.
--
-- Kjør «Før» først: alle søkerne skal ha søknad og sak i opptak 34, og ingen sak skal være behandlet.

BEGIN;

-- Søkerne og hva hver skal ha. liste = listen i miljøfila uten «sak-»-prefikset.
CREATE TEMP TABLE plan (navn text, liste text) ON COMMIT DROP;
INSERT INTO plan VALUES
  ('ØKOLOGISK BADERING','tidlig-opptak-kvalifisert'), ('GRETTEN PEDAL','tidlig-opptak-kvalifisert'),
  ('TRIST RYGG','tidlig-opptak-kvalifisert'), ('FORMBAR JUICE','tidlig-opptak-kvalifisert'),
  ('TRU KJETTING','tidlig-opptak-kvalifisert'), ('UROMANTISK PLASMA','tidlig-opptak-kvalifisert'),
  ('UFORNUFTIG GRAF','tidlig-opptak-kvalifisert'), ('MISFORNØYD SKRIVEMASKIN','tidlig-opptak-kvalifisert'),
  ('MISFORNØYD AMBASSADE','tidlig-opptak-kvalifisert'), ('AKUSTISK ELG','tidlig-opptak-kvalifisert'),
  ('VOKAL ADRESSAT','tidlig-opptak-kvalifisert'), ('OVEREKSPONERT STOKK','tidlig-opptak-kvalifisert'),
  ('FIKTIV MOTVIND','tidlig-opptak-kvalifisert'), ('UVITENDE BJØRNUNGE','tidlig-opptak-kvalifisert'),
  ('UKONTROVERSIELL ORIDÉ','tidlig-opptak-kvalifisert'), ('MUNTER JORDBÆR','tidlig-opptak-kvalifisert'),
  ('RØD NATTERGAL','tidlig-opptak-kvalifisert'), ('INNESLUTTET TURISTBY','tidlig-opptak-kvalifisert'),
  ('LATTERMILD ALTMULIGMANN','tidlig-opptak-kvalifisert'), ('KVADRATISK OPPLAG','tidlig-opptak-kvalifisert'),
  ('SPRETTEN LAKS','tidlig-opptak-kvalifisert'), ('STRAFFET TRAPP','tidlig-opptak-kvalifisert'),
  ('UKLAR ARTIKKEL','tidlig-opptak-kvalifisert'), ('UTTRYKKSFULL PORT','tidlig-opptak-kvalifisert'),
  ('VIKTIG RINGDUE','tidlig-opptak-kvalifisert'), ('KONKRET FOBI','tidlig-opptak-kvalifisert'),
  ('MYE BEHANDLING','tidlig-opptak-kvalifisert'), ('KLOK NETTHINNE','tidlig-opptak-kvalifisert'),
  ('ROBUST SKATOLL','tidlig-opptak-kvalifisert'), ('IDIOTSIKKER MATTE','tidlig-opptak-kvalifisert'),
  ('KRANGLETE ARTISJOKK','tidlig-opptak-ikke-kvalifisert'), ('SOLID SVERM','tidlig-opptak-ikke-kvalifisert'),
  ('FYLDIG REVEBJELLE','tidlig-opptak-ikke-kvalifisert'),
  ('EKSEMPLARISK BEVEGELSE','tidlig-opptak-kvalifisering-ikke-vurdert'), ('TØRST HALVKULE','tidlig-opptak-kvalifisering-ikke-vurdert'),
  ('FAMØS TUNGE','tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert'), ('SMART GLOSE','tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert'),
  ('RAVGUL KATEDRAL','tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert'), ('TOPP SAVANNE','tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert'),
  ('OPPKLARENDE FOBI','tidlig-opptak-to-kvoter'), ('TALEFØR TORSK','tidlig-opptak-to-kvoter'),
  ('OPPRETT FJELLKJEDE','tidlig-opptak-poeng-i-kvote-uten-kvoteplassering'), ('FAMILIÆR BANE','tidlig-opptak-poeng-i-kvote-uten-kvoteplassering'),
  ('LANG BUKT','tidlig-opptak-uten-poengsum'), ('OPPJAGET BAS','tidlig-opptak-uten-poengsum'), ('JUSTERBAR PRØVE','tidlig-opptak-uten-poengsum'),
  ('AKTUELL KJEPPHEST','tidlig-opptak-prioritet-1-uten-tidlig-opptak'), ('VIS SERVISE','tidlig-opptak-prioritet-1-uten-tidlig-opptak'),
  ('BETYDELIG OPSJON','uten-soknad-om-tidlig-opptak'), ('SLITEN MUNN','uten-soknad-om-tidlig-opptak'),
  ('KUNST KLISJÉ','tidlig-opptak-median-over'), ('KRANGLETE VEVSTOL','tidlig-opptak-median-over'), ('NORMAL KONJUNKSJON','tidlig-opptak-median-over'),
  ('UEMOSJONELL BETALING','tidlig-opptak-median-lik'), ('DISTINGVERT DRAGE','tidlig-opptak-median-lik'),
  ('NERVØS ROSIN','tidlig-opptak-median-under'), ('ANSTENDIG LEGE','tidlig-opptak-median-under'), ('FYSISK DELMENGDE','tidlig-opptak-median-under'),
  ('MOTVILLIG BRØKDEL','tidlig-opptak-uten-median'), ('FILOSOFISK LISTE','tidlig-opptak-uten-median');
  -- sak-tidlig-opptak-to-saker (Gild Galleri, Vertikal Branngate) trenger verken kvalifisering eller poengsum.

-- Hva hver liste gir, per utdanningstilbud:
--   grunnlag:    VES = kvalifiseringen på VES; vov = kvalifiseringen på VOV (null = ingen rad)
--   kvoter:      poengsum i ORD (skal kvoteplasseres) og ORDF (skal_ordf = om søkeren skal kvoteplasseres der)
CREATE TEMP TABLE regel (liste text, nr int, ves boolean, ves_vurdert boolean, vov boolean, vov_finnes boolean,
                         ord numeric, ordf numeric, skal_ordf boolean) ON COMMIT DROP;
INSERT INTO regel VALUES
  ('tidlig-opptak-kvalifisert',                              99, true,  true,  null,  false, 50.0, null, null),
  ('tidlig-opptak-kvalifisert',                             111, true,  true,  null,  false, 50.0, null, null),
  ('uten-soknad-om-tidlig-opptak',                           99, true,  true,  null,  false, 50.0, null, null),
  ('uten-soknad-om-tidlig-opptak',                          111, true,  true,  null,  false, 50.0, null, null),
  ('tidlig-opptak-ikke-kvalifisert',                         99, false, true,  null,  false, 50.0, null, null),
  ('tidlig-opptak-kvalifisering-ikke-vurdert',               99, null,  false, null,  false, 50.0, null, null),
  ('tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert', 99, true,  true,  false, true,  50.0, null, null),
  ('tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert',99, null,  false, false, true,  50.0, null, null),
  ('tidlig-opptak-to-kvoter',                                99, true,  true,  null,  false, 50.0, 52.0, true),
  ('tidlig-opptak-poeng-i-kvote-uten-kvoteplassering',       99, true,  true,  null,  false, 45.0, 55.0, false),
  ('tidlig-opptak-uten-poengsum',                            99, true,  true,  null,  false, null, null, null),
  ('tidlig-opptak-prioritet-1-uten-tidlig-opptak',           99, true,  true,  null,  false, 50.0, null, null),
  ('tidlig-opptak-median-over',                             100, true,  true,  null,  false, 50.0, null, null),
  ('tidlig-opptak-median-lik',                              100, true,  true,  null,  false, 47.8, null, null),
  ('tidlig-opptak-median-under',                            100, true,  true,  null,  false, 45.0, null, null),
  ('tidlig-opptak-uten-median',                             101, true,  true,  null,  false, 50.0, null, null);

-- Søkeren, saken og regelverket per rad.
CREATE TEMP TABLE mal ON COMMIT DROP AS
SELECT DISTINCT p.navn, p.liste, sk.soker_id, s.organisasjonskode AS org,
       u.regelverk_organisasjonskode AS rorg, u.regelverksamling_kode AS rs,
       u.kompetanseregelverk_kode AS komp, u.rangeringsregelverk_kode AS rang,
       r.nr, r.ves, r.ves_vurdert, r.vov, r.vov_finnes, r.ord, r.ordf, r.skal_ordf
  FROM plan p
  JOIN regel r ON r.liste = p.liste
  JOIN tilgangskontroll.person pe ON upper(pe.fornavn || ' ' || pe.etternavn) = p.navn
  JOIN soknad_v2.soker sk ON sk.person_id = pe.person_id
  JOIN opptak_v2.utdanningstilbud u ON u.opptak_kode = 34 AND u.utdanningstilbudsnr = r.nr
  JOIN saksbehandling.sak_soknadsalternativ ssa
    ON ssa.soker_id = sk.soker_id AND ssa.opptak_kode = 34 AND ssa.utdanningstilbudsnr = r.nr
  JOIN saksbehandling.sak s
    ON s.soker_id = sk.soker_id AND s.opptak_kode = 34 AND s.organisasjonskode = ssa.organisasjonskode_behandler;

-- Før: hver søker i planen, om søkeren har søknad og sak på utdanningstilbudene, og saksstatusen.
-- Alle radene skal ha ok = true. Mangler en rad, er søknaden ikke laget i Min kompetanse ennå.
SELECT p.navn, p.liste, r.nr,
       m.soker_id IS NOT NULL AS har_sak,
       (SELECT s.statustype_kode FROM saksbehandling.sak s
         WHERE s.soker_id = m.soker_id AND s.opptak_kode = 34 AND s.organisasjonskode = m.org) AS status,
       m.soker_id IS NOT NULL
       AND (SELECT s.statustype_kode FROM saksbehandling.sak s
             WHERE s.soker_id = m.soker_id AND s.opptak_kode = 34 AND s.organisasjonskode = m.org) <> 'BEHANDLET' AS ok
  FROM plan p
  JOIN regel r ON r.liste = p.liste
  LEFT JOIN mal m ON m.navn = p.navn AND m.nr = r.nr
 ORDER BY ok, p.liste, p.navn;

-- Kvalifiseringen
INSERT INTO saksbehandling.sak_kvalifikasjonsgrunnlag
  (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode,
   kompetanseregelverk_kode, grunnlag_kode, er_kvalifisert, la_staa)
SELECT DISTINCT soker_id, 34, org, rorg, rs, komp, 'VES', CASE WHEN ves_vurdert THEN ves END, true FROM mal
UNION
SELECT DISTINCT soker_id, 34, org, rorg, rs, komp, 'VOV', vov, true FROM mal WHERE vov_finnes
ON CONFLICT (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode,
             kompetanseregelverk_kode, grunnlag_kode)
DO UPDATE SET er_kvalifisert = EXCLUDED.er_kvalifisert, la_staa = true, tid_oppdatert = now();

-- Rangeringsgrunnlaget poengsummen henger på
INSERT INTO saksbehandling.sak_rangeringsgrunnlag
  (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode,
   grunnlag_kode, kompetanseregelverk_kode, rangeringsregelverk_kode)
SELECT DISTINCT soker_id, 34, org, rorg, rs, 'VES', komp, rang FROM mal WHERE ord IS NOT NULL OR ordf IS NOT NULL
ON CONFLICT DO NOTHING;

-- Kvotene: ORD skal kvoteplasseres; ORDF bare der lista har en poengsum i ORDF
INSERT INTO saksbehandling.sak_kvote
  (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode, kvotetype_kode,
   skal_kvoteplasseres, er_aktiv)
SELECT DISTINCT soker_id, 34, org, rorg, rs, 'ORD', true, true FROM mal
UNION
SELECT DISTINCT soker_id, 34, org, rorg, rs, 'ORDF', skal_ordf, true FROM mal WHERE ordf IS NOT NULL
ON CONFLICT (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode, kvotetype_kode)
DO UPDATE SET skal_kvoteplasseres = EXCLUDED.skal_kvoteplasseres, er_aktiv = true, tid_oppdatert = now();

-- Poengsummen
INSERT INTO saksbehandling.sak_poengsum
  (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode,
   grunnlag_kode, kompetanseregelverk_kode, rangeringsregelverk_kode, kvotetype_kode, poengsum)
SELECT DISTINCT soker_id, 34, org, rorg, rs, 'VES', komp, rang, 'ORD', ord FROM mal WHERE ord IS NOT NULL
UNION
SELECT DISTINCT soker_id, 34, org, rorg, rs, 'VES', komp, rang, 'ORDF', ordf FROM mal WHERE ordf IS NOT NULL
ON CONFLICT (soker_id, opptak_kode, organisasjonskode, regelverk_organisasjonskode, regelverksamling_kode,
             grunnlag_kode, kompetanseregelverk_kode, rangeringsregelverk_kode, kvotetype_kode)
DO UPDATE SET poengsum = EXCLUDED.poengsum, tid_oppdatert = now();

-- Etter: det tidligopptaket vil lese, per søker og utdanningstilbud
SELECT m.navn, m.liste, m.nr,
       (SELECT string_agg(k.grunnlag_kode || '=' || coalesce(k.er_kvalifisert::text, 'ikke vurdert'), ', ')
          FROM saksbehandling.sak_kvalifikasjonsgrunnlag k
         WHERE k.soker_id = m.soker_id AND k.opptak_kode = 34 AND k.organisasjonskode = m.org
           AND k.kompetanseregelverk_kode = m.komp) AS kvalifisering,
       (SELECT max(ps.poengsum)
          FROM saksbehandling.sak_poengsum ps
          JOIN saksbehandling.sak_kvote kv
            ON kv.soker_id = ps.soker_id AND kv.opptak_kode = ps.opptak_kode AND kv.organisasjonskode = ps.organisasjonskode
           AND kv.regelverk_organisasjonskode = ps.regelverk_organisasjonskode
           AND kv.regelverksamling_kode = ps.regelverksamling_kode AND kv.kvotetype_kode = ps.kvotetype_kode
         WHERE ps.soker_id = m.soker_id AND ps.opptak_kode = 34 AND ps.organisasjonskode = m.org
           AND ps.kompetanseregelverk_kode = m.komp AND ps.rangeringsregelverk_kode = m.rang
           AND kv.skal_kvoteplasseres IS TRUE AND kv.er_aktiv) AS poengsum_som_teller
  FROM mal m
 ORDER BY m.liste, m.navn, m.nr;

-- Se over «Før» og «Etter». Er alt riktig: COMMIT. Ellers: ROLLBACK.
-- COMMIT;
