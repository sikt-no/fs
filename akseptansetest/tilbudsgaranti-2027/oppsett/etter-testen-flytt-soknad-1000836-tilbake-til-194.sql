-- Flytter søknadsalternativene i søknad 1000836 i opptak 34 (Overbevisende Havhest) tilbake fra
-- 20827 til 194, så søknaden kan brukes i den interne akseptansetesten av tilbudsgaranti igjen,
-- også i 1.18, som skal utløse flyttingen til 20827 selv.
-- Kjøres som superbruker: tabellene har RLS. Kjør «Før» først, og se at det stemmer med det som står under.
--
-- Hva som skjedde 2026-10-26: unntaket ORD + UTLAND → 20827 ble lagt inn mens søknaden hadde overstyrt
-- utdanningsbakgrunn UTLAND. En søknadshendelse kl. 14:58:28 fikk tildelingsjobben til å flytte alle
-- 10 søknadsalternativene fra 194 til 20827 (14:58:32), og saken hos 194 ble deaktivert. Overstyringen
-- ble fjernet i FS Admin kl. 15:18:21, men NORSK har omfordel_b_rolle = false, så jobben flytter ikke tilbake.
--
-- Skriptet gjør det BehandlertildelingService.flyttBehandlere gjør, baklengs:
--   1. raden i saksbehandling.sak_soknadsalternativ slettes hos 20827 og legges inn igjen hos 194,
--      med de samme tilbudsgarantiene og tid_registrert (tilbudsgarantien følger søknadsalternativet)
--   2. saken hos 194 blir aktiv igjen, og saken hos 20827 blir inaktiv (saker slettes aldri)
--   3. det lagrede valget for regelen ORD i soknad_v2.soknad_behandlertildeling settes til 194,
--      hvis det står 20827 der, så en ny tildeling ikke velger 20827 igjen
-- Endringsloggen får de samme radene som ved en vanlig flytting, med en intensjon som sier at det er testdata.
-- Det registreres ingen søknadshendelse: en ny tildeling er ikke ønsket.
--
-- Forutsetter at overstyringen er fjernet (ingen rad i saksbehandling.sak_soknad). Står det fortsatt
-- UTLAND der, flytter neste tildeling alt til 20827 igjen.

-- Før ------------------------------------------------------------------------------------------

-- Overstyringen (ventet: ingen rad)
SELECT ss.*
  FROM saksbehandling.sak_soknad ss
  JOIN soknad_v2.soknad s ON s.soker_id = ss.soker_id AND s.opptak_kode = ss.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836';

-- Søknadsalternativene og tilbudsgarantiene (ventet: 10 rader hos 20827)
SELECT ssa.utdanningstilbudsnr, ssa.organisasjonskode_behandler,
       ssa.tilbudsgarantitype_kode_fra_behandler, ssa.tilbudsgarantitype_kode_fra_tilbyder,
       ssa.tilbudsgarantitype_kode_fra_forvalter
  FROM saksbehandling.sak_soknadsalternativ ssa
  JOIN soknad_v2.soknad s ON s.soker_id = ssa.soker_id AND s.opptak_kode = ssa.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
 ORDER BY 1;

-- Sakene (ventet: 194 inaktiv, 20827 aktiv)
SELECT sak.organisasjonskode, sak.saksnummer, sak.er_aktiv
  FROM saksbehandling.sak sak
  JOIN soknad_v2.soknad s ON s.soker_id = sak.soker_id AND s.opptak_kode = sak.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
 ORDER BY 1;

-- Det lagrede valget per regel
SELECT sb.*
  FROM soknad_v2.soknad_behandlertildeling sb
  JOIN soknad_v2.soknad s ON s.soker_id = sb.soker_id AND s.opptak_kode = sb.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836';

-- Flyttingen ---------------------------------------------------------------------------------

BEGIN;

CREATE TEMP TABLE flytt_tilbake ON COMMIT DROP AS
SELECT ssa.*
  FROM saksbehandling.sak_soknadsalternativ ssa
  JOIN soknad_v2.soknad s ON s.soker_id = ssa.soker_id AND s.opptak_kode = ssa.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
   AND ssa.organisasjonskode_behandler = '20827';

-- Konteksten endringsloggen leser, satt for den avgivende saken (20827)
SELECT set_config('saksbehandling.intensjon',
                  'Søknadsalternativ flyttet til behandler [194] (testdata for akseptansetest)', true),
       set_config('saksbehandling.saksbehandler_ident', 'fs-opptak-automatikk', true),
       set_config('saksbehandling.sak_soker_id', s.soker_id::text, true),
       set_config('saksbehandling.sak_opptak_kode', s.opptak_kode::text, true),
       set_config('saksbehandling.sak_organisasjonskode', '20827', true)
  FROM soknad_v2.soknad s
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836';

