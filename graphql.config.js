/** @type {import('graphql-config').IGraphQLConfig} */
module.exports = {
  schema: './tester/graphql/schema.graphql',
  documents: ['./tester/graphql/**/*.ts', './tester/steps/**/*.ts'],
}
