# Solar Empire — PROJEKT.md

**Läs den här filen i början av varje session. Uppdatera den i slutet.**

Idle-spel för iPhone. Spelaren bygger en solpark: trycker för att skapa energi,
säljer energi för pengar, köper uppgraderingar, tjänar pengar offline och
expanderar till nya länder (prestige). Mål: App Store-lansering inom 30 dagar,
intäkter via belönade annonser + köpet "Ta bort annonser".

**Ägare:** Jeton (entreprenör, kodar inte — Claude gör allt tekniskt).
**Startad:** 2026-07-19 (session 1).

---

## Status just nu

| Del | Status |
|---|---|
| Spelloop (tryck → energi → sälj → pengar) | ✅ Byggd |
| 10 uppgraderingar med stigande priser | ✅ Byggd |
| Offline-inkomst (max 8 tim, "Välkommen tillbaka"-ruta) | ✅ Byggd |
| Prestige (nytt land, +30 % permanent per land) | ✅ Byggd |
| Autospar (var 30:e sekund + när appen stängs) | ✅ Byggd |
| Låtsas-reklamannons → 2× produktion i 4 tim | ✅ Byggd |
| Köp "Ta bort annonser" (StoreKit 2 + lokal testconfig) | ✅ Byggd |
| Svenska + engelska (86 texter) | ✅ Byggd |
| Solnedgångsdesign, animationer, haptik, app-ikon | ✅ Byggd |
| **Byggd och testad i iPhone-simulatorn** | ⚠️ **EJ GJORT — session 1 kördes i en Linux-molnmiljö utan Xcode. Första prioritet nästa session: bygg i Xcode på Jetons Mac och rätta eventuella kompileringsfel.** |

## Så startas spelet (på en Mac)

1. Installera **Xcode** från Mac App Store (kräver Xcode 16 eller nyare — projektet använder det moderna projektformatet).
2. Hämta koden: grenen `claude/solar-empire-idle-game-akn240` i repot `jjnote15/driftiq-site`.
3. Dubbelklicka på `SolarEmpire/SolarEmpire.xcodeproj`.
4. Välj en iPhone-simulator uppe i mitten (t.ex. "iPhone 16").
5. Tryck på ▶ (Play). Klart.
6. Svenska: simulatorn följer systemspråket. Byt via Edit Scheme → Run → Options → App Language → Swedish.

Testköpet fungerar direkt i simulatorn tack vare `Products.storekit`
(redan vald i körschemat) — inga Apple-konton behövs.

## Arkitektur och filer

Allt ligger i `SolarEmpire/`. Inga externa beroenden — bara SwiftUI + StoreKit 2.
Minsta iOS-version: 17.0. Bundle-id: `com.driftiq.solarempire`.

```
SolarEmpire.xcodeproj        Xcode-projektet (synkad mapp — nya filer plockas upp automatiskt)
Products.storekit            Testkonfiguration för köpet (29 kr, non-consumable)
SolarEmpire/
  SolarEmpireApp.swift       Appstart; sparar när appen läggs i bakgrunden
  Models/GameState.swift     Allt som sparas (Codable → JSON)
  Models/Upgrades.swift      De 10 uppgraderingarna: pris, tillväxt, effekt
  Models/Countries.swift     Prestige-länderna (10 st, loopar sedan)
  Engine/GameEngine.swift    Spelmotorn: 10 Hz-timer, produktion, offline, prestige, boost
  Engine/SaveStore.swift     Läser/skriver save.json i Application Support
  Store/StoreManager.swift   StoreKit 2: ladda produkt, köp, återställ
  UI/Theme.swift             Solnedgångspalett + kortstil
  UI/Formatters.swift        Talformat (12.5 K, 3.1 M) + L.t() för översättningar
  UI/Haptics.swift           Haptisk feedback
  Views/ContentView.swift    Huvudskärm: rubrik, energimätare, sälj, knapprad, låtsasbanner
  Views/TapAreaView.swift    Den stora solen + flytande "+N"-siffror
  Views/UpgradesView.swift   Uppgraderingslistan
  Views/BoostView.swift      Boost-skärm + MockRewardedAdView (låtsasannonsen)
  Views/PrestigeView.swift   Expandera till nytt land
  Views/StoreView.swift      Köp/återställ "Ta bort annonser" (+ nollställningsknapp i testläge)
  Views/WelcomeBackView.swift "Välkommen tillbaka" med offline-inkomst
  Localizable.xcstrings      Alla 86 texter, en + sv
  Assets.xcassets            App-ikon (genererad solnedgång) + accentfärg
```

