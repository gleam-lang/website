---
layout: page
title: Frequently asked questions
description: The answers to some things you might be wondering about Gleam!
---

- [Why is it called Gleam?](#why-is-it-called-gleam)
- [What does Gleam compile to](#what-does-gleam-compile-to)
- [Will Gleam have type classes?](#will-gleam-have-type-classes)
- [Will Gleam have metaprogramming?](#will-gleam-have-metaprogramming)
- [Does Gleam have mutable state?](#does-gleam-have-mutable-state)
- [Does Gleam have side effects?](#does-gleam-have-side-effects)
- [How does Gleam compare to Alpaca?](#how-does-gleam-compare-to-alpaca)
- [How is message passing typed?](#how-is-message-passing-typed)
- [Can we use the hot code reloading feature from OTP?](#can-we-use-the-hot-code-reloading-feature-from-otp)
- [Should I put Gleam in production?](#should-i-put-gleam-in-production)
- [Why is the compiler written in Rust?](#why-is-the-compiler-written-in-rust)
- [Is it good?](#is-it-good)


## Why is it called Gleam?

Gleam rhymes with and is a synonym of "beam", which is the name of the Erlang
virtual machine.

It's also a short and cute word that's hopefully easy to spell and pronounce
for most people.


## What does Gleam compile to

Gleam compiles to Erlang and also JavaScript.


## Will Gleam have type classes?

Some form of ad-hoc polymorphism could be a good addition to the ergonomics of
the language, though what shape that may take is unclear. Type classes are one
option, OCaml style implicit modules are another, or perhaps it'll be
something else entirely.


## Will Gleam have metaprogramming?

We don't currently have any fixed ideas for what metaprogramming might look
like in Gleam, but it is an area we are interested in. If you have any ideas
please do share them!


## Does Gleam have mutable state?

All data structures in Gleam are immutable and are implemented using
structural sharing so they can be efficiently updated.

If your application needs to hold on to some mutable state then it can be held
by an actor (which immutably wraps mutable state using recursion) or you can
use ETS, the Erlang in-memory key-value database.


## How does Gleam compare to Alpaca?

[alpaca]: https://github.com/alpaca-lang/alpaca

[Alpaca][alpaca] is similar to Gleam in that it is a statically typed language
for the Erlang VM that is inspired by the ML family of languages. It's a
wonderful project and we hope they are wildly successful!

Here's a non-exhaustive list of differences:

- Alpaca functions are auto-curried, Gleam's are not.
- Alpaca's unions can be untagged, with Gleam all variants in a custom type
  need a name.
- Alpaca's compiler is written in Erlang, Gleam's is written in Rust.
- Alpaca's syntax is closer to ML family languages, Gleam's is closer to C or
  ECMAScript family languages.
- Alpaca compiles to Core Erlang, Gleam compiles to regular Erlang and
  optionally JavaScript.
- Alpaca uses the Erlang build tool, Gleam has its own build tool.


## Does Gleam have side effects?

Yes, Gleam is an impure functional language like OCaml or Erlang, so impure
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


## Can we use the hot code reloading feature from OTP?

All the usual Erlang code reloading features work, but it is not possible to
type check the upgrades themselves as we have no way knowing the types of the
already running code. This means you would have the usual Erlang amount of
safety rather than what you might have with Gleam otherwise.

Generally the OTP libraries for Gleam are optimised for type safety rather than
upgrades, and use records rather than atom modules so the state upgrade
callbacks may be slightly more complex to write.


## Should I put Gleam in production?

Gleam is a young language that has not reached version 1.0, so while it is
robust it is likely to undergo breaking changes in the future, and there may
be some annoying bugs in there somewhere. The Gleam ecosystem is also quite
young, so many libraries that are found in other languages will need to be
written, or Erlang/Elixir libraries will have to be used in place of pure
Gleam versions.

The Erlang VM is extremely mature and well tested, so the runtime aspect of
the language is ready for production.

If you decide to move away from Gleam the language you can compile your code
to Erlang and maintain that in future.


## Why is the compiler written in Rust?

Prototype versions of the Gleam compiler was written in Erlang, but a switch was
made to Rust as the lack of static types was making refactoring a slow and
error prone process. A full Rust rewrite of the prototype resulted in the
removal of a lot of tech debt and bugs, and the performance boost is nice too!

One day Gleam may have a compiler written in Gleam, but for now we are focused
on developing other areas of the language such as libraries, tooling, and
documentation.


## Is it good?

Yes, I think so. :)
