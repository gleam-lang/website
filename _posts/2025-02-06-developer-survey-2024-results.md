---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Developer Survey 2024 Results
subtitle: A look at the Gleam community after version one
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

The results are in for the first ever Gleam Developer Survey! It ran for a
couple months at the end of 2024 and received 841 responses! Thank you to
everyone who took part! 💖

The survey was a [Gleam web application][src] with both the frontend and the
backend written in Gleam. It was deployed to a physical Linux server and wrote
data to the local filesystem as JSON files rather than using any particular
database.

All the questions in the survey were optional, and several of the questions had
a free-text field for people to give their answers. For these free-text answers
I've manually categorised them so that we can see some trends, and the raw data
is not shared in order to protect the privacy of the participants.

First we'll go over the numerical data, and after that I'll outline common
trends in the free-text answers.

## What's your job role?

<ol class="bar-chart">
  {% include chartbar.html amount=448 max=448 label="Engineer" %}
  {% include chartbar.html amount=81 max=448 label="Student" %}
  {% include chartbar.html amount=36 max=448 label="CTO" %}
  {% include chartbar.html amount=36 max=448 label="Other non-technical" %}
  {% include chartbar.html amount=31 max=448 label="Tech Lead" %}
  {% include chartbar.html amount=25 max=448 label="Staff Engineer" %}
  {% include chartbar.html amount=23 max=448 label="Principal Engineer" %}
  {% include chartbar.html amount=21 max=448 label="Software Architect" %}
  {% include chartbar.html amount=18 max=448 label="Head of Engineering" %}
  {% include chartbar.html amount=17 max=448 label="Other C-level executive" %}
  {% include chartbar.html amount=8 max=448 label="System administrator" %}
  {% include chartbar.html amount=7 max=448 label="Hardware Engineer" %}
  {% include chartbar.html amount=7 max=448 label="Researcher" %}
  {% include chartbar.html amount=6 max=448 label="Educator" %}
  {% include chartbar.html amount=4 max=448 label="Engineering Manager" %}
  {% include chartbar.html amount=3 max=448 label="Designer" %}
  {% include chartbar.html amount=2 max=448 label="ML Engineer" %}
  {% include chartbar.html amount=2 max=448 label="QA" %}
  {% include chartbar.html amount=1 max=448 label="Data Scientist" %}
</ol>

## What country are you from?

<ol class="bar-chart">
  {% include chartbar.html amount=191 max=191 label="USA" %}
  {% include chartbar.html amount=77 max=191 label="Germany" %}
  {% include chartbar.html amount=56 max=191 label="The United Kingdom" %}
  {% include chartbar.html amount=37 max=191 label="Canada" %}
  {% include chartbar.html amount=36 max=191 label="France" %}
  {% include chartbar.html amount=28 max=191 label="Brazil" %}
  {% include chartbar.html amount=26 max=191 label="Sweden" %}
  {% include chartbar.html amount=23 max=191 label="Spain" %}
  {% include chartbar.html amount=22 max=191 label="Australia" %}
  {% include chartbar.html amount=19 max=191 label="Denmark" %}
  {% include chartbar.html amount=18 max=191 label="India" %}
  {% include chartbar.html amount=15 max=191 label="Japan" %}
  {% include chartbar.html amount=15 max=191 label="The Netherlands" %}
  {% include chartbar.html amount=14 max=191 label="Norway" %}
  {% include chartbar.html amount=14 max=191 label="Poland" %}
  {% include chartbar.html amount=12 max=191 label="The Russian Federation" %}
  {% include chartbar.html amount=11 max=191 label="Belgium" %}
  {% include chartbar.html amount=10 max=191 label="Italy" %}
  {% include chartbar.html amount=10 max=191 label="New Zealand" %}
  {% include chartbar.html amount=9 max=191 label="Mexico" %}
  {% include chartbar.html amount=8 max=191 label="Austria" %}
  {% include chartbar.html amount=8 max=191 label="China" %}
  {% include chartbar.html amount=7 max=191 label="Argentina" %}
  {% include chartbar.html amount=7 max=191 label="Portugal" %}
  {% include chartbar.html amount=7 max=191 label="South Africa" %}
  {% include chartbar.html amount=7 max=191 label="Switzerland" %}
  {% include chartbar.html amount=7 max=191 label="Ukraine" %}
  {% include chartbar.html amount=6 max=191 label="Greece" %}
  {% include chartbar.html amount=6 max=191 label="Indonesia" %}
  {% include chartbar.html amount=5 max=191 label="Czechia" %}
  {% include chartbar.html amount=5 max=191 label="Estonia" %}
  {% include chartbar.html amount=5 max=191 label="Finland" %}
  {% include chartbar.html amount=5 max=191 label="Ireland" %}
  {% include chartbar.html amount=5 max=191 label="The Republic of Korea" %}
  {% include chartbar.html amount=4 max=191 label="Bangladesh" %}
  {% include chartbar.html amount=4 max=191 label="Kenya" %}
  {% include chartbar.html amount=4 max=191 label="Singapore" %}
  {% include chartbar.html amount=55 max=191 label="Other" %}
