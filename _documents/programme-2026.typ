// EES Research Day 2026 — programme booklet.
// All content comes from _data/editions/2026.yml, so the booklet stays in sync with the website.
// Compile from the repository root (the data and images live outside this folder):
//   typst compile --root . _documents/programme-2026.typ

#let ed = yaml("/_data/editions/2026.yml")

// ---- Website palette, plus Christmas accents ----
#let red = rgb("#c81919")
#let red-dark = rgb("#9b1313")
#let green = rgb("#2f6a3e")
#let gold = rgb("#f2c14e")
#let ink = rgb("#1b1b1b")
#let surface = rgb("#f6f5f3")
#let line-c = rgb("#e2dfdb")

#let page-w = 297mm
#let page-h = 210mm
#let margin-x = 2.2cm

// ---- Helpers ----
#let event-date = {
  let d = str(ed.date).split("-").map(int)
  datetime(year: d.at(0), month: d.at(1), day: d.at(2))
}
#let date-long = event-date.display("[weekday] [day padding:none] [month repr:long] [year]")

// Markdown links → plain text; blank lines → paragraphs; "* " lines → bullet list.
#let plain(s) = str(s).replace(regex("\[([^\]]+)\]\([^)]+\)"), m => m.captures.at(0))
#let md(s) = {
  for para in plain(s).trim().split(regex("\n\s*\n")) {
    let lines = para.split("\n").map(l => l.trim()).filter(l => l != "")
    if lines.len() > 0 and lines.all(l => l.starts-with("* ")) {
      list(..lines.map(l => l.slice(2)))
    } else {
      par(lines.join(" "))
    }
  }
}

// Deterministic pseudo-random numbers in [0, 1) for the snow.
#let rand(n, seed) = {
  let out = ()
  let s = seed
  for _ in range(n) {
    s = calc.rem(s * 1103515245 + 12345, 2147483648)
    out.push(s / 2147483648)
  }
  out
}

#let wave-y(x, height, shift, cycles) = height / 2 - height * 0.42 * calc.sin(x * cycles * 2 * calc.pi + shift)

// Three-phase waves, as in the website hero.
#let waves(width: page-w, height: 2cm, cycles: 2, stroke-w: 1.2pt) = box(width: width, height: height, {
  for (shift, alpha) in ((0, 50%), (2 * calc.pi / 3, 72%), (4 * calc.pi / 3, 86%)) {
    let n = 160
    let pts = range(n + 1).map(i => (i / n * width, wave-y(i / n, height, shift, cycles)))
    place(curve(
      stroke: stroke-w + white.transparentize(alpha),
      curve.move(pts.first()),
      ..pts.slice(1).map(p => curve.line(p)),
    ))
  }
})

// Fairy lights hanging from the first wave.
#let fairy-lights(width: page-w, height: 2cm, cycles: 2, count: 22) = box(width: width, height: height, {
  let colours = (gold, white, rgb("#8fd19e"), rgb("#ffd6d6"))
  for i in range(count) {
    let x = (i + 0.5) / count
    let y = wave-y(x, height, 0, cycles)
    let c = colours.at(calc.rem(i, colours.len()))
    place(dx: x * width - 6pt, dy: y - 1pt, circle(radius: 6pt, fill: c.transparentize(78%)))
    place(dx: x * width - 1.2pt, dy: y, rect(width: 2.4pt, height: 3pt, fill: rgb("#3a0a0a")))
    place(dx: x * width - 3pt, dy: y + 2.6pt, circle(radius: 3pt, fill: c))
  }
})

#let snowflake(size, alpha: 30%) = box(width: size, height: size, {
  let c = white.transparentize(alpha)
  for k in range(6) {
    let a = k * 60deg
    place(dx: size / 2, dy: size / 2, line(length: size / 2, angle: a, stroke: 1pt + c))
    let bx = size / 2 + calc.cos(a) * size * 0.3
    let by = size / 2 + calc.sin(a) * size * 0.3
    place(dx: bx, dy: by, line(length: size * 0.14, angle: a + 45deg, stroke: 0.8pt + c))
    place(dx: bx, dy: by, line(length: size * 0.14, angle: a - 45deg, stroke: 0.8pt + c))
  }
})

