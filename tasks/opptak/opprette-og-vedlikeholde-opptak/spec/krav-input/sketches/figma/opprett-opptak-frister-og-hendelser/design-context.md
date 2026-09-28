# Design context — Opprett opptak NY

Hentet 2026-09-28 fra Figma Dev Mode MCP (lokal server), ny versjon av siden: node `20606:117530`. Erstatter versjonen fra node `18929:96690`.

## Frister section (node 20606:117632) — tekst

`get_design_context` ble ikke kjørt for denne versjonen. Teksten er skrevet av fra skjermbildet [sub-frames/04-frister-section.png](sub-frames/04-frister-section.png).

**Generelle frister** — Gjelder alle utdanningstilbud og utdanningsbakgrunner som ikke har avvikende frister.

| Gruppe | Felt | Hjelpetekst |
|---|---|---|
| Redigering av studier | Redigering åpner | Organisasjoner som deltar i opptaket kan legge til og endre sine utdanningstilbud fra denne datoen. |
| Redigering av studier | Redigering stenger | Organisasjoner kan ikke legge til eller endre eller trekke utdanningstilbud etter denne datoen. |
| Søkeperiode | Åpner for søking | Opptaket publiseres for søker |
| Søkeperiode | Ordinær søknadsfrist | Frist for ordinære søkere |
| Endre søknad | Omprioriteringsfrist | Frist for å endre rekkefølgen på alternativene. |
| Endre søknad | Slette søknadsalternativer | Frist for å slette studier fra søknaden. |
| Dokumentasjon | Ordinær frist | For søkere med ordinær søknadsfrist. |
| Dokumentasjon | Ettersendingsfrist | Dokumentasjon som ikke forelå ved søknadsfristen. |
| Tidlig opptak | Søknadsfrist | For søkere som vil være med i tidlig opptak. |
| Tidlig opptak | Dokumentasjonsfrist | Frist for tidlig opptak. |
| Ledige studieplasser | Publiseres på nettsiden | Når restplasser vises til søker i Min kompetanse |
| Ledige studieplasser | Åpner for søking | Ledige studieplasser kan søkes på fra denne datoen |
| Ledige studieplasser | Stenger for søking | Det er ikke lenger mulig å søke fra denne datoen |
| Saksbehandlertildeling | Endre utdanningsbakgrunn | Saksbehandler kan endre søkers utdanningsbakgrunn frem til denne datoen. |
| Hovedopptak | Publiseringsdato | Tilbud og ventelisteplasser tildeles. |
| Hovedopptak | Svarfrist | Søker må svare innen denne fristen. |

Endringer mot forrige versjon: «Opptaksresultat» / «Hovedopptaket kjøres» er erstattet av «Hovedopptak» med «Publiseringsdato» og «Svarfrist». Gruppen er flyttet sist. Hjelpeteksten for tidlig dokumentasjonsfrist er endret til «Frist for tidlig opptak.».

## Metadata (hele siden, node 20606:117530)

