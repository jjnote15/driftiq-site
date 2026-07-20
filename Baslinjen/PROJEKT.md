# Baslinjen — PROJEKT.md

**Läs den här filen i början av varje session som rör Baslinjen. Uppdatera den i slutet.**

Enspelarspel om att läsa människor (Chase Hughes-mekanik flippad till deckarnöje).
Fullt koncept: se `KONCEPT-BASLINJEN.md`. Detta är ett **eget projekt** — Solar
Empire (branch `claude/solar-empire-idle-game-akn240`) och GLÖD (branch
`claude/solarempire-mobile-game-ijvmk9`) ligger orörda och fredade.

**Ägare:** Jeton (entreprenör, kodar inte — Claude gör allt tekniskt).
**Startad:** 2026-07-20 (session 3). **Branch:** `claude/game-human-psychology-concept-5pr795`.

## Status just nu

| Del | Status |
|---|---|
| Konceptdokument v0.1 (kärnloop, affärsmodell, etik, säsongsplan) | ✅ Skrivet |
| Spelbar webbprototyp av Fall 01 "Handkassan" (3 akter, poäng, facit) | ✅ Byggd |
| Jeton har spelat prototypen och gett GO/NO-GO | ⚠️ Återstår — NÄSTA STEG |
| Pitchtest på 5 riktiga personer | ⚠️ Återstår (frågorna i koncept §8) |
| Fall 02+, iOS-app, namnkontroll | ⏸ Väntar på GO |

## Testa prototypen

- **Enklast:** öppna artefakt-länken Claude publicerade i chatten (funkar i
  mobil och på PC, inget konto behövs).
- **Alternativ:** ladda ned `Baslinjen/prototyp/index.html` från branchen på
  GitHub och dubbelklicka — filen är helt fristående, inga beroenden.
- Speltid ~10 min. Spela gärna två gånger (andra varvet ser man mer — det är
  en poäng med designen).

## Tekniska beslut

- **Webbprototyp före iOS:** billigaste sättet att testa om kärnloopen är rolig.
  En HTML-fil, ren vanilla JS, mobilanpassad. Kastas eller byggs ut utan smärta.
- **Tempo som information:** svarslatens ("…"-indikator) och textutrullningens
  hastighet ÄR tempo-kanalen; scenanvisningar i kursiv är kropp-kanalen.
  Billigt att producera, läsbart, och skalar till iOS senare.
- **Datadrivet fallformat:** frågor/svar/avvikelser ligger som datastrukturer i
  skriptet — nya fall är innehåll, inte kod.
- Vid iOS-GO återanvänds Solar Empire-infran: GitHub Actions Mac-byggen,
  StoreKit 2-upplägget, språksystemet (xcstrings), ljudmotorn, appetize-flödet.

## Sessionslogg

- **2026-07-20 (session 3):** Jeton bad om ett nytt parallellt enspelarkoncept
  byggt på "människors inre" (Chase Hughes, flippat till något kul). Claude
  spånade fyra riktningar (läsa andra / bli läst / simulera flocken / dagligt
  Wordle-format) med frågor och utmaningar. Jeton delegerade beslutet: "ta du
  fram något som faktiskt funkar, är roligt och folk betalar för." Claude valde
  BASLINJEN (motivering i koncept §2: bevisad betalgenre, färsk mekanik, ingen
  löpande AI-kostnad, Jeton är domänexperten), skrev konceptdokument v0.1 och
  byggde spelbar webbprototyp av Fall 01 "Handkassan". Nästa session: börja med
  Jetons speltestreaktion + pitchtestet — bygg inget mer före GO.
