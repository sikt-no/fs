---
name: jira-overlapp-sjekk
description: Sjekker om en Jira-sak overlapper med eksisterende åpne saker i Tind (TOT), Puff/Overdrevent overkomplisert (STEK), Shiitake (TAKE), Shinkansen (SHI) og BAT, via Atlassian-MCP-en. Bruk ALLTID før en ny Jira-sak opprettes (før `createJiraIssue`, også via `executeWrite`), når brukeren ber om å opprette eller lage en Jira-sak, før arbeid på en sak starter, og når brukeren ber om å sjekke en konkret sak mot andre saker. Bruk også når brukeren ber om å hente alle sakene i et team og sjekke etter duplikater. Trigges av "ny Jira-sak", "opprett sak", "lag en oppgave i Jira", "finnes det noe tilsvarende", "kolliderer", "overlapp", "duplikat", "samme sak", "jira-overlapp-sjekk".
---

# Jira overlapp-sjekk

En kollisjon er to personer som løser det samme problemet samtidig, eller arbeid som overlapper vesentlig i funksjon under en annen saksnøkkel, vanligvis i et annet team. Det kan også være en sak som er opprettet manuelt og dekker det samme.

Skillen leser bare fra Jira, via Atlassian-MCP-en. Den oppretter, endrer eller kommenterer ingen saker.

## Verktøy

Bruk Atlassian-MCP-en som er koblet til: `mcp__claude_ai_Atlassian_Rovo__*` (som `fs-scope` bruker), eller plugin-varianten `mcp__plugin_atlassian_atlassian__*`. Er verktøyene utsatt (deferred), last dem med `ToolSearch` først.

- `cloudId`: bruk den du har fra før i økta. Ellers hent den med `getAccessibleAtlassianResources` (oppføringen med `read:jira-work`). For sikt.atlassian.net er den `03cbbec7-5724-4dce-8a65-494b98e1cb4d`.
- Søk med `searchJiraIssuesUsingJql`.
- Hent en hel sak med `getJiraIssue`.

Teamet leses av prefikset i saksnøkkelen: TOT = Tind, STEK = Puff (Overdrevent overkomplisert), TAKE = Shiitake, SHI = Shinkansen, BAT = BAT.

Avgrensningen i JQL (kalt `<omfang>` under):

```
project in (TOT, STEK, TAKE, SHI, BAT) AND statusCategory != Done
```

### Hold svaret lite

Svarene blir fort 100 000 tegn eller mer, og lagres da til en fil. Hold dem små:

- Første søk ber bare om `fields: ["summary", "status", "updated"]` med `maxResults: 25`. Ikke be om `description`, og ikke om `assignee`, `project` eller `customfield_10401`: objektene med avatarer gir mye støy. Eier og beskrivelse hentes med `getJiraIssue` for kandidatene.
- Les titlene. Hent `description` med `getJiraIssue` for de få kandidatene som kan ligne, og alltid for saker med en generisk tittel («Frontend», «Backend», «Diverse») der tittelen ikke sier hva saken leverer.
- Havner svaret i en fil, er det JSON på formen `{issues: {nodes: [...]}}`. Les det med for eksempel:

  ```
  jq -r '.issues.nodes[] | [.key, .fields.status.name, .fields.updated[0:10], .fields.summary] | @tsv' <fil>
  ```

- Bla (`nextPageToken`) bare når søket er smalt og du trenger resten. Har du ikke sett alle treffene, si fra til brukeren.

## Sjekk av en ny eller påbegynt sak

Skillen kjøres på utkastet til saken (tittel og beskrivelse), og sammenligner det saken leverer med det andre saker leverer.

1. Finn ut hva saken leverer: tittel, beskrivelse og, når den kommer fra et krav, `Regel:`-titlene og Feature-ID-en. Oppgir brukeren en kildesak («som <NØKKEL>, men …»), hent den med `getJiraIssue` og `fields: ["summary", "description", "status", "updated"]` (uten feltbegrensning kommer avatarer og andre objekter med). Er kilden `Done`, nevn det kort som et faktum, uten råd, og sjekk likevel utkastet mot de åpne sakene. Er kilden selv åpen, dukker den opp i treffene: legg `AND key != <kilde>` i søkene, så den ikke flagges mot seg selv. Andre saker som leverer det samme som kilden (for eksempel et søsken i et annet team) flagges som vanlig, og meldingen kan nevne at de trolig hører sammen med kilden.
2. Utled søkeord for det saken leverer: noen få, spesifikke ord (norsk og engelsk, domeneord som i kravene), og synonymer. Brede domeneord alene gir støy, siden nesten alt i domenet nevner dem. Kombiner to begreper med `AND`, og synonymer med `OR`. `text ~` søker også i beskrivelser og kommentarer: bruk `summary ~` som tilleggssøk når du vil ha færre og mer presise treff.

   ```
   <omfang> AND key != <kilde> AND updated >= -90d AND (text ~ "<begrep A>" AND (text ~ "<synonym B1>*" OR text ~ "<synonym B2>*"))
   ```

