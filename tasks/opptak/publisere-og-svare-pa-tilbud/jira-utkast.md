# Utkast til Jira: Publisere resultatet og svare på tilbud

Utkast 2026-10-28, ikke opprettet. Kravene er `@draft`, og lenkene går til `main` (kravene kommer dit når PR #850 er merget).

## Epic: Publisere resultatet og svare på tilbud

Opptaksforvalter publiserer resultatet til søkerne, saksbehandlerne ser det publiserte resultatet, og søkerne svarer på tilbud og ventelisteplass, så svarene brukes i neste runde. Bygger på at plasstildelingen er gjennomført.

Saker som flyttes hit fra TAKE-3: TAKE-156, TAKE-268, TAKE-288, TAKE-329, TAKE-330, TAKE-331.

Verifisering 2026-10-28: 14 av 26 scenarioer finnes i koden.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/scope-plasstildeling-2027.md)

---

## Story (TAKE-330, skrives om): Publisere resultatet til søkerne

Ny tittel og beskrivelse, uten svarmelding. Meldingen til søkerne står i kravet om varsler og meldinger (`@should`), og svarbrevet i vedtaksformidlingen.

Opptaksforvalter velger hvilken plasstildeling som publiseres, og søkerne ser resultatet med begrunnelse i Min kompetanse. I dag går «kansellert» foran tilbud, og poenggrensen vises uansett innstillingen på utdanningstilbudet.

Akseptansekriterier:

- Søkerne ser ikke resultatet før det er publisert (`@OPT-PLA-RES-002`)
- Opptaksforvalter velger hvilken plasstildeling i plasstildelingsrunden som publiseres
- Søkeren ser resultatet med begrunnelse

Krav: [publisere_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/publisere_resultat.feature)

## Story (TAKE-288, beholdes): Søkeren ser ventelistenummeret

Søkeren ser ventelistenummeret når utdanningstilbudet viser det. Henger sammen med TOT-2443 og TOT-2022 hos Tind.

Akseptansekriterier:

- Søkeren ser resultatet med begrunnelse, scenarioet «Søker ser ventelistenummer» (`@OPT-PLA-RES-002`)

Krav: [publisere_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/publisere_resultat.feature)

## Story (TAKE-329, skrives om): Saksbehandler ser det publiserte resultatet

Ny tittel og beskrivelse. Resultatet før publisering er en egen story i epicen for gjennomføringen.

Saksbehandler ser det publiserte resultatet per søknad og per utdanningskvote, med poenggrense og totaltall, for søknadene organisasjonen saksbehandler eller tilbyr.

Akseptansekriterier:

- Saksbehandler ser det publiserte resultatet per søknad (`@OPT-PLA-RES-003`)
- Saksbehandler ser poenggrense og totaltall for det publiserte resultatet
- Saksbehandler ser søknadene organisasjonen er saksbehandlende organisasjon for og søknadene til utdanningstilbudene organisasjonen tilbyr
- Oppsummeringen av søknaden viser resultatet fra plasstildelingen

Krav: [se_publisert_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature)

## Story (TAKE-331, beskrivelsen oppdateres): Håndtere svar fra søker

Ny beskrivelse: ja, nei og venteliste virker. Det som gjenstår, er det som gjelder etterfylling (ingen bortfall på ventelisteplass, velge mellom flere tilbud), og at søkeren ser den nye svarfristen når den flyttes.

Akseptansekriterier:

- Søkeren svarer ja eller nei på tilbudet innen svarfristen (`@OPT-PLA-SVA-001`)
- Søkeren ser den nye svarfristen når svarfristen flyttes
- Søkeren kan svare ja til å stå på venteliste
- Søker med flere tilbud må velge ett

Krav: [håndtere_svar_fra_søker.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature)

## Bug: Opptakssvar kan leses uten avgrensning til organisasjonen

Alle med tilgang til søknadsbehandling (SE_SØKNADSBEHANDLING eller SE_SØKNAD) kan lese alle opptakssvar i alle opptak, uansett organisasjon.

Forventet: Saksbehandler ser søknadene organisasjonen er saksbehandlende organisasjon for og søknadene til utdanningstilbudene organisasjonen tilbyr (`@OPT-PLA-RES-003`).

Kode: `fs-plattform/…/V330__opptakssvar_plasstildeling_rls.sql:17-27`.

Krav: [se_publisert_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)
