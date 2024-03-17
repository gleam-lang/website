---
author: Louis Pilfold
title: Gleam version 1
subtitle: It's finally here! 🎉
tags:
  - Release
---

Today Gleam v1.0.0 has been released! This is the first "stable" release of the
language (more on what that means later) and a big milestone for the ecosystem.

It has been a long journey and I'm proud of both the technology and the
community that we've built here with Gleam. Thank you so much to everyone who
has taken part in any way, you've all contributed to the project getting here in
meaningful ways of all sizes.


## What's Gleam?

Gleam is a programming language that tries to make your job as a writer and
maintainer of software systems as predictable, stress-free, and enjoyable as
possible.

The language is consistent and has a small surface area, making it possible to
[learn in an afternoon][tour]. Coupled with a lack of magic and a strong desire
to have only one way of doing things, Gleam is typically easy to read and
understand. Reading and debugging code is more difficult than writing new code,
so we optimise for this.

[tour]: https://tour.gleam.run/

Gleam has robust static analysis and a type system inspired by languages such as
Elm, OCaml, and Rust, so the compiler serves as a programming assistant, giving
you additional context to help you make the change you want to make. Don't worry
about writing perfect code the first time round, with Gleam refactoring is low
risk and low stress so you can continue to improve your code as you learn more
about the problem at hand.

Running and administrating software is as important as writing it. Gleam
runs on the Erlang virtual machine, a mature and battle-tested platform that
powers many of the world's most reliable and scalable systems, such as WhatsApp.
Gleam can also run on JavaScript runtimes, making it possible to run Gleam code
in the browser, on mobile devices, or anywhere else.

Gleam looks like this:
```gleam
import gleam/json
import gleam/result.{try}
import my_app/person
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  let result = {
    use data <- try(person.decode(json))
    use row <- try(person.insert(ctx.db, data))
    Ok(person.to_json(row))
  }

  case result {
    Ok(json) -> wisp.json_response(json, 201)
    Error(_) -> wisp.unprocessable_entity()
  }
}
```


## What does Gleam v1 include?

This version covers all the public APIs found in [the main Gleam git
repository][repo], that is:

- The Gleam language design.
- The Gleam compiler.
- The Gleam build tool.
- The Gleam package manager.
- The Gleam code formatter.
- The Gleam language server.
- The Gleam compiler WASM API and JavaScript bindings.

[repo]: https://github.com/gleam-lang/gleam

The Gleam standard library and other packages maintained by the core team will
be getting an accompanying v1 release shortly afterwards. Before these are
released we will be making pull requests to popular community packages to relax
their package manager version constraints to ensure that the update to v1 is as
smooth as possible for all Gleam users.


## What does v1 mean?

Version 1 is a statement about Gleam's stability and readiness to be used in
production systems. We believe Gleam is suitable for use in projects that
matter, and Gleam will provide a stable and predictable foundation.

Gleam follows [semantic versioning][semver], so maintaining backwards
compatibility is now a priority. We will be making every effort to ensure that
Gleam does not introduce breaking changes. The exception to this is for security
and soundness issues. Should a critical bug of this nature be discovered we
reserve the right to fix the security issue, even if some programs were taking
advantage of the bug.

[semver]: https://semver.org/


## What's next for Gleam?

Gleam is a practical language intended for making real things, so our focus for
Gleam post-v1 is to be split between productivity for Gleam users and
sustainability for the Gleam project.


### Productivity for Gleam users

As well as not introducing breaking changes we will also be avoiding language
bloat. It's easy to keep adding new features to a language to aid with specific
problems, but with each new language feature or new way of solving a problem the
language as a whole becomes more complex and harder to understand.
Simplicity is a feature in Gleam and that will not change going forward.
There is scope adding new features to the language, but we will be doing so
extremely conservatively. Any new feature has to be generally useful and enable
new things not otherwise possible in Gleam, while being a worthwhile trade
for the added complexity it brings to the language.

Rather than adding new features to the language we will be continuously
improving the Gleam developer experience and enhancing real-world productivity.
Initially the focus will be on improving the Gleam language server as it is
immature compared to the rest of the Gleam tooling. We will also be working on
all the libraries and such that folks will likely want when making production
systems in Gleam, with an initial focus on development of websites and web
services.