DELETE FROM saksbehandling.sak_soknadsalternativ ssa
 USING flytt_tilbake f
 WHERE ssa.soker_id = f.soker_id
   AND ssa.opptak_kode = f.opptak_kode
   AND ssa.utdanningstilbudsnr = f.utdanningstilbudsnr;

-- Konteksten for den mottakende saken (194)
SELECT set_config('saksbehandling.intensjon',
                  'Søknadsalternativ flyttet fra behandler [20827] (testdata for akseptansetest)', true),
       set_config('saksbehandling.sak_organisasjonskode', '194', true);

INSERT INTO saksbehandling.sak_soknadsalternativ
    (soker_id, opptak_kode, utdanningstilbudsnr, organisasjonskode_behandler,
     tilbudsgarantitype_kode_fra_behandler, tilbudsgarantitype_kode_fra_forvalter,
     tilbudsgarantitype_kode_fra_tilbyder, tid_registrert, tid_oppdatert)
SELECT soker_id, opptak_kode, utdanningstilbudsnr, '194',
       tilbudsgarantitype_kode_fra_behandler, tilbudsgarantitype_kode_fra_forvalter,
       tilbudsgarantitype_kode_fra_tilbyder, tid_registrert, now()
  FROM flytt_tilbake;

-- Saken hos 194 aktiveres igjen
SELECT set_config('saksbehandling.intensjon',
                  'Sak gjenåpnet med nytt søknadsalternativ (testdata for akseptansetest)', true);

UPDATE saksbehandling.sak sak
   SET er_aktiv = true, tid_oppdatert = now()
  FROM soknad_v2.soknad s
 WHERE s.soker_id = sak.soker_id AND s.opptak_kode = sak.opptak_kode
   AND s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
   AND sak.organisasjonskode = '194'
   AND sak.er_aktiv = false;

-- Saken hos 20827 deaktiveres
SELECT set_config('saksbehandling.intensjon',
                  'Sak deaktivert uten søknadsalternativer (testdata for akseptansetest)', true),
       set_config('saksbehandling.sak_organisasjonskode', '20827', true);

UPDATE saksbehandling.sak sak
   SET er_aktiv = false, tid_oppdatert = now()
  FROM soknad_v2.soknad s
 WHERE s.soker_id = sak.soker_id AND s.opptak_kode = sak.opptak_kode
   AND s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
   AND sak.organisasjonskode = '20827'
   AND sak.er_aktiv = true
   AND NOT EXISTS (SELECT 1 FROM saksbehandling.sak_soknadsalternativ ssa
                    WHERE ssa.soker_id = sak.soker_id AND ssa.opptak_kode = sak.opptak_kode
                      AND ssa.organisasjonskode_behandler = '20827');

-- Det lagrede valget for regelen ORD, hvis tildelingen har satt det til 20827
UPDATE soknad_v2.soknad_behandlertildeling sb
   SET organisasjonskode_behandler = '194'
  FROM soknad_v2.soknad s
 WHERE s.soker_id = sb.soker_id AND s.opptak_kode = sb.opptak_kode
   AND s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
   AND sb.behandlertildelingsregel_kode = 'ORD'
   AND sb.organisasjonskode_behandler = '20827';

COMMIT;

-- Etter ----------------------------------------------------------------------------------------

-- Ventet: 10 rader hos 194, med de samme tilbudsgarantiene som før
SELECT ssa.utdanningstilbudsnr, ssa.organisasjonskode_behandler,
       ssa.tilbudsgarantitype_kode_fra_behandler, ssa.tilbudsgarantitype_kode_fra_tilbyder,
       ssa.tilbudsgarantitype_kode_fra_forvalter
  FROM saksbehandling.sak_soknadsalternativ ssa
  JOIN soknad_v2.soknad s ON s.soker_id = ssa.soker_id AND s.opptak_kode = ssa.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
 ORDER BY 1;

-- Ventet: 194 aktiv, 20827 inaktiv
SELECT sak.organisasjonskode, sak.saksnummer, sak.er_aktiv
  FROM saksbehandling.sak sak
  JOIN soknad_v2.soknad s ON s.soker_id = sak.soker_id AND s.opptak_kode = sak.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836'
 ORDER BY 1;

-- Ventet: ORD → 194 (eller ingen rad, hvis det ikke fantes noen før)
SELECT sb.*
  FROM soknad_v2.soknad_behandlertildeling sb
  JOIN soknad_v2.soknad s ON s.soker_id = sb.soker_id AND s.opptak_kode = sb.opptak_kode
 WHERE s.opptak_kode = 34 AND s.soknadsnummer = '1000836';