</ol>

Gleam folks are all around the world! London and Paris have active Gleam
meet-ups, hopefully other top countries such as Germany and USA will start
similar community groups in the near future.

## Are you a Gleam user?

<ol class="bar-chart">
  {% include chartbar.html amount=632 max=632 label="Yes" %}
  {% include chartbar.html amount=173 max=632 label="Not currently" %}
</ol>

The survey was open to everyone with any interest in Gleam, rather than just
experienced users. Around three quarters of respondents are using Gleam, which
is a great indicator of adoption in the language's first year.

## Are you using Gleam in production?

<ol class="bar-chart">
  {% include chartbar.html amount=572 max=572 label="Not yet" %}
  {% include chartbar.html amount=52 max=572 label="Yes" %}
</ol>

Around 8% of people of respondents have got Gleam into production, despite the
language being less than a year old! Encouraging and enabling production use is
one of our primary goals presently, so this result is very satisfying, and I
hope the trend continues.

## Does your organisation sponsor Gleam? (just production users)

<ol class="bar-chart">
  {% include chartbar.html amount=37 max=37 label="No" %}
  {% include chartbar.html amount=1 max=37 label="Yes" %}
</ol>

We have had much less success getting sponsorship from corporate users. This is
disappointing as everyone benefits from dependencies being well maintained and
sufficiently funded. The silver lining is that our lack of success here implies
that there is more money on the table, and if we find some other method that
works better for corporate users then we may be able to substantially increase
project funding.

## How large is your organisation

<ol class="bar-chart">
  {% include chartbar.html amount=124 max=143 label="No organisation" %}
  {% include chartbar.html amount=143 max=143 label="1 to 10" %}
  {% include chartbar.html amount=129 max=143 label="11 to 50" %}
  {% include chartbar.html amount=88 max=143 label="51 to 100" %}
  {% include chartbar.html amount=96 max=143 label="101 to 500" %}
  {% include chartbar.html amount=90 max=143 label="501 to 2000" %}
  {% include chartbar.html amount=108 max=143 label="More than 2001" %}
</ol>

### Just production Gleam users

<ol class="bar-chart">
  {% include chartbar.html amount=10 max=15 label="No organisation" %}
  {% include chartbar.html amount=15 max=15 label="1 to 10" %}
  {% include chartbar.html amount=6 max=15 label="11 to 50" %}
  {% include chartbar.html amount=7 max=15 label="51 to 100" %}
  {% include chartbar.html amount=4 max=15 label="101 to 500" %}
  {% include chartbar.html amount=4 max=15 label="501 to 2000" %}
  {% include chartbar.html amount=3 max=15 label="More than 2001" %}
</ol>

Production users of Gleam are more likely to be in smaller organisations. This
likely is due to larger organisations being more risk-averse than smaller ones,
and Gleam not yet had time to build a reputation as being a strong and reliable
foundation for a technology project.