#let snow(width, height, count: 80, seed: 7) = {
  let r = rand(count * 4, seed)
  for i in range(count) {
    let x = r.at(i * 4) * width
    let y = r.at(i * 4 + 1) * height
    let rad = 0.6pt + r.at(i * 4 + 2) * 1.6pt
    let alpha = 35% + r.at(i * 4 + 3) * 50%
    place(dx: x, dy: y, circle(radius: rad, fill: white.transparentize(alpha)))
  }
}

// Inner-page header band: website red fading into Christmas green.
#let band(title, seed: 11) = block(
  width: 100%, height: 3.4cm, outset: (x: margin-x), below: 1cm,
  fill: gradient.linear(red, red-dark, green, angle: 20deg), clip: true,
)[
  #place(dx: -margin-x, dy: 0cm, snow(page-w, 3.4cm, count: 30, seed: seed))
  #place(bottom + left, dx: -margin-x, dy: 0.5cm, waves(height: 1.4cm, cycles: 3, stroke-w: 1pt))
  #place(right + horizon, dx: -0.2cm, snowflake(1.5cm, alpha: 55%))
  #place(left + horizon, text(size: 26pt, weight: "bold", fill: white, upper(title)))
]

// Vertical tab on the page edge, as in the 2025 booklet.
#let side-tab(label, side: left, fill: red) = place(
  side + horizon, dx: if side == left { -margin-x } else { margin-x },
  rect(width: 1.3cm, height: 13cm, fill: fill, inset: 0pt)[
    #set align(center + horizon)
    #rotate(-90deg, reflow: true, text(size: 13pt, weight: "bold", fill: white, label))
  ],
)

#let avatar(path, size: 4.2cm) = box(
  width: size, height: size, radius: 50%, clip: true, stroke: 3pt + white,
  image(path, width: size, height: size, fit: "cover"),
)

#let section-label(body, colour: green) = text(size: 12pt, weight: "bold", fill: colour, upper(body))

// ---- Document setup ----
#set document(title: "EES Research Day 2026 — Programme", author: "EES Research Day organisers")
#set text(font: ("Segoe UI", "Arial"), size: 13pt, fill: ink, lang: "en")
#set par(justify: true, leading: 0.6em, spacing: 0.85em)
#set list(marker: text(fill: red)[•])
#show link: set text(fill: red)

// ================= Cover =================
#page(paper: "a4", flipped: true, margin: 0pt, fill: red)[
  #set text(fill: white)
  #place(snow(page-w, page-h, count: 140, seed: 2026))
  #for (x, y, s) in ((24.5cm, 2.2cm, 1.9cm), (27cm, 6.4cm, 1.1cm), (19.5cm, 5.2cm, 0.9cm), (2.2cm, 16.3cm, 1.2cm), (25.6cm, 11.3cm, 1.4cm)) {
    place(dx: x, dy: y, snowflake(s, alpha: 40%))
  }

  // Top-left: TU/e | Electrical Energy Systems
  #place(dx: margin-x, dy: 1.8cm, grid(
    columns: (auto, auto, auto), column-gutter: 12pt, align: horizon,
    image("/_documents/assets/tue-logo-white.svg", height: 1.1cm),
    box(width: 0.6pt, height: 1cm, fill: white.transparentize(50%)),
    text(size: 9.5pt, weight: "bold", tracking: 0.08em, upper[Electrical Energy Systems]),
  ))

  // Title block
  #place(dx: margin-x, dy: 5cm, block(width: 20cm)[
    #text(size: 11pt, weight: "bold", tracking: 0.12em, fill: gold, upper[Second edition · #date-long])
    #v(0.2cm)
    #text(size: 50pt, weight: "bold", tracking: -0.02em)[EES Research Day #text(weight: "light")[#ed.year]]
    #v(-0.5cm)
    #text(size: 26pt, weight: "regular", style: "italic")[& Christmas gathering]
    #v(0.3cm)
    #text(size: 12.5pt)[#ed.venue.name · #ed.venue.address]
  ])

  // Waves with fairy lights across the lower part of the cover
  #place(dx: 0pt, dy: 14.2cm, waves(height: 2.6cm, cycles: 2, stroke-w: 1.4pt))
  #place(dx: 0pt, dy: 14.2cm, fairy-lights(height: 2.6cm, cycles: 2, count: 24))

  // Bottom strip
  #place(bottom + left, dx: margin-x, dy: -1.3cm, text(size: 11pt, tracking: 0.04em)[
    Research talks #h(0.6em)·#h(0.6em) Guest speakers #h(0.6em)·#h(0.6em) EES researcher presentations #h(0.6em)·#h(0.6em) Group activities #h(0.6em)·#h(0.6em) Festive lunch
  ])
]

