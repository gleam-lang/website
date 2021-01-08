# Bit strings

Gleam offers a syntax for working directly with raw data in the form of bit
strings.

```gleam
// A bit string of the 8 bit int value 3
<<3>>

// A bit string of the utf8 encoded string "Gleam"
<<"Gleam":utf8>>

// A bit string of 3 bits with the value 0 and 1 bit with the value 1
<<0:size(1), 0:size(1), 0:size(1), 1:size(1)>>
```

More information on bit strings can be found in the [Erlang
documentation](https://erlang.org/doc/programming_examples/bit_syntax.html)
