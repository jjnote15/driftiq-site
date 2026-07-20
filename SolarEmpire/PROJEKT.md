# Solar Empire — PROJEKT.md

**Läs den här filen i början av varje session. Uppdatera den i slutet.**

## ⚠️ LÄS DETTA FÖRST: projektet är i en riktningspaus

Solar Empire v1–v1.3 (idle-klickspel om en solpark) är **fullt byggt, testat och
fungerande** — se status och arkitektur nedan. Men i slutet av session 1 kom
Jeton och Claude fram till att ett rent idle-klickspel troligen **inte kommer
sälja eller behålla spelare på den nivå Jeton siktar på** ("Top-notch,
världsnivå", betalvilja ~100 kr, "man kan bara inte låta bli att öppna spelet").

Vi utforskar därför just nu **en ny spelriktning**, inspirerad av två förebilder:
**Josef Fares/Hazelight** (It Takes Two, Split Fiction — se "Pivot-diskussionen")
och **King/Candy Crush Saga** (Sebastian Knutsson — se "King-analysen", tillagd
session 2). Två skissade koncept finns: TVÅ och MELLAN. **Inget beslut är
taget.** Jeton skulle fundera vidare och eventuellt testa pitchar på riktiga
människor. **Nästa session ska börja med att fråga Jeton var han landade**,
inte anta att Solar Empire eller något av de skissade koncepten är valt.
Om ett nytt koncept väljs blir det sannolikt ett nytt projekt/mapp — Solar
Empire-koden och hela CI/bygginfrastrukturen fredas och återanvänds tekniskt
(se "Tekniska beslut"), men spelet, namnet och designen kan bytas helt ut.

Idle-spelet i sin nuvarande form: spelaren bygger en solpark, trycker för att
skapa energi, säljer energi för pengar, köper uppgraderingar, tjänar pengar
offline och expanderar till nya länder (prestige).

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

## Ljud & personlighet v1.2

- **Ljudeffekter:** 6 st, syntetiserade med skript (`gen_sounds.py` i scratchpad,
  kan genereras om) — tap (mjukt plopp), sell (ka-ching), buy (dunk+pling),
  crit (stigande burst), golden (mystisk arpeggio när gyllene solen dyker upp),
  reward (fanfar för solrusch/daglig/boost/prestige). Ligger i `SolarEmpire/Sounds/`.
  Spelas via `Sound.swift` (AVAudioPlayer-pooler). Ljudkategori `.ambient`:
  respekterar ljudlös-knappen och stoppar inte spelarens egen musik.
  Ingen mute-knapp i appen ännu (ljudlös-knappen räcker i v1) — kandidat till 1.1-uppdateringen.
  Obs: ljud hörs dåligt/inte alls på appetize beroende på webbläsare — riktigt test på iPhone.
- **Personlighet:** alla 10 uppgraderingsbeskrivningar + välkomst-/batteritexter
  omskrivna med torr humor (sv + en). Tonen: underfundig chefen-för-solimperiet-humor,
  aldrig fånig. Exempel: Rengöringsrobotar – "Fågelbajs, möt din nemesis."

## Den synliga parken v1.3 (Jetons idé: "tänk om man kunde se vad man bygger")

- `ParkView` på huvudskärmen, under solen: en levande bild av parken som växer
  med varje köp. Solpaneler ritas en per nivå (max 18 + "+N"-räknare),
  solföljare som 🌻, batterier som mätare **som fylls synligt med lagrad energi**,
  patrullerande robot 🤖 (rengöring/autosälj), blinkande AI-antenn, väderstation,
  landets flagga. Nya köp poppar in med fjäderanimation. Panelerna glöder när
  parken producerar. Allt ritat i kod (SF Symbols + former + emoji), inga bildfiler.
- Solen krymptes något (280→236 pt glöd) för att ge parken plats.

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

## Pivot-diskussionen (session 1, forts 3) — läs detta innan du planerar nästa steg

**Utlösande fråga från Jeton:** "hade du betalt för att spela denna [Solar Empire]?"
Claudes ärliga svar: nej — trots retentionmekanik (v1.1), ljud/humor (v1.2) och
en synlig växande park (v1.3) är kärnhandlingen ("tryck på en knapp, se siffror
växa") en handelsvara. Polish kan inte kompensera för att grundmekaniken saknar
skicklighet, spänning eller spektakel. Jeton höll med: "det är inget kul eller
engagerande spel — bara en massa klickande på en sol."

**Jetons kravbild för nästa försök:**
- Tidlöst (talar till människan) + samtida (relaterbart till vår tid) på samma gång
- Psykologiska beroendemekanismer inbyggda i kärnan, inte pålagda
- Starkt visuellt — "captivating", "glues them to the screen"
- Prisnivå ~100 kr (premium, inte free-to-play-annonser)
- Jeton refererade explicit till **Josef Fares / Hazelight** (It Takes Two, A Way
  Out, Split Fiction) som förebild och skickade en detaljerad analys av deras
  framgångsfaktorer (finns i sin helhet i chatthistoriken, sammanfattat här).

**Fares-principerna (destillerade, källa: Jetons analys + Claudes tillägg):**
1. Obligatoriskt beroende av en annan människa (inte nödvändigtvis samma skärm/rum —
   se diskussionen om sync vs. async nedan) → delad sårbarhet, delad agens.
2. Mekanisk variation / ingen grinding — ny mekanik i nästan varje kapitel, aldrig
   återanvänd länge nog för att bli tråkig.
3. Ludonarrativ resonans — det spelaren gör med fingrarna ska spegla vad
   karaktärerna känner/upplever i berättelsen.
4. Kompromisslös nisch — designa 100 % för en specifik upplevelse (t.ex. "bara två
   personer"), inte "hyfsat bra" för alla.
5. Generositet som spridningsmotor — en betalar, en (eller fler) spelar gratis
   ("Friend's Pass") → köparen blir självmotiverad ambassadör.

**Koncept 1 — "TVÅ" (föreslaget av Claude, sedan ifrågasatt):**
Samma iPhone, delad skärm, två tummar, omöjligt att spela ensam. Asymmetriska
mekaniker per kort kapitel (gyroskop, viskning i mikrofon, delade hörlurar för
info-asymmetri i ena örat vardera, m.m.). Ordlös berättelse om två ljusvarelser.
Gratis nedladdning, episod 1–3 gratis, engångsköp ~99–129 kr låser upp resten
(köparens vän spelar gratis på samma telefon).

**Jetons invändning (viktig, giltig):** samma-skärm begränsar när/var/med vem
man kan spela. Fares kommer undan med det för att hans spel är 10–15-timmars
soffupplevelser; mobil lever på återkommande, portabelt spelande. "Samma skärm"
är transportlager, inte kärnprincip — man kan hålla fast vid principerna 1–5
utan att kräva fysisk närhet.

**Koncept 2 — "MELLAN" (Claudes svar på invändningen, oprövat):**
Asynkront tvåsamhet. Jeton + en specifik person (partner, förälder, bästa vän)
delar en värld ingen av dem ser hela av. Man spelar var för sig, när man vill —
men lämnar spår, nycklar, gåvor i den andres halva (jag vrider en nyckel i
morse → du kan öppna en dörr i kväll). Konversationen ("öppnade du porten?!")
sker i verkligheten, inte i appen. Bygger på CloudKit (gratis, Apple-inbyggt,
ingen egen server) för datadelning mellan två enheter. Retentionkroken: en
människa man bryr sig om väntar på en — samma mekanism som gör Snapchat/streaks
beroendeframkallande, men i en varm/relationell form i stället för manipulativ.
Samma Friend's Pass-affärsmodell (ett par-köp låser upp för båda).

**Öppna frågor Jeton skulle fundera på (svara på dessa när ni återupptar):**
1. Vem ska sakna spelet om det försvinner? (Par? Vänner? Familj över avstånd?
   Svaret styr ton, svårighetsgrad och marknadsföring.)
2. Sync (samma rum, intensivt, "TVÅ") eller async (över avstånd, dagligt, "MELLAN")
   — eller ett tredje koncept Jeton själv kommer på? v1 bör välja EN riktning
   kompromisslöst (Fares-princip 4), inte försöka bli bra på båda.
3. Jeton skulle testa en enmenings-pitch på 5 riktiga personer och observera
   reaktionen — det är billigare och mer tillförlitlig data än fortsatt
   brainstorming i chatten.

**Status vid pausen:** inget koncept är valt. Ingen kod skriven för det nya
spelet. Solar Empire v1–v1.3 ligger orörd och fungerande i repot om Jeton
väljer att ändå gå vidare med idle-spelet, eller om delar (CI, StoreKit,
språksystem, ljudmotor) ska återanvändas i ett nytt projekt.

## King-analysen (session 2, 2026-07-20) — andra förebilden: Candy Crush Saga

Jeton skickade en detaljerad analys av hur King (Sebastian Knutsson m.fl.)
byggde Candy Crush Saga. Uppdraget: fortsätt utveckla konceptet — bygg inget.
Detta avsnitt destillerar King-principerna, ställer dem mot Fares-principerna
och drar slutsatser för TVÅ och MELLAN.

**King-principerna (destillerade ur Jetons analys):**
1. **Juiciness** — varje lyckad handling belönas överdrivet: partiklar, skärmskak,
   ljus, tillfredsställande ljud ("Delicious!"). Objekten designas glansiga/"blöta"
   för att vara maximalt attraktiva för ögat. Universellt tema som väcker omedelbart
   positiva känslor hos alla åldrar och kulturer.
2. **Socialt kapital** — vänner synliga på kartan (tävlingsinstinkt: "förbi grannen"),
   be vänner om liv (gratis viral spridning). Andra människor är retentionmotorn.
3. **Kontrollerad frustration** — artificiell brist (5 liv, 30 min väntan per liv)
   förhindrar mättnad, skapar längtan och daglig vana. Monetiseringen säljer **tid,
   inte framgång**: betala för att fortsätta *just nu*, inte för att vinna.
4. **Near-miss** — banor designade så man ofta faller på målsnöret ("ett drag ifrån").
   Medveten växling svår/lätt bana: frustration gör lättnaden vid seger mycket
   starkare — det är *den känslan* spelaren betalar för med boosters.
5. **Datadriven svårighetsgrad (LiveOps)** — spåra exakt var spelare fastnar och
   slutar; justera banor i realtid via molnuppdatering; A/B-testa allt. Spelet är
   aldrig "klart", det balanseras kontinuerligt på gränsen utmanande/uppgivet.

**Var Fares och King är ÖVERENS (→ obligatoriska krav på vårt koncept, oavsett riktning):**
- **Andra människor är den starkaste kroken.** Fares gör det genom obligatoriskt
  co-op-beroende; King genom grannen på kartan och liv från vänner. Båda företagen
  byggde sin succé på att en verklig människa drar dig tillbaka in i spelet.
  Detta validerar kärnan i både TVÅ och MELLAN.
- **Känslomässig bergochdalbana.** Fares: mekanikbyten + narrativa kontraster.
  King: svår bana → lätt bana, frustration → lättnad. Ett spel som håller jämn
  känslonivå tappar spelare. Konceptet måste designa kontrast medvetet.
- **Kompromisslös polish i feedbacken.** Fares spektakel = Kings juiciness.
  Solar Empire-lärdomen bekräftas från två håll: polish räddar inte en tom kärna,
  men en bra kärna utan juiciness når aldrig sin potential. Budgetera juiciness
  som kärnfunktion, inte som yta i slutet.
- **En betalar, fler dras in.** Fares Friend's Pass = Kings vän-inbjudningar.
  Spridningsmotorn ska vara inbyggd i spelet, inte köpt via annonser.

**Var de är OFÖRENLIGA (→ val Jeton måste göra):**
- **Affärsmodell.** King säljer lindring av frustration de själva skapat
  (energisystem, betalväggar) — kräver F2P och massiv volym. Fares säljer en
  generös premiumupplevelse en gång (~100 kr) och vägrar mikrotransaktioner.
  Ett energisystem i ett 100-kronorsspel vore ett löftesbrott mot köparen —
  de två modellerna kan inte blandas rakt av.
- **Vem bestämmer designen.** King låter data ändra spelet (bana 12 för svår →
  sänk den). Fares är auteur — visionen kompromissas inte av telemetri.
  Medelväg finns (data justerar *balans*, aldrig *vision*), men default måste väljas.
- **Relationen till spelarens tid.** King vill maximera återkommande sessioner i
  åratal (vana). Fares vill ge en avslutad, minnesvärd upplevelse (10–15 tim, slut).
  MELLAN lutar åt King här (daglig vana), TVÅ åt Fares (intensiv, ändlig).

**Vad King-linsen säger om de två koncepten:**
- **MELLAN stärks mest.** Viktigaste insikten i hela analysen: MELLAN har redan
  ett "liv-system" — men ett naturligt och mänskligt i stället för artificiellt.
  Du kan inte fortsätta förrän den andra personen gjort sitt drag. Samma psykologi
  som Kings 30-minuterstimer (paus → längtan → vana → återkomst), men bristen
  går inte att köpa bort och skapas av en människa du bryr dig om, inte av en
  timer som vill åt ditt kort. King bevisar att mekanismen fungerar i miljardskala;
  MELLAN gör den varm i stället för cynisk.
  Fler King-mekaniker som mappar direkt på MELLAN:
  - *Delad svit* i stället för individuell streak: "er dag 12 tillsammans" —
    dubbel förlustaversion, man sviker en person, inte en siffra (Snapchat-streaks
    bevisar styrkan; Kings dagliga bonus är samma mekanik solo).
  - *Near-miss i async-form:* "nyckeln du fick passade nästan — en kugge fattas,
    den finns i hennes halva" → tvingar fram samtalet i verkligheten ("kolla
    i tornet ikväll!"), vilket är exakt den krok konceptet lever på.
  - *Juiciness på överlämningarna:* ögonblicket när den andres gåva/spår dyker upp
    i din värld ska vara spelets mest överdådiga effekt (Kings "Delicious!"-ögonblick).
- **TVÅ påverkas mindre.** Juiciness och near-miss gäller, men samma-soffa-sync
  har ingen naturlig plats för Kings vane-/pausmekanik — det är en ändlig
  upplevelse à la Fares. King-analysen ger alltså inget nytt argument för TVÅ,
  och Jetons tidigare invändning (begränsad räckvidd på mobil) står kvar.
  Sammantaget pekar nu båda förebilderna åt MELLAN-hållet — men beslutet är Jetons.

**Monetisering — tre vägar (ny öppen fråga, kravbilden ~100 kr behöver bekräftas eller revideras):**
- **A) Ren premium (Fares):** 99–129 kr engångsköp + Friend's Pass (partnern
  spelar gratis). King-lärdomarna används enbart för retention, inte intäkt.
  Enklast, ärligast, men taket är lägre och all intäkt tas dag 1.
- **B) Hybrid (rekommenderas att utreda vidare):** gratis nedladdning, kapitel 1–3
  gratis, engångsköp (~99–129 kr per *par*) låser resten — plus **gåvo-köp**:
  små kosmetiska saker man bara kan köpa *till den andre* (aldrig till sig själv).
  Det är Kings intäktspsykologi (betala i ett känsloladdat ögonblick) omvänd till
  generositet i stället för frustrationslindring. Ingen energi, inga annonser,
  inget pay-to-win — bör klara både App Store-granskning och den varma tonen.
  Troligen unik mekanik på marknaden = marknadsföringsvinkel i sig.
