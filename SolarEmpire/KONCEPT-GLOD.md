# GLÖD (arbetsnamn; en: EMBER) — konceptdokument v0.1

**Status: koncept, inget byggt. Ägare: Jeton. Skrivet 2026-07-20 (session 2).**
Bygger på analyserna i PROJEKT.md (Fares, King, djupdykningen, stresstestet).
Allt här är designbeslut på papper — billiga att ändra, gratis att döda.

---

## 1. Kärnfantasin (en mening)

> Två människor på varsin plats i världen håller tillsammans liv i ett väsen
> av glöd — det överlever bara om båda kommer tillbaka.

Metaforen är avsiktligt tidlös: **en eld som två personer håller vid liv.**
Människor har vaktat elden tillsammans i hundratusen år; "hålla lågan vid liv"
är redan språkets bild för en levande relation. Spelaren behöver aldrig få
metaforen förklarad — den känns. (Ludonarrativ resonans, Fares-princip 3:
det fingrarna gör — vårda, värma, mata — ÄR det relationen gör.)

**Arbetsnamn:** GLÖD på svenska, EMBER internationellt. Kort, känslobärande,
fungerar som verb ("har du glött idag?" är tänkbar vardagssvenska i målgruppen).
Namnkontroll (varumärke/App Store) görs först vid beslut.

## 2. Vem spelar? (antagande att bekräfta)

Primär målgrupp: **"de åtskilda"** — två människor med en verklig relation och
geografiskt/vardagligt avstånd. Tre kärnpar, i prioritetsordning:

1. **Par på distans** (störst betalvilja, starkast dagligt behov, tydligast
   marknadsföring — LDR-communityn är stor, aktiv och underbetjänad).
2. **Förälder ↔ vuxet barn** (enorm och orörd: "ring din mamma"-skulden
   omvandlad till fem varma minuter om dagen).
3. **Bästa vänner på olika orter** (friendship recession-medvinden).

Designen får inte vara så romantiskt kodad att par 2–3 stängs ute: väsendet är
ett *gemensamt ansvar*, inte en kärlekssymbol. Tonen: värme, inte romantik.
(Antagande: vi designar för alla tre men marknadsför mot par först. Jeton bekräftar.)

## 3. Världen och väsendet

- **Världen:** en liten dal/ö delad i två halvor — **Gryningssidan** och
  **Skymningssidan.** Du ser bara din halva skarpt; den andres halva skymtar
  som siluetter och ljus på andra sidan. (Informationsasymmetrin är alltså
  inbyggd i själva geografin, inte pålagd.)
- **Väsendet — "Glöden":** ett litet väsen av levande glöd som bor i mitten,
  vid gränsen mellan halvorna. Det behöver **två olika saker som bara
  respektive sida kan ge** (t.ex. gryningsdagg ↔ skymningsvind). En person kan
  hålla det vid liv nödtorftigt — men det *växer* bara av båda.
- **Väsendet är den tredje karaktären, aldrig en ersättning:** det talar inte
  språk, det reagerar (värmer, lyser, kurar, spinner som glödande kol). AI
  driver dess beteende och pusselgenereringen bakom kulisserna — men det
  låtsas aldrig vara en människa och förmedlar aldrig fejkade händelser.
  (Regulatoriskt trygg design: inget "companion chatbot"-mönster, inga
  konversationer, ingen simulerad anknytning till en person.)
- **Världen är parets monument:** allt de gjort syns. Varje vårdad dag lägger
  ett ljus i dalen; varje avklarad säsong reser något permanent (ett träd, en
  bro, en lykta). Efter ett år är dalen en synlig historia över relationen —
  att lämna spelet = att lämna monumentet. (Lärdomen från Solar Empire v1.3,
  Jetons egen "se vad man bygger"-idé, nu med känslomässig laddning:
  bytkostnaden är minnen, inte siffror.)

## 4. Det dagliga ritualet (~5 minuter) — kärnloopen

Varje dag, när man vill, på var sitt håll:

