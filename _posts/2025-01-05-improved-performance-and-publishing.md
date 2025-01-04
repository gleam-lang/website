---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Improved performance and publishing
subtitle: Gleam v1.7.0 released
tags:
  - Release
---

Gleam is a type-safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.7.0][release] has been published, featuring
an array of wonderful improvements. Let's take a look!

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.7.0

## Faster record updates

Gleam is a language with immutable data, and it has a syntax for creating a new
record from an old one with some updated fields.

```gleam
/// Create a new version of the user with `admin` set to true.
pub fn make_admin(person: User) {
  User(..person, admin: True)
}
```

If you're familiar with JavaScript this is similar to the object spread update
syntax, and similarly it is fast, only copying the references to the fields,
not the data itself.

The code that the Gleam compiler would generate would also be similar to how
JavaScript's update works, using a small amount of dynamic code at runtime to
construct the new record with the new fields. This runtime conditional logic
had a small performance cost at runtime.

The compiler now instead _monomorphises_ record updates, meaning it generates
exactly the most efficient code to construct the new record on a case-by-case
basis, removing the runtime conditional logic and its associated cost entirely.

The optimisation is for both the Erlang and the JavaScript targets, has no
additional compile speed cost or increase in code size, so it's an improvement
in every way!

Another benefit of record update monomorphisation is that you can now change
the parameterised types of a generic record with the update syntax.

```gleam
pub type Named(element) {
  Named(name: String, value: element)
}

pub fn replace_value(data: Named(a), replacement: b) -> Named(b) {
  Named(..data, value: replacement)
}
```

Previously this would not compile as the type parameter changed, and the
compiler wasn't able to infer it was always done safely. Now it can tell, so
this compiles!

