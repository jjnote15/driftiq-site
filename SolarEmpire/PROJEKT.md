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
| Bygget verifierat med riktig Xcode | ✅ Grönt på första försöket (GitHub Actions, 2026-07-19) |
| Spelet genomspelat/testat av människa | ⚠️ Återstår — Jeton testar via appetize.io (se nedan) |

## Viktigt: Jeton har PC, ingen Mac

Xcode och iPhone-simulatorn finns bara på Mac. Lösningen (uppsatt och fungerande):

- **Bygget:** GitHub Actions bygger appen automatiskt på GitHubs gratis Mac-servrar
  vid varje push som rör `SolarEmpire/` (workflow: `.github/workflows/solar-empire-build.yml`).
  Claude ser byggloggar och rättar fel direkt från molnsessionen. Repot är publikt
  → obegränsade gratisbyggen.
- **Spela/testa på PC:** varje grönt bygge sparar artefakten `SolarEmpire-Simulator`
  (zip med `SolarEmpire.app`). Den kan köras i webbläsaren via **appetize.io**
  (gratis konto): ladda ned artefakten från byggets sida på GitHub → packa upp det
  yttre zippet → ladda upp `SolarEmpire-Simulator.zip` på appetize → välj iPhone → spela.
- **Begränsningar i webbläsartestet:** ingen haptik (vibrationer), och köpet
  "Ta bort annonser" kan inte testas där — StoreKit-testconfigen aktiveras via
  Xcodes körschema och följer inte med i den råa appfilen. Sparfilen nollställs
  också ofta mellan appetize-sessioner. Allt annat (spelloop, uppgraderingar,
  låtsasannons, prestige, språk) går att testa i webbläsaren.
- **Fullständigt köptest** kräver antingen en Mac med Xcode (hyrd moln-Mac, t.ex.
  MacinCloud, ~kaffepengar per timme) eller vänta till TestFlight med riktig
  App Store Connect-produkt (sandbox-köp funkar då på riktig iPhone).

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

## Retentionpaketet v1.1 ("beroendepaketet", byggt på Jetons order: inga restriktioner)

- **Nästa mål-raden:** huvudskärmen visar alltid billigaste köpbara uppgradering med
  progressbar — det finns alltid något att spara till. Lyser gul när man har råd.
- **Milstolpar:** platta uppgraderingar (paneler, celler, solföljare, AI, batteri)
  dubblar sin effekt permanent vid var 10:e nivå. Visas som "7/10 till ×2" i listan.
- **Gyllene solen:** dyker upp slumpmässigt (första gången efter 45–90 s, sedan var
  2–5 min), försvinner efter 6 s. Träffar man den: SOLRUSCH ×5 produktion i 30 s.
- **Kritiska tryck:** 5 % chans att ett tryck ger ×10 med stor visuell explosion.
- **Dubbla mot annons:** både "Välkommen tillbaka"-rutan (offline-inkomst) och
  dagliga bonusen har "Se annons → få dubbelt" (låtsasannonsen, AdMob senare).
  Detta är genrens mest lönsamma annonsplacering.
- **Daglig bonus-svit:** dag 1–7, belöning skalar med dag och produktion
  (min 100 kr, ~4 min produktion × dagnummer). Dag 7+: även 1 tim dubbel produktion.
  Missad dag nollställer sviten. Detta är mekaniken som ska driva dag 2-retention.
- Etisk gräns (medvetet vald): inga betalväggar, ingen kasinomekanik med riktiga
  pengar, inga notisspam. Standardmekanik som Apple godkänner.

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

## 30-dagarsplan (prioriterad, anpassad för PC-ägare)

**Vecka 1 — Speltesta och polera (nästa session börjar här)**
1. Jeton spelar via appetize.io (instruktioner ovan) och ger feedback på känsla,
   balans och design. Claude justerar och bygger om (varje push → nytt grönt bygge).
2. Justera spelbalansen efter känslan (uppgraderingspriser, prestige-tröskel).

**Vecka 2 — Apple-konto och riktig iPhone** *(kräver Jeton: konto + pengar)*
3. Apple Developer Program, 99 USD/år — developer.apple.com. Går att registrera
   från PC:n i webbläsaren. Behövs för TestFlight och App Store.
4. Sätt upp signering + TestFlight-uppladdning i GitHub Actions (fastlane eller
   Codemagic) — då kan Jeton testa på sin riktiga iPhone utan Mac, och haptiken
   går äntligen att känna. Sandbox-köpet testas här.
5. TestFlight: låt 5–10 vänner testa, samla feedback.

**Vecka 3 — Riktiga pengar** *(kräver Jeton: AdMob-konto)*
6. AdMob-konto (admob.google.com) + Google Mobile Ads SDK; ersätt MockRewardedAdView.
   Obs: kräver App Tracking Transparency-dialog eller enbart icke-spårade annonser.
7. App Store Connect: registrera appen + köpet "Ta bort annonser" på riktigt.
8. Integritetspolicy (krävs av både Apple och AdMob) — enkel sida, kan ligga på driftiq.se.

**Vecka 4 — Lansering**
9. App Store-material: skärmbilder, beskrivning (sv + en), nyckelord, ev. förbättrad ikon.
10. Inskickning till Apple via CI (fastlane deliver) eller hyrd moln-Mac vid behov.
    Apples granskning: räkna med 1–3 dagar + risk för en avvisning första gången.
11. Lansera. Därefter: mät, justera balans, planera uppdatering 1.1
    (fler länder-bonusar, statistik, ljud?).

## Sessionslogg

- **2026-07-19 (session 1):** Hela v1 byggd från noll i molnmiljö (Linux, utan Xcode).
  All kod, design, språk, ikon, StoreKit-config klar och kvalitetskontrollerad
  (JSON/XML validerad, alla översättningsnycklar korskollade, syntax-sanity).
- **2026-07-19 (session 1, forts):** Jeton har PC, ingen Mac. Satte upp GitHub
  Actions-bygge på gratis Mac-servrar. **Första bygget grönt utan ett enda
  kompileringsfel** (run #1). Spelbar simulator-app sparas som artefakt vid varje
  bygge; Jeton testar via appetize.io. Plan omskriven för Mac-fri väg till lansering.
  Stabil nedladdningslänk utan inloggning:
  https://github.com/jjnote15/driftiq-site/releases/download/simulator-latest/SolarEmpire-Simulator.zip
- **2026-07-19 (session 1, forts 2):** Jeton testade spelet live på appetize —
  hela kedjan funkar. Ärligt marknadssamtal: organisk succé osannolik, projektet
  är en billig marknadsutbildning + app-fabrik; mätgrind satt (dag 2/3-retention
  i TestFlight avgör ev. annonsbudget). Därefter byggdes retentionpaketet v1.1
  (se ovan) på Jetons klartecken "inga restriktioner". Gamla sparfiler
  är kompatibla (GameState avkodar nu med standardvärden för nya fält).
