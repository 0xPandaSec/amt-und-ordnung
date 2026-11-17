# Amt & Ordnung — Game Design Document

**Version:** 0.1 (Konzept)
**Status:** Pre-Prototyp
**Zielplattform:** Steam (Windows, Linux, Steam Deck), lokal / Hotseat, 2–5 Spieler
**Genre:** Karten-Partyspiel, Push-your-luck, Elimination

---

## 1. Elevator Pitch

> Du wolltest nur einen Bauantrag einreichen. Jetzt sitzt du im Vorzimmer des *Amts für
> allgemeine Ordnung*, das Deck ist voller **Auflagenbescheide**, und der letzte, der noch
> im Wartezimmer sitzt, gewinnt.

Ein Kartenspiel für alle, die schon einmal ein Formular ausgefüllt haben. Ziehen ist
gefährlich, Widerspruch ist die einzige Rettung, und der Formfehler ist deine Waffe.

**Ein Satz für die Steam-Seite:**
*„Zieh eine Karte. Wenn es ein Auflagenbescheid ist, war's das — es sei denn, du hast
einen Widerspruch."*

---

## 2. Positionierung

| | |
|---|---|
| **Zielgruppe** | DACH, 18–45, Büro-/Behörden-Erfahrung, Humor-affin, Gelegenheitsspieler |
| **Session-Länge** | 10–20 Minuten pro Runde |
| **Modus** | Lokal 2–5 Spieler (Hotseat), Solo gegen KI-Bots |
| **Preis** | 8,99 – 9,99 € (Launch-Rabatt 15 %) |
| **Vergleichstitel** | Exploding Kittens (Mechanik), Unstable Unicorns, Rento |
| **USP** | Bürokratie-Satire im DACH-Raum. Kein anderes Kartenspiel besetzt dieses Thema. Art-Stil, der mit Typografie statt teurer Illustration funktioniert. |

**Wichtig:** In Marketing und Store-Texten *nie* „wie Exploding Kittens" schreiben.
Mechaniken sind frei, Markenvergleiche sind es nicht.

---

## 3. Kern-Loop

```
Zugbeginn
   ↓
beliebig viele Aktionskarten spielen (oder keine)
   ↓
genau 1 Karte ziehen
   ↓
Auflagenbescheid?  ── nein ──→  Karte auf die Hand, Zug endet
   │ ja
   ↓
Widerspruch auf der Hand?  ── nein ──→  RAUS
   │ ja
   ↓
Bescheid verdeckt an beliebiger Stelle ins Deck zurücklegen
   ↓
Zug endet
```

Der Nervenkitzel entsteht an genau einer Stelle: **dem Moment vor dem Ziehen**.
Alles andere im Spiel dient dazu, diesen Moment hinauszuzögern, zu entschärfen oder
auf jemand anderen abzuwälzen.

---

## 4. Regeln (vollständig)

### 4.1 Aufbau

1. Karten nach Typ sortieren.
2. **1 Widerspruch pro Spieler** aus den 6 heraussortieren und beiseitelegen.
3. **Auflagenbescheide** ins Deck mischen — Anzahl = **Spielerzahl − 1**
   (2 → 1, 3 → 2, 4 → 3, 5 → 4).
4. Alle **übrigen Widersprüche** ins Deck mischen.
5. Deck mischen, **4 Karten pro Spieler** als Starthand austeilen.
6. Jeder Spieler bekommt seinen beiseitegelegten **Widerspruch** auf die Hand
   → Starthand = 5 Karten, davon genau 1 Widerspruch.
7. Der jüngste Spieler beginnt.

### 4.2 Ein Zug

In beliebiger Reihenfolge:

- **Beliebig viele** Aktionskarten spielen (auch Null, auch mehrere gleiche)
- **Genau eine** Karte ziehen — Pflicht, nicht optional

Es gibt **kein Handkartenlimit**.
Nach dem Ziehen endet der Zug sofort.

