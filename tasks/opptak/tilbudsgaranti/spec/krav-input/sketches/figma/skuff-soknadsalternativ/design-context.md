# Skuffen, fanen «Søknadsalternativ» (Figma 9348:84214)

Hentet 2026-10-22 med `get_metadata` og `get_screenshot`. `get_design_context` er ikke hentet: skissen brukes til å validere kravet og til tekstene i implementasjonsdetaljene, ikke til kode.

## Struktur

- Komponent `ActiveTab=Søknadsalternativer` (488 × 1679)
  - «Skjul»-knapp
  - Faner: Søknadsalternativ, Merknader, Mangler, Endringslogg
  - `Application options`: overskrift «Søknadsalternativer», og ett kort per søknadsalternativ (`studiealternativ v2` åpent, `studiealternativ v3` lukket)

## Tilbudsgaranti i skissen

| Søknadsalternativ | Node | Hva vises |
|---|---|---|
| 1. Biologi (Master, UiT) | `17311:85484` `input/subcomponent/combofield` | Etiketten «Tilbudsgaranti» og en nedtrekksmeny med verdien «KLA». Kan endres |
| 2. Informatikk (Master, UiB) | `18147:101042` | Overskriften «TILBUDSGARANTI», verdien «FOR», og «UiB, 12. april 2026 (12:03)» under. Kan ikke endres |

Lukkede kort viser ikke tilbudsgarantien. Et skjult merke `tilbudsgaranti` ved status «Kvalifisert» (`9348:84253`) finnes i komponenten, men vises ikke.

## Tekster

- «Tilbudsgaranti» (etikett over nedtrekksmenyen)
- «TILBUDSGARANTI» (overskrift over verdien som ikke kan endres)
- «<organisasjon>, <dato> (<klokkeslett>)», for eksempel «UiB, 12. april 2026 (12:03)»
- Verdien vises som kode: «KLA», «FOR»
