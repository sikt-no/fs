/**
 * GraphQL queries for Organisasjon domain
 */

export const HENT_CAMPUS_LISTE = `
  query HentCampusListe($eierOrganisasjonskode: String!, $first: Int) {
    campuser(filter: { eierOrganisasjonskode: $eierOrganisasjonskode }, first: $first) {
      edges {
        node {
          id
          kode
          navnAlleSprak {
            bokmal
            nynorsk
            engelsk
          }
        }
      }
    }
  }
`;

export const HENT_ORGANISASJONER = `
  query HentOrganisasjoner($first: Int) {
    organisasjoner(first: $first) {
      edges {
        node {
          id
          organisasjonskode
          navnAlleSprak {
            nb
            nn
            en
          }
        }
      }
    }
  }
`;