### 4.3 Der Auflagenbescheid

Ziehst du einen Auflagenbescheid:

- **Mit Widerspruch:** Widerspruch und Bescheid zeigen, Widerspruch auf den Ablagestapel.
  Den Bescheid **verdeckt an eine beliebige Position** im verbleibenden Deck zurücklegen.
  Du darfst dabei zusehen, wie das Deck gemischt wird — aber niemand weiß, wo er liegt.
- **Ohne Widerspruch:** Du bist raus. Deine Handkarten kommen offen auf den Ablagestapel.
  Bescheid bleibt aus dem Spiel.

### 4.4 Die Reaktionskette (Formfehler!)

`Formfehler!` annulliert **eine** gerade gespielte Aktion.

- Wird eine Aktion gespielt, öffnet sich ein Reaktionsfenster.
- Jeder Spieler (auch der aktive) darf **einen** Formfehler spielen.
- Ein Formfehler kann selbst durch einen Formfehler annulliert werden → **LIFO-Stack**.
- Bei **gerader** Anzahl gespielter Formfehler: Aktion **wird ausgeführt**.
- Bei **ungerader** Anzahl: Aktion **verpufft**, alle beteiligten Karten auf den Ablagestapel.
- Das Reaktionsfenster hat einen **kurzen Timer** (~3 Sekunden), damit Hotseat-Runden
  nicht durch Nachdenken stehen.

**Nicht konterbar:** das Ziehen einer Karte und das Aufdecken eines Auflagenbescheids.

### 4.5 Kartentypen

| Karte | Kopien | Effekt | Konterbar |
|---|---|---|---|
| **Auflagenbescheid** | 4 (skaliert) | Ziehen = raus, wenn kein Widerspruch | nein |
| **Widerspruch** | 6 | Entschärft einen Bescheid | nein |
| **Formfehler!** | 5 | Annulliert eine Aktion | ja (durch sich selbst) |
| **Vorgang vertagen** | 4 | Zug endet ohne Ziehen | ja |
| **Fristverlängerung** | 4 | Nächster Spieler muss 2× ziehen; danach ist er dran | ja |
| **Amtshilfe** | 4 | Ein Spieler deiner Wahl gibt dir eine Karte seiner Wahl | ja |
| **Zuständigkeit wechseln** | 4 | Deck wird neu gemischt | ja |
| **Akteneinsicht** | 5 | Sieh dir die obersten 3 Karten an, lege sie in gleicher Reihenfolge zurück | ja |
| **Aus dem Archiv** | 4 | Ziehe die unterste Karte des Decks | ja |
| **Dokumente** (5 Typen, siehe §4.6) | je 5 (25) | Effektlos — nur als Kombination spielbar | ja |

**Gesamt: 65 Karten**

### 4.6 Dokumente (Setzsammlung)

Fünf Dokumenttypen, **je 5 Kopien = 25 Karten**. Sie haben **keinen eigenen Effekt** und
können **ausschließlich als Kombination** gespielt werden. Einzeln auf der Hand sind sie
totes Gewicht — das ist Absicht, es erzeugt den Druck, Kombinationen zu sammeln.

| Dokument | Farbe | Symbol |
|---|---|---|
| **Bauantrag** | Blau | Zirkel |
| **Lärmprotokoll** | Grün | Schallwellen |
| **Grundriss** | Gelb | Grundriss-Linien |
| **Statiknachweis** | Rot | Träger |
| **Nachbarschaftsbeschwerde** | Lila | Ausrufezeichen-Brief |

Jedes Dokument existiert in **Farbe + Symbol + Name**. Nie nur Farbe — sonst ist das
Spiel für Farbenblinde unspielbar und fällt beim Steam-Accessibility-Check durch.

**Kombinationen** (die Kombination ersetzt jeden aufgedruckten Effekt):

