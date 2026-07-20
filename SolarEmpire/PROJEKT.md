# Solar Empire — PROJEKT.md

**Läs den här filen i början av varje session. Uppdatera den i slutet.**

## ⚠️ LÄS DETTA FÖRST: projektet är i en riktningspaus

Solar Empire v1–v1.3 (idle-klickspel om en solpark) är **fullt byggt, testat och
fungerande** — se status och arkitektur nedan. Men i slutet av session 1 kom
Jeton och Claude fram till att ett rent idle-klickspel troligen **inte kommer
sälja eller behålla spelare på den nivå Jeton siktar på** ("Top-notch,
världsnivå", betalvilja ~100 kr, "man kan bara inte låta bli att öppna spelet").

Vi utforskar därför just nu **en ny spelriktning**. Session 2 (2026-07-20)
utvecklade den i fyra steg: King-analysen → djupdykningen (marknad + mästare)
→ stresstestet (sociala trender + AI-frågan) → **ett fullt konceptdokument:
`KONCEPT-GLOD.md`** (arbetsnamn GLÖD/EMBER — asynkront tvåpersonsspel, daglig
5-minutersritual, delat väsen av glöd). Jeton gav klartecken att gå på djupet
med konceptet ("jag gillar din idé") — men **inget bygge är beslutat**; nästa
konkreta steg är valideringsplanen i KONCEPT-GLOD.md §11 (pitchtest +
Trollkarlen från Oz-testet). Läs KONCEPT-GLOD.md tillsammans med denna fil.
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

## Djupdykningen (session 2, forts) — marknaden 2026, de främsta utvecklarna, och en riktningsrekommendation

Jeton bad om en bredare analys: Fares och King är bara två exempel — studera de
främsta, marknaden idag, globala preferenser och den tidlösa psykologin, och
destillera till en riktning för oss. Research gjord med webbkällor 2026-07-20
(marknadsrapporter, deconstructions, utvecklarintervjuer).

**Marknadsläget 2026 (det viktigaste, med konsekvens för oss):**
- **Nedladdningar är platta (+0,8 %), intäkter växer (+10,6 %).** Eran
  "växa till varje pris" är över; vinnarna är de som behärskar retention och
  värdeskapande, inte volym. → Ett litet spel med extremt lojala användare är
  rätt spelplan; vi ska inte tävla i nedladdningar.
- **Premium på mobil växer kraftigt från låg bas:** +77 % fler premiumsläpp 2025
  (~750 titlar), men bara 4 % av nedladdningarna. Balatro (99 kr-klassen) tog
  ~21 M USD och 3,1 M nedladdningar på mobil enbart — utan annonser, driven av
  community, streamers och mun-till-mun. → Premium är möjligt, men bara om
  spelet i sig är delbart/pratbart.
- **Socialt är motorn:** sociala funktioner höjer LTV 40–60 %, co-op höjer
  retention ~20 %+, och ~78 % av all speltid är multiplayer. → Bekräftar
  pivotens kärntes från båda tidigare analyserna: människor är kroken.
- **Hybrid-monetisering är norm** — få framgångsrika spel är rena F2P- eller
  rena premiumspel längre.

**De främsta utveckarna — vad varje mästare lär oss (utöver Fares & King):**
- **Supercell (Clash of Clans/Royale):** formeln "bekant men nytt + litet
  featureset + kompromisslös polish". Viktigast för oss är dock deras
  *processprincip*: små team, snabba prototyper, och stolthet i att döda spel
  som inte bär ("skåla när ett projekt läggs ner"). → Vi ska testa billigt och
  våga döda — Solar Empire-pausen var alltså rätt beteende, inte ett misslyckande.
- **Rusty Lake — The Past Within (2022):** tvåspelarpussel där en spelare är i
  "det förflutna" och en i "framtiden"; man MÅSTE prata med varandra utanför
  spelet för att lösa gåtorna. ~6 USD, **1 miljon sålda enheter bara på Steam**
  plus mobil/Switch. → **Direkt bevis på att MELLAN-typen säljer som premium.**
  Men: synkront (man spelar samtidigt) och ändligt (~2 tim). Luckan de lämnar:
  async + pågående.
- **Tick Tock: A Tale for Two:** två telefoner, varsin halva av världen, allt
  löses genom att prata. Kallas återkommande "det bäst designade spelet för
  distanspar". Samma lucka: engångsupplevelse, inget skäl att återvända.
- **thatgamecompany — Sky: Children of the Light:** 160 M nedladdningar,
  ~300 M USD livstid på "etisk monetisering" kring socialt uttryck.
  **22 % av intäkterna är gåvor; 40–50 % av säsongspassen köps som gåva till
  någon annan.** Avgörande nyans: de försökte först med en HELT altruistisk
  ekonomi — det misslyckades (quid pro quo-bitterhet när gåvor inte
  återgäldades). Balansen som fungerar: både köp till sig själv OCH gåvor.
  → Validerar gåvo-idén i modell B ovan, men korrigerar den: erbjud båda.
- **Wordle (Josh Wardle/NYT):** EN gåta om dagen — medveten brist utan
  energisystem-cynism; resultatet är en delbar artefakt (de gröna rutorna) som
  marknadsför spelet varje dag; ritual i stället för binge. → Kadensen för vårt
  spel: kort, daglig, delbar — inte oändlig session.
- **Duolingo:** streak-psykologin kvantifierad (7-dagars streak → 3,6× högre
  fullföljande; förlustaversion som motor) och *etiskt utförd* (streak freeze
  som förlåtelse i stället för straff). → Delad svit för två personer, med
  inbyggd förlåtelsemekanik så den bygger relation i stället för skuld.
- **Nintendo/Miyamoto (det tidlösa):** jaga den fundamentala lekkänslan, inte
  teknik eller grafik; "experiential gaming" — spel ska skapa känslor, inte
  bara berätta; enkelt att börja, djupt att bemästra. Tidlöshetens facit.
- **Självbestämmandeteorin (SDT — forskningsgrunden bakom allt ovan):**
  människor återvänder varaktigt till det som föder tre medfödda behov:
  **autonomi** (egna val), **kompetens** (växande skicklighet), **samhörighet**
  (betyda något för någon). Candy Crush kör mest på kompetens-dopamin; Fares på
  samhörighet+kompetens; Wordle/Duolingo på vana+kompetens. Ett spel som föder
  alla tre samtidigt har den tidlösa profilen. Samhörighet är det behov som är
  sämst betjänat på mobil idag — och det är exakt MELLAN:s kärna.

**Syntesen — vad allt pekar mot (Claudes rekommendation):**
Marknadsdata, mästarstudierna och psykologin konvergerar på samma punkt:

> **"Det dagliga ritualet för två" — ett asynkront tvåpersonsspel byggt som
> vana, inte som engångsupplevelse.** MELLAN-riktningen, skärpt: en kort
> (~5 min), daglig, asymmetrisk pusselritual mellan två specifika människor
> som delar en värld ingen ser hela av. The Past Within bevisar att formen
> säljer; Wordle bevisar kadensen; Duolingo bevisar streak-limmet; Sky bevisar
> gåvoekonomin; Fares bevisar mekanisk variation + Friend's Pass; King bevisar
> juiciness + naturlig väntan; SDT förklarar varför det är tidlöst
> (samhörighet + kompetens + autonomi i samma loop).

Positioneringsluckan är tydlig: listorna över "spel för par/distanspar"
domineras av spel som inte är byggda för det. De två som ÄR byggda för det
(The Past Within, Tick Tock) är synkrona engångsupplevelser utan
återkomstmekanik. **Ingen äger kategorin "det dagliga vi:et"** — Duolingo äger
dagligt lärande, Wordle äger daglig gåta, ingen äger daglig tvåsamhet.
Målgruppen är global och tidlös: par, distanspar, förälder–vuxet barn,
bästa vänner på olika orter.

**Formeln "stjäl principen, inte mekaniken" (svar på Jetons hur-fråga):**
1. Identifiera VARFÖR något fungerar hos en mästare (psykologisk princip),
   aldrig VAD de gjorde (mekanik). Kings liv-system = "paus skapar längtan" —
   vi tar principen (den andres drag är pausen), inte mekaniken (energibar).
2. Kombinera principer från olika mästare som aldrig mötts förut — det är där
   innovationen uppstår. Vår mix (async-tvåsamhet × daglig ritual ×
   gåvoekonomi) finns inte på marknaden; varje ingrediens är dock bevisad var
   för sig. Det är "bekant men nytt" (Supercell) på konceptnivå.
3. Validera som Supercell: billigast möjliga test först (pitch → papper →
   prototyp), och var stolt över att döda det som inte bär.

**Risker att ha ögonen på (ärlighet, inte säljsnack):**
- *Innehållstrampkvarnen:* daglig kadens kräver antingen genererbara pussel
  (à la Wordle — en formel, oändligt innehåll) eller kapitel + daglig
  mikroritual i kombination. Måste lösas i designen tidigt.
- *Tvåsidig cold start:* spelet är värdelöst ensam — onboarding måste göra
  det trivialt att bjuda in sin person (Friend's Pass löser betalningen,
  inbjudningsflödet måste vara friktionsfritt).
- *Churn i par:* om en tröttnar dör spelet för båda. Duolingos
  förlåtelsemekanik + möjlighet till "solo-drag som gåva" mildrar.
- *4 %-nischen:* ren premium begränsar; hybridmodellen (gratis in, par-köp,
  gåvor) är sannolikt rätt — bekräftas av både marknadsdata och Sky.

## Stresstestet (session 2, forts 2) — flyger "daglig tvåsamhet"? Och: människa eller AI som den andre?

Jeton tänkte högt: håller konceptet mot globala sociala trender — och kan den
andra "personen" vara en AI/avatar i stället för en levande människa?
Research 2026-07-20 (ensamhetsstatistik, AI-kompanjonsmarknaden, regulatorik).

**Flyger det? De sociala trenderna (medvind, med en viktig nyans):**
- Ensamhetsepidemin är global och växande: WHO — 1 av 6 människor drabbade,
  kopplad till ~100 dödsfall i timmen; 57 % av amerikaner ensamma; värst bland
  unga vuxna (24 % under 30 ensamma större delen av tiden). "Friendship
  recession": andelen män med 6+ nära vänner halverad sedan 1990.
  US Surgeon General: brist på social kontakt lika farligt som 15 cigaretter/dag.
- **Nyansen:** vår målgrupp är inte "de ensamma" (de saknar en person att spela
  med) utan **"de åtskilda"** — par på distans, förälder–vuxet barn, bästa
  vänner på olika orter, familjer över landsgränser (Jeton lever själv
  Sverige–Kosovo-vardagen). Den gruppen växer strukturellt: migration,
  distansarbete, globala familjer. Och friendship recession gör de FÅ
  relationer man har mer värda att underhålla — vi säljer underhåll av
  relationer, inte bot mot ensamhet.
- Kulturell medvind nr 2: växande backlash mot parasocial skärmtid ("brain
  rot", digital detox, "social fitness"). Ett spel vars produkt är en STÄRKT
  verklig relation rider både på problemet och på motreaktionen. Det är
  positioneringen "skärmtid ni inte behöver skämmas över".

**AI/avatar-varianten — marknaden är stor men fel för oss som KÄRNA:**
- Marknadsfakta: AI-kompanjonsappar ~220 M ackumulerade nedladdningar, ~50 M
  aktiva användare (feb 2026), ~120 M USD 2025 → 20 M+ USD/månad 2026;
  Replika 200 M+ USD/år; Character.AI 233 M registrerade, ~92 min/dag
  engagemang. Kommersiellt verklig och växande.
- **Fyra skäl att INTE göra AI:n till den andre spelaren:**
  1. *Regulatorisk storm:* Kaliforniens SB 243 (i kraft 2026-01-01), New Yorks
     minderårig-förbud (25 000 USD/överträdelse), federala GUARD Act, Kinas
     minderårig-förbud, Character.AI/Google förlikade fem wrongful-death-
     stämningar 2026. Kraven (åldersverifiering, självmordsdetektering,
     ständiga "jag är inte människa"-påminnelser) är tunga för ett tvåmansbolag,
     och App Store-reglerna lär skärpas.
  2. *Etiskt/psykologiskt:* hela vår kärnmekanism är att väntan är ÄKTA — en
     verklig människa gjorde sitt drag. En AI som låtsas vänta är simulerad
     anknytning — exakt den beroendemekanik som stämningarna handlar om, och
     Kings cynism i ny skepnad. Det bryter konceptets själ.
  3. *Strategiskt:* i AI-kompanjonskategorin blir vi app nr 338 i en marknad
     där topp-10 % tar 89 % av intäkterna, mot bolag med LLM-infrastruktur-
     budgetar. I "daglig tvåsamhet mellan riktiga människor" är vi först.
  4. *Tidlöshet:* SDT-behovet samhörighet handlar om att BETYDA något för
     någon verklig; forskningen tyder på att AI-sällskap ger kortsiktig
     lindring men riskerar fördjupad isolering. Äkta människa = tidlöst;
     AI-kompanjon = trendkänsligt och backlash-exponerat.
- **Där AI DÄREMOT hör hemma (principen "AI driver världen, ersätter aldrig
  människan"):**
  - *AI som innehållsmotor:* genererar/personaliserar dagliga pussel åt paret —
    löser innehållstrampkvarnen (identifierad huvudrisk).
  - *AI som den TREDJE karaktären:* världens varelse/väsen som paret sköter
    TILLSAMMANS — inte din partner utan ert gemensamma "barn/husdjur".
    Beprövat: Tamagotchi, Finch (självomsorgs-fågeln), Widgetable (delade
    husdjurswidgets för par — redan en trend). Ger världen personlighet,
    ger solo-ögonblick mening ("varelsen har saknat er"), och är
    pitch-testbar som variant.
  - *AI som mjuk fallback:* om ena parten är borta en vecka dör inte världen —
    varelsen "håller ställningarna" (aldrig genom att låtsas vara partnern).
  - *Ev. solo-övningsläge* märkt som just övning — mildrar tvåsidig cold start.

**Slutsats stresstestet:** konceptet flyger — trenderna är medvind åt två håll
samtidigt (behovet växer OCH motreaktionen mot fejkad närhet växer). Människa
som den andre är rätt; AI som osynlig motor och ev. som parets gemensamma
varelse. Enmenings-pitchen kan nu testas i två varianter: med och utan
varelsen ("ni två sköter en värld ingen ser hela av" vs "ni två uppfostrar
ett väsen som bara överlever om ni båda kommer tillbaka").

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
- **2026-07-20 (session 2, forts — djupdykningen):** Jeton bad om bredare
  research: marknaden idag, globala preferenser, tidlös psykologi, fler mästare
  än Fares/King. Webbresearch gjord (marknadsrapporter 2026, Supercell,
  Rusty Lake/The Past Within, Tick Tock, thatgamecompany/Sky, Wordle, Duolingo,
  Nintendo/Miyamoto, självbestämmandeteorin). Nyckelfynd: The Past Within
  (tvåspelarpussel, ~6 USD) sålde 1M+ enheter — MELLAN-formen bevisat säljbar;
  Sky tjänar 22 % av intäkterna på gåvor; premium växer +77 % men är 4 % av
  nedladdningar; socialt höjer LTV 40–60 %. Claudes rekommendation formulerad:
  **"Det dagliga ritualet för två"** — async tvåpersonsspel som daglig vana
  (se "Djupdykningen" ovan), hybridmodell. Risker dokumenterade (innehålls-
  trampkvarn, tvåsidig cold start, par-churn). **Inget byggt, inget beslutat —
  Jeton tar ställning till rekommendationen.**
- **2026-07-20 (session 2, forts 2 — stresstest + AI-frågan):** Jeton tänkte
  högt: flyger daglig tvåsamhet mot globala trender, och kan den andre vara en
  AI/avatar? Research: ensamhetsepidemin (WHO 1 av 6; friendship recession),
  AI-kompanjonsmarknaden (50 M aktiva, Replika 200 M USD/år) och regulatoriken
  (SB 243, NY-förbud, GUARD Act, förlikade dödsfallsstämningar). Slutsats i
  "Stresstestet" ovan: konceptet har dubbel medvind (behovet växer + backlash
  mot fejkad närhet); målgruppen preciserad till "de åtskilda", inte "de
  ensamma". AI som den andre spelaren avråds (4 skäl); AI:s rätta roll:
  innehållsmotor + ev. parets gemensamma varelse (Tamagotchi/Finch/Widgetable-
  spåret) + mjuk fallback. Två pitch-varianter att testa formulerade.
  **Inget byggt, inget beslutat.**
- **2026-07-20 (session 2, forts 3 — KONCEPT-GLOD.md skapad):** Jeton gillade
  riktningen ("fortsätt gå djupare, applicera allt som gör de främsta spelen
  beroendeframkallande och premium-värda"). Claude skrev konceptdokumentet
  `KONCEPT-GLOD.md` v0.1: kärnfantasi (två håller liv i ett väsen av glöd),
  världen (delad dal, Grynings-/Skymningssidan), dagligt 5-minutersritual i
  5 steg, komplett mekanismtabell (mästare → mekanik), etiska designlagar
  (längtan aldrig skuld, privat by design, utanför companion-chatbot-
  regulatoriken), trelagers innehållsmotor, livscykeldesign (ägg-inbjudan,
  kläckning kräver båda, ide i stället för död, värdig arkivering),
  hybridmodell (129 kr parpass + gåvobutik 15–39 kr, aldrig energi/annonser),
  riskregister och valideringsplan (pitchtest + Trollkarlen från Oz-test via
  WhatsApp — noll kod). Öppna antaganden listade i §12 för Jetons reaktion.
  **Fortfarande inget byggt.**
- **2026-07-20 (session 2, forts 4 — Oz-testmaterialet levererat):** Jeton bad
  om vecka 1-gåtorna för Oz-testet. Claude byggde `SolarEmpire/OzTest/`:
  14 gåtkort som PNG (1080×1593, 7 dagar × Grynings-/Skymningssida, genererade
  via `gen_oztest.py` + Chromium-screenshots — omgenererbara) och
  `OZTEST-GUIDE.md` (körinstruktioner, observationslogg, förutbestämda
  beslutskriterier, facit). Gåtorna: Symbolbron (GNISTA), Mönsterhalvan (V),
  Vandringen (DAGG), Rösterna (GRYNINGSSTJÄRNA, röstmeddelanden), Frågorna
  (gissa om varandra), Sifferlåset (3517), Kläckningen (VAKNA + lågbild).
  Varje kort har "Avskedet"-gåvouppmaning. Jeton kör testet 7 dagar med en
  verklig person; nästa session: fråga efter loggen och utfall mot
  beslutskriterierna. **Inget byggt utöver testmaterialet.**