Documentation is also a priority. We want to have tutorials and guides for all
manner of tasks in Gleam. It should always be easy to find how to do something
in Gleam, so you can focus on achieving your goal.


### Sustainability for the Gleam project

Gleam is not a project from Microsoft or Google, it's a community project. There
is one full-time developer working on Gleam (me!) and a number of part time
volunteers who do excellent work. With this small team we need to be efficient
with our efforts. Anything we work on needs to be impactful and meaningful to
the whole Gleam community, we cannot afford to spend time on niche or
unimportant situations.

Internal documentation is also important. As an open source project we want
folks to be able to open up the codebase and make their contribution as easily
as possible. So far the feedback has been that the Gleam compiler and build tool
are easy to contribute to. This is encouraging, and we will continue to work on
this to ensure that the Gleam project never gets to a point where only a select
few people are able to meaningfully contribute to its maintenance.

The last part of sustainability is financial.

I am able to afford to work on Gleam full time thanks to the support of the
project's sponsors on [GitHub Sponsors][sponsors]. The largest contributor is
[Fly.io](https://fly.io), who provide approximately half the funding. Thank you
Fly.io! We wouldn't be here today without your support!

[sponsors]: https://github.com/sponsors/lpil

Going forward I would like to diversify the funding with more corporate
sponsors, as well as other revenue streams. I earn less than half of what I
would make with the median lead developer salary in London, the city in which I
live. This is enough money for me to get by, but I would very much like to earn
around what I would if I had some other job.

Long term I would like to be able to financially reward the regular contributors
to Gleam. The folks in the core team are wonderfully talented and they should be
rewarded appropriately for their work.


<img
  class="no-shadow"
  src="/images/lucy/lucy.svg"
  alt="Lucy, Gleam's cute pink starfish mascot"
  style="float: left; max-width: 260px; margin: 0 var(--gap-2) var(--gap-2) 0">

## Hello, Lucy!

Gleam's mascot, Lucy, has had little bit of a glow-up! 💖


Lucy's a kind and friendly little starfish who enjoys strawberry ice cream and
functional programming. The rest of Lucy's story is up to the community to tell.
Thank you to [suppyluppy](https://github.com/suppyluppy) for this wonderful
redesign and for starting Lucy's canon.

To go with Lucy's new look we've also snazzied up the website up a little and
adjusted the colours for legibility. We hope you like it!

Right, that's everything! Thank you to all the fantastic people who have made
this v1.0.0 release possible through sponsorship or code contributions:

<ul class="top-sponsors">
  <li>
    <a href="https://fly.io" rel="noopener" target="_blank">
      <img class="sponsor-fly no-shadow" src="/images/sponsors/fly.svg" alt="Fly">
    </a>
  </li>
</ul>

 - [Aaron Gunderson](https://github.com/agundy)
 - [Adam Brodzinski](https://github.com/AdamBrodzinski)
 - [Adam Mokan](https://github.com/amokan)
 - [Adi Iyengar](https://github.com/thebugcatcher)
 - [Alembic](https://alembic.com.au)
 - [Alex Manning](https://github.com/rawhat)
 - [Alexander Koutmos](https://github.com/akoutmos)
 - [Alexander Stensrud](https://github.com/spektroskop)
 - [Alexandre Del Vecchio](https://github.com/defgenx)
 - [Andrea Tupini](https://github.com/tupini07)
 - [Andy Aylward](https://github.com/aaylward)
 - [Anthony Khong](https://github.com/anthony-khong)
 - [Anthony Scotti](https://github.com/amscotti)
 - [Arnaud Berthomier](https://github.com/oz)
 - [Ayodeji O](https://github.com/aosasona)
 - [Barry Moore](https://github.com/chiroptical)
 - [Ben Marx](https://github.com/bgmarx)
 - [Ben Myles](https://github.com/benmyles)
 - [Benjamin Peinhardt](https://github.com/bcpeinhardt)
 - [Benjamin Thomas](https://github.com/bentomas)
 - [brettkolodny](https://github.com/brettkolodny)
 - [Brian Glusman](https://github.com/bglusman)
 - [Brian Kung](https://github.com/briankung)
 - [Bruno Michel](https://github.com/nono)
 - [Carlos Saltos](https://github.com/csaltos)
 - [Chew Choon Keat](https://github.com/choonkeat)
 - [Chris Lloyd](https://github.com/chrislloyd)
 - [Chris Ohk](https://github.com/utilForever)
 - [Chris Rybicki](https://github.com/Chriscbr)
 - [Christopher Dieringer](https://github.com/cdaringe)
 - [Christopher Keele](https://github.com/christhekeele)
 - [clangley](https://github.com/clangley)
 - [Clay](https://github.com/connorlay)
 - [Coder](https://github.com/coder)
 - [Cole Lawrence](https://github.com/colelawrence)
 - [Colin](https://github.com/insanitybit)
 - [Cristine Guadelupe](https://github.com/cristineguadelupe)
 - [Damir Vandic](https://github.com/dvic)
 - [Dan Dresselhaus](https://github.com/ddresselhaus)
 - [Daniel Sherlock](https://github.com/DanielSherlock)
 - [Danielle Maywood](https://github.com/DanielleMaywood)
 - [Danny Martini](https://github.com/despairblue)
 - [Dave Lucia](https://github.com/davydog187)
 - [David Bernheisel](https://github.com/dbernheisel)
 - [David Flanagan](https://github.com/rawkode)
 - [David Sancho](https://github.com/davesnx)
 - [Dennis Dang](https://github.com/dangdennis)
 - [Devon Sawatsky](https://github.com/novedevo)
 - [Dillon Mulroy](https://github.com/dmmulroy)
 - [Dmitry Poroh](https://github.com/poroh)
 - [Douglas M](https://github.com/Massolari)
 - [Edon Gashi](https://github.com/edongashi)
 - [Elliott Pogue](https://github.com/epogue)
 - [Emma](https://github.com/Emma-Fuller)
 - [Erik Terpstra](https://github.com/eterps)
 - [Ernesto Malave](https://github.com/oberernst)
 - [F. Schwalbe](https://github.com/fschwalbe)
 - [Fernando Farias](https://github.com/nandofarias)
 - [Filip Figiel](https://github.com/ffigiel)
 - [Florian Kraft](https://github.com/floriank)
 - [fly.io](https://github.com/superfly)
 - [Frédéric Boyer](https://github.com/fredericboyer)
 - [ggobbe](https://github.com/ggobbe)
 - [Giacomo Cavalieri](https://github.com/giacomocavalieri)
 - [Graeme Coupar](https://github.com/obmarg)
 - [Guilherme de Maio](https://github.com/nirev)
 - [Gustavo Villa](https://github.com/gfvcastro)
 - [Hayleigh Thompson](https://github.com/hayleigh-dot-dev)
 - [Hazel Bachrach](https://github.com/hibachrach)
 - [Henry Warren](https://github.com/henrysdev)
 - [Hex](https://github.com/hexpm)
 - [human154](https://github.com/human154)
 - [Ian González](https://github.com/Ian-GL)
 - [Igor Rumiha](https://github.com/irumiha)
 - [inoas](https://github.com/inoas)
 - [Ivar Vong](https://github.com/ivarvong)
 - [James Birtles](https://github.com/jamesbirtles)
 - [James MacAulay](https://github.com/jamesmacaulay)
 - [Jan Skriver Sørensen](https://github.com/monzool)
 - [Jen Stehlik](https://github.com/okkdev)
 - [jiangplus](https://github.com/jiangplus)
 - [Joey Kilpatrick](https://github.com/joeykilpatrick)
 - [John Björk](https://github.com/JohnBjrk)
 - [Jonas Hedman Engström](https://github.com/JonasHedEng)
 - [Josef Richter](https://github.com/josefrichter)
 - [Joseph T. Lyons](https://github.com/JosephTLyons)
 - [Julian Schurhammer](https://github.com/schurhammer)
 - [Kieran Gill](https://github.com/kierangilliam)
 - [kodumbeats](https://github.com/kodumbeats)
 - [Kryštof Řezáč](https://github.com/krystofrezac)
 - [Lars Wikman](https://github.com/lawik)
 - [Leon Qadirie](https://github.com/leonqadirie)
 - [LighghtEeloo](https://github.com/LighghtEeloo)
 - [Linda Vitali](https://github.com/vitlinda)
 - [Manuel Rubio](https://github.com/manuel-rubio)
 - [Marcøs](https://github.com/ideaMarcos)
 - [Mario Flach](https://github.com/redrabbit)
 - [Marius Kalvø](https://github.com/mariuskalvo)
 - [Mark Holmes](https://github.com/markholmes)
 - [Mark Markaryan](https://github.com/markmark206)
 - [Markus](https://github.com/markusfeyh)
 - [Martin Janiczek](https://github.com/Janiczek)
 - [Matt Savoia](https://github.com/matt-savvy)
 - [Matt Van Horn](https://github.com/mattvanhorn)
 - [Matthias Benkort](https://github.com/KtorZ)
 - [max-tern](https://github.com/max-tern)
 - [Michael Davis](https://github.com/the-mikedavis)
 - [Michael Duffy](https://github.com/stunthamster)
 - [Michael Jones](https://github.com/michaeljones)
 - [Mike Roach](https://github.com/mroach)
 - [MystPi](https://github.com/MystPi)
 - [Natanael Sirqueira](https://github.com/natanaelsirqueira)
 - [Nathaniel Knight](https://github.com/nathanielknight)
 - [NFIBrokerage](https://github.com/NFIBrokerage)
 - [Nick Reynolds](https://github.com/ndreynolds)
 - [Nicklas Sindlev Andersen](https://github.com/NicklasXYZ)
 - [NineFX](http://www.ninefx.com)
 - [Noah Betzen](https://github.com/Nezteb)
 - [Ocean Armstrong Lewis](https://github.com/oceanlewis)
 - [OldhamMade](https://github.com/OldhamMade)
 - [Ole Michaelis](https://github.com/OleMchls)
 - [Paul Gideon Dann](https://github.com/giddie)
 - [Paul Guse](https://github.com/pguse)
 - [Pete Jodo](https://github.com/petejodo)
 - [Philip Giuliani](https://github.com/philipgiuliani)
 - [Prashant Singh Pawar](https://github.com/prashantpawar)
 - [qingliangcn](https://github.com/qingliangcn)
 - [Raúl Chouza ](https://github.com/chouzar)
 - [Redmar Kerkhoff](https://github.com/redmar)
 - [Richard Viney](https://github.com/richard-viney)
 - [Rico Leuthold](https://github.com/rico)
 - [Robert Attard](https://github.com/TanklesXL)
 - [Robert Ellen](https://github.com/rellen)
 - [Sam Aaron](https://github.com/samaaron)
 - [Sammy Isseyegh](https://github.com/bkspace)
 - [Saša Jurić](https://github.com/sasa1977)
 - [Scott Bowles](https://github.com/scottBowles)
 - [Scott Wey](https://github.com/scottwey)
 - [Sean Jensen-Grey](https://github.com/seanjensengrey)
 - [Sebastian Porto](https://github.com/sporto)
 - [sekun](https://github.com/sekunho)
 - [Seve Salazar](https://github.com/tehprofessor)
 - [Shuqian Hon](https://github.com/honsq90)
 - [Signal Insights](https://github.com/signalinsights)
 - [Simon Johansson](https://github.com/DrPhil)
 - [Simone Vittori](https://github.com/simonewebdesign)
 - [Szymon Wygnański](https://github.com/finalclass)
 - [Thanabodee Charoenpiriyakij](https://github.com/wingyplus)
 - [Theo Harris](https://github.com/Theosaurus-Rex)
 - [Timo Sulg](https://github.com/timgluz)
 - [Tom Kenny](https://github.com/twome)
 - [Tomasz Kowal](https://github.com/tomekowal)
 - [Tristan de Cacqueray](https://github.com/TristanCacqueray)
 - [Tristan Sloughter](https://github.com/tsloughter)
 - [tynanbe](https://github.com/tynanbe)
 - [Volker Rabe](https://github.com/yelps)
 - [Weizheng Liu](https://github.com/weizhliu)
 - [Wesley Moore](https://github.com/wezm)
 - [Willyboar](https://github.com/Willyboar)
 - [Wilson Silva](https://github.com/wilsonsilva)
 - [xhh](https://github.com/xhh)
 - [Yasuo Higano](https://github.com/Yasuo-Higano)
 - [Yu Matsuzawa](https://github.com/ymtszw)
 - [Zsombor Gasparin](https://github.com/gasparinzsombor)
 - [Šárka Slavětínská](https://github.com/sarkasl)

Thanks for reading, and I hope you enjoy Gleam v1 💜

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>


