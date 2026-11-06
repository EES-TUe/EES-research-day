// EES Research Day 2026 — call for presenters.
// Compile: typst compile call-for-presenters.typ
// Colours and type follow the website (assets/css/main.css).

// ---- Details to check before sharing ----
#let deadline = "Friday 4 December 2026"
#let contact-name = "Lingkang Jin"
#let contact-mail = "l.jin@tue.nl"
#let site = "ees-tue.github.io/EES-research-day"

// ---- Website palette ----
#let red = rgb("#c81919")
#let red-strong = rgb("#a31414")
#let ink = rgb("#1b1b1b")
#let muted = rgb("#5d5b58")
#let surface = rgb("#f6f5f3")
#let line-c = rgb("#e2dfdb")
#let badge-bg = rgb("#fbe9e9")
#let badge-ink = rgb("#8f1111")

#let margin-x = 2cm

#set document(title: "EES Research Day 2026 — Call for presenters", author: "EES Research Day organisers")
#set page(paper: "a4", margin: (x: margin-x, top: 0cm, bottom: 1.6cm), footer: context [
  #set text(size: 8pt, fill: muted)
  #line(length: 100%, stroke: 0.5pt + line-c)
  #v(-4pt)
  EES Research Day 2026 #h(1fr) #link("https://" + site)[#site] #h(1fr) Electrical Energy Systems · TU/e
])
#set text(font: "Arial", size: 10.5pt, fill: ink, lang: "en")
#set par(leading: 0.62em, spacing: 0.9em, justify: true)
#show link: set text(fill: red)

#show heading.where(level: 2): it => block(above: 1.3em, below: 0.6em)[
  #box(width: 1.6em, height: 3pt, fill: red, baseline: -0.35em)
  #h(0.45em)
  #text(size: 12.5pt, weight: "bold", it.body)
]

// Three-phase waves, as in the website hero.
#let waves(width: 21cm, height: 1.5cm) = {
  let n = 120
  let phase(shift, alpha) = {
    let pts = range(n + 1).map(i => {
      let x = i / n
      (x * width, height / 2 - height * 0.42 * calc.sin(x * 4 * calc.pi + shift))
    })
    place(curve(
      stroke: 1.2pt + white.transparentize(alpha),
      curve.move(pts.first()),
      ..pts.slice(1).map(p => curve.line(p)),
    ))
  }
  box(width: width, height: height, {
    phase(0deg.rad() * 1.0, 55%)
    phase(2 * calc.pi / 3, 75%)
    phase(4 * calc.pi / 3, 88%)
  })
}

#let fact(big, small) = align(center, circle(
  radius: 1.6cm, fill: surface, stroke: 1.2pt + red, inset: 4pt,
)[
  #set align(center + horizon)
  #set par(justify: false, leading: 0.35em)
  #box(text(size: 17pt, weight: "bold", fill: red, big)) \
  #text(size: 8.5pt, fill: muted, small)
])

// ---- Hero ----
#block(width: 100%, fill: red, outset: (x: margin-x), inset: (top: 1.2cm, bottom: 2cm), below: 0pt)[
  #set text(fill: white)
  #place(bottom + left, dx: -margin-x, dy: 2cm - 0.15cm, waves())
  #grid(
    columns: (auto, auto, 1fr),
    column-gutter: 12pt,
    align: horizon,
    image("assets/tue-logo-white.svg", height: 1.05cm),
    box(width: 0.6pt, height: 1cm, fill: white.transparentize(50%)),
    text(size: 12pt, weight: "bold", tracking: 0.08em, upper[Electrical Energy Systems]),
  )
  #v(0.5cm)
  #text(size: 12pt, weight: "bold", tracking: 0.1em, upper[EES Research Day 2026 · Call for presenters])
  #v(0.1cm)
  #text(size: 30pt, weight: "bold", tracking: -0.01em)[Share your research \ with the group]
  #v(0.15cm)
  #text(size: 11.5pt)[Wednesday 16 December 2026 · Aristo Meeting Center Eindhoven]
]

#v(0.75cm)

// ---- Body ----


== What
  On Wednesday 16 December we are bringing the EES group together for our second Research Day. The afternoon belongs to our researchers: *five colleagues will take the stage and tell the group what they are working on.* We would love for one of them to be you.


#v(0.45cm)
#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 10pt,
  fact[5][talk slots],
  fact[15+3][minutes talk \ and Q&A],
  fact[14:00][afternoon \ session],
)

== Why

Most of us only see a small part of what happens in the group. This session is a chance to change that. We would like the five talks to come from *five different research areas within EES*.

Your work does not need to be finished or polished. A recent paper, early results from a project, a new lab setup or demonstrator, or a question you keep coming back to can all make a great talk. 

PhD candidates, postdocs and staff are equally welcome. You will have 15 minutes to present and 3 minutes for questions. 

== How

#block(width: 100%, fill: badge-bg, radius: 6pt, inset: 14pt, above: 0.8em)[
  Interested? Send an email to *#contact-name* (#link("mailto:" + contact-mail)[#contact-mail]) *by #deadline*, with:

  #set list(marker: text(fill: badge-ink)[•], spacing: 0.55em)
  - your name, position and research area;
  - a short bio of two or three sentences;
  - a short description of your presentation with a working title;
  - three to five keywords.
]

If more people volunteer than we have slots, we will choose the talks so that five different research areas are covered. We look forward to hearing about your work!