- **C) Ren F2P (King):** kräver energisystem/annonser/booster-ekonomi och
  miljonvolym för att bära sig. Krockar frontalt med varm ton, premiumambition
  och tvåpersonskärnan. Avråds — noteras bara för fullständighet.

**LiveOps-lärdomen (gäller ALLA riktningar, även ren premium):**
- Bygg in analytics från dag 1: var i kapitlen slutar folk, hur ofta öppnas appen,
  hur lång tid mellan de två spelarnas drag. Utan data famlar vi som med Solar Empire.
- Soft-launch i ett litet land (King-standard; t.ex. Nya Zeeland/Norden) och mät
  D1/D7/D30-retention *innan* pengar läggs på marknadsföring — detta ersätter
  den gamla TestFlight-mätgrinden som beslutspunkt.
- Datans roll: justera *balans och friktion* (var folk fastnar), aldrig *vision
  och ton* (auteur-linjen behålls). Kapitel ska kunna ombalanseras via
  serverflagga/uppdatering utan ny App Store-granskning där det går.

**Uppdaterade öppna frågor till Jeton (ersätter listan i Pivot-avsnittet):**
1. Vem ska sakna spelet om det försvinner? (Par? Vänner? Familj över avstånd?)
2. Sync (TVÅ) eller async (MELLAN) — eller ett eget tredje koncept?
   Båda förebilderna pekar nu mot async/MELLAN, men valet är inte taget.
