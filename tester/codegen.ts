import type { CodegenConfig } from '@graphql-codegen/cli'
import * as fs from 'fs'
import * as path from 'path'
import 'dotenv/config'

// Read cookies from Playwright auth state
function getCookieHeader(): string {
  const authFile = path.join(process.cwd(), 'playwright/.auth/fs-admin.json')
  if (!fs.existsSync(authFile)) {
    throw new Error(
      'Auth file not found. Run "npm test" first to create auth cookies.'
    )
  }
  const auth = JSON.parse(fs.readFileSync(authFile, 'utf-8'))
  return auth.cookies.map((c: { name: string; value: string }) => `${c.name}=${c.value}`).join('; ')
}

const config: CodegenConfig = {
  schema: [
    {
      [process.env.FS_ADMIN_GRAPHQL!]: {
        headers: {
          Cookie: getCookieHeader(),
        },
      },
    },
  ],
  generates: {
    'graphql/schema.graphql': {
      plugins: ['schema-ast'],
    },
    'graphql/types.ts': {
      plugins: ['typescript', 'typescript-operations'],
      config: {
        skipTypename: true,
        enumsAsTypes: true,
      },
    },
  },
}

export default config
