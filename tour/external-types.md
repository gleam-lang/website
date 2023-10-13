{% include linkedHeading.html heading="External types" level=1 %}

In addition to importing external functions we can also import external types.
Gleam knows nothing about the runtime representation of these types and so
they cannot be pattern matched on, but they can be used with external
functions that know how to work with them.

To write an external type define a type but don't give it any constructors. Here
is an example of importing a `Queue` data type and some functions from Erlang's
`queue` module to work with the new `Queue` type.

```gleam
pub type Queue(a)

@external(erlang, "queue", "new")
pub fn new() -> Queue(a)

@external(erlang, "queue",  "len")
pub fn length(queue: Queue(a)) -> Int

@external(erlang, "queue", "in")
pub fn push(new: a, queue: Queue(a)) -> Queue(a)
```
