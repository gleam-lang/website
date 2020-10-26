# Constants

Gleam's module constants provide a way to use a certain fixed value in
multiple places in a Gleam project.

```rust,noplaypen
pub const start_year = 2101
pub const end_year = 2111

pub fn is_before(year: Int) -> Bool {
  year < start_year
}

pub fn is_during(year: Int) -> Bool {
  start_year <= year && year <= end_year
}
```

Like all values in Gleam constants are immutable and their values cannot be
changed, so they cannot be used as global mutable state.

When a constant is referenced the value is inlined by the compiler, so they
can be used in case expression guards.

```rust,noplaypen
pub const start_year = 2101
pub const end_year = 2111

pub describe(year: Int) -> String {
  case year {
    year if year < start_year -> "Before"
    year if year > end_year -> "After"
    _ -> "During"
  }
}
```

## Type annotations

Constants can also be given type annotations. 

```rust,noplaypen
pub const name: String = "Gleam"
pub const size: Int = 100
```

These annotations serve as documentation or can be used to provide a more 
specific type than the compiler would otherwise infer.
