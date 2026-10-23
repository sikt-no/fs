---
"krav-viewer": minor
---

Flyter følger ankeret: har en regel eller et scenario i kravet en fase (eller et krav i kjeden) bygger på, `@ref-<ID-en som peker på kravet>`, følges bare de delene av kravet. Kortet og treet viser delene med `@ref-`, og et klikk åpner kravet på den første av dem. Uten anker brukes regelen i «…» i kommentaren under taggen, som før. For et scenario følges også `@depends-on-` på regelen over. «Følg» heter nå «Bare delen fasen bygger på» (standard) og «Hele kravet».
