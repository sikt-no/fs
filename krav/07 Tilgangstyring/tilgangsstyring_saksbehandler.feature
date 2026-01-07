# language: no

Egenskap: Tilgangstyring av saksbehandler

Scenario: Saksbehandler logger inn og får tilgang til å saksbehandle søknader
Gitt administratoren er på hovedsiden til adminflaten
Og administratoren er autorisert saksbehandler
Når administratoren går inn på søknadsbehandling siden
Og velger å saksbehandle et opptak
Så skal administratoren se søknadene på opptaket

Scenario: Uautorisert administrator logger inn og får ikke tilgang til å saksbehandle søknader
Gitt administratoren er på hovedsiden til adminflaten
Og administratoren IKKE er autorisert saksbehandler
Når administratoren går inn på søknadsbehandling siden
Og velger å saksbehandle et opptak
Så skal administratoren IKKE se søknadene på opptaket

