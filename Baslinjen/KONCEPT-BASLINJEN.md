# BASLINJEN (en: BASELINE) — konceptdokument v0.2

**Status: koncept + spelbar webbprototyp v0.2 (Fall 01–02, galleri, delningskort, ljud).**
**Ägare: Jeton. Skrivet 2026-07-20 (session 3), fördjupat samma dag på Jetons GO**
**("gå vidare med detta koncept och utveckla på djupet").**
Enspelarspel. Separat projekt — GLÖD och Solar Empire ligger orörda på sina brancher.
Claude valde detta koncept på Jetons mandat ("ta du fram något som faktiskt funkar,
är roligt och folk betalar för"). Motivering nedan i §2.

---

## 1. Kärnfantasin (en mening)

> Du är människoläsaren — den som ser vad folk *faktiskt* säger.

Spelaren är personen man ringer när tekniken inte räcker: en läsare av människor
som löser fall genom att först lära sig en persons **baslinje** (deras normala)
och sedan jaga **avvikelser** när trycket ökar. Chase Hughes-mekanik, flippad
till deckarnöje.

**Löftet till spelaren (defensiv inramning, avgörande för marknadsföringen):**
*"Bli omöjlig att lura."* Inte "lär dig manipulera" — samma innehåll, men
skölden säljer bredare än svärdet, är etiskt ren och App Store-säker.

## 2. Varför detta koncept (beslutet och motiveringen)

Fyra kandidater fanns (se chatthistorik session 3): A) Baslinjen (läsa andra),
B) Spegeln (spelet läser dig), C) Flocken (social simulation), D) Dagens
Människa (dagligt Wordle-format). Valet föll på A för att det ensamt uppfyller
alla tre kraven "funkar, roligt, folk betalar":

1. **Bevisad betalvilja i genren.** Deduktionsspel i premiumformat är en av få
   mobilkategorier där folk faktiskt betalar engångspris: Papers Please,
   Her Story, Return of the Obra Dinn, The Case of the Golden Idol,
   Ace Attorney-serien. Ingen av dem har dock beteendeläsning som kärnverb.
2. **Ny mekanik, inte ny genre.** Befintliga "lögndetektor-spel" använder
   generiska tells (skakig blick = lögn). Baslinjens grundregel — *samma
   beteende är normalt hos en person och en varningsflagga hos en annan* —
   är (a) sant enligt beteendeforskningen, (b) mekaniskt färskt: varje fall
   får nya "regler" eftersom varje människa är sin egen regelbok. Det är
   Fares-principen om mekanisk variation, gratis, inbyggd i premissen.
3. **Ingen löpande AI-kostnad.** Handskrivna fall → engångsköp ~100–129 kr
   fungerar affärsmässigt (till skillnad från AI-drivna samtal som kräver
   abonnemang). AI kan läggas till senare som premiumläge, men behövs inte.
4. **Jeton är domänexperten.** Sälj sedan barnsben — att läsa och läsa av
   människor är hans yrkeskunskap. Första projektet där grundaren är innehållet.
5. **Ludonarrativ resonans på riktigt (Fares princip 3):** spelaren blir
   *faktiskt* bättre på att läsa människor. Skickligheten i spelet är samma
   skicklighet som i livet. Det är retention ingen mekanik kan köpa.

## 3. Kärnloopen — ett fall i tre akter (~20–40 min per fall)

**Akt 1 — Baslinjen (småpratet).** Innan de riktiga frågorna: kallprat om
neutrala ämnen. Spelaren observerar och antecknar personens normala i fyra
kanaler: **Tempo** (svarshastighet, talrytm), **Språk** (småord, ordval),
**Detaljer** (svarslängd, specificitet), **Kropp** (blick, händer).
Lärdomen byggs in här: nervositet, plotter, undvikande blick kan vara någons
*normala* — den som dömer på myter förlorar.

**Akt 2 — Trycket (de riktiga frågorna).** Nu handlar frågorna om fallet.
Varje svar spelas upp genom samma fyra kanaler; spelaren flaggar **avvikelser
från just den här personens baslinje** — inte från "hur folk borde bete sig".
Avvikelse ≠ lögn; avvikelse = stress = *gräv här.* Vägval i samtalet:
**pressa eller lugna.** Mekaniskt är empati starkare — pressa en stressad
människa och hon stänger (kortare svar, information går förlorad); bygg
trygghet och hon öppnar sig. (Hughes förhörslära, flippad: snällhet är
den optimala strategin, inte den mjuka.)

