# -*- coding: utf-8 -*-
# Genererar Oz-testets 14 gåtkort som HTML (screenshottas till PNG separat).
import os, html

OUT = "/tmp/claude-0/-home-user-driftiq-site/af825569-f09b-53a0-af12-7c1c0a9c9563/scratchpad/oztest_html"
os.makedirs(OUT, exist_ok=True)

CSS = """
* { margin:0; padding:0; box-sizing:border-box; }
body { width:1080px; height:1680px; font-family:'DejaVu Sans',sans-serif; }
.card { width:1080px; height:1680px; padding:52px 72px 40px; display:flex; flex-direction:column; color:#f7eeda; }
.gryning { background:linear-gradient(170deg,#472a5e 0%,#8a4049 38%,#c96f4a 68%,#f0a95c 100%); }
.skymning { background:linear-gradient(170deg,#0c1533 0%,#27234f 42%,#553a6e 74%,#8a5a86 100%); }
.top { display:flex; justify-content:space-between; align-items:baseline; letter-spacing:4px;
       font-size:26px; text-transform:uppercase; opacity:.85; }
.day { font-size:30px; font-weight:bold; }
h1 { font-family:'DejaVu Serif',serif; font-size:62px; margin:26px 0 6px; font-weight:normal; }
.side { font-size:30px; opacity:.9; margin-bottom:26px; }
.intro { font-size:31px; line-height:1.42; opacity:.95; margin-bottom:22px; }
.puzzle { background:rgba(0,0,0,.28); border:1px solid rgba(255,255,255,.25); border-radius:26px;
          padding:34px 40px; font-size:31px; line-height:1.5; flex:1; overflow:hidden; min-height:0; }
.puzzle p { margin-bottom:18px; }
.big { font-size:44px; letter-spacing:10px; text-align:center; margin:22px 0; }
.avsked { margin-top:22px; background:rgba(255,244,214,.14); border-radius:22px; padding:20px 30px;
          font-size:29px; line-height:1.4; }
.avsked .h { display:block; letter-spacing:3px; font-size:24px; text-transform:uppercase; margin-bottom:8px; opacity:.85; }
.rule { margin-top:9px; line-height:1.35; font-size:22px; opacity:.62; text-align:center; }
table.map { border-collapse:collapse; margin:10px auto; }
svg text { font-family:'DejaVu Sans',sans-serif; }
.qq { margin:14px 0 14px 8px; }
"""

def card(side, day, title, intro, body, avsked):
    glyph = "☀" if side == "gryning" else "☾"
    label = "Gryningssidan" if side == "gryning" else "Skymningssidan"
    return f"""<!doctype html><html><head><meta charset="utf-8"><style>{CSS}</style></head>
<body><div class="card {side}">
<div class="top"><span>GLÖD · OZ-TESTET</span><span class="day">DAG {day}</span></div>
<h1>{title}</h1>
<div class="side">{glyph} {label}</div>
<div class="intro">{intro}</div>
<div class="puzzle">{body}</div>
<div class="avsked"><span class="h">Avskedet — dagens gåva</span>{avsked}
<div class="rule">Prata så mycket ni vill — det är meningen. Men visa aldrig ditt kort.</div></div>
</div></body></html>"""

def grid_svg(filled, accent):
    # 5x5-rutnät, kolumner A–E, rader 1–5
    cell, x0, y0 = 92, 70, 46
    s = [f'<svg width="560" height="524" viewBox="0 0 620 580" style="display:block;margin:6px auto">']
    for i, c in enumerate("ABCDE"):
        s.append(f'<text x="{x0+i*cell+cell/2}" y="34" text-anchor="middle" font-size="30" fill="#f7eeda" opacity=".8">{c}</text>')
    for r in range(1, 6):
        s.append(f'<text x="40" y="{y0+(r-1)*cell+cell/2+10}" text-anchor="middle" font-size="30" fill="#f7eeda" opacity=".8">{r}</text>')
    for i in range(5):
        for r in range(1, 6):
            key = "ABCDE"[i] + str(r)
            fill = accent if key in filled else "rgba(255,255,255,.06)"
            s.append(f'<rect x="{x0+i*cell}" y="{y0+(r-1)*cell}" width="{cell-8}" height="{cell-8}" rx="12" fill="{fill}" stroke="rgba(255,255,255,.35)"/>')
    s.append("</svg>")
    return "".join(s)

