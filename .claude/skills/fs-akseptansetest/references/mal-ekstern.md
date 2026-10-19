# Mal: Ekstern akseptansetest (trinn 3)

For HK-dir og lærestedene. Den er lettere enn den interne med vilje: testerne skal komme raskt i gang, og skal ikke trenge bakgrunnen for saken.

- **Bare det testerne skal bruke.** Ta med scenarioene for rollene og prosessene testerne har (f.eks. samordna opptak, ikke lokalt opptak). Utvalget gjøres sammen med brukeren (C1 i SKILL.md).
- **Bare positive testtilfeller.** Som hovedregel tester eksterne ikke det som ikke skal gå (feilmeldinger, obligatoriske felt, sperrer, grenseverdier). Det testes i den interne testen, og står i «Ikke med i denne testen» med grunnen «Testes i den interne akseptansetesten». Et negativt testtilfelle tas bare med når brukeren ber om det.
- **Bare det som kan testes.** Det som ikke er testbart i miljøet, står i «Ikke med i denne testen» med en kort grunn uten tekniske ord.
- **Kort.** Sikt mot høyst 20–25 testtilfeller og under én time. Blir det mer, foreslå å dele i flere tester (C4).
- **Ingen intern informasjon:** Feature-ID-er, tagger, commits, Jira, GitHub, feature-flagg, kodeverdier, verify-resultater, «berører andre team», åpne spørsmål og kvalitetssikringen i teamet. Er noe uavklart, avklar det før testen, eller ta testtilfellet ut.
- **Testbrukeren og testdataene står i hver test** (kolonnene «Testbruker» og «Testdata»), og bytte av testbruker er et eget steg (T1 og T13).
- Testerne konkluderer selv (se informasjonsskrivet).

Fila skrives til `tasks/<domene>/<slug>/tester/akseptansetest-ekstern-<slug>.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Har den interne testen et testtilfelle som svarer til et eksternt, står det i metadataene (`Bygger på`), så funn kan sammenlignes.

```markdown
# Akseptansetest – <navn på saken>

- **Nivå**: ekstern (trinn 3)
- **Oppgave**: [tasks/<domene>/<slug>](../oppgave.md)
- **Krav**: <feature-filer med Feature-ID>, commit `<sha>` (<dato>)
- **Bygger på**: [intern akseptansetest](akseptansetest-intern-<slug>.md). Sporingen fra test til krav står på kvalitetssikringssiden
- **Testere**: <HK-dir, læresteder>
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-akseptansetest

---

Velkommen til akseptansetesten av <navn>. I testen sjekker du om løsningen gjør det kravene sier. Du tester ikke om kravene er de riktige, og du trenger ikke kjenne bakgrunnen for saken. Les [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting) før du starter.

## Før du starter

| Felt | Innhold |
|---|---|
| Hva er laget | <2–3 setninger med vanlige ord: hva du kan gjøre, og hvor i løsningen> |
| Hvor du tester | [<url>](<url>) |
| Dette kan du ikke gjøre i testen | - <kort> <br>- <…> |
| Tid | Ca. <N> minutter. Frist: <dato> |
| Spørsmål underveis | <kontaktperson>, i <kanal / e-post / møte> |

## Slik fyller du ut

1. Ta testene i rekkefølge, og følg stegene slik de står.
2. «Testbruker» sier hvem du skal være. «Testdata» sier hva du bruker, og hva du lager som de neste testene trenger.
3. Skriv det du så i «Faktisk resultat», og Ja, Nei eller Delvis i «Bestått?».
4. Sjekk at det du har lagret, står der når du åpner siden igjen.
5. Stemmer noe ikke, skriv hva du gjorde, hva du forventet og hva du fikk. Ta skjermbilde hvis du kan.

## Testene

### Del 1: <hva du gjør> (ca. <N> minutter)

| # | Testbruker | Hva du tester | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 1 | <navn>, <rolle> ved <organisasjon> | <med vanlige ord> | **Bruker:** … <br>**Lager:** … | 1. Logg inn som … <br>2. Gå til … <br>3. … | <det du ser> | | |

### Del 2: …

## Andre funn og erfaringer

Her skriver du det du oppdager som ikke står i testene, f.eks. om brukervennlighet, eller om du savner en test. Kontaktpersonen vurderer om og hvor det følges opp.

| Hva gjorde du? | Hvor gjorde du det? | Hva vil du melde om? |
|---|---|---|
| | | |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| <med vanlige ord> | <kommer senere / testes på en annen måte / gjelder ikke dette opptaket> |

## Konklusjon

| Felt | Innhold |
|---|---|
| Utfall | Godkjent / Godkjent med forbehold / Ikke godkjent |
| Begrunnelse | |
| Testet av og dato | |
```
