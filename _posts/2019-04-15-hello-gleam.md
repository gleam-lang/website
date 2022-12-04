---
author: Louis Pilfold
title: Hello, Gleam!
subtitle: There's a new friendly language in town
tags:
  - Release
---

Gleam has reached v0.1! Happy first release-day Gleam!

## What's Gleam?

Gleam is a functional programming language for writing maintainable and
scalable concurrent systems. If you enjoy the actor based concurrency model
and durable runtime of Erlang and Elixir, and the sound type system of
OCaml, ReasonML, or Elm then I hope you will enjoy Gleam.

It looks something like this:

```gleam
pub enum User =
  | LoggedIn(String)
  | Guest

pub fn check(user) {
  case user {
  | LoggedIn("Al") -> "Hi Al!"
  | LoggedIn(name) -> "Welcome back!"
  | Guest -> "Hello! Please log in"
  }
}
```


## What is it like?

Gleam supports generics, algebraic data types, modules as a first-class
data-type, and row typed maps to enable flexible and permissive function
interfaces.

The type system aims to provide compile time safety and easy refactoring
without burdening the programmer with verbose annotations or boilerplate.
Types are completely inferred, though future releases will allow programmers
to add optional type annotations if desired.

Gleam compiles to Erlang and runs on the <a href="https://www.wired.com/2015/09/whatsapp-serves-900-million-users-50-engineers/" target="_blank">battle proven</a>
Erlang virtual machine, making it suitable for writing massively concurrent
systems that are fault tolerant and relatively easy to reason about.

The Erlang ecosystem is full of great libraries, languages, and applications,
so Gleam makes it straightforward to import functions written in other BEAM
languages and use them in your program. Gleam also aims to be a good citizen,
so any library or application written in Gleam can be used by any other BEAM
language without fuss or performance overhead.


## What is it for?

Thanks to its Erlang heritage Gleam excels at low latency, high concurrency,
networked applications such as web application backends, databases, or message
brokers. Erlang and Elixir are also highly suited for embedded applications,
so perhaps Gleam will be useful there too.

Gleam's type system gives it an edge in rapidly evolving problem spaces as it
helps the programmer refactor quickly and safely by supplying precise and
useful error messages until the change is fully applied.


## What is it not for?

It doesn't run in a browser or on a mobile device, and doesn't have a graphics
library, so it's not suited for GUI applications. It doesn't have the
near-instant boot time and easy distribution of a native binary so it's not
the best for command line applications. It isn't fast at crunching numbers so
you won't use it for statistical analysis.


## Is it good?

Yes, I think so. But then it would be silly if I say otherwise, wouldn't it?

Perhaps don't put it into production just yet, but it's usable enough for pet
projects and toy applications. 🚀


## Sounds interesting. What now?

Check out [the website](http://gleam.run) for more information, and check out
the project on [GitHub](https://github.com/lpil/gleam).

If you've any questions or want to get involved join the IRC channel
`#gleam-lang` on Freenode.

Thanks for reading! :)