def map_svg():
    pts = [("Duvfallet", 150, 120), ("Stenporten", 430, 90), ("Vindkullen", 340, 230),
           ("Alagranen", 130, 330), ("Glimmerkällan", 450, 360), ("Eldstaden", 240, 460),
           ("Gråängen", 430, 520), ("Månbryggan", 150, 560)]
    s = ['<svg width="550" height="568" viewBox="0 0 620 640" style="display:block;margin:4px auto">',
         '<rect x="8" y="8" width="604" height="624" rx="26" fill="rgba(255,255,255,.05)" stroke="rgba(255,255,255,.3)"/>']
    for name, x, y in pts:
        s.append(f'<circle cx="{x}" cy="{y}" r="13" fill="#ffd27a"/>')
        s.append(f'<text x="{x}" y="{y+44}" text-anchor="middle" font-size="27" fill="#f7eeda">{name}</text>')
    s.append("</svg>")
    return "".join(s)

def lantern_flower_svg():
    s = ['<svg width="640" height="430" viewBox="0 0 640 430" style="display:block;margin:2px auto">',
         '<text x="20" y="40" font-size="28" fill="#f7eeda" opacity=".85">Lyktorna vid stigen:</text>']
    for i in range(5):  # 5 lyktor
        x = 60 + i * 115
        s.append(f'<ellipse cx="{x}" cy="105" rx="34" ry="44" fill="#ffb64d" opacity=".95"/>')
        s.append(f'<rect x="{x-12}" y="52" width="24" height="12" rx="4" fill="#7a4a2a"/>')
        s.append(f'<rect x="{x-12}" y="146" width="24" height="10" rx="4" fill="#7a4a2a"/>')
    s.append('<text x="20" y="235" font-size="28" fill="#f7eeda" opacity=".85">Blommorna på ängen:</text>')
    for i in range(7):  # 7 blommor
        x = 60 + i * 82
        y = 320
        for dx, dy in [(0, -20), (0, 20), (-20, 0), (20, 0), (-14, -14), (14, -14), (-14, 14), (14, 14)]:
            s.append(f'<circle cx="{x+dx}" cy="{y+dy}" r="12" fill="#f2d9ff" opacity=".9"/>')
        s.append(f'<circle cx="{x}" cy="{y}" r="13" fill="#ffd24d"/>')
    s.append("</svg>")
    return "".join(s)

def birds_window_svg():
    s = ['<svg width="640" height="430" viewBox="0 0 640 430" style="display:block;margin:2px auto">',
         '<text x="20" y="40" font-size="28" fill="#f7eeda" opacity=".85">Fåglarna på himlen:</text>']
    for i, (x, y) in enumerate([(120, 110), (300, 85), (470, 125)]):  # 3 fåglar
        s.append(f'<path d="M {x-44} {y} Q {x-22} {y-30} {x} {y} Q {x+22} {y-30} {x+44} {y}" '
                 f'stroke="#f7eeda" stroke-width="8" fill="none" stroke-linecap="round"/>')
    s.append('<text x="20" y="225" font-size="28" fill="#f7eeda" opacity=".85">Huset vid dalens rand:</text>')
    s.append('<rect x="180" y="260" width="280" height="150" rx="10" fill="rgba(255,255,255,.10)" stroke="rgba(255,255,255,.4)"/>')
    s.append('<path d="M 165 262 L 320 195 L 475 262 Z" fill="rgba(255,255,255,.16)"/>')
    wins = [(215, 290), (305, 290), (395, 290), (305, 355)]
    for i, (x, y) in enumerate(wins):  # 1 tänt fönster (det första)
        fill = "#ffcf5e" if i == 0 else "rgba(20,25,60,.85)"
        s.append(f'<rect x="{x}" y="{y}" width="52" height="52" rx="6" fill="{fill}" stroke="rgba(255,255,255,.5)"/>')
    s.append("</svg>")
    return "".join(s)

