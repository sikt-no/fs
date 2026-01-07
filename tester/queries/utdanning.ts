/**
 * GraphQL queries for Utdanning domain
 */

export const HENT_UTDANNINGSINSTANSER = `
  query HentUtdanningsinstanser {
    admissioUtdanningsinstanser {
      id
      campus {
        navn {
          nb
        }
      }
      organisasjon {
        navn {
          nb
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
`;
