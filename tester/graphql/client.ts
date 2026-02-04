import type { APIRequestContext } from '@playwright/test';
import type {
  Opptak,
  OpprettOpptakInput,
  OpprettOpptakPayloadV2,
  OpptakFilterInput,
  AdmissioUtdanningsinstans,
  PersonProfil,
  QueryPersonProfilerFilterInput,
  OpprettUtdanningstilbudInput,
  OppdaterUtdanningstilbudV2Payload,
  OppdaterUtdanningstilbudV2Input,
} from './types';

if (!process.env.FS_ADMIN_GRAPHQL) {
  throw new Error('FS_ADMIN_GRAPHQL environment variable is required');
}
const FS_ADMIN_GRAPHQL = process.env.FS_ADMIN_GRAPHQL.trim();

// Generic GraphQL request helper
interface GraphQLResponse<T> {
  data?: T;
  errors?: Array<{ message: string; extensions?: Record<string, unknown> }>;
}

async function graphqlRequest<T>(
  request: APIRequestContext,
  query: string,
  variables?: Record<string, unknown>
): Promise<GraphQLResponse<T>> {
  const response = await request.post(FS_ADMIN_GRAPHQL, {
    headers: { 'Content-Type': 'application/json' },
    data: { query, variables },
  });
  return response.json();
}

// ============================================================
// Opptak Mutations
// ============================================================

export async function opprettOpptak(
  request: APIRequestContext,
  input: OpprettOpptakInput
): Promise<OpprettOpptakPayloadV2> {
  const response = await graphqlRequest<{ opprettOpptakV2: OpprettOpptakPayloadV2 }>(
    request,
    /* GraphQL */ `
      mutation OpprettOpptak($input: OpprettOpptakInput!) {
        opprettOpptakV2(input: $input) {
          errors {
            __typename
            ... on IkkeAutorisertError {
              message
            }
            ... on ManglerOpptakshendelser {
              message
            }
          }
          opptak {
            id
            navn
            status
            opprettetTidspunkt
            maksAntallUtdanningstilbud
            organisasjon {
              id
              navn { nb nn en }
            }
            type {
              id
              kode
              navn { nb nn en }
            }
            hendelser {
              id
              hendelseTidspunkt
              type { kode navn }
            }
            runder {
              id
              navn
              opptaksrundetype { id kode navn }
            }
          }
        }
      }
    `,
    { input }
  );

  if (response.errors?.length) {
    throw new Error(`GraphQL errors: ${response.errors.map(e => e.message).join(', ')}`);
  }

  return response.data!.opprettOpptakV2;
}

export async function opprettUtdanningstilbud(
  request: APIRequestContext,
  input: OpprettUtdanningstilbudInput
): Promise<OppdaterUtdanningstilbudV2Payload> {
  const response = await graphqlRequest<{ opprettUtdanningstilbudV2: OppdaterUtdanningstilbudV2Payload }>(
    request,
    /* GraphQL */ `
      mutation OpprettUtdanningstilbud($input: OpprettUtdanningstilbudInput!) {
        opprettUtdanningstilbudV2(input: $input) {
          errors {
            ... on Error {
              message
              __typename
            }
            __typename
          }
          utdanningstilbud {
            id
            __typename
          }
          __typename
        }
      }
    `,
    { input }
  );

  if (response.errors?.length) {
    throw new Error(`GraphQL errors: ${response.errors.map(e => e.message).join(', ')}`);
  }

  return response.data!.opprettUtdanningstilbudV2;
}

export async function oppdaterUtdanningstilbud(
  request: APIRequestContext,
  input: OppdaterUtdanningstilbudV2Input
): Promise<OppdaterUtdanningstilbudV2Payload> {
  const response = await graphqlRequest<{ oppdaterUtdanningstilbudV2: OppdaterUtdanningstilbudV2Payload }>(
    request,
    /* GraphQL */ `
      mutation updateUtdanningstilbudDetails($input: OppdaterUtdanningstilbudV2Input!) {
        oppdaterUtdanningstilbudV2(input: $input) {
          errors {
            ... on Error {
              message
              __typename
            }
            __typename
          }
          utdanningstilbud {
            id
            __typename
          }
          __typename
        }
      }
    `,
    { input }
  );

  if (response.errors?.length) {
    throw new Error(`GraphQL errors: ${response.errors.map(e => e.message).join(', ')}`);
  }

  return response.data!.oppdaterUtdanningstilbudV2;
}

// ============================================================
// Opptak Queries
// ============================================================

export async function hentOpptak(
  request: APIRequestContext,
  filter?: OpptakFilterInput
): Promise<Opptak[]> {
  const response = await graphqlRequest<{ opptak: Opptak[] }>(
    request,
    /* GraphQL */ `
      query HentOpptak($filter: OpptakFilterInput) {
        opptak(filter: $filter) {
          id
          navn
          status
          opprettetTidspunkt
          endretTidspunkt
          maksAntallUtdanningstilbud
          organisasjon {
            id
            navn { nb nn en }
          }
          type {
            id
            kode
            navn { nb nn en }
          }
          hendelser {
            id
            hendelseTidspunkt
            type { kode navn }
          }
          runder {
            id
            navn
            opptaksrundetype { id kode navn }
          }
        }
      }
    `,
    { filter }
  );

  if (response.errors?.length) {
    throw new Error(`GraphQL errors: ${response.errors.map(e => e.message).join(', ')}`);
  }

  return response.data!.opptak;
}

export async function hentOpptakById(
  request: APIRequestContext,
  id: string
): Promise<Opptak | undefined> {
  const opptak = await hentOpptak(request, { opptaksIDer: [id] });
  return opptak[0];
}

// ============================================================
// Utdanningsinstans Queries
// ============================================================

export async function hentUtdanningsinstanser(
  request: APIRequestContext
): Promise<AdmissioUtdanningsinstans[]> {
  const response = await graphqlRequest<{ admissioUtdanningsinstanser: AdmissioUtdanningsinstans[] }>(
    request,
    /* GraphQL */ `
      query HentUtdanningsinstanser {
        admissioUtdanningsinstanser {
          id
          organisasjon {
            navn {
              nb
            }
          }
          utdanningsmulighet {
            navn {
              nb
              nn
              en
            }
          }
          terminFra {
            arstall
          }
          terminTil {
            arstall
          }
        }
      }
    `
  );

  if (response.errors?.length) {
    throw new Error(`GraphQL errors: ${response.errors.map(e => e.message).join(', ')}`);
  }

  return response.data!.admissioUtdanningsinstanser;
}

// ============================================================
// Person Search Queries
// ============================================================

export async function sokPersoner(
  request: APIRequestContext,
  filter: QueryPersonProfilerFilterInput
): Promise<PersonProfil[]> {
  const response = await graphqlRequest<{
    personProfiler: { edges: Array<{ node: PersonProfil }> };
  }>(
    request,
    /* GraphQL */ `
      query SokPersoner($filter: QueryPersonProfilerFilterInput!) {
        personProfiler(filter: $filter) {
          edges {
            node {
              id
              fodselsnummer
              fodselsdato
              navn {
                fornavn
                etternavn
              }
              feideBruker
              student {
                studentnummer
              }
            }
          }
        }
      }
    `,
    { filter }
  );

  if (response.errors?.length) {
    throw new Error(`GraphQL errors: ${response.errors.map(e => e.message).join(', ')}`);
  }

  return response.data!.personProfiler.edges.map(e => e.node);
}