1. **Ankomsten (juiciness-toppen).** Du öppnar appen och ser FÖRST vad din
   människa gjort sedan sist: hens spår lyser i din halva, väsendet springer
   fram med det hen lämnat. Detta är spelets mest påkostade ögonblick — ljus,
   partiklar, väsendets glädje, haptik. (Kings "Delicious!"-princip lagd på
   spelets känslomässiga centrum. Obs: belöningen är äkta variabel belöning —
   genererad av en människa, inte en slumpgenerator. Spelautomaten ersatt av
   en person man älskar. Det är hela konceptets motor och dess etiska ryggrad.)
2. **Dagens gåta (5 min, asymmetrisk).** Ett litet pussel i din halva där din
   information inte räcker hela vägen: du ser mönstret, hen har nyckeln — eller
   tvärtom. Två lösningsvägar: vänta på hens drag (asynkront), eller ta
   kontakt i verkligheten ("vad står det på DIN sida av stenen?"). **Att
   spelet tvingar fram ett riktigt meddelande/samtal är inte en bugg — det är
   produkten.** (The Past Within-principen, gjord asynkron; Kings near-miss:
   din halva löser nästan alltid ~80 % — det saknade är alltid hos den andre.)
3. **Vårdandet (30 sek).** Ge väsendet din sidas gåva. Enkelt, taktilt,
   ASMR-vänligt (samla dagg med fingerdrag, blåsa i mikrofonen så glöden
   flammar — mekanisk variation per säsong, se §6).
4. **Avskedet: lämna något.** Du lämnar ett spår till i morgon: en gåva,
   en ledtråd, en liten teckning, ett arrangemang av föremål. Detta skapar
   HENS ankomstögonblick i morgon. (Loopen är ett perpetuum mobile av
   ömsesidighet: min avslutning är din öppning.)
5. **Glödvakan (delad streak).** När båda varit inne samma dygn flammar
   glöden och vakan räknas upp: "Er vaka: dag 34." Missar en person en dag
   **dör inget** — väsendet sover, dalen mörknar en aning, och vakan kan
   räddas med en "glödsten" (se förlåtelsemekanik, §7).

**Sessionslängd är ett löfte:** ~5 minuter, en gåta, klart. Ingen oändlig
session att fastna i (Wordle-principen: brist utan cynism). Vill man stanna
och pyssla i dalen får man — men ritualen är alltid kort. Det gör spelet
förenligt med vuxenliv och gör det till en vana i stället för en binge.

## 5. Beroendemekanismerna — mästare för mästare, medvetet och etiskt

| Mekanism (källa) | I GLÖD |
|---|---|
| Äkta väntan (King: liv-timer → vår mänskliga variant) | Kan inte slutföra dagens gåta utan den andres drag → längtan, återkomst. Bristen är en människa, kan inte köpas bort. |
| Variabel belöning (slotpsykologi, etisk form) | Ankomstögonblicket: vad lämnade hen? Människogenererad överraskning varje dag. |
| Near-miss (King) | Din halva löser ~80 % av gåtan; resten finns hos den andre → "jag måste bara fråga…" |
| Delad streak + förlustaversion ×2 (Duolingo/Snapchat) | Glödvakan är gemensam egendom — att tappa den sviker en person, inte en siffra. |
| Förlåtelse > straff (Duolingo streak freeze) | Glödstenar täcker missade dagar; semesterläge sätts TILLSAMMANS (en ritual i sig). |
| Juiciness (King) | Ankomsten är mest påkostad; vårdandet är taktilt; väsendet reagerar på allt. |
| Delbar artefakt (Wordle) | Varje fullbordad dag genererar ett "dagkort" — en vacker liten bild av dalen med bådas bidrag antydda (aldrig avslöjade). Delbar utan spoiler → daglig gratis marknadsföring. |
| Mekanisk variation (Fares) | Säsonger (~2 veckor) byter vårdmekanik och gåttyp; rollerna (vem som har nyckeln) växlar. Ingen mekanik hinner bli tråkig. |
| Ludonarrativ resonans (Fares) | Vårda glöden = vårda relationen. Sägs aldrig i text — känns i händerna. |
| Synligt bygge (Solar Empire v1.3, Jetons idé) | Dalen växer permanent; monument per säsong; relationens historia som landskap. |
| Progression/kompetens (SDT) | Gåtorna djupnar långsamt; väsendet utvecklas i stadier efter ackumulerad omvårdnad; par-nivå ("Er dal, nivå 7"). |
| Autonomi (SDT) | Fritt när på dygnet, fritt vad man lämnar, fri utsmyckning av sin halva. |
| Samhörighet (SDT) | Kärnan. Allt ovan tjänar den. |

