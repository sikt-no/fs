-- Gir regelen ORD i opptak 34 et unntak for utdanningsbakgrunnen UTLAND: søknadsalternativene til
-- søkere med utenlandsk utdanningsbakgrunn behandles av organisasjonen som forvalter opptaket (HK-dir).
-- Kjøres som superbruker: tabellene har RLS.
--
-- Bakgrunn: et statusskript (2026-10-26) viste at opptak 34 har standardregelen
-- ORD («Ordinær fordeling», behandles av alle), men ingen unntak per utdanningsbakgrunn. UTLAND har
-- omfordel_b_rolle = true, og søknad 1000836 har overstyrt utdanningsbakgrunn UTLAND med
-- b_rolle_overstyr = true, men søknadsalternativene ble liggende hos 194. Det er unntaket som mangler.
-- Testcase 1.18 i den interne akseptansetesten av tilbudsgaranti venter at saken flyttes til HK-dir.
--
-- Det samme kan gjøres med API-et (oppdaterBehandlertildelingsregel med unntak), eller i FS Admin
-- hvis siden for saksbehandlertildeling finnes der.

-- Før: unntakene i opptak 34 (ventet: ingen), og organisasjonen som forvalter opptaket
SELECT * FROM regelverk.behandlertildelingsregel_utdanningsbakgrunn WHERE opptak_kode = 34;
SELECT opptak_kode, organisasjonskode AS forvalter FROM opptak_v2.opptak WHERE opptak_kode = 34;

BEGIN;

INSERT INTO regelverk.behandlertildelingsregel_utdanningsbakgrunn
    (opptak_kode, behandlertildelingsregel_kode, utdanningsbakgrunn_type_kode,
     behandles_tilbyder, organisasjonskode_behandler)
SELECT o.opptak_kode, 'ORD', 'UTLAND', false, o.organisasjonskode
  FROM opptak_v2.opptak o
 WHERE o.opptak_kode = 34;

COMMIT;

-- Etter: én rad, ORD + UTLAND, med forvalteren som behandler
SELECT * FROM regelverk.behandlertildelingsregel_utdanningsbakgrunn WHERE opptak_kode = 34;