Thank you [yoshi](https://github.com/joshi-monster) for this excellent change!

## Generate decoder code action

Gleam has a very robust type system, it won't let you unsafely cast values
between different types. This results in a programming experience where the
compiler and language server can offer lots help to the programmer, especially
in unfamiliar or large codebases.

One drawback of this sound type system is that converting untyped input from
the outside world into data of known types requires some additional code which
would not be required in unsound systems. This decoder code can be unfamiliar
and confusing to those new to Gleam, and in simple cases it can seem a chore.

To aid with this the Gleam language server now includes code action to
generate a dynamic decoder for a custom type. For example, if you have this code:

```gleam
pub type Person {
  Person(name: String, age: Int)
}
```

If you place your cursor on the type header and select the code action in your,
then it'll be updated to this:

```gleam
import gleam/dynamic/decode

pub type Person {
  Person(name: String, age: Int)
}

fn person_decoder() -> decode.Decoder(Person) {
  use name <- decode.field("name", decode.string)
  use age <- decode.field("age", decode.int)
  decode.success(Person(name:, age:))
}
```

Thank you [Surya Rose](https://github.com/GearsDatapacks)! I know this will be
a very popular addition.

## More secure package manager credential handling

Gleam is part of the Erlang ecosystem, so it uses the [Hex package manager](https://hex.pm/).
To publish a package to Hex the build tool needs the credentials for your Hex
account, and you would type them into the command line to supply them.
We make this as secure as possible, but there's always some risk when typing in
credentials. No amount of in-computer security can save you from someone
sitting behind you, watching your fingers on the keyboard.

Gleam now only asks for your Hex credentials once, and uses that to create a
long-lived API token, which will be stored on your filesystem and encrypted
using a local password of your choosing. For all future interactions with Hex
Gleam will ask for the local password, use that to decrypt the API key, and
then use it to authenticate with the Hex APIs.

With this if someone manages to learn the password you use to Hex they would
not be able to do anything with it unless they can also get access to your
computer and the encrypted file stored on it.

## Package namespace checking

The Erlang virtual machine has a single namespace for modules. It does not have
isolation of modules between different packages, so if two packages define
modules with the same name they can collide and cause a build failure or
other undesired behaviour.

To avoid this packages place their modules within their own namespace. For
example, if I am writing a package named `pumpkin` I would place my modules
within the `src/pumpkin/` directory.

Sometimes people from other ecosystems with per-package isolation may not
understand this convention and place all their code in the top-level namespace,
using generic names, which results in problems for any users of their package. To
avoid this the `gleam publish` command will now check for top-level namespace
pollution, explaining the problem and asking for confirmation if it is present.

Thank you [Aleksei Gurianov](https://github.com/guria)!

## Core team package name checking

The Hex package manager system doesn't have namespaces, so we can't publish
packages maintained by the Gleam core team as `@gleam/*` or such. Instead Hex
users have to rely on adding a prefix to the names of their packages, and in
the Gleam core team we use the prefix `gleam_`.

These prefixes are unchecked, so one can use anyone else's prefix without
issue. This is a problem for us as people occasionally publish packages using
the core team's prefix, and then other people get confused as to why this
seemingly official package is of a low quality. To try and remedy this Gleam
will ask for confirmation when a package is published with the `gleam_` prefix.
Unfortunately this was not enough and another unofficial package was
accidentally published, so Gleam now asks for a much longer confirmation to be
typed in, to force the publisher to read the message.

## Semantic versioning encouragement

Sometimes people like to publish packages that are unfinished or unsuitable for
use by others, publishing them as version 0.\*. Other people publish code that
is good to use, but shy away from semantic versioning and publish them as
v0.\*. In both of these cases the users of these packages have an inferior
experience, unable to take advantage of the benefits that semantic versioning
is designed to bring, which can lead to irritating build errors.

Gleam will now ask for confirmation if a package is published with a v0.\*
version, as it does not respect semantic versioning. The fewer zero-version
packages published the better experience users of the package ecosystem will
have.

## Variant deprecation

In Gleam one can deprecate functions and types using the `@deprecated`
attribute, which causes the compiler to emit a warning if they are used. With
this release it is also possible to deprecate individual custom type variants
too!

```gleam
pub type HashAlgorithm {
  @deprecated("Please upgrade to another algorithm")
  Md5
  Sha224
  Sha512
}

pub fn hash_password(input: String) -> String {
  hash(input:, algorithm: Md5) // Warning: Deprecated value used
}
```

Thank you [Iesha](https://github.com/wilbert-mad) for this!

## Canonical documentation links

When packages are published to Hex Gleam will also generate HTML documentation
and upload it to [HexDocs](https://hexdocs.pm/), the documentation hosting site
for the BEAM ecosystem.

Currently we have a problem where Google is returning documentation for very
old versions of Gleam libraries instead of the latest version, which can result
in confusion as people try to use functions that no longer exist, etc. To
prevent this from happening with future versions Gleam now adds a canonical
link when publishing, which should help search engines return the desired version.
In the near future we will write a tool that will update historical
documentation to add these links too.

Thank you [Dave Lage](https://github.com/rockerBOO) for this improvement!

## Custom messages for pattern assertions

Gleam's `let assert` allows you to pattern match with a _partial pattern_, that
is: one that doesn't match all possible values a type could be. When the value
does not match the program it crashes the program, which is most often used in
tests or in quick scripts or prototypes where one doesn't care to implement
proper error handling.

With this version the `as` syntax can be used to add a custom error message for
the crash, which can be helpful for debugging when the unexpected does occur.

```gleam
let assert Ok(regex) = regex.compile("ab?c+") as "This regex is always valid"
```

Thank you [Surya Rose](https://github.com/GearsDatapacks)!

## JavaScript bit array compile time evaluation

Gleam's bit array literal syntax is a convenient way to build up and to pattern
match on binary data. When targeting JavaScript the compiler now generates
faster and smaller code for int values in these bit array expressions and
patterns by evaluating them at compile time where possible.

Thank you [Richard Viney](https://github.com/richard-viney) for this!

## JavaScript bit array slicing optimisation

Continuing on from his previous bit array optimisation, [Richard Viney](https://github.com/richard-viney)
has made taking a sub-slice of a bit array a constant time operation on
JavaScript, to match the behaviour on the Erlang target. This is a significant
improvement to performance.

Thank you Richard! Our bit array magician!

## Empty blocks are valid!

In Gleam one can write an empty function body, and it is considered a
not-yet-implemented function, emitting a warning when compiled. This is useful
for when writing new code, where you want to check some things about your
program but have not yet finished writing it entirely.

```gleam
pub fn wibble() {} // warning: unimplemented function
```

You can now also do the same for blocks, leaving them empty will result in a
compile warning but permit you to compile the rest of your code.

```gleam
pub fn wibble() {
  let x = {
     // warning: incomplete block
  }
  io.println(x)
}
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## External modules in subdirectories

Gleam has excellent interop with Erlang, Elixir, JavaScript, and other
languages running on its target platforms. Modules in these languages can be
added to your project and imported using Gleam's [external functions](https://tour.gleam.run/advanced-features/externals/)
feature.

Previously these external modules had to be at the top level of the `src/` or
`test/` directories, but now they can reside within subdirectories of them too.

Thank you [PgBiel](https://github.com/PgBiel) for this long-awaited feature!

## Installation hints

To run Gleam on the BEAM an Erlang installation is required, and to run it on
JavaScript a suitable runtime such as NodeJS is required. To initialise a
repository git is required. To compile Elixir code Elixir must be installed.
You get the idea- to use various external tools they need to be installed.

If there's a particular recommended way to install a missing component for your
operating system the error message for its absence will now direct you to
install it that way.

```
error: Shell command failed

The program `elixir` was not found. Is it installed?

You can install Elixir via homebrew: brew install elixir

Documentation for installing Elixir can be viewed here:
https://elixir-lang.org/install.html
```

Thank you [wheatfox](https://github.com/enkerewpo) for this helpful improvement!

## Faster Erlang dependency compilation

You can add packages written in Erlang or Elixir to your Gleam projects, and
the Gleam build tool will compile them for you. To compile Erlang packages
rebar3, the Erlang build tool, is used.

Gleam now sets the `REBAR_SKIP_PROJECT_PLUGINS` environment variable
when using rebar3. With future versions of rebar3 this will cause it to skip
project plugins, significantly reducing the amount of code it'll need to
download and compile, improving compile times. 

Thank you to [Tristan Sloughter](https://github.com/tsloughter) for this
contribution to both Gleam and rebar3! Elixir's Mix build tool will also
benefit from this new rebar3 feature.

## Sugar and desugar `use` expressions

Gleam's `use` expression is a much loved and very useful bit of syntactic
sugar, good for making nested higher-order-functions easy to work with. It is
by-far Gleam's most unusual feature, so it can take a little time to get a good
understanding of it.

To help with this, and to make refactoring easier, Jak has added two new code
actions to the language server, to convert to and from the `use` expression
syntax and the equivalent using the regular function call syntax.

Here's the same code in each syntax, so you can get an idea of what the code
actions will convert to and from for you.

```gleam
pub fn main() {
  use profile <- result.try(fetch_profile(user))
  render_welcome(user, profile)
}
```

```gleam
pub fn main() {
  result.try(fetch_profile(user), fn(profile) {
    render_welcome(user, profile)
  })
}
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for these!

## Yet more language server hover information

[Surya Rose](https://github.com/GearsDatapacks) has been adding more hover
information to the language server. If you hover over patterns or function
labels in your editor then type and documentation information will be shown.
Thank you Surya!

## Inexhaustive `let` to `case` code action

Using a partial pattern that does not match all possible values with a `let`
binding is a compile error in Gleam.

```gleam
pub fn unwrap_result(result: Result(a, b)) -> a {
  let Ok(inner) = result // error: inexhaustive
  inner
}
```

The language server now suggests a code action to convert this `let` into a
`case` expression with the missing patterns added, so you can complete the
code.

```gleam
pub fn unwrap_result(result: Result(a, b)) -> a {
  let inner = case result {
    Ok(inner) -> inner
    Error(_) -> todo
  }
  inner
}
```

Thanks again [Surya Rose](https://github.com/GearsDatapacks)!

## Extract variable code action

The language server now provides an action to extract a value into a variable.
Given this code:

```gleam
pub fn main() {
  list.each(["Hello, Mike!", "Hello, Joe!"], io.println)
}
```

If you place your cursor on the list and trigger the code action in your editor
the code will be updated to this:

```gleam
pub fn main() {
  let value = ["Hello, Mike!", "Hello, Joe!"]
  list.each(value, io.println)
}
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this!

## Expand function capture code action

Gleam has a short-hand syntax for a function that takes a single argument and
passes it to another function, along with some other arguments. Here you can
see it being used with the `int.add` function to create a function that always
adds 11.

```gleam
pub fn main() {
  let add_eleven = int.add(_, 11)
  list.map([1, 2, 3], add_eleven)
}
```

Triggering the code action result in the function-capture being expanded to the
full anonymous function syntax:

```gleam
pub fn main() {
  list.map([1, 2, 3], fn(value) { int.add(value, 11) })
}
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for the
final code action of the release!

### And the rest

And thank you to the bug fixers and error message improvers
[Giacomo Cavalieri](https://github.com/giacomocavalieri),
[Ivan Ermakov](https://github.com/ivanjermakov),
[Jiangda Wang](https://github.com/Frank-III),
[John Strunk](https://github.com/jrstrunk),
[PgBiel](https://github.com/PgBiel),
[Richard Viney](https://github.com/richard-viney),
[Sakari Bergen](https://github.com/sbergen),
[Surya Rose](https://github.com/GearsDatapacks), and
[yoshi](https://github.com/joshi-monster)


For full details of the many fixes and improvements they've implemented see [the
changelog][changelog].

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.7.md


# It's my birthday 🎁

Today is my birthday! If you'd like to give me a gift please consider
[supporting Gleam on GitHub Sponsors][sponsor].

Gleam is not owned by a corporation; instead it is entirely supported by
sponsors, most of which contribute between $5 and $20 USD per month, and Gleam
is my sole source of income.

[Giacomo Cavalieri](https://github.com/sponsors/giacomocavalieri) is also
deserving of your support. He has been doing amazing work on Gleam without any
pay for nearly two years, but now he has GitHub sponsors, so show him some love!

<a class="sponsor-level0" href="https://github.com/sponsors/lpil" rel="noopener" target="_blank">
  <img src="/images/community/github.svg" alt="GitHub Sponsors" style="filter: invert(1)"/>
</a>

[sponsor]: https://github.com/sponsors/lpil

Thank you to all our sponsors, especially our top sponsor: Lambda.

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
- [Benjamin Thomas](https://github.com/bentomas)
- [bgw](https://github.com/bgwdotdev)
- [Bill Nunney](https://github.com/bigtallbill)
- [Bjarte Aarmo Lund](https://github.com/bjartelund)
- [Brad Mehder](https://github.com/bmehder)
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
- [Chaz Watkins](https://github.com/chazwatkins)
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
- [CodeCrafters](https://github.com/codecrafters-io)
- [Coder](https://github.com/coder)
- [Cole Lawrence](https://github.com/colelawrence)
- [Colin](https://github.com/insanitybit)
- [Comamoca](https://github.com/Comamoca)
- [Constantin (Cleo) Winkler](https://github.com/Lucostus)
- [Corentin J.](https://github.com/jcorentin)
- [Cristiano Carvalho](https://github.com/ccarvalho-eng)
- [Daigo Shitara](https://github.com/sdaigo)
- [Damir Vandic](https://github.com/dvic)
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
- [Diemo Gebhardt](https://github.com/diemogebhardt)
- [Dillon Mulroy](https://github.com/dmmulroy)
- [Dima Utkin](https://github.com/gothy)
- [Dmitry Poroh](https://github.com/poroh)
- [DoctorCobweb](https://github.com/DoctorCobweb)
- [Donnie Flood](https://github.com/floodfx)
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
- [Ganesan Janarthanam (Jana)](https://github.com/janag)
- [Geir Arne Hjelle](https://github.com/gahjelle)
- [Georg H. Ekeberg](https://github.com/hagenek)
- [Georg Hartmann](https://github.com/brasilikum)
- [George](https://github.com/george-grec)
- [ggobbe](https://github.com/ggobbe)
- [Giacomo Cavalieri](https://github.com/giacomocavalieri)
- [Giovanni Kock Bonetti](https://github.com/giovannibonetti)
- [Graeme Coupar](https://github.com/obmarg)
- [grotto](https://github.com/grottohub)
- [Guilherme de Maio](https://github.com/nirev)
- [Guillaume Heu](https://github.com/guillheu)
- [Guillaume Hivert](https://github.com/ghivert)
- [Hammad Javed](https://github.com/hammad-r-javed)
- [Hannes Nevalainen](https://github.com/kwando)
- [Hannes Schnaitter](https://github.com/ildorn)
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
- [Jan Pieper](https://github.com/janpieper)
- [Jan Skriver Sørensen](https://github.com/monzool)
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
- [Jojor](https://github.com/xjojorx)
- [Jon Lambert](https://github.com/jonlambert)
- [Jonas E. P](https://github.com/igern)
- [Jonas Hedman Engström](https://github.com/JonasHedEng)
- [jooaf](https://github.com/jooaf)
- [Joseph Lozano](https://github.com/joseph-lozano)
- [Joshua Steele](https://github.com/joshocalico)
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
- [LighghtEeloo](https://github.com/LighghtEeloo)
- [Lily Rose](https://github.com/LilyRose2798)
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
- [Markéta Lisová](https://github.com/datayja)
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
- [METATEXX GmbH](https://github.com/metatexx)
- [Metin Emiroğlu](https://github.com/amiroff)
- [Michael Duffy](https://github.com/stunthamster)
- [Michael Jones](https://github.com/michaeljones)
- [Michael Mazurczak](https://github.com/monocursive)
- [Michał Łępicki](https://github.com/michallepicki)
- [Mikael Karlsson](https://github.com/karlsson)
- [Mike](https://liberapay.com/Daybowbow/)
- [Mike Roach](https://github.com/mroach)
- [Mikey J](https://liberapay.com/mikej/)
- [MoeDev](https://github.com/MoeDevelops)
- [Moritz Böhme](https://github.com/MoritzBoehme)
- [MzRyuKa](https://github.com/rykawamu)
- [n8n - Workflow Automation](https://github.com/n8nio)
- [Natanael Sirqueira](https://github.com/natanaelsirqueira)
- [Nathaniel Knight](https://github.com/nathanielknight)
- [Nayuki](https://github.com/Kuuuuuuuu)
- [NFIBrokerage](https://github.com/NFIBrokerage)
- [Nicholas Moen](https://github.com/arcanemachine)
- [Nick Chapman](https://github.com/nchapman)
- [Nick Reynolds](https://github.com/ndreynolds)
- [Nicklas Sindlev Andersen](https://github.com/NicklasXYZ)
- [NicoVIII](https://github.com/NicoVIII)
- [Niket Shah](https://github.com/mrniket)
- [Ninaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa](https://github.com/ninanomenon)
- [NineFX](http://www.ninefx.com)
- [Nomio](https://github.com/nomio)
- [Ocean](https://github.com/oceanlewis)
- [Olaf Sebelin](https://github.com/osebelin)
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
- [Philpax](https://github.com/philpax)
- [Pierrot](https://github.com/pierrot-lc)
- [Piotr Szlachciak](https://github.com/sz-piotr)
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
- [Sam Aaron](https://github.com/samaaron)
- [Sam Zanca](https://github.com/metruzanca)
- [sambit](https://github.com/soulsam480)
- [Sami Fouad](https://github.com/samifouad)
- [Sammy Isseyegh](https://github.com/bkspace)
- [Savva](https://github.com/castletaste)
- [Saša Jurić](https://github.com/sasa1977)
- [Scott Trinh](https://github.com/scotttrinh)
- [Scott Weber](https://github.com/smweber)
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
- [Stefan Hagen](https://github.com/sthagen)
- [Stephen Belanger](https://github.com/Qard)
- [Steve Powers](https://github.com/stvpwrs)
- [Strandinator](https://github.com/Strandinator)
- [Sunil Pai](https://github.com/threepointone)
- [Sławomir Ehlert](https://github.com/slafs)
- [Theo Harris](https://github.com/Theosaurus-Rex)
- [Thomas](https://github.com/thomaswhyyou)
- [Thomas Coopman](https://github.com/tcoopman)
- [Thomas Ernst](https://github.com/ernstla)
- [Tim Brown](https://github.com/tmbrwn)
- [Timo Sulg](https://github.com/timgluz)
- [Tom Calloway](https://github.com/modellurgist)
- [Tom Schuster](https://github.com/tomjschuster)
- [Tomasz Kowal](https://github.com/tomekowal)
- [tommaisey](https://github.com/tommaisey)
- [Travis Johnson](https://github.com/ThisGuyCodes)
- [Tristan de Cacqueray](https://github.com/TristanCacqueray)
- [Tristan Sloughter](https://github.com/tsloughter)
- [tymak](https://github.com/tymak)
- [upsidedowncake](https://github.com/upsidedownsweetfood)
- [Valerio Viperino](https://github.com/vvzen)
- [Vic Valenzuela](https://github.com/sandsower)
- [Victor Rodrigues](https://github.com/rodrigues)
- [Viv Verner](https://github.com/PerpetualPossum)
- [Volker Rabe](https://github.com/yelps)
- [Weizheng Liu](https://github.com/weizhliu)
- [wheatfox](https://github.com/enkerewpo)
- [Willyboar](https://github.com/Willyboar)
- [Wilson Silva](https://github.com/wilsonsilva)
- [Xucong Zhan](https://github.com/HymanZHAN)
- [Yamen Sader](https://github.com/yamen)
- [Yasuo Higano](https://github.com/Yasuo-Higano)
- [yoshi~ ](https://github.com/joshi-monster)
- [Yuriy Baranov](https://github.com/Yuri2b)
- [Zsombor Gasparin](https://github.com/gasparinzsombor)
- [~1814730](https://liberapay.com/~1814730/)
- [~1847917](https://liberapay.com/~1847917/)
- [~1867501](https://liberapay.com/~1867501/)
- [Éber Freitas Dias](https://github.com/eberfreitas)

Thanks for reading, I hope you have fun with Gleam! 💜

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>
