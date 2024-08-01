---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Supercharged labels
subtitle: Gleam v1.4.0 released
tags:
  - Release
---

Gleam is a type safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.4.0][release] has been published, and we're
going to go over all that's new.

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.4.0


## A shorthand syntax for labels

Gleam's labelled arguments are a way to give a parameter a name that can be used
at the call site, to serve as documentation and to make code easier to read and
modify. Here the function `date` takes 3 labelled arguments, `day`, `month`, and
`year`.

```gleam
pub fn main() {
  let day = 11
  let month = October
  let year = 1998
  date(year: year, month: month, day: day)
}
```

It's common in Gleam programs to have this repetition of a label and a variable
with the same name. The new label shorthand means that the variable name can be
omitted if it matches the name of the variable to be supplied, so the above
would be written like so:

```gleam
pub fn main() {
  let day = 11
  let month = October
  let year = 1998
  date(year:, month:, day:)
}
```

The shorthand can be used for labelled record fields and in pattern matching
too.

```gleam
pub fn get_year(data: Date) -> Year {
  let Date(year:, ..) = date
  year
}
```

## Label shorthand code action

There is also a new language server code-action (an automated code edit you can
trigger in your editor) to convert to the shorthand syntax. Given code like this
that uses appropriate labels:

```gleam
case date {
  Day(day: day, month: month, year: year) -> todo
}
```
Trigging the code action will edit it to use the shorthand:

```gleam
case date {
  Day(day:, month:, year:) -> todo
}
```

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for these features!

## Adding labels action

The second code action in this release is one to automatically add the labels
that a call accepts. Given this code:

```gleam
pub fn main() {
  Date()
}
```

Triggering the action results in this code:

```gleam
pub fn main() {
  Date(year: todo, month: todo, day: todo)
}
```