def ring_svg():
    import math
    letters = ["S", "E", "A", "L", "T", "A", "R", "V", "O", "K", "N", "M"]  # pos 1..12
    s = ['<svg width="550" height="532" viewBox="0 0 620 600" style="display:block;margin:4px auto">',
         '<circle cx="310" cy="300" r="230" fill="none" stroke="rgba(255,255,255,.4)" stroke-width="3"/>',
         '<circle cx="310" cy="300" r="60" fill="#ffb64d" opacity=".9"/>']
    for i in range(12):
        ang = math.radians(-90 + i * 30)
        lx, ly = 310 + 185 * math.cos(ang), 300 + 185 * math.sin(ang)
        nx, ny = 310 + 262 * math.cos(ang), 300 + 262 * math.sin(ang)
        s.append(f'<text x="{lx:.0f}" y="{ly+14:.0f}" text-anchor="middle" font-size="44" fill="#f7eeda" font-weight="bold">{letters[i]}</text>')
        s.append(f'<text x="{nx:.0f}" y="{ny+9:.0f}" text-anchor="middle" font-size="26" fill="#f7eeda" opacity=".65">{i+1}</text>')
    s.append("</svg>")
    return "".join(s)

CARDS = []

# ---------- DAG 1 ----------
CARDS.append(("dag1-till-dig-gryning", card("gryning", 1, "Symbolbron",
 "Sex stenar reser sig ur dimman på din sida. Du ser i vilken <b>ordning</b> de står — men tecknens bokstäver finns bara på skymningssidan.",
 """<p>Stenarnas ordning, från dalens mitt och utåt:</p>
 <div class="big">☾ &nbsp; ★ &nbsp; ≈ &nbsp; ■ &nbsp; ◆ &nbsp; ▲</div>
 <p>Din människa vet vilken bokstav varje tecken bär. Tillsammans bildar ni <b>dagens ord</b> — sex bokstäver.</p>
 <p>När ni har ordet: skicka det till varandra samtidigt.</p>""",
 "Skicka en bild på något <b>gult</b> du ser just nu — utan förklaring.")))

CARDS.append(("dag1-till-din-manniska-skymning", card("skymning", 1, "Symbolbron",
 "Sex tecken lyser svagt i skymningen på din sida. Du ser vilken <b>bokstav</b> varje tecken bär — men i vilken ordning stenarna står vet bara gryningssidan.",
 """<p>Tecknens bokstäver:</p>
 <div class="big">☾ = G &nbsp;&nbsp; ★ = N &nbsp;&nbsp; ≈ = I</div>
 <div class="big">■ = S &nbsp;&nbsp; ◆ = T &nbsp;&nbsp; ▲ = A</div>
 <p>Din människa ser ordningen. Tillsammans bildar ni <b>dagens ord</b> — sex bokstäver.</p>
 <p>När ni har ordet: skicka det till varandra samtidigt.</p>""",
 "Skicka en bild på något <b>blått</b> du ser just nu — utan förklaring.")))

# ---------- DAG 2 ----------
CARDS.append(("dag2-till-dig-gryning", card("gryning", 2, "Mönsterhalvan",
 "I natt föll ljus över dalen och lämnade ett mönster — men hälften landade hos dig och hälften hos din människa.",
 f"""<p>Dina lysande rutor:</p>{grid_svg({"A1","E2","D3","C4"}, "#ffcf5e")}
 <p>Beskriv era rutor för varandra (t.ex. ”A1”). Lägg ihop dem i huvudet eller på papper: tillsammans bildar de <b>en bokstav</b>. Vilken?</p>""",
 "Skicka en bild på din utsikt just nu, precis som den är.")))

CARDS.append(("dag2-till-din-manniska-skymning", card("skymning", 2, "Mönsterhalvan",
 "I natt föll ljus över dalen och lämnade ett mönster — men hälften landade hos dig och hälften hos din människa.",
 f"""<p>Dina lysande rutor:</p>{grid_svg({"E1","A2","B3"}, "#c9a1ff")}
 <p>Beskriv era rutor för varandra (t.ex. ”E1”). Lägg ihop dem i huvudet eller på papper: tillsammans bildar de <b>en bokstav</b>. Vilken?</p>""",
 "Skicka en bild på det närmaste fönstret — inifrån eller utifrån.")))

