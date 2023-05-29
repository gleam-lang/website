# External type

In addition to importing external functions we can also import external types.
Gleam knows nothing about the runtime representation of these types and so
they cannot be pattern matched on, but they can be used with external
functions that know how to work with them.

Here is an example of importing a `Queue` data type and some functions from
Erlang's `queue` module to work with the new `Queue` type.

```rust,noplaypen
pub external type Queue(a)

pub external fn new() -> Queue(a) = "queue" "new"

pub external fn length(Queue(a)) -> Int = "queue" "len"

pub external fn push(Queue(a), a) -> Queue(a) = "queue" "in"
```

When you need an external type you must use the `import` command to bring them into a module.

There are two ways to refer to an external type.

The first is an explicit named import:

```rust,noplaypen
import mytypes.{MySpecialType}

...

fn myfun(x: MySpecialType) -> Int

...
```

The second is a general import with name:

```rust,noplaypen
import mytypes

...

fn myfun(x: mytypes.MySpecialType) -> Int

...
```