And now the programmer can replace the `todo` expressions with whatever values
are appropriate, and they didn't have to refer to the documentation to remember
what the labels are.
Thanks [Giacomo Cavalieri](https://github.com/giacomocavalieri) once again!

## Signature help

The Gleam language server now implemented _signature help_. This means that when
you're calling a function your editor will display the documentation for the
function as well as highlight which argument you need to supply next.

A picture is worth a thousand words, so presumably a video is a small book.
Here's a demonstration:

<video autoplay loop muted playsinline style="max-width: 720px">
  <source src="/images/news/gleam-v1.4-released/help.mp4" type="video/mp4">
</video>

Thank you [Giacomo Cavalieri](https://github.com/giacomocavalieri) for this!

## Unmistakable warnings

The Gleam build tool implements incremental compilation, so a module will only
be recompiled if its definition changes. This means that Gleam compile times
stay low even as codebases grow very large.

One problem with the implementation was that if a module emitted a warning
during compilation, for example: if it uses a deprecated function, then the
warning would not be shown unless the module definition changes. This could
result in people not realising that their project has warnings as nothing was
displayed when they run `gleam build` or `gleam test`.

Warnings are now emitted each time the project is built, ensuring that this
mistake can no longer happen.

And on the topic of warnings, [Damir Vandic](https://github.com/dvic) has
improved our Erlang typespec generation to silence new warnings that were added
to Erlang in version OTP27. Thank you!

## Targeted documentation

`gleam docs build` now takes an optional `--target` flag to specify the target
platform for the generated documentation. This typically is not needed but if
you use the discouraged conditional compilation features then it may be useful
for your project. Thank you [Jiangda Wang](https://github.com/frank-iii)!

## Even more fault tolerance!

Gleam's compiler implements _fault tolerant anaylsis_. This means that when
there is some error in the code that means the code is invalid and cannot be
compiled, it can still continue to analyse the code to the best of its ability,
ignoring the invalid parts. This means that the Gleam language server can have a
good understanding of the code and provide IDE feature even when the codebase is
in an invalid state.

Our language server magician [Ameen Radwan](https://github.com/Acepie) has
continued to improve this capability and now the compiler retains more
information in the presence of record accessor or function call related errors,
giving you a better experience in your text editor.

## Help for a common type definition mistake

This is Gleam's syntax for defining a type named `User` that has a single
constructor also named `User`.

```gleam
pub type User {
  User(name: String)
}
```

This syntax is similar to the class syntax in some object oriented languages
where you define the class and constructors for the class for it within it.

One common mistake is to try and use a C-style struct definition syntax in
Gleam, but this syntax is invalid.

```gleam
pub type User {
  name: String
}
```

If you do this then the compile will now emit a custom error that show you what
the correct syntax is and how to fix the problem:

```
error: Syntax error
  ┌─ /src/parse/error.gleam:3:5
  │
3 │     name: String,
  │     ^^^^ I was not expecting this

Each custom type variant must have a constructor:

pub type User {
  User(
    name: String,
  )
}
```

Thank you [Rahul D. Ghosal](https://github.com/rdghosal) for this feature!

A similar improved error message is emitted for when trying to use a function in
a guard expression, while due to its Erlang heritage only a constant-time subset
of pure expressions are permitted in guards. Thank you [Thomas](https://github.com/DeviousStoat)!

## Constant concatenation

The `<>` string concatenation operator can now be used in constant expressions.

```gleam
pub const greeting = "Hello"

pub const name = "Joe"

pub const sentence = greeting <> " " <> name <> "!"
```

Thank you again [Thomas](https://github.com/DeviousStoat)!

## More JavaScript bit array support

Gleam's has a literal syntax for constructing and pattern matching on bit
arrays, providing a convenient and easier to understand alternative using
bitwise operators as is common in other languages. Currently not all options
supported on the Erlang target are supported on the JavaScript target.

In this release [Richard Viney](https://github.com/richard-viney) has added
support for the `little` and `big` endianness options, the `signed` and
`unsigned` int options, sized floats (32-bit and 64-bit), and `utf8` option.
Thank you Richard!

### Language Server

- The language server can now show completions for fields if a record access is
  being attempted.
  ([Ameen Radwan](https://github.com/Acepie))

- The language server now suggests a code a action to rename variables, types
  and functions when they don't match the Gleam naming requirements:

  ```gleam
  let myNumber = 10
  ```

  Becomes:

  ```gleam
  let my_number = 10
  ```

  ([Surya Rose](https://github.com/gearsdatapacks))

- The language server can now suggest a code action to convert `let assert` into
  a case expression:

  ```gleam
  let assert Ok(value) = get_result()
  ```

  Becomes:

  ```gleam
  let value = case get_result() {
    Ok(value) -> value
    _ -> panic
  }
  ```

  ([Surya Rose](https://github.com/gearsdatapacks))

- The language server now supports listing document symbols, such as functions
  and constants, for the current Gleam file.
  ([PgBiel](https://github.com/PgBiel))

- The language server can now show completions for labels when writing a
  function call or record construction.
  ([Ameen Radwan](https://github.com/Acepie))

- Completions are now sorted by priority based on why the completion is in the
  list. This means that more specific completions like labels and local
  definitions will be shown before more broad completions like functions from a
  not yet imported module.
  ([Ameen Radwan](https://github.com/Acepie))

## And the rest

There's even more in this release! An extra special shout out to the bug hunters 
[Ameen Radwan](https://github.com/Acepie), [Connor Szczepaniak](https://github.com/cszczepaniak),
[Giacomo Cavalieri](https://github.com/giacomocavalieri), [Juraj Petráš](https://github.com/Hackder),
[PgBiel](https://github.com/PgBiel), [sobolevn](https://github.com/sobolevn),
and [Surya Rose](https://github.com/gearsdatapacks).

If you'd like to see all the changes for this release, including all the bug
fixes, check out [the changelog][changelog] in the git repository.

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.4.md

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

<ul class="top-sponsors">
  <li>
  </li>
</ul>

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
