---
author: Louis Pilfold
title: Developer Survey 2022 Results
subtitle: What did we learn about the Gleamers?
tags:
  - developer-survey
---

The results are in! Thank you to everyone who took part! 💖

### What's your age?

<ol class="bar-chart">
  {% include chartbar.html amount=2 max=92 label="less than 18 years old" %}
  {% include chartbar.html amount=20 max=92 label="19 to 24 years old" %}
  {% include chartbar.html amount=92 max=92 label="25 to 34 years old" %}
  {% include chartbar.html amount=58 max=92 label="35 to 44 years old" %}
  {% include chartbar.html amount=22 max=92 label="45 to 54 years old" %}
  {% include chartbar.html amount=4 max=92 label="55 to 64 years old" %}
</ol>

### What operating systems do you use in production?

<ol class="bar-chart">
  {% include chartbar.html amount=193 max=193 label="Linux" %}
  {% include chartbar.html amount=10 max=193 label="Windows" %}
  {% include chartbar.html amount=7 max=193 label="macOS" %}
  {% include chartbar.html amount=4 max=193 label="OpenBSD" %}
  {% include chartbar.html amount=2 max=193 label="FreeBSD" %}
  {% include chartbar.html amount=2 max=193 label="Embedded RTOS" %}
  {% include chartbar.html amount=1 max=193 label="iOS" %}
  {% include chartbar.html amount=1 max=193 label="Illumos" %}
  {% include chartbar.html amount=1 max=193 label="Android" %}
</ol>

### What operating systems do you use for development?

<ol class="bar-chart">
  {% include chartbar.html amount=149 max=149 label="Linux" %}
  {% include chartbar.html amount=118 max=149 label="macOS" %}
  {% include chartbar.html amount=45 max=149 label="Windows" %}
  {% include chartbar.html amount=3 max=149 label="OpenBSD" %}
  {% include chartbar.html amount=1 max=149 label="Illumos" %}
  {% include chartbar.html amount=1 max=149 label="FreeBSD" %}
  {% include chartbar.html amount=1 max=149 label="Embedded RTOS" %}
</ol>

### How large is your company?

<ol class="bar-chart">
  {% include chartbar.html amount=39 max=82 label="1 to 10 employees" %}
  {% include chartbar.html amount=47 max=82 label="11 to 50 employees" %}
  {% include chartbar.html amount=21 max=82 label="50 to 100 employees" %}
  {% include chartbar.html amount=82 max=82 label="More than 100 employees" %}
</ol>

### What Gleam compiler targets do you use?

<ol class="bar-chart">
  {% include chartbar.html amount=84 max=84 label="Erlang" %}
  {% include chartbar.html amount=21 max=84 label="JavaScript" %}
</ol>

### Why do you like Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=143 max=143 label="Types" %}
  {% include chartbar.html amount=92 max=143 label="BEAM / OTP" %}
  {% include chartbar.html amount=37 max=143 label="Syntax" %}
  {% include chartbar.html amount=28 max=143 label="Simplicity" %}
  {% include chartbar.html amount=20 max=143 label="Interoperability" %}
  {% include chartbar.html amount=18 max=143 label="Friendly" %}
  {% include chartbar.html amount=15 max=143 label="Tooling" %}
  {% include chartbar.html amount=14 max=143 label="Community" %}
  {% include chartbar.html amount=13 max=143 label="ML influence" %}
  {% include chartbar.html amount=13 max=143 label="Rust influence" %}
  {% include chartbar.html amount=12 max=143 label="Functional programming" %}
  {% include chartbar.html amount=11 max=143 label="JavaScript target" %}
  {% include chartbar.html amount=9 max=143 label="Language design" %}
  {% include chartbar.html amount=8 max=143 label="Louis, Gleam's creator" %}
  {% include chartbar.html amount=7 max=143 label="Elm influence" %}
  {% include chartbar.html amount=6 max=143 label="Elixir influence" %}
  {% include chartbar.html amount=5 max=143 label="Developer experience" %}
  {% include chartbar.html amount=5 max=143 label="Pattern matching" %}
  {% include chartbar.html amount=5 max=143 label="Pragmatism" %}
  {% include chartbar.html amount=4 max=143 label="Immutability" %}
  {% include chartbar.html amount=3 max=143 label="Branding" %}
  {% include chartbar.html amount=3 max=143 label="Documentation" %}
  {% include chartbar.html amount=1 max=143 label="Everything!" %}
  {% include chartbar.html amount=1 max=143 label="It's gay" %}
</ol>


### Are you transgender or cisgender?

<ol class="bar-chart">
  {% include chartbar.html amount=166 max=166 label="Cisgender" %}
  {% include chartbar.html amount=12 max=166 label="Transgender" %}