3. Enmenings-pitchen på 5 riktiga personer — gjord? Vad blev reaktionerna?
4. **Ny:** Affärsmodell A, B eller C ovan? (Påverkar designen i grunden och
   måste väljas före första spelbara prototyp.)
5. **Ny:** Står ~100 kr-premiumkravet fast, eller öppnade King-analysen för
   hybrid (gratis in, betala för att fortsätta + gåvo-köp)?

## 30-dagarsplan (prioriterad, anpassad för PC-ägare) — PAUSAD, gäller endast om Solar Empire återupptas som den är

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
  Kompileringsfel åtgärdat efter run #4 (ternary mellan olika knappstilar).
  Därefter v1.2: ljudeffekter + humoristiska texter (se ovan) efter ärlig
  "hade du betalat?"-diskussion — nej: saknade personlighet, ljud och djup.
  Kvarstår för "kanske betala": mer innehållsdjup (achievements, landsbonusar).
  Stabil nedladdningslänk utan inloggning:
  https://github.com/jjnote15/driftiq-site/releases/download/simulator-latest/SolarEmpire-Simulator.zip
- **2026-07-19 (session 1, forts 2):** Jeton testade spelet live på appetize —
  hela kedjan funkar. Ärligt marknadssamtal: organisk succé osannolik, projektet
  är en billig marknadsutbildning + app-fabrik; mätgrind satt (dag 2/3-retention
  i TestFlight avgör ev. annonsbudget). Därefter byggdes retentionpaketet v1.1
  (se ovan) på Jetons klartecken "inga restriktioner". Gamla sparfiler
  är kompatibla (GameState avkodar nu med standardvärden för nya fält).
