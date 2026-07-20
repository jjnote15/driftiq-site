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
| Konceptdokument v0.2 (kärnloop, affärsmodell, etik, fallbibel för säsong 1) | ✅ Skrivet |
| Prototyp v0.2: hubb/persongalleri + sparade framsteg (localStorage) | ✅ Byggd |
| Fall 01 "Handkassan" (Moa — nervositet är inte skuld) | ✅ Byggd |
| Fall 02 "Den som aldrig darrar" (Richard — manus varierar inte; ny mekanik: ställ frågan igen) | ✅ Byggd |
| Delbart utlåtandekort (canvas-bild) + syntetiserat ljud (valbart) | ✅ Byggd |
| Automatisk genomspelning av båda fallen utan fel (Playwright) | ✅ Grönt |
| Jeton speltestar v0.2 + pitchtest på 5 personer | ⚠️ Återstår — NÄSTA STEG |
| Fall 03 "Två personer, en lögn" (tvåstols-mekanik) | ⏸ Nästa bygge |
| iOS-app, namnkontroll, App Store | ⏸ Efter fler fall + speltest |

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
  byggde spelbar webbprototyp av Fall 01 "Handkassan".
- **2026-07-20 (session 3, forts — GO):** Jeton: "Gå vidare med detta koncept
  och utveckla på djupet — riktigt grymt." Claude byggde v0.2: datadriven
  fallmotor, hubb med persongalleri och sparade framsteg, Fall 02 "Den som
  aldrig darrar" (motsatt lärdom + ny »ställ frågan igen«-mekanik), delbart
  utlåtandekort (canvas), syntetiserat ljud med av/på, reduced-motion-stöd.
  Fallbibeln för hela säsong 1 (10 fall, en lärdom + en mekanik per fall)
  skriven i koncept §4b. Båda fallen automatiskt genomspelade utan fel
  (perfekt spel = exakt maxpoäng: 120 resp 115). Obs: artefakt-länkar öppnades
  inte hos Jeton tidigare — spelfilen skickas även direkt i chatten och via
  raw.githack-länk. Nästa session: Jetons reaktion på v0.2 (fråga särskilt om
  Fall 02 kändes tillräckligt ANNORLUNDA än Fall 01 — det är variationstestet),
  därefter Fall 03 med tvåstols-mekanik.
