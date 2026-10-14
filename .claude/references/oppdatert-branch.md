# Sjekk at branchen er oppdatert

fs-*-skillene sjekker at branchen er oppdatert før de gjør noe, så de ikke retagger, skriver eller verifiserer på en utdatert versjon. Andre kan ha pushet til den samme branchen (også etter en rebase), og main kan ha kommet videre. Det gjelder kravrepoet (dette repoet), og kodeklonene (fs-plattform, fs-admin, min-kompetanse) når skillen leser kode i dem.

## Når

- **Kravrepoet:** i oppstarten, før skillen leser eller skriver krav.
- **En kodeklone:** når stien er kjent, før skillen leter i koden.
- Én gang per kjøring og repo. Unntaket er når første skriving i kravrepoet kommer lenge etter oppstarten (f.eks. retaggingen på slutten av en gjennomgang i `fs-krav`). Da kjøres *Hent* og *Sammenlign* på nytt rett før, og skillen spør bare hvis noe har endret seg siden sist.

## Uten Bash

I Claude-panelet i FS Kravforvaltning er det ikke Bash. Hopp over sjekken der, og ikke si noe om den. Skriver skillen en rapport med en linje for dette, står det `ikke sjekket (Claude-panelet)`.

I terminalen (også terminalen i FS Kravforvaltning) kan Claude Code spørre brukeren om lov til `git fetch` og `git pull`. At brukeren blir spurt, betyr ikke at kommandoen har feilet. Vent på svaret.

## Hent

```bash
git -C "<repo>" fetch --quiet origin
```

Feiler den (offline, innlogging), si det på én linje («Fikk ikke hentet fra origin, sjekker mot det som er hentet fra før»), og fortsett med det som finnes lokalt.

## Sammenlign

Bare lesende git:

```bash
git -C "<repo>" rev-parse --abbrev-ref HEAD                            # branchen
git -C "<repo>" symbolic-ref --short refs/remotes/origin/HEAD          # hovedbranchen, origin/main hvis den mangler
git -C "<repo>" rev-parse --abbrev-ref @{u}                            # upstream, feiler hvis branchen ikke har en
git -C "<repo>" rev-list --left-right --count HEAD...@{u}              # «foran bak» mot upstream
git -C "<repo>" rev-list --count HEAD..<hovedbranch>                   # bak hovedbranchen
```

Mangler upstream (branchen er ikke pushet), sammenlignes det bare med hovedbranchen. Er branchen selv hovedbranchen, er upstream og hovedbranchen det samme, og det sjekkes én gang.

## Hva skillen gjør

**Oppdatert** (ikke bak upstream, og ikke bak hovedbranchen): én kort linje, f.eks. «`krav/x` er oppdatert mot origin», og fortsett.

**Bak upstream, ikke foran:** vis commitene som mangler (høyst 10):

```bash
git -C "<repo>" log --format='%h %an, %ar: %s' -10 HEAD..@{u}
```

Spør så med `AskUserQuestion`: «`<branch>` i `<repo>` er N commits bak origin. Hente dem først?», med valgene:

- **Hent nå**: kjør `git -C "<repo>" pull --ff-only`. Feiler den (f.eks. fordi lokale endringer er i veien), vis feilmeldingen og stopp. Brukeren ordner det selv og starter skillen på nytt.
- **Fortsett uten**: fortsett, og nevn det i rapporten når skillen skriver en.
- **Avbryt**: stopp.

**Både foran og bak upstream** (branchene har gått hver sin vei, typisk fordi noen har rebaset branchen på origin): ikke pull. Forklar hva som har skjedd: N lokale commits som ikke er på origin, og M på origin som ikke er lokalt. Be brukeren ordne det selv (f.eks. med `git pull --rebase`, eller en merge), og spør «Fortsett uten» eller «Avbryt».

**Bak hovedbranchen:** si hvor mange commits branchen mangler fra `<hovedbranch>`, og spør «Fortsett» eller «Avbryt». Skillen merger aldri hovedbranchen inn selv. For en kodeklone: si i tillegg at det er koden på `<branch>` som blir lest, ikke koden på main.

Er branchen både bak upstream og bak hovedbranchen, tas upstream først. Etter «Hent nå» telles det på nytt mot hovedbranchen.

## Aldri

- `stash`, `reset`, `rebase`, `checkout`, `merge` eller `push`. Den eneste kommandoen som endrer noe, er `pull --ff-only`, og bare når brukeren har svart «Hent nå».
- Foreslå kommandoer som sletter historikk eller lokale endringer, som `reset --hard` eller `checkout -- .`.
- Pulle uten å spørre, heller ikke i kodeklonene. `fetch` spørres det ikke om, siden den bare oppdaterer `origin/*`.