**Akt 3 — Beslutet.** Spelaren fäller sitt omdöme med konsekvenser, får
facit: personens verkliga baslinje, varje avvikelse förklarad, vad vägvalen
kostade/gav, poäng och titel. Fällorna är designade: den som såg "nervös =
skyldig" åker dit; den som såg oskulden men missade avvikelserna får bara
halvrätt. Full poäng kräver att man läste *personen*.

## 4. Innehållsstruktur och variation

- **Säsong 1: 10 fall**, varje fall en ny människa = ny baslinje = nya regler.
  Fullständig fallbibel i §4b. Fallens ämnen: vardagsnära och relaterbara —
  inte seriemördarklichéer. Tonen: skandinavisk noir med värme och torr humor.
- **Metaprogression:** "persongalleriet" — varje läst människa sparas som ett
  porträttkort med utfall och intjänad titel. Samlarinstinkt + synligt bygge
  (Solar Empire-lärdomen: se vad man byggt). Byggt i prototyp v0.2.

## 4b. Fallbibeln — säsong 1 (varje fall lär ut EN äkta läsprincip)

Säsongen är i hemlighet en kurs i människoläsning — det är premiumkänslans
kärna: efter tio fall ÄR spelaren bättre på att läsa folk. Varje fall byter
dessutom ut ett mekaniskt verktyg (Fares princip 2: ingen mekanik hinner tråka ut).

| # | Arbetsnamn | Person & härva | Lärdomen | Mekanisk variation |
|---|---|---|---|---|
| 01 | Handkassan | Moa, praktikant; stulen handkassa | Nervositet är inte skuld — avvikelsen är signalen | Grundloopen + pressa/lugna-vägval |
| 02 | Den som aldrig darrar | Richard, egenföretagare; "inbrott" och försäkring | Perfektion är också en avvikelse; manus varierar inte | »Ställ frågan igen« — ordagrann upprepning avslöjar manus |
| 03 | Två personer, en lögn | Två syskon, ett arv, en namnteckning | Korsläsning: två baslinjer, en berättelse — hitta glappet | Växla mellan två stolar; svaren måste jämföras |
| 04 | Den nervösa oskulden | Vittne med maximala "skuldsignaler" | Falsklarmets pris — allt du lärt dig kan överanvändas | Poängvikten flyttad: falsklarm kostar dubbelt |
| 05 | Rösten i telefonen | Ett samtal, ingen kropp | Kanalbrist: tempo och språk får bära allt | Två kanaler släckta — bara ljud/text |
| 06 | Familjemiddagen | Fyra personer, en liten lögn, hög känsla | Låg insats ≠ låg svårighet; kärlek stör avläsning | Flera baslinjer samtidigt vid samma bord |
| 07 | Spegeln | En förhandlare som läser DIG | Den som vet vad du letar efter kan spela din baslinje | Dina egna frågeval förändrar motpartens beteende |
| 08 | Minnet | Ett vittne som minns fel — och tror sig tala sanning | Avvikelse utan lögn: stress ≠ lögn ≠ falskt minne | Bevis kan motsäga ett ärligt svar |
| 09 | Experten | En person utbildad i förhörsteknik; dubbelbluff | Kontrollerad avvikelse — planterade signaler | Vissa "tells" är beten; källkritik på beteende |
| 10 | Rekryteringen (final) | Två kandidater — du anställer en till DITT team | Allt testas; facit visar din utveckling över säsongen | Två fullständiga förhör, ett oåterkalleligt val |

Svårighetskurvan: 01–02 lär grunderna (två motsatta avvikelsetyper), 03–06
utökar kontexten, 07–09 vänder verktygen mot spelaren, 10 examinerar.
Slutfacit efter fall 10: spelarens "läsprofil" över hela säsongen — vilka
kanaler man är stark i, var man går på myter. Mycket delbar.

## 5. Beroendemekanismer (medvetet och etiskt, samma ramverk som GLÖD)

