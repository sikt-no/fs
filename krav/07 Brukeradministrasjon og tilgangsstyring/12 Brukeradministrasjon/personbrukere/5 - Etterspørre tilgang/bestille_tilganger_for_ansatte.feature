# language: no
# GitHub: #497
# Kilde: Brukerhistorie BH11 (temp/brukerhistorier.md)
@BRU-PER-ETT-001 @draft
Egenskap: Bestille tilganger for ansatte
  Som tilgangsbestiller
  ønsker jeg å bestille tilganger og roller på vegne av mine ansatte
  slik at de ansatte raskt får det de trenger uten å måtte be om det selv.

  Scenario: Tilgangsbestiller bestiller en rolle for en ansatt
    Gitt at jeg har tilgangsbestiller-rollen
    Og en ansatt mangler en spesifikk rolle
    Når jeg bestiller rollen for den ansatte
    Så skal forespørselen registreres som "venter på behandling"
    Og brukeradministrator skal varsles (se BRU-PER-ETT-004)

  Scenario: Bestille flere tilganger samtidig
    Gitt at jeg har tilgangsbestiller-rollen
    Når jeg velger flere tilganger og en eller flere ansatte
    Så skal det opprettes én forespørsel per kombinasjon
    Og alle skal være sporbare som et felles batch-bestilling

# ÅPNE SPØRSMÅL:
# - Hvem regnes som "mine ansatte" — basert på organisasjonsstruktur, leder-relasjon, eller manuell konfigurasjon?
# - Skal tilgangsbestiller-rollen være en egen rolle som tildeles, eller utledes automatisk fra leder-status?
# - Skal det være begrensninger på hvilke tilganger en tilgangsbestiller kan bestille (whitelist)?
# - Hva med tilganger som krever taushetserklæring — skal bestillingen aktivere flyt for det også?
# - Skal en bestilling automatisk godkjennes hvis bestiller har "tillit" for visse rolletyper?
# - Forholdet til BRU-PER-ETT-002 (egen forespørsel) — felles datamodell, ulik UX?