- **2026-07-19 (session 1, forts 3 — PIVOT-PAUS):** Jeton testade v1.2/v1.3 och
  svarade ärligt: inte köpvärt, "bara klickande på en sol". Öppnade en bredare
  diskussion om Josef Fares/Hazelight-designfilosofi som förebild, ~100 kr
  prisnivå och "world-class"-ambition. Claude föreslog co-op-koncept "TVÅ"
  (samma skärm); Jeton ifrågasatte klokt att samma-skärm begränsar räckvidden.
  Claude föreslog async-alternativet "MELLAN". **Ingen riktning vald.** Jeton
  skulle fundera vidare/testa pitchar på riktiga personer. Se "Pivot-diskussionen"
  ovan för fullt resonemang och öppna frågor. Nästa session: fråga var Jeton
  landade innan något byggs.
- **2026-07-20 (session 2 — konceptarbete, inget byggt):** Jeton skickade en
  King/Candy Crush-analys (Knutsson: juiciness, socialt kapital, kontrollerad
  frustration, near-miss, datadriven svårighetsgrad) som andra förebild vid
  sidan av Fares, med uppdraget "fortsätt utveckla konceptet utan att bygga".
  Claude skrev "King-analysen" (ovan): var King/Fares är överens (människor som
  krok, känslokontrast, juiciness, inbyggd spridning) respektive oförenliga
  (affärsmodell, data vs auteur, vana vs avslutad upplevelse). Central slutsats:
  MELLAN:s vänta-på-den-andre-mekanik är Kings liv-system i naturlig, mänsklig
  form — båda förebilderna pekar nu mot MELLAN. Tre monetiseringsvägar skissade
  (premium / hybrid med gåvo-köp / F2P), hybrid B rekommenderad att utreda.
  Öppna frågor uppdaterade (5 st, inkl. affärsmodellsval). **Fortfarande inget
  koncept formellt valt — invänta Jetons besked.**
