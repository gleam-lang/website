---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Fault tolerant Gleam
subtitle: Gleam v1.2.0 released
tags:
  - Release
---

Gleam is a type safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.2.0][release] has been published, a release
that focuses on improving the language server and developer experience. It's a
big one both in terms of size and impact, so let's take a look as what it
includes.

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.2.0


## Fault tolerant compilation

Gleam's compiler has traditionally halted immediately when a compile time error
was encountered, presenting the error to the programmer and requiring them to
fix it before compilation can be attempted again.

The main advantage of this is that the programmer has just the first and
most important error, rather than a mix of the real error and a bunch of
red-herring cascading errors. On the other hand, if there's multiple genuine
errors the programmer can only see the first one, which may not be the one they
want to work on, or the most understandable.

Even worse, this halting behaviour causes major issues for the Gleam Language
Server (the engine that text editors like Neovim, Helix, Zed, and VS Code use to
get IDE features for Gleam). The language server internally uses the compiler to
build and analyse Gleam projects, so when the compiler halts with an error the
language server is left without up-to-date information about the code. Without a
successful build some language server features may not work, and the longer a
project goes without successful compilation (such as during a large refactoring)
the more drift there can be between the language server's understanding of the
code and the reality.

With this release when the compiler encounters an error during analysis it will
move on to the next definition in the module, returning all of the errors along
with updated code information once the whole module has been analysed. This has
resulted in a dramatic improvement in the experience of using the Gleam
language server, it being much more responsive and accurate in its feedback.

In future releases we will continue to improve the granularity of the fault
tolerant compilation and we will also introduce fault tolerant parsing.

