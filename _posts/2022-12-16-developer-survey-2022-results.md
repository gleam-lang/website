---
author: Louis Pilfold
title: Developer Survey 2022 Results
subtitle: What did we learn about the Gleamers?
tags:
  - developer-survey
---

<style>
  hr {
    margin: var(--gap-6) 0;
  }

  h3 {
    margin-bottom: 0;
  }
</style>

The results are in for the first ever Gleam Developer Survey! Over the
month-and-a-bit the survey was open we had 211 entries! Thank you to everyone
who took part! 💖

The survey was a [Gleam web application][src] with both the frontend and the
backend written in Gleam. It was deployed to [Fly.io](https://fly.io) and wrote
data to the local filesystem rather than using any particular database.

All the questions in the survey were optional, and several of the questions had
a free-text field for people to give their answers. For these free-text answers
I've manually categorised them so that we can see some trends, and the raw data
is not shared in order to protect the privacy of the participants.

Let's take a look at the results now.

## The Gleam folks

These questions are about the participants themselves. Community is one of
the most important aspects of Gleam and it is vital that everyone feels welcome
regardless of who they are, so these questions are intended to give a feel for
the makeup of the community, and if there is anything we can do to improve.

---

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
  {% include chartbar.html amount=29 max=50 label="Other" %}
</ol>

China, France, India, Italy, Mexico, New Zealand, Portugal, and Switzerland each
got 3 responses. Argentina, Austria, Czechia, Nepal, Norway, and Romania each
got 2 responses. Colombia, Croatia, Finland, Greece, Iceland, Iran, Ireland,
Japan, Kenya, Nicaragua, North Macedonia, Russia, Saudi Arabia, Serbia Taiwan,
Turkey, and the United Arab Emirates each got 1 response.

---

### What's your age?

<ol class="bar-chart">
  {% include chartbar.html amount=2 max=92 label="less than 18 years old" %}
  {% include chartbar.html amount=20 max=92 label="19 to 24 years old" %}
  {% include chartbar.html amount=92 max=92 label="25 to 34 years old" %}
  {% include chartbar.html amount=58 max=92 label="35 to 44 years old" %}
  {% include chartbar.html amount=22 max=92 label="45 to 54 years old" %}
  {% include chartbar.html amount=4 max=92 label="55 to 64 years old" %}
</ol>

---

### What's your gender?

<ol class="bar-chart">
  {% include chartbar.html amount=170 max=170 label="Male" %}
  {% include chartbar.html amount=9 max=170 label="Non-binary" %}
  {% include chartbar.html amount=6 max=170 label="Female" %}
</ol>

---

### Are you transgender or cisgender?

<ol class="bar-chart">
  {% include chartbar.html amount=166 max=166 label="Cisgender" %}
  {% include chartbar.html amount=12 max=166 label="Transgender" %}
</ol>

---

### What's your sexual orientation?

<ol class="bar-chart">
  {% include chartbar.html amount=137 max=137 label="Straight" %}
  {% include chartbar.html amount=29 max=137 label="Not straight" %}
</ol>

Overall the Gleam community are a wonderful bunch, and I'm glad we've got an
array of different people from different places participating. It is
disappointing that there are so few responses from women. This certainly is an
area to improve on in future.

---


## Gleamers as programmers

These questions are about programming without being specific to Gleam, so we can
get an understanding of where Gleamers are coming from. If we know what
ecosystems people are familiar with, we can better understand how to help them
get started with Gleam and if there are any integrations we ought to build.

---

### How much programming experience do you have?

<ol class="bar-chart">
  {% include chartbar.html amount=2 max=130 label="1 to 2 years" %}
  {% include chartbar.html amount=12 max=130 label="2 to 5 years" %}
  {% include chartbar.html amount=63 max=130 label="5 to 10 years" %}
  {% include chartbar.html amount=130 max=130 label="More than 10 years" %}
</ol>

---

### How much professional programming experience do you have?

<ol class="bar-chart">
  {% include chartbar.html amount=10 max=89 label="N/A" %}
  {% include chartbar.html amount=4 max=89 label="Less than 1 year" %}
  {% include chartbar.html amount=7 max=89 label="1 to 2 years" %}
  {% include chartbar.html amount=36 max=89 label="2 to 5 years" %}
  {% include chartbar.html amount=60 max=89 label="5 to 10 years" %}
  {% include chartbar.html amount=89 max=89 label="More than 10 years" %}
</ol>

I was really surprised to see such a high level of experience in the Gleam
community! To me this suggests that we may be doing a good job of communicating
how Gleam helps with real-world professional development problems such as
refactoring and keeping codebases maintainable, though we may need to do more to
communicate value to people who are new to programming.

We should probably also not lump everyone with more than 10 years of experience
into one group!

---

### How large is your company?

<ol class="bar-chart">
  {% include chartbar.html amount=39 max=82 label="1 to 10 employees" %}
  {% include chartbar.html amount=47 max=82 label="11 to 50 employees" %}
  {% include chartbar.html amount=21 max=82 label="50 to 100 employees" %}
  {% include chartbar.html amount=82 max=82 label="More than 100 employees" %}
</ol>

---

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

Lots of experience and seniority on show here again!

---

### Which programming languages do you use?

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

No surprise with Elixir making a very strong showing here! Though I was
not expecting to see more Rustaceans and Gophers than Erlangers.

---

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

I think sometimes it can be easy for projects to assume that developers will be
on macOS, so this is a good reminder that all platforms must have an excellent
development experience.

---

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

Good to see a range of operating systems in production too. I'd love to have
have the Gleam test suite also run on OpenBSD and FreeBSD, but unfortunately
GitHub Actions doesn't support these platforms.

---

## Using Gleam

This set of questions is about the participants' experience using Gleam and
participating in the community.

---

### When did you first hear about Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=6 max=128 label="Less than 1 month ago" %}
  {% include chartbar.html amount=27 max=128 label="1 to 6 months ago" %}
  {% include chartbar.html amount=45 max=128 label="6 months to 1 year ago" %}
  {% include chartbar.html amount=128 max=128 label="More than 1 year ago" %}
</ol>

Another question where we probably should have given more options! We
underestimated how long people have been following the project.

---

### When did you start using Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=114 max=114 label="Haven't started yet" %}
  {% include chartbar.html amount=22 max=114 label="Less than 1 month" %}
  {% include chartbar.html amount=30 max=114 label="1 to 6 months" %}
  {% include chartbar.html amount=18 max=114 label="6 months to 1 year" %}
  {% include chartbar.html amount=9 max=114 label="1 year to 2 years" %}
  {% include chartbar.html amount=12 max=114 label="More than 2 years" %}
</ol>

56% of respondents haven't started using Gleam yet. Gleam is a young language so
this is to be expected, hopefully we'll have much more users next year.

---

### What Gleam compiler targets do you use?

<ol class="bar-chart">
  {% include chartbar.html amount=66 max=66 label="Erlang only" %}
  {% include chartbar.html amount=18 max=66 label="Erlang & JavaScript" %}
  {% include chartbar.html amount=3 max=66 label="JavaScript only" %}
</ol>

When the JavaScript target was first created it was seen as a value-add to the
"default" Erlang target, so it is cool to see people using it by itself.

---

### Why do you like Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=143 max=143 label="Types" %}
  {% include chartbar.html amount=92 max=143 label="BEAM / OTP" %}
  {% include chartbar.html amount=37 max=143 label="Syntax" %}
  {% include chartbar.html amount=28 max=143 label="Simplicity" %}
  {% include chartbar.html amount=20 max=143 label="Interoperability" %}
  {% include chartbar.html amount=18 max=143 label="Friendliness" %}
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

Thank you everyone for the kind words! I'm glad you like Gleam.

Predictably the static type system and the Erlang VM are the most popular
characteristics of Gleam, and I'm pleased that all the work we've put into
making Gleam as simple and consistent as possible is resonating with people.

When I started Gleam I had the opinion that syntax largely did not matter much,
and we had an ML language style syntax. After a good amount of feedback I
relented and put a lot of work into making a new syntax that would hopefully
feel approachable to anyone familiar with a mainstream language. Judging by the
results here that work has paid off! The syntax is now one of the most popular
characteristics of Gleam.

<sup>
Also, thank you to the peeps who said I'm one of the things they like about Gleam :)
</sup>

---

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

People have been asking for Gleam merchandise for a while now, so this helps us
understand what sort of things people would be interested in.

I don't know if I can make butt plugs, but I'll try my best.

---


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
  {% include chartbar.html amount=1 max=87 label="The Fediverse" %}
  {% include chartbar.html amount=1 max=87 label="Elm Slack" %}
</ol>

The [Gleam Discord Server](https://discord.gg/Fm8Pwmy) continues to be an
excellent place for Gleamers to hang out ✨

---


And that's all! Once again thank you to everyone who took the time to fill out
the survey, it has been a great help. See you next year!

[src]: https://github.com/gleam-lang/developer-survey/
