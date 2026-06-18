# Spec log

History of skill invocations for this spec. Append-only — never edit past entries.

## Invocations

- 2026-06-16 — `bat-specify-delta` started — commit b0e8de5 (sikt-no/fs#31)
- 2026-06-16 — `bat-specify-delta` ended (success) — wrote spec-changes-2026-06-16-b0e8de5.md, 0 lagt til / 6 endret / 0 fjernet (2 .feature-filer, begge @planned), 1 Figma-skisse linket (4 sub-frame-screenshots hentet, defaults + kolonner + arvet-badge bekreftet), alle 5 åpne spørsmål avklart
- 2026-06-16 — `bat-analyze` started — analyserer fs-admin-kode mot delta-spec (commit b0e8de5)
- 2026-06-16 — `bat-analyze` ended (success) — wrote analysis-applikasjoner-visning-delta.md (5 krav-gap identifisert: 4 filterkilder + 1 rolle-filter på tilgangslisten; cross-contributor-arbeid mot fs-plattform-producer i 3 punkter)
- 2026-06-16 — `bat-analyze` walkthrough — alle 5 åpne spørsmål avklart: (1) separate queries `mineSynlige*` + behold `mineApplikasjonsAdminOrganisasjoner` for redigeringsrett; (2) server-side felter `Applikasjon.tilgangerMiljoer`/`tilgangerOrganisasjoner` (ikke client-side derivasjon); (3) behold admin-hook + ny synlig-hook; (4) ingen ny cache-invalidering kreves (eksisterende `usePersonaOverride` dekker); (5) implementer rolle-filter i mock-API
- 2026-06-17 — `bat-plan` started — planlegger delta-iterasjon mot analysis-applikasjoner-visning-delta.md (kjøres i fs-admin)
- 2026-06-17 — `bat-graphql-dev` started — skisserer schema-endringer for plan-applikasjoner-visning-delta.md (kalles fra bat-plan)
- 2026-06-17 — `bat-graphql-dev` ended (success) — returnerte ## GraphQL-endringer-seksjon som tekst til bat-plan: 2 nye queries (mineSynligeOrganisasjoner, mineSynligeMiljoer), 2 nye Applikasjon-felter (tilgangerOrganisasjoner, tilgangerMiljoer), 1 autorisasjonsendring på Applikasjon.tilganger, 0 mutations, 0 åpne spørsmål (alle spec-spørsmål var avklart før kjøring). Sitert: fs-sikt-no-producer-schema-design §"Vi innfører gjerne egne felt og typer", fs-sikt-no-producer-naming §"Boolean-felt navngis med verb" + §"lowerCamelCase", fs-sikt-no-producer-best-practice §Paginering + §Nullability, graphql-golden-path-fragment-colocation §Implementation notes.
- 2026-06-17 — `bat-plan` ended (success) — wrote plan-applikasjoner-visning-delta.md, 6 tasks (1×M, 1×M, 4×S → total 1M+1M+4S; konservativ scope), GraphQL section yes (embedded mellom File Changes Overview og Implementation Tasks, fra bat-graphql-dev-runden i samme tur), 0 åpne spørsmål, full requirements-traceability tabell, cross-contributor hand-off til fs-plattform documented som Task #6.