// ---- Inner pages ----
#set page(
  paper: "a4", flipped: true,
  margin: (x: margin-x, top: 0cm, bottom: 1.5cm),
  footer: context [
    #set text(size: 10.5pt, fill: ink)
    #line(length: 100%, stroke: 0.5pt + line-c)
    #v(-4pt)
    EES Research Day #ed.year · #date-long #h(1fr) #link("https://ees-tue.github.io/EES-research-day/2026/")[ees-tue.github.io/EES-research-day/2026] #h(1fr) #counter(page).display()
  ],
)

// ================= About =================
#band[About]
#grid(
  columns: (1.15fr, 1fr), column-gutter: 1.4cm,
  [
    #text(size: 14pt, weight: "bold")[#ed.welcome]
    #v(0.2cm)
    #md(ed.intro)
    We are glad to host guest speakers from academia and industry, to hear from five of our own researchers in the afternoon, and to close the day together with group activities. We look forward to welcoming you on #event-date.display("[day padding:none] [month repr:long]")!
  ],
  {
    for (i, g) in ed.organisers.enumerate() {
      block(width: 100%, fill: if i == 0 { red } else { green }, inset: (x: 10pt, y: 6pt), above: 0.9em, below: 0.5em,
        align(center, text(size: 12pt, weight: "bold", fill: white, g.role)))
      set par(justify: false)
      grid(
        columns: (1fr, 1fr), column-gutter: 14pt, row-gutter: 11pt,
        ..g.names.map(n => {
          let n = if type(n) == str { (name: n) } else { n }
          [#text(weight: "bold", n.name.trim()) \ #text(size: 11pt, fill: ink, str(n.at("title", default: "")).trim())]
        }),
      )
    }
  },
)

// ================= Venue =================
#pagebreak()
#grid(
  columns: (1fr, 1.15fr), column-gutter: 1.2cm, align: horizon,
  [
    #v(3cm)
    #text(size: 22pt, weight: "bold")[Venue]
    #v(0.2cm)
    The EES Research Day takes place at the *#ed.venue.name*.

    #text(fill: ink)[Address:] #ed.venue.address

    #link(ed.venue.url)[#ed.venue.url.replace("https://", "")]

    #v(0.4cm)
    #block(fill: surface, inset: 12pt, stroke: 0.5pt + line-c)[
      #text(weight: "bold", fill: red)[#ed.start_time–#ed.end_time] #h(0.4em) #date-long
    ]
  ],
  [
    #v(1.6cm)
    #box(clip: true, image(ed.venue.photo, width: 100%, height: 15.5cm, fit: "cover"))
  ],
)