| Mekanism | I BASLINJEN |
|---|---|
| Kompetens på riktigt (SDT) | Spelaren blir mätbart bättre på att läsa människor — färdigheten följer med ut i livet. |
| Near-miss | "Jag SÅG ju att något var fel på fråga fyra…" — facit visar exakt vad man nästan fångade. |
| Variabel belöning | Varje ny människa är en ny gåta; avvikelserna kommer aldrig där man väntar dem. |
| Delbar artefakt (Wordle) | Efter varje fall: ett delbart "utlåtandekort" (titel + träffsäkerhet, utan spoilers). |
| Samlande | Persongalleriet växer; tomma ramar skvallrar om kommande fall. |
| Mekanisk variation (Fares) | Varje människa är en ny regelbok; specialfall bryter mönstret. |
| Ludonarrativ resonans (Fares) | Att lyssna noga och döma rättvist ÄR spelet — och belönas mekaniskt. |
| Generositet (Fares/Friend's Pass-andan) | Fall 01 gratis och delbart; köpet låser upp säsongen. |

**Etiska ramar:** spelet lär ut läsning och empati, aldrig manipulation.
Pressa-strategin är mekaniskt sämre — spelet *bevisar* att trygghet slår hot.
Inga fejkade notiser, ingen FOMO-mekanik. Premium utan kasinologik.

## 6. Affärsmodell

- **Fall 01 gratis** (fullt spelbart, delbart utlåtandekort = spridningsmotor).
- **Engångsköp ~99–129 kr** låser upp hela säsong 1. Inga annonser i premium.
- Framtida intäktsben (beslutas senare, inget krav för v1): säsong 2+,
  "AI-läge" (improviserade förhör mot AI-karaktärer, abonnemang),
  B2B-spår (rekryterare/säljteam tränar personbedömning — Jetons nätverk).

## 7. Prototypen v0.2 (byggd, spelbar nu)

`Baslinjen/prototyp/index.html` — en enda fristående fil (mobil + PC, inga
beroenden) med riktig spelstruktur:

- **Persongalleriet (hubb):** fallval, porträttkort, sparade framsteg
  (bästa poäng + titel per fall, localStorage), teaser för låst Fall 03.
- **Fall 01 "Handkassan":** Moa, praktikant. Lärdomen: nervositet är inte
  skuld. Hennes baslinje är snabb/pladdrig/rastlös; avvikelserna (pauser,
  korta svar, småorden tystnar) kommer bara kring Viktor. Vägval pressa/lugna
  med verklig informationskostnad.
- **Fall 02 "Den som aldrig darrar":** Richard, egenföretagare, anmält inbrott,
  Rolex försäkrad för 180 000 kr. Motsatta lärdomen: hans baslinje är avmätt
  och exakt — avvikelsen är ÖVERPRESTATION (svaret om kvällen kommer för snabbt,
  för perfekt, i rapportspråk; känslan för den älskade klockan är borta; första
  äkta pausen kommer utanför manus). Ny mekanik: »ställ frågan igen« — svaret
  kommer ordagrant identiskt, och manus avslöjas.
- **Delbart utlåtandekort:** genereras som bild (canvas) efter varje löst fall —
  titel + poäng, inga spoilers. Wordle-principen: daglig gratis marknadsföring.
- **Ljud:** syntetiserat (WebAudio) — klick, skrivticks, facitklang. Valbart.
- **Motorn är datadriven:** ett fall är en datastruktur, inte kod. Fall 03+
  är innehållsarbete.

Prototypen testar: är loopen rolig, bär variationen mellan fall, och känns
lärdomarna äkta? Grafiken är medvetet enkel — känslan är det som bedöms.

## 8. Öppna frågor till Jeton (svara efter att du SPELAT prototypen)

1. Kärnfrågan: var loopen rolig? Ville du spela Fall 02 direkt? (Om nej — vad
   saknades: spänning, tydlighet, belöning?)
2. Ton: satt den skandinaviska vardagsnoiren, eller ska det mörkare/varmare?
3. Pitchtestet (samma regel som sist): säg *"ett spel som gör dig omöjlig att
   lura — du förhör människor och lär dig se när de avviker från sitt normala"*
   till 5 personer. Räkna hur många som säger "oj, det vill jag testa".
4. Priskänsla: skulle du betala 129 kr för 10 sådana fall, om varje fall är
   3–4× djupare än prototypen?

## 9. Nästa steg (efter Jetons test, i ordning)

1. Jeton spelar prototypen + pitchtest på 5 personer → GO/NO-GO på konceptet.
2. Vid GO: skriv Fall 02–03 på papper, speltesta i webbprototypen (billigast).
3. Först därefter: iOS-beslut — återanvänd hela Solar Empire-infran
   (GitHub Actions-byggen, StoreKit, språksystem, ljudmotor, appetize-testning).
4. Namnkontroll (varumärke/App Store) på "Baslinjen"/"Baseline" vid beslut.
