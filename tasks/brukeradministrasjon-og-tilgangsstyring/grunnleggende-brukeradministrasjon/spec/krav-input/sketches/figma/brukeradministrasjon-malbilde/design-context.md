# Design-kontekst — Figma: Brukeradministrasjon v 1.0

- **Fil:** FS-Admin – Målbilde (`fileKey: dlG13wATArPvG69oePHPeL`)
- **Pekt-på node (URL):** `4551:5331` — canvas «Personbruker»
- **Relevant seksjon:** `4561:12394` — section «Brukeradministrasjon v 1.0» (5872×6677)
- **Hentet:** 2026-07-07 via Figma MCP (`get_metadata`, `get_screenshot`)

## Merknad om scope

Canvasen `4551:5331` inneholder også en urelatert section «Målbilde – Applikasjoner»
(`4561:15404`) som tilhører et annet domene (applikasjoner) og er **utenfor scope** for
denne spec-en. Kun «Brukeradministrasjon v 1.0» er hentet.

## Node-hierarki (meningsbærende frames i seksjonen)

```
section 4561:12394  "Brukeradministrasjon v 1.0"
├─ frame    4561:12399  "Group 1000001033"        (tittel-/label-gruppe — hoppet over)
├─ instance 4561:9806   "[Utdatert] Sidelayout…"  → detaljside, Detaljer-fane
├─ instance 4561:9982   "[Utdatert] Sidelayout…"  → detaljside, Tilganger-fane
├─ instance 4561:10158  "[Utdatert] Sidelayout…"  → detaljside, Roller-fane
├─ instance 4561:10418  "Sidelayout… (gjeldende)" → listevisning «Personbrukere»
├─ frame    4561:10420  "Deaktiver bruker - Modal"
├─ frame    4561:10433  "Tildele tilgang - Modal"
├─ frame    4561:10449  "Tildele rolle - Modal"
├─ frame    4561:10465  "Fjerne tilgang - Modal"
├─ frame    4561:10481  "Fjerne rolle - Modal"
└─ frame    4561:10497  "Aktiver bruker - Modal"
```

Merk: «[Utdatert]» i instans-navnet viser til at side-layout-**komponenten** er en eldre
versjon av pattern-et, ikke at skjerm-innholdet er utdatert. Skjermene brukes som
gjeldende designintensjon for validering.

## Sub-frame → krav-mapping

| Sub-frame (fil) | Figma-node | Dekker krav |
|---|---|---|
| `sub-frames/01-personbrukere-liste.png` | 4561:10418 | BRU-PER-GRU-001 (søke_opp_bruker) |
| `sub-frames/02-detaljside-detaljer.png` | 4561:9806 | BRU-PER-GRU-007 (se_detaljer) |
| `sub-frames/03-detaljside-tilganger.png` | 4561:9982 | BRU-PER-GRU-002 (se_brukers_tilganger) |
| `sub-frames/04-detaljside-roller.png` | 4561:10158 | BRU-PER-GRU-002 (se_brukers_tilganger) |
| `sub-frames/05-tildele-tilgang-modal.png` | 4561:10433 | BRU-PER-GRU-003 (tildele_og_fjerne) |
| `sub-frames/06-tildele-rolle-modal.png` | 4561:10449 | BRU-PER-GRU-003 (tildele_og_fjerne) |
| `sub-frames/07-fjerne-tilgang-modal.png` | 4561:10465 | BRU-PER-GRU-003 (tildele_og_fjerne) |
| `sub-frames/08-fjerne-rolle-modal.png` | 4561:10481 | BRU-PER-GRU-003 (tildele_og_fjerne) |
| `sub-frames/09-deaktiver-bruker-modal.png` | 4561:10420 | BRU-PER-GRU-004 (aktivere_og_deaktivere) |
| `sub-frames/10-aktiver-bruker-modal.png` | 4561:10497 | BRU-PER-GRU-004 (aktivere_og_deaktivere) |

## Ikke hentet

- `get_variable_defs` (design-tokens) og `download_assets`: ikke hentet i spec-fasen.
  Tokens/assets er mer relevante for design/implementasjons-fasen (`utdype-implementasjon`)
  enn for kravavklaring. Kan hentes senere ved behov.