// ================= Programme =================
#pagebreak()
#band(seed: 23)[Programme]
#{
  let colour(s) = {
    let k = s.at("kind", default: "talk")
    if k == "break" { ink } else if k == "talk" { red } else { green }
  }
  table(
    columns: (4.2cm, 1fr), stroke: none, inset: (x: 12pt, y: 13pt),
    fill: (_, y) => if calc.odd(y) { surface } else { white },
    ..ed.programme.map(s => (
      align(right, text(size: 15pt, weight: "bold")[#s.start – #s.end]),
      {
        text(size: 15pt, weight: "bold", fill: colour(s), s.title)
        if s.at("tbc", default: false) [ #text(size: 8pt, fill: red)[(TBC)]]
        if "who" in s or "note" in s {
          h(0.6em)
          text(fill: ink, size: 12pt, (
            s.at("who", default: none),
            s.at("affiliation", default: none),
            s.at("note", default: none),
          ).filter(x => x != none).join(" · "))
        }
      },
    )).flatten(),
  )
}

// ================= Speakers =================
#for (i, sp) in ed.speakers.enumerate() {
  pagebreak()
  let side = if calc.even(i) { left } else { right }
  side-tab(sp.at("role", default: "Speaker"), side: side, fill: if calc.even(i) { red } else { green })
  pad(left: if side == left { 1cm } else { 0cm }, right: if side == right { 1cm } else { 0cm }, top: 1.6cm)[
    #grid(
      columns: (1fr, auto), column-gutter: 1cm,
      [
        #text(size: 20pt, weight: "bold", upper(sp.name)) #h(0.5em)
        #text(size: 11pt, weight: "bold", fill: ink, upper(sp.affiliation))
        #v(0.1cm)
        #text(size: 18pt, weight: "bold", fill: red)[“#sp.title”]
        #if "logo" in sp { v(0.25cm); box(width: 5.5cm, height: 0.8cm, image(sp.logo, width: 100%, height: 100%, fit: "contain")) }
      ],
      if "photo" in sp { avatar(sp.photo) },
    )
    #v(0.5cm)
    #set text(size: 12pt)
    #let has-bio = "bio" in sp
    #grid(
      columns: if has-bio { (1fr, 1fr) } else { (1fr,) }, column-gutter: 1cm,
      [#section-label[Abstract] #v(0.1cm) #md(sp.abstract)],
      ..if has-bio { ([#section-label[Bio] #v(0.1cm) #md(sp.bio)],) },
    )
  ]
}

// ================= EES researcher presentations =================
#pagebreak()
#side-tab([EES presentations], side: left, fill: green)
#pad(left: 1cm, top: 1.6cm)[
  #for ps in ed.pitch_sessions {
    text(size: 20pt, weight: "bold")[#ps.name]
    h(0.6em)
    text(size: 12pt, fill: ink)[#ps.time]
    v(0.1cm)
    text(fill: ink, ps.note)
    v(0.4cm)
    let pitches = ps.at("pitches", default: ())
    let slots = ps.at("slots", default: pitches.len())
    block(stroke: (left: 1pt + green), inset: (left: 14pt))[
      #for p in pitches {
        block(below: 0.7cm, width: 100%)[
          #text(size: 12pt, weight: "bold", fill: green, p.title)
          #line(length: 100%, stroke: 0.8pt + green)
          #v(-0.45em)
          #text(weight: "bold", p.name)
          #if "position" in p [ #text(fill: ink)[· #plain(p.position)]]
          #if "keywords" in p [ \ #text(size: 9pt, fill: ink)[Keywords: #p.keywords.join("; ")]]
        ]
      }
      #for _ in range(calc.max(0, slots - pitches.len())) {
        block(below: 0.7cm, width: 100%)[
          #text(size: 12pt, weight: "bold", fill: green.transparentize(50%))[To be announced]
          #line(length: 100%, stroke: 0.8pt + green.transparentize(50%))
        ]
      }
    ]
  }
]

// ================= Group activities & closing =================
#pagebreak()
#band(seed: 37)[Group activities]
#let social = ed.programme.filter(s => s.at("kind", default: "") == "social")
#grid(
  columns: (1fr, 1fr), column-gutter: 1.4cm,
  [
    #for s in social [
      #text(size: 13pt, weight: "bold", fill: green)[#s.start – #s.end · #s.title]

      #if "note" in s [#s.note \ ]
      #if "who" in s [Organised by #s.who]
    ]
  ],
  block(width: 100%, height: 9cm, clip: true, fill: gradient.linear(red, red-dark, green, angle: 30deg))[
    #place(snow(14cm, 9cm, count: 50, seed: 1216))
    #place(bottom + left, dy: 0.4cm, waves(width: 14cm, height: 1.8cm, cycles: 2))
    #place(bottom + left, dy: 0.4cm, fairy-lights(width: 14cm, height: 1.8cm, cycles: 2, count: 11))
    #place(top + right, dx: -0.6cm, dy: 0.6cm, snowflake(1.6cm, alpha: 35%))
    #pad(1cm)[
      #set text(fill: white)
      #set par(justify: false)
      #text(size: 24pt, weight: "bold")[Season's greetings]
      #v(0.1cm)
      #text(size: 12pt)[Thank you for being part of EES this year. We wish you happy holidays and a bright #(ed.year + 1)!]
    ]
  ],
)
