---
"krav-viewer": patch
---

`@implemented` på en regel eller et scenario under en `@in-progress` egenskap gir ikke lenger avvik: det betyr at delen er levert, mens resten av kravet ikke er det (*Delvis levert* i `krav/README.md`). Under andre egenskaper, på et scenario under en `@implemented` regel, og sammen med en annen statustag på delen gir det fortsatt avvik.
