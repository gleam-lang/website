---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Gleam's New Interactive Language Tour
subtitle: Learn Gleam in your browser!
tags:
  - Release
---

Gleam is a type safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam's new language tour has been launched, a way to
try and to learn Gleam without having to install anything on your computer.
Check it out, it looks like this:

<a href="https://tour.gleam.run/"><img alt="A Gleam project being created and compiled with dependencies from both targets" src="/images/news/gleams-new-interactive-language-tour/browser.png"></a>

The language tour guides you through the language, from the basics to the most
advanced features, introducing each concept in a way that builds on what has
come before. Gleam is a small and consistent language, designed to be as easy to
learn and predictable as possible, so the tour manages to cover the entire
language while still being a relatively short read. Once you've completed the
tour you'll know everything you need to know to write your own Gleam programs,
or make contributions to existing ones.

The examples and any code you write are compiled and execute entirely
within the browser, rather sending the code to a build server for processing.
This coupled with Gleam's fast compilation speed means that the tour is
super-snappy. You can experiment and try things without getting bogged down
waiting for the results to come back.

We're super happy with how this work has turned out, and we're hoping that this
will make it easier than ever for people to go from "Gleam sounds interesting"
to "I can write code in Gleam!".

Sound good? Find it at <https://tour.gleam.run/> ✨


## How does it work?

Gleam's [compiler][compiler] is written in Rust, and all input/output is
provided to it via dependency injection. This means that it's possible to
replace the command-line interface that reads and writes to files with an
in-memory one which can be compiled to [WebAssembly][wasm] and run in the
browser.

[compiler]: https://github.com/gleam-lang/gleam/
[wasm]: https://webassembly.org/

Gleam compiles to either Erlang or JavaScript, so in the language tour
JavaScript is used as the target, and this compiled code can be executed
directly in the browser. Executing the code is a little tricky as Gleam outputs
esmodules, which cannot run using JavaScript's `eval` function.
Instead the compiled code is base64 encoded and dynamically imported as a data
URL, after which the `main` function can be called.

```javascript
const encoded = btoa(unescape(encodeURIComponent(code)));
const module = await import("data:text/javascript;base64," + encoded);
module.main();
```

The other tricky part is that we need the code to be able to import and use
modules from the standard library. Compiled Gleam code uses relative paths to
import other Gleam modules. These paths get edited slightly in the tour to point
to where we have a precompiled copy of the standard library, which the browser can
download as needed. Another approach here would have been to include a
JavaScript bundler in the browser, but this more lightweight approach works well
for our needs.

The compiler is fast, but it's important that the website and the browser
remain responsive even on slower hardware, or if compilation is slow for some
other unexpected reason. To avoid this problem compilation and execution is done
in a different thread to the browser's UI using JavaScript [Web Workers][workers].

[workers]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers

The [CodeFlask][codeflask] library is used to provide the code editor and syntax
highlighting. This was selected as it's a lightweight and easy to use text
editor that has just the features we need, and no more.

[codeflask]: https://kazzkiq.github.io/CodeFlask

The website is a static site that is deployed to [GitHub Pages][pages]. Rather
than using any specific static site generator it is built using a small Gleam
program that can be found [here](https://github.com/gleam-lang/language-tour).

[pages]: https://pages.github.com/


## All the thanks

Thanks to [John Doneth](https://github.com/JohnDoneth) for his work getting the
compiler to work within the browser, and to
[Enderchief](https://github.com/Enderchief) for taking this further still.

Thanks to [Hayleigh Thompson](https://github.com/hayleigh-dot-dev/) for her
JavaScript witchcraft, including but not limited to helping us figure out what
our options are for executing esmodules in the browser.

Thanks to [Hazel Bachrach](https://github.com/hibachrach/) for testing the tour
and suggesting use of a second thread, to keep the experience good for folks on
all devices.

Thanks to [Dillon Mulroy](https://github.com/dmmulroy), [Giacomo Cavalieri](https://github.com/giacomocavalieri/), [inoas](https://github.com/inoas/), and [jimpjorps](https://github.com/hunkyjimpjorps/)
for giving feedback on the content of the tour, as well as unpicking my many
typos and grammatical errors.

This has been a long project, so I'm sure I've missed some important people. I'm
very grateful for everyone's help, thank you.

## Support Gleam development

If you like Gleam consider becoming a sponsor or asking your employer to
[sponsor Gleam development](https://github.com/sponsors/lpil). I work full time
on Gleam and your kind sponsorship is how I pay my bills.

Thanks for reading! Happy hacking! 💜
