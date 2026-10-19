# Changesets

Hver endring i FS Kravforvaltning som skal med i neste versjon, får en changeset: en liten markdown-fil her som sier hva som er endret, og om det er en `patch`, `minor` eller `major`.

```bash
cd fs-kravforvaltning
npx changeset
```

Teksten blir en linje i `CHANGELOG.md` og i release-notatene, så skriv den for brukerne av appen. Se [`docs/release.md`](../docs/release.md) for hele flyten.
