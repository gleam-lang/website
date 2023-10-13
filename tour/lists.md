{% include linkedHeading.html heading="Lists" level=1 %}

Lists are ordered collections of values. They're one of the most common data
structures in Gleam.

Lists are _homogeneous_, meaning all the elements of a List must be of the
same type. Attempting to construct a list of multiple types of element will
result in the compiler presenting a type error.

```gleam
[1, 2, 3, 4]  // List(Int)
[1.22, 2.30]  // List(Float)
[1.22, 3, 4]  // Type error!
```

Prepending to a list is very fast, and is the preferred way to add new values.

```gleam
[1, ..[2, 3]]  // => [1, 2, 3]
```

Note that all data structures in Gleam are immutable so prepending to a list
does not change the original list. Instead it efficiently creates a new list
with the new additional element.

```gleam
let x = [2, 3]
let y = [1, ..x]


x  // => [2, 3]
y  // => [1, 2, 3]
```

## Stdlib references

- [gleam/list](https://hexdocs.pm/gleam_stdlib/gleam/list.html)
- [gleam/iterator](https://hexdocs.pm/gleam_stdlib/gleam/iterator.html)