## Spelbalans (medvetna val)

- Tryck ger 1 energi (basvärde), 1 energi = 1 kr (basvärde).
- Uppgraderingspriser: `baspris × tillväxt^nivå` (klassisk idle-formel, t.ex. solpanel 15 kr × 1,15^nivå).
- Batteri begränsar lagrad energi (bas 100). Automatisk försäljning (5 000 kr) gör batteriet mindre viktigt — medveten morot.
- Offline: max 8 timmar per frånvaro; utan automation fylls batteriet, med automation blir det pengar direkt.
- Boost (annons): 2× produktion i 4 tim, kan förlängas genom att titta igen. Räknas inte under offline-tid (enkelhet).
- Prestige: kräver 1 miljon intjänat totalt i landet, ×8 per nytt land. Ger +30 % produktion permanent per land.
- Balansen är en första gissning — justeras efter speltest.

## Tekniska beslut

- **Ingen AdMob ännu:** `MockRewardedAdView` är låtsasannonsen. När AdMob kopplas in
  ersätts bara den vyn — belöningsanropet `engine.activateBoost()` behålls.
  "Ta bort annonser" döljer bannern men behåller belöningsannonser (branschstandard).
- **StoreKit 2 med lokal config:** `Products.storekit` är vald i det delade körschemat,
  så köpet kan testas utan App Store Connect. Om butiken visar "kunde inte laddas":
  Edit Scheme → Run → Options → StoreKit Configuration → välj filen.
- **Sparfil:** JSON i Application Support (inte UserDefaults) — lätt att versionera
  och felsöka. Sparas var 30:e sekund + vid bakgrund + efter viktiga händelser.
- **Offline-detektering:** lucka > 60 sekunder mellan timer-tick = appen var stängd/vilande.
- **Projektformat:** Xcode 16:s synkade mappar — nya Swift-filer i mappen läggs till
  automatiskt, inga projektfilskonflikter mellan sessioner.
- **Ikonen** är genererad med ett skript; duger gott för test,
  men bör ersättas med en proffsigare version innan lansering.

## 30-dagarsplan (prioriterad)

**Vecka 1 — Få igång och polera (nästa session börjar här)**
1. ⚠️ Bygg i Xcode på Jetons Mac, rätta eventuella kompileringsfel (koden är
   skriven "i blindo" i molnet — räkna med några små rättningar).
2. Testa hela loopen i simulatorn: tryck, sälj, alla 10 köp, låtsasannons,
   offline (stäng appen, vänta, öppna), prestige, köpet, återställ, språkbyte.
3. Justera spelbalansen efter känsla.

**Vecka 2 — Konton och riktig telefon** *(kräver Jeton: konto + pengar)*
4. Apple Developer Program, 99 USD/år — developer.apple.com. Behövs för test på
   riktig iPhone, TestFlight och App Store.
5. Kör på Jetons riktiga iPhone (haptiken känns bara där).
6. TestFlight: låt 5–10 vänner testa, samla feedback.

**Vecka 3 — Riktiga pengar** *(kräver Jeton: AdMob-konto)*
7. AdMob-konto (admob.google.com) + Google Mobile Ads SDK; ersätt MockRewardedAdView.
   Obs: kräver App Tracking Transparency-dialog eller enbart icke-spårade annonser.
8. App Store Connect: registrera appen + köpet "Ta bort annonser" på riktigt.
9. Integritetspolicy (krävs av både Apple och AdMob) — enkel sida, kan ligga på driftiq.se.

**Vecka 4 — Lansering**
10. App Store-material: skärmbilder, beskrivning (sv + en), nyckelord, ev. förbättrad ikon.
11. Apples granskning (räkna med 1–3 dagar + risk för en avvisning första gången).
12. Lansera. Därefter: mät, justera balans, planera uppdatering 1.1
    (fler länder-bonusar, statistik, ljud?).

## Sessionslogg

- **2026-07-19 (session 1):** Hela v1 byggd från noll i molnmiljö (Linux, utan Xcode).
  All kod, design, språk, ikon, StoreKit-config klar och kvalitetskontrollerad
  (JSON/XML validerad, alla översättningsnycklar korskollade, syntax-sanity).
  **Ej byggt i riktig Xcode ännu** — det är första steget nästa session.