## Where do you get your Gleam news from?

<ol class="bar-chart">
  {% include chartbar.html amount=238 max=238 label="The Gleam Discord" %}
  {% include chartbar.html amount=197 max=238 label="gleam.run" %}
  {% include chartbar.html amount=193 max=238 label="Gleam Weekly" %}
  {% include chartbar.html amount=147 max=238 label="reddit" %}
  {% include chartbar.html amount=124 max=238 label="Twitter" %}
  {% include chartbar.html amount=82 max=238 label="lobste.rs" %}
  {% include chartbar.html amount=77 max=238 label="GitHub" %}
  {% include chartbar.html amount=74 max=238 label="Bluesky" %}
  {% include chartbar.html amount=58 max=238 label="YouTube" %}
  {% include chartbar.html amount=57 max=238 label="Hacker News" %}
  {% include chartbar.html amount=34 max=238 label="Discord" %}
  {% include chartbar.html amount=24 max=238 label="The Fediverse" %}
  {% include chartbar.html amount=16 max=238 label="Elixir Forum" %}
  {% include chartbar.html amount=6 max=238 label="LinkedIn" %}
  {% include chartbar.html amount=6 max=238 label="daily.dev" %}
  {% include chartbar.html amount=5 max=238 label="Other websites" %}
  {% include chartbar.html amount=5 max=238 label="Word of mouth" %}
  {% include chartbar.html amount=3 max=238 label="Kirakira" %}
  {% include chartbar.html amount=1 max=238 label="Conferences" %}
  {% include chartbar.html amount=1 max=238 label="Podcasts" %}
  {% include chartbar.html amount=1 max=238 label="Twitch" %}
</ol>