Thanks to [Ameen Radwan](https://github.com/Acepie) and myself for this feature!


## Language server imports improvements

This is a Gleam import statement:
```gleam
import gleam/option.{type Option, Some, None}
//     ^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^
//      the module     unqualified imports
```

The language server could previously autocomplete module names, but now it can
also autocomplete types and values when importing them in the unqualified
fashion.

You can also hover types and values in an import statement to see their
documentation, and use go-to definition on them and the module itself to jump
to where they defined in your project or its dependencies.


## Single line pipelines

Gleam's much loved `|>` pipe operator can be used to pipe the output from one
function into the input of another, not dissimilar to `|` pipes in bash, etc.
Gleam's code formatter would always put each function of a sequence of pipes on
individual lines, but now you can opt to put them all on one line, so long as
altogether they are short enough to fit.
```gleam
[1, 2, 3] |> list.map(int.to_string) |> string.join(with: "\n")
```

In addition you can also force the formatter to break a pipe on multiple lines
by adding a line break. This:
```gleam
[1, 2, 3] |> list.map(int.to_string)
// By putting a newline here I'm telling the formatter to split the pipeline
|> string.join(with: "\n")
```

Will turn into this:
```gleam
[1, 2, 3]
|> list.map(int.to_string)
|> string.join(with: "\n")
```

Thank you to our formatter wizard [Giacomo Cavalieri](https://github.com/giacomocavalieri)
for this feature!


## Improved error messages for `use` expressions

Gleam's [`use` expressions](https://tour.gleam.run/advanced-features/use-sugar/)
are very powerful and can be used to replicate many built-in features of other
languages such as Go's `defer`, procedural languages' early returns, Haskell's
do-notation, and more. As an unusual and powerful feature it can be confusing
at first, and that was made worse as any type errors from incorrect `use`
expressions would be generic ones rather than being specific to `use`.

These errors have been greatly refined and we hope this will help folks learning
the language and debugging their code. Here's some specific examples:

This error message is used when the right-hand-side of `<-` in a `use`
expression is not a function:
```txt
error: Type mismatch
  ┌─ /src/one/two.gleam:2:8
  │
2 │ use <- 123
  │        ^^^

In a use expression, there should be a function on the right hand side of
`<-`, but this value has type:

    Int

See: https://tour.gleam.run/advanced-features/use/
```

This error message is used when the right-hand-side of `<-` is a function,
but it takes no arguments:
```txt
error: Incorrect arity
  ┌─ /src/one/two.gleam:3:8
  │
3 │ use <- func
  │        ^^^^ Expected no arguments, got 1

The function on the right of `<-` here takes no arguments.
But it has to take at least one argument, a callback function.

See: https://tour.gleam.run/advanced-features/use/
```

And this one is used when it takes arguments, but not the correct number of
arguments:
  ```txt
error: Incorrect arity
  ┌─ /src/one/two.gleam:3:8
  │
3 │ use <- f(1, 2)
  │        ^^^^^^^ Expected 2 arguments, got 3

The function on the right of `<-` here takes 2 arguments.
All the arguments have already been supplied, so it cannot take the
`use` callback function as a final argument.

See: https://tour.gleam.run/advanced-features/use/
```

And more! Too many to list here. Thank you to [Giacomo Cavalieri](https://github.com/giacomocavalieri)
for these big improvements!


## Type/value mix up feedback

One common mistake is to try and import a type as a value, or a value as a type.
When an imported item is found not to exist the compiler will now check to see
if there is a matching type or value and explain the mix-up.
```text
error: Unknown module field
  ┌─ /src/one/two.gleam:1:19
  │
1 │ import gleam/one.{One}
  │                   ^^^ Did you mean `type One`?

`One` is only a type, it cannot be imported as a value.
```
```text
error: Unknown module type
  ┌─ /src/one/two.gleam:1:19
  │
1 │ import gleam/two.{type Two}
  │                   ^^^^^^^^ Did you mean `Two`?

`Two` is only a value, it cannot be imported as a type.
```

Thank you [Pi-Cla](https://github.com/Pi-Cla/) for this feature!


## Assertion exhaustiveness checking

Gleam has a `let assert` syntax to apply a pattern to a value, extracting values
contained within if the pattern matches, and crashing the program if it does
not.

The compiler now performs exhaustiveness checking on these assertions to find
patterns that are total and warn that the `assert` is redundant as a result.
```text
warning: Redundant assertion
  ┌─ /home/lucy/src/app/src/app.gleam:4:7
  │
4 │   let assert x = get_name()
  │       ^^^^^^ You can remove this

This assertion is redundant since the pattern covers all possibilities.
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this feature.


## Catching common crash mistakes

Gleam has `todo` and `panic` expressions, both of which crash the program due to
it being incomplete or in an invalid state respectively. The syntax looks like
this:
```gleam
panic as "The session is no longer valid, this should never happen!"
```

A common mistake is to try and give the message string using the function call
syntax like so:
```gleam
panic("The session is no longer valid, this should never happen!")
```

This is valid Gleam code, but it is not using that string as a message for the
panic. The string is unreachable as the program panics before it is evaluated. A
compiler warning is now emitted when code like this is found.
```text
warning: Todo used as a function
  ┌─ /src/warning/wrn.gleam:2:16
  │
2 │           todo(1)
  │                ^

`todo` is not a function and will crash before it can do anything with
this argument.

Hint: if you want to display an error message you should write
`todo as "my error message"`
See: https://tour.gleam.run/advanced-features/todo/
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this feature!


## Invalid constant error message improvement

Gleam's constants are limited to a subset of the language that be evaluated at
compile time, and as such arbitrary functions cannot be called within them.
Previously if you tried to call a function you would get a somewhat confusing
parse error, but with this version it'll emit a much more helpful error message.
```text
error: Syntax error
  ┌─ /src/parse/error.gleam:3:18
  │
3 │ const wib: Int = wibble(1, "wobble")
  │                  ^^^^^^^ Functions can only be called within other functions
```

Thank you [Nino Annighoefer](https://github.com/nino) for this improvement!


## Unreachable code detection

Code that comes after a `panic` expression is unreachable and will never be
evaluated as the program will crash before it is reached. The compiler will now
warn in these situations to catch these mistakes.

For example, this code will emit this warning:

```gleam
pub fn main() {
  panic
  my_app.run()
}
```
```text
warning: Unreachable code
  ┌─ /src/warning/wrn.gleam:3:11
  │
3 │    my_app.run()
  │    ^^^^^^^^^^^^

This code is unreachable because it comes after a `panic`.
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this feature!


## Further Hex integration

Gleam is part of the Erlang ecosystem, and as such it uses the
[Hex package manager](https://hex.pm).

The `gleam hex revert` has been added to the Gleam binary. It can be used to
unpublish a package release within the first 24 hours of it being published.
After 24 hours Hex package releases become immutable and cannot be removed.

Additionally the error message that is emitted when you attempt to publish a
package that has already been published has been improved:
```text
error: Version already published

Version v1.0.0 has already been published.
This release has been recently published so you can replace it
or you can publish it using a different version number

Hint: Please add the --replace flag if you want to replace the release.
```

Thank you [Pi-Cla](https://github.com/Pi-Cla) for these features!


## Erlang module collision prevention

The Erlang virtual machine supports loading new versions of existing module,
enabling an application to be upgraded while it is still running. One
unfortunate consequence of this is that if you accidentally reuse a module name
loading it into the VM will cause the application to be upgraded to the new
version, causing confusing errors as functions that no longer exist are called
and crash.

The Gleam build tool would return an error and refuse to compile Gleam modules
that would overwrite each other, but with this version it will also emit an
error if a Gleam module would overwrite a built-in Erlang/OTP module.
```text
error: Erlang module name collision

The module `src/code.gleam` compiles to an Erlang module named `code`.

By default Erlang includes a module with the same name so if we were to
compile and load your module it would overwrite the Erlang one, potentially
causing confusing errors and crashes.

Hint: Rename this module and try again.
```

## Better build tool errors

A helpful error message is now shown if the `manifest.toml` file has become
invalid, perhaps due to a git rebase or accidental edit.
```text
error: Corrupt manifest.toml

The `manifest.toml` file is corrupt.

Hint: Please run `gleam update` to fix it.
```

Previously when no package versions could be found that satisfy the project's
requirements, a very cryptic message would printed that detailed all the
constraints from all the versions that were incompatible. This was overwhelming
and practically impossible to read, so it has been replaced with a much simpler
message.
```text
error: Dependency resolution failed

An error occurred while determining what dependency packages and
versions should be downloaded.
The error from the version resolver library was:

Unable to find compatible versions for the version constraints in your
gleam.toml. The conflicting packages are:

- hellogleam
- lustre_dev_tools
- glint
```

Thank you [zahash](https://github.com/zahash) for these improvements!


## Redundant pattern matching warnings

Gleam's case expressons support pattern matching on multiple values at the same
time. This is uncommon so people used to other languages may habitually wrap
multiple values in a tuple or a list to match on them. The compiler will now
warn when this is done:
```text
warning: Redundant list
  ┌─ /src/warning/wrn.gleam:2:14
  │
2 │         case [1, 2] {
  │              ^^^^^^ You can remove this list wrapper

Instead of building a list and matching on it, you can match on its
contents directly.
A case expression can take multiple subjects separated by commas like this:

    case one_subject, another_subject {
      _, _ -> todo
    }

See: https://tour.gleam.run/flow-control/multiple-subjects/
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this feature.


## Redundant pattern matching auto-fix

And further still, if you are using the Gleam language server then a code action
is offered to automatically fix redundant tuple wrappers. Place your cursor on
the tuple and select this language action and the language server will remove
the tuple from the values as well as from all patterns in the case expression.
```gleam
case #(x, y) {
  #(1, 2) -> 0
  #(_, _) -> 1
}
```
Is rewritten to:
```gleam
case x, y {
  1, 2 -> 0
  _, _ -> 1
}
```
Thank you [Nicky Lim](https://github.com/nicklimmm) for this code action, and
for laying the foundation for other code actions like this in future!


## A helping hand for JavaScript programmers

JavaScript programmers sometimes type `===` by mistake in their Gleam code. We
have an error message for that too now:
```text
error: Syntax error
  ┌─ /src/parse/error.gleam:4:37
  │
4 │   [1,2,3] |> list.filter(fn (a) { a === 3 })
  │                                     ^^^ Did you mean `==`?

Gleam uses `==` to check for equality between two values.
See: https://tour.gleam.run/basics/equality
```

Thank you [Rabin Gaire](https://github.com/rabingaire) for this feature!









































## And the rest

If you'd like to see all the changes for this release, including all the bug
fixes, check out [the changelog](https://github.com/gleam-lang/gleam/blob/main/changelog/v1.2.md)
in the git repository.

## Thanks

Gleam is made possible by the support of all the kind people and companies who have
very generously [**sponsored**](https://github.com/sponsors/lpil) or
contributed to the project. Thank you all!

If you like Gleam consider sponsoring or asking your employer to
[sponsor Gleam development](https://github.com/sponsors/lpil). I work full time
on Gleam and your kind sponsorship is how I pay my bills!

Alternatively consider using our [referral link for CodeCrafters](https://app.codecrafters.io/join?via=lpil),
who have recently launched a course on implementing Redis in Gleam. Use your
training budget to learn and to support Gleam too!

<ul class="top-sponsors">
  <li>
    <a href="https://fly.io" rel="noopener" target="_blank">
      <img class="sponsor-fly no-shadow" src="/images/sponsors/fly-invert.svg" alt="Fly">
    </a>
  </li>
</ul>

- [Aaron](https://github.com/apstone)
- [Aaron Gunderson](https://github.com/agundy)
- [Abdulrhman Alkhodiry](https://github.com/zeroows)
- [ad-ops](https://github.com/ad-ops)
- [Adam Brodzinski](https://github.com/AdamBrodzinski)
- [Adam Johnston](https://github.com/adjohnston)
- [Adi Iyengar](https://github.com/thebugcatcher)
- [Adi Salimgereyev](https://github.com/abs0luty)
- [aelishRollo](https://github.com/aelishRollo)
- [Aiden Fox Ivey](https://github.com/aidenfoxivey)
- [Ajit Krishna](https://github.com/JitPackJoyride)
- [Alembic](https://alembic.com.au)
- [Alex Manning](https://github.com/rawhat)
- [Alexander Koutmos](https://github.com/akoutmos)
- [Alexander Stensrud](https://github.com/spektroskop)
- [Alexandre Del Vecchio](https://github.com/defgenx)
- [Ameen Radwan](https://github.com/Acepie)
- [AndreHogberg](https://github.com/AndreHogberg)
- [Andy Aylward](https://github.com/aaylward)
- [Anthony Khong](https://github.com/anthony-khong)
- [Anthony Maxwell](https://github.com/Illbjorn)
- [Anthony Scotti](https://github.com/amscotti)
- [Arnaud Berthomier](https://github.com/oz)
- [Arthur Weagel](https://github.com/aweagel)
- [Austin Daily](https://github.com/austindaily)
- [Barry Moore](https://github.com/chiroptical)
- [Bartek Górny](https://github.com/bartekgorny)
- [Ben Martin](https://github.com/requestben)
- [Ben Marx](https://github.com/bgmarx)
- [Ben Myles](https://github.com/benmyles)
- [Benjamin Peinhardt](https://github.com/bcpeinhardt)
- [Benjamin Thomas](https://github.com/bentomas)
- [bgw](https://github.com/bgwdotdev)
- [Bill Nunney](https://github.com/bigtallbill)
- [brettkolodny](https://github.com/brettkolodny)
- [Brian Dawn](https://github.com/brian-dawn)
- [Brian Glusman](https://github.com/bglusman)
- [Bruno B.](https://github.com/b-bruno)
- [Bruno Michel](https://github.com/nono)
- [bucsi](https://github.com/bucsi)
- [Carlo Munguia](https://github.com/carlomunguia)
- [Carlos Saltos](https://github.com/csaltos)
- [Chad Selph](https://github.com/chadselph)
- [Charlie Govea](https://github.com/charlie-n01r)
- [Chaz Watkins](https://github.com/chazwatkins)
- [Chew Choon Keat](https://github.com/choonkeat)
- [Chris Donnelly](https://github.com/ceedon)
- [Chris King](https://github.com/Morzaram)
- [Chris Lloyd](https://github.com/chrislloyd)
- [Chris Ohk](https://github.com/utilForever)
- [Chris Rybicki](https://github.com/Chriscbr)
- [Christopher Dieringer](https://github.com/cdaringe)
- [Christopher Keele](https://github.com/christhekeele)
- [clangley](https://github.com/clangley)
- [Clay](https://github.com/connorlay)
- [Cleo](https://github.com/Lucostus)
- [CodeCrafters](https://github.com/codecrafters-io)
- [Coder](https://github.com/coder)
- [Cole Lawrence](https://github.com/colelawrence)
- [Colin](https://github.com/insanitybit)
- [Comamoca](https://github.com/Comamoca)
- [Constantine Manakov](https://github.com/c-manakov)
- [Cristine Guadelupe](https://github.com/cristineguadelupe)
- [ctulb](https://github.com/ctulb)
- [Damir Vandic](https://github.com/dvic)
- [Dan Dresselhaus](https://github.com/ddresselhaus)
- [Daniel](https://github.com/danielelli)
- [Daniel Hayes](https://github.com/daniel-hayes)
- [Danielle Maywood](https://github.com/DanielleMaywood)
- [Danny Arnold](https://github.com/pinnet)
- [Danny Martini](https://github.com/despairblue)
- [Darshak Parikh](https://github.com/dar5hak)
- [Dave Lucia](https://github.com/davydog187)
- [David Bernheisel](https://github.com/dbernheisel)
- [David Sancho](https://github.com/davesnx)
- [Denis](https://github.com/myFavShrimp)
- [Dennis Dang](https://github.com/dangdennis)
- [dennistruemper](https://github.com/dennistruemper)
- [dependabot[bot]](https://github.com/dependabot%5Bbot%5D)
- [Dezhi Wu](https://github.com/dzvon)
- [Dillon Mulroy](https://github.com/dmmulroy)
- [Dima Utkin](https://github.com/gothy)
- [Dmitry Poroh](https://github.com/poroh)
- [ds2600](https://github.com/ds2600)
- [Edgars Burtnieks](https://github.com/edburtnieks)
- [Edon Gashi](https://github.com/edongashi)
- [Efstathiadis Dimitris](https://github.com/EfstathiadisD)
- [Eileen Noonan](https://github.com/enoonan)
- [eli](https://github.com/dropwhile)
- [Elie Labeca](https://github.com/elabeca)
- [Elliott Pogue](https://github.com/epogue)
- [ellipticview](https://github.com/ellipticview)
- [Emma](https://github.com/Emma-Fuller)
- [EMR Technical Solutions](https://github.com/EMRTS)
- [Erik Lilja](https://github.com/Lilja)
- [Erik Terpstra](https://github.com/eterps)
- [erikareads](https://liberapay.com/erikareads/)
- [ErikML](https://github.com/ErikML)
- [Ernesto Malave](https://github.com/oberernst)
- [Felix Mayer](https://github.com/yerTools)
- [Fernando Farias](https://github.com/nandofarias)
- [Filip Figiel](https://github.com/ffigiel)
- [Fionn Langhans](https://github.com/codefionn)
- [Florian Kraft](https://github.com/floriank)
- [fly.io](https://github.com/superfly)
- [Francisco-Montanez](https://github.com/Francisco-Montanez)
- [Georg H. Ekeberg](https://github.com/hagenek)
- [Giacomo Cavalieri](https://github.com/giacomocavalieri)
- [Graeme Coupar](https://github.com/obmarg)
- [grotto](https://github.com/grottohub)
- [Guilherme de Maio](https://github.com/nirev)
- [Guillaume Hivert](https://github.com/ghivert)
- [Hamir Mahal](https://github.com/hamirmahal)
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
- [Ian González](https://github.com/Ian-GL)
- [Ian M. Jones](https://github.com/ianmjones)
- [Igor Rumiha](https://github.com/irumiha)
- [inoas](https://github.com/inoas)
- [Isaac](https://github.com/graphiteisaac)
- [Isaac Harris-Holt](https://github.com/isaacharrisholt)
- [Ismael Abreu](https://github.com/ismaelga)
- [Ivar Vong](https://github.com/ivarvong)
- [Iván Ovejero](https://github.com/ivov)
- [J. Rinaldi](https://github.com/m-rinaldi)
- [Jack Malcom](https://github.com/dizeeee)
- [Jacob Lamb](https://github.com/jacobdalamb)
- [James Birtles](https://github.com/jamesbirtles)
- [James MacAulay](https://github.com/jamesmacaulay)
- [Jan Skriver Sørensen](https://github.com/monzool)
- [Jean-Luc Geering](https://github.com/jlgeering)
- [Jen Stehlik](https://github.com/okkdev)
- [Jenkin Schibel](https://github.com/dukeofcool199)
- [Jeremy Jacob](https://github.com/jeremyjacob)
- [jiangplus](https://github.com/jiangplus)
- [Jimpjorps™](https://github.com/hunkyjimpjorps)
- [Jiri Luzny](https://github.com/jluzny)
- [Joey Kilpatrick](https://github.com/joeykilpatrick)
- [Johan Strand](https://github.com/johan-st)
- [John Björk](https://github.com/JohnBjrk)
- [John Gallagher](https://github.com/johngallagher)
- [John Pavlick](https://github.com/jmpavlick)
- [Jonas Dahlbæk](https://github.com/dahlbaek)
- [Jonas Hartmann](https://github.com/inoas-nbw)
- [Jonas Hedman Engström](https://github.com/JonasHedEng)
- [Jonas Hietala](https://github.com/treeman)
- [Josef Richter](https://github.com/josefrichter)
- [Joshua Steele](https://github.com/joshocalico)
- [Julian Schurhammer](https://github.com/schurhammer)
- [Kevin](https://github.com/apainintheneck)
- [Kevin Schweikert](https://github.com/kevinschweikert)
- [Kieran Gill](https://github.com/kierangilliam)
- [kodumbeats](https://github.com/kodumbeats)
- [Kramer Hampton](https://github.com/hamptokr)
- [Kryštof Řezáč](https://github.com/krystofrezac)
- [Krzysztof G.](https://github.com/krzysztofgb)
- [Lars Kappert](https://github.com/webpro)
- [Leandro Ostera](https://github.com/leostera)
- [Len Blum](https://github.com/CoronixTV)
- [Leon Qadirie](https://github.com/leonqadirie)
- [lidashuang](https://github.com/defp)
- [LighghtEeloo](https://github.com/LighghtEeloo)
- [Loïc Tosser](https://github.com/wowi42)
- [Lucas Pellegrinelli](https://github.com/lucaspellegrinelli)
- [Luci Phillips](https://github.com/scorpi4n)
- [Lucian Petic](https://github.com/lpetic)
- [Luna](https://github.com/2kool4idkwhat)
- [Luna Schwalbe](https://github.com/lunagl)
- [mahcodes](https://github.com/MAHcodes)
- [Manuel Rubio](https://github.com/manuel-rubio)
- [Marcel](https://github.com/greenthepear)
- [Marcus André](https://github.com/marcusandre)
- [Marcøs](https://github.com/ideaMarcos)
- [Mariano Uvalle](https://github.com/AYM1607)
- [Marius Kalvø](https://github.com/mariuskalvo)
- [Mark Holmes](https://github.com/markholmes)
- [Mark Markaryan](https://github.com/markmark206)
- [Mark Spink](https://github.com/codebay)
- [Martin Janiczek](https://github.com/Janiczek)
- [Martin Rechsteiner](https://github.com/rechsteiner)
- [Mateusz Ledwoń](https://github.com/Axot017)
- [Matt Champagne](https://github.com/han-tyumi)
- [Matt Savoia](https://github.com/matt-savvy)
- [Matt Van Horn](https://github.com/mattvanhorn)
- [Matthias Benkort](https://github.com/KtorZ)
- [Max Hung](https://github.com/maxhungry)
- [Max McDonnell](https://github.com/maxmcd)
- [max-tern](https://github.com/max-tern)
- [Michael Duffy](https://github.com/stunthamster)
- [Michael Jones](https://github.com/michaeljones)
- [Michael Kieran O'Reilly](https://github.com/SoTeKie)
- [Michael Kumm](https://github.com/mkumm)
- [Mike](https://liberapay.com/Daybowbow/)
- [Mike Roach](https://github.com/mroach)
- [Mikey J](https://liberapay.com/mikej/)
- [Milco Kats](https://github.com/katsmil)
- [MoeDev](https://github.com/MoeDevelops)
- [Moshe Goldberg](https://github.com/mogold)
- [MystPi](https://github.com/MystPi)
- [MzRyuKa](https://github.com/rykawamu)
- [n8n - Workflow Automation](https://github.com/n8nio)
- [Nashwan Azhari](https://github.com/aznashwan)
- [Natanael Sirqueira](https://github.com/natanaelsirqueira)
- [Nathaniel Knight](https://github.com/nathanielknight)
- [Nayuki](https://github.com/Kuuuuuuuu)
- [NFIBrokerage](https://github.com/NFIBrokerage)
- [Nick Chapman](https://github.com/nchapman)
- [Nick Reynolds](https://github.com/ndreynolds)
- [Nicklas Sindlev Andersen](https://github.com/NicklasXYZ)
- [Nicky Lim](https://github.com/nicklimmm)
- [NineFX](http://www.ninefx.com)
- [Nino Annighoefer](https://github.com/nino)
- [Nomio](https://github.com/nomio)
- [Ocean Armstrong Lewis](https://github.com/oceanlewis)
- [OldhamMade](https://github.com/OldhamMade)
- [Ole Michaelis](https://github.com/OleMchls)
- [optizio](https://github.com/optizio)
- [P. Envall](https://github.com/npup)
- [PastMoments](https://github.com/PastMoments)
- [Patrick Wheeler](https://github.com/Davorak)
- [Paul Gideon Dann](https://github.com/giddie)
- [Paul Guse](https://github.com/pguse)
- [Pawel Biernacki](https://github.com/biernacki)
- [Pete Jodo](https://github.com/petejodo)
- [Peter Rice](https://github.com/pvsr)
- [Peter Saxton](https://github.com/CrowdHailer)
- [PgBiel](https://github.com/PgBiel)
- [Philip Giuliani](https://github.com/philipgiuliani)
- [Pi-Cla](https://github.com/Pi-Cla)
- [Piotr Szlachciak](https://github.com/sz-piotr)
- [qingliangcn](https://github.com/qingliangcn)
- [Qynn Schwaab](https://github.com/2ynn)
- [Rabin Gaire](https://github.com/rabingaire)
- [Race Williams](https://github.com/raquentin)
- [Rahul Butani](https://github.com/rrbutani)
- [Ratio PBC](https://github.com/RatioPBC)
- [Raúl Chouza ](https://github.com/chouzar)
- [Redmar Kerkhoff](https://github.com/redmar)
- [Renovator](https://github.com/renovatorruler)
- [Richard Viney](https://github.com/richard-viney)
- [Rico Leuthold](https://github.com/rico)
- [Ripta Pasay](https://github.com/ripta)
- [Robert Attard](https://github.com/TanklesXL)
- [Robert Ellen](https://github.com/rellen)
- [Robert Malko](https://github.com/malkomalko)
- [Rodrigo Heinzen de Moraes](https://github.com/R0DR160HM)
- [Roman Wagner](https://github.com/rojnwa)
- [Ross Bratton](https://github.com/brattonross)
- [Ross Cousens](https://github.com/rcousens)
- [Ruslan Ustitc](https://github.com/ustitc)
- [Ryan M. Moore](https://github.com/mooreryan)
- [Sam Aaron](https://github.com/samaaron)
- [Sam Mercer](https://github.com/smercer10)
- [Sami Fouad](https://github.com/samifouad)
- [Sammy Isseyegh](https://github.com/bkspace)
- [Samu Kumpulainen](https://github.com/Ozame)
- [Santi Lertsumran](https://github.com/mrgleam)
- [Saša Jurić](https://github.com/sasa1977)
- [Scott Trinh](https://github.com/scotttrinh)
- [Scott Wey](https://github.com/scottwey)
- [Sean Jensen-Grey](https://github.com/seanjensengrey)
- [Sebastian Porto](https://github.com/sporto)
- [sekun](https://github.com/sekunho)
- [Seve Salazar](https://github.com/tehprofessor)
- [Shane Poppleton](https://github.com/codemonkey76)
- [shayan javani](https://github.com/massivefermion)
- [Shuqian Hon](https://github.com/honsq90)
- [silver-shadow](https://github.com/silver-shadow)
- [Simon Curtis](https://github.com/simon-curtis)
- [Simone Vittori](https://github.com/simonewebdesign)
- [Siraj](https://github.com/syhner)
- [Stephen Belanger](https://github.com/Qard)
- [Szymon Wygnański](https://github.com/finalclass)
- [Sławomir Ehlert](https://github.com/slafs)
- [TheHiddenLayer](https://github.com/TheHiddenLayer)
- [Theo Harris](https://github.com/Theosaurus-Rex)
- [Thomas](https://github.com/thomaswhyyou)
- [Thomas Ernst](https://github.com/ernstla)
- [thorhj](https://github.com/thorhj)
- [Timo Sulg](https://github.com/timgluz)
- [Tom Schuster](https://github.com/tomjschuster)
- [Tomasz Kowal](https://github.com/tomekowal)
- [tommaisey](https://github.com/tommaisey)
- [trag1c](https://github.com/trag1c)
- [Tristan de Cacqueray](https://github.com/TristanCacqueray)
- [Tristan Sloughter](https://github.com/tsloughter)
- [Vassiliy Kuzenkov](https://github.com/bondiano)
- [Vic Valenzuela](https://github.com/sandsower)
- [Victor Rodrigues](https://github.com/rodrigues)
- [Vincent Costa](https://github.com/VincentCosta6)
- [Viv Verner](https://github.com/PerpetualPossum)
- [Vladislav Botvin](https://github.com/darky)
- [Volker Rabe](https://github.com/yelps)
- [Weizheng Liu](https://github.com/weizhliu)
- [Wesley Moore](https://github.com/wezm)
- [Willyboar](https://github.com/Willyboar)
- [Wilson Silva](https://github.com/wilsonsilva)
- [xhh](https://github.com/xhh)
- [xxKeefer](https://github.com/xxKeefer)
- [Yamen Sader](https://github.com/yamen)
- [Yasuo Higano](https://github.com/Yasuo-Higano)
- [zahash](https://github.com/zahash)
- [Zsombor Gasparin](https://github.com/gasparinzsombor)
- [~1847917](https://liberapay.com/~1847917/)
- [Šárka Slavětínská](https://github.com/sarkasl)

Thanks for reading, I hope you have fun with Gleam! 💜

<div style="text-align: center">
  <a class="button" href="https://tour.gleam.run/">Try Gleam</a>
</div>