```xml
<frame id="20606:117530" name="Opprett opptak NY" x="9172" y="1540" width="1920" height="4736.447265625">
  <frame id="20606:117531" name="Samordna Opptak- Opprett opptak info" x="0" y="0" width="1920" height="4736.447265625">
    <instance id="20606:117532" name="Drawer" x="0" y="0" width="1920" height="72" />
    <frame id="20606:117533" name="Frame 2629" x="164" y="80" width="1592" height="122">
      <instance id="20606:117534" name="Breadcrumb + Title - FS Admin" x="8" y="24" width="1576" height="74">
        <frame id="I20606:117534;1765:13230" name="Frame 1000000993" x="0" y="0" width="507" height="74">
          <instance id="I20606:117534;1765:13232" name="Breadcrumbs" x="0" y="0" width="116" height="16">
            <instance id="I20606:117534;1765:13232;27792:3824" name="Home" x="0" y="0" width="38" height="16" />
            <instance id="I20606:117534;1765:13232;27792:3825" name="CaretRight" x="42" y="0" width="16" height="16" />
            <instance id="I20606:117534;1765:13232;27792:3826" name="Level 1" x="86" y="0" width="41" height="16" hidden="true" />
            <instance id="I20606:117534;1765:13232;27792:3827" name="CaretRight" x="131" y="0" width="16" height="16" hidden="true" />
            <slot id="I20606:117534;1765:13232;27792:3986" name="slotCompact" x="62" y="0" width="64" height="16" hidden="true" />
            <instance id="I20606:117534;1765:13232;27792:3834" name="Current page" x="62" y="0" width="54" height="16" />
          </instance>
          <text id="I20606:117534;1765:13234" name="Title" x="0" y="32" width="507" height="42" />
        </frame>
        <slot id="I20606:117534;1765:13235" name="ButtonSlot" x="523" y="26" width="1053" height="48">
          <instance id="I20606:117534;1765:13235;20606:117752" name="Button" x="740" y="0" width="313" height="48" />
        </slot>
      </instance>
    </frame>
    <frame id="20606:117535" name="Frame 1000001976" x="164" y="210" width="1592" height="4282.4296875">
      <frame id="20606:117536" name="Info Schema" x="0" y="0" width="1592" height="4282.4296875">
        <frame id="20606:117537" name="Informasjon section" x="24" y="24" width="1544" height="200">
          <frame id="20606:117538" name="Frame 1000001931" x="0" y="0" width="1544" height="92">
            <frame id="20606:117539" name="Frame 1000001598" x="0" y="24" width="1544" height="32">
              <instance id="20606:117540" name="FileText" x="0" y="0" width="32" height="32" />
              <text id="20606:117541" name="Navn" x="36" y="2" width="57" height="28" />
            </frame>
            <frame id="20606:117542" name="Frame 1000001599" x="0" y="68" width="1544" height="24">
              <text id="20606:117543" name="Alle felter må fylles" x="0" y="0" width="134" height="24" />
            </frame>
          </frame>
          <frame id="20606:117544" name="Frame 1000001482" x="0" y="104" width="1544" height="92">
            <frame id="20606:117545" name="Frame 1000001481" x="0" y="0" width="1544" height="92">
              <frame id="20606:117546" name="Frame 1000001644" x="0" y="0" width="240" height="88" hidden="true">
                <frame id="20606:117547" name="Select" x="0" y="0" width="240" height="88">
                  <frame id="20606:117548" name="Input/.Label" x="0" y="0" width="240" height="40">
                    <text id="20606:117549" name="Hvilken type samordna opptak?" x="8" y="8" width="262" height="24" />
                  </frame>
                  <frame id="20606:117550" name="Field" x="0" y="40" width="240" height="48.000003814697266">
                    <frame id="20606:117551" name="Content" x="8" y="8.000000953674316" width="192" height="32">
                      <text id="20606:117552" name="Input value" x="4" y="4" width="184" height="24" />
                    </frame>
                    <frame id="20606:117553" name="Button" x="232" y="40" width="32.00000279752885" height="32.000002797529305">
                      <instance id="20606:117554" name="ArrowLeft" x="4" y="4" width="24.000002098146524" height="24.00000209814607" hidden="true" />
                      <frame id="20606:117555" name="Textcontainer" x="28" y="4" width="48.000002098146524" height="24.000004196293958" hidden="true">
                        <text id="20606:117556" name="Label" x="4" y="0" width="40.000002098146524" height="24.000003496910722" />
                      </frame>
                      <frame id="20606:117557" name="CaretDown" x="28.000001907348633" y="27.999998092651367" width="24" height="24" />
                    </frame>
                  </frame>
                </frame>
              </frame>
              <instance id="20606:117559" name="TextField" x="0" y="0" width="280" height="80">
                <frame id="I20606:117559;26791:4774" name="Label container" x="0" y="0" width="185" height="24">
                  <text id="I20606:117559;26132:609" name="Label text" x="0" y="0" width="185" height="24" />
                  <slot id="I20606:117559;31218:4474" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117559;26132:611" name="Helper text" x="0" y="32" width="280" height="16" hidden="true" />
                <frame id="I20606:117559;26132:612" name="Field" x="0" y="32" width="280" height="48">
                  <text id="I20606:117559;26132:613" name="Tekst he|" x="12" y="10" width="70" height="28" hidden="true" />
                  <frame id="I20606:117559;27805:15344" name="focus" x="-2.199951171875" y="-2" width="284" height="52" hidden="true" />
                </frame>
              </instance>
              <instance id="20606:117560" name="TextField" x="328" y="0" width="280" height="80">
                <frame id="I20606:117560;26791:4774" name="Label container" x="0" y="0" width="192" height="24">
                  <text id="I20606:117560;26132:609" name="Label text" x="0" y="0" width="192" height="24" />
                  <slot id="I20606:117560;31218:4474" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117560;26132:611" name="Helper text" x="0" y="32" width="280" height="16" hidden="true" />
                <frame id="I20606:117560;26132:612" name="Field" x="0" y="32" width="280" height="48">
                  <text id="I20606:117560;26132:613" name="Tekst he|" x="12" y="10" width="70" height="28" hidden="true" />
                  <frame id="I20606:117560;27805:15344" name="focus" x="-2.199951171875" y="-2" width="284" height="52" hidden="true" />
                </frame>
              </instance>
              <instance id="20606:117561" name="TextField" x="656" y="0" width="280" height="80">
                <frame id="I20606:117561;26791:4774" name="Label container" x="0" y="0" width="188" height="24">
                  <text id="I20606:117561;26132:609" name="Label text" x="0" y="0" width="188" height="24" />
                  <slot id="I20606:117561;31218:4474" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117561;26132:611" name="Helper text" x="0" y="32" width="280" height="16" hidden="true" />
                <frame id="I20606:117561;26132:612" name="Field" x="0" y="32" width="280" height="48">
                  <text id="I20606:117561;26132:613" name="Tekst he|" x="12" y="10" width="70" height="28" hidden="true" />
                  <frame id="I20606:117561;27805:15344" name="focus" x="-2.199951171875" y="-2" width="284" height="52" hidden="true" />
                </frame>
              </instance>
              <instance id="20606:117562" name="TextField" x="984" y="0" width="280" height="80">
                <frame id="I20606:117562;26791:4774" name="Label container" x="0" y="0" width="182" height="24">
                  <text id="I20606:117562;26132:609" name="Label text" x="0" y="0" width="182" height="24" />
                  <slot id="I20606:117562;31218:4474" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117562;26132:611" name="Helper text" x="0" y="32" width="280" height="16" hidden="true" />
                <frame id="I20606:117562;26132:612" name="Field" x="0" y="32" width="280" height="48">
                  <text id="I20606:117562;26132:613" name="Tekst he|" x="12" y="10" width="70" height="28" hidden="true" />
                  <frame id="I20606:117562;27805:15344" name="focus" x="-2.199951171875" y="-2" width="284" height="52" hidden="true" />
                </frame>
              </instance>
            </frame>
          </frame>
        </frame>
        <frame id="20606:117563" name="Frame 1000001846" x="24" y="248" width="1544" height="0">
          <line id="20606:117564" name="Line 83" x="0" y="2.67841304690819e-15" width="1544" height="0" />
        </frame>
        <frame id="20606:117565" name="Samordning section" x="24" y="272" width="1544" height="1071">
          <frame id="20606:117566" name="Frame 1000001598" x="0" y="0" width="1544" height="32">
            <instance id="20606:117567" name="Graph" x="0" y="0" width="32" height="32" />
            <text id="20606:117568" name="Samordning" x="36" y="2" width="135" height="28" />
          </frame>
          <frame id="20606:117569" name="Frame 1000001599" x="0" y="44" width="1544" height="24">
            <text id="20606:117570" name="Definer hvilke organisasjoner som samordnes" x="0" y="0" width="324" height="24" />
          </frame>
          <frame id="20606:118588" name="Frame 1000002203" x="0" y="80" width="1544" height="967">
            <frame id="20606:118589" name="Frame 1000002262" x="12" y="12" width="1520" height="931">
              <frame id="20606:118590" name="Frame 1000002265" x="0" y="0" width="384" height="88">
                <frame id="20606:118591" name="Frame 1000002207" x="0" y="0" width="349" height="24">
                  <frame id="20606:118592" name="Frame 1000001601" x="0" y="0" width="349" height="24">
                    <frame id="20606:118593" name="Frame 1000001477" x="0" y="0" width="349" height="24">
                      <frame id="20606:118594" name="Frame 1000002305" x="0" y="0" width="212" height="24">
                        <text id="20606:118595" name="Forvalter av opptaket: HK-Dir" x="0" y="0" width="212" height="24" />
                      </frame>
                      <instance id="20606:118596" name="Input/Text/Default" x="252" y="0" width="240" height="84" hidden="true" />
                    </frame>
                  </frame>
                </frame>
                <frame id="20606:118597" name="Frame 1000002210" x="0" y="40" width="384" height="48">
                  <frame id="20606:118598" name="Frame 1000002197" x="0" y="0" width="384" height="48">
                    <text id="20606:118599" name="Ingen organisasjoner er invitert ennå" x="0" y="0" width="293" height="24" hidden="true" />
                    <instance id="20606:118600" name="Button" x="0" y="0" width="384" height="48" />
                  </frame>
                </frame>
              </frame>
              <frame id="20606:118601" name="Frame 1000002264" x="0" y="136" width="1520" height="795">
                <frame id="20606:118602" name="meta" x="0" y="0" width="528" height="33">
                  <frame id="20606:118603" name="Input/.Label" x="0" y="4" width="528" height="25">
                    <text id="20606:118604" name="Samordnede organisasjoner" x="0" y="0" width="528" height="25" />
                  </frame>
                </frame>
                <text id="20606:118605" name="27 organisasjoner er med i samordningen i tillegg til UiX som administrerer opptaket" x="0" y="57" width="674" height="24" />
                <frame id="20606:118606" name="Frame 1000002260" x="0" y="105" width="1520" height="690">
                  <instance id="20606:118607" name="samordnet-org" x="0" y="0" width="497" height="66" />
                  <instance id="20606:118608" name="samordnet-org" x="509" y="0" width="497" height="66" />
                  <instance id="20606:118609" name="samordnet-org" x="1018" y="0" width="497" height="66" />
                  <instance id="20606:118610" name="samordnet-org" x="0" y="78" width="497" height="66" />
                  <instance id="20606:118611" name="samordnet-org" x="509" y="78" width="497" height="66" />
                  <instance id="20606:118612" name="samordnet-org" x="1018" y="78" width="497" height="66" />
                  <instance id="20606:118613" name="samordnet-org" x="0" y="156" width="497" height="66" />
                  <instance id="20606:118614" name="samordnet-org" x="509" y="156" width="497" height="66" />
                  <instance id="20606:118615" name="samordnet-org" x="1018" y="156" width="497" height="66" />
                  <instance id="20606:118616" name="samordnet-org" x="0" y="234" width="497" height="66" />
                  <instance id="20606:118617" name="samordnet-org" x="509" y="234" width="497" height="66" />
                  <instance id="20606:118618" name="samordnet-org" x="1018" y="234" width="497" height="66" />
                  <instance id="20606:118619" name="samordnet-org" x="0" y="312" width="497" height="66" />
                  <instance id="20606:118620" name="samordnet-org" x="509" y="312" width="497" height="66" />
                  <instance id="20606:118621" name="samordnet-org" x="1018" y="312" width="497" height="66" />
                  <instance id="20606:118622" name="samordnet-org" x="0" y="390" width="497" height="66" />
                  <instance id="20606:118623" name="samordnet-org" x="509" y="390" width="497" height="66" />
                  <instance id="20606:118624" name="samordnet-org" x="1018" y="390" width="497" height="66" />
                  <instance id="20606:118625" name="samordnet-org" x="0" y="468" width="497" height="66" />
                  <instance id="20606:118626" name="samordnet-org" x="509" y="468" width="497" height="66" />
                  <instance id="20606:118627" name="samordnet-org" x="1018" y="468" width="497" height="66" />
                  <instance id="20606:118628" name="samordnet-org" x="0" y="546" width="497" height="66" />
                  <instance id="20606:118629" name="samordnet-org" x="509" y="546" width="497" height="66" />
                  <instance id="20606:118630" name="samordnet-org" x="1018" y="546" width="497" height="66" />
                  <instance id="20606:118631" name="samordnet-org" x="0" y="624" width="497" height="66" />
                  <instance id="20606:118632" name="samordnet-org" x="509" y="624" width="497" height="66" />
                  <instance id="20606:118633" name="samordnet-org" x="1018" y="624" width="497" height="66" />
                </frame>
              </frame>
            </frame>
            <instance id="20606:118634" name="Button" x="1396" y="42" width="126" height="48" />
          </frame>
        </frame>
        <frame id="20606:117589" name="Innstillinger section" x="24" y="1367" width="1544" height="728">
          <frame id="20606:117590" name="Frame 1000001598" x="0" y="0" width="1544" height="32">
            <instance id="20606:117591" name="settings" x="0" y="0" width="32" height="32" />
            <text id="20606:117592" name="Innstillinger for opptaket" x="36" y="2" width="268" height="28" />
          </frame>
          <frame id="20606:117593" name="Frame 1000001599" x="0" y="44" width="1544" height="24">
            <text id="20606:117594" name="Her bestemmer du funksjonalitet til opptaket" x="0" y="0" width="318" height="24" />
          </frame>
          <frame id="20606:117595" name="Frame 1000002530" x="0" y="80" width="1544" height="624">
            <frame id="20606:117596" name="Frame 1000002203" x="0" y="0" width="1134" height="624">
              <frame id="20606:117597" name="Frame 1000002207" x="12" y="12" width="1110" height="588">
                <frame id="20606:117598" name="Frame 1000002300" x="0" y="0" width="1110" height="256">
                  <frame id="20606:117599" name="Frame 1000002559" x="0" y="0" width="543" height="232">
                    <instance id="20606:117600" name="Select" x="0" y="0" width="543" height="104">
                      <frame id="I20606:117600;27245:4004" name="Label" x="0" y="0" width="143" height="24">
                        <text id="I20606:117600;27245:4005" name="Label text" x="0" y="0" width="143" height="24" />
                        <slot id="I20606:117600;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                      </frame>
                      <text id="I20606:117600;25981:3468" name="Helper text" x="0" y="32" width="543" height="16" />
                      <frame id="I20606:117600;25981:3469" name="Field" x="0" y="56" width="543" height="48">
                        <text id="I20606:117600;25981:3470" name="Valg" x="12" y="10" width="487" height="28" />
                        <instance id="I20606:117600;25981:3471" name="CaretDown" x="507" y="12" width="24" height="24" />
                        <frame id="I20606:117600;27845:1930" name="focus" x="-2" y="-2" width="547" height="52" hidden="true" />
                      </frame>
                    </instance>
                    <instance id="20606:117601" name="Select" x="0" y="128" width="543" height="104">
                      <frame id="I20606:117601;27245:4004" name="Label" x="0" y="0" width="543" height="24">
                        <text id="I20606:117601;27245:4005" name="Label text" x="0" y="0" width="543" height="24" />
                        <slot id="I20606:117601;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                      </frame>
                      <text id="I20606:117601;25981:3468" name="Helper text" x="0" y="32" width="543" height="16" />
                      <frame id="I20606:117601;25981:3469" name="Field" x="0" y="56" width="543" height="48">
                        <text id="I20606:117601;25981:3470" name="Valg" x="12" y="10" width="487" height="28" />
                        <instance id="I20606:117601;25981:3471" name="CaretDown" x="507" y="12" width="24" height="24" />
                        <frame id="I20606:117601;27845:1930" name="focus" x="-2" y="-2" width="547" height="52" hidden="true" />
                      </frame>
                    </instance>
                  </frame>
                  <frame id="20606:117602" name="Frame 1000002560" x="567" y="0" width="543" height="204">
                    <instance id="20606:117603" name="Combobox" x="0" y="0" width="543" height="100">
                      <instance id="I20606:117603;27672:1438" name=".Combobox / combofield" x="0" y="0" width="543" height="100">
                        <frame id="I20606:117603;27672:1438;27646:17916" name="Container" x="0" y="0" width="543" height="44">
                          <frame id="I20606:117603;27672:1438;27646:17543" name="Label" x="0" y="0" width="77" height="24">
                            <text id="I20606:117603;27672:1438;27646:17544" name="Label" x="0" y="0" width="77" height="24" />
                            <instance id="I20606:117603;27672:1438;27646:17545" name="TagCustom" x="88" y="0" width="72" height="24" hidden="true" />
                          </frame>
                          <text id="I20606:117603;27672:1438;27646:17546" name="Helper text" x="0" y="28" width="543" height="16" />
                        </frame>
                        <frame id="I20606:117603;27672:1438;27646:17547" name="Field" x="0" y="52" width="543" height="48">
                          <slot id="I20606:117603;27672:1438;27646:17730" name="lg-slot-1" x="12" y="8" width="487" height="32">
                            <instance id="I20606:117603;27672:1438;27646:17730;20606:117757" name="InputChip" x="0" y="0" width="203" height="32" />
                            <instance id="I20606:117603;27672:1438;27646:17730;20606:117758" name="InputChip" x="211" y="0" width="142" height="32" />
                            <instance id="I20606:117603;27672:1438;27646:17730;20606:117759" name="InputChip" x="361" y="0" width="116" height="32" />
                          </slot>
                          <instance id="I20606:117603;27672:1438;27646:17549" name="Dropdown Icon" x="507" y="12" width="24" height="24" />
                        </frame>
                        <frame id="I20606:117603;27672:1438;30441:17819" name="focus" x="-2" y="50" width="547" height="52" hidden="true" />
                      </instance>
                      <instance id="I20606:117603;27672:1512" name=".Combobox / list box" x="0" y="108" width="280" height="56" hidden="true" />
                    </instance>
                    <instance id="20606:117604" name="Select" x="0" y="124" width="412" height="80">
                      <frame id="I20606:117604;27245:4004" name="Label" x="0" y="0" width="132" height="24">
                        <text id="I20606:117604;27245:4005" name="Label text" x="0" y="0" width="132" height="24" />
                        <slot id="I20606:117604;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                      </frame>
                      <text id="I20606:117604;25981:3468" name="Helper text" x="0" y="32" width="252" height="16" hidden="true" />
                      <frame id="I20606:117604;25981:3469" name="Field" x="0" y="32" width="412" height="48">
                        <text id="I20606:117604;25981:3470" name="Valg" x="12" y="10" width="356" height="28" />
                        <instance id="I20606:117604;25981:3471" name="CaretDown" x="376" y="12" width="24" height="24" />
                        <frame id="I20606:117604;27845:1930" name="focus" x="-2" y="-2" width="416" height="52" hidden="true" />
                      </frame>
                    </instance>
                  </frame>
                </frame>
                <frame id="20606:117605" name="Frame 1000002562" x="0" y="268" width="784" height="320">
                  <frame id="20606:117606" name="Frame 1000002528" x="0" y="0" width="784" height="150">
                    <frame id="20606:117607" name="Frame 1000002206" x="0" y="15" width="784" height="120">
                      <frame id="20606:117608" name="Frame 1000002521" x="0" y="0" width="218" height="120">
                        <instance id="20606:117609" name="TextField" x="0" y="0" width="218" height="120">
                          <frame id="I20606:117609;26791:4774" name="Label container" x="0" y="0" width="218" height="24">
                            <text id="I20606:117609;26132:609" name="Label text" x="0" y="0" width="218" height="24" />
                            <slot id="I20606:117609;31218:4474" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                          </frame>
                          <text id="I20606:117609;26132:611" name="Helper text" x="0" y="32" width="183" height="32" />
                          <frame id="I20606:117609;26132:612" name="Field" x="0" y="72" width="218" height="48">
                            <text id="I20606:117609;26132:613" name="Tekst he|" x="12" y="10" width="7" height="28" />
                            <frame id="I20606:117609;27805:15344" name="focus" x="-2.199951171875" y="-2" width="222" height="52" hidden="true" />
                          </frame>
                        </instance>
                      </frame>
                      <instance id="20606:117610" name="Input/Text/Default" x="764.6666259765625" y="0" width="240" height="84" hidden="true" />
                      <instance id="20606:117611" name="Select" x="288" y="0" width="216" height="120">
                        <frame id="I20606:117611;27245:4004" name="Label" x="0" y="0" width="214" height="24">
                          <text id="I20606:117611;27245:4005" name="Label text" x="0" y="0" width="214" height="24" />
                          <slot id="I20606:117611;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                        </frame>
                        <text id="I20606:117611;25981:3468" name="Helper text" x="0" y="32" width="216" height="32" />
                        <frame id="I20606:117611;25981:3469" name="Field" x="0" y="72" width="216" height="48">
                          <text id="I20606:117611;25981:3470" name="Valg" x="12" y="10" width="160" height="28" />
                          <instance id="I20606:117611;25981:3471" name="CaretDown" x="180" y="12" width="24" height="24" />
                          <frame id="I20606:117611;27845:1930" name="focus" x="-2" y="-2" width="220" height="52" hidden="true" />
                        </frame>
                      </instance>
                      <instance id="20606:117612" name="Select" x="574" y="0" width="210" height="120">
                        <frame id="I20606:117612;27245:4004" name="Label" x="0" y="0" width="211" height="24">
                          <text id="I20606:117612;27245:4005" name="Label text" x="0" y="0" width="211" height="24" />
                          <slot id="I20606:117612;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                        </frame>
                        <text id="I20606:117612;25981:3468" name="Helper text" x="0" y="32" width="210" height="32" />
                        <frame id="I20606:117612;25981:3469" name="Field" x="0" y="72" width="210" height="48">
                          <text id="I20606:117612;25981:3470" name="Valg" x="12" y="10" width="154" height="28" />
                          <instance id="I20606:117612;25981:3471" name="CaretDown" x="174" y="12" width="24" height="24" />
                          <frame id="I20606:117612;27845:1930" name="focus" x="-2" y="-2" width="214" height="52" hidden="true" />
                        </frame>
                      </instance>
                    </frame>
                  </frame>
                  <instance id="20606:117613" name="poenglikhet" x="0" y="150" width="782" height="170">
                    <frame id="I20606:117613;20513:115137" name="Frame 1000002529" x="0" y="0" width="782" height="134">
                      <instance id="I20606:117613;20513:115138" name="Input/Text/Default" x="764.6666259765625" y="15" width="240" height="84" hidden="true" />
                      <instance id="I20606:117613;20513:115139" name="Select" x="0" y="15" width="782" height="104">
                        <frame id="I20606:117613;20513:115139;27245:4004" name="Label" x="0" y="0" width="148" height="24">
                          <text id="I20606:117613;20513:115139;27245:4005" name="Label text" x="0" y="0" width="148" height="24" />
                          <slot id="I20606:117613;20513:115139;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                        </frame>
                        <text id="I20606:117613;20513:115139;25981:3468" name="Helper text" x="0" y="32" width="782" height="16" />
                        <frame id="I20606:117613;20513:115139;25981:3469" name="Field" x="0" y="56" width="782" height="48">
                          <text id="I20606:117613;20513:115139;25981:3470" name="Valg" x="12" y="10" width="726" height="28" />
                          <instance id="I20606:117613;20513:115139;25981:3471" name="CaretDown" x="746" y="12" width="24" height="24" />
                          <frame id="I20606:117613;20513:115139;27845:1930" name="focus" x="-2" y="-2" width="786" height="52" hidden="true" />
                        </frame>
                      </instance>
                    </frame>
                    <instance id="I20606:117613;20513:115140" name="Checkbox" x="0" y="146" width="539" height="24" />
                    <instance id="I20606:117613;20513:115160" name="Combobox" x="0" y="182" width="782" height="100" hidden="true" />
                  </instance>
                </frame>
              </frame>
            </frame>
            <frame id="20606:117614" name="Frame 1000002204" x="1164" y="0" width="380" height="624">
              <frame id="20606:117615" name="Frame 1000002207" x="12" y="12" width="356" height="600">
                <frame id="20606:117616" name="Label" x="0" y="0" width="370" height="36" hidden="true">
                  <text id="20606:117617" name="Content" x="8" y="4" width="354" height="24" />
                </frame>
                <frame id="20606:117618" name="Label" x="0" y="0" width="356" height="32">
                  <text id="20606:117619" name="Content" x="8" y="0" width="340" height="24" />
                </frame>
                <frame id="20606:117620" name="Checkbox/Single (Interactive)" x="0" y="44" width="339" height="49">
                  <instance id="20606:117621" name="interactive checkbox" x="0" y="0.5" width="48" height="48" />
                  <text id="20606:117622" name="Input value" x="56" y="12.5" width="147" height="24" />
                </frame>
                <frame id="20606:117623" name="Checkbox/Single (Interactive)" x="0" y="105" width="236" height="49">
                  <instance id="20606:117624" name="interactive checkbox" x="0" y="0.5" width="48" height="48" />
                  <text id="20606:117625" name="Input value" x="56" y="12.5" width="180" height="24" />
                </frame>
                <frame id="20606:117626" name="Checkbox/Single (Interactive)" x="0" y="166" width="339" height="49">
                  <instance id="20606:117627" name="interactive checkbox" x="0" y="0.5" width="48" height="48" />
                  <text id="20606:117628" name="Input value" x="56" y="12.5" width="232" height="24" />
                </frame>
                <frame id="20606:117629" name="Checkbox/Single (Interactive)" x="0" y="227" width="244" height="49">
                  <instance id="20606:117630" name="interactive checkbox" x="0" y="0.5" width="48" height="48" />
                  <text id="20606:117631" name="Input value" x="56" y="12.5" width="192" height="24" />
                </frame>
              </frame>
            </frame>
          </frame>
        </frame>
        <frame id="20606:117632" name="Frister section" x="24" y="2119" width="1592" height="784">
          <frame id="20606:117633" name="Frame 1000002532" x="0" y="0" width="1544" height="56">
            <frame id="20606:117634" name="Frame 1000001598" x="0" y="0" width="1544" height="32">
              <instance id="20606:117635" name="date-calendar" x="0" y="0" width="32" height="32" />
              <text id="20606:117636" name="Generelle frister" x="36" y="2" width="177" height="28" />
            </frame>
            <frame id="20606:117637" name="Frame 1000001599" x="0" y="32" width="1544" height="24">
              <text id="20606:117638" name="Gjelder alle utdanningstilbud og utdanningsbakgrunner som ikke har avvikende frister." x="0" y="0" width="613" height="24" />
            </frame>
          </frame>
          <frame id="20606:117639" name="Redigering av studier" x="0" y="80" width="367" height="300">
            <frame id="20606:117640" name="Frame 1000002545" x="16" y="8" width="245" height="28">
              <frame id="20606:117641" name="Frame 1000001476" x="0" y="0" width="245" height="28">
                <text id="20606:117642" name="Content" x="0" y="0" width="245" height="28" />
              </frame>
            </frame>
            <instance id="20606:117643" name="DateInput" x="16" y="48" width="335" height="116">
              <frame id="I20606:117643;31049:18198" name="Text container" x="0" y="0" width="335" height="60">
                <frame id="I20606:117643;31232:3274" name="Label container" x="0" y="0" width="142" height="24">
                  <text id="I20606:117643;26891:2579" name="Label text" x="0" y="0" width="142" height="24" />
                  <slot id="I20606:117643;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117643;26891:2580" name="Format info" x="0" y="28" width="335" height="32" />
              </frame>
              <frame id="I20606:117643;26891:2581" name="Container" x="0" y="68" width="335" height="48">
                <frame id="I20606:117643;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117643;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117643;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117643;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117644" name="DateInput" x="16" y="176" width="335" height="116">
              <frame id="I20606:117644;31049:18198" name="Text container" x="0" y="0" width="335" height="60">
                <frame id="I20606:117644;31232:3274" name="Label container" x="0" y="0" width="157" height="24">
                  <text id="I20606:117644;26891:2579" name="Label text" x="0" y="0" width="157" height="24" />
                  <slot id="I20606:117644;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117644;26891:2580" name="Format info" x="0" y="28" width="335" height="32" />
              </frame>
              <frame id="I20606:117644;26891:2581" name="Container" x="0" y="68" width="335" height="48">
                <frame id="I20606:117644;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117644;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117644;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117644;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117645" name="input publiseringsdato" x="391" y="80" width="367" height="268">
            <frame id="20606:117646" name="Frame 1000001476" x="16" y="8" width="188" height="28">
              <text id="20606:117647" name="Content" x="0" y="0" width="188" height="28" />
            </frame>
            <instance id="20606:117648" name="DateInput" x="16" y="48" width="335" height="100">
              <frame id="I20606:117648;31049:18198" name="Text container" x="0" y="0" width="185" height="44">
                <frame id="I20606:117648;31232:3274" name="Label container" x="0" y="0" width="136" height="24">
                  <text id="I20606:117648;26891:2579" name="Label text" x="0" y="0" width="136" height="24" />
                  <slot id="I20606:117648;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117648;26891:2580" name="Format info" x="0" y="28" width="185" height="16" />
              </frame>
              <frame id="I20606:117648;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117648;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117648;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117648;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117648;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117649" name="DateInput" x="16" y="160" width="335" height="100">
              <frame id="I20606:117649;31049:18198" name="Text container" x="0" y="0" width="174" height="44">
                <frame id="I20606:117649;31232:3274" name="Label container" x="0" y="0" width="174" height="24">
                  <text id="I20606:117649;26891:2579" name="Label text" x="0" y="0" width="174" height="24" />
                  <slot id="I20606:117649;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117649;26891:2580" name="Format info" x="0" y="28" width="153" height="16" />
              </frame>
              <frame id="I20606:117649;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117649;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117649;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117649;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117649;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117650" name="input publiseringsdato" x="782" y="80" width="367" height="268">
            <frame id="20606:117651" name="Frame 1000001476" x="16" y="8" width="188" height="28">
              <text id="20606:117652" name="Content" x="0" y="0" width="188" height="28" />
            </frame>
            <instance id="20606:117653" name="DateInput" x="16" y="48" width="335" height="100">
              <frame id="I20606:117653;31049:18198" name="Text container" x="0" y="0" width="282" height="44">
                <frame id="I20606:117653;31232:3274" name="Label container" x="0" y="0" width="165" height="24">
                  <text id="I20606:117653;26891:2579" name="Label text" x="0" y="0" width="165" height="24" />
                  <slot id="I20606:117653;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117653;26891:2580" name="Format info" x="0" y="28" width="282" height="16" />
              </frame>
              <frame id="I20606:117653;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117653;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117653;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117653;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117653;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117654" name="DateInput" x="16" y="160" width="335" height="100">
              <frame id="I20606:117654;31049:18198" name="Text container" x="0" y="0" width="229" height="44">
                <frame id="I20606:117654;31232:3274" name="Label container" x="0" y="0" width="215" height="24">
                  <text id="I20606:117654;26891:2579" name="Label text" x="0" y="0" width="215" height="24" />
                  <slot id="I20606:117654;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117654;26891:2580" name="Format info" x="0" y="28" width="229" height="16" />
              </frame>
              <frame id="I20606:117654;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117654;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117654;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117654;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117654;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117655" name="input publiseringsdato" x="1173" y="80" width="367" height="268">
            <frame id="20606:117656" name="Frame 1000001476" x="16" y="8" width="233" height="28">
              <text id="20606:117657" name="Content" x="0" y="0" width="233" height="28" />
            </frame>
            <instance id="20606:117658" name="DateInput" x="16" y="48" width="335" height="100">
              <frame id="I20606:117658;31049:18198" name="Text container" x="0" y="0" width="233" height="44">
                <frame id="I20606:117658;31232:3274" name="Label container" x="0" y="0" width="106" height="24">
                  <text id="I20606:117658;26891:2579" name="Label text" x="0" y="0" width="106" height="24" />
                  <slot id="I20606:117658;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117658;26891:2580" name="Format info" x="0" y="28" width="233" height="16" />
              </frame>
              <frame id="I20606:117658;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117658;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117658;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117658;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117658;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117659" name="DateInput" x="16" y="160" width="335" height="100">
              <frame id="I20606:117659;31049:18198" name="Text container" x="0" y="0" width="320" height="44">
                <frame id="I20606:117659;31232:3274" name="Label container" x="0" y="0" width="147" height="24">
                  <text id="I20606:117659;26891:2579" name="Label text" x="0" y="0" width="147" height="24" />
                  <slot id="I20606:117659;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117659;26891:2580" name="Format info" x="0" y="28" width="320" height="16" />
              </frame>
              <frame id="I20606:117659;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117659;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117659;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117659;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117659;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117664" name="input publiseringsdato" x="0" y="404" width="367" height="268">
            <frame id="20606:117665" name="Frame 1000001476" x="16" y="8" width="233" height="28">
              <text id="20606:117666" name="Content" x="0" y="0" width="233" height="28" />
            </frame>
            <instance id="20606:117667" name="DateInput" x="16" y="48" width="335" height="100">
              <frame id="I20606:117667;31049:18198" name="Text container" x="0" y="0" width="269" height="44">
                <frame id="I20606:117667;31232:3274" name="Label container" x="0" y="0" width="103" height="24">
                  <text id="I20606:117667;26891:2579" name="Label text" x="0" y="0" width="103" height="24" />
                  <slot id="I20606:117667;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117667;26891:2580" name="Format info" x="0" y="28" width="269" height="16" />
              </frame>
              <frame id="I20606:117667;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117667;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117667;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117667;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117667;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117668" name="DateInput" x="16" y="160" width="335" height="100">
              <frame id="I20606:117668;31049:18198" name="Text container" x="0" y="0" width="170" height="44">
                <frame id="I20606:117668;31232:3274" name="Label container" x="0" y="0" width="170" height="24">
                  <text id="I20606:117668;26891:2579" name="Label text" x="0" y="0" width="170" height="24" />
                  <slot id="I20606:117668;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117668;26891:2580" name="Format info" x="0" y="28" width="131" height="16" />
              </frame>
              <frame id="I20606:117668;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117668;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117668;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117668;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117668;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117669" name="input publiseringsdato" x="391" y="404" width="367" height="380">
            <frame id="20606:117670" name="Frame 1000001476" x="16" y="8" width="262" height="28">
              <text id="20606:117671" name="Content" x="0" y="0" width="262" height="28" />
            </frame>
            <instance id="20606:117672" name="DateInput" x="16" y="48" width="335" height="100">
              <frame id="I20606:117672;31049:18198" name="Text container" x="0" y="0" width="292" height="44">
                <frame id="I20606:117672;31232:3274" name="Label container" x="0" y="0" width="191" height="24">
                  <text id="I20606:117672;26891:2579" name="Label text" x="0" y="0" width="191" height="24" />
                  <slot id="I20606:117672;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117672;26891:2580" name="Format info" x="0" y="28" width="292" height="16" />
              </frame>
              <frame id="I20606:117672;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117672;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117672;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117672;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117672;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117673" name="DateInput" x="16" y="160" width="335" height="100">
              <frame id="I20606:117673;31049:18198" name="Text container" x="0" y="0" width="323" height="44">
                <frame id="I20606:117673;31232:3274" name="Label container" x="0" y="0" width="136" height="24">
                  <text id="I20606:117673;26891:2579" name="Label text" x="0" y="0" width="136" height="24" />
                  <slot id="I20606:117673;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117673;26891:2580" name="Format info" x="0" y="28" width="323" height="16" />
              </frame>
              <frame id="I20606:117673;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117673;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117673;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117673;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117673;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="20606:117674" name="DateInput" x="16" y="272" width="335" height="100">
              <frame id="I20606:117674;31049:18198" name="Text container" x="0" y="0" width="301" height="44">
                <frame id="I20606:117674;31232:3274" name="Label container" x="0" y="0" width="151" height="24">
                  <text id="I20606:117674;26891:2579" name="Label text" x="0" y="0" width="151" height="24" />
                  <slot id="I20606:117674;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117674;26891:2580" name="Format info" x="0" y="28" width="301" height="16" />
              </frame>
              <frame id="I20606:117674;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117674;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117674;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117674;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117674;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117675" name="input publiseringsdato" x="782" y="404" width="367" height="172">
            <frame id="20606:117676" name="Frame 1000001476" x="16" y="8" width="321.04150390625" height="28">
              <text id="20606:117677" name="Content" x="0" y="0" width="321.04150390625" height="28" />
            </frame>
            <instance id="20606:117678" name="DateInput" x="16" y="48" width="335" height="116">
              <frame id="I20606:117678;31049:18198" name="Text container" x="0" y="0" width="335" height="60">
                <frame id="I20606:117678;31232:3274" name="Label container" x="0" y="0" width="225" height="24">
                  <text id="I20606:117678;26891:2579" name="Label text" x="0" y="0" width="225" height="24" />
                  <slot id="I20606:117678;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117678;26891:2580" name="Format info" x="0" y="28" width="335" height="32" />
              </frame>
              <frame id="I20606:117678;26891:2581" name="Container" x="0" y="68" width="335" height="48">
                <frame id="I20606:117678;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117678;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117678;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117678;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
          <frame id="20606:117660" name="input publiseringsdato" x="1173" y="404" width="367" height="268">
            <frame id="20606:117661" name="Frame 1000001476" x="16" y="8" width="335" height="28">
              <text id="20606:117662" name="Content" x="0" y="0" width="233" height="28" />
            </frame>
            <instance id="20606:117663" name="DateInput" x="16" y="48" width="335" height="100">
              <frame id="I20606:117663;31049:18198" name="Text container" x="0" y="0" width="216" height="44">
                <frame id="I20606:117663;31232:3274" name="Label container" x="0" y="0" width="138" height="24">
                  <text id="I20606:117663;26891:2579" name="Label text" x="0" y="0" width="138" height="24" />
                  <slot id="I20606:117663;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117663;26891:2580" name="Format info" x="0" y="28" width="216" height="16" />
              </frame>
              <frame id="I20606:117663;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I20606:117663;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I20606:117663;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I20606:117663;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I20606:117663;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
            <instance id="21033:102412" name="DateInput" x="16" y="160" width="335" height="100">
              <frame id="I21033:102412;31049:18198" name="Text container" x="0" y="0" width="223" height="44">
                <frame id="I21033:102412;31232:3274" name="Label container" x="0" y="0" width="69" height="24">
                  <text id="I21033:102412;26891:2579" name="Label text" x="0" y="0" width="69" height="24" />
                  <slot id="I21033:102412;31232:3926" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I21033:102412;26891:2580" name="Format info" x="0" y="28" width="223" height="16" />
              </frame>
              <frame id="I21033:102412;26891:2581" name="Container" x="0" y="52" width="335" height="48">
                <frame id="I21033:102412;26891:2582" name="Field" x="0" y="0" width="335" height="48">
                  <text id="I21033:102412;26891:2583" name="Date input" x="12" y="15" width="226" height="18" hidden="true" />
                  <instance id="I21033:102412;31045:12806" name="Search icon" x="295" y="8" width="32" height="32" />
                </frame>
                <frame id="I21033:102412;27805:20448" name="focus" x="-2" y="-2" width="339" height="52" hidden="true" />
              </frame>
            </instance>
          </frame>
        </frame>
        <frame id="20606:117679" name="Opptaksgruppe section" x="24" y="2927" width="1544" height="396">
          <frame id="20606:117680" name="FilterList/FilterListSectionHead" x="16" y="8" width="1512" height="80">
            <frame id="20606:117681" name="Frame 1000002533" x="24" y="24" width="1360" height="32">
              <instance id="20606:117682" name="GitFork" x="0" y="0" width="32" height="32" />
              <text id="20606:117683" name="Utdanningsbakgrunner med avvikende frister" x="40" y="2" width="496" height="28" />
            </frame>
            <instance id="20606:117684" name="TagCustom" x="1392" y="24" width="80" height="32" />
            <frame id="20606:117685" name="FilterCount" x="261" y="5" width="35" height="30" hidden="true">
              <text id="20606:117686" name="1" x="14" y="2" width="7" height="24" />
            </frame>
            <instance id="20606:117687" name="Button" x="1480" y="24" width="32" height="32" />
            <rounded-rectangle id="20606:117688" name="Focus" x="0" y="0" width="1512" height="80" hidden="true" />
          </frame>
          <instance id="20606:117689" name="Button" x="16" y="100" width="326" height="48" />
          <frame id="20606:117690" name="Frame 1000002256" x="16" y="160" width="1512" height="228">
            <frame id="20606:117691" name="Søkergruppe" x="0" y="0" width="1512" height="228">
              <frame id="20606:117692" name="Frame 1000001598" x="12" y="8" width="1488" height="64">
                <frame id="20606:117693" name="Frame 1000002249" x="12" y="16" width="182" height="32">
                  <instance id="20606:117694" name="UsersThree" x="0" y="0" width="32" height="32" />
                  <text id="20606:117695" name="EU/EØS/Sveits" x="44" y="3.5" width="138" height="25" />
                </frame>
                <instance id="20606:117696" name="CaretUp" x="259" y="8" width="32" height="32" hidden="true" />
                <instance id="20606:117697" name="Button" x="1358" y="8" width="118" height="48" />
              </frame>
              <frame id="20606:117698" name="Frister" x="12" y="80" width="1488" height="136">
                <frame id="20606:117699" name="Frame 1000001599" x="12" y="12" width="196" height="28" hidden="true">
                  <text id="20606:117700" name="For søkergruppen" x="0" y="0" width="196" height="28" />
                </frame>
                <frame id="20606:117701" name="Frame 1000002251" x="12" y="12" width="682" height="100">
                  <frame id="20606:117702" name="Frame 1000002252" x="0" y="0" width="170" height="100">
                    <frame id="20606:117703" name="Frame 1000002255" x="0" y="0" width="262" height="40" hidden="true">
                      <text id="20606:117704" name="Kriterier for å inngå i gruppen" x="4" y="8" width="241" height="24" />
                    </frame>
                    <frame id="20606:117705" name="Frame 1000002253" x="0" y="0" width="170" height="48">
                      <text id="20606:117706" name="Utdanningsbakgrunn:  EU/EØS/Sveits" x="4" y="0" width="162" height="48" />
                    </frame>
                    <frame id="20606:117707" name="Frame 1000002256" x="0" y="52" width="170" height="48">
                      <text id="20606:117708" name="Nasjonalitet:  EU/EØS/Sveits" x="4" y="0" width="107" height="48" />
                    </frame>
                  </frame>
                  <frame id="20606:117709" name="Frame 1000001472" x="194" y="0" width="488" height="84">
                    <frame id="20606:117710" name="Frame 1000001477" x="0" y="0" width="240" height="84">
                      <instance id="20606:117711" name="Input/Date" x="0" y="0" width="240" height="84" />
                    </frame>
                    <frame id="20606:117712" name="Frame 1000001474" x="248" y="0" width="240" height="84">
                      <frame id="20606:117713" name="Frame 1000001477" x="0" y="0" width="240" height="84">
                        <instance id="20606:117714" name="Input/Date" x="0" y="0" width="240" height="84" />
                      </frame>
                    </frame>
                  </frame>
                </frame>
                <frame id="20606:117715" name="Frame 1000002250" x="1251" y="21" width="215" height="24">
                  <frame id="20606:117716" name="Frame 1000002234" x="0" y="0" width="215" height="24">
                    <text id="20606:117717" name="Slett utdanningsbakgrunn" x="0" y="0" width="187" height="24" />
                    <instance id="20606:117718" name="Delete" x="191" y="0" width="24" height="24" />
                  </frame>
                </frame>
              </frame>
            </frame>
          </frame>
        </frame>
        <frame id="20606:117719" name="Tekstforvaltning section" x="24" y="3347" width="1544" height="911.4296875">
          <instance id="20606:117720" name="Forvaltning accordion" x="0" y="0" width="1544" height="911.4296875">
            <frame id="I20606:117720;18858:24210" name="FilterList/FilterListSectionHead" x="3" y="3" width="1538" height="80">
              <frame id="I20606:117720;18943:153439" name="Frame 1000002533" x="24" y="24" width="1386" height="32">
                <instance id="I20606:117720;18858:24211" name="settings" x="0" y="0" width="32" height="32" />
                <text id="I20606:117720;18858:24212" name="Tekstforvaltning Min kompetanse" x="40" y="2" width="364" height="28" />
              </frame>
              <instance id="I20606:117720;18858:24213" name="TagCustom" x="1418" y="24" width="80" height="32" />
              <frame id="I20606:117720;18858:24214" name="FilterCount" x="261" y="5" width="35" height="30" hidden="true" />
              <instance id="I20606:117720;18858:24216" name="Button" x="1506" y="24" width="32" height="32" />
              <rounded-rectangle id="I20606:117720;18858:24217" name="Focus" x="0" y="0" width="1538" height="80" hidden="true" />
            </frame>
            <frame id="I20606:117720;18858:25392" name="Forvaltning tekst" x="3" y="95" width="1538" height="813.4296875">
              <text id="I20606:117720;18858:25394" name="Velg side i Min Kompetanse" x="24" y="24" width="224" height="24" />
              <instance id="I20606:117720;18858:25395" name="Tabs" x="24" y="72" width="748" height="48">
                <instance id="I20606:117720;18858:25395;26637:5361" name=".TabsAtom" x="0" y="0" width="147" height="48">
                  <instance id="I20606:117720;18858:25395;26637:5361;19743:1801" name="success" x="12" y="12" width="24" height="24" />
                  <text id="I20606:117720;18858:25395;26637:5361;19743:1802" name="Label" x="44" y="10" width="91" height="28" />
                  <slot id="I20606:117720;18858:25395;26637:5361;30120:2891" name="slot-1" x="64" y="12" width="72" height="24" hidden="true" />
                  <rounded-rectangle id="I20606:117720;18858:25395;26637:5361;30929:15427" name="Focus" x="-2" y="-2" width="152" height="53" hidden="true" />
                </instance>
                <instance id="I20606:117720;18858:25395;26637:5365" name=".TabsAtom" x="147" y="0" width="195" height="48">
                  <instance id="I20606:117720;18858:25395;26637:5365;19743:1797" name="alert" x="12" y="12" width="24" height="24" hidden="true" />
                  <text id="I20606:117720;18858:25395;26637:5365;19743:1798" name="Label" x="12" y="10" width="171" height="28" />
                  <slot id="I20606:117720;18858:25395;26637:5365;30120:3070" name="slot-4" x="64" y="12" width="72" height="24" hidden="true" />
                  <rounded-rectangle id="I20606:117720;18858:25395;26637:5365;30929:15449" name="Focus" x="-2" y="-2" width="200" height="53" hidden="true" />
                </instance>
                <instance id="I20606:117720;18858:25395;26637:5416" name="Tab 3" x="342" y="0" width="152" height="48">
                  <instance id="I20606:117720;18858:25395;26637:5416;19743:1797" name="Icon placeholder" x="12" y="12" width="24" height="24" hidden="true" />
                  <text id="I20606:117720;18858:25395;26637:5416;19743:1798" name="Label" x="12" y="10" width="128" height="28" />
                  <slot id="I20606:117720;18858:25395;26637:5416;30120:3070" name="slot-4" x="64" y="12" width="72" height="24" hidden="true" />
                  <rounded-rectangle id="I20606:117720;18858:25395;26637:5416;30929:15449" name="Focus" x="-2" y="-2" width="157" height="53" hidden="true" />
                </instance>
                <slot id="I20606:117720;18858:25395;27845:5439" name="slot" x="494" y="0" width="254" height="48">
                  <instance id="I20606:117720;18858:25395;27845:5439;20606:117761" name="Tab 4" x="0" y="0" width="153" height="48">
                    <instance id="I20606:117720;18858:25395;27845:5439;20606:117761;19743:1797" name="Icon placeholder" x="12" y="12" width="24" height="24" hidden="true" />
                    <text id="I20606:117720;18858:25395;27845:5439;20606:117761;19743:1798" name="Label" x="12" y="10" width="129" height="28" />
                    <slot id="I20606:117720;18858:25395;27845:5439;20606:117761;30120:3070" name="slot-4" x="64" y="12" width="72" height="24" hidden="true" />
                    <rounded-rectangle id="I20606:117720;18858:25395;27845:5439;20606:117761;30929:15449" name="Focus" x="-2" y="-2" width="158" height="53" hidden="true" />
                  </instance>
                  <instance id="I20606:117720;18858:25395;27845:5439;20606:117762" name="Tabs" x="153" y="0" width="101" height="48">
                    <instance id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5361" name="Tab 1" x="0" y="0" width="101" height="48">
                      <instance id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5361;19743:1797" name="Icon placeholder" x="12" y="12" width="24" height="24" hidden="true" />
                      <text id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5361;19743:1798" name="Label" x="12" y="10" width="77" height="28" />
                      <slot id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5361;30120:3070" name="slot-4" x="64" y="12" width="72" height="24" hidden="true" />
                      <rounded-rectangle id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5361;30929:15449" name="Focus" x="-2" y="-2" width="106" height="53" hidden="true" />
                    </instance>
                    <instance id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5365" name="Tab 2" x="68" y="0" width="68" height="48" hidden="true" />
                    <instance id="I20606:117720;18858:25395;27845:5439;20606:117762;26637:5416" name="Tab 3" x="136" y="0" width="68" height="48" hidden="true" />
                    <slot id="I20606:117720;18858:25395;27845:5439;20606:117762;27845:5439" name="slot" x="204" y="0" width="68" height="48" hidden="true" />
                  </instance>
                </slot>
              </instance>
              <instance id="I20606:117720;18890:118099" name="Select" x="24" y="144" width="423" height="80">
                <frame id="I20606:117720;18890:118099;27245:4004" name="Label" x="0" y="0" width="155" height="24">
                  <text id="I20606:117720;18890:118099;27245:4005" name="Label text" x="0" y="0" width="155" height="24" />
                  <slot id="I20606:117720;18890:118099;31232:4965" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                </frame>
                <text id="I20606:117720;18890:118099;25981:3468" name="Helper text" x="0" y="32" width="252" height="16" hidden="true" />
                <frame id="I20606:117720;18890:118099;25981:3469" name="Field" x="0" y="32" width="423" height="48">
                  <text id="I20606:117720;18890:118099;25981:3470" name="Valg" x="12" y="10" width="367" height="28" />
                  <instance id="I20606:117720;18890:118099;25981:3471" name="CaretDown" x="387" y="12" width="24" height="24" />
                  <frame id="I20606:117720;18890:118099;27845:1930" name="focus" x="-2" y="-2" width="427" height="52" hidden="true" />
                </frame>
              </instance>
              <frame id="I20606:117720;18858:25398" name="Frame 1000002511" x="24" y="248" width="1490" height="541.4296875">
                <instance id="I20606:117720;18858:25399" name="Tabs" x="25" y="25" width="263" height="48">
                  <instance id="I20606:117720;18858:25399;26637:5361" name=".TabsAtom" x="0" y="0" width="85" height="48">
                    <instance id="I20606:117720;18858:25399;26637:5361;19743:1801" name="confirm" x="12" y="12" width="24" height="24" hidden="true" />
                    <text id="I20606:117720;18858:25399;26637:5361;19743:1802" name="Label" x="12" y="10" width="61" height="28" />
                    <slot id="I20606:117720;18858:25399;26637:5361;30120:2891" name="slot-1" x="64" y="12" width="72" height="24" hidden="true" />
                    <rounded-rectangle id="I20606:117720;18858:25399;26637:5361;30929:15427" name="Focus" x="-2" y="-2" width="90" height="53" hidden="true" />
                  </instance>
                  <instance id="I20606:117720;18858:25399;26637:5365" name=".TabsAtom" x="85" y="0" width="91" height="48">
                    <instance id="I20606:117720;18858:25399;26637:5365;19743:1797" name="alert" x="12" y="12" width="24" height="24" hidden="true" />
                    <text id="I20606:117720;18858:25399;26637:5365;19743:1798" name="Label" x="12" y="10" width="67" height="28" />
                    <slot id="I20606:117720;18858:25399;26637:5365;30120:3070" name="slot-4" x="64" y="12" width="72" height="24" hidden="true" />
                    <rounded-rectangle id="I20606:117720;18858:25399;26637:5365;30929:15449" name="Focus" x="-2" y="-2" width="96" height="53" hidden="true" />
                  </instance>
                  <instance id="I20606:117720;18858:25399;26637:5416" name="Tab 3" x="176" y="0" width="87" height="48">
                    <instance id="I20606:117720;18858:25399;26637:5416;19743:1797" name="Icon placeholder" x="12" y="12" width="24" height="24" hidden="true" />
                    <text id="I20606:117720;18858:25399;26637:5416;19743:1798" name="Label" x="12" y="10" width="63" height="28" />
                    <slot id="I20606:117720;18858:25399;26637:5416;30120:3070" name="slot-4" x="64" y="12" width="72" height="24" hidden="true" />
                    <rounded-rectangle id="I20606:117720;18858:25399;26637:5416;30929:15449" name="Focus" x="-2" y="-2" width="92" height="53" hidden="true" />
                  </instance>
                  <slot id="I20606:117720;18858:25399;27845:5439" name="slot" x="204" y="0" width="68" height="48" hidden="true" />
                </instance>
                <instance id="I20606:117720;18890:118165" name="TextField" x="25" y="97" width="482" height="80">
                  <frame id="I20606:117720;18890:118165;26791:4774" name="Label container" x="0" y="0" width="133" height="24">
                    <text id="I20606:117720;18890:118165;26132:609" name="Label text" x="0" y="0" width="133" height="24" />
                    <slot id="I20606:117720;18890:118165;31218:4474" name="Tag slot" x="88" y="0" width="72" height="24" hidden="true" />
                  </frame>
                  <text id="I20606:117720;18890:118165;26132:611" name="Helper text" x="0" y="32" width="280" height="16" hidden="true" />
                  <frame id="I20606:117720;18890:118165;26132:612" name="Field" x="0" y="32" width="482" height="48">
                    <text id="I20606:117720;18890:118165;26132:613" name="Tekst he|" x="12" y="10" width="223" height="28" />
                    <frame id="I20606:117720;18890:118165;27805:15344" name="focus" x="-2.19921875" y="-2" width="486" height="52" hidden="true" />
                  </frame>
                </instance>
                <frame id="I20606:117720;18858:25402" name="TextField" x="25" y="201" width="1277" height="243.4296875">
                  <frame id="I20606:117720;18858:25403" name="Label" x="0" y="0" width="311" height="24">
                    <text id="I20606:117720;18858:25404" name="Informasjonstekst (Steg 1: Prioritering)" x="0" y="0" width="311" height="24" />
                    <instance id="I20606:117720;18858:25405" name="TagCustom" x="88" y="0" width="72" height="24" hidden="true" />
                  </frame>
                  <text id="I20606:117720;18858:25406" name="Denne teksten vises i søknadsflyten der søker skal prioritere studiealternativer" x="0" y="32" width="1277" height="16" />
                  <frame id="I20606:117720;18858:25407" name="Editor" x="0" y="56" width="398" height="41.4296875">
                    <rounded-rectangle id="I20606:117720;18858:25408" name="image 15" x="0" y="0" width="60.2060546875" height="37.4296875" />
                    <rounded-rectangle id="I20606:117720;18858:25409" name="image 16" x="60.2060546875" y="0.3046875" width="65.40185546875" height="36.8203125" />
                    <rounded-rectangle id="I20606:117720;18858:25410" name="image 17" x="125.60791015625" y="0" width="29.2861328125" height="37.4296875" />
                  </frame>
                  <frame id="I20606:117720;18858:25411" name="Field" x="0" y="105.4296875" width="1277" height="138">
                    <text id="I20606:117720;18858:25412" name="Tekst he|" x="12" y="21" width="667" height="96" />
                    <frame id="I20606:117720;18858:25413" name="focus" x="-2.19921875" y="-1.51953125" width="1281" height="142" hidden="true" />
                  </frame>
                </frame>
                <instance id="I20606:117720;18858:25414" name="Button" x="25" y="468.4296875" width="249" height="48" />
              </frame>
              <instance id="I20606:117720;18858:25415" name="Icon placeholder" x="60" y="27" width="13" height="13" hidden="true" />
            </frame>
          </instance>
        </frame>
      </frame>
    </frame>
    <frame id="20606:117721" name="Frame 1000001920" x="0" y="4500.4296875" width="1920" height="84">
      <text id="20606:117722" name="Endringer er lagret: 12:53" x="707" y="0" width="178" height="24" hidden="true" />
      <frame id="20606:117723" name="Frame 1000001926" x="813.5" y="18" width="293" height="48">
        <instance id="20606:117724" name="Button" x="0" y="0" width="102" height="48" />
        <instance id="20606:117725" name="Button" x="114" y="0" width="179" height="48" />
      </frame>
    </frame>
    <frame id="20606:117726" name="Footer" x="0" y="4592.4296875" width="1920" height="144.01760864257812">
      <frame id="20606:117727" name="Container" x="480" y="0" width="960" height="144.01760864257812">
        <frame id="20606:117728" name="Container" x="48" y="48" width="236.0290985107422" height="48.017601013183594">
          <frame id="20606:117729" name="Link" x="0" y="0" width="236.0290985107422" height="48.017601013183594">
            <frame id="20606:117730" name="Container" x="0" y="0" width="236.0290985107422" height="48.017601013183594">
              <frame id="20606:117731" name="SVG" x="0" y="0" width="75.03910064697266" height="48.017601013183594" />
              <frame id="20606:117734" name="Container" x="87.02909851074219" y="0.008800506591796875" width="149" height="48">
                <frame id="20606:117735" name="Container" x="0" y="0" width="149" height="16">
                  <text id="20606:117736" name="Sikt" x="0" y="0" width="28" height="16" />
                </frame>
                <frame id="20606:117737" name="Container" x="0" y="16" width="149" height="32">
                  <text id="20606:117738" name="Kunnskapssektorens tjenesteleverandør" x="0" y="0" width="149" height="32" />
                </frame>
              </frame>
            </frame>
          </frame>
        </frame>
        <frame id="20606:117739" name="Container" x="284.02911376953125" y="48" width="627.9708862304688" height="48.017601013183594">
          <frame id="20606:117740" name="Link" x="531.9708862304688" y="0" width="96" height="24">
            <text id="20606:117741" name="Endringslogg" x="0" y="0" width="96" height="24" />
          </frame>
          <frame id="20606:117742" name="Link" x="420.180908203125" y="23.8799991607666" width="207.7899932861328" height="24">
            <text id="20606:117743" name="Tilgjengelighetserklæring" x="0" y="0" width="183" height="24" />
            <frame id="20606:117744" name="Mask Group:align-center" x="186.99000549316406" y="0" width="20.799999237060547" height="24">
              <frame id="20606:117745" name="Mask Group" x="0" y="1.6000003814697266" width="20.799999237060547" height="20.799999237060547">
                <frame id="20606:117746" name="Mask" x="0" y="0" width="20.799999237060547" height="20.799999237060547">
                  <frame id="20606:117747" name="image fill" x="0" y="0" width="20.790000915527344" height="20.790000915527344">
                    <frame id="20606:117748" name="image" x="-0.009998321533203125" y="-0.0049991607666015625" width="20.799999237060547" height="20.799999237060547" />
                  </frame>
                </frame>
                <rounded-rectangle id="20606:117750" name="Background" x="0" y="0" width="20.790000915527344" height="20.790000915527344" />
              </frame>
            </frame>
          </frame>
        </frame>
      </frame>
    </frame>
  </frame>
</frame>IMPORTANT: After you call this tool, you MUST call get_design_context if trying to implement the design, since this tool only returns metadata. If you do not call get_design_context, the agent will not be able to implement the design.
```
