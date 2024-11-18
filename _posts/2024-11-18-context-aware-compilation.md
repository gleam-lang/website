---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Context aware compilation
subtitle: Gleam v1.6.0 released
tags:
  - Release
---

Gleam is a type-safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.6.0][release] has been published, featuring
so many excellent improvements that I struggled to title this post.
Let's take a look at them now, but first, the Gleam developer survey!

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.6.0

This is your chance to shape our 2025 plans, so fill it in and share with your
friends! Any level of Gleam experience is OK (or even none yet at all), so
please fill it in so we can use your feedback to decide what to focus on in the
coming year.

<div style="text-align: center">
  <a class="button pulse-animation" href="https://developer-survey.gleam.run/">Gleam Developer Survey</a>
</div>

Right. Now on to the release changes.

## Context aware errors

A big part of what makes Gleam productive is the way its powerful static
analysis can immediately provide you feedback as you type, enabling you to
confidently make changes within large or unfamiliar codebases. Much of this
feedback will come in the form of error messages, so it is vital that they are
as clear and as understandable as possible.

With this release Gleam's errors are now _context aware_. Using data from the
compiler's code analysis system type errors now use the names and syntax that
the programmer would use within that specific area of the code.

For example, here is some code with a type error.

```gleam
import gleam/order

pub fn run(value: order.Order) -> Int {
  100 + value
}
```
```txt
error: Type mismatch
  ┌─ /src/problem.gleam:4:9
  │
4 │   100 + value
  │         ^^^^^

The + operator expects arguments of this type:

    Int

But this argument has this type:

    order.Order
```

Notice how the `Order` type is qualified with the module name, the same as the
programmer would write in this module. If the module is aliased when imported
then that alias will also be used in the error.

```diff
-import gleam/order
+import gleam/order as some_imported_module

-pub fn run(value: order.Order) -> Int {
+pub fn run(value: some_imported_module.Order) -> Int {
  100 + value
}
```
```diff
error: Type mismatch
  ┌─ /src/problem.gleam:4:9
  │
4 │   100 + value
  │         ^^^^^

The + operator expects arguments of this type:

    Int

But this argument has this type:

-   order.Order
+   some_imported_module.Order
```
Or the type could be imported in an unqualified fashion, in which case the error
would not have the redundant qualifier. 

```diff
-import gleam/order
+import gleam/order.{type Order}

-pub fn run(value: order.Order) -> Int {
+pub fn run(value: Order) -> Int {
  100 + value
}
```
```diff
error: Type mismatch
  ┌─ /src/problem.gleam:4:9
  │
4 │   100 + value
  │         ^^^^^

The + operator expects arguments of this type:

    Int

But this argument has this type:

-   order.Order
+   Order
```

You could even define your own types that hide prelude types like `Int`,
`Float`, and `String`, at which point the prelude types would be displayed with
a qualifier. 

Perhaps don't write code like this though, your coworkers probably won't be
happy with you if you do.

```gleam
pub type Int
pub type String

pub fn run() {
  [100, "123"]
}
```
```txt
error: Type mismatch
  ┌─ /src/thingy.gleam:6:9
  │
6 │   [100, "123"]
  │         ^^^^^

All elements of a list must be the same type, but this one doesn't
match the one before it.

Expected type:

    gleam.Int

Found type:

    gleam.String
```