</ol>

### What's your sexual orientation?

<ol class="bar-chart">
  {% include chartbar.html amount=137 max=137 label="Straight" %}
  {% include chartbar.html amount=29 max=137 label="Not straight" %}
</ol>

### What's your gender?

<ol class="bar-chart">
  {% include chartbar.html amount=170 max=170 label="Male" %}
  {% include chartbar.html amount=9 max=170 label="Non-binary" %}
  {% include chartbar.html amount=6 max=170 label="Female" %}
</ol>

## How much programming experience do you have?

<ol class="bar-chart">
  {% include chartbar.html amount=2 max=130 label="1 to 2 years" %}
  {% include chartbar.html amount=12 max=130 label="2 to 5 years" %}
  {% include chartbar.html amount=63 max=130 label="5 to 10 years" %}
  {% include chartbar.html amount=130 max=130 label="More than 10 years" %}
</ol>

## How much professional programming experience do you have?

<ol class="bar-chart">
  {% include chartbar.html amount=10 max=89 label="N/A" %}
  {% include chartbar.html amount=4 max=89 label="Less than 1 year" %}
  {% include chartbar.html amount=7 max=89 label="1 to 2 years" %}
  {% include chartbar.html amount=36 max=89 label="2 to 5 years" %}
  {% include chartbar.html amount=60 max=89 label="5 to 10 years" %}
  {% include chartbar.html amount=89 max=89 label="More than 10 years" %}
</ol>

## Which programming languages do you use?

<ol class="bar-chart">
  {% include chartbar.html amount=140 max=140 label="JavaScript" %}
  {% include chartbar.html amount=123 max=140 label="Elixir" %}
  {% include chartbar.html amount=120 max=140 label="TypeScript" %}
  {% include chartbar.html amount=93 max=140 label="Rust" %}
  {% include chartbar.html amount=83 max=140 label="Python" %}
  {% include chartbar.html amount=54 max=140 label="Go" %}
  {% include chartbar.html amount=48 max=140 label="Erlang" %}
  {% include chartbar.html amount=47 max=140 label="Ruby" %}
  {% include chartbar.html amount=39 max=140 label="Elm" %}
  {% include chartbar.html amount=37 max=140 label="Java" %}
  {% include chartbar.html amount=36 max=140 label="C" %}
  {% include chartbar.html amount=30 max=140 label="Haskell" %}
  {% include chartbar.html amount=23 max=140 label="Kotlin" %}
  {% include chartbar.html amount=22 max=140 label="Lisp" %}
  {% include chartbar.html amount=20 max=140 label="C++" %}
  {% include chartbar.html amount=17 max=140 label="C#" %}
  {% include chartbar.html amount=17 max=140 label="PHP" %}
  {% include chartbar.html amount=14 max=140 label="OCaml" %}
  {% include chartbar.html amount=12 max=140 label="Scala" %}
  {% include chartbar.html amount=55 max=140 label="Other" %}
</ol>

F# got 8 responses, Julia got 7 responses, Clojure got 4 responses, and Nix got
3 responses. Crystal, Prolog, Zig, Ada, Dart, GDScript, and PureScript got 2
responses, and BQN, CSS, HTML, Jakt, Lean, Mercury, Nushell, Perl,
Racket, Ren, SML, and SQL got 1 response.

### What Gleam merchandise would you be interested in?

<ol class="bar-chart">
  {% include chartbar.html amount=78 max=78 label="T-shirts" %}
  {% include chartbar.html amount=65 max=78 label="Stickers" %}
  {% include chartbar.html amount=52 max=78 label="Hoodies" %}
  {% include chartbar.html amount=38 max=78 label="Mugs" %}
  {% include chartbar.html amount=19 max=78 label="Enamel pins" %}
  {% include chartbar.html amount=16 max=78 label="Earings" %}
  {% include chartbar.html amount=14 max=78 label="Notepads" %}
  {% include chartbar.html amount=7 max=78 label="Leggings" %}
  {% include chartbar.html amount=3 max=78 label="Socks" %}
  {% include chartbar.html amount=1 max=78 label="Butt plugs" %}
  {% include chartbar.html amount=1 max=78 label="Hats" %}
  {% include chartbar.html amount=1 max=78 label="Plushies" %}
  {% include chartbar.html amount=1 max=78 label="Sweat pants" %}
  {% include chartbar.html amount=1 max=78 label="Temporary tattoos" %}
</ol>

### What is your job role?

