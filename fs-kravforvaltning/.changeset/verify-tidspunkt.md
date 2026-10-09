---
"krav-viewer": patch
---

Verify-rapportene har tidspunkt: `fs-verify` og `fs-verify-agent-teams` skriver `verify-<dato>-<HHMM>.md` og `- **Dato:** <dato> <HH:MM>`, så flere kjøringer samme dag kan sammenlignes. Claude-panelet og terminalen får tidspunktet i systemteksten. Spesifikasjoner bruker den nyeste rapporten etter dato og klokkeslett, og viser klokkeslettet. Før ble `verify-<dato>-2.md` tatt for å være eldre enn `verify-<dato>.md`.

`fs-verify` får resultatet kontrollert før brukeren spørres: av en uavhengig kontrollør (`fs-verify-kontroll`) i terminalen, og manuelt i Claude-panelet, som sier fra om det.