3. Kjør minst to søk med ulike ordsett, og **ett av dem uten `updated`-avgrensning** (men med smalere ord), så en gammel «In Progress»-sak som fortsatt er aktiv, ikke går glipp. Mål: under 25 treff per søk. Har et søk `hasNextPage: true`, følg det alltid av et smalere søk i stedet for å bla, og si fra til brukeren hvis du ikke har sett alle treffene.
4. Les titlene, og hent beskrivelsen for kandidatene. Sammenlign etter hva sakene leverer, ikke etter navn. En sak med samme ord i tittelen kan levere noe helt annet. Peker tittelen og beskrivelsen i ulik retning, gå etter beskrivelsen (det saken faktisk leverer), og si i meldingen at tittelen peker et annet sted. Lenker saken til samme krav (Feature-ID, `.feature`-fil) eller samme GitHub-issue som utkastet, styrker det flagget, og det nevnes i meldingen.
5. Bruk reglene under, og meld fra.

## Duplikater i ett team (bare når brukeren ber om det)

Brukes bare ved eksplisitt forespørsel, for eksempel «hent alle sakene i teamet mitt og sjekk etter duplikater». Den kjører ikke på egen hånd.

1. Spør hvilket team (prosjekt) det gjelder. «Mitt team» kan ikke utledes, siden skillen ikke vet hvilket team brukeren tilhører.
2. Hent alle åpne saker i teamet: `project = <prosjekt> AND statusCategory != Done`, med `maxResults: 100` og bare `summary, status, updated`, og bla gjennom alle sidene med `nextPageToken`. Hent `description` bare for sakene som ser ut til å ligne.
3. Sammenlign sakene med hverandre etter hva de leverer. Bruk reglene under.
4. Saker i andre team tas bare med hvis brukeren ber om det.

## Regler

* Ikke en kollisjon, og skal aldri meldes: delte filer, merge-konflikter, Flyway-versjoner som krasjer, en frontend-sak og backend-saken til den samme funksjonen (også når sakene ligger i ulike team), og en sak delt i deler innenfor ett team.
* En kollisjon er også en bredere sak som eksplisitt lister det samme som en del av leveransen (for eksempel en sak om «alle <X>» når utkastet er én av dem), når den er åpen og nylig oppdatert. Meldingen sier at den er bredere.
* «Nylig» betyr oppdatert de siste 30 dagene. En sak med status On Hold regnes som åpen, og flagges bare når den er nylig oppdatert. Meldingen nevner statusen.
* Samme domene betyr ikke samme leveranse. En sak som lager en funksjon og en sak som håndhever en regel rundt den er ulike leveranser, selv om begge handler om samme funksjon.
* Heller ikke en kollisjon: en gammel sak med samme tittel, uten nylige oppdateringer og uten åpen MR. Sjekk `updated` før du melder. En glemt «In Progress» er bakgrunnsstøy, ikke parallelt arbeid.
* Meldingen om en kollisjon sier at Claude flagget det, og gir lenkene med én linje om hva hver av sakene leverer. Er det flere saker, får hver sin linje, og lenkene står samlet til slutt. Har saken en generisk tittel («Frontend», «Diverse»), beskriv kort hva den leverer etter beskrivelsen, uten å vurdere tittelen og uten råd. Ingen forslag og ingen råd om hva brukeren bør gjøre.
* Er en kollisjon flagget, opprettes ikke saken, og arbeidet på saken starter ikke, før brukeren har svart. Still ett spørsmål: «Skal jeg opprette saken likevel?» (eller «Skal jeg fortsette?»). Det er ikke et råd.
* Ingen kollisjoner: si det i én linje, med hva som ble sjekket.

## Eksempler

Eksemplene bruker plassholdere.

Kollisjon:

> Claude flagget en mulig kollisjon:
> - <NØKKEL-1> «<tittel 1>»: <én linje om hva saken leverer>.
> - <NØKKEL-2> «<tittel 2>»: <én linje om hva saken leverer>.
> https://sikt.atlassian.net/browse/<NØKKEL-1>
> https://sikt.atlassian.net/browse/<NØKKEL-2>
>
> Skal jeg opprette saken likevel?

Bredere sak:

> Claude flagget en mulig kollisjon: <NØKKEL> «<tittel>» (<status>) er en bredere sak som også leverer <det utkastet leverer>.
> https://sikt.atlassian.net/browse/<NØKKEL>
>
> Skal jeg opprette saken likevel?

Ingen kollisjon:

> Claude sjekket åpne saker i TOT, STEK, TAKE, SHI og BAT: ingen overlapper med «<tittel på utkastet>».

## Feil

* MCP-verktøyene finnes ikke, eller kallet feiler med autentisering: si fra til brukeren at Atlassian-MCP-en ikke er koblet til, og stopp. Ikke opprett saken uten sjekk, og ikke gjett.
* Svaret er avkortet eller for stort: gjør søket smalere (flere søkeord, kortere `updated`-vindu, ett prosjekt om gangen), og si fra til brukeren hvis du ikke fikk sett alt.
