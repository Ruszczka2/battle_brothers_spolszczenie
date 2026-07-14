# Pełne Spolszczenie Battle Brothers

Uwaga! Żeby upewnić się, że spolszczenie będzie działało prawidłowo, należy pobrać mod **[Modding Script Hooks](https://www.nexusmods.com/battlebrothers/mods/42)**. Instrukcja znajduje się w sekcji *Instalacja*.

Ten projekt jest dokończeniem spolszczenia przygotowanego przez Daedalusa. Udało mi się dokończyć tłumaczenie:
- Opisy końcowe ambicji
- Biografie postaci

Oraz przetłumaczyć wszystkie:
- Wydarzenia
- Opisy kontraktów

## Wymagania

- **Battle Brothers 1.5.2.3** (lub nowszy patch z tej linii)
- **Modding Script Hooks** — wymagane dla 32 skryptów `!mods_preload` (dynamiczne tłumaczenia nazw umiejętności, przedmiotów itd.). Bez tego mod działa, ale część tekstów zostanie po angielsku.

## Instalacja

1. Pobierz `data_PL.dat` z [GitHub Releases](https://github.com/Ruszczka2/battle_brothers_spolszczenie/releases).
2. Pobierz i zainstaluj **Modding Script Hooks** (plik `.zip` z Nexus Mods #42).
3. Skopiuj oba pliki do `Battle Brothers\data\` (nadpisz stary `data_PL.dat`, jeśli istnieje).
4. **Nie rozpakowuj** archiwów — gra ładuje pliki `.dat` / `.zip` bezpośrednio.

## Budowa paczki (dla deweloperów)

```powershell
# 1. Skompiluj wszystkie .nut → .cnut (sq + szyfrowanie bbsq)
# 2. Spakuj:
python E:\Programy\bbtranslate\build_dat.py
# Wynik: build\data_PL.dat
```

Narzędzia: `adamskit\bin\sq.exe`, `adamskit\bin\bbsq.exe`.

Weryfikacja przed release:

```powershell
python scan_continue_loops.py      # oczekiwane: 0 hitów
python compare_vs_game.py          # oczekiwane: 0 brakujących funkcji vs data_001.dat
```

## Changelog

### v1.2 — fix crash ok. 60–70 dnia (kryzys końcowy)

- Normalizacja pętli w `factions/faction_manager.nut` (ścieżka `updateGreaterEvil` / `breakNobleHouseAlliances`), żeby uniknąć zawieszenia przy starcie fazy Warning/Live (~dzień 50–80).
- Weryfikacja zgodności ze skryptami gry 1.5.2.3 (`compare_vs_game.py` → 0 mismatchów).
- Zgłoszenie: crash podczas podróży karawaną ok. 60. dnia (Edfit).

## Źródło

Pierwotne spolszczenie: https://www.nexusmods.com/battlebrothers/mods/335

## Screenshoty

![Screenshot gry](screenshots/event1.png)

![Screenshot gry](screenshots/event2.png)

![Screenshot gry](screenshots/contract.png)

## Autor

Tłumaczenie główne:
**Daedalus**  
[daedalus.pl@gmail.com](mailto:daedalus.pl@gmail.com)

Dokończenie tłumaczenia:
**Ruszczka**  
[ruszczka22@gmail.com](mailto:ruszczka22@gmail.com)