These context-aware errors should reduce the mental overhead of understanding
them, making Gleam programming easier and more productive.
Thank you [Surya Rose](https://github.com/GearsDatapacks) for this!

## Context aware editing hovering

Not being satisfied with improving only the error messages, Surya has also made
the language server hovering context aware. This means that if you hover
over Gleam code in your editor the type information will be shown using the
appropriate names and syntax for that module.

```gleam
import gleam/option

const value = option.Some(1)
//    ^ hovering here shows `option.Option(Int)`
```
```gleam
import gleam/option.{type Option as Maybe}

const value = option.Some(1)
//    ^ hovering here shows `Maybe(Int)`
```

Thank you again Surya!

## Add annotations code action

In Gleam all type annotations are optional, full analysis is always performed.
Adding annotations does not make your code more safe or well typed, but we still
think it's a good idea to add them to make your code easier to read.

If your colleague has sadly forgotten this and not written any annotations for
their functions, you can use the language server's new code action within your
editor to add missing annotations. Place your cursor within this function that
is missing annotations:

```gleam
pub fn add_int_to_float(a, b) {
  a +. int.to_float(b)
}
```
And after triggering the code action this code becomes:
```gleam
pub fn add_int_to_float(a: Float, b: Int) -> Float {
  a +. int.to_float(b)
}
```

Thanks to, you guessed it, [Surya Rose](https://github.com/GearsDatapacks) for
this new feature!

## Erlang compilation daemon

When targeting the Erlang virtual machine the build tool makes use of the Erlang
compiler to generate BEAM bytecode, taking advantage of all of its
optimisations. The Erlang compiler is written in Erlang, so this would involve
booting the virtual machine and the compiler once per dependency. On a slow
machine this could take as much as half a second each time, which would add up
and slow down from-scratch build times.

The build tool now boots one instance of the virtual machine and sends code to
it for compilation when needed, completely removing this cost. This change will
be most impactful for clean builds such when changing Gleam version or in your
CI pipeline, or in monorepos of many packages.

Thank you [yoshi](https://github.com/joshi-monster) for this!

## Variant inference

The compiler now infers and keeps track of the variant of custom types within
expressions that construct or pattern match on them. Using this information it
can now be more precise with exhaustiveness checking, field access, and record
updates.

That's not the clearest explanation, so here's some examples. Imagine a custom
type named `Pet` which has two variants, `Dog` and `Turtle`.

```gleam
pub type Pet {
  Dog(name: String, cuteness: Int)
  Turtle(name: String, speed: Int, times_renamed: Int)
}
```

Any place where a value of type `Pet` is used, the code would have to take into
account both variants, even if it seems obvious to us as humans that the value
is definitely a specific variant at this point in the code. The compiler would
still require that you take the other variants into account.

With variant inference you now no longer need to include patterns for the other
variants.

```gleam
pub fn main() {
  // We know `charlie` is a `Dog`...
  let charlie = Dog("Charles", 1000)

  // ...so you do not need to match on the `Turtle` variant
  case charlie {
    Dog(..) -> todo
  }
}
```

It also works for the record update syntax. This code would previously fail to
compile due to the compiler not being able to tell that `pet` is the right
variant.

```gleam
pub fn rename(pet: Pet, to name: String) -> Pet {
  case pet {
    Dog(..) -> Dog(..pet, name:)
    Turtle(..) -> Turtle(..pet, name:, times_renamed: pet.times_renamed + 1)
  }
}
```

It also works for the field accessor syntax, enabling their use with fields that
do not exist on all of the variants.

```gleam
pub fn speed(pet: Pet) -> Int {
  case pet {
    Dog(..) -> 500

    // Here the speed field can be safely accessed even though
    // it only exists on the `Turtle` variant.
    Turtle(..) -> pet.speed
  }
}
```

Thank you [Surya Rose](https://github.com/GearsDatapacks), the superstar of this
release!

## Precise dependency updates

The `gleam update` command can be used to update your dependencies to the latest
versions compatible with the requirements specified in `gleam.toml`.

You can now also use this command to update a specific set of dependencies,
rather than all of them. If I wanted to update `lustre` and `gleam_json` I could
run this command:

```shell
gleam update lustre gleam_json
```

Thank you [Jason Sipula](https://github.com/SnakeDoc) for this feature!

## Monorepo documentation links

When a package is published Gleam will also generate and upload HTML
documentation for users to read. This documentation includes links to the source
code in its repository, assuming it is hosted using a known service such as
Forgejo or GitHub.

Unfortunately these links would not be accurate if you were using a monorepo or
if the package was not located at the root of the repository for some other
reason.

To resolve this the `repository` config in `gleam.toml` can now optionally
include a `path` so Gleam knows how to build the correct URLs.

```toml
[repository]
type = "github"
user = "pink-inc"
repo = "monorepo"
path = "packages/fancy_package"
```

Thank you [Richard Viney](https://github.com/richard-viney)!

## Result handling hints

Errors are represented as values in Gleam, and exceptions are rare and not used
for flow control. This means that Gleam programmers will very often be using the
`Result` type in their programs, which can be initially confusing to programmers
more familiar with exception based error handling.

One common stumbling block is how to use a value that is wrapped in a `Result`.
To help with this the compiler can now suggest to pattern match on these result
values when appropriate.

```txt
error: Type mismatch
  ┌─ /src/one/two.gleam:6:9
  │
6 │   int.add(1, not_a_number)
  │              ^^^^^^^^^^^^

Expected type:

    Int

Found type:

    Result(Int, a)

Hint: If you want to get a `Int` out of a `Result(Int, a)` you can pattern
match on it:

    case result {
      Ok(value) -> todo
      Error(reason) -> todo
    }
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## Optional dependencies are now optional

Gleam uses Hex, the package managers for the BEAM ecosystem. It has a concept of
optional packages, allowing a package to specify a version constraint on
another package without causing it to be added to the dependency graph. This
constraint is only used if a third package also depends on that package.
This isn't very useful in Gleam, but Elixir commonly makes use of via its
compile time metaprogramming system.

Until now the Gleam build tool would treat these optional dependencies as
regular dependencies, always downloading them. With this release it now handles
them correctly and will ignore packages where all constraints are marked as
optional. This will reduce compile times for some Gleam projects that depend on
Elixir packages.

Thank you [Gustavo Inacio](https://github.com/gusinacio)!

## Optimised bit arrays

Gleam inherits the bit-syntax from Erlang, which is a literal syntax for
constructing and parsing binary data. It can be a very nice alternative to
bitwise operators commonly used in other language, and makes Gleam a pleasant
language for working with binary data.

Performance wizard [Richard Viney](https://github.com/richard-viney) has been
hard at work optimising the implementation on JavaScript, and has made their
creation between 2 and 40 times faster, depending on the input data. Thank you
Richard! Very impressive work!

## Unsafe number warnings

When compiling to JavaScript Gleam uses JavaScript's number types, to ensure
good interop with JavaScript code and the JavaScript platform as a whole. This
means that it inherits some shortcomings that do not exist on the BEAM, namely a
maximum and minimum safe number size.

When targeting JavaScript the compiler now emits a warning for integer literals
and constants that lie outside JavaScript's safe integer range, letting the
programmer know that their code may have unexpected behaviour due to lost
precision.

```txt
warning: Int is outside the safe range on JavaScript
  ┌─ /Users/richard/Desktop/int_test/src/int_test.gleam:1:15
  │
1 │ pub const i = 9_007_199_254_740_992
  │               ^^^^^^^^^^^^^^^^^^^^^ This is not a safe integer on JavaScript

This integer value is too large to be represented accurately by
JavaScript's number type. To avoid this warning integer values must be in
the range -(2^53 - 1) - (2^53 - 1).

See JavaScript's Number.MAX_SAFE_INTEGER and Number.MIN_SAFE_INTEGER
properties for more information.
```

Thank you again [Richard Viney](https://github.com/richard-viney)!

## (un)qualification code actions

When using types and value from other Gleam modules the programmer has the
choice as to whether to use them in a qualified or an unqualified fashion.

```gleam
import gleam/option.{type Option}

pub fn item() -> Option(Int) { // <- unqualified
  option.Some(9) // <- qualified
}
```

Most commonly Gleam programmers will choose to qualify all functions, and to
unqualify types that share the same name as their containing module.

Changing from one to the other is trivial, but also boring and time-consuming
for types and values that are used many times in a module. The language server
now has two code actions to automate this annoyance away!

Within your editor place your cursor on an instance of the type or value you
wish to change, select the "qualify" or "unqualify" code action, and the
language server will instantly update all the instances of that type or value in
the module along with the required import statement.

Thank you [Jiangda Wang](https://github.com/Frank-III) for this code action!

## JavaScript project creation

Gleam can compile to JavaScript as well as to Erlang. If you know your project
is going to target JavaScript primarily you can now use `gleam new myapp
--template javascript` to create a new project that is already configured for
JavaScript, saving you adding the `target = "javascript"` to your `gleam.toml`.

Thank you [Mohammed Khouni](https://github.com/Tar-Tarus) for this!

### And the rest

And thank you to the bug fixers and error message improvers
[Antonio Iaccarino](https://github.com/eingin),
[Giacomo Cavalieri](https://github.com/giacomocavalieri),
[Jiangda Wang](https://github.com/frank-iii),
[Markus Pettersson](https://github.com/MarkusPettersson98/),
[PgBiel](https://github.com/PgBiel),
[Richard Viney](https://github.com/richard-viney),
[Surya Rose](https://github.com/GearsDatapacks),
[yoshi](https://github.com/joshi-monster), and
[Zak Farmer](https://github.com/ZakFarmer)!


For full details of the many fixes and improvements they've implemented see [the
changelog][changelog].

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.6.md


# A call for support

Gleam is not owned by a corporation; instead it is entirely supported by
sponsors, most of which contribute between $5 and $20 USD per month. I currently
earn less than the median salary tech lead salary for London UK, the city in
which I live, and Gleam is my sole source of income.

If you appreciate Gleam, please [support the project on GitHub
Sponsors][sponsor] with any amount you comfortably can. I am endlessly grateful
for your support, thank you so much.

<a class="sponsor-level0" href="https://github.com/sponsors/lpil" rel="noopener" target="_blank">
  <img src="/images/community/github.svg" alt="GitHub Sponsors" style="filter: invert(1)"/>
</a>

[sponsor]: https://github.com/sponsors/lpil

<ul class="top-sponsors">
  <li>
    <a class="sponsor-level1" href="https://lambdaclass.com/" rel="noopener" target="_blank" >
      <img src="/images/sponsors/lambda-class-white.png" alt="Lambda Class">
    </a>
  </li>
</ul>

- [00bpa](https://github.com/00bpa)
- [Aaron Gunderson](https://github.com/agundy)
- [Abdulrhman Alkhodiry](https://github.com/zeroows)
- [ad-ops](https://github.com/ad-ops)
- [Adam Brodzinski](https://github.com/AdamBrodzinski)
- [Adam Johnston](https://github.com/adjohnston)
- [Adam Wyłuda](https://github.com/adam-wyluda)
- [Adi Iyengar](https://github.com/thebugcatcher)
- [Adi Salimgereyev](https://github.com/abs0luty)
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
- [andrew](https://github.com/ajkachnic)
- [Andrii Shupta](https://github.com/andriishupta)
- [Andris Horváth](https://github.com/horvathandris)
- [Antharuu](https://github.com/antharuu)
- [Anthony Khong](https://github.com/anthony-khong)
- [Anthony Maxwell](https://github.com/Illbjorn)
- [Anthony Scotti](https://github.com/amscotti)
- [Antonio](https://github.com/Eingin)
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
- [Benjamin Thomas](https://github.com/bentomas)
- [Berkan Teber](https://github.com/berkanteber)
- [bgw](https://github.com/bgwdotdev)
- [Bill Nunney](https://github.com/bigtallbill)
- [Bjarte Aarmo Lund](https://github.com/bjartelund)
- [BlockListed](https://github.com/BlockListed)
- [Brad Mehder](https://github.com/bmehder)
- [brettkolodny](https://github.com/brettkolodny)
- [Brian Dawn](https://github.com/brian-dawn)
- [Brian Glusman](https://github.com/bglusman)
- [Bruno Michel](https://github.com/nono)
- [bucsi](https://github.com/bucsi)
- [Cameron Presley](https://github.com/cameronpresley)
- [Carlo Gilmar](https://github.com/carlogilmar)
- [Carlo Munguia](https://github.com/carlomunguia)
- [Carlos Saltos](https://github.com/csaltos)
- [Carlos Silva](https://github.com/carlosqsilva)
- [Chad Selph](https://github.com/chadselph)
- [Charlie Duong](https://github.com/ctdio)
- [Charlie Govea](https://github.com/charlie-n01r)
- [Chaz Watkins](https://github.com/chazwatkins)
- [Chew Choon Keat](https://github.com/choonkeat)
- [Chris Donnelly](https://github.com/ceedon)
- [Chris Haynes](https://github.com/chaynes3)
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
- [Claudio](https://github.com/ReXase27)
- [CodeCrafters](https://github.com/codecrafters-io)
- [Coder](https://github.com/coder)
- [Cole Lawrence](https://github.com/colelawrence)
- [Colin](https://github.com/insanitybit)
- [Comamoca](https://github.com/Comamoca)
- [Constantin (Cleo) Winkler](https://github.com/Lucostus)
- [Cristiano Carvalho](https://github.com/ccarvalho-eng)
- [Daigo Shitara](https://github.com/sdaigo)
- [Damir Vandic](https://github.com/dvic)
- [Dan](https://github.com/dansholds)
- [Dan Dresselhaus](https://github.com/ddresselhaus)
- [Danielle Maywood](https://github.com/DanielleMaywood)
- [Danny Arnold](https://github.com/pinnet)
- [Danny Martini](https://github.com/despairblue)
- [Dave Lucia](https://github.com/davydog187)
- [David Bernheisel](https://github.com/dbernheisel)
- [David Cornu](https://github.com/davidcornu)
- [David Sancho](https://github.com/davesnx)
- [Dennis Dang](https://github.com/dangdennis)
- [dennistruemper](https://github.com/dennistruemper)
- [Dillon Mulroy](https://github.com/dmmulroy)
- [Dima Utkin](https://github.com/gothy)
- [Dimos Michailidis](https://github.com/mrdimosthenis)
- [Dmitry Poroh](https://github.com/poroh)
- [Donnie Flood](https://github.com/floodfx)
- [Drew Olson](https://github.com/drewolson)
- [ds2600](https://github.com/ds2600)
- [ducdetronquito](https://github.com/ducdetronquito)
- [Dylan Carlson](https://github.com/gdcrisp)
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
- [Gears](https://github.com/GearsDatapacks)
- [Geir Arne Hjelle](https://github.com/gahjelle)
- [Georg H. Ekeberg](https://github.com/hagenek)
- [George](https://github.com/george-grec)
- [ggobbe](https://github.com/ggobbe)
- [Giacomo Cavalieri](https://github.com/giacomocaval
- [Giovanni Kock Bonetti](https://github.com/giovannibonetti)
- [Graeme Coupar](https://github.com/obmarg)
- [grotto](https://github.com/grottohub)
- [Guilherme de Maio](https://github.com/nirev)
- [Guillaume Heu](https://github.com/guillheu)
- [Guillaume Hivert](https://github.com/ghivert)
- [Gustavo Inacio](https://github.com/gusinacio)
- [Hamir Mahal](https://github.com/hamirmahal)
- [Hammad Javed](https://github.com/hammad-r-javed)
- [Hannes Nevalainen](https://github.com/kwando)
- [Hannes Schnaitter](https://github.com/ildorn)
- [Hans Fjällemark](https://github.com/hfjallemark)
- [Hans Raaf](https://github.com/oderwat)
- [Hayes Hundman](https://github.com/jhundman)
- [Hayleigh Thompson](https://github.com/hayleigh-dot-dev)
- [Hazel Bachrach](https://github.com/hibachrach)
- [Henning Dahlheim](https://github.com/hdahlheim)
- [Henry Firth](https://github.com/h14h)
- [Henry Warren](https://github.com/henrysdev)
- [Heyang Zhou](https://github.com/losfair)
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
- [Ivar Vong](https://github.com/ivarvong)
- [J. Rinaldi](https://github.com/m-rinaldi)
- [Jacob Lamb](https://github.com/jacobdalamb)
- [Jake Cleary](https://github.com/jakecleary)
- [James Birtles](https://github.com/jamesbirtles)
- [James MacAulay](https://github.com/jamesmacaulay)
- [Jan Skriver Sørensen](https://github.com/monzool)
- [Jason Sipula](https://github.com/SnakeDoc)
- [Javien Lee](https://github.com/SnowMarble)
- [Jean-Luc Geering](https://github.com/jlgeering)
- [Jen Stehlik](https://github.com/okkdev)
- [Jenkin Schibel](https://github.com/dukeofcool199)
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
- [Jonathan Arnett](https://github.com/J3RN)
- [jooaf](https://github.com/jooaf)
- [Joseph Lozano](https://github.com/joseph-lozano)
- [Joseph T. Lyons](https://github.com/JosephTLyons)
- [Joshua Steele](https://github.com/joshocalico)
- [Julian Lukwata](https://liberapay.com/d2quadra/)
- [Julian Schurhammer](https://github.com/schurhammer)
- [Justin Lubin](https://github.com/justinlubin)
- [Karl](https://github.com/karlM-BM)
- [Kemp Brinson](https://github.com/jkbrinso)
- [Kero van Gelder](https://github.com/keroami)
- [Kevin Schweikert](https://github.com/kevinschweikert)
- [kodumbeats](https://github.com/kodumbeats)
- [Kramer Hampton](https://github.com/hamptokr)
- [krautkai](https://github.com/krautkai)
- [Kritsada Sunthornwutthikrai](https://github.com/Bearfinn)
- [Kryštof Řezáč](https://github.com/krystofrezac)
- [Krzysztof G.](https://github.com/krzysztofgb)
- [Laurent Arnoud](https://github.com/spk)
- [Leandro Ostera](https://github.com/leostera)
- [Lee Jarvis](https://github.com/leejarvis)
- [Leon Qadirie](https://github.com/leonqadirie)
- [Leonardo Donelli](https://github.com/LeartS)
- [lidashuang](https://github.com/defp)
- [LighghtEeloo](https://github.com/LighghtEeloo)
- [Lily Rose](https://github.com/LilyRose2798)
- [Loïc Tosser](https://github.com/wowi42)
- [Lucas Pellegrinelli](https://github.com/lucaspelle
- [Lukas Bjarre](https://github.com/lbjarre)
- [Lukas Meihsner](https://github.com/lukasmeihsner)
- [Luke Amdor](https://github.com/lamdor)
- [Luna](https://github.com/2kool4idkwhat)
- [Manuel Rubio](https://github.com/manuel-rubio)
- [Marco A L Barbosa](https://github.com/malbarbo)
- [Marcus André](https://github.com/marcusandre)
- [Marcøs](https://github.com/ideaMarcos)
- [Mariano Uvalle](https://github.com/AYM1607)
- [Marius Kalvø](https://github.com/mariuskalvo)
- [Mark Holmes](https://github.com/markholmes)
- [Mark Markaryan](https://github.com/markmark206)
- [Markus Pettersson](https://github.com/MarkusPettersson98)
- [Markéta Lisová](https://github.com/datayja)
- [Marshall Bowers](https://github.com/maxdeviant)
- [Martin Janiczek](https://github.com/Janiczek)
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
- [max-tern](https://github.com/max-tern)
- [metame](https://github.com/metame)
- [Michael Duffy](https://github.com/stunthamster)
- [Michael Jones](https://github.com/michaeljones)
- [Michael Mazurczak](https://github.com/monocursive)
- [Mikael Karlsson](https://github.com/karlsson)
- [Mike](https://liberapay.com/Daybowbow/)
- [Mike Nyola](https://github.com/nyolamike)
- [Mike Roach](https://github.com/mroach)
- [Mikey J](https://liberapay.com/mikej/)
- [Mikko Ahlroth](https://github.com/Nicd)
- [MoeDev](https://github.com/MoeDevelops)
- [Moritz Böhme](https://github.com/MoritzBoehme)
- [mpatajac](https://github.com/mpatajac)
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
- [Ninaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa](https://github.com/l1f)
- [NineFX](http://www.ninefx.com)
- [noam sauer-utley](https://github.com/noamsauerutley)
- [Nomio](https://github.com/nomio)
- [Norbert Szydlik](https://github.com/NorbertSzydlik)
- [Ocean](https://github.com/oceanlewis)
- [OldhamMade](https://github.com/OldhamMade)
- [Oliver Medhurst](https://github.com/CanadaHonk)
- [Oliver Tosky](https://github.com/otosky)
- [optizio](https://github.com/optizio)
- [Osman Cea](https://github.com/daslaf)
- [PastMoments](https://github.com/PastMoments)
- [Patrick Wheeler](https://github.com/Davorak)
- [Paul Gideon Dann](https://github.com/giddie)
- [Paul Guse](https://github.com/pguse)
- [Pawel Biernacki](https://github.com/biernacki)
- [Pedro Correa](https://github.com/Tulkdan)
- [Pete Jodo](https://github.com/petejodo)
- [Peter Rice](https://github.com/pvsr)
- [Peter Saxton](https://github.com/CrowdHailer)
- [PgBiel](https://github.com/PgBiel)
- [Philip Giuliani](https://github.com/philipgiuliani)
- [Philpax](https://github.com/philpax)
- [Pierrot](https://github.com/pierrot-lc)
- [Piotr Szlachciak](https://github.com/sz-piotr)
- [Qdentity](https://github.com/qdentity)
- [qingliangcn](https://github.com/qingliangcn)
- [Race Williams](https://github.com/raquentin)
- [Rasmus](https://github.com/stoft)
- [Ray](https://github.com/ray-delossantos)
- [Raúl Chouza ](https://github.com/chouzar)
- [re.natillas](https://github.com/renatillas)
- [Rebecca Valentine](https://github.com/BekaValentine)
- [Redmar Kerkhoff](https://github.com/redmar)
- [Reilly Tucker Siemens](https://github.com/reillysiemens)
- [Renato Massaro](https://github.com/renatomassaro)
- [Renovator](https://github.com/renovatorruler)
- [Richard Viney](https://github.com/richard-viney)
- [Rico Leuthold](https://github.com/rico)
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
- [Sami Fouad](https://github.com/samifouad)
- [Sammy Isseyegh](https://github.com/bkspace)
- [sanabel-al-firdaws](https://github.com/sanabel-al-firdaws)
- [Santi Lertsumran](https://github.com/mrgleam)
- [Savva](https://github.com/castletaste)
- [Saša Jurić](https://github.com/sasa1977)
- [Scott Trinh](https://github.com/scotttrinh)
- [Scott Wey](https://github.com/scottwey)
- [Sean Jensen-Grey](https://github.com/seanjensengrey)
- [Sean Roberts](https://github.com/SeanRoberts)
- [Sebastian Porto](https://github.com/sporto)
- [sekun](https://github.com/sekunho)
- [Seve Salazar](https://github.com/tehprofessor)
- [Shane Poppleton](https://github.com/codemonkey76)
- [Shuqian Hon](https://github.com/honsq90)
- [Simone Vittori](https://github.com/simonewebdesign)
- [star-szr](https://github.com/star-szr)
- [Stefan](https://github.com/bytesource)
- [Stephen Belanger](https://github.com/Qard)
- [Steve Powers](https://github.com/stvpwrs)
- [Steve Toro](https://github.com/stevetoro)
- [Strandinator](https://github.com/Strandinator)
- [Sunil Pai](https://github.com/threepointone)
- [syhner](https://github.com/syhner)
- [Sławomir Ehlert](https://github.com/slafs)
- [Tar-Tarus](https://github.com/Tar-Tarus)
- [Theo Harris](https://github.com/Theosaurus-Rex)
- [TheShmill](https://github.com/TheShmill)
- [Thomas](https://github.com/thomaswhyyou)
- [Thomas Coopman](https://github.com/tcoopman)
- [Thomas Ernst](https://github.com/ernstla)
- [Tim Brown](https://github.com/tmbrwn)
- [Timo Sulg](https://github.com/timgluz)
- [Tom Calloway](https://github.com/modellurgist)
- [Tom Schuster](https://github.com/tomjschuster)
- [Tomasz Kowal](https://github.com/tomekowal)
- [tommaisey](https://github.com/tommaisey)
- [Tristan de Cacqueray](https://github.com/TristanCacqueray)
- [Tristan Sloughter](https://github.com/tsloughter)
- [upsidedowncake](https://github.com/upsidedownsweetfood)
- [Valerio Viperino](https://github.com/vvzen)
- [Vic Valenzuela](https://github.com/sandsower)
- [Victor Rodrigues](https://github.com/rodrigues)
- [Viv Verner](https://github.com/PerpetualPossum)
- [Volker Rabe](https://github.com/yelps)
- [Weizheng Liu](https://github.com/weizhliu)
- [Wesley Moore](https://github.com/wezm)
- [Willyboar](https://github.com/Willyboar)
- [Wilson Silva](https://github.com/wilsonsilva)
- [Xucong Zhan](https://github.com/HymanZHAN)
- [Yamen Sader](https://github.com/yamen)
- [Yasuo Higano](https://github.com/Yasuo-Higano)
- [yoshi~ ](https://github.com/joshi-monster)
- [Zak Farmer](https://github.com/ZakFarmer)
- [Zsombor Gasparin](https://github.com/gasparinzsombor)
- [~1847917](https://liberapay.com/~1847917/)
- [Éber Freitas Dias](https://github.com/eberfreitas)

Thanks for reading, I hope you have fun with Gleam! 💜

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>