[The Gleam Discord server](https://discord.gg/Fm8Pwmy) continues to be the
place-to-be in the Gleam community. [Gleam Weekly](https://gleamweekly.com/) and
[reddit](https://www.reddit.com/r/gleamlang/) have grown a lot since v1.0.0,
providing two good options for folks who do not have the desire or the time to
participate in a busy chat server.

## How much professional programming experience do you have?

<ol class="bar-chart">
  {% include chartbar.html amount=253 max=253 label="0 to 4 years" %}
  {% include chartbar.html amount=242 max=253 label="5 to 9 years" %}
  {% include chartbar.html amount=136 max=253 label="10 to 14 years" %}
  {% include chartbar.html amount=75 max=253 label="15 to 19 years" %}
  {% include chartbar.html amount=74 max=253 label="20 to 24 years" %}
  {% include chartbar.html amount=26 max=253 label="25 to 29 years" %}
  {% include chartbar.html amount=13 max=253 label="30 to 34 years" %}
  {% include chartbar.html amount=6 max=253 label="35 to 39 years" %}
  {% include chartbar.html amount=2 max=253 label="40 to 44 years" %}
  {% include chartbar.html amount=2 max=253 label="45 to 50 years" %}
</ol>

## How much Gleam experience do you have?

<ol class="bar-chart">
  {% include chartbar.html amount=290 max=293 label="Less than 1 year" %}
  {% include chartbar.html amount=293 max=293 label="1 year" %}
  {% include chartbar.html amount=32 max=293 label="2 years" %}
  {% include chartbar.html amount=10 max=293 label="3 years" %}
  {% include chartbar.html amount=6 max=293 label="4 years" %}
  {% include chartbar.html amount=1 max=293 label="5 years" %}
  {% include chartbar.html amount=3 max=293 label="6 years" %}
</ol>

Some folks have been using Gleam since way before v1.0.0! Thank you for staying
with Gleam for so long! I think I can guess who these people are. 😁

## What Gleam compilation targets do you use?

<ol class="bar-chart">
  {% include chartbar.html amount=571 max=571 label="Erlang" %}
  {% include chartbar.html amount=297 max=571 label="JavaScript" %}
  {% include chartbar.html amount=29 max=571 label="Unsure" %}
</ol>

Sometimes people think that Gleam's JavaScript target is an afterthought or
somehow less important, but it is used a lot. It is also interesting to see how
some folks don't know what target they are using. I think this shows how the
Gleam tooling does a good job of letting you get started without having to learn
lots about the surrounding ecosystem, but perhaps we could do better at
education in some fashion here.

### Just production Gleam users

<ol class="bar-chart">
  {% include chartbar.html amount=48 max=48 label="Erlang" %}
  {% include chartbar.html amount=35 max=48 label="JavaScript" %}
</ol>

Among production uses Gleam's JavaScript target is even more widely used, likely
for web frontends. Note that these are not distinct groups, many respondents
will have picked both.

## What runtimes do you use to run your Gleam code?

<ol class="bar-chart">
  {% include chartbar.html amount=545 max=545 label="BEAM" %}
  {% include chartbar.html amount=228 max=545 label="Web browsers" %}
  {% include chartbar.html amount=134 max=545 label="NodeJS" %}
  {% include chartbar.html amount=69 max=545 label="Deno" %}
  {% include chartbar.html amount=47 max=545 label="Bun" %}
  {% include chartbar.html amount=31 max=545 label="Unsure" %}
  {% include chartbar.html amount=7 max=545 label="AtomVM" %}
</ol>

Predictably the Erlang VM (the BEAM) is the most widely used runtime, but we've
also got a few folks using AtomVM, an alternative Erlang runtime optimised for
resource constrained environments. It would be good to have better support for
this runtime in the Gleam toolchain.

### Just production Gleam users

<ol class="bar-chart">
  {% include chartbar.html amount=48 max=48 label="BEAM" %}
  {% include chartbar.html amount=32 max=48 label="Web browsers" %}
  {% include chartbar.html amount=14 max=48 label="NodeJS" %}
  {% include chartbar.html amount=8 max=48 label="Deno" %}
  {% include chartbar.html amount=3 max=48 label="Bun" %}
</ol>

## What operating system do you use in development?

<ol class="bar-chart">
  {% include chartbar.html amount=559 max=559 label="Linux" %}
  {% include chartbar.html amount=458 max=559 label="macOS" %}
  {% include chartbar.html amount=213 max=559 label="Windows" %}
  {% include chartbar.html amount=43 max=559 label="Android" %}
  {% include chartbar.html amount=42 max=559 label="iOS" %}
  {% include chartbar.html amount=17 max=559 label="FreeBSD" %}
  {% include chartbar.html amount=9 max=559 label="OpenBSD" %}
  {% include chartbar.html amount=1 max=559 label="ChromeOS" %}
  {% include chartbar.html amount=1 max=559 label="Embedded" %}
  {% include chartbar.html amount=1 max=559 label="Illumos" %}
</ol>

A strong showing from the usual suspects, and good to see some more uncommon
operating systems in there too. Windows being so common is a good reminder of
the importance of having good Windows support. It's vital that we don't leave
that huge portion of potential users behind and limit Gleam's growth.

## What operating system do you use in production?

<ol class="bar-chart">
  {% include chartbar.html amount=731 max=731 label="Linux" %}
  {% include chartbar.html amount=134 max=731 label="Windows" %}
  {% include chartbar.html amount=68 max=731 label="macOS" %}
  {% include chartbar.html amount=57 max=731 label="Android" %}
  {% include chartbar.html amount=49 max=731 label="iOS" %}
  {% include chartbar.html amount=21 max=731 label="FreeBSD" %}
  {% include chartbar.html amount=10 max=731 label="OpenBSD" %}
  {% include chartbar.html amount=1 max=731 label="ChromeOS" %}
  {% include chartbar.html amount=1 max=731 label="Illumos" %}
  {% include chartbar.html amount=1 max=731 label="QNX" %}
</ol>

The BSDs showing quite strongly here too! It would be great for the Gleam
project to be able to run the tests on and provide binaries for FreeBSD and
OpenBSD, but unfortunately our CI system, GitHub Actions, does not support them.

Some people put platforms such as "AWS Lambda" or "Kubernetes" as their
operating system here. I've largely put these within the "Linux" category.

## What sort of projects do you make with Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=574 max=574 label="Applications" %}
  {% include chartbar.html amount=200 max=574 label="Libraries" %}
</ol>

It's wonderful to see so many people making applications! People tend to share
or publicise libraries more than applications, so we don't get to see as many of
them as we would like. This year we hope to devise some ways to encourage people
to share applications, there's a lot we can learn from studying them.

## Do you use Gleam for open source development?

<ol class="bar-chart">
  {% include chartbar.html amount=311 max=311 label="No" %}
  {% include chartbar.html amount=309 max=311 label="Yes" %}
</ol>

It's great to see so many people using Gleam for open-source. Gleam is a
community project, so we greatly benefit from people making and sharing via open
source.

## Do you sponsor Gleam?

<ol class="bar-chart">
  {% include chartbar.html amount=655 max=655 label="false" %}
  {% include chartbar.html amount=146 max=655 label="true" %}
</ol>

### Just production Gleam users

<ol class="bar-chart">
  {% include chartbar.html amount=39 max=39 label="false" %}
  {% include chartbar.html amount=11 max=39 label="true" %}
</ol>

It's great to see so many people sponsoring Gleam! All the funding for the
project comes from [sponsorship](https://github.com/sponsors/lpil) rather than a
corporate owner. This gives us more freedom to make Gleam the best language
possible, and removes the risk of the project falling victim to changes in
business priorities, but means we have less funding overall. Having a good
amount of sponsorship is vital and we hope to continue to grow it so all the
core team can be paid appropriately.

## What other languages do you use?

<ol class="bar-chart">
  {% include chartbar.html amount=384 max=384 label="TypeScript" %}
  {% include chartbar.html amount=338 max=384 label="JavaScript" %}
  {% include chartbar.html amount=314 max=384 label="Python" %}
  {% include chartbar.html amount=243 max=384 label="Rust" %}
  {% include chartbar.html amount=230 max=384 label="Go" %}
  {% include chartbar.html amount=158 max=384 label="Elixir" %}
  {% include chartbar.html amount=129 max=384 label="Java" %}
  {% include chartbar.html amount=100 max=384 label="C#" %}
  {% include chartbar.html amount=81 max=384 label="PHP" %}
  {% include chartbar.html amount=80 max=384 label="Bash" %}
  {% include chartbar.html amount=77 max=384 label="Ruby" %}
  {% include chartbar.html amount=58 max=384 label="C" %}
  {% include chartbar.html amount=53 max=384 label="Kotlin" %}
  {% include chartbar.html amount=49 max=384 label="Elm" %}
  {% include chartbar.html amount=41 max=384 label="C++" %}
  {% include chartbar.html amount=40 max=384 label="Haskell" %}
  {% include chartbar.html amount=40 max=384 label="Lua" %}
  {% include chartbar.html amount=34 max=384 label="OCaml" %}
  {% include chartbar.html amount=34 max=384 label="Zig" %}
  {% include chartbar.html amount=32 max=384 label="Erlang" %}
  {% include chartbar.html amount=29 max=384 label="POSIX Shell" %}
  {% include chartbar.html amount=27 max=384 label="Swift" %}
  {% include chartbar.html amount=26 max=384 label="Dart" %}
  {% include chartbar.html amount=23 max=384 label="Scala" %}
  {% include chartbar.html amount=22 max=384 label="F#" %}
  {% include chartbar.html amount=21 max=384 label="Clojure" %}
  {% include chartbar.html amount=20 max=384 label="SQL" %}
  {% include chartbar.html amount=12 max=384 label="ReScript" %}
  {% include chartbar.html amount=10 max=384 label="R" %}
  {% include chartbar.html amount=9 max=384 label="Crystal" %}
  {% include chartbar.html amount=9 max=384 label="GDScript" %}
  {% include chartbar.html amount=9 max=384 label="Julia" %}
  {% include chartbar.html amount=8 max=384 label="Nix" %}
  {% include chartbar.html amount=8 max=384 label="Racket" %}
  {% include chartbar.html amount=6 max=384 label="Lisp" %}
  {% include chartbar.html amount=6 max=384 label="Odin" %}
  {% include chartbar.html amount=6 max=384 label="Prolog" %}
  {% include chartbar.html amount=5 max=384 label="Nim" %}
  {% include chartbar.html amount=5 max=384 label="PowerShell" %}
  {% include chartbar.html amount=5 max=384 label="PureScript" %}
  {% include chartbar.html amount=4 max=384 label="Assembly" %}
  {% include chartbar.html amount=4 max=384 label="Nushell" %}
  {% include chartbar.html amount=3 max=384 label="AWK" %}
  {% include chartbar.html amount=3 max=384 label="Groovy" %}
  {% include chartbar.html amount=3 max=384 label="Idris" %}
  {% include chartbar.html amount=3 max=384 label="Lean" %}
  {% include chartbar.html amount=3 max=384 label="MATLAB" %}
  {% include chartbar.html amount=3 max=384 label="Perl" %}
  {% include chartbar.html amount=3 max=384 label="Tcl" %}
  {% include chartbar.html amount=2 max=384 label="Common Lisp" %}
  {% include chartbar.html amount=2 max=384 label="Fennel" %}
  {% include chartbar.html amount=2 max=384 label="Mercury" %}
  {% include chartbar.html amount=2 max=384 label="Mumps" %}
  {% include chartbar.html amount=2 max=384 label="Pony" %}
  {% include chartbar.html amount=2 max=384 label="Unison" %}
  {% include chartbar.html amount=2 max=384 label="V" %}
  {% include chartbar.html amount=1 max=384 label="ABAP" %}
  {% include chartbar.html amount=1 max=384 label="Agda" %}
  {% include chartbar.html amount=1 max=384 label="AssemblyScript" %}
  {% include chartbar.html amount=1 max=384 label="BASIC" %}
  {% include chartbar.html amount=1 max=384 label="BQN" %}
  {% include chartbar.html amount=1 max=384 label="CUDA" %}
  {% include chartbar.html amount=1 max=384 label="Coq" %}
  {% include chartbar.html amount=1 max=384 label="D" %}
  {% include chartbar.html amount=1 max=384 label="Delphi" %}
  {% include chartbar.html amount=1 max=384 label="EYG" %}
  {% include chartbar.html amount=1 max=384 label="Fish" %}
  {% include chartbar.html amount=1 max=384 label="Flix" %}
  {% include chartbar.html amount=1 max=384 label="Janet" %}
  {% include chartbar.html amount=1 max=384 label="Javascript" %}
  {% include chartbar.html amount=1 max=384 label="Mint" %}
  {% include chartbar.html amount=1 max=384 label="Objective-C" %}
  {% include chartbar.html amount=1 max=384 label="PSL" %}
  {% include chartbar.html amount=1 max=384 label="Roc" %}
  {% include chartbar.html amount=1 max=384 label="SAS" %}
  {% include chartbar.html amount=1 max=384 label="Scheme" %}
  {% include chartbar.html amount=1 max=384 label="StandardML" %}
  {% include chartbar.html amount=1 max=384 label="SystemVerilog" %}
  {% include chartbar.html amount=1 max=384 label="Terraform" %}
  {% include chartbar.html amount=1 max=384 label="Typst" %}
  {% include chartbar.html amount=1 max=384 label="Visual Basic" %}
</ol>

Wow, what a lot of different languages! A common misconception is that Gleam in
some way competes with Erlang and Elixir, and draws programmers from those
communities. This is not the case! People who enjoy the dynamic and expressive
styles of those languages tend not to gel quite as well as the much stricter and
type-directed style of Gleam.

<ol class="bar-chart">
  {% include chartbar.html amount=2639 max=2639 label="Other" %}
  {% include chartbar.html amount=190 max=2639 label="Erlang and Elixir" %}
</ol>

With the answers broken down into Erlang and Elixir vs others this can be seen
more easily. Gleam folk overwhelmingly come from other ecosystems, often
ones that already use static types.

## Free text responses

It took a long time to read all the various messages submitted to the survey.
Overwhelmingly everyone was very supportive, and we didn't have any trolls or
similar. Here's some of the common themes in the messages:

### Easier JSON decoding

Gleam is a sound statically typed language, so when data comes in from the
outside work it needs to be converted into well typed data before it can be
used. This is done using _dynamic decoders_.
The original API for these could be challenging to work with at times, and the
survey responses highlighted it as a sore spot in the Gleam developer
experience.

Since the survey we have completely redesigned this API, making it much easier
to use and also removing some of the limitations people would get stuck on. The
language server has also gained a code action to generate decoders for you from
type definitions.

### OTP actor framework improvements

Gleam is part of the BEAM language, so it makes use of the OTP actor application
framework. One can use the regular Erlang implementation, but there is also a
library called `gleam_otp` which provides a type safe version of the same
concepts and protocols, while maintaining compatibility.

`gleam_otp` is somewhat minimal and respondents wanted it to be expanded, which
we intend to do over the next year.

### Language server renaming

Gleam's language server provides IDE-like features to all text editors that
support the language server protocol, which is most mainstream editors.
At the time of the survey it lacked support for the "rename" feature, so Gleam
programmers would have to rename things manually.

We agree this is a missing piece and is highly sought after. Renaming of
arguments and local variables has been added recently, and we intend to continue
to add more renaming functionality.

### Macros and metaprogramming

Several respondents expressed a desire for macros or metaprogramming, though
rarely did it include any details of what that might mean or any justification
as to why it should be added. Metaprogramming is a lot of fun in many languages,
so it is understandable that people would want their favourite type of
metaprogramming in Gleam, but we need a more detailed proposal before we can
move forward with any language editions, especially one so large in scope. [This
blog post](https://lpil.uk/blog/how-to-add-metaprogramming-to-gleam/) details
what this proposal process needs to look like.

### Documentation

People like the current documentation but they want more! I agree, this is very
important. Help with making applications and getting them into production was
especially highlighted. Documentation and production is one of my main
priorities for 2025.

Video content was especially in-demand. I intend to experiment with some video
guides for key areas of the Gleam ecosystem.

### Compilation to a single binary

This would be a cool feature to have, but we don't have any particular plans
to do this at present. Perhaps one day!

### Easier installation of Erlang and rebar3

Installing Gleam is easy, but installing Erlang and rebar3 (Erlang's build tool)
can be difficult, especially as they are not distributed together (making
version mismatches possible) and Debian and Fedora both currently have Erlang
packages which are incomplete and can fail to compile simple Erlang programs.

This is a wider problem in the BEAM ecosystem and we are collectively working on
making it easier to install these dependencies.

### Libraries

Some people want websocket support in the [Wisp web framework](https://github.com/gleam-wisp/wisp)
and stabilisation of the core libraries, both of which are planned for this
year.

The lack of a core time library was highlighted as making it unclear how best to
work with time. This week the official `gleam_time` library has been published
to resolve this issue.

Some people want a much larger standard library. This is not something we intend
to do as we believe a "batteries included" standard library is a relic of times
before effective package management, and today it is more practical to have a
selection of well maintained packages that all work together but can be upgraded
or replaced independently than to have one monolithic library where the majority
of the code is unused or discouraged.

A convention based backend web framework in the style of Rails, Django, or
Phoenix was a not-uncommon request. This is not something the core team has
any plans to work on, but perhaps the community will produce such a project!

## The end

And that's all! Once again thank you to everyone who took the time to fill out
the survey, it has been a great help. See you next year!

[src]: https://github.com/gleam-lang/developer-survey/
