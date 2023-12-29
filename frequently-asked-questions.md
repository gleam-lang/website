---
layout: page
title: Frequently asked questions
subtitle: What? Why? Where? When? How?
description: The answers to some things you might be wondering about Gleam!
---

- [Why is it called Gleam?](#why-is-it-called-gleam)
- [What does Gleam compile to?](#what-does-gleam-compile-to)
- [Does Gleam have mutable state?](#does-gleam-have-mutable-state)
- [Does Gleam have side effects?](#does-gleam-have-side-effects)
- [Will Gleam have type classes?](#will-gleam-have-type-classes)
- [Will Gleam have metaprogramming?](#will-gleam-have-metaprogramming)
- [How is message passing typed?](#how-is-message-passing-typed)
- [Can Gleam use Erlang's hot code reloading?](#can-gleam-use-erlangs-hot-code-reloading)
- [How does Gleam compare to...](#how-does-gleam-compare-to)
  - [Alpaca?](#how-does-gleam-compare-to-alpaca)
  - [Caramel?](#how-does-gleam-compare-to-caramel)
  - [Elixir?](#how-does-gleam-compare-to-elixir)
  - [Purerl?](#how-does-gleam-compare-to-purerl)
  - [Rust?](#how-does-gleam-compare-to-rust)
- [Can I use Elixir code with Gleam?](#can-i-use-elixir-code-with-gleam)
- [Should I put Gleam in production?](#should-i-put-gleam-in-production)
- [Why is the compiler written in Rust?](#why-is-the-compiler-written-in-rust)
- [Is it good?](#is-it-good)


## Why is it called Gleam?

Gleam rhymes with and is a synonym of "beam", which is the name of the Erlang
virtual machine.

It's also a short and cute word that's hopefully easy to spell and pronounce
for most people.


## What does Gleam compile to?

Gleam compiles to Erlang or JavaScript.


## Will Gleam have type classes?

Type classes are fun and enable creation very nice concise APIs, but they can
make it easy to make challenging to understand code, tend to have confusing
error messages, consuming the code from other languages much harder, have a high
compile time cost, and have a runtime cost unless the compiler performs
full-program compilation and expensive monomorphism. This is unfortunately not a
good fit for Gleam and they are not planned.


## Will Gleam have metaprogramming?

We are gently interested in some form of metaprogramming in Gleam. Currently we
are in the early research and design phase, and it is a low priority compared to
tooling and other work needed for a v1.0 release.

If you have some problems that would be solved with metaprogramming, or proposal
for a metaprogramming design please do share them with us!


## Does Gleam have mutable state?

All data structures in Gleam are immutable and are implemented using
structural sharing so they can be efficiently updated.

If your application needs to hold on to some mutable state then it can be held
by an actor (which immutably wraps mutable state using recursion) or you can
use ETS, the Erlang in-memory key-value database.

If you are compiling Gleam to JavaScript the
[`gleam_javascript`](https://hexdocs.pm/gleam_javascript/index.html) library
offers mutable references.


## Does Gleam have side effects?

Yes, Gleam is an impure functional language like OCaml or Erlang. Impure
actions like reading to files and printing to the console is possible without
special handling.

We may later introduce an effects system for identifying and tracking any
impure code in a Gleam application, though this is still an area of research.


## How is message passing typed?

Type safe message passing is implemented in Gleam as a set of libraries,
rather than being part of the core language itself. This allows us to write safe
concurrent programs that make use of Erlang's OTP framework while not locking
us in to one specific approach to typing message passing. This lack of lock-in
is important as typing message passing is an area of active research, we may
discover an even better approach at a later date!

If you'd like to see more consider checking out [Gleam's OTP
library](https://github.com/gleam-lang/otp).


## Can Gleam use Erlang's hot code reloading?

All the usual Erlang code reloading features work, but it is not possible to
type check the upgrades themselves as we have no way knowing the types of the
already running code. This means you would have the usual Erlang amount of
safety rather than what you might have with Gleam otherwise.

Generally the OTP libraries for Gleam are optimised for type safety rather than
upgrades, and use records rather than atom modules so the state upgrade
callbacks may be more complex to write.

## How does Gleam compare to...

### How does Gleam compare to Alpaca?

[alpaca]: https://github.com/alpaca-lang/alpaca

[Alpaca][alpaca] is similar to Gleam in that it is a statically typed language
for the Erlang VM that is inspired by the ML family of languages. It's a
wonderful project and it was an early inspiration for Gleam!

Here's a non-exhaustive list of differences:

- Alpaca's functions are auto-curried, Gleam's are not.
- Alpaca's unions can be untagged, with Gleam all variants in a custom type
  need a name.
- Alpaca's compiler is written in Erlang, Gleam's is written in Rust.
- Alpaca's syntax is closer to ML family languages, Gleam's is closer to C 
  family languages.
- Alpaca compiles to Core Erlang, Gleam compiles to regular Erlang and
  optionally JavaScript.
- Alpaca uses the Erlang build tool, Gleam has its own build tool.
- Gleam is more actively developed than Alpaca (at time of writing).


### How does Gleam compare to Caramel?

[caramel]: https://github.com/AbstractMachinesLab/caramel

[Caramel][caramel] is similar to Gleam in that it is a statically typed language
for the Erlang VM. It is very cool, especially because of its OCaml heritage!

Here's a non-exhaustive list of differences:

- Caramel is based off of OCaml and forks the OCaml compiler, Gleam is an
  entirely new language, syntax, and compiler.
- Caramel's functions are auto-curried, Gleam's are not.
- Caramel's compiler is written in OCaml, Gleam's is written in Rust.
- Caramel uses OCaml syntax, Gleam has its own syntax that is closer to C
  family languages.
- Gleam is more actively developed than Caramel (at time of writing).


### How does Gleam compare to Elixir?

[elixir]: https://github.com/elixir-lang/elixir

[Elixir][elixir] is another language that runs on the Erlang virtual machine.
It is very popular and a great language!

Here's a non-exhaustive list of differences:

- Elixir is dynamically typed, Gleam is statically typed.
- Elixir has a powerful macro system, Gleam has no metaprogramming features.
- Elixir's compiler is written in Erlang and Elixir, Gleam's is written in Rust.
- Elixir uses Ruby style syntax, Gleam has a C family style syntax.
- Elixir has a namespace for module functions and another for variables,
  Gleam has one unified namespace (so there's no special `fun.()` syntax).
- Gleam standard library is distributed as Hex packages, which makes interoperability
  with other BEAM languages easier.
- Both languages compile to Erlang but Elixir compiles to Erlang abstract
  format, while Gleam compiles to Erlang source. Gleam can also compile to
  JavaScript.
- Elixir is more mature than Gleam and has a much larger ecosystem.


### How does Gleam compare to Purerl?

[purerl]: https://github.com/purerl/purerl

[Purerl][purerl] is a backend for the PureScript compiler that outputs Erlang.
Both PureScript and Purerl are fantastic!

Here's a non-exhaustive list of differences:

- Purerl is a backend for the PureScript compiler, Gleam is its own language and
  compiler.
- PureScript has a more sophisticated type system than Gleam, featuring rows,
  HKTs, type classes, and more.
- Purerl's compiler is written in Haskell, Gleam's is written in Rust.
- PureScript has an ML family style syntax, Gleam has a C family style
  syntax.
- Purerl code can be difficult to use from other BEAM languages, Gleam code is
  designed to be usable from all BEAM languages.
- PureScript is more mature than Gleam and has a much larger ecosystem,
  though not all of it can be used with the Purerl compiler backend.


### How does Gleam compare to Rust?

[rust]: https://github.com/rust-lang/rust

[Rust][rust] is a language that compiles to native code and gives you full
control of memory use in your program, much like C or C++. Gleam's compiler is
written in Rust! We're big fans of the language.

Despite having some syntactic similarities, Gleam and Rust are extremely
different language.

- Rust is a low level programming language, Gleam is a very high level language.
- Rust is a hybrid functional and imperative language that makes heavy use of
  mutable state. Gleam is a functional language where everything is immutable.
- Rust compiles to native code. Gleam runs on the Erlang VM and JavaScript
  runtimes.
- Rust is a very large language which can be challenging to learn. Gleam is a
  small language and is designed to be easy to learn.
- Rust uses futures with async/await, Gleam uses the actor model on Erlang.
- Rust features traits and multiple macro systems, Gleam does not.


## Can I use Elixir code with Gleam?

Yes! The Gleam build tool has support for Elixir and can compile both Elixir
dependencies and Elixir source files in your Gleam project. Elixir has to be
installed on your computer for this to work.

Elixir macros cannot be called from outside of Elixir, so some Elixir APIs
cannot be used directly from Gleam. To use one of these you can write an Elixir
module that uses the macros, and then use that module in your Gleam code.


## Should I put Gleam in production?

Gleam is a young language that has not reached version 1.0, so while it is
robust, it is likely to undergo breaking changes in the future, and there may
be some annoying bugs in there somewhere. The Gleam ecosystem is also quite
young, so many libraries that are found in other languages will need to be
written, or Erlang/Elixir libraries will have to be used in place of pure
Gleam versions.

The Erlang VM is extremely mature and well tested, so the runtime aspect of
the language is ready for production.

If you decide to move away from Gleam, you can compile your code
to Erlang and maintain that in future.


## Why is the compiler written in Rust?

Prototype versions of the Gleam compiler were written in Erlang, but a switch was
made to Rust as the lack of static types was making refactoring a slow and
error prone process. A full Rust rewrite of the prototype resulted in the
removal of a lot of tech debt and bugs, and the performance boost is nice too!

One day, Gleam may have a compiler written in Gleam, but for now we are focused
on developing other areas of the language such as libraries, tooling, and
documentation.


## Is it good?

Yes, I think so. :)