# ---------- DAG 3 ----------
CARDS.append(("dag3-till-dig-gryning", card("gryning", 3, "Vandringen",
 "Glöden var ute och vandrade i natt. Du hörde dess steg — men kartan över dalen finns bara på skymningssidan.",
 """<p>Så här gick vandringen, i fyra steg:</p>
 <p class="qq">1. Den vaknade vid platsen <b>där vattnet faller</b>.</p>
 <p class="qq">2. Den vilade under trädet <b>som aldrig tappar sina barr</b>.</p>
 <p class="qq">3. Den drack ur källan <b>som speglar månen</b>.</p>
 <p class="qq">4. Den somnade <b>där gräset alltid är vått</b>.</p>
 <p>Be din människa om platsernas namn. De fyra platsernas <b>första bokstäver</b>, i vandringens ordning, bildar dagens ord.</p>""",
 "Röstmeddelande: berätta om en plats ni båda har varit på — och varför du tänker på den idag.")))

CARDS.append(("dag3-till-din-manniska-skymning", card("skymning", 3, "Vandringen",
 "Glöden var ute och vandrade i natt. Du har kartan över dalen — men bara gryningssidan hörde vart stegen gick.",
 f"""{map_svg()}<p>Din människa beskriver fyra platser i tur och ordning. Hitta dem på kartan — deras <b>första bokstäver</b> bildar dagens ord.</p>""",
 "Röstmeddelande: vilken plats vill du ta med din människa till någon dag — och varför?")))

# ---------- DAG 4 ----------
CARDS.append(("dag4-till-dig-gryning", card("gryning", 4, "Rösterna",
 "Idag talar dalen i rytmer. Ni skickar varandra ett ljud — och bara den andre kan tyda det.",
 """<p><b>1. Skicka:</b> knacka eller nynna denna rytm i ett röstmeddelande<br>(● = kort, — = lång):</p>
 <div class="big">● ● — ●</div>
 <p><b>2. Tyd din människas rytm</b> med din lexikonhalva:</p>
 <p class="qq">— ● ● &nbsp;=&nbsp; STJÄRNA<br>● ● — &nbsp;=&nbsp; REGN<br>● — ● &nbsp;=&nbsp; MÅNE<br>— — — &nbsp;=&nbsp; SNÖ</p>
 <p><b>3.</b> Sätt ihop: det din människa tyder ur <b>din</b> rytm, följt av det du tyder ur <b>hens</b>. Tillsammans blir det ett enda ord.</p>""",
 "Skicka den fånigaste selfie du vågar.")))

CARDS.append(("dag4-till-din-manniska-skymning", card("skymning", 4, "Rösterna",
 "Idag talar dalen i rytmer. Ni skickar varandra ett ljud — och bara den andre kan tyda det.",
 """<p><b>1. Skicka:</b> knacka eller nynna denna rytm i ett röstmeddelande<br>(● = kort, — = lång):</p>
 <div class="big">— ● ●</div>
 <p><b>2. Tyd din människas rytm</b> med din lexikonhalva:</p>
 <p class="qq">● ● — ● &nbsp;=&nbsp; GRYNING<br>— ● — &nbsp;=&nbsp; ASKA<br>● — — ● &nbsp;=&nbsp; LÅGA<br>● ● ● &nbsp;=&nbsp; VIND</p>
 <p><b>3.</b> Sätt ihop: det du tyder ur <b>hens</b> rytm, följt av det hen tyder ur <b>din</b>. Tillsammans blir det ett enda ord.</p>""",
 "Skicka en bild på något du åt eller drack idag.")))

# ---------- DAG 5 ----------
CARDS.append(("dag5-till-dig-gryning", card("gryning", 5, "Frågorna",
 "Idag är gåtan din människa. Gissa först — skriv ner dina svar. Fråga sedan, och se hur nära du kom.",
 """<p class="qq"><b>1.</b> Soluppgång eller solnedgång — vilken skulle hen välja?</p>
 <p class="qq"><b>2.</b> Vilken doft tar hen rakt tillbaka till barndomen?</p>
 <p class="qq"><b>3.</b> Om hen fick bo var som helst i världen i en vecka — var?</p>
 <p>Varje rätt gissning ger er en <b>glödsten</b>. Räkna ihop era stenar tillsammans (max 6).</p>""",
 "Berätta ett minne från er första tid som ni aldrig pratar om — i ord eller bild.")))

