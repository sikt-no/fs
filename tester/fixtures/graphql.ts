import { APIRequestContext } from '@playwright/test';

const GRAPHQL_ENDPOINT = process.env.GRAPHQL_ENDPOINT || 'https://supergraf-gateway-test.fsweb.no/graphql';

export interface GraphQLResponse<T = unknown> {
  data?: T;
  errors?: Array<{
    message: string;
    locations?: Array<{ line: number; column: number }>;
    path?: string[];
    extensions?: Record<string, unknown>;
  }>;
}

export interface GraphQLClient {
  query: <T = unknown>(query: string, variables?: Record<string, unknown>) => Promise<GraphQLResponse<T>>;
  mutation: <T = unknown>(mutation: string, variables?: Record<string, unknown>) => Promise<GraphQLResponse<T>>;
}

/**
 * Opprett en GraphQL-klient med Playwright request context
 */
export function createGraphQLClient(request: APIRequestContext, token?: string): GraphQLClient {
  const execute = async <T = unknown>(
    query: string,
    variables?: Record<string, unknown>
  ): Promise<GraphQLResponse<T>> => {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    const response = await request.post(GRAPHQL_ENDPOINT, {
      headers,
      data: {
        query,
        variables,
      },
    });

    return response.json();
  };

  return {
    query: execute,
    mutation: execute,
  };
}
