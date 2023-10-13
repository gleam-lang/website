{% include linkedHeading.html heading="Let bindings" level=1 %}

A value can be given a name using `let`. Names can be reused by later let
bindings, but the values contained are _immutable_, meaning the values
themselves cannot be changed.

```gleam
let x = 1
let y = x
let x = 2

x  // => 2
y  // => 1
```

## Type annotations

A type annotation can be added to a let binding.

```gleam
let x: Int = 1
```

These annotations are optional and while they are checked, they do not aid the
type checker. Gleam code is always fully type checked with or without type
annotations.