| Kombination | Name | Effekt |
|---|---|---|
| **2 gleiche** | Paar | Ziehe eine **zufällige** Karte von einem Spieler deiner Wahl |
| **3 gleiche** | Drilling | **Benenne** eine Karte. Hat der Zielspieler sie, muss er sie dir geben |
| **5 gleiche** | Volle Akte | Nimm **eine Karte deiner Wahl aus dem Ablagestapel** auf die Hand |

**Warum kein Vierling?** Ein Vierling ist eine tote Stufe: er kostet 4 Karten und wäre
zwischen „Karte benennen" (3) und „aus der Ablage holen" (5) nicht sinnvoll zu dosieren.
Drei Stufen sind erklärbar, vier sind Buchhaltung.

**Regeln zu Kombinationen:**
- Alle Karten einer Kombination werden zusammen gespielt und gehen danach auf den Ablagestapel.
- Beim Paar bestimmst **du** das Ziel, aber der Zufall entscheidet über die Karte.
- Beim Drilling bestimmt der Zielspieler, **ob** er die Karte hat — im Zweifel muss er
  seine Hand vorzeigen. Lügen ist keine Option, Betrug ist keine Spielmechanik.
- Kombinationen sind konterbar (`Formfehler!`) — auch das Paar.
- Dokumente dürfen **nicht** typübergreifend gemischt werden
  (kein „2× Bauantrag + 1× Grundriss").

> **Optional für später (Stufe 2, „Remix-Regel"):** Jedes **beliebige** Kartenpaar mit
> gleichem Titel funktioniert als Paar — also auch 2× `Zuständigkeit wechseln`. Das
> reduziert tote Hände massiv, verändert aber das Balancing stark. Als Toggle im
> Optionsmenü, nicht als Standard.

### 4.7 Sonderfälle

- **Deck leer:** Ablagestapel (ohne Bescheide) mischen und als neues Deck verwenden.
  Sind Deck *und* Ablage leer, wird nicht gezogen und der Zug endet. Das ist ein
  Edge-Case, der in der Praxis so gut wie nie auftritt — aber er muss definiert sein,
  sonst hängt der Prototyp.
- **Letzter Spieler:** Gewinnt sofort, sobald nur noch er übrig ist.
  Ein Zug muss nicht zu Ende gespielt werden.
- **Fristverlängerung auf Fristverlängerung:** addiert sich. 2 + 2 = 4 Züge für den
  nächsten Spieler.
- **Akteneinsicht:** nur der aktive Spieler sieht die Karten. Im Hotseat: „Weiter"-Button
  mit verdecktem Bildschirmzustand.

---

## 5. Vollständiges Deck (65 Karten)

| Bereich | Karten | Anzahl |
|---|---|---|
| Bedrohung | Auflagenbescheid | 4 |
| Rettung | Widerspruch | 6 |
| Reaktion | Formfehler! | 5 |
| Verzögerung | Vorgang vertagen, Fristverlängerung | 8 |
| Information | Akteneinsicht | 5 |
| Kontrolle | Zuständigkeit wechseln, Aus dem Archiv | 8 |
| Interaktion | Amtshilfe | 4 |
| Dokumente | Bauantrag, Lärmprotokoll, Grundriss, Statiknachweis, Nachbarschaftsbeschwerde | 25 |
| **Summe** | | **65** |

**Balancing-Annahmen (im Prototyp zu prüfen):**
- 6 Widersprüche bei 5 Spielern = 1,2 pro Spieler → knapp, aber nicht unfair
- 5 Formfehler ist bewusst hoch: die Reaktionskette ist der Spaßfaktor
- 4 Auflagenbescheide sind das Maximum; bei 2 Spielern bleiben nur 1 übrig
- **25 Dokumente = 38 % des Decks.** Das ist Absicht und entspricht dem Verhältnis des
  Vorbilds (20 von 56). Ohne diesen Anteil gäbe es zu wenige Kombinationen und die Hände
  wären zu mächtig. Prüfen: fühlt sich das Deck „zu voller Müll" an? Falls ja, erst
  `Widerspruch` erhöhen, nicht die Dokumente senken.

---

## 6. Art Direction

### Palette

| Rolle | Farbe |
|---|---|
| Papier | `#F4F1E8` |
| Amtsschimmel-Grün | `#4F6B3A` |
| Stempelrot | `#B02A2A` |
| Akten-Grau | `#5C5C56` |
| Highlighter-Gelb | `#E8D44D` |
| Tinte-Schwarz | `#1C1B18` |

### Dokumentfarben (Kombinations-Set)

| Dokument | Farbe | Hex |
|---|---|---|
| Bauantrag | Blau | `#2C5F8A` |
| Lärmprotokoll | Grün | `#3F7A4C` |
| Grundriss | Gelb | `#D9A521` |
| Statiknachweis | Rot | `#A8322F` |
| Nachbarschaftsbeschwerde | Lila | `#6B4B8A` |

Die fünf Dokumente müssen **auf einen Blick** unterscheidbar sein — das ist die wichtigste
Einzelentscheidung im ganzen Kartenlayout. Deshalb: Farbe **plus** Symbol **plus** Name,
und das Symbol sitzt an derselben Stelle auf jeder Karte.

### Stil

Jede Karte ist **ein Formular**: Vordruck-Rahmen, Feldnummern, Kästchen zum Ankreuzen,
Durchschlag-Löcher, ein Stempel, eine handschriftliche Randnotiz, gelegentlich ein
Kaffeefleck. Die Illustration ist Typografie, nicht Malerei.

Das ist der wirtschaftliche Kern des Konzepts: **Der Look entsteht aus Layout, Textur
und Stempeln — nicht aus 56 handgemalten Illustrationen.** Ein einzelnes Karten-Artwork
kostet damit einen Bruchteil dessen, was ein Illustrations-Set kosten würde.

### Bewegung & Sound

| Element | Idee |
|---|---|
| Karte spielen | Papier rutscht über den Tisch, leises Knistern |
| Stempel-Aktionen | „KLACK" + kurzer Screenshake |
| Bescheid gezogen | Roter Stempel schlägt auf, Papier zerknittert |
| Widerspruch | Zweiter Stempel über den ersten, „ABGELEHNT"-Sound rückwärts |
| Niederlage | Aktenordner klappt zu |
| Hintergrundmusik | **Warteschleifen-Musik** — gedämpftes Saxophon-Loop, unterbrochen von „Ihre Anfrage wird bearbeitet" |
| Sieg | Locher-Geräusch, Papierstapel fällt um |

Die Warteschleife als Musik ist der Gag, über den Leute reden. Budget dafür einplanen.

### Schriften (alle OFL-lizenziert)

- **Grotesk** für Fließtext/UI: `Inter` oder `IBM Plex Sans`
- **Stempel/Maschinenschrift** für Kartentitel: `Special Elite` oder `Courier Prime`

### Kartenlayout

Format **63 × 88 mm** (Standard-TCG, passt in 63,5 × 88,9-Sleeves). Aufbau von oben nach unten:

| Zone | Höhe | Inhalt |
|---|---|---|
| Farbbalken | 1,3 mm | Kategorie- bzw. Dokumentfarbe |
| Kopf | 10 mm | **Symbol oben links** (7 mm, farbig hinterlegt), Formularzeile, Kartentitel |
| Artwork | 40 mm | Comic-Illustration, Kategorie-Stempel unten rechts |
| Wirkung | flexibel | Effekttext in einem gestrichelten Formularfeld mit Beschriftung |
| Flavor | ~5 mm | kursiver Begleittext, abgetrennt durch Haarlinie |
| Fußzeile | 4,5 mm | Kartennummer (`Nr. 001 / 065`) und Anzahl im Deck |

**Warum genau diese Zonen:**
- Das **Symbol oben links** ist der Anker: Man erkennt eine Karte am Tisch, ohne den Text
  zu lesen — wichtig, wenn fünf Leute gleichzeitig auf ihre Hände schauen.
- Das **Artwork belegt 45 % der Karte**. Es ist der Grund, warum die Karten im Regal
  funktionieren, und gleichzeitig der teuerste Teil. Deshalb: ein Layout, 14 Motive.
- Der **Effekttext steht unter dem Bild**, weil das die Erwartung von jedem erfüllt, der
  schon mal ein Sammelkartenspiel in der Hand hatte. Keine Lernkurve.
- Die **Fußzeile** ist Buchhaltung für den Prototyp (Zählen beim Sortieren). Im fertigen
  Spiel bleibt nur die Kartennummer.

**Illustrationsbedarf: 14 Motive für 65 Karten.** Nicht 65. Jeder Kartentyp hat ein
Motiv, die Kopien teilen es sich. Das ist der Unterschied zwischen einem bezahlbaren und
einem unbezahlbaren Art-Budget.

---

## 7. Name & Marke

**Arbeitstitel: „Amt & Ordnung"** (Wortspiel auf „Recht und Ordnung")

Alternativen: *Vorgang abgelehnt*, *Amtsschimmel*, *Formular 42*, *Posteingang*.

Vor Festlegung zwingend prüfen:
- [ ] DPMA-Recherche (DE-Marke, Klasse 9/28/41)
- [ ] EUIPO-Recherche
- [ ] Steam-Suche (gibt es den Namen schon?)
- [ ] Domain + Social Handles
- [ ] Nicht in die Nähe von „Aktenzeichen XY" (TV-Format, eingetragene Marke)

---

## 8. Lokalisierung

| Sprache | Priorität | Aufwand |
|---|---|---|
| Deutsch | 1 (Original) | — |
| Englisch | 1 (Steam-Pflicht für Reichweite) | ~120 Strings, überwiegend Wortwitze → muss von einem Menschen übersetzt werden, nicht maschinell |
| Französisch | 2 | optional nach Launch |
| Polnisch, Türkisch | 3 | nur bei Nachfrage |

Alle Texte müssen ab Tag 1 in einer `localization/`-Datei liegen. Kein String im Code.

---

## 9. Risiken

| Risiko | Auswirkung | Gegenmaßnahme |
|---|---|---|
| „Nur ein Klon" | Reviews, mangelnde Sichtbarkeit | Eigenes Theme als Kernverkauf, nicht die Mechanik |
| Humor funktioniert nur auf Deutsch | Reichweite | EN-Übersetzung von Muttersprachler:in |
| Reaktionskette in Hotseat zu langsam | Spielspaß kippt | Timer, Hotseat-UI mit verdecktem Bildschirm |
| Art wird zu teuer | Budget | Typografie-Look statt Illustration (siehe § 6) |
| Scope Creep (Online-MP, Kampagne) | Release platzt | v1.0 ohne Online, Bots stattdessen |
| Steam-Seite ohne Wishlists | Flop trotz gutem Spiel | Coming-Soon-Seite sobald Vertical Slice steht |

---

## 10. Definition of Done — v1.0

- [ ] 65 Karten vollständig implementiert und gebalanced
- [ ] 2–5 Spieler lokal, Hotseat mit verdeckter Hand
- [ ] 1–4 KI-Bots mit drei Schwierigkeitsgraden
- [ ] Tutorial, das die Reaktionskette erklärt
- [ ] Menü, Einstellungen, Pause, Speichern des laufenden Spiels
- [ ] DE + EN vollständig
- [ ] 10 Achievements, Cloud Saves, Steam Deck Verified
- [ ] 8+ externe Playtester ohne Blocker-Bug
- [ ] Store-Seite, Trailer, Demo

---

## 10.1 Umsetzungsstand — 3D-Vertical-Slice (Godot 4.7)

Umgesetzt:

- Kellerraum, Tisch, Stühle, Requisiten — vollständig prozedural aus Primitiven, keine Modell-Dateien
- Erste-Person-Kamera am Tisch, Blickneigung begrenzt, Umsehen per rechter Maustaste oder Pfeiltasten
- Hand aus 5 Karten im Kameraraum, Anheben beim Überfahren (Physik-Raycast auf Kartenflächen)
- Zieh- und Ablagestapel sichtbar, sobald der Zeiger nicht auf der Hand liegt
- Drei Gegnerfiguren mit eigenem Kartenfächer, Blickbewegung und Atmung
- Kartenoberflächen identisch zur Druckvorlage (gerendert aus `style.css`)

Bewusste Festlegungen:

- **Sichtbarer Zeiger statt Maus-Capture.** Karten-Hover braucht eine absolute
  Zeigerposition, freies Umsehen braucht eine gefangene Maus. Beides gleichzeitig geht
  nicht — also bleibt der Zeiger sichtbar und das Umsehen liegt auf der rechten Maustaste.
- **Primitive statt Modelle.** Ohne Art-Skills ist ein stimmiger Raum aus Kästen,
  Zylindern und Kugeln schneller erreichbar als mit gekauften Platzhalter-Modellen. Die
  Figuren dürfen cartoonhaft sein; das passt zum Tusche-Stil der Karten.

Noch offen: Regel-Engine, Karten ausspielen, Bots, Menü, Sound.

---

## 11. Nächste Schritte

1. **Papier-Prototyp** — 65 Karten drucken, 5 Runden spielen, Balancing notieren
2. **Regel-Engine** (GDScript, engine-unabhängig) + Tests
3. **Konsolen-Prototyp** — komplettes Spiel headless durchspielbar
4. **Andocken der Engine an die 3D-Szene** — Karten ausspielen, Ziehen, Reaktionskette
5. **Art-Pass** — ein Kartenlayout, final, als Vorlage für alle 65

---

## 12. Content-Roadmap — wie viele Karten verträgt das Spiel?

### 12.1 Ausgangslage

Das Vorbild hat über alle Produkte hinweg **45 Kartentypen**. Davon stammen aber:

| Quelle | Kartentypen |
|---|---|
| Basisspiel | 9 |
| Erweiterung „Imploding" | 2 |
| Erweiterung „Streaking" | 4 |
| Erweiterung „Barking" | 7 |
| „Recipes for Disaster" | ~10 (Remix-Box) |
| „Good vs. Evil" (Modul) | 3 (Godcat/Devilcat/Armageddon) |
| „Zombie Kittens" (Modul) | 7 (Tote/Wiederbelebung) |

**Digitale Spiele haben keine Druckkosten.** 250 Karten kosten exakt so viel wie 56. Die
Menge ist also nicht das Problem.

### 12.2 Der eigentliche Preis: Interaktionsmatrix

Der Aufwand wächst **quadratisch**, nicht linear:

| Kartentypen | Kartenpaare, die sich gegenseitig beeinflussen können |
|---|---|
| 10 | ~100 |
| 25 | ~625 |
| 45 | ~2.000 |

Bei 45 Typen musst du für **jede Kombination** beantworten:
*Kann A B kontern? Was passiert, wenn B mitten in A gespielt wird? Was, wenn beide
gleichzeitig im Reaktionsfenster liegen?*

Genau hier sterben Kartenspiel-Klone: nicht an zu wenig Content, sondern an
Wechselwirkungen, die niemand getestet hat.

### 12.3 Die Lösung: eine generische Effekt-Engine

Kein Sondercode pro Karte. Karten sind **Daten**, Effekte sind **zusammensetzbare
Primitives**:

```
drawTop(n) · drawBottom · peek(n) · reorderTop(n) · shuffle · insertAt(pos)
moveCard(from, to) · stealRandom · stealNamed · skipTurns(n)
forceTurns(target, n) · endTurnNoDraw · cancelAction · protectNextDraw
revealPublic(n) · copyPrevious · wildcard · markCard · returnFromDiscard
```

Eine Karte ist dann eine Liste dieser Primitives. `Akteneinsicht` ist
`[peek(3)]`, `Fristverlängerung` ist `[endTurnNoDraw, forceTurns(next, 2)]`.

Konsequenz: **Ein neuer Kartentyp, der aus bekannten Primitives besteht, kostet
10 Minuten Arbeit statt eines Tages.** Neue Kartentypen werden erst teuer, wenn sie ein
neues Primitive brauchen — und das passiert bei 45 Typen nur etwa 15-mal.

### 12.4 Stufenplan

#### Stufe 1 — Basisspiel (v1.0, 56 Karten, 10 Typen)

| Amt & Ordnung | Vorbild-Funktion |
|---|---|
| Auflagenbescheid | Exploding Kitten |
| Widerspruch | Defuse |
| Formfehler! | Nope |
| Vorgang vertagen | Skip |
| Fristverlängerung | Attack 2x |
| Amtshilfe | Favor |
| Zuständigkeit wechseln | Shuffle |
| Akteneinsicht | See the Future 3x |
| Aus dem Archiv | Draw from the Bottom |
| Dokumente (Bauantrag, Lärmprotokoll, Grundriss, Statiknachweis, Nachbarschaftsbeschwerde) | Cat Cards |

Das ist bewusst **das komplette Basisspiel**, nicht mehr. Ein Spiel, das man in
5 Minuten erklären kann, verkauft sich besser als eines mit 45 Karten.

#### Stufe 2 — Erweiterung „Bürgeramt" (kostenloser Content-Update, ~4 Wochen nach Launch)

10 neue Typen, ~40 Karten. Für Spieler, die das Basisspiel beherrschen.

| Amt & Ordnung | Vorbild-Funktion |
|---|---|
| Nachreichen | Bury |
| Aktenumsortierung | Alter the Future 3x |
| Offene Aktenlage | Reveal the Future (öffentlich) |
| Amtshilfeersuchen | Share the Future |
| Ablage tauschen | Swap Top and Bottom |
| Dienstweg rückwärts | Reverse |
| Dienstaufsichtsbeschwerde | Targeted Attack 2x |
| Prüfungsausschuss | Personal Attack 3x |
| Antrag zurückziehen | Super Skip |
| Verfahrensfehler | Imploding Kitten (nicht entschärfbar) |

#### Stufe 3 — Modul „Dienststelle" (DLC oder großes Update, ~3 Monate nach Launch)

Kein Kartenset, sondern ein **Regelmodul** — das ist der wichtige Unterschied.

| Modul | Inhalt |
|---|---|
| **Vertretung** | Ausgeschiedene Spieler kommen zurück (Vorbild: Zombie Kittens). Braucht neue Spielzustände: `dead`, `revived`. |
| **Aktenblindheit** | Karten verdeckt halten, Markierungen, Kopien, Blankoformulare (Curse, Mark, Clone, Feral) |
| **Der Minister** | Boss-Karten, die nur unter bestimmten Bedingungen spielbar sind (Godcat/Devilcat/Armageddon) |

Module sind der teuerste Teil, weil sie die Zustandsmaschine erweitern, nicht nur das
Deck.

### 12.5 Empfehlung

**v1.0 = Stufe 1.** Nicht, weil mehr nicht geht, sondern weil:
- Onboarding einfacher ist (10 Typen erklärt man in 5 Minuten)
- Du die Interaktionsmatrix für 10 Typen wirklich testen kannst
- Ein Content-Update nach Launch ein **zweiter Marketing-Moment** ist
  (Steam-News, Reviews, "Major Update"-Banner) — kostenlos
- Wenn das Spiel floppt, hast du 4 Monate gespart

**Und ein Vorteil, den das physische Spiel nicht hat:** Du kannst Karten *nachträglich
balancieren*. Wenn `Fristverlängerung` zu stark ist, patcht du sie. Das rechtfertigt
vorsichtiges Starten mit kleinerem Set doppelt.
