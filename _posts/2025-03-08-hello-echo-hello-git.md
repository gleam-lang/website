---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Hello echo! Hello git!
subtitle: Gleam v1.9.0 released
tags:
  - Release
---

Gleam is a type-safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.9.0][release] has been published. Let's
take a look!

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.9.0


## Echo debug printing

There are debuggers you can use with Gleam, however the most popular ways
to understand the runtime behaviour of a Gleam program is through writing tests
and through print debugging.

The standard library function `io.debug` is most commonly used for print
debugging. It takes a value of any type, uses target specific runtime
reflection to turn it into a string of Gleam syntax, and then prints it to
standard-error. This works well, but there are some ways in which this function
is not optimal:

- Functions don't know anything about where they are called from, so it's not
  possible to print the location of the `io.debug` call along with the value
  being printed.
- There's no way for the compiler or build tool to know this is a special
  function which is only for debugging, so they are unable to prevent you from
  accidentally publishing packages that still have debug code in them.
- Runtime reflection is used to make a string representation of the value, so
  any information that no longer exists after compile time cannot be used. This
  results in `io.debug` relying on heuristics to decide how to show the value,
  and this can be at-times incorrect.

To improve on this the `echo` keyword has been introduced. Prefix an expression
with it and the value will be printed to standard-error, along with the path to
the file and line containing the echo expression, so you can click to jump to it
in your editor.

```gleam
pub fn main() {
  echo [1, 2, 3]
}
```

It can also be used in pipelines. Here the list returned by the first `list.map`
call will be printed.

```gleam
pub fn main() {
  [1, 2, 3]
  |> list.map(fn(x) { x + 1 })
  |> echo
  |> list.map(fn(x) { x * 2 })
}
```

The build tool is aware this is for debugging, so it'll let you know if you
forget to remove it before publishing a package for others to use.

Currently it uses the same runtime reflection and heuristics to format the
output, but in future it'll be enhanced to make use of the compiler's static
analysis.

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)! We had all
manner of annoying CI-related problems when implementing the integration tests
for this feature, Jak's a very patient and determined programmer indeed!

## Git dependencies

There are times when we wish to try out early prototype versions of libraries we
have made in our applications. It may be tempting to publish these unfinished
packages to the package manager, but this would be inappropriate! Only
production-ready packages should be published for other people to use, the Gleam
package ecosystem is to be high quality and easy to depend upon safely.

As a more suitable alternative the build tool now supports depending on packages
within git repositories. Add the git or HTTP URL of a repository along with a
tag, branch, or commit SHA, and the build tool will download it for you and then
treat it like a regular Gleam dependency package.

```toml
[dependencies]
gleam_stdlib = { git = "https://github.com/gleam-lang/stdlib.git", ref = "957b83b" }
```

