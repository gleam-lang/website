# Bit strings

Gleam has a convenient syntax for working directly with binary data called a
Bit String. Bit Strings represent a sequence of 1s and 0s.

Bit Strings are written literally with an opening bracket `<<` any number of
bit string segments separated by commas, and a closing bracket `>>`.

## Bit String Segments

By default a Bit String segment represent 8 bits, also known as 1 byte.

```gleam
// This is the number 3 as an 8 bit value.
// Written in binary it would be 00000011
<<3>>
```

You can also specify a size using either the short hand or long form.

```gleam
// These are the exact same value as above
// Shorthand
<<3:8>>

// Long Form
<<3:size(8)>>
```

You can specify any positive integer as the size.

```gleam
// This is not same as above, remember we're working with a series of 1s and 0s.
<<3:size(16)>>
```

You can have any number of segments separated by a commas.

```gleam
// This is True
<<0:4, 1:3, 1:1>> == <<3>>
```

## Bit String Segment Options

There are a few more options you can attach to a segment to describe its size
and bit layout.

`unit()` lets you create a segment of repeating size. The segment will represent
`unit * size` number of bits. If you use `unit()` you must also have a `size` option.

```gleam
// This is True
<<3:size(4)-unit(4)>> == <<3:size(16)>>
```

The `utf8`, `utf16` and `utf32` options let you put a String directly into a Bit String.

```gleam
<<"Hello Gleam 💫":utf8>>
```

The `bit_string` option lets you put any other Bit String into a Bit String.

```gleam
let a = <<0:1, 1:1, 1:1>>
<<a:bit_string, 1:5>> == <<"a":utf8>> // True
```

Here Is the full list of options and their meaning:

| Option          | Meaning                                                |
| --------------- | ------------------------------------------------------ |
| binary          | a bitstring that is a multiple of 8 bits               |
| bit_string      | a bitstring that is any bit size                       |
| float           | default size of 64 bits                                |
| int             | default size of 8 bits                                 |
| big             | big endian                                             |
| little          | little endian                                          |
| native          | endianness of the processor                            |
| signed          | only valid in patterns, the captured value is signed   |
| signed          | only valid in patterns, the captured value is unsigned |
| size            | the size of the segment in bits                        |
| unit            | how many times to repeat the segment, must have a size |
| utf16           | valid utf16 codepoints                                 |
| utf16_codepoint | a single valid utf16 codepoint                         |
| utf32           | valid utf32 codepoints                                 |
| utf32_codepoint | a single valid utf32 codepoint                         |
| utf8            | valid utf8 codepoints                                  |
| utf8_codepoint  | a single valid utf8 codepoint                          |

Gleam inherits its Bit String syntax and handling directly from Erlang. You can
find the erlang documentation [here](https://erlang.org/doc/reference_manual/expressions.html#bit_syntax).

```

```
