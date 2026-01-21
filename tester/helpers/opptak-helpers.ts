import type { OpprettOpptakInput } from '../graphql/types';

/**
 * Genererer standard testdata for å opprette et opptak
 * @param navn - Opptakets navn (hvis ikke oppgitt, brukes timestamp)
 * @returns OpprettOpptakInput med alle påkrevde felter
 */
export function opprettStandardOpptakInput(navn?: string): OpprettOpptakInput {
  // Generer unikt navn hvis ikke oppgitt
  const opptakNavn = navn || `OPPTAK-TEST-${Date.now()}`;

  // Kalkuler dynamiske datoer
  const iDag = new Date();
  const toUkerFremITid = new Date(iDag);
  toUkerFremITid.setDate(iDag.getDate() + 14);

  const iDagISO = iDag.toISOString();
  const toUkerFremITidISO = toUkerFremITid.toISOString();

  return {
    navn: opptakNavn,
    opptaksstatusKode: 'PUBLISERT',
    opptakstypeKode: 'YTo1OiJMT0si', // LOK (Lokalt opptak)
    runder: [],
    hendelser: [
      {
        opptakshendelsestypeKode: 'SOKING_APNER',
        hendelseTidspunkt: iDagISO,
      },
      {
        opptakshendelsestypeKode: 'FRIST_VURDERINGSGRUNNLAG',
        hendelseTidspunkt: iDagISO,
      },
      {
        opptakshendelsestypeKode: 'FRIST_REALKOMPETANSE',
        hendelseTidspunkt: iDagISO,
      },
      {
        opptakshendelsestypeKode: 'PUBLISERING_RESULTAT',
        hendelseTidspunkt: iDagISO,
      },
      {
        opptakshendelsestypeKode: 'PUBLISERING_OPPTAK',
        hendelseTidspunkt: iDagISO,
      },
      {
        opptakshendelsestypeKode: 'FRIST_OMPRIORITERING',
        hendelseTidspunkt: toUkerFremITidISO,
      },
      {
        opptakshendelsestypeKode: 'FRIST_ETTERSENDING',
        hendelseTidspunkt: toUkerFremITidISO,
      },
      {
        opptakshendelsestypeKode: 'SOKNADSFRIST_ORDINAER',
        hendelseTidspunkt: toUkerFremITidISO,
      },
      {
        opptakshendelsestypeKode: 'FRIST_ORDINAER_OPPLASTING',
        hendelseTidspunkt: toUkerFremITidISO,
      },
    ],
  };
}
