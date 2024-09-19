---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Convenient code actions
subtitle: Gleam v1.5.0 released
tags:
  - Release
---

Gleam is a type-safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.5.0][release] has been published, featuring
lots of really nice developer experience and productivity improvements,
including several useful language server code actions. Let's
take a look.

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.5.0

<a style="float: right; padding-left: var(--gap-4)" class="sponsor-level1" href="https://lambdaclass.com/" rel="noopener" target="_blank" >
  <img src="/images/sponsors/lambda-class-white.png" alt="Lambda Class">
</a>

Before we start I just want to give extra thanks to [Lambda](https://lambdaclass.com/),
Gleam's new primary sponsor. Gleam is an entirely open-source community driven
project rather than being owned by any particular corporation or academic
institution. All funding comes from sponsors, both corporate sponsors such as
Lambda, and individuals sponsoring a few dollars a month on [GitHub
Sponsors][sponsor]. Thank you for making Gleam possible.






## Context aware exhaustiveness errors and code action

The compile time error messages for inexhaustive pattern matching have been
upgraded to show the unmatched values using the syntax the programmer would use
in their code, respecting the aliases and imports in that module. For example,
if you had this code:

```gleam
import gleam/option

pub fn main() {
  let an_option = option.Some("wibble!")
  case an_option {
    option.None -> "missing"
  }
}
```

The error message would show the qualified `option.Some(_)` as the missing
pattern:

```txt
error: Inexhaustive patterns
  ┌─ /root/prova/src/prova.gleam:5:3
  │
5 │ ╭   case an_option {
6 │ │     option.None -> "missing"
7 │ │   }
  │ ╰───^

This case expression does not have a pattern for all possible values. If it
is run on one of the values without a pattern then it will crash.

The missing patterns are:

    option.Some(_)
```

This makes it easier to understand the error message, and the missing patterns
can be copied from the error directly into the source code.

Further still, when there is one of these errors in the code the language
server offers a code action to add the missing patterns for you.

```gleam
// Before
pub fn run(a: Bool) -> Nil {
  case a {}
}
```

```gleam
// After
pub fn run(a: Bool) -> Nil {
  case a {
    False -> todo
    True -> todo
  }
}
```

Thank you [Surya Rose](https://github.com/gearsdatapacks) for this! The code
action is a real favourite of mine! I have been using it constantly.

## Silent compilation

When you run a command like `gleam run` or `gleam test` it prints some progress
information.

<pre><code class="nohighlight"><span class="code-prompt">$</span> gleam run
<span class="code-operator"> Compiling</span> thoas
<span class="code-operator"> Compiling</span> gleam_json
<span class="code-operator"> Compiling</span> app
<span class="code-operator">  Compiled</span> in 1.67s
<span class="code-operator">   Running</span> app_test.main
Hello, world!
</code></pre>

This is generally nice, but sometimes you only want to see the output from your
tests or your program, so a `--no-print-progress` flag has been added to silence
this additional output.

<pre><code class="nohighlight"><span class="code-prompt">$</span> gleam run --no-print-progress
Hello, world!
</code></pre>

Additionally, this information is now printed to standard error rather than
standard out, making it possible to redirect it elsewhere in your command line shell.

Thank you [Ankit Goel](https://github.com/crazymerlyn) and [Victor
Kobinski](https://github.com/vkobinski) for this!

## Run dependency command any time

The `gleam run` command accepts a `--module` flag, which can be used to run a
`main` function from any module in your project, including modules in your
dependencies. It works by compiling your project, booting the virtual machine,
and running the specified module.

The problem with this is that if your code doesn't compile you won't be able to
run modules in your dependencies, even if they have already compiled
successfully. You would have to fix your code before you can run anything.

The build tool now skips compiling your code if you're running a dependency
module, removing this limitation and adding a slight performance improvement as
less work is being done. Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## Prettier HTML documentation

The `gleam docs build` command can be used to generate lovely searchable
documentation for your code and the documentation comments within, and when you
publish a package with `gleam publish` then the HTML documentation is also
published for you.

[Jiangda Wang](https://github.com/frank-iii) has improved the styling of the
sidebar of this documentation. Now if you have a project with long module names
(such as `my_project/web/api/v2/permissions/bucket_creation`) the text will wrap
at a `/` and the continued text on the next line will be indented, making it
easier to read. Thank you Jiangda!

## Prettier runtime errors

We've put a lot of work into making Gleam's compile time errors as clear and
understandable as possible, but when a runtime error crashes a program we've
used the virtual machine's default exception printing functionality, which
wasn't as clear as it could have been.

<pre><code class="nohighlight"><span class="code-error">runtime error: </span>let assert

Pattern match failed, no pattern matched the value.

unmatched value:
  Error("User not logged in")

stacktrace:
  my_app.-main/0-fun-0- <span class="code-prompt">/root/my_app/src/my_app.gleam:8</span>
  gleam/list.do_map <span class="code-prompt">/root/my_app/build/packages/gleam_stdlib/src/gleam/list.gleam:380</span>
  my_app.-main/0-fun-1- <span class="code-prompt">/root/my_app/src/my_app.gleam:11</span>
</code></pre>

The virtual machine doesn't have a source-maps feature, so the line numbers may
not be perfectly accurate, but the generated code now includes per-function
annotations to improve the accuracy compared to previous versions. Additionally,
OTP application trees are now shut down gracefully when `main` exits.

## Gleam requirement detection

In a package's `gleam.toml` you can specify a minimum required Gleam version.
This is useful as if someone attempts to compile your package with too low a
version they will be presented with a clear error message instead of a cryptic
syntax error. Previously it was up for the programmer to keep this requirement
accurate for the code, which is error prone and rarely done.

The compiler can now infer the minimum Gleam version needed for your code to
compile and emits a warning if the project's `gleam` version constraint doesn't
include it. For example, let's say your `gleam.toml` has the constraint
`gleam = ">= 1.1.0"` and your code is using some feature introduced in a later
version:

```gleam
// Concatenating constant strings was introduced in v1.4.0!
pub const greeting = "hello " <> "world!"
```

You would now get the following warning:

```txt
warning: Incompatible gleam version range
  ┌─ /root/datalog/src/datalog.gleam:1:22
  │
1 │ pub const greeting = "hello " <> "world!"
  │                      ^^^^^^^^^^^^^^^^^^^^ This requires a Gleam version >= 1.4.0

Constant strings concatenation was introduced in version v1.4.0. But the
Gleam version range specified in your `gleam.toml` would allow this code to
run on an earlier version like v1.1.0, resulting in compilation errors!
Hint: Remove the version constraint from your `gleam.toml` or update it to be:

    gleam = ">= 1.4.0"
```

Running the `gleam fix` will now update the package's `gleam` version constraint
for you automatically.

If a package has an incorrect constraint then `gleam publish` will not let the
package be published until it is correct. If there's no explicit constraint in
the `gleam.toml` file then the inferred requirement will be added to the package
in the package repository for its users to benefit from.

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for these features!

## Bit array analysis improvements

Gleam's bit array syntax allows you to construct and parse binary data in a way
that may be easier to understand than using binary operators. [Giacomo Cavalieri](https://github.com/giacomocavalieri) 
has introduced some overloading to the syntax so literal unicode segments no
longer need to be annotated with `utf8`.
```gleam
<<"Hello", 0:size(1), "world">>
```

Is the same as:

```gleam
<<"Hello":utf8, 0:size(1), "world":utf8>>
```

On JavaScript bit arrays currently have to be byte aligned. Previously invalid
alignment would be a runtime error, but [Richard Viney](https://github.com/richard-viney)
has added analysis that turns this into a compiler error instead.

Thank you Giacomo and Richard!

## Context aware function inference

Anonymous functions that are immediately called with a record or a tuple as an
argument are now inferred correctly without the need to add type annotations.
For example you can now write:

```gleam
fn(x) { x.0 }(#(1, 2))
// ^ you no longer need to annotate this!
```

This also includes to anonymous functions in pipelines, making it easy to access
a record field without extra annotations or assigning to a variable.

```gleam
pub type User {
  User(name: String)
}

pub fn main() {
  User("Lucy")
  |> fn(user) { user.name }
  //    ^^^^ you no longer need to annotate this!
  |> io.debug
}
```

Thank you [sobolevn](https://github.com/sobolevn) for these type inference
improvements!

## Helpful errors for using modules as values

Modules and values occupy two different namespaces in Gleam, so you can use the same name for a variable and an import and the compiler will pick whichever is correct for that context.

Other BEAM languages such as Erlang and Elixir have modules that can be assigned
to variables and passed around as values, so sometimes folks new to Gleam can be
confused and try to use a module as a value. The compiler now has a helpful
error message specifically for this case.
```gleam
import gleam/list

pub fn main() {
  list
}
```

```txt
error: Module `list` used as a value
  ┌─ /root/prova/src/prova.gleam:4:3
  │
4 │   list
  │   ^^^^

Modules are not values, so you cannot assign them to variables, pass them to
functions, or anything else that you would do with a value.
```

Thank you [sobolevn](https://github.com/sobolevn)!

## Helpful errors for OOP-ish syntax errors

Another common mistake is attempting to write an OOP class in Gleam. Being a
functional language Gleam doesn't have classes or methods, only data and
functions. A helpful error message has been added for when someone attempts to
define methods within a custom type definition.

```gleam
pub type User {
  User(name: String)

  fn greet(user: User) -> String {
    "hello " <> user.name
  }
}
```
```txt
error: Syntax error
  ┌─ /root/prova/src/prova.gleam:8:3
  │
8 │   fn greet(user: User) -> String {
  │   ^^ I was not expecting this

Found the keyword `fn`, expected one of:
- `}`
- a record constructor
Hint: Gleam is not an object oriented programming language so
functions are declared separately from types.
```

Thank you [sobolevn](https://github.com/sobolevn)!

## Missing import suggestions

If some code attempts to use a module that has not been imported yet then the
compile error will suggest which module you may want to import to fix the
problem. This suggestion checks not only the name of the module but also whether
it contains the value you are attempting to access. For example, this code
results in this error with a suggestion:

```gleam
pub fn main() {
  io.println("Hello, world!")
}
```
```txt
error: Unknown module
  ┌─ /src/file.gleam:2:3
  │
2 │   io.println("Hello, world!")
  │   ^^

No module has been found with the name `io`.
Hint: Did you mean to import `gleam/io`?
```

However this code does not get a suggestion in its error message:

```gleam
pub fn main() {
  io.non_existent()
}
```

When there is a suitable module to suggest the language server offers a code
action to add an import for that module to the top of the file.

```gleam
pub fn main() {
  io.println("Hello, world!")
}
```

```gleam
// After
import gleam/io

pub fn main() {
  io.println("Hello, world!")
}
```

Thank you [Surya Rose](https://github.com/gearsdatapacks) for this!

## Helpful invalid external target errors

[Jiangda Wang](https://github.com/frank-iii) has added a helpful error message
for when the specified target for an external function is unknown. Thank you
Jiangda!

```
error: Syntax error
  ┌─ /root/my_app/src/my_app.gleam:5:1
  │
5 │ @external(elixir, "main", "run")
  │ ^^^^^^^^^ I don't recognise this target

Try `erlang`, `javascript`.
```

## Helpful "if" expression errors

Gleam has one single flow-control construct, the pattern matching `case`
expression. The compiler now shows an helpful error message if you try writing
an `if` expression instead of a case. For example, this code:

```gleam
pub fn main() {
  let a = if wibble {
    1
  }
}
```

```txt
error: Syntax error
  ┌─ /src/parse/error.gleam:3:11
  │
3 │   let a = if wibble {
  │           ^^ Gleam doesn't have if expressions

If you want to write a conditional expression you can use a `case`:

    case condition {
      True -> todo
      False -> todo
    }

See: https://tour.gleam.run/flow-control/case-expressions/
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri)!


## Implicit `todo` formatting

If you write a [`use` expression](https://tour.gleam.run/advanced-features/use/)
without any more code in that block then the compiler implicitly inserts a
`todo` expression. With this release the Gleam code formatter will insert that
`todo` for you, to make it clearer what is happening.

```gleam
// Before
pub fn main() {
  use user <- result.try(fetch_user())
}
```
```gleam
// After
pub fn main() {
  use user <- result.try(fetch_user())
  todo
}
```

Thank you to our formatter magician [Giacomo Cavalieri](https://github.com/giacomocavalieri)!

## Result discarding code action

The compiler will warn if a function returns a `Result` and that result
value is not used in any way, meaning that the function could have failed and
the code doesn't handle that failure.

[Jiangda Wang](https://github.com/frank-iii) has added a language server code
action to assign this unused result to `_` for times when you definitely do not
care if the function succeeded or not. Thank you!

```gleam
// Before
pub fn main() {
  function_which_can_fail()
  io.println("Done!")
}
```
```gleam
// After
pub fn main() {
  let _ = function_which_can_fail()
  io.println("Done!")
}
```

## Variable and argument completion

And last but not least, [Ezekiel Grosfeld](https://github.com/ezegros) has added
autocompletion for local variable and function arguments to the language server,
an addition that people have been excitedly asking for for a long time. Thank
you Ezekiel!

## Bug bashing

An extra special shout-out to the bug hunters 
[Ankit Goel](https://github.com/crazymerlyn), [Giacomo
Cavalieri](https://github.com/giacomocavalieri), [Gustavo
Inacio](https://github.com/gusinacio), [Surya
Rose](https://github.com/GearsDatapacks), and [Victor
Kobinski](https://github.com/vkobinski)
Thank you!

If you'd like to see all the changes for this release, including all the bug
fixes, check out [the changelog][changelog] in the git repository.

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.5.md

# A call for support

Gleam is not owned by a corporation, instead it is entirely supported by
sponsors, most of which contribute between $5 and $20 USD per month. I currently
earn substantially less than the median salary tech lead salary for London UK,
the city in which I live, and Gleam is my sole source of income.

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
- [Adi Iyengar](https://github.com/thebugcatcher)
- [Adi Salimgereyev](https://github.com/abs0luty)
- [Adrian Mouat](https://github.com/amouat)
- [Ajit Krishna](https://github.com/JitPackJoyride)
- [Alembic](https://alembic.com.au)
- [Alex](https://github.com/avbits)
- [Alex Houseago](https://github.com/ahouseago)
- [Alex Manning](https://github.com/rawhat)
- [Alex Viscreanu](https://github.com/aexvir)
- [Alexander Koutmos](https://github.com/akoutmos)
- [Alexander Stensrud](https://github.com/muonoum)
- [Alexandre Del Vecchio](https://github.com/defgenx)
- [Aliaksiej Maroz](https://github.com/ricountzero)
- [Ameen Radwan](https://github.com/Acepie)
- [AndreHogberg](https://github.com/AndreHogberg)
- [andrew](https://github.com/ajkachnic)
- [Andrew Brown](https://github.com/andrew-werdna)
- [Andris Horvath](https://github.com/horvathandris)
- [András B Nagy](https://github.com/BNAndras)
- [Andy Aylward](https://github.com/aaylward)
- [Ankit Goel](https://github.com/crazymerlyn)
- [Antharuu](https://github.com/antharuu)
- [Anthony Khong](https://github.com/anthony-khong)
- [Anthony Maxwell](https://github.com/Illbjorn)
- [Anthony Scotti](https://github.com/amscotti)
- [areel](https://github.com/areel)
- [Arnaud Berthomier](https://github.com/oz)
- [Arthur Weagel](https://github.com/aweagel)
- [Azure Flash](https://github.com/azureflash)
- [Barry Moore](https://github.com/chiroptical)
- [Bartek Górny](https://github.com/bartekgorny)
- [Ben Martin](https://github.com/requestben)
- [Ben Marx](https://github.com/bgmarx)
- [Ben Myles](https://github.com/benmyles)
- [Benjamin Peinhardt](https://github.com/bcpeinhardt)
- [Benjamin Thomas](https://github.com/bentomas)
- [bgw](https://github.com/bgwdotdev)
- [Bill Nunney](https://github.com/bigtallbill)
- [Brett Cannon](https://github.com/brettcannon)
- [brettkolodny](https://github.com/brettkolodny)
- [Brian Dawn](https://github.com/brian-dawn)
- [Brian Glusman](https://github.com/bglusman)
- [Bruno Michel](https://github.com/nono)
- [Bruno Roy](https://github.com/QnJ1c2kNCg)
- [bucsi](https://github.com/bucsi)
- [Carlo Gilmar](https://github.com/carlogilmar)
- [Carlo Munguia](https://github.com/carlomunguia)
- [Carlos Saltos](https://github.com/csaltos)
- [Chad Selph](https://github.com/chadselph)
- [Charlie Govea](https://github.com/charlie-n01r)
- [Chaz Watkins](https://github.com/chazwatkins)
- [Chew Choon Keat](https://github.com/choonkeat)
- [Chris Donnelly](https://github.com/ceedon)
- [Chris Haynes](https://github.com/chaynes3)
- [Chris King](https://github.com/Morzaram)
- [Chris Lloyd](https://github.com/chrislloyd)
- [Chris Ohk](https://github.com/utilForever)
- [Chris Rybicki](https://github.com/Chriscbr)
- [Christopher De Vries](https://github.com/devries)
- [Christopher Dieringer](https://github.com/cdaringe)
- [Christopher Keele](https://github.com/christhekeele)
- [clangley](https://github.com/clangley)
- [Claudio](https://github.com/ReXase27)
- [CodeCrafters](https://github.com/codecrafters-io)
- [Coder](https://github.com/coder)
- [Cole Lawrence](https://github.com/colelawrence)
- [Colin](https://github.com/insanitybit)
- [Comamoca](https://github.com/Comamoca)
- [Constantin (Cleo) Winkler](https://github.com/Lucostus)
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
- [David Cornu](https://github.com/davidcornu)
- [David Dios](https://github.com/dios-david)
- [David Sancho](https://github.com/davesnx)
- [Dennis Dang](https://github.com/dangdennis)
- [dennistruemper](https://github.com/dennistruemper)
- [dependabot[bot]](https://github.com/dependabot%5Bbot%5D)
- [Dillon Mulroy](https://github.com/dmmulroy)
- [Dima Utkin](https://github.com/gothy)
- [Dmitry Poroh](https://github.com/poroh)
- [Donnie Flood](https://github.com/floodfx)
- [ds2600](https://github.com/ds2600)
- [ducdetronquito](https://github.com/ducdetronquito)
- [Duncan Holm](https://github.com/frou)
- [Dusty Phillips](https://github.com/dusty-phillips)
- [Dylan Carlson](https://github.com/gdcrisp)
- [Edon Gashi](https://github.com/edongashi)
- [eeeli24](https://github.com/eeeli24)
- [Eileen Noonan](https://github.com/enoonan)
- [eli](https://github.com/dropwhile)
- [Emma](https://github.com/Emma-Fuller)
- [EMR Technical Solutions](https://github.com/EMRTS)
- [Eric Koslow](https://github.com/ekosz)
- [Erik Terpstra](https://github.com/eterps)
- [erikareads](https://liberapay.com/erikareads/)
- [ErikML](https://github.com/ErikML)
- [Ernesto Malave](https://github.com/oberernst)
- [Evaldo Bratti](https://github.com/evaldobratti)
- [Evan Johnson](https://github.com/evanj2357)
- [evanasse](https://github.com/evanasse)
- [ezegrosfeld](https://github.com/ezegros)
- [Fede Esteban](https://github.com/fmesteban)
- [Felix Mayer](https://github.com/yerTools)
- [Fernando Farias](https://github.com/nandofarias)
- [Filip Figiel](https://github.com/ffigiel)
- [Florian Kraft](https://github.com/floriank)
- [Frank Wang](https://github.com/Frank-III)
- [G-J van Rooyen](https://github.com/gvrooyen)
- [Gareth Pendleton](https://github.com/pendletong)
- [GearsDatapacks](https://github.com/GearsDatapacks)
- [Georg H. Ekeberg](https://github.com/hagenek)
- [Giacomo Cavalieri](https://github.com/giacomocavalieri)
- [Giovanni Kock Bonetti](https://github.com/giovannibonetti)
- [Graeme Coupar](https://github.com/obmarg)
- [graphiteisaac](https://github.com/graphiteisaac)
- [grotto](https://github.com/grottohub)
- [Guilherme de Maio](https://github.com/nirev)
- [Guillaume Hivert](https://github.com/ghivert)
- [Gustavo Inacio](https://github.com/gusinacio)
- [Hammad Javed](https://github.com/hammad-r-javed)
- [Hannes Nevalainen](https://github.com/kwando)
- [Hannes Schnaitter](https://github.com/ildorn)
- [Hans Fjällemark](https://github.com/hfjallemark)
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
- [inoas](https://github.com/inoas)
- [Isaac Harris-Holt](https://github.com/isaac
- [Isaac McQueen](https://github.com/imcquee)
- [Ismael Abreu](https://github.com/ismaelga)
- [Ivar Vong](https://github.com/ivarvong)
- [J. Rinaldi](https://github.com/m-rinaldi)
- [Jack Peregrine Doust](https://github.com/Tuna4242)
- [Jacob Lamb](https://github.com/jacobdalamb)
- [Jake Cleary](https://github.com/jakecleary)
- [James Birtles](https://github.com/jamesbirtles)
- [James MacAulay](https://github.com/jamesmacaulay)
- [Jan Skriver Sørensen](https://github.com/monzool)
- [Jean-Luc Geering](https://github.com/jlgeering)
- [Jen Stehlik](https://github.com/okkdev)
- [Jenkin Schibel](https://github.com/dukeofcool199)
- [Jesse Tham](https://github.com/jessetham)
- [jiangplus](https://github.com/jiangplus)
- [Jimpjorps™](https://github.com/hunkyjimpjorps)
- [Joey Kilpatrick](https://github.com/joeykilpatrick)
- [Johan Strand](https://github.com/johan-st)
- [John Björk](https://github.com/JohnBjrk)
- [John Gallagher](https://github.com/johngallagher)
- [John Pavlick](https://github.com/jmpavlick)
- [Jon Lambert](https://github.com/jonlambert)
- [Jonas E. P](https://github.com/igern)
- [Jonas Hedman Engström](https://github.com/JonasHedEng)
- [Jonathan Arnett](https://github.com/J3RN)
- [jooaf](https://github.com/jooaf)
- [Jorge Martí Marín](https://github.com/jormarma)
- [Joseph Lozano](https://github.com/joseph-lozano)
- [Joshua Reusch](https://github.com/joshi-monster)
- [Joshua Steele](https://github.com/joshocalico)
- [Juhan](https://github.com/Juhan280)
- [Julian Lukwata](https://liberapay.com/d2quadra/)
- [Julian Schurhammer](https://github.com/schurhammer)
- [Justin Lubin](https://github.com/justinlubin)
- [Kero van Gelder](https://github.com/keroami)
- [Kevin Schweikert](https://github.com/kevinschweikert)
- [Kirill Morozov](https://github.com/kirillmorozov)
- [kodumbeats](https://github.com/kodumbeats)
- [Kramer Hampton](https://github.com/hamptokr)
- [Kryštof Řezáč](https://github.com/krystofrezac)
- [Krzysztof G.](https://github.com/krzysztofgb)
- [Leandro Ostera](https://github.com/leostera)
- [LelouchFR](https://github.com/LelouchFR)
- [Leon Qadirie](https://github.com/leonqadirie)
- [Leonardo Donelli](https://github.com/LeartS)
- [lidashuang](https://github.com/defp)
- [LighghtEeloo](https://github.com/LighghtEeloo)
- [Lily Rose](https://github.com/LilyRose2798)
- [Loïc Tosser](https://github.com/wowi42)
- [Lucas Pellegrinelli](https://github.com/lucaspellegrinelli)
- [Lucian Petic](https://github.com/lpetic)
- [Lukas Meihsner](https://github.com/lukasmei
- [Luke Amdor](https://github.com/lamdor)
- [Luna](https://github.com/2kool4idkwhat)
- [Manav](https://github.com/chikoYEAT)
- [Manuel Rubio](https://github.com/manuel-rubio)
- [Marcus André](https://github.com/marcusandre)
- [Marcøs](https://github.com/ideaMarcos)
- [Mariano Uvalle](https://github.com/AYM1607)
- [Marius Kalvø](https://github.com/mariuskalvo)
- [Mark Holmes](https://github.com/markholmes)
- [Mark Markaryan](https://github.com/markmark206)
- [Markéta Lisová](https://github.com/datayja)
- [Martin Janiczek](https://github.com/Janiczek)
- [Martin Rechsteiner](https://github.com/rechsteiner)
- [martonkaufmann](https://github.com/martonkaufmann)
- [Mathieu Darse](https://github.com/mdarse)
- [Matt Champagne](https://github.com/han-tyumi)
- [Matt Robinson](https://github.com/matthewrobinsondev)
- [Matt Savoia](https://github.com/matt-savvy)
- [Matt Van Horn](https://github.com/mattvanhorn)
- [Matthias Benkort](https://github.com/KtorZ)
- Max Hill
- [Max McDonnell](https://github.com/maxmcd)
- [max-tern](https://github.com/max-tern)
- [Michael Duffy](https://github.com/stunthamster)
- [Michael Jones](https://github.com/michaeljones)
- [Michael Kieran O'Reilly](https://github.com/SoTeKie)
- [Michael Kumm](https://github.com/mkumm)
- [Michael Mazurczak](https://github.com/monocursive)
- [Michał Hodur](https://github.com/mjwhodur)
- [Mihlali Jordan](https://github.com/mihlali-jordan)
- [Mike](https://liberapay.com/Daybowbow/)
- [Mike Nyola](https://github.com/nyolamike)
- [Mike Roach](https://github.com/mroach)
- [Mikey J](https://liberapay.com/mikej/)
- [MoeDev](https://github.com/MoeDevelops)
- [Moritz Böhme](https://github.com/MoritzBoehme)
- [MzRyuKa](https://github.com/rykawamu)
- [Måns Östman](https://github.com/cheesemans)
- [n8n - Workflow Automation](https://github.com/n8nio)
- [Natanael Sirqueira](https://github.com/natanaelsirqueira)
- [Nathaniel Johnson](https://github.com/nathanjohnson320)
- [Nathaniel Knight](https://github.com/nathanielknight)
- [NFIBrokerage](https://github.com/NFIBrokerage)
- [Nick Chapman](https://github.com/nchapman)
- [Nick Reynolds](https://github.com/ndreynolds)
- [Nicklas Sindlev Andersen](https://github.com/NicklasXYZ)
- [NicoVIII](https://github.com/NicoVIII)
- [Niket Shah](https://github.com/mrniket)
- [Ninaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa](https://github.com/l1f)
- [NineFX](http://www.ninefx.com)
- [Nomio](https://github.com/nomio)
- [Ocean](https://github.com/oceanlewis)
- [OldhamMade](https://github.com/OldhamMade)
- [Oliver Medhurst](https://github.com/CanadaHonk)
- [optizio](https://github.com/optizio)
- [oscar](https://github.com/oscarfsbs)
- [Osman Cea](https://github.com/daslaf)
- [PastMoments](https://github.com/PastMoments)
- [Patrick Wheeler](https://github.com/Davorak)
- [Paul Gideon Dann](https://github.com/giddie)
- [Paul Guse](https://github.com/pguse)
- [Paul Kuruvilla](https://github.com/rohitpaulk)
- [Paulo Vidal](https://github.com/vidalpaul)
- [Pawel Biernacki](https://github.com/biernacki)
- [Pete Jodo](https://github.com/petejodo)
- [Peter Rice](https://github.com/pvsr)
- [Petri-Johan Last](https://github.com/pjlast)
- [PgBiel](https://github.com/PgBiel)
- [Philip Giuliani](https://github.com/philipgiuliani)
- [Pierrot](https://github.com/pierrot-lc)
- [Piotr Szlachciak](https://github.com/sz-piotr)
- [porkbrain](https://github.com/porkbrain)
- [Qdentity](https://github.com/qdentity)
- [qexat](https://github.com/qexat)
- [qingliangcn](https://github.com/qingliangcn)
- [Race Williams](https://github.com/raquentin)
- [Rahul Butani](https://github.com/rrbutani)
- [Ray](https://github.com/ray-delossantos)
- [Raúl Chouza ](https://github.com/chouzar)
- [re.natillas](https://github.com/renatillas)
- [Redmar Kerkhoff](https://github.com/redmar)
- [Reilly Tucker Siemens](https://github.com/reillysiemens)
- [Renovator](https://github.com/renovatorruler)
- [Richard Viney](https://github.com/richard-viney)
- [Rico Leuthold](https://github.com/rico)
- [Ripta Pasay](https://github.com/ripta)
- [Rob](https://github.com/robertwayne)
- [Robert Attard](https://github.com/TanklesXL)
- [Robert Ellen](https://github.com/rellen)
- [Robert Malko](https://github.com/malkomalko)
- [rockerBOO](https://github.com/rockerBOO)
- [Rodrigo Heinzen de Moraes](https://github.com/R0DR160HM)
- [Rupus Reinefjord](https://github.com/reinefjord)
- [Ruslan Ustitc](https://github.com/ustitc)
- [Sam Aaron](https://github.com/samaaron)
- [sambit](https://github.com/soulsam480)
- [Sammy Isseyegh](https://github.com/bkspace)
- [Samu Kumpulainen](https://github.com/Ozame)
- [Santi Lertsumran](https://github.com/mrgleam)
- [Savva](https://github.com/castletaste)
- [Saša Jurić](https://github.com/sasa1977)
- [Scott Trinh](https://github.com/scotttrinh)
- [Scott Wey](https://github.com/scottwey)
- [Sean Jensen-Grey](https://github.com/seanjensengrey)
- [Sebastian Porto](https://github.com/sporto)
- [sekun](https://github.com/sekunho)
- [Seve Salazar](https://github.com/tehprofessor)
- [Shane Poppleton](https://github.com/codemonkey76)
- [Shuqian Hon](https://github.com/honsq90)
- [Simone Vittori](https://github.com/simonewebdesign)
- [sobolevn](https://github.com/sobolevn)
- [Spec](https://github.com/spectacle-cat)
- [star-szr](https://github.com/star-szr)
- [Stefan](https://github.com/bytesource)
- [Stephen Belanger](https://github.com/Qard)
- [Steve Powers](https://github.com/stvpwrs)
- [Strandinator](https://github.com/Strandinator)
- [Sunil Pai](https://github.com/threepointone)
- [syhner](https://github.com/syhner)
- [Sławomir Ehlert](https://github.com/slafs)
- [Theo Harris](https://github.com/Theosaurus-Rex)
- [Thomas](https://github.com/thomaswhyyou)
- [Thomas Coopman](https://github.com/tcoopman)
- [Thomas Ernst](https://github.com/ernstla)
- Thomas Teixeira
- [Tim Brown](https://github.com/tmbrwn)
- [Timo Sulg](https://github.com/timgluz)
- [Tom Schuster](https://github.com/tomjschuster)
- [Tomasz Kowal](https://github.com/tomekowal)
- [tommaisey](https://github.com/tommaisey)
- [Tristan de Cacqueray](https://github.com/TristanCacqueray)
- [Tristan Sloughter](https://github.com/tsloughter)
- [upsidedowncake](https://github.com/upsidedownsweetfood)
- [Valerio Viperino](https://github.com/vvzen)
- [Vassiliy Kuzenkov](https://github.com/bondiano)
- [versecafe](https://github.com/versecafe)
- [Vic Valenzuela](https://github.com/sandsower)
- [Victor Rodrigues](https://github.com/rodrigues)
- [Vincent Costa](https://github.com/VincentCosta6)
- [Viv Verner](https://github.com/PerpetualPossum)
- [vkobinski](https://github.com/vkobinski)
- [Volker Rabe](https://github.com/yelps)
- [Weizheng Liu](https://github.com/weizhliu)
- [Wesley Moore](https://github.com/wezm)
- [Willyboar](https://github.com/Willyboar)
- [Wilson Silva](https://github.com/wilsonsilva)
- [Yamen Sader](https://github.com/yamen)
- [Yasuo Higano](https://github.com/Yasuo-Higano)
- [Zack Sargent](https://github.com/zsarge)
- [Zhomart Mukhamejanov](https://github.com/Zhomart)
- [Zsombor Gasparin](https://github.com/gasparinzsombor)
- [~1847917](https://liberapay.com/~1847917/)

Thanks for reading, I hope you have fun with Gleam! 💜

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>
