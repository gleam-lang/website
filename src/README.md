# Gleam

Gleam is a statically typed functional programming language for building
scalable concurrent systems.

It compiles to [Erlang](http://www.erlang.org/) and has straightforward
interop with other BEAM languages such as Erlang, Elixir and LFE.

It looks like this:


```rust,noplaypen
pub type Tree(value) {
  Leaf(value)
  Node(Tree(value), Tree(value))
}

pub fn any(tree: Tree(a), check: fn(a) -> Bool) -> Bool {
  case tree {
    Leaf(i) -> check(i)
    Node(left, right) -> any(left, check) || any(right, check)
  }
}

pub fn has_even_leaf(tree: Tree(Int)) -> Bool {
  any(tree, fn(i) {
    i % 2 == 0
  })
}
```

The source code can be found at
[https://github.com/gleam-lang/gleam](https://github.com/gleam-lang/gleam).

For Gleam chat we have the IRC channel `#gleam-lang` on Freenode.

## Sponsors

Gleam is made possible by its sponsors. A special thanks to these people who
sponsor Gleam development for $20 or more, thank you!

- [Arian Daneshvar](https://github.com/bees)
- [Bryan Paxton](https://github.com/starbelly)
- [Hendrik Richter](https://github.com/hendi)
- [John Palgut](https://github.com/Jwsonic)
- [José Valim](https://github.com/josevalim)
- [ontofractal](https://github.com/ontofractal)

If you would like to support Gleam please consider [sponsoring the
project](https://github.com/sponsors/lpil).
