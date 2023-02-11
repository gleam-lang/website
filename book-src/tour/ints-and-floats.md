# Int and Float

Gleam's main number types are Int and Float.

## Ints

Ints are "whole" numbers.

Binary, octal, and hexadecimal ints begin with `0b`, `0o`, and `0x` respectively.

```gleam
1
2
-3
4001
0b00001111
0o17
0xF
```

Gleam has several operators that work with Ints.

```gleam
1 + 1 // => 2
5 - 1 // => 4
5 / 2 // => 2
3 * 3 // => 9
5 % 2 // => 1

2 > 1  // => True
2 < 1  // => False
2 >= 1 // => True
2 <= 1 // => False
```

Underscores can be added to Ints for clarity.

```gleam
1_000_000 // One million
```

## Floats

Floats are numbers that have a decimal point.

```gleam
1.5
2.0
-0.1
```

Floats also have their own set of operators.

```gleam
1.0 +. 1.4 // => 2.4
5.0 -. 1.5 // => 3.5
5.0 /. 2.0 // => 2.5
3.0 *. 3.1 // => 9.3

2.0 >. 1.0  // => True
2.0 <. 1.0  // => False
2.0 >=. 1.0 // => True
2.0 <=. 1.0 // => False
```

Underscores can also be added to Floats for clarity.

```gleam
1_000_000.0 // One million
```

Scientific notation can also be used with Floats:

```gleam
1.01e3 // 1010
15.1e-3 // 0.0151
```

## Stdlib references

- [gleam/float](https://hexdocs.pm/gleam_stdlib/gleam/float.html)
- [gleam/int](https://hexdocs.pm/gleam_stdlib/gleam/int.html)
