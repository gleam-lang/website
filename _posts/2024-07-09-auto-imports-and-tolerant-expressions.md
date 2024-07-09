---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Auto-imports and tolerant expressions
subtitle: Gleam v1.3.0 released
tags:
  - Release
---

Gleam is a type safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.3.0][release] has been published, and we're
going to go over all that's new.

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.3.0

## Auto-imports

Excellent developer tooling is important for programmers to be productive so the
Gleam core team develops and maintains the Gleam language server, which provides
IDE features for all text editors. As the language only reached v1.0.0 a handful
of months ago the language server is one of the least mature parts of the
toolchain, but it is improving very rapidly!

With this release it will now suggest completions for values and types from
any module in the project or its dependencies, and if the module hasn't been
imported yet then an import statement will be added for you.

For example, if you have this code:

```gleam
pub fn main() {
  [1, 2, 3] |> eac
}
```

And you accept `list.each` as the completion for `eac`, you'll get this:

```gleam
import gleam/list

pub fn main() {
  [1, 2, 3] |> list.each
}
```

Thank you [Ameen Radwan](https://github.com/Acepie) for this feature!

## Tolerant expressions

The language server is _fault tolerant_, meaning it is able to work with and
understand your code even when it has errors that would cause the compiler to
halt. Without this feature the information and assistance offered in
your editor would degrade when your project does not compile successfully, such
as when performing a refactoring.

Fault tolerance was introduced in v1.2.0 and was at a module definition level
granularity. [Ameen Radwan](https://github.com/Acepie) has improved this to be
expression level, giving further information in functions which has errors
within them.

## Completion improvements

The language server protocol has some ambiguities around completions, so if one
of the completion APIs is used then you will get different results in different
text editors. Resident language-server magician [Ameen Radwan](https://github.com/Acepie)
has upgraded the language server to use the more complex completion API which
gives consistent results in all text editors.

On top of that completions are no longer provided inside comments, thank you
[Nicky Lim](https://github.com/nicklimmm)!

## Import cycles diagnostics

The language server protocol has a way for servers to send messages to the
client to be displayed to user. However, one newer editor that is very popular
with Gleam programmers doesn't support this API yet, so any project errors sent
this way wouldn't be displayed to the programmer.

The most common errors which would cause this problem are the ones for import
cycles, so [Ameen Radwan](https://github.com/Acepie) has converted this error to
be attached to the locations of all of the import statements which cause the
cycle.

As part of this work the language server diagnostics system has been upgraded to
make use of the protocol's ability to have diagnostic nested within each other,
a feature which can benefit more errors and warnings in future.

## Helpful hidden hovering

Gleam has a syntax for ignoring record fields that you're not interested in when
pattern matching on them:

```gleam
case pokemon {
  Pokemon(name: "Staryu", ..) -> "Hi Staryu!"
  Pokemon(name: name, ..) -> "Hello " <> name
}
```

[Giacomo Cavalieri](https://github.com/giacomocavalieri) has made it so when you
hover over the `..` in your editor it'll show you the details of the remaining
fields, so you can easily see what they are and add them to your pattern as
required.

```markdown
Unused positional fields:
- `Int`

Unused labelled fields:
- `sprite: String`
- `abilities: List(String)`
- `types: List(String)`
```

## Redundant tuple code-action

Gleam v1.2.0 added a warning for when a redundant tuple is used to pattern match
on multiple values at the same time in a `case` expression. The language server
now has a code-action that can fix the code with a single button press.

```gleam
case #(a, b) {
  #(1, 2) -> todo
  _ -> todo
}
```

Becomes:

```gleam
case a, b {
  1, 2 -> todo
  _, _ -> todo
}
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## `gleam add`, `gleam remove`

The Gleam command line has two commands for quickly adding and removing
dependencies without manually editing the `gleam.toml` project file.

Thanks to [Rahul D. Ghosal](https://github.com/rdghosal) `gleam add` can now take
an optional package version specifier:

```shell
gleam add lustre@1.2.3 # "1.2.3"
gleam add lustre@1.2   # ">= 1.2.0 and < 2.0.0"
gleam add lustre@1     # ">= 1.0.0 and < 2.0.0"
```

And `gleam remove` will now present an error if a package being removed does not
exist as a dependency in the project. Previously it would see that package
already doesn't exist and report the removal as successful.
Thank you [Changfeng Lou](https://github.com/hnlcf) for this!

## Syntax warning and error improvements

Thanks to [Giacomo Cavalieri](https://github.com/giacomocavalieri)
the compiler now emits a warning for redundant function captures in a pipeline:

```text
warning: Redundant function capture
  ┌─ /src/warning/wrn.gleam:5:17
  │
5 │     1 |> wibble(_, 2) |> wibble(2)
  │                 ^ You can safely remove this

This function capture is redundant since the value is already piped as the
first argument of this call.

See: https://tour.gleam.run/functions/pipelines/
```

And thanks to [Antonio Iaccarino](https://github.com/eingin) there is now a
more informative error explaining why the `..` list prepending syntax cannot be
used for appending.

```text
error: Syntax error
  ┌─ /src/parse/error.gleam:4:14
  │
4 │         [..rest, last] -> 1
  │          ^^^^^^ I wasn't expecting elements after this

Lists are immutable and singly-linked, so to match on the end
of a list would require the whole list to be traversed. This
would be slow, so there is no built-in syntax for it. Pattern
match on the start of the list instead.
```

On the subject of the `..` syntax, using it without a comma (`[a..b]`) has been 
deprecated in favour of the recommended `[a, ..b]` syntax.

This was to avoid it being mistaken for a range syntax, which Gleam does
not have. The comma-less syntax being accepted by the parser was not intentional
and was a mistake by the Gleam compiler developers. If a Gleam v2.0.0 is
released in future then this mistake will be corrected then.
Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!


And lastly on the syntax side, [Rahul D. Ghosal](https://github.com/rdghosal)
has improved the error message for an unexpected token to include more
information. This change was prompted to help people understand what the issue
was when trying to use a keyword as a variable name:

```text
error: Syntax error
  ┌─ /src/parse/error.gleam:3:9
3 │     A(type: String)
  │       ^^^^ I was not expecting this

Found the keyword `type`, expected one of:
- `)`
- a constructor argument name
```

## OTP 27 keyword support

Erlang/OTP 27 introduced two new keywords to Erlang, `maybe` and `else`.
[Jake Barszcz](https://github.com/barszcz) and [Giacomo Cavalieri](https://github.com/giacomocavalieri)
have updated Gleam's Erlang code generation to appropriately escape any
functions, types, and record constructors which would clash with the new Erlang
syntax.

## JavaScript byte alignment errors

When compiling to JavaScript Gleam's bit-arrays must contain a whole number of
bytes. In future this limitation will be lifted, but today it is an error to
attempt to construct one with some other number of bits.

The error for this has been moved from run-time to compile-time when a constant
number is used with the `size` option of a bit-array.

```text
error: Unsupported feature for compilation target
  ┌─ /src/test/gleam_test.gleam:6:5
  │
6 │   <<1:size(5)>>
  │     ^^^^^^^^^

Non byte aligned array is not supported for JavaScript compilation.
```

Thank you [Pi-Cla](https://github.com/Pi-Cla) for this improvement!


## Arithmetic guards

The Erlang virtual machine only supports a limited subset of expressions in case
clause guards, and Gleam inherits this restriction. With this version Gleam now
supports arithmetic operations on floats and ints here too.

```gleam
case numbers {
  [x, y] if x + y == 0 -> "zero sum"
  _ -> "something else"
}
```

Thank you [Danielle Maywood](https://github.com/DanielleMaywood) for this!

## Hints for JavaScript bundlers

When compiling Gleam to JavaScript it may be useful to use a JavaScript bundler
such as esbuild or Vite to perform dead-code elimination and to combine all the
modules into a single file.

These bundlers don't know as much about the code as the Gleam compiler does, so
at times they have to be conservative with dead code elimination as they cannot
tell if code has side effects or not, and so cannot tell if removing some code
would change the behaviour of the program. To give them a little help Gleam will
output `/* @__PURE__ */` annotation comments to pure constructors, which
bundlers will use to perform more aggressive elimination.

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## And the rest

If you'd like to see all the changes for this release, including all the bug
fixes, check out [the changelog][changelog] in the git repository.

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.3.md

## Thanks

Gleam is made possible by the support of all the kind people and companies who have
very generously [**sponsored**][sponsor] or contributed to the project. Thank you all!

If you like Gleam consider sponsoring or asking your employer to
[sponsor Gleam development][sponsor]. I work full time on Gleam and your kind
sponsorship is how I pay my bills!

[sponsor]: https://github.com/sponsors/lpil

Alternatively consider using our [referral link for CodeCrafters](https://app.codecrafters.io/join?via=lpil),
who have courses on implementing Redis, SQLite, and grep in Gleam. Use your
training budget to learn and to support Gleam too!

- [00bpa](https://github.com/00bpa)
- [Aaron Gunderson](https://github.com/agundy)
- [Abdulrhman Alkhodiry](https://github.com/zeroows)
- [Ace](https://github.com/Acepie)
- [ad-ops](https://github.com/ad-ops)
- [Adam Brodzinski](https://github.com/AdamBrodzinski)
- [Adam Johnston](https://github.com/adjohnston)
- [Adi Iyengar](https://github.com/thebugcatcher)
- [Adi Salimgereyev](https://github.com/abs0luty)
- [Ajit Krishna](https://github.com/JitPackJoyride)
- [Akira Komamura](https://github.com/akirak)
- [Alembic](https://alembic.com.au)
- [Alex Manning](https://github.com/rawhat)
- [Alex Viscreanu](https://github.com/aexvir)
- [Alexander Koutmos](https://github.com/akoutmos)
- [Alexander Stensrud](https://github.com/spektroskop)
- [Alexandre Del Vecchio](https://github.com/defgenx)
- [Alyx](https://github.com/AlyxPink)
- [AndreHogberg](https://github.com/AndreHogberg)
- [András B Nagy](https://github.com/BNAndras)
- [Andy Aylward](https://github.com/aaylward)
- [Anthony Khong](https://github.com/anthony-khong)
- [Anthony Maxwell](https://github.com/Illbjorn)
- [Anthony Scotti](https://github.com/amscotti)
- [Antonio Iaccarino](https://github.com/Eingin)
- António Dias
- [Arnaud Berthomier](https://github.com/oz)
- [Arthur Weagel](https://github.com/aweagel)
- [Austin Daily](https://github.com/austinKane95)
- [Barry Moore](https://github.com/chiroptical)
- [Bartek Górny](https://github.com/bartekgorny)
- [Ben Martin](https://github.com/requestben)
- [Ben Marx](https://github.com/bgmarx)
- [Ben Myles](https://github.com/benmyles)
- [Benjamin Peinhardt](https://github.com/bcpeinhardt)
- [Benjamin Thomas](https://github.com/bentomas)
- [bgw](https://github.com/bgwdotdev)
- [Bill Nunney](https://github.com/bigtallbill)
- [Brad Bollenbach](https://github.com/bradb)
- [Brad Lewis](https://github.com/BradLewis)
- [brettkolodny](https://github.com/brettkolodny)
- [Brian Dawn](https://github.com/brian-dawn)
- [Brian Glusman](https://github.com/bglusman)
- [Bruno Michel](https://github.com/nono)
- [bucsi](https://github.com/bucsi)
- [bwireman](https://github.com/bwireman)
- [Carlo Munguia](https://github.com/carlomunguia)
- [Carlos Saltos](https://github.com/csaltos)
- [Carter Davis](https://github.com/orvitpng)
- [Chad Selph](https://github.com/chadselph)
- Changfeng Lou
- [Charlie Govea](https://github.com/charlie-n01r)
- [Chaz Watkins](https://github.com/chazwatkins)
- [Chetan Bhasin](https://github.com/ChetanBhasin)
- [Chew Choon Keat](https://github.com/choonkeat)
- [Chris Donnelly](https://github.com/ceedon)
- [Chris King](https://github.com/Morzaram)
- [Chris Lloyd](https://github.com/chrislloyd)
- [Chris Ohk](https://github.com/utilForever)
- [Chris Rybicki](https://github.com/Chriscbr)
- [Christopher Dieringer](https://github.com/cdaringe)
- [Christopher Keele](https://github.com/christhekeele)
- [clangley](https://github.com/clangley)
- [Cleo](https://github.com/Lucostus)
- [CodeCrafters](https://github.com/codecrafters-io)
- [Coder](https://github.com/coder)
- [Cole Lawrence](https://github.com/colelawrence)
- [Colin](https://github.com/insanitybit)
- [Collin](https://github.com/CollinBrennan)
- [Comamoca](https://github.com/Comamoca)
- [Constantine Manakov](https://github.com/c-manakov)
- [Cristine Guadelupe](https://github.com/cristineguadelupe)
- [Daigo Shitara](https://github.com/sdaigo)
- [Damir Vandic](https://github.com/dvic)
- [Dan Dresselhaus](https://github.com/ddresselhaus)
- [Daniel](https://github.com/danielelli)
- [Danielle Maywood](https://github.com/DanielleMaywood)
- [Danny Arnold](https://github.com/pinnet)
- [Danny Martini](https://github.com/despairblue)
- [Darshak Parikh](https://github.com/dar5hak)
- [Dave Lucia](https://github.com/davydog187)
- [David Bernheisel](https://github.com/dbernheisel)
- [David Sancho](https://github.com/davesnx)
- [Day Fisher](https://github.com/ddfisher)
- [Denis](https://github.com/myFavShrimp)
- [Dennis Dang](https://github.com/dangdennis)
- [dennistruemper](https://github.com/dennistruemper)
- [Dillon Mulroy](https://github.com/dmmulroy)
- [Dima Utkin](https://github.com/gothy)
- [Diogo Korok](https://github.com/korokd)
- [Dmitry Poroh](https://github.com/poroh)
- [ds2600](https://github.com/ds2600)
- [ducdetronquito](https://github.com/ducdetronquito)
- [Edon Gashi](https://github.com/edongashi)
- [Eileen Noonan](https://github.com/enoonan)
- [eli](https://github.com/dropwhile)
- [Elliott Pogue](https://github.com/epogue)
- [Emma](https://github.com/Emma-Fuller)
- [EMR Technical Solutions](https://github.com/EMRTS)
- [Erik Lilja](https://github.com/Lilja)
- [Erik Terpstra](https://github.com/eterps)
- [erikareads](https://erikarow.land/)
- [ErikML](https://github.com/ErikML)
- [Ernesto Malave](https://github.com/oberernst)
- [Felix Mayer](https://github.com/yerTools)
- [Fernando Farias](https://github.com/nandofarias)
- [Filip Figiel](https://github.com/ffigiel)
- [Fionn Langhans](https://github.com/codefionn)
- [Florian Kraft](https://github.com/floriank)
- [frozen](https://github.com/Frozen)
- [GearsDatapacks](https://github.com/GearsDatapacks)
- [Georg H. Ekeberg](https://github.com/hagenek)
- [Giacomo Cavalieri](https://github.com/giacomocavalieri)
- [Gioele Bucci](https://github.com/GioeleBucci)
- [Graeme Coupar](https://github.com/obmarg)
- [grotto](https://github.com/grottohub)
- [Guilherme de Maio](https://github.com/nirev)
- [Guillaume Hivert](https://github.com/ghivert)
- [Hammad Javed](https://github.com/hammad-r-javed)
- [Hampus Kraft](https://github.com/hampuskraft)
- [Hannes Schnaitter](https://github.com/ildorn)
- [Hayes Hundman](https://github.com/jhundman)
- [Hayleigh Thompson](https://github.com/hayleigh-dot-dev)
- [Hazel Bachrach](https://github.com/hibachrach)
- [Henning Dahlheim](https://github.com/hdahlheim)
- [Henry Firth](https://github.com/h14h)
- [Henry Warren](https://github.com/henrysdev)
- [Hex](https://github.com/hexpm)
- [human154](https://github.com/human154)
- [Humberto Piaia](https://github.com/hpiaia)
- [Iain H](https://github.com/iainh)
- [Ian González](https://github.com/Ian-GL)
- [Ian M. Jones](https://github.com/ianmjones)
- [Igor Goryachev](https://github.com/delitrem)
- [Igor Montagner](https://github.com/igordsm)
- [Igor Rumiha](https://github.com/irumiha)
- [inoas](https://github.com/inoas)
- [Isaac](https://github.com/graphiteisaac)
- [Isaac Harris-Holt](https://github.com/isaacharrisholt)
- [Ismael Abreu](https://github.com/ismaelga)
- [Ivar Vong](https://github.com/ivarvong)
- [J. Rinaldi](https://github.com/m-rinaldi)
- [Jacob Lamb](https://github.com/jacobdalamb)
- [Jake Barszcz](https://github.com/barszcz)
- [James Birtles](https://github.com/jamesbirtles)
- [James MacAulay](https://github.com/jamesmacaulay)
- [Jan Skriver Sørensen](https://github.com/monzool)
- [Jean-Luc Geering](https://github.com/jlgeering)
- [Jen Stehlik](https://github.com/okkdev)
- [Jenkin Schibel](https://github.com/dukeofcool199)
- [Jeremy Jacob](https://github.com/jeremyjacob)
- [jiangplus](https://github.com/jiangplus)
- [Jimpjorps™](https://github.com/hunkyjimpjorps)
- [jmcharter](https://github.com/jmcharter)
- [Joey Kilpatrick](https://github.com/joeykilpatrick)
- [Johan Strand](https://github.com/johan-st)
- [Johannes](https://github.com/johtso)
- [John Björk](https://github.com/JohnBjrk)
- [John Gallagher](https://github.com/johngallagher)
- [John Pavlick](https://github.com/jmpavlick)
- [John Strunk](https://github.com/jrstrunk)
- [John Thile](https://github.com/jthile)
- [Jonas Hedman Engström](https://github.com/JonasHedEng)
- [Jonathan Arnett](https://github.com/J3RN)
- [Josef Richter](https://github.com/josefrichter)
- [Joshua Hall](https://github.com/JoshuaHall)
- [Joshua Steele](https://github.com/joshocalico)
- [Julia Pitts](https://github.com/jewelpit)
- [Julian Kalema Lukwata](https://github.com/fridewald)
- [Julian Lukwata](https://liberapay.com/d2quadra/)
- [Julian Schurhammer](https://github.com/schurhammer)
- [Juraj Petráš](https://github.com/Hackder)
- [Kero van Gelder](https://github.com/keroami)
- [Kevin Schweikert](https://github.com/kevinschweikert)
- [Kieran Gill](https://github.com/kierangilliam)
- [kodumbeats](https://github.com/kodumbeats)
- [Komo](https://github.com/cattokomo)
- [Kramer Hampton](https://github.com/hamptokr)
- [Kryštof Řezáč](https://github.com/krystofrezac)
- [Krzysztof G.](https://github.com/krzysztofgb)
- [Leandro Ostera](https://github.com/leostera)
- [Leon Qadirie](https://github.com/leonqadirie)
- [Leonardo Donelli](https://github.com/LeartS)
- [lidashuang](https://github.com/defp)
- [LighghtEeloo](https://github.com/LighghtEeloo)
- [Lily Rose](https://github.com/LilyRose2798)
- [Loïc Tosser](https://github.com/wowi42)
- [Lucas Pellegrinelli](https://github.com/lucaspellegrinelli)
- [Lucian Petic](https://github.com/lpetic)
- [Luna](https://github.com/2kool4idkwhat)
- [Mads Hougesen](https://github.com/hougesen)
- [Manuel Rubio](https://github.com/manuel-rubio)
- [Marcus André](https://github.com/marcusandre)
- [Marcøs](https://github.com/ideaMarcos)
- [Mariano Uvalle](https://github.com/AYM1607)
- [Marius Kalvø](https://github.com/mariuskalvo)
- [Mark Holmes](https://github.com/markholmes)
- [Mark Markaryan](https://github.com/markmark206)
- [Marshall Bowers](https://github.com/maxdeviant)
- [Martin Janiczek](https://github.com/Janiczek)
- [Martin Rechsteiner ](https://github.com/rechsteiner)
- [Mathieu Darse](https://github.com/mdarse)
- [Matias Kinnunen](https://github.com/mtsknn)
- [Matt Champagne](https://github.com/han-tyumi)
- [Matt Savoia](https://github.com/matt-savvy)
- [Matt Van Horn](https://github.com/mattvanhorn)
- [Matthew Scharley](https://github.com/mscharley)
- [Matthias Benkort](https://github.com/KtorZ)
- [Max McDonnell](https://github.com/maxmcd)
- [max-tern](https://github.com/max-tern)
- [miampf](https://github.com/miampf)
- [Michael Duffy](https://github.com/stunthamster)
- [Michael Jones](https://github.com/michaeljones)
- [Michael Kieran O'Reilly](https://github.com/SoTeKie)
- [Michael Kumm](https://github.com/mkumm)
- [Michael Mark](https://github.com/Michael-Mark-Edu)
- [mihaimiuta](https://github.com/miutamihai)
- [Mike](https://liberapay.com/Daybowbow/)
- [Mike Nyola](https://github.com/nyolamike)
- [Mike Roach](https://github.com/mroach)
- [Mikey J](https://liberapay.com/mikej/)
- [MoeDev](https://github.com/MoeDevelops)
- [MzRyuKa](https://github.com/rykawamu)
- [Måns Östman](https://github.com/cheesemans)
- [n8n - Workflow Automation](https://github.com/n8nio)
- [Natanael Sirqueira](https://github.com/natanaelsirqueira)
- [Nathaniel Knight](https://github.com/nathanielknight)
- [ncihnegn](https://github.com/ncihnegn)
- [NFIBrokerage](https://github.com/NFIBrokerage)
- [Nick Chapman](https://github.com/nchapman)
- [Nick Reynolds](https://github.com/ndreynolds)
- [Nicklas Sindlev Andersen](https://github.com/NicklasXYZ)
- [Nicky Lim](https://github.com/nicklimmm)
- [Ninaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa](https://github.com/l1f)
- [NineFX](http://www.ninefx.com)
- [Nomio](https://github.com/nomio)
- [Ocean Armstrong Lewis](https://github.com/oceanlewis)
- Ofek Doitch
- [OldhamMade](https://github.com/OldhamMade)
- [Oli Clive-Griffin](https://github.com/oli-clive-griffin)
- [Oliver Linnarsson](https://github.com/Olian04)
- [Om Prakaash](https://github.com/omprakaash)
- [optizio](https://github.com/optizio)
- [Osman Cea](https://github.com/daslaf)
- [Patrick Wheeler](https://github.com/Davorak)
- [Patrik Kühl](https://github.com/patrik-kuehl)
- [Paul Gideon Dann](https://github.com/giddie)
- [Paul Guse](https://github.com/pguse)
- [Pawel Biernacki](https://github.com/biernacki)
- [Pete Jodo](https://github.com/petejodo)
- [Peter Rice](https://github.com/pvsr)
- [Peter Saxton](https://github.com/CrowdHailer)
- [Philip Giuliani](https://github.com/philipgiuliani)
- [Pi-Cla](https://github.com/Pi-Cla)
- [Piotr Szlachciak](https://github.com/sz-piotr)
- [Praveen Perera](https://github.com/praveenperera)
- [qingliangcn](https://github.com/qingliangcn)
- [Qynn Schwaab](https://github.com/2ynn)
- [Race Williams](https://github.com/raquentin)
- Rado
- [Rahul Butani](https://github.com/rrbutani)
- Rahul D. Ghosal
- Rahul Ghosal
- [Ratio PBC](https://github.com/RatioPBC)
- [Raúl Chouza ](https://github.com/chouzar)
- [Redmar Kerkhoff](https://github.com/redmar)
- [Reilly Tucker Siemens](https://github.com/reillysiemens)
- [Renovator](https://github.com/renovatorruler)
- [Richard Viney](https://github.com/richard-viney)
- [Rico Leuthold](https://github.com/rico)
- [Ripta Pasay](https://github.com/ripta)
- [Robert Attard](https://github.com/TanklesXL)
- [Robert Ellen](https://github.com/rellen)
- [Robert Malko](https://github.com/malkomalko)
- [Ross Bratton](https://github.com/brattonross)
- [Ross Cousens](https://github.com/rcousens)
- [Ruslan Ustits](https://github.com/ustitc)
- [Ryan Moore](https://github.com/mooreryan)
- [Sam Aaron](https://github.com/samaaron)
- [sambit](https://github.com/soulsam480)
- [Sami Fouad](https://github.com/samifouad)
- [Sammy Isseyegh](https://github.com/bkspace)
- [Samu Kumpulainen](https://github.com/Ozame)
- [Santi Lertsumran](https://github.com/mrgleam)
- [Saphira Kai](https://github.com/SaphiraKai)
- [Savin Angel-Mario](https://github.com/notangelmario)
- [Saša Jurić](https://github.com/sasa1977)
- [Scott Trinh](https://github.com/scotttrinh)
- [Scott Wey](https://github.com/scottwey)
- [Sean Jensen-Grey](https://github.com/seanjensengrey)
- [Sebastian Porto](https://github.com/sporto)
- [sekun](https://github.com/sekunho)
- [Seve Salazar](https://github.com/tehprofessor)
- [Shane Poppleton](https://github.com/codemonkey76)
- [Shuqian Hon](https://github.com/honsq90)
- [Simon Curtis](https://github.com/simon-curtis)
- [Simone Vittori](https://github.com/simonewebdesign)
- [Sonny Kjellberg](https://github.com/sk222sw)
- [Stephen Belanger](https://github.com/Qard)
- [syhner](https://github.com/syhner)
- [Szymon Wygnański](https://github.com/finalclass)
- [Sławomir Ehlert](https://github.com/slafs)
- [TankorSmash](https://github.com/tankorsmash)
- [Theo Harris](https://github.com/Theosaurus-Rex)
- [Thomas](https://github.com/thomaswhyyou)
- [Thomas Ernst](https://github.com/ernstla)
- [thorhj](https://github.com/thorhj)
- [Tim Brown](https://github.com/tmbrwn)
- [Timo Sulg](https://github.com/timgluz)
- [Tom Schuster](https://github.com/tomjschuster)
- [Tomasz Kowal](https://github.com/tomekowal)
- [tommaisey](https://github.com/tommaisey)
- [Tristan de Cacqueray](https://github.com/TristanCacqueray)
- [Tristan Sloughter](https://github.com/tsloughter)
- [Vassiliy Kuzenkov](https://github.com/bondiano)
- [Vic Valenzuela](https://github.com/sandsower)
- [Victor Rodrigues](https://github.com/rodrigues)
- [Vincent Costa](https://github.com/VincentCosta6)
- [Viv Verner](https://github.com/PerpetualPossum)
- [Volker Rabe](https://github.com/yelps)
- [Weizheng Liu](https://github.com/weizhliu)
- [Wesley Moore](https://github.com/wezm)
- [Willyboar](https://github.com/Willyboar)
- [Wilson Silva](https://github.com/wilsonsilva)
- [xhh](https://github.com/xhh)
- [xxKeefer](https://github.com/xxKeefer)
- [Yamen Sader](https://github.com/yamen)
- [Yasuo Higano](https://github.com/Yasuo-Higano)
- [Zhomart Mukhamejanov](https://github.com/Zhomart)
- [Zsombor Gasparin](https://github.com/gasparinzsombor)
- [~1847917](https://liberapay.com/~1847917/)

Thanks for reading, I hope you have fun with Gleam! 💜

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>