Thank you [Surya Rose](https://github.com/GearsDatapacks) for this much
anticipated feature.

## More powerful bit arrays on JavaScript

Gleam's bit array syntax allows you to construct and parse binary data in a way
that may be easier to understand than using binary operators. Historically bit
arrays had to be byte aligned, meaning they had to have a number of bits that
was divisible by 8. [Richard Viney](https://github.com/richard-viney) has done
some incredible work and lifted this limitation. Thank you Richard!

[Surya Rose](https://github.com/GearsDatapacks) has also been lifting
JavaScript bit array restrictions, enabling the usage of dynamically sized
segments in bit array patterns. Thank you Surya!

## Faster list pattern matching on JavaScript

The list type is one of Gleam's primary data structures, it is used very heavily
in Gleam programs. [yoshi~](https://github.com/yoshi-monster) has been working
hard to identify potential performance optimisations for the virtual-DOM
implementation of the [Lustre](https://github.com/lustre-labs/lustre) framework,
and in the process they identified a way to improve the JavaScript code we
generate when pattern matching on lists.

Programs that compile to JavaScript and make heavy use of list prefix patterns
may now be up to twice as fast!

## Go-to type definition

Gleam's built-in language server brings IDE-like functionality to all editors
that support the language server protocol. It has had support for go-to
definition for some time, but with this release [Giacomo Cavalieri](https://github.com/giacomocavalieri)
has added support for go-to type definition. Place your cursor on an expression
and trigger the feature and the language server will identify the types of all
the values used in the expression and present their definitions for you to view
and to jump to. Thank you Jak!

## HexDocs search integration

When a Gleam package is published HTML documentation is generated and published
to HexDocs for users to read. HexDocs have been improving their search
functionality to search for types and functions with in packages themselves, and 
[Diemo Gebhardt](https://github.com/diemogebhardt) has updated Gleam's
documentation generator to implement the search index interface so Gleam
packages are included in the search. Thank you Diemo!

Another option for searching within Gleam packages is [Gloogle](https://gloogle.run/search?q=fn(Int,%20Int)%20-%3E%20Order),
a Gleam community project, which can even search by function type signature.

## Custom CA certificates support

Some enterprise networks may perform TLS interception for security reasons. In
these environments custom CA certificates must be used as otherwise requests
will get TLS errors due to the unknown authority of the injected certificates.

The new `GLEAM_CACERTS_PATH` environment variable can be used to specify a
path to CA certificates for Gleam to use when interacting with the Hex package
manager servers, making Gleam usable in these enterprise environments.
Thank you [winstxnhdw](https://github.com/winstxnhdw)!

## Convert to and from pipeline code actions

Gleam's much-loved pipe syntax gives programmers another way to write nested
function calls so that they read top-to-botton and left-to-right.

Two new language server code actions have been added to help you refactor
between the pipe syntax and regular function call syntax. Triggering them on
these two code examples will edit your code to match the other.

```gleam
import gleam/list

pub fn main() {
  list.map([1, 2, 3], double)
}
```
```gleam
import gleam/list

pub fn main() {
  [1, 2, 3] |> list.map(double)
}
```

You can also choose to pipe arguments other than the first by selecting them in
your editor before triggering the code action. Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## Generate JSON encoder code action

Many Gleam programs make use of JSON, a common text-based data exchange format.
With this release the Gleam language server now offers a code action to generate
a function to convert a type into JSON using the `gleam_json` library. Given
this type definition:

```gleam
pub type Person {
  Person(name: String, age: Int)
}
```

If the code action is triggered on the type definition this function will be
generated:

```gleam
import gleam/json

fn encode_person(person: Person) -> json.Json {
  json.object([
    #("name", json.string(person.name)),
    #("age", json.int(person.age)),
  ])
}
```

Thank you [Surya Rose](https://github.com/GearsDatapacks) for this code action!

## Inline variable code action

The Gleam language server now offers a code action that will inline a variable
that is used only once.

```gleam
import gleam/io

pub fn main() {
  let greeting = "Hello!"
  io.println(greeting)
}
```

If the code action is triggered on the `greeting` variable the code will be
edited like so:


```gleam
import gleam/io

pub fn main() {
  io.println("Hello!")
}
```

Thank you [Surya Rose](https://github.com/GearsDatapacks)!

## Generate multi-variant decoder code action

Gleam's `Dynamic` type represents data of unknown shape that comes from outside
of the Gleam program, for example data sent to a HTTP server as JSON. To convert
data from dynamic into known Gleam types the decoder API is used.

A previous release added convenient a code action which would generate a dynamic
decoder for a given type definition. With this release this code action has been
extended to support multi-variant custom types. For example, given this type
definition:

```gleam
pub type Person {
  Adult(age: Int, job: String)
  Child(age: Int, height: Float)
}
```

If the code action is triggered on it then this function will be generated:

```gleam
import gleam/dynamic/decode

fn person_decoder() -> decode.Decoder(Person) {
  use variant <- decode.field("type", decode.string)
  case variant {
    "adult" -> {
      use age <- decode.field("age", decode.int)
      use job <- decode.field("job", decode.string)
      decode.success(Adult(age:, job:))
    }
    "child" -> {
      use age <- decode.field("age", decode.int)
      use height <- decode.field("height", decode.float)
      decode.success(Child(age:, height:))
    }
    _ -> decode.failure(todo as "Zero value for Person", "Person")
  }
}
```

Thank you [Surya Rose](https://github.com/GearsDatapacks)!

## String interpolate code action

The language server now offers a convenient code action to interpolate a value
into a string easily. If the cursor is inside a literal string the language
server will offer to split it:

```gleam
"wibble | wobble"
//      ^ Triggering the action with the cursor
//        here will produce this:
"wibble " <> todo <> " wobble"
```

And if the cursor is selecting a valid Gleam name, the language server will
offer to interpolate it as a variable:

```gleam
"wibble wobble woo"
//      ^^^^^^ Triggering the code action if you're
//             selecting an entire name, will produce this:
"wibble " <> wobble <> " woo"
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this!

## Module qualifier hovering

The language server can now show documentation for a module when hovering the
module qualifier of an imported type or value. Thank you [Surya Rose](https://github.com/GearsDatapacks)!

## Redundant function capture removal

Gleam's function capture syntax is a shorthand for creating an anonymous
function that takes one argument and calls another function with that argument
and some other values. These two expressions are equivalent:

```gleam
let double = fn(number) { int.double(number, 2) }
let double = int.double(_, 2)
```

If the function capture syntax is used without any additional arguments, then it
is redundant and does nothing that referring the function directly wouldn't do.

```gleam
let print = io.print(_)
```

The Gleam code formatter will now remove the redundant function capture syntax
for you, formatting it like so:

```gleam
let print = io.print
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## And the rest

And thank you to the bug fixers:
[Giacomo Cavalieri](https://github.com/giacomocavalieri),
[LostKobrakai](https://github.com/lostkobrakai),
[Louis Pilfold](https://github.com/lpil),
[Mikko Ahlroth](https://git.ahlcode.fi/nicd)
[Pedro Francisco](https://github.com/mine-tech-oficial),
[PgBiel](https://github.com/PgBiel),
[Richard Viney](https://github.com/richard-viney), and
[Surya Rose](https://github.com/GearsDatapacks)!

For full details of the many fixes and improvements they've implemented see [the
changelog][changelog].

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.9.md

## A call for support

Gleam is not owned by a corporation; instead it is entirely supported by
sponsors, most of which contribute between $5 and $20 USD per month, and Gleam
is my sole source of income.

We have made great progress towards our goal of being able to appropriately pay
the core team members, but we still have further to go. Please consider
supporting [the project][sponsor] or core team members 
[Giacomo Cavalieri](https://github.com/sponsors/giacomocavalieri) and
[Surya Rose](https://github.com/sponsors/GearsDatapacks) 
on GitHub Sponsors.

<a class="sponsor-level0" href="https://github.com/sponsors/lpil" rel="noopener" target="_blank">
  <img src="/images/community/github.svg" alt="GitHub Sponsors" style="filter: invert(1)"/>
</a>

[sponsor]: https://github.com/sponsors/lpil

Thank you to all our sponsors! And especially our top sponsor: Lambda.

<ul class="top-sponsors">
  <li>
    <a class="sponsor-level1" href="https://lambdaclass.com/" rel="noopener" target="_blank" >
      <img src="/images/sponsors/lambda-class-white.png" alt="Lambda Class">
    </a>
  </li>
</ul>

- [Aaron Gunderson](https://github.com/agundy)
- [Abdulrhman Alkhodiry](https://github.com/zeroows)
- [Abel Jimenez](https://github.com/abeljim)
- [ad-ops](https://github.com/ad-ops)
- [Adam Brodzinski](https://github.com/AdamBrodzinski)
- [Adam Johnston](https://github.com/adjohnston)
- [Adam Wyłuda](https://github.com/adam-wyluda)
- [Adi Iyengar](https://github.com/thebugcatcher)
- [Adrian Mouat](https://github.com/amouat)
- [Ajit Krishna](https://github.com/JitPackJoyride)
- [Aleksei Gurianov](https://github.com/Guria)
- [Alembic](https://alembic.com.au)
- [Alex](https://github.com/eelmafia)
- [Alex Houseago](https://github.com/ahouseago)
- [Alex Manning](https://github.com/rawhat)
- [Alex Viscreanu](https://github.com/aexvir)
- [Alexander Koutmos](https://github.com/akoutmos)
- [Alexander Stensrud](https://github.com/muonoum)
- [Alexandre Del Vecchio](https://github.com/defgenx)
- [Ameen Radwan](https://github.com/Acepie)
- [Andrea Bueide](https://github.com/abueide)
- [AndreHogberg](https://github.com/AndreHogberg)
- [Andrew Muratov](https://github.com/andrewmuratov)
- [Antharuu](https://github.com/antharuu)
- [Anthony Khong](https://github.com/anthony-khong)
- [Anthony Maxwell](https://github.com/Illbjorn)
- [Anthony Scotti](https://github.com/amscotti)
- [Arthur Weagel](https://github.com/aweagel)
- [Arya Irani](https://github.com/aryairani)
- [Azure Flash](https://github.com/azureflash)
- [Barry Moore](https://github.com/chiroptical)
- [Bartek Górny](https://github.com/bartekgorny)
- [Ben Martin](https://github.com/requestben)
- [Ben Marx](https://github.com/bgmarx)
- [Ben Myles](https://github.com/benmyles)
- [Benjamin Kane](https://github.com/bbkane)
- [Benjamin Peinhardt](https://github.com/bcpeinhardt)
- [bgw](https://github.com/bgwdotdev)
- [Bjarte Aarmo Lund](https://github.com/bjartelund)
- [Bjoern Paschen](https://github.com/00bpa)
- [Brad Mehder](https://github.com/bmehder)
- [Brendan P. ](https://github.com/brendisurfs)
- [brettkolodny](https://github.com/brettkolodny)
- [Brian Dawn](https://github.com/brian-dawn)
- [Brian Glusman](https://github.com/bglusman)
- [Bruce Williams](https://github.com/bruce)
- [Bruno Michel](https://github.com/nono)
- [bucsi](https://github.com/bucsi)
- [Cam Ray](https://github.com/camray)
- [Cameron Presley](https://github.com/cameronpresley)
- [Carlo Munguia](https://github.com/carlomunguia)
- [Carlos Saltos](https://github.com/csaltos)
- [Chad Selph](https://github.com/chadselph)
- [Charlie Duong](https://github.com/ctdio)
- [Charlie Govea](https://github.com/charlie-n01r)
- [Chew Choon Keat](https://github.com/choonkeat)
- [Chris Donnelly](https://github.com/ceedon)
- [Chris King](https://github.com/Morzaram)
- [Chris Lloyd](https://github.com/chrislloyd)
- [Chris Ohk](https://github.com/utilForever)
- [Chris Rybicki](https://github.com/Chriscbr)
- [Christopher David Shirk](https://github.com/christophershirk)
- [Christopher De Vries](https://github.com/devries)
- [Christopher Dieringer](https://github.com/cdaringe)
- [Christopher Jung](https://github.com/christopherhjung)
- [Christopher Keele](https://github.com/christhekeele)
- [CJ Salem](https://github.com/specialblend)
- [clangley](https://github.com/clangley)
- [Clifford Anderson](https://github.com/CliffordAnderson)
- [Coder](https://github.com/coder)
- [Cole Lawrence](https://github.com/colelawrence)
- [Colin](https://github.com/insanitybit)
- [Comamoca](https://github.com/Comamoca)
- [Constantin (Cleo) Winkler](https://github.com/Lucostus)
- [Corentin J.](https://github.com/jcorentin)
- [Daigo Shitara](https://github.com/sdaigo)
- [Damir Vandic](https://github.com/dvic)
- [Dan Dresselhaus](https://github.com/ddresselhaus)
- [Dan Strong](https://github.com/strongoose)
- [Danielle Maywood](https://github.com/DanielleMaywood)
- [Danny Arnold](https://github.com/pinnet)
- [Danny Martini](https://github.com/despairblue)
- [Dave Lucia](https://github.com/davydog187)
- [David Bernheisel](https://github.com/dbernheisel)
- [David Cornu](https://github.com/davidcornu)
- [David Sancho](https://github.com/davesnx)
- [Dennis Dang](https://github.com/dangdennis)
- [dennistruemper](https://github.com/dennistruemper)
- [Diemo Gebhardt](https://github.com/diemogebhardt)
- [Dillon Mulroy](https://github.com/dmmulroy)
- [Dima Utkin](https://github.com/gothy)
- [Dmitry Poroh](https://github.com/poroh)
- [DoctorCobweb](https://github.com/DoctorCobweb)
- [Donnie Flood](https://github.com/floodfx)
- [ds2600](https://github.com/ds2600)
- [Dylan Carlson](https://github.com/gdcrisp)
- [Éber Freitas Dias](https://github.com/eberfreitas)
- [Ed Hinrichsen](https://github.com/edhinrichsen)
- [Edon Gashi](https://github.com/edongashi)
- [eeeli24](https://github.com/eeeli24)
- [Eileen Noonan](https://github.com/enoonan)
- [eli](https://github.com/dropwhile)
- [Emma](https://github.com/Emma-Fuller)
- [EMR Technical Solutions](https://github.com/EMRTS)
- [Endo Shogo](https://github.com/yellowsman)
- [Eric Koslow](https://github.com/ekosz)
- [Erik Terpstra](https://github.com/eterps)
- [erikareads](https://liberapay.com/erikareads/)
- [ErikML](https://github.com/ErikML)
- [erlend-axelsson](https://github.com/erlend-axelsson)
- [Ernesto Malave](https://github.com/oberernst)
- [Ethan Olpin](https://github.com/EthanOlpin)
- [Evaldo Bratti](https://github.com/evaldobratti)
- [Evan Johnson](https://github.com/evanj2357)
- [evanasse](https://github.com/evanasse)
- [Fabrizio Damicelli](https://github.com/fabridamicelli)
- [Fede Esteban](https://github.com/fmesteban)
- [Felix Mayer](https://github.com/yerTools)
- [Fernando Farias](https://github.com/nandofarias)
- [Filip Figiel](https://github.com/ffigiel)
- [Florian Kraft](https://github.com/floriank)
- [Francis Hamel](https://github.com/francishamel)
- [frankwang](https://github.com/Frank-III)
- [G-J van Rooyen](https://github.com/gvrooyen)
- [Gabriel Vincent](https://github.com/gabrielvincent)
- [Geir Arne Hjelle](https://github.com/gahjelle)
- [Georg Hartmann](https://github.com/brasilikum)
- [George](https://github.com/george-grec)
- [Georgi Martsenkov](https://github.com/gmartsenkov)
- [ggobbe](https://github.com/ggobbe)
- [Giacomo Cavalieri](https://github.com/giacomocavalieri)
- [Giovanni Kock Bonetti](https://github.com/giovannibonetti)
- [Graham Vasquez](https://github.com/GV14982)
- [grotto](https://github.com/grottohub)
- [Guilherme de Maio](https://github.com/nirev)
- [Guillaume Heu](https://github.com/guillheu)
- [Guillaume Hivert](https://github.com/ghivert)
- [Hammad Javed](https://github.com/hammad-r-javed)
- [Hannes Nevalainen](https://github.com/kwando)
- [Hannes Schnaitter](https://github.com/ildorn)
- [Hans Raaf](https://github.com/oderwat)
- [Hayleigh Thompson](https://github.com/hayleigh-dot-dev)
- [Hazel Bachrach](https://github.com/hibachrach)
- [Henning Dahlheim](https://github.com/hdahlheim)
- [Henrik Tudborg](https://github.com/tudborg)
- [Henry Warren](https://github.com/henrysdev)
- [Heyang Zhou](https://github.com/losfair)
- [Hubert Małkowski](https://github.com/hubertmalkowski)
- [human154](https://github.com/human154)
- [Humberto Piaia](https://github.com/hpiaia)
- [Iain H](https://github.com/iainh)
- [Ian González](https://github.com/Ian-GL)
- [Ian M. Jones](https://github.com/ianmjones)
- [Igor Montagner](https://github.com/igordsm)
- [Igor Rumiha](https://github.com/irumiha)
- [ILLIA NEGOVORA](https://github.com/nilliax)
- [Ingrid](https://github.com/intarga)
- [inoas](https://github.com/inoas)
- [Isaac](https://github.com/graphiteisaac)
- [Isaac Harris-Holt](https://github.com/isaacharrisholt)
- [Isaac McQueen](https://github.com/imcquee)
- [Ismael Abreu](https://github.com/ismaelga)
- [István Bozsó](https://github.com/bozso)
- [Ivar Vong](https://github.com/ivarvong)
- [Jacob Lamb](https://github.com/jacobdalamb)
- [Jake Cleary](https://github.com/jakecleary)
- [Jake Wood](https://github.com/jzwood)
- [Jakob Ladegaard Møller](https://github.com/jakob753951)
- [James Birtles](https://github.com/jamesbirtles)
- [James MacAulay](https://github.com/jamesmacaulay)
- [Jan Pieper](https://github.com/janpieper)
- [Jan Skriver Sørensen](https://github.com/monzool)
- [Jean-Adrien Ducastaing](https://github.com/MightyGoldenOctopus)
- [Jean-Luc Geering](https://github.com/jlgeering)
- [Jen Stehlik](https://github.com/okkdev)
- [jiangplus](https://github.com/jiangplus)
- [Jimpjorps™](https://github.com/hunkyjimpjorps)
- [Joey Kilpatrick](https://github.com/joeykilpatrick)
- [Joey Trapp](https://github.com/joeytrapp)
- [Johan Strand](https://github.com/johan-st)
- [John Björk](https://github.com/JohnBjrk)
- [John Gallagher](https://github.com/johngallagher)
- [John Pavlick](https://github.com/jmpavlick)
- [John Strunk](https://github.com/jrstrunk)
- [Jojor](https://github.com/xjojorx)
- [Jon Lambert](https://github.com/jonlambert)
- [Jonas E. P](https://github.com/igern)
- [Jonas Hedman Engström](https://github.com/JonasHedEng)
- [jooaf](https://github.com/jooaf)
- [Joseph Lozano](https://github.com/joseph-lozano)
- [Joshua Steele](https://github.com/joshocalico)
- [Julian Hirn](https://github.com/Nineluj)
- [Julian Lukwata](https://liberapay.com/d2quadra/)
- [Julian Schurhammer](https://github.com/schurhammer)
- [Justin Lubin](https://github.com/justinlubin)
- [Jérôme Schaeffer](https://github.com/Neofox)
- [Kemp Brinson](https://github.com/jkbrinso)
- [Kero van Gelder](https://github.com/keroami)
- [Kevin Schweikert](https://github.com/kevinschweikert)
- [Kramer Hampton](https://github.com/hamptokr)
- [Kritsada Sunthornwutthikrai](https://github.com/Bearfinn)
- [Kryštof Řezáč](https://github.com/krystofrezac)
- [Krzysztof G.](https://github.com/krzysztofgb)
- [Leandro Ostera](https://github.com/leostera)
- [Lee Jarvis](https://github.com/leejarvis)
- [Leon Qadirie](https://github.com/leonqadirie)
- [Leonardo Donelli](https://github.com/LeartS)
- [lidashuang](https://github.com/defp)
- [Lily Rose](https://github.com/LilyRose2798)
- [liv](https://github.com/nnuuvv)
- [Loïc Tosser](https://github.com/wowi42)
- [Lucas Pellegrinelli](https://github.com/lucaspellegrinelli)
- [Lukas Bjarre](https://github.com/lbjarre)
- [Lukas Meihsner](https://github.com/lukasmeihsner)
- [Luke Amdor](https://github.com/lamdor)
- [Luna](https://github.com/2kool4idkwhat)
- [Manuel Rubio](https://github.com/manuel-rubio)
- [Marcos](https://github.com/ideaMarcos)
- [marcusandre](https://github.com/marcusandre)
- [Mariano Uvalle](https://github.com/AYM1607)
- [Marius Kalvø](https://github.com/mariuskalvo)
- [Mark Holmes](https://github.com/markholmes)
- [Mark Markaryan](https://github.com/markmark206)
- [Martijn Gribnau](https://github.com/foresterre)
- [Martin Janiczek](https://github.com/Janiczek)
- [Martin Poelstra](https://github.com/poelstra)
- [Martin Rechsteiner ](https://github.com/rechsteiner)
- [martonkaufmann](https://github.com/martonkaufmann)
- [Matt Champagne](https://github.com/han-tyumi)
- [Matt Heise](https://github.com/mhheise)
- [Matt Mullenweg](https://github.com/m)
- [Matt Robinson](https://github.com/matthewrobinsondev)
- [Matt Savoia](https://github.com/matt-savvy)
- [Matt Van Horn](https://github.com/mattvanhorn)
- [Matthew Whitworth](https://github.com/mwhitworth)
- [Max McDonnell](https://github.com/maxmcd)
- [metame](https://github.com/metame)
- [METATEXX GmbH](https://github.com/metatexx)
- [Metin Emiroğlu](https://github.com/amiroff)
- [Michael Duffy](https://github.com/stunthamster)
- [Michael Jones](https://github.com/michaeljones)
- [Michael Mazurczak](https://github.com/monocursive)
- [Michael McClintock](https://github.com/mrmcc3)
- [Mikael Karlsson](https://github.com/karlsson)
- [Mike Roach](https://github.com/mroach)
- [Mikey J](https://liberapay.com/mikej/)
- [MoeDev](https://github.com/MoeDevelops)
- [MzRyuKa](https://github.com/rykawamu)
- [n8n - Workflow Automation](https://github.com/n8nio)
- [Natanael Sirqueira](https://github.com/natanaelsirqueira)
- [Nathaniel Knight](https://github.com/nathanielknight)
- [Nayuki](https://github.com/Kuuuuuuuu)
- [NFIBrokerage](https://github.com/NFIBrokerage)
- [Nick Chapman](https://github.com/nchapman)
- [Nick Reynolds](https://github.com/ndreynolds)
- [Nicklas Sindlev Andersen](https://github.com/NicklasXYZ)
- [NicoVIII](https://github.com/NicoVIII)
- [Niket Shah](https://github.com/mrniket)
- [Nikolai S. K.](https://github.com/blink1415)
- [Ninaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa](https://github.com/ninanomenon)
- [NineFX](http://www.ninefx.com)
- [Nomio](https://github.com/nomio)
- [Ocean](https://github.com/oceanlewis)
- [Olaf Sebelin](https://github.com/osebelin)
- [OldhamMade](https://github.com/OldhamMade)
- [Oliver Medhurst](https://github.com/CanadaHonk)
- [Oliver Tosky](https://github.com/otosky)
- [optizio](https://github.com/optizio)
- [Patrick Wheeler](https://github.com/Davorak)
- [Paul Guse](https://github.com/pguse)
- [Pawel Biernacki](https://github.com/biernacki)
- [Pedro Correa](https://github.com/Tulkdan)
- [Pete Jodo](https://github.com/petejodo)
- [Peter Rice](https://github.com/pvsr)
- [Philpax](https://github.com/philpax)
- [Pierrot](https://github.com/pierrot-lc)
- [Qdentity](https://github.com/qdentity)
- [Race Williams](https://github.com/raquentin)
- [Rasmus](https://github.com/stoft)
- [Ray](https://github.com/ray-delossantos)
- [Raúl Chouza ](https://github.com/chouzar)
- [re.natillas](https://github.com/renatillas)
- [Redmar Kerkhoff](https://github.com/redmar)
- [Reilly Tucker Siemens](https://github.com/reillysiemens)
- [Renato Massaro](https://github.com/renatomassaro)
- [Renovator](https://github.com/renovatorruler)
- [Richard Viney](https://github.com/richard-viney)
- [Rico Leuthold](https://github.com/rico)
- [Rintaro Okamura](https://github.com/rinx)
- [Ripta Pasay](https://github.com/ripta)
- [Rob](https://github.com/robertwayne)
- [Robert Attard](https://github.com/TanklesXL)
- [Robert Ellen](https://github.com/rellen)
- [Robert Malko](https://github.com/malkomalko)
- [Rodrigo Álvarez](https://github.com/Papipo)
- [Ronan Harris](https://liberapay.com/Karakunai/)
- [Rotabull](https://github.com/rotabull)
- [Rupus Reinefjord](https://github.com/reinefjord)
- [Ruslan Ustitc](https://github.com/ustitc)
- [Ryan Moore](https://github.com/mooreryan)
- [Sam Aaron](https://github.com/samaaron)
- [Sam Zanca](https://github.com/metruzanca)
- [sambit](https://github.com/soulsam480)
- [Sammy Isseyegh](https://github.com/bkspace)
- [Santi Lertsumran](https://github.com/mrgleam)
- [Savva](https://github.com/castletaste)
- [Saša Jurić](https://github.com/sasa1977)
- [Scott Trinh](https://github.com/scotttrinh)
- [Scott Weber](https://github.com/smweber)
- [Scott Wey](https://github.com/scottwey)
- [Scott Zhu Reeves](https://github.com/star-szr)
- [Sean Jensen-Grey](https://github.com/seanjensengrey)
- [Sean Roberts](https://github.com/SeanRoberts)
- [Sebastian Porto](https://github.com/sporto)
- [sekun](https://github.com/sekunho)
- [Seve Salazar](https://github.com/tehprofessor)
- [Shane Poppleton](https://github.com/codemonkey76)
- [Shuqian Hon](https://github.com/honsq90)
- [Sigma](https://github.com/sigmasternchen)
- [Simone Vittori](https://github.com/simonewebdesign)
- [Stefan](https://github.com/bytesource)
- [Stefan Hagen](https://github.com/sthagen)
- [Steinar Eliassen](https://github.com/steinareliassen)
- [Stephen Belanger](https://github.com/Qard)
- [Steve Powers](https://github.com/stvpwrs)
- [Strandinator](https://github.com/Strandinator)
- [Sławomir Ehlert](https://github.com/slafs)
- [Theo Harris](https://github.com/Theosaurus-Rex)
- [Thomas](https://github.com/thomaswhyyou)
- [Thomas Coopman](https://github.com/tcoopman)
- [Thomas Ernst](https://github.com/ernstla)
- [Tim Brown](https://github.com/tmbrwn)
- [Timo Sulg](https://github.com/timgluz)
- [Tom Schuster](https://github.com/tomjschuster)
- [Tomasz Kowal](https://github.com/tomekowal)
- [tommaisey](https://github.com/tommaisey)
- [Travis Johnson](https://github.com/ThisGuyCodes)
- [Tristan de Cacqueray](https://github.com/TristanCacqueray)
- [Tristan Sloughter](https://github.com/tsloughter)
- [Tudor Luca](https://github.com/lucamtudor)
- [tymak](https://github.com/tymak)
- [upsidedowncake](https://github.com/upsidedownsweetfood)
- [Valerio Viperino](https://github.com/vvzen)
- [Vic Valenzuela](https://github.com/sandsower)
- [Victor Rodrigues](https://github.com/rodrigues)
- [Viv Verner](https://github.com/PerpetualPossum)
- [Volker Rabe](https://github.com/yelps)
- [Walton Hoops](https://github.com/Whoops)
- [Weizheng Liu](https://github.com/weizhliu)
- [wheatfox](https://github.com/enkerewpo)
- [Willyboar](https://github.com/Willyboar)
- [Wilson Silva](https://github.com/wilsonsilva)
- [Xucong Zhan](https://github.com/HymanZHAN)
- [Yamen Sader](https://github.com/yamen)
- [Yasuo Higano](https://github.com/Yasuo-Higano)
- [yoshi~ ](https://github.com/yoshi-monster)
- [Zsombor Gasparin](https://github.com/gasparinzsombor)
- [ZWubs](https://github.com/zwubs)
- [~1814730](https://liberapay.com/~1814730/)
- [~1847917](https://liberapay.com/~1847917/)
- [~1867501](https://liberapay.com/~1867501/)

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>