CARDS.append(("dag5-till-din-manniska-skymning", card("skymning", 5, "Frågorna",
 "Idag är gåtan din människa. Gissa först — skriv ner dina svar. Fråga sedan, och se hur nära du kom.",
 """<p class="qq"><b>1.</b> Berg eller hav — vilket skulle hen välja?</p>
 <p class="qq"><b>2.</b> Vilken låt sätter hen på när ingen hör?</p>
 <p class="qq"><b>3.</b> Vad ville hen bli när hen var tio år?</p>
 <p>Varje rätt gissning ger er en <b>glödsten</b>. Räkna ihop era stenar tillsammans (max 6).</p>""",
 "Berätta ett minne från er första tid som ni aldrig pratar om — i ord eller bild.")))

# ---------- DAG 6 ----------
CARDS.append(("dag6-till-dig-gryning", card("gryning", 6, "Sifferlåset",
 "Glödens skrin har ett lås med fyra siffror. Ledtrådarna finns hos dig — men det de räknar syns bara på skymningssidan. Och tvärtom.",
 f"""{lantern_flower_svg()}
 <p><b>Dina ledtrådar:</b></p>
 <p class="qq">Siffra 1 = antalet <b>fåglar</b> på skymningssidans himmel.<br>
 Siffra 3 = antalet <b>tända fönster</b> i skymningssidans hus.</p>
 <p>Din människa har ledtrådarna till siffra 2 och 4 — de räknar det du ser ovan. När ni har koden: skicka den samtidigt.</p>""",
 "Skicka en bild på något som är trasigt men älskat.")))

CARDS.append(("dag6-till-din-manniska-skymning", card("skymning", 6, "Sifferlåset",
 "Glödens skrin har ett lås med fyra siffror. Ledtrådarna finns hos dig — men det de räknar syns bara på gryningssidan. Och tvärtom.",
 f"""{birds_window_svg()}
 <p><b>Dina ledtrådar:</b></p>
 <p class="qq">Siffra 2 = antalet <b>lyktor</b> vid gryningssidans stig.<br>
 Siffra 4 = antalet <b>blommor</b> på gryningssidans äng.</p>
 <p>Din människa har ledtrådarna till siffra 1 och 3 — de räknar det du ser ovan. När ni har koden: skicka den samtidigt.</p>""",
 "Skicka en bild på något som är gammalt men vackert.")))

# ---------- DAG 7 ----------
CARDS.append(("dag7-till-dig-gryning", card("gryning", 7, "Kläckningen",
 "Sista dagen. Glödens sigill står på din sida — tolv bokstäver i en ring. Men bara skymningssidan vet vilka som ska läsas, och i vilken ordning.",
 f"""{ring_svg()}<p>Läs upp ringen för din människa när hen ber om positioner. Ordet ni finner är det som väcker glöden.</p>""",
 "När ni har ordet: viska det i varsitt röstmeddelande — och skicka sedan en bild på en <b>riktig låga</b> (ett ljus, en spis, en eld). Glöden har kläckts.")))

CARDS.append(("dag7-till-din-manniska-skymning", card("skymning", 7, "Kläckningen",
 "Sista dagen. Du bär nyckeln till glödens sigill — men själva ringen med bokstäverna står på gryningssidan.",
 """<p><b>Nyckeln:</b> be din människa läsa bokstäverna vid dessa positioner, i exakt denna ordning:</p>
 <div class="big">8 &nbsp; · &nbsp; 3 &nbsp; · &nbsp; 10 &nbsp; · &nbsp; 11 &nbsp; · &nbsp; 6</div>
 <p>Ordet ni finner är det som väcker glöden.</p>""",
 "När ni har ordet: viska det i varsitt röstmeddelande — och skicka sedan en bild på en <b>riktig låga</b> (ett ljus, en spis, en eld). Glöden har kläckts.")))

for name, htmldoc in CARDS:
    with open(os.path.join(OUT, name + ".html"), "w", encoding="utf-8") as f:
        f.write(htmldoc)
print("Skrev", len(CARDS), "kort till", OUT)
