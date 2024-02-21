---
author: Louis Pilfold
title: Gleam version 1
subtitle: It's finally here! 🎉
tags:
  - Release
---

Today Gleam v1.0.0 has been released! This is the first "stable" release of the
language (more on what that means later) and a big milestone for the language
and the ecosystem.

It has been a long journey and I'm proud of both the technology and the
community that we've built here with Gleam. Thank you so much to everyone who
has taken part in any way, you've all contributed to the project getting here in
meaningful ways of all sizes.


## What's Gleam?

Gleam is a programming language that focuses on practicality, predictability,
and tries to make your job as a writer and maintainer of software systems as
easy as possible.

The language is consistent and has a small surface area, making it possible to
[learn in an afternoon][tour]. Coupled with a lack of magic and a strong desire
to have only one way of doing things, Gleam is typically easy to read and
understand. Reading and debugging code is typically more difficult than writing
new code, so we optimise for this.

[tour]: https://tour.gleam.run/

Gleam has robust static analysis and a type system inspired by languages such as
Elm, OCaml, and Rust, so the compiler serves as a programming assistant, giving
you additional context to help you make the change you want to make. Don't worry
about writing perfect code the first time round, with Gleam refactoring is low
risk and low stress so you can continue to improve your code as you learn more
about the problem at hand.

Running and administrating software is as important as writing it. Gleam
runs on the Erlang virtual machine, a mature and battle-tested platform that
powers many of the world's most reliable, scalable, and massively concurrent,
such as WhatsApp. Gleam can also run on JavaScript runtimes, making it possible
to run Gleam code in the browser, on mobile devices, or anywhere else.

Gleam looks like this:
```gleam
import my_app/person
import gleam/json
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  let result = {
    use data <- try(person.decode(json))
    use row <- try(person.insert(ctx.db, data))
    Ok(person.to_json(row))
  }

  case result {
    Ok(json) -> wisp.json_response(json, 201)
    Error(_) -> wisp.unprocessable_entity()
  }
}
```


## What does Gleam v1 include?

This version covers all the public APIs found in [the main Gleam git
repository][repo], that is:

- The Gleam language design.
- The Gleam compiler.
- The Gleam build tool.
- The Gleam package manager.
- The Gleam code formatter.
- The Gleam language server.
- The Gleam compiler WASM API and JavaScript bindings.

[repo]: https://github.com/gleam-lang/gleam

The Gleam standard library and other packages maintained by the core team will
be getting an accompanying v1 release shortly afterwards. Before these are
released we will be making pull requests to popular community packages to relax
their package manager version constraints to ensure that the update to v1 is as
smooth as possible for all Gleam users.


## What does v1 mean?

Version 1 is a statement about Gleam's stability and readiness to be used in
production systems. We believe Gleam is suitable for use in projects that
matter, and can be relied upon to provide a stable and predictable foundation.

Gleam follows [semantic versioning][semver], so maintaining backwards
compatibility is now a priority. We will be making every effort to ensure that
Gleam does not introduce breaking changes. The exception to this is for security
and soundness issues. Should a critical bug of this nature be discovered we
reserve the right to fix the security issue, even if some programs were taking
advantage of the bug.

[semver]: https://semver.org/


## What's next for Gleam?

Gleam is a practical language intended for making real things, so our focus for
Gleam post-v1 is to be split between productivity for Gleam users and
sustainability for the Gleam project.

### Productivity for Gleam users



### Sustainability for the Gleam project


Thanks for reading! Happy hacking! 💜