<ol class="bar-chart">
  {% include chartbar.html amount=77 max=77 label="Software Engineer" %}
  {% include chartbar.html amount=29 max=77 label="Senior Software Engineer" %}
  {% include chartbar.html amount=18 max=77 label="Tech Lead" %}
  {% include chartbar.html amount=10 max=77 label="Principal Engineer" %}
  {% include chartbar.html amount=9 max=77 label="CEO" %}
  {% include chartbar.html amount=9 max=77 label="CTO" %}
  {% include chartbar.html amount=6 max=77 label="Software Architect" %}
  {% include chartbar.html amount=5 max=77 label="Consultant" %}
  {% include chartbar.html amount=5 max=77 label="Start-up founder" %}
  {% include chartbar.html amount=4 max=77 label="Engineering Manager" %}
  {% include chartbar.html amount=4 max=77 label="Staff Engineer" %}
  {% include chartbar.html amount=17 max=77 label="Other" %}
</ol>

Director of Engineering, Head of Engineering, Maker, Infrastructure engineer,
Student each got 2 responses.  Security engineer, Intern, Data engineer,
Lecturer, Teaching Assistant, Security Manager, and Agile Coach each got 1
response.


### Where do you get your Gleam news?

<ol class="bar-chart">
  {% include chartbar.html amount=87 max=87 label="The Gleam Discord Server" %}
  {% include chartbar.html amount=80 max=87 label="@gleamlang on Twitter" %}
  {% include chartbar.html amount=69 max=87 label="@louispilfold on Twitter" %}
  {% include chartbar.html amount=51 max=87 label="reddit.com/r/gleamlang" %}
  {% include chartbar.html amount=41 max=87 label="GitHub" %}
  {% include chartbar.html amount=19 max=87 label="Erlang Forums" %}
  {% include chartbar.html amount=11 max=87 label="lobste.rs" %}
  {% include chartbar.html amount=6 max=87 label="gleam.run" %}
  {% include chartbar.html amount=4 max=87 label="Hacker News" %}
  {% include chartbar.html amount=3 max=87 label="Elixir Forum" %}
  {% include chartbar.html amount=2 max=87 label="reddit.com/r/programming" %}
  {% include chartbar.html amount=2 max=87 label="reddit.com/r/elixir" %}
  {% include chartbar.html amount=1 max=87 label="Fediverse" %}
  {% include chartbar.html amount=1 max=87 label="Elm Slack" %}
</ol>

### Where do you live?

<ol class="bar-chart">
  {% include chartbar.html amount=50 max=50 label="United States of America" %}
  {% include chartbar.html amount=16 max=50 label="Germany" %}
  {% include chartbar.html amount=14 max=50 label="United Kingdom" %}
  {% include chartbar.html amount=11 max=50 label="Australia" %}
  {% include chartbar.html amount=11 max=50 label="Canada" %}
  {% include chartbar.html amount=10 max=50 label="Brazil" %}
  {% include chartbar.html amount=8 max=50 label="Netherlands" %}
  {% include chartbar.html amount=7 max=50 label="Sweden" %}
  {% include chartbar.html amount=7 max=50 label="Poland" %}
  {% include chartbar.html amount=5 max=50 label="Spain" %}
  {% include chartbar.html amount=5 max=50 label="Denmark" %}
  {% include chartbar.html amount=3 max=50 label="China" %}
  {% include chartbar.html amount=3 max=50 label="Italy" %}
  {% include chartbar.html amount=3 max=50 label="Switzerland" %}
  {% include chartbar.html amount=3 max=50 label="Portugal" %}
  {% include chartbar.html amount=3 max=50 label="India" %}
  {% include chartbar.html amount=3 max=50 label="France" %}
  {% include chartbar.html amount=3 max=50 label="New Zealand" %}
  {% include chartbar.html amount=3 max=50 label="Mexico" %}
  {% include chartbar.html amount=29 max=50 label="Other" %}
</ol>

Austria, Nepal, Nepal, Argentina, Argentina, and Czechia each got 2 responses.
Czechia, Romania, Kenya, Republic of North Macedonia, Japan, Russian Federation,
Taiwan, Romania, Norway, Finland, Croatia, and Serbia each got 1 response.

### When did you start using Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=114 max=114 label="Haven't started yet" %}
  {% include chartbar.html amount=22 max=114 label="Less than 1 month" %}
  {% include chartbar.html amount=30 max=114 label="1 to 6 months" %}
  {% include chartbar.html amount=18 max=114 label="6 months to 1 year" %}
  {% include chartbar.html amount=9 max=114 label="1 year to 2 years" %}
  {% include chartbar.html amount=12 max=114 label="More than 2 years" %}
</ol>

### When did you first hear about Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=6 max=128 label="Less than 1 month ago" %}
  {% include chartbar.html amount=27 max=128 label="1 to 6 months ago" %}
  {% include chartbar.html amount=45 max=128 label="6 months to 1 year ago" %}
  {% include chartbar.html amount=128 max=128 label="More than 1 year ago" %}
</ol>
