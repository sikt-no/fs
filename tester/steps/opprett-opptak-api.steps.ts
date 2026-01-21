import { createBdd } from 'playwright-bdd';
import { test, expect } from '../fixtures/logged-in-states';
import { opprettOpptak } from '../graphql/client';
import { opprettStandardOpptakInput } from '../helpers/opptak-helpers';
import type { OpprettOpptakInput, OpprettOpptakPayloadV2 } from '../graphql/types';

const { When, Then } = createBdd(test);

// Store the response and input for assertions
let opptakResponse: OpprettOpptakPayloadV2;
let opptakInput: OpprettOpptakInput;

When('jeg oppretter et opptak via API', async ({ adminPage }) => {
  // Hent request context fra adminPage (har auth-cookies fra innlogging)
  const request = adminPage.request;

  // Generer standard testdata
  opptakInput = opprettStandardOpptakInput();

  // Kall mutation ved hjelp av client-helperen
  // Auth kommer fra adminPage's session cookies (overstyrt bruker valgt ved innlogging)
  opptakResponse = await opprettOpptak(request, opptakInput);
});

Then('skal opptaket være opprettet uten feil', async () => {
  expect(opptakResponse.errors).toHaveLength(0);
});

Then('opptaket skal ha en gyldig ID', async () => {
  const opptak = opptakResponse.opptak!;

  // Verifiser ID-struktur (base64-encoded format)
  expect(opptak.id).toMatch(/^[A-Za-z0-9+/]+=*$/);
  expect(opptak.id.length).toBeGreaterThan(10);

  // Verifiser nøyaktig at navnet matcher
  expect(opptak.navn).toBe(opptakInput.navn);

  // Verifiser nøyaktig at status matcher
  expect(opptak.status).toBe(opptakInput.opptaksstatusKode);

  // Verifiser at opprettetTidspunkt er satt og er nylig (innenfor siste 5 minutter)
  const opprettetTid = new Date(opptak.opprettetTidspunkt);
  const nå = new Date();
  const differanseMs = Math.abs(nå.getTime() - opprettetTid.getTime());
  expect(differanseMs).toBeLessThan(5 * 60 * 1000); // Innenfor 5 minutter (tolererer klokkeavvik)

  // Verifiser opptakstype
  expect(opptak.type?.kode).toBe('LOK');
  expect(opptak.type?.id).toBe(opptakInput.opptakstypeKode);

  // Verifiser at organisasjon er satt
  expect(opptak.organisasjon?.id).toBeDefined();
  expect(opptak.organisasjon?.navn?.nb).toBeDefined();

  // Verifiser maksAntallUtdanningstilbud har en fornuftig verdi
  expect(opptak.maksAntallUtdanningstilbud).toBeGreaterThan(0);
});

Then('opptaket skal ha alle opprettede hendelser', async () => {
  const opptak = opptakResponse.opptak;
  expect(opptak).toBeDefined();

  const hendelser = opptak!.hendelser;
  expect(hendelser).toBeDefined();

  // Verifiser at vi fikk NØYAKTIG samme antall hendelser som vi sendte inn
  expect(hendelser!.length).toBe(opptakInput.hendelser.length);

  // Bygg en map av forventede hendelser for enkel oppslag
  const forventedeHendelserMap = new Map(
    opptakInput.hendelser.map(h => [h.opptakshendelsestypeKode, h.hendelseTidspunkt])
  );

  // Verifiser at alle hendelsestyper finnes i responsen med riktig data
  const mottattHendelsestyper = hendelser!.map(h => h.type?.kode);

  for (const [forventetKode, forventetTidspunkt] of forventedeHendelserMap) {
    // Sjekk at hendelsestypen finnes
    expect(mottattHendelsestyper).toContain(forventetKode);

    // Finn den spesifikke hendelsen
    const hendelse = hendelser!.find(h => h.type?.kode === forventetKode);
    expect(hendelse).toBeDefined();

    // Verifiser ID-format (base64)
    expect(hendelse!.id).toMatch(/^[A-Za-z0-9+/]+=*$/);
    expect(hendelse!.id.length).toBeGreaterThan(20);

    // Verifiser at tidspunktet matcher det vi sendte (ignorer millisekunder)
    const forventetDato = new Date(forventetTidspunkt);
    const mottattDato = new Date(hendelse!.hendelseTidspunkt);

    // Sammenlign dato uten millisekunder (API kan runde av)
    expect(Math.abs(mottattDato.getTime() - forventetDato.getTime())).toBeLessThan(1000);

    // Verifiser at type har navn
    expect(hendelse!.type?.navn).toBeDefined();
    expect(hendelse!.type?.navn).toBeTruthy();
  }

  // Verifiser at det ikke er noen ekstra hendelser (samme antall unike som input)
  expect(new Set(mottattHendelsestyper).size).toBe(opptakInput.hendelser.length);
});
