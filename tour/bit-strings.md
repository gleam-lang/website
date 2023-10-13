{% include linkedHeading.html heading="Bit strings" level=1 %}

Gleam has a convenient syntax for working directly with binary data called a
Bit String. Bit Strings represent a sequence of 1s and 0s.

Bit Strings are written literally with opening brackets `<<`, any number of bit
string segments separated by commas, and closing brackets `>>`.

## Bit String Segments

By default a Bit String segment represents 8 bits, also known as 1 byte.

```gleam
// This is the number 3 as an 8 bit value.
// Written in binary it would be 00000011
<<3>>
```

You can also specify a bit size using either short hand or long form.

```gleam
// These are the exact same value as above
// Shorthand
<<3:8>>

// Long Form
<<3:size(8)>>
```

You can specify any positive integer as the bit size.

```gleam
// This is not same as above, remember we're working with a series of 1s and 0s.
// This Bit String is 16 bits long: 0000000000000011
<<3:size(16)>>
```

You can have any number of segments separated by commas.

```gleam
// This is True
<<0:4, 1:3, 1:1>> == <<3>>
```

## Bit String Segment Options

There are a few more options you can attach to a segment to describe its size
and bit layout.

`unit()` lets you create a segment of repeating size. The segment will
represent `unit * size` number of bits. If you use `unit()` you must also have
a `size` option.

```gleam
// This is True
<<3:size(4)-unit(4)>> == <<3:size(16)>>
```

The `utf8`, `utf16` and `utf32` options let you put a String directly into a
Bit String.

```gleam
<<"Hello Gleam 💫":utf8>>
```

The `bit_string` option lets you put any other Bit String into a Bit String.

```gleam
let a = <<0:1, 1:1, 1:1>>
<<a:bit_string, 1:5>> == <<"a":utf8>> // True
```

Here Is the full list of options and their meaning:

### Options in Values

| Option     | Meaning                                                |
| ---------- | ------------------------------------------------------ |
| bit_string | a bitstring that is any bit size                       |
| float      | default size of 64 bits                                |
| int        | default size of 8 bits                                 |
| size       | the size of the segment in bits                        |
| unit       | how many times to repeat the segment, must have a size |
| big        | big endian                                             |
| little     | little endian                                          |
| native     | endianness of the processor                            |
| utf8       | a string to encode as utf8 codepoints                  |
| utf16      | a string to encode as utf16 codepoints                 |
| utf32      | a string to encode as utf32 codepoints                 |

### Options in Patterns

| Option          | Meaning                                                |
| --------------- | ------------------------------------------------------ |
| binary          | a bitstring that is a multiple of 8 bits               |
| bit_string      | a bitstring that is any bit size                       |
| float           | float value, size of exactly 64 bits                   |
| int             | int value, default size of 8 bits                      |
| big             | big endian                                             |
| little          | little endian                                          |
| native          | endianness of the processor                            |
| signed          | the captured value is signed                           |
| unsigned        | the captured value is unsigned                         |
| size            | the size of the segment in bits                        |
| unit            | how many times to repeat the segment, must have a size |
| utf8            | an exact string to match as utf8 codepoints            |
| utf16           | an exact string to match as utf16 codepoints           |
| utf32           | an exact string to match as utf32 codepoints           |
| utf8_codepoint  | a single valid utf8 codepoint                          |
| utf16_codepoint | a single valid utf16 codepoint                         |
| utf32_codepoint | a single valid utf32 codepoint                         |

## Values vs Patterns

Bit Strings can appear on either the left or the right side of an equals sign.
On the left they are called **patterns**, and on the right they are called
**values**.

This is an important distinction because values and patterns have slightly
different rules.

### Rules for Patterns

You can match on a variable length segment with the `bit_string` or `binary`
options. A pattern can have at most 1 variable length segment and it must be
the last segment.

In a pattern the types `utf8`, `utf16`, and `utf32` must be an exact string.
They cannot be a variable. There is no way to match a variable length section
of a binary with an exact encoding.

You can match a single variable codepoint with `utf8_codepoint`,
`utf16_codepoint`, and `utf32_codepoint` which will match the correct number of
bytes depending on the codepoint size and data.

## Further Reading

Gleam inherits its Bit String syntax and handling from Erlang. You can find the
Erlang documentation
[here](https://erlang.org/doc/reference_manual/expressions.html#bit_syntax).

## Stdlib references

- [gleam/bit_string](https://hexdocs.pm/gleam_stdlib/gleam/bit_string.html)
- [gleam/bit_builder](https://hexdocs.pm/gleam_stdlib/gleam/bit_builder.html)