**Etiska ramar (varumärkeskritiska, skrivs in i designen från dag 1):**
- **Längtan, aldrig skuld.** Notiser bara vid ÄKTA händelser ("din människa har
  varit i dalen"), aldrig fejkade ("glöden är ledsen…" förbjudet). Väsendet
  dör aldrig permanent. Inga passivt-aggressiva texter.
- Relationsskydd: spelet får aldrig bli ett vapen ("du missade IGEN") —
  statistik visar bådas bidrag som helhet, aldrig som jämförelse/tävling
  mellan de två.
- Privat by design: allt mellan två personer är deras; ingen publik feed,
  inga främlingar, inget socialt betyg. (Även GDPR-enkelt.)
- 16+ i marknadsföring, ingen companion-chat-mekanik → utanför den
  regulatoriska stormen kring AI-kompanjoner.

## 6. Innehållsmotorn — så undviker vi trampkvarnen (huvudrisken)

Tre lager, i kostnadsordning:

1. **Formelgåtor (dagligt, genererade):** en familj av asymmetriska pusseltyper
   (mönsterhalvor, ljud↔bild, minne↔karta, ord↔symbol) där AI genererar
   dagliga instanser parametriserade per par (svårighet följer parets
   historik — Kings datadrivna svårighetsgrad, applicerad per par i stället
   för per bana). Wordle bevisar att EN formel räcker länge om ritualen bär.
2. **Säsonger (~2 veckor, handgjorda):** ny region i dalen, ny vårdmekanik,
   ny gåtfamilj, ett monument. Det är här Fares-variationen och det
   handgjorda hantverket bor. 26 säsonger/år är målet på sikt; lansering
   behöver bara 3.
3. **Händelser (sällsynta, gemensamma):** norrsken, kometnätter, glödens
   utvecklingssteg — ögonblick designade för att två människor ska säga
   "såg du?!" till varandra i verkligheten samma kväll.

## 7. Livscykel och kritiska ögonblick

- **Inbjudan = ägget.** Spelet börjar med att en person skickar ett ägg:
  *"Någon vill dela en värld med dig."* Inbjudan är känslomässig, inte
  teknisk — den ska kännas som att få ett brev, inte en app-länk.
  (Tvåsidiga cold start-risken attackeras med spelets starkaste känsla.)
- **D1: kläckningen sker först när båda varit inne.** Den som bjuder in har
  alltså ett starkt skäl att jaga sin människa — spelet rekryterar spelare 2
  åt oss.
- **D7: väsendets första utvecklingssteg + veckokort** (delbart: "Vår första
  vecka"). Duolingos data: 7-dagarströskeln är magisk (3,6× fullföljande).
- **D30: första säsongsskiftet + första monumentet.** Nu finns något att förlora.
- **Paus/churn:** väsendet går i ide (aldrig död), dalen väntar i skymning.
  Återkomstritual: att tända glöden igen TILLSAMMANS är designat som ett eget
  litet vackert ögonblick — comeback ska kännas som försoning, inte skam.
- **Om relationen tar slut** (kommer att hända): exportera dalen som minnesbok
  (bild/PDF), arkivera med värdighet. Ryktesrisk om vi hanterar det fel;
  varumärkesbyggande empati om vi gör det rätt.

## 8. Affärsmodellen — hybrid, kalibrerad mot Sky/Fares/marknadsdata

- **Gratis:** ägget, första regionen, 14 dagars full ritual. (Tillräckligt för
  att vanan och känslan ska hinna sätta sig — vi säljer aldrig till skeptiker,
  bara till redan-förälskade.)
- **Parpasset, ~129 kr engångsköp, EN gång per par:** låser upp allt, för
  BÅDA, för alltid. Köps av den ena — Friend's Pass-generositeten gör köparen
  till ambassadör. Prisankaret är inte "ett spel" utan "billigaste dejten i
  månaden" / "mindre än en blombukett".
- **Gåvobutiken (Sky-modellen, med Skys egen korrigering):** små kosmetiska
  köp 15–39 kr — utsmyckning, väsendets tillbehör, lyktor — köpbara BÅDE till
  sig själv och som gåva till den andre (ren altruism-ekonomi misslyckades
  för Sky; mixen fungerar). Gåvan levereras i dalen som en händelse
  (= ett extra ankomstögonblick, som råkar vara vår intäkt).
- **Säsongsdekor (senare, valfritt):** ~29 kr för säsongens kosmetiska paket.
- **Aldrig:** energi, annonser, pay-to-progress, köpbara glödstenar i mängd
  (förlåtelse ska vara generös gratis — att sälja förlåtelse vore Kings
  cynism rakt in i relationens kärna).
- Intäktsprofil att sikta på (Sky-benchmark): grundintäkt parpass;
  20–30 % av löpande intäkt från gåvor.

## 9. Varför betalar man premium? (kravet "top-notch, världsnivå")

Folk betalar 100+ kr utan att blinka för det som ger en KÄNSLA de inte får
någon annanstans (Balatro: flow; It Takes Two: gemensamt äventyr; Sky: skönhet
och generositet). GLÖD:s känsla: **att betyda något för någon varje dag, och
se det växa till ett landskap.** Ingen annan app på marknaden levererar den
känslan som daglig ritual. Betalningen inramas som en handling i relationen
(man köper åt *oss*, ofta som gåva) — det flyttar köpet från spelbudget till
relationsbudget, där betalviljan är en helt annan.

Kvalitetsribban det kräver (Supercell-formeln: litet featureset, kompromisslös
polish): få mekaniker, men varje ljud, partikel och väsensreaktion på
Monument Valley/Sky-nivå. Hellre en säsong färre än en ful övergång.

## 10. Riskregister (uppdaterat)

| Risk | Motmedel |
|---|---|
| Innehållstrampkvarn | Trelagersmotorn (§6); lansera med bara 3 säsonger + formelgåtor |
| Tvåsidig cold start | Ägg-inbjudan som känsloögonblick; kläckning kräver båda (D1-design) |
| Par-churn (en tröttnar) | Ide + glödstenar + försoningsritual; solo-vård håller väsendet vid liv nödtorftigt |
| Skuldmekanik-backlash | Etiska ramarna i §5 är hårda designlagar, inte riktlinjer |
| Relationer tar slut | Värdig arkivering/minnesbok (§7) |
| Romantisk kodning stänger ute vän/familj-par | Värme-inte-romantik i all ton och art direction |
| Kategorin finns inte ("vad ÄR detta?") | Marknadsför mot LDR-par först (de söker aktivt); dagkorten utbildar marknaden organiskt |
| Namnet upptaget | Namnkontroll före beslut; GLÖD/EMBER är arbetsnamn |

## 11. Valideringsplan — fortfarande noll kod

1. **Pitchtest (Jetons aktion, kvar sedan tidigare):** två meningar på 5+5
   personer: utan väsen ("ni två delar en värld ingen ser hela av") vs med
   väsen ("ni två uppfostrar ett väsen som bara överlever om båda kommer
   tillbaka"). Mät: lyser ögonen? Frågar de "hur då?"? Nämner de en specifik
   person de vill spela med? (Sista frågan är den viktigaste signalen.)
2. **Trollkarlen från Oz-testet (billigast tänkbara prototyp, 1 vecka):**
   Claude genererar dagliga asymmetriska gåtpar som bilder; Jeton och en
   verklig person (partner/vän) kör ritualen manuellt via WhatsApp i 7 dagar.
   Mät: kom båda tillbaka varje dag? Uppstod riktiga samtal ur gåtorna?
   Kändes dag 5 som längtan eller plikt? — Detta testar kärnhypotesen
   (daglig tvåsamhet bär) utan en rad kod.
3. **Först därefter:** beslut om prototyp. (Supercell-disciplinen: döda gratis
   är en vinst, döda efter tre månaders bygge är ett misslyckande.)

## 12. Öppna antaganden Jeton kan reagera på (inget blockerar)

- Målgruppsprioritering: par först, vän/familj-inkluderande design (§2).
- Arbetsnamnet GLÖD/EMBER och eld-metaforen som kärnfantasi.
- Prisnivå 129 kr parpass + gåvor 15–39 kr (§8).
- Sessionslöftet 5 min och säsongslängd 2 veckor.
- Trollkarlen från Oz-testet som nästa konkreta steg.
