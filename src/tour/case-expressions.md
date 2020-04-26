# Case

The `case` expression is the most common kind of flow control in Gleam code. It
allows us to say "if the data has this shape then do that", which we call
_pattern matching_.

Here we match on an `Int` and return a specific string for the values 0, 1,
and 2. The final pattern `n` matches any other value that did not match any of
the previous patterns.

```rust,noplaypen
case some_number {
  0 -> "Zero"
  1 -> "One"
  2 -> "Two"
  n -> "Some other number" // This matches anything
}
```

Pattern matching on a `Bool` value is the Gleam alternative to the `if else`
statement found in other languages.

```rust,noplaypen
case some_bool {
  True -> "It's true!"
  False -> "It's not true."
}
```

Gleam's `case` is an expression, meaning it returns a value and can be used
anywhere we would use a value. For example, we can name the value of a case
expression with a `let` binding.

```rust,noplaypen
let description =
  case True {
    True -> "It's true!"
    False -> "It's not true."
  }

description  // => "It's true!"
```


## Destructuring

A `case` expression can be used to destructure values that
contain other values, such as tuples and lists.

```rust,noplaypen
case xs {
  [] -> "This list is empty"
  [a] -> "This list has 1 element"
  [a, b] -> "This list has 2 elements"
  _other -> "This list has more than 2 elements"
}
```

It's not just the top level data structure that can be pattern matches,
contained values can also be matched. This gives `case` the ability to
concisely express flow control that might be verbose without pattern matching.

```rust,noplaypen
case xs {
  [[]] -> "The only element is an empty list"
  [[], ..] -> "The 1st element is an empty list"
  [[4], ..] -> "The 1st element is a list of the number 4"
  other -> "Something else"
}
```

Pattern matching also works in `let` bindings, though patterns that do not
match all instances of that type may result in a runtime error.

```rust,noplaypen
let [a] = [1]    // a is 1
let [b] = [1, 2] // Runtime error! The pattern has 1 element but the value has 2
```


## Matching on multiple values

Sometimes it is useful to pattern match on multiple values at the same time,
so `case` supports having multiple subjects.

```rust,noplaypen
case x, y {
  1, 1 -> "both are 1"
  1, _ -> "x is 1"
  _, 1 -> "y is 1"
  _, _ -> "neither is 1"
}
```


## Assigning names to sub-patterns

Sometimes when pattern matching we want to assign a name to a value while
specifying it's shape at the same time. We can do this using the `as` keyword.

```rust,noplaypen
case xs {
  [[_, ..] as inner_list] -> inner_list
  other -> []
}
```


## Checking equality and ordering in patterns

The `if` keyword can be used to add a guard expression to a case clause. Both the patterns have to match and the guard has to evaluate to `True` for the clause to match. The guard expression can check for equality or ordering for `Int` and `Float`.

```rust,noplaypen
case xs {
  [a, b, c] if a == b && b != c -> "ok"
  _other -> "ko"
}
```

```rust,noplaypen
case xs {
  [a, b, c] if a >. b && a <=. c -> "ok"
  _other -> "ko"
}
```


## Alternative clause patterns

Alternative patterns can be given for a case clause using the `|` operator. If
any of the patterns match then the clause matches.

Here the first clause will match if the variable `number` holds 2, 4, 6 or 8.

```rust,noplaypen
case number {
  2 | 4 | 6 | 8 -> "This is an even number"
  1 | 3 | 5 | 7 -> "This is an odd number"
  _ -> "I'm not sure"
}
```

If the patterns declare variables then the same variables must be declared in
all patterns, and the variables must have the same type in all the patterns.


```rust,noplaypen
case list {
  [1, x] | x -> x // Error! Int != List(Int)
  _ -> 0
}
```
