import gleam/option
import lustre/attribute.{attribute as attr} as attr
import lustre/element/html
import website/fs
import website/layout
import website/page
import website/site

pub fn elixir(ctx: site.Context) -> fs.File {
  let meta =
    site.PageMeta(
      path: "cheatsheets/gleam-for-elixir-users",
      title: "Gleam for Elixir users",
      meta_title: "Gleam for Elixir users | Cheat sheet",
      subtitle: "Hello Alchemists!",
      description: "A handy reminder of Gleam syntax for all Alchemists out there.",
      preload_images: [],
      preview_image: option.None,
    )

  [
    html.ul([], [
      html.li([], [html.a([attr.href("#comments")], [html.text("Comments")])]),
      html.li([], [
        html.a([attr.href("#variables")], [html.text("Variables")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#match-operator")], [html.text("Match operator")]),
          ]),
          html.li([], [
            html.a([attr.href("#variables-type-annotations")], [
              html.text("Variables type annotations"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#functions")], [html.text("Functions")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#exporting-functions")], [
              html.text("Exporting functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-type-annotations")], [
              html.text("Function type annotations"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-heads")], [html.text("Function heads")]),
          ]),
          html.li([], [
            html.a([attr.href("#function-overloading")], [
              html.text("Function overloading"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#referencing-function")], [
              html.text("Referencing functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#calling-anonymous-functions")], [
              html.text("Calling anonymous functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#labelled-arguments")], [
              html.text("Labelled arguments"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#modules")], [html.text("Modules")])]),
      html.li([], [html.a([attr.href("#operators")], [html.text("Operators")])]),
      html.li([], [html.a([attr.href("#constants")], [html.text("Constants")])]),
      html.li([], [html.a([attr.href("#blocks")], [html.text("Blocks")])]),
      html.li([], [
        html.a([attr.href("#data-types")], [html.text("Data types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#strings")], [html.text("Strings")])]),
          html.li([], [html.a([attr.href("#tuples")], [html.text("Tuples")])]),
          html.li([], [html.a([attr.href("#lists")], [html.text("Lists")])]),
          html.li([], [html.a([attr.href("#atoms")], [html.text("Atoms")])]),
          html.li([], [html.a([attr.href("#dicts")], [html.text("Dicts")])]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#patterns")], [html.text("Patterns")])]),
      // html.li([], [
      //   html.a([attr.href("#flow-control")], [html.text("Flow control")]),
      //   html.text("TODO"),
      //   html.ul([], [
      //     html.li([], [
      //       html.a([attr.href("#case")], [html.text("Case")]),
      //       html.text("TODO"),
      //     ]),
      //     html.li([], [
      //       html.a([attr.href("#try")], [html.text("Try")]),
      //       html.text("TODO"),
      //     ]),
      //   ]),
      // ]),
      // html.li([], [
      //   html.a([attr.href("#type-aliases")], [html.text("Type aliases")]),
      //   html.text("TODO"),
      // ]),
      html.li([], [
        html.a([attr.href("#custom-types")], [html.text("Custom types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#records")], [html.text("Records")])]),
          html.li([], [html.a([attr.href("#unions")], [html.text("Unions")])]),
          // html.li([], [
        //   html.a([attr.href("#opaque-custom-types")], [
        //     html.text("Opaque custom types"),
        //   ]),
        //   html.text("TODO"),
        // ]),
        ]),
      ]),
      // html.li([], [
    //   html.a([attr.href("#modules")], [html.text("Modules")]),
    //   html.text("TODO"),
    //   html.ul([], [
    //     html.li([], [
    //       html.a([attr.href("#imports")], [html.text("Imports")]),
    //       html.text("TODO"),
    //     ]),
    //     html.li([], [
    //       html.a([attr.href("#nested-modules")], [html.text("Nested modules")]),
    //       html.text("TODO"),
    //     ]),
    //     html.li([], [
    //       html.a([attr.href("#first-class-modules")], [
    //         html.text("First class modules"),
    //       ]),
    //       html.text("TODO"),
    //     ]),
    //   ]),
    // ]),
    ]),
    html.h2([attr.id("comments")], [html.text("Comments")]),
    html.h4([attr.id("elixir")], [html.text("Elixir")]),
    html.p([], [
      html.text("In Elixir comments are written with a "),
      html.code([], [html.text("#")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "# Hello, Joe!
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        "are used to document the following statement. Comments starting with ",
      ),
      html.code([], [html.text("////")]),
      html.text("are used to document the current module."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
",
        ),
      ]),
    ]),
    html.h2([attr.id("variables")], [html.text("Variables")]),
    html.p([], [html.text("You can reassign variables in both languages.")]),
    html.h4([attr.id("elixir-1")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "size = 50
size = size + 100
size = 1
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-1")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam has the "),
      html.code([], [html.text("let")]),
      html.text("keyword before each variable assignment."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let size = 50
let size = size + 100
let size = 1
",
        ),
      ]),
    ]),
    html.h3([attr.id("match-operator")], [html.text("Match operator")]),
    html.h4([attr.id("elixir-2")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "[x, y] = [1, 2] # assert that the list has 2 elements
2 = y # assert that y is 2
2 = x # runtime error because x's value is 1
[y] = \"Hello\" # runtime error
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-2")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, "),
      html.code([], [html.text("let")]),
      html.text(" and "),
      html.code([], [html.text("=")]),
      html.text(
        " can be used for pattern matching, but you’ll get compile errors if there’s a type mismatch, and a runtime error if there’s a value mismatch. For assertions, the equivalent ",
      ),
      html.code([], [html.text("let assert")]),
      html.text(" keyword is preferred."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let assert [x, y] = [1, 2]
let assert 2 = y // assert that y is 2
let assert 2 = x // runtime error
let assert [y] = \"Hello\" // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h3([attr.id("variables-type-annotations")], [
      html.text("Variables type annotations"),
    ]),
    html.h4([attr.id("elixir-3")], [html.text("Elixir")]),
    html.p([], [html.text("In Elixir there’s no static types.")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "some_list = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-3")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam type annotations can optionally be given when binding variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let some_list: List(Int) = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Gleam will check the type annotation to ensure that it matches the type of the assigned value. It does not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.",
      ),
    ]),
    html.h2([attr.id("functions")], [html.text("Functions")]),
    html.h4([attr.id("elixir-4")], [html.text("Elixir")]),
    html.p([], [
      html.text("In Elixir, you can define functions with the "),
      html.code([], [html.text("def")]),
      html.text(
        " keyword, or assign anonymous functions to variables. Anonymous functions need a ",
      ),
      html.code([], [html.text(".")]),
      html.text(" when calling them."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "def sum(x, y) do
  x + y
end

mul = fn(x, y) -> x * y end
mul.(1, 2)
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-4")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s functions are declared using a syntax similar to Rust or JavaScript. Gleam’s anonymous functions have a similar syntax and don’t need a ",
      ),
      html.code([], [html.text(".")]),
      html.text(" when called."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
",
        ),
      ]),
    ]),
    html.h3([attr.id("exporting-functions")], [html.text("Exporting functions")]),
    html.h4([attr.id("elixir-5")], [html.text("Elixir")]),
    html.p([], [
      html.text("In Elixir functions defined by "),
      html.code([], [html.text("def")]),
      html.text(" are public by default, while ones defined by "),
      html.code([], [html.text("defp")]),
      html.text(" are private."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "# this is public
def sum(x, y) do
  x + y
end

# this is private
defp mul(x, y) do
  x * y
end
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-5")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam functions are private by default and need the "),
      html.code([], [html.text("pub")]),
      html.text("keyword to be public."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// this is public
pub fn sum(x, y) {
  x + y
}

// this is private
fn mul(x, y) {
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-type-annotations")], [
      html.text("Function type annotations"),
    ]),
    html.h4([attr.id("elixir-6")], [html.text("Elixir")]),
    html.p([], [
      html.text(
        "You can use Typespecs to annotate functions in Elixir but they mainly serve as documentation. Typespecs can be optionally used by tools like Dialyzer to find some subset of possible bugs.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "@spec sum(number, number) :: number
def sum(x, y), do: x + y

@spec mul(number, number) :: boolean # no Elixir compile error
def mul(x, y), do: x * y
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-6")], [html.text("Gleam")]),
    html.p([], [
      html.text("Functions can "),
      html.strong([], [html.text("optionally")]),
      html.text(
        " have their argument and return types annotated in Gleam. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool { // compile error, type mismatch
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-heads")], [html.text("Function heads")]),
    html.h4([attr.id("elixir-7")], [html.text("Elixir")]),
    html.p([], [html.text("Elixir functions can have multiple function heads.")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "def zero?(0), do: true
def zero?(x), do: false
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-7")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam functions can have only one function head. Use a case expression to pattern match on function arguments.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn is_zero(x) { // we cannot use `?` in function names in Gleam
  case x {
    0 -> True
    _ -> False
  }
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-overloading")], [
      html.text("Function overloading"),
    ]),
    html.p([], [
      html.text(
        "Unlike Elixir, Gleam does not support function overloading, so there can only
be 1 function with a given name, and the function can only have a single
implementation for the types it accepts.",
      ),
    ]),
    html.h3([attr.id("referencing-functions")], [
      html.text("Referencing functions"),
    ]),
    html.p([], [
      html.text(
        "Gleam has a single namespace for value and functions within a module, so there
is no need for a special syntax to assign a module function to a variable.",
      ),
    ]),
    html.h4([attr.id("elixir-8")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "def identity(x) do
  x
end

def main() do
  func = &identity/1
  func.(100)
end
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-8")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn identity(x) {
  x
}

fn main() {
  let func = identity
  func(100)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("calling-anonymous-functions")], [
      html.text("Calling anonymous functions"),
    ]),
    html.p([], [
      html.text(
        "Elixir has a different namespace for module functions and anonymous functions
so a special ",
      ),
      html.code([], [html.text(".()")]),
      html.text("syntax has to be used to call anonymous functions."),
    ]),
    html.p([], [
      html.text("In Gleam all functions are called using the same syntax."),
    ]),
    html.h4([attr.id("elixir-9")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "anon_function = fn x, y -> x + y end
anon_function.(1, 2)
mod_function(3, 4)
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-9")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let anon_function = fn(x, y) { x + y }
anon_function(1, 2)
mod_function(3, 4)
",
        ),
      ]),
    ]),
    html.h3([attr.id("labelled-arguments")], [html.text("Labelled arguments")]),
    html.p([], [
      html.text(
        "Both Elixir and Gleam have ways to give arguments names and in any order,
though they function differently.",
      ),
    ]),
    html.h4([attr.id("elixir-10")], [html.text("Elixir")]),
    html.p([], [
      html.text(
        "In Elixir arguments can be given as a list of tuples with the name of the
argument being the first element in the tuple.",
      ),
    ]),
    html.p([], [
      html.text(
        "The name used at the call-site does not have to match the name used for the
variable inside the function.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "def replace(opts \\\\ []) do
  string = opts[:inside] || default_string()
  pattern = opts[:each] || default_pattern()
  replacement = opts[:with] || default_replacement()
  go(string, pattern, replacement)
end
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "replace(each: \",\", with: \" \", inside: \"A,B,C\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Because the arguments are stored in a list there is a small runtime
performance penalty for using Elixir’s keyword arguments, and it is possible
for any of the arguments to be missing or of the incorrect type. There are no
compile time checks or optimisations for keyword arguments.",
      ),
    ]),
    html.h4([attr.id("gleam-10")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam arguments can be given a label as well as an internal name. As with
Elixir the name used at the call-site does not have to match the name used
for the variable inside the function.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "replace(each: \",\", with: \" \", inside: \"A,B,C\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "There is no performance cost to Gleam’s labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.",
      ),
    ]),
    html.h2([attr.id("operators")], [html.text("Operators")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Operator")]),
          html.th([], [html.text("Elixir")]),
          html.th([], [html.text("Gleam")]),
          html.th([], [html.text("Notes")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.text("Equal")]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Strictly equal to")]),
          html.td([], [html.code([], [html.text("===")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [html.text("Comparison in Gleam is always strict")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean and")]),
          html.td([], [html.code([], [html.text("and")])]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Logical and")]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean or")]),
          html.td([], [html.code([], [html.text("or")])]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Logical or")]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("div")])]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Remainder")]),
          html.td([], [html.code([], [html.text("rem")])]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Concatenate")]),
          html.td([], [html.code([], [html.text("<>")])]),
          html.td([], [html.code([], [html.text("<>")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("strings")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Pipe")]),
          html.td([], [html.code([], [html.text("|>")])]),
          html.td([], [html.code([], [html.text("|>")])]),
          html.td([], [
            html.text("Gleam’s pipe can pipe into anonymous functions"),
          ]),
        ]),
      ]),
    ]),
    html.h2([attr.id("constants")], [html.text("Constants")]),
    html.h4([attr.id("elixir-11")], [html.text("Elixir")]),
    html.p([], [
      html.text(
        "In Elixir module attrs can be defined to name literals we may want to use in multiple places. They can only be used within the current module.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "defmodule MyServer do
  @the_answer 42
  def main, do: @the_answer
end
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-11")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam constants can be created using the "),
      html.code([], [html.text("const")]),
      html.text("keyword."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "const the_answer = 42

pub fn main() {
  the_answer
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Additionally, Gleam constants can be referenced from other modules.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file other_module.gleam
pub const the_answer: Int = 42
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import other_module

fn main() {
  other_module.the_answer
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("blocks")], [html.text("Blocks")]),
    html.h4([attr.id("elixir-12")], [html.text("Elixir")]),
    html.p([], [
      html.text("In Elixir expressions can be grouped using "),
      html.code([], [html.text("do")]),
      html.text(" and "),
      html.code([], [html.text("end")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "defmodule Wibble do
  def main() do
    x = do
      print(1)
      2
    end
    y = x * (x + 10) # parentheses are used to change arithmetic operations order
    y
  end
end
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-12")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam braces "),
      html.code([], [html.text("{")]),
      html.code([], [html.text("}")]),
      html.text(" are used to group expressions."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn main() {
  let x = {
    print(1)
    2
  }
  // Braces are used to change arithmetic operations order
  let y = x * { x + 10 }
  y
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("data-types")], [html.text("Data types")]),
    html.h3([attr.id("strings")], [html.text("Strings")]),
    html.p([], [
      html.text(
        "In both Elixir and Gleam all strings are UTF-8 encoded binaries.",
      ),
    ]),
    html.h4([attr.id("elixir-13")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-13")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("tuples")], [html.text("Tuples")]),
    html.p([], [
      html.text(
        "Tuples are very useful in Gleam as they’re the only collection data type that allows mixed types in the collection.",
      ),
    ]),
    html.h4([attr.id("elixir-14")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "my_tuple = {\"username\", \"password\", 10}
{_, password, _} = my_tuple
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-14")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let my_tuple = #(\"username\", \"password\", 10)
let #(_, password, _) = my_tuple
",
        ),
      ]),
    ]),
    html.h3([attr.id("lists")], [html.text("Lists")]),
    html.p([], [
      html.text(
        "Lists in Elixir are allowed to be of mixed types, but not in Gleam. They retain all of the same performance semantics.",
      ),
    ]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("cons")]),
      html.text(
        "operator works the same way both for pattern matching and for appending elements to the head of a list, but it uses a different syntax.",
      ),
    ]),
    html.h4([attr.id("elixir-15")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "list = [2, 3, 4]
list = [1 | list]
[1, second_element | _] = list
[1.0 | list] # works
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-15")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h3([attr.id("atoms")], [html.text("Atoms")]),
    html.p([], [
      html.text(
        "In Elixir atoms can be created as needed, but in Gleam all atoms must be defined as values in a custom type before being used. Any value in a type definition in Gleam that does not have any arguments is an atom in Elixir.",
      ),
    ]),
    html.p([], [
      html.text(
        "There are some exceptions to that rule for atoms that are commonly used and have types built-in to Gleam that incorporate them, such as ",
      ),
      html.code([], [html.text("Ok")]),
      html.text(", "),
      html.code([], [html.text("Error")]),
      html.text(" and bools."),
    ]),
    html.p([], [
      html.text(
        "In general, atoms are not used much in Gleam, and are mostly used for bools, ",
      ),
      html.code([], [html.text("Ok")]),
      html.text(" and "),
      html.code([], [html.text("Error")]),
      html.text(" result types, and defining custom types."),
    ]),
    html.h4([attr.id("elixir-16")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "var = :my_new_var

# true and false are atoms in elixir
{:ok, true}
{:error, false}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-16")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type MyNewType {
  MyNewVar
}
let var = MyNewVar

// Ok(_) and Error(_) are of type Result(_, _) in Gleam
Ok(True)
Error(False)
",
        ),
      ]),
    ]),
    html.h3([attr.id("dicts")], [html.text("Dicts")]),
    html.p([], [
      html.text(
        "In Elixir, maps can have keys and values of any type, and they can be mixed in a given map. In Gleam, maps are called Dict (Dictionary) and provided by the standard library. Dicts can have keys and values of any type, but all keys must be of the same type in a given dict and all values must be of the same type in a given dict.",
      ),
    ]),
    html.p([], [
      html.text(
        "There is no dictionary literal syntax in Gleam, and you cannot pattern match on a dict. Dicts are generally not used much in Gleam, custom types are more common.",
      ),
    ]),
    html.h4([attr.id("elixir-17")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "%{\"key1\" => \"value1\", \"key2\" => \"value2\"}
%{\"key1\" => :value1, \"key2\" => 2}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-17")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import gleam/dict

dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", \"value2\")])
dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", 2)]) // Type error!
",
        ),
      ]),
    ]),
    html.h2([attr.id("custom-types")], [html.text("Custom types")]),
    html.p([], [
      html.text(
        "Custom type allows you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.",
      ),
    ]),
    html.h3([attr.id("records")], [html.text("Records")]),
    html.h4([attr.id("elixir-18")], [html.text("Elixir")]),
    html.p([], [
      html.text("Elixir uses Structs which are implemented using Erlang’s Map."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "defmodule Person do
 defstruct name: \"John\", age: 35
end

person = %Person{name: \"Jake\"}
name = person.name
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "In Elixir, the Record module can be used to create Erlang’s Records, but they are not used frequently.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "defmodule Person do
  require Record
  Record.defrecord(:person, Person, name: \"John\", age: \"35\")
end

require Person
{Person, \"Jake\", 35} == Person.person(name: \"Jake\")
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-18")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s custom types can be used in much the same way that structs are used in Elixir. At runtime, they have a tuple representation and are compatible with Erlang records.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Person {
  Person(name: String, age: Int)
}

let person = Person(name: \"Jake\", age: 35)
let name = person.name
",
        ),
      ]),
    ]),
    html.h2([attr.id("modules")], [html.text("Modules")]),
    html.h4([attr.id("elixir-19")], [html.text("Elixir")]),
    html.p([], [
      html.text("In Elixir, the "),
      html.code([], [html.text("defmodule")]),
      html.text(
        "keyword allows to create a module. Multiple modules can be defined in a single file.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "defmodule Wibble do
  def identity(x) do
    x
  end
end

defmodule Wobble do
  def main(x) do
    Wibble.identity(1)
  end
end
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-19")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s file is a module and named by the file name (and its directory path). Since there is no special syntax to create a module, there can be only one module in a file.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file Wibble.gleam
pub fn identity(x) {
  x
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file main.gleam
import Wibble // if Wibble was in a folder called `lib` the import would be `lib/Wibble`
pub fn main() {
  Wibble.identity(1)
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("patterns")], [html.text("Patterns")]),
    html.p([], [
      html.text(
        "Same as Elixir, Gleam has pattern matching, which is used for matching complex structured data. In Gleam we use ",
      ),
      html.code([], [html.text("as")]),
      html.text("to name the variable, same as using "),
      html.code([], [html.text("=")]),
      html.text("in Elixir."),
    ]),
    html.h4([attr.id("gleam-20")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [1, 2, 3]

let assert [1 as first, second, ..rest] = list

let assert Person(name: \"Jack\" as name, age: 20 as age) = Person(name: \"Jack\", age: 20)

let assert #(1 as a, 2 as b) = #(1, 2)
",
        ),
      ]),
    ]),
    html.h4([attr.id("elixir-20")], [html.text("Elixir")]),
    html.pre([], [
      html.code([attr.class("language-elixir")], [
        html.text(
          "list = [1, 2, 3]
[1 = first, second | rest] = list

%Person{name: \"Jack\", age: 20} = %Person{name: \"Jack\", age: 20}

{1 = a, 2 = b} = {1, 2}
",
        ),
      ]),
    ]),
  ]
  |> layout.with_header("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn erlang(ctx: site.Context) -> fs.File {
  let meta =
    site.PageMeta(
      path: "cheatsheets/gleam-for-erlang-users",
      title: "Gleam for Erlang users",
      meta_title: "Gleam for Erlang users | Cheat sheet",
      subtitle: "Hello Erlangers and their many 9s!",
      description: "A handy reminder of Gleam syntax for all Erlangers out there.",
      preload_images: [],
      preview_image: option.None,
    )
  [
    html.ul([], [
      html.li([], [html.a([attr.href("#comments")], [html.text("Comments")])]),
      html.li([], [
        html.a([attr.href("#variables")], [html.text("Variables")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#partial-assignments")], [
              html.text("Partial assignments"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#variable-type-annotations")], [
              html.text("Variable type annotations"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#functions")], [html.text("Functions")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#exporting-functions")], [
              html.text("Exporting functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-type-annotations")], [
              html.text("Function type annotations"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-heads")], [html.text("Function heads")]),
          ]),
          html.li([], [
            html.a([attr.href("#function-overloading")], [
              html.text("Function overloading"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#referencing-functions")], [
              html.text("Referencing functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#chaining-function-calls")], [
              html.text("Chaining function calls"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#labelled-arguments")], [
              html.text("Labelled arguments"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#operators")], [html.text("Operators")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#pipe")], [html.text("Pipe")])]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#constants")], [html.text("Constants")])]),
      html.li([], [html.a([attr.href("#blocks")], [html.text("Blocks")])]),
      html.li([], [
        html.a([attr.href("#data-types")], [html.text("Data types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#strings")], [html.text("Strings")])]),
          html.li([], [html.a([attr.href("#tuples")], [html.text("Tuples")])]),
          html.li([], [html.a([attr.href("#lists")], [html.text("Lists")])]),
          html.li([], [html.a([attr.href("#atoms")], [html.text("Atoms")])]),
          html.li([], [html.a([attr.href("#dicts")], [html.text("Dicts")])]),
        ]),
      ]),
      // html.li([], [
      //   html.a([attr.href("#patterns")], [html.text("Patterns")]),
      //   html.text("TODO"),
      // ]),
      // html.li([], [
      //   html.a([attr.href("#flow-control")], [html.text("Flow control")]),
      //   html.text("TODO"),
      //   html.ul([], [
      //     html.li([], [
      //       html.a([attr.href("#case")], [html.text("Case")]),
      //       html.text("TODO"),
      //     ]),
      //     html.li([], [
      //       html.a([attr.href("#try")], [html.text("Try")]),
      //       html.text("TODO"),
      //     ]),
      //   ]),
      // ]),
      html.li([], [
        html.a([attr.href("#type-aliases")], [html.text("Type aliases")]),
      ]),
      html.li([], [
        html.a([attr.href("#custom-types")], [html.text("Custom types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#records")], [html.text("Records")])]),
          html.li([], [html.a([attr.href("#unions")], [html.text("Unions")])]),
          html.li([], [
            html.a([attr.href("#opaque-custom-types")], [
              html.text("Opaque custom types"),
            ]),
          ]),
        ]),
      ]),
      // html.li([], [
    //   html.a([attr.href("#modules")], [html.text("Modules")]),
    //   html.text("TODO"),
    //   html.ul([], [
    //     html.li([], [
    //       html.a([attr.href("#imports")], [html.text("Imports")]),
    //       html.text("TODO"),
    //     ]),
    //     html.li([], [
    //       html.a([attr.href("#nested-modules")], [html.text("Nested modules")]),
    //       html.text("TODO"),
    //     ]),
    //     html.li([], [
    //       html.a([attr.href("#first-class-modules")], [
    //         html.text("First class modules"),
    //       ]),
    //       html.text("TODO"),
    //     ]),
    //   ]),
    // ]),
    ]),
    html.h2([attr.id("variables")], [html.text("Variables")]),
    html.h4([attr.id("erlang")], [html.text("Erlang")]),
    html.p([], [
      html.text(
        "In Erlang variables are written with a capital letter, and can only be
assigned once.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "Size = 50
Size2 = Size + 100
Size2 = 1 % Runtime error! Size2 is 150, not 1
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam variables are written with a lowercase letter, and names can be
reassigned.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let size = 50
let size = size + 100
let size = 1 // size now refers to 1
",
        ),
      ]),
    ]),
    html.h3([attr.id("partial-assignments")], [html.text("Partial assignments")]),
    html.h4([attr.id("erlang-1")], [html.text("Erlang")]),
    html.p([], [
      html.text(
        "In Erlang a partial pattern that does not match all possible values can be
used to assert that a given term has a specific shape.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "[Element] = SomeList % assert `SomeList` is a 1 element list
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-1")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, the "),
      html.code([], [html.text("let assert")]),
      html.text(
        " keyword is used to make assertions using partial
patterns.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let [element] = some_list // Compile error! Partial pattern
let assert [element] = some_list
",
        ),
      ]),
    ]),
    html.h3([attr.id("variables-type-annotations")], [
      html.text("Variables type annotations"),
    ]),
    html.h4([attr.id("erlang-2")], [html.text("Erlang")]),
    html.p([], [
      html.text(
        "In Erlang it’s not possible to give type annotations to variables.",
      ),
    ]),
    html.h4([attr.id("gleam-2")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam type annotations can optionally be given when binding variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let some_list: List(Int) = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Gleam will check the type annotation to ensure that it matches the type of the
assigned value.",
      ),
    ]),
    html.p([], [
      html.text(
        "Gleam does not need annotations to type check your code, but you may find it
useful to annotate variables to hint to the compiler that you want a specific
type to be inferred.",
      ),
    ]),
    html.h2([attr.id("functions")], [html.text("Functions")]),
    html.p([], [
      html.text(
        "Gleam’s top level functions are declared using a syntax similar to Rust or
JavaScript.",
      ),
    ]),
    html.h4([attr.id("erlang-3")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "my_function(X) ->
    X + 1.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-3")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn my_function(x) {
  x + 1
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("exporting-functions")], [html.text("Exporting functions")]),
    html.p([], [
      html.text("In Gleam functions are exported with the "),
      html.code([], [html.text("pub")]),
      html.text(
        " keyword. An export statement is
not required.",
      ),
    ]),
    html.h4([attr.id("erlang-4")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "-export([my_function/1]).

my_function(X) ->
    X + 1.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-4")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn my_function(x) {
  x + 1
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-type-annotations")], [
      html.text("Function type annotations"),
    ]),
    html.p([], [
      html.text(
        "Functions can optionally have their argument and return types annotated.",
      ),
    ]),
    html.h4([attr.id("erlang-5")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "-spec my_function(integer()) :: integer().
my_function(X) ->
    X + 1.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-5")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn my_function(x: Int) -> Int {
  x + 1
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Unlike in Erlang these type annotations will always be checked by the compiler
and have to be correct for compilation to succeed.",
      ),
    ]),
    html.h3([attr.id("function-heads")], [html.text("Function heads")]),
    html.p([], [
      html.text(
        "Unlike Erlang (but similar to Core Erlang) Gleam does not support multiple
function heads, so to pattern match on an argument a case expression must be
used.",
      ),
    ]),
    html.h4([attr.id("erlang-6")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "identify(1) ->
    \"one\";
identify(2) ->
    \"two\";
identify(3) ->
    \"three\";
identify(_) ->
    \"dunno\".
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-6")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn identify(x) {
  case x {
    1 -> \"one\"
    2 -> \"two\"
    3 -> \"three\"
    _ -> \"dunno\"
  }
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-overloading")], [
      html.text("Function overloading"),
    ]),
    html.p([], [
      html.text(
        "Gleam does not support function overloading, so there can only be 1 function
with a given name, and the function can only have a single implementation for
the types it accepts.",
      ),
    ]),
    html.h3([attr.id("referencing-functions")], [
      html.text("Referencing functions"),
    ]),
    html.p([], [
      html.text(
        "Gleam has a single namespace for value and functions within a module, so there
is no need for a special syntax to assign a module function to a variable.",
      ),
    ]),
    html.h4([attr.id("erlang-7")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "identity(X) ->
  X.

main() ->
  Func = fun identity/1,
  Func(100).
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-7")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn identity(x) {
  x
}

fn main() {
  let func = identity
  func(100)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("chaining-function-calls")], [
      html.text("Chaining function calls"),
    ]),
    html.p([], [
      html.text(
        "Gleam’s parser allows functions returned from functions to be called directly
without adding parenthesis around the function call.",
      ),
    ]),
    html.h4([attr.id("erlang-8")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "(((some_function(0))(1))(2))(3)
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-8")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "some_function(0)(1)(2)(3)
",
        ),
      ]),
    ]),
    html.h3([attr.id("labelled-arguments")], [html.text("Labelled arguments")]),
    html.p([], [
      html.text(
        "Both Erlang and Gleam have ways to give arguments names and in any order,
though they function differently.",
      ),
    ]),
    html.h4([attr.id("erlang-9")], [html.text("Erlang")]),
    html.p([], [
      html.text(
        "In Erlang arguments can be given as as a map so that each has a name.",
      ),
    ]),
    html.p([], [
      html.text(
        "The name used at the call-site does not have to match the name used for the
variable inside the function.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "replace(#{inside => String, each => Pattern, with => Replacement}) ->
  go(String, Pattern, Replacement).
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "replace(#{each => <<\",\">>, with => <<\" \">>, inside => <<\"A,B,C\">>}).
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Because the arguments are stored in a map there is a small runtime
performance penalty to naming arguments, and it is possible for any of the
arguments to be missing or of the incorrect type. There are no compile time
checks or optimisations for maps of arguments.",
      ),
    ]),
    html.h4([attr.id("gleam-9")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam arguments can be given a label as well as an internal name. As with
Erlang the name used at the call-site does not have to match the name used
for the variable inside the function.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "replace(each: \",\", with: \" \", inside: \"A,B,C\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "There is no performance cost to Gleam’s labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.",
      ),
    ]),
    html.h2([attr.id("comments")], [html.text("Comments")]),
    html.h4([attr.id("erlang-10")], [html.text("Erlang")]),
    html.p([], [
      html.text("In Erlang comments are written with a "),
      html.code([], [html.text("%")]),
      html.text(" prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "% Hello, Joe!
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-10")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam comments are written with a "),
      html.code([], [html.text("//")]),
      html.text(" prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        "are used to document the following statement,
comments starting with ",
      ),
      html.code([], [html.text("////")]),
      html.text(" are used to document the current module."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
",
        ),
      ]),
    ]),
    html.h2([attr.id("operators")], [html.text("Operators")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Operator")]),
          html.th([], [html.text("Erlang")]),
          html.th([], [html.text("Gleam")]),
          html.th([], [html.text("Notes")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.text("Equal")]),
          html.td([], [html.code([], [html.text("=:=")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Equal")]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], []),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("=/=")])]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("/=")])]),
          html.td([], []),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("=<")])]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("=<")])]),
          html.td([], [html.code([], [html.text("<=.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean and")]),
          html.td([], [html.code([], [html.text("andalso")])]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [html.text("In Gleam both values must be bools")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean and")]),
          html.td([], [html.code([], [html.text("and")])]),
          html.td([], []),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean or")]),
          html.td([], [html.code([], [html.text("orelse")])]),
          html.td([], [html.code([], [html.text("⎮⎮")])]),
          html.td([], [html.text("In Gleam both values must be bools")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean or")]),
          html.td([], [html.code([], [html.text("or")])]),
          html.td([], []),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*.")])]),
          html.td([], [html.text("In Gleam both values must be floats")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("div")])]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Remainder")]),
          html.td([], [html.code([], [html.text("rem")])]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [html.text("In Gleam both values must be ints")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Concatenate")]),
          html.td([], []),
          html.td([], [html.code([], [html.text("<>")])]),
          html.td([], [html.text("In Gleam both values must be strings")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Pipe")]),
          html.td([], []),
          html.td([], [html.code([], [html.text("⎮>")])]),
          html.td([], [
            html.text("See "),
            html.a([attr.href("#pipe")], [html.text("the pipe section")]),
            html.text(" for details"),
          ]),
        ]),
      ]),
    ]),
    html.h3([attr.id("pipe")], [html.text("Pipe")]),
    html.p([], [
      html.text(
        "The pipe operator can be used to chain together function calls so that they
read from top to bottom.",
      ),
    ]),
    html.h4([attr.id("erlang-11")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "X1 = trim(Input),
X2 = csv:parse(X1, <<\",\">>),
ledger:from_list(X2).
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-11")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "input
|> trim
|> csv.parse(\",\")
|> ledger.from_list
",
        ),
      ]),
    ]),
    html.h2([attr.id("constants")], [html.text("Constants")]),
    html.h4([attr.id("erlang-12")], [html.text("Erlang")]),
    html.p([], [
      html.text(
        "In Erlang macros can be defined to name literals we may want to use in
multiple places. They can only be used within the current module",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "-define(the_answer, 42).

main() ->
  ?the_answer.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-12")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam constants can be used to achieve the same."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "const the_answer = 42

fn main() {
  the_answer
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Gleam constants can be referenced from other modules."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import other_module

fn main() {
  other_module.the_answer
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("blocks")], [html.text("Blocks")]),
    html.h4([attr.id("erlang-13")], [html.text("Erlang")]),
    html.p([], [
      html.text("In Erlang expressions can be grouped using parenthesis or "),
      html.code([], [html.text("begin")]),
      html.text(" and "),
      html.code([], [html.text("end")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "main() ->
  X = begin
    print(1),
    2
  end,
  Y = X * (X + 10),
  Y.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-13")], [html.text("Gleam")]),
    html.p([], [html.text("In Gleam braces are used to group expressions.")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn main() {
  let x = {
    print(1)
    2
  }
  let y = x * {x + 10}
  y
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("data-types")], [html.text("Data types")]),
    html.h3([attr.id("strings")], [html.text("Strings")]),
    html.p([], [html.text("All strings in Gleam are UTF-8 encoded binaries.")]),
    html.h4([attr.id("erlang-14")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "<<\"Hellø, world!\"/utf8>>.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-14")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("tuples")], [html.text("Tuples")]),
    html.p([], [
      html.text(
        "Tuples are very useful in Gleam as they’re the only collection data type that allows for mixed
types of elements in the collection.",
      ),
    ]),
    html.h4([attr.id("erlang-15")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "Tuple = {\"username\", \"password\", 10}.
{_, Password, _} = Tuple.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-15")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let my_tuple = #(\"username\", \"password\", 10)
let #(_, password, _) = my_tuple
",
        ),
      ]),
    ]),
    html.h3([attr.id("lists")], [html.text("Lists")]),
    html.p([], [
      html.text(
        "Lists in Erlang are allowed to be of mixed types, but not in Gleam. They retain all of the same
performance semantics.",
      ),
    ]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("cons")]),
      html.text(
        " operator works the same way both for pattern matching and for appending elements to the
head of a list, but it uses a different syntax.",
      ),
    ]),
    html.h4([attr.id("erlang-16")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "List0 = [2, 3, 4].
List1 = [1 | List0].
[1, SecondElement | _] = List1.
[1.0 | List1].
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-16")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // Type error!
",
        ),
      ]),
    ]),
    html.h3([attr.id("atoms")], [html.text("Atoms")]),
    html.p([], [
      html.text(
        "In Erlang atoms can be created as needed, but in Gleam all atoms must be defined as values in a
custom type before being used. Any value in a type definition in Gleam that does not have any
arguments is an atom in Erlang.",
      ),
    ]),
    html.p([], [
      html.text(
        "There are some exceptions to that rule for atoms that are commonly used and have types built-in to
Gleam that incorporate them, such as ",
      ),
      html.code([], [html.text("ok")]),
      html.text(", "),
      html.code([], [html.text("error")]),
      html.text(" and booleans."),
    ]),
    html.p([], [
      html.text(
        "In general, atoms are not used much in Gleam, and are mostly used for booleans, ",
      ),
      html.code([], [html.text("ok")]),
      html.text("and "),
      html.code([], [html.text("error")]),
      html.text(" result types, and defining custom types."),
    ]),
    html.h4([attr.id("erlang-17")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "Var = my_new_var.

{ok, true}.

{error, false}.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-17")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type MyNewType {
  MyNewVar
}
let var = MyNewVar

Ok(True)

Error(False)
",
        ),
      ]),
    ]),
    html.h3([attr.id("dicts")], [html.text("Dicts")]),
    html.p([], [
      html.text(
        "In Erlang, maps can have keys and values of any type, and they can be mixed in a given map. In Gleam, maps are called Dict (Dictionary) and provided by the standard library. Dicts can have keys and values of any type, but all keys must be of the same type in a given dict and all values must be of the same type in a given dict.",
      ),
    ]),
    html.p([], [
      html.text(
        "There is no dict literal syntax in Gleam, and you cannot pattern match on a dict. Dicts are generally
not used much in Gleam, custom types are more common.",
      ),
    ]),
    html.h4([attr.id("erlang-18")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "#{\"key1\" => \"value1\", \"key2\" => \"value2\"}.
#{\"key1\" => \"value1\", \"key2\" => 2}.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-18")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import gleam/dict


dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", \"value2\")])
dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", 2)]) // Type error!
",
        ),
      ]),
    ]),
    // html.h2([attr.id("flow-control")], [html.text("Flow control")]),
    // html.p([], [html.text("TODO")]),
    // html.h3([attr.id("case")], [html.text("Case")]),
    // html.p([], [html.text("TODO")]),
    // html.h3([attr.id("try")], [html.text("Try")]),
    // html.p([], [html.text("TODO")]),
    html.h2([attr.id("type-aliases")], [html.text("Type aliases")]),
    html.h4([attr.id("erlang-19")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "-type scores() :: list(integer()).
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-19")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub type Scores =
  List(Int)
",
        ),
      ]),
    ]),
    html.h2([attr.id("custom-types")], [html.text("Custom types")]),
    html.h3([attr.id("records")], [html.text("Records")]),
    html.p([], [
      html.text(
        "In Erlang, Records are a specialized data type built on a tuple. Gleam does not have anything
called a ",
      ),
      html.code([], [html.text("record")]),
      html.text(
        ", but custom types can be used in Gleam in much the same way that records are
used in Erlang, even though custom types don’t actually define a ",
      ),
      html.code([], [html.text("record")]),
      html.text(
        "in Erlang when it is
compiled.",
      ),
    ]),
    html.p([], [
      html.text(
        "The important thing is that a custom type allows you to define a collection data type with a fixed
number of named fields, and the values in those fields can be of differing types.",
      ),
    ]),
    html.h4([attr.id("erlang-20")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "-record(person, {age :: integer(),
                 name :: binary()}).
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "Person = #person{name = <<\"name\">>, age = 35}.
Name = Person#person.name.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-20")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Person {
  Person(age: Int, name: String)
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let person = Person(name: \"name\", age: 35)
let name = person.name
",
        ),
      ]),
    ]),
    html.h3([attr.id("unions")], [html.text("Unions")]),
    html.p([], [
      html.text(
        "In Erlang a function can take or receive values of multiple different types.
For example it could return an int some times, and float other times.",
      ),
    ]),
    html.p([], [
      html.text(
        "In Gleam functions must always take and receive one type. To have a union of
two different types they must be wrapped in a new custom type.",
      ),
    ]),
    html.h4([attr.id("erlang-21")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "int_or_float(X) ->
  case X of
    true -> 1;
    false -> 1.0
  end.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-21")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type IntOrFloat {
  AnInt(Int)
  AFloat(Float)
}

fn int_or_float(x) {
  case x {
    True -> AnInt(1)
    False -> AFloat(1.0)
  }
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("opaque-custom-types")], [html.text("Opaque custom types")]),
    html.p([], [
      html.text("In Erlang the "),
      html.code([], [html.text("opaque")]),
      html.text(
        " attr can be used to declare that the internal
structure of a type is not considered a public API and isn’t to be used by
other modules. This is purely for documentation purposes and other modules
can introspect and manipulate opaque types any way they wish.",
      ),
    ]),
    html.p([], [
      html.text(
        "In Gleam custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.",
      ),
    ]),
    html.h4([attr.id("erlang-22")], [html.text("Erlang")]),
    html.pre([], [
      html.code([attr.class("language-erlang")], [
        html.text(
          "-opaque identifier() :: integer().

-spec get_id() -> identifier().
get_id() ->
  100.
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-22")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub opaque type Identifier {
  Identifier(Int)
}

pub fn get_id() {
  Identifier(100)
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("modules")], [html.text("Modules")]),
    html.h3([attr.id("imports")], [html.text("Imports")]),
    html.h3([attr.id("nested-modules")], [html.text("Nested modules")]),
    html.h3([attr.id("first-class-modules")], [html.text("First class modules")]),
  ]
  |> layout.with_header("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn python(ctx: site.Context) -> fs.File {
  let meta =
    site.PageMeta(
      path: "cheatsheets/gleam-for-python-users",
      title: "Gleam for Python users",
      meta_title: "Gleam for Python users | Cheat sheet",
      subtitle: "Hello Pythonistas!",
      description: "A handy reminder of Gleam syntax for all Pythonistas out there.",
      preload_images: [],
      preview_image: option.None,
    )

  [
    html.ul([], [
      html.li([], [html.a([attr.href("#comments")], [html.text("Comments")])]),
      html.li([], [
        html.a([attr.href("#variables")], [html.text("Variables")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#match-operator")], [html.text("Match operator")]),
          ]),
          html.li([], [
            html.a([attr.href("#variables-type-annotations")], [
              html.text("Variables type annotations"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#functions")], [html.text("Functions")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#exporting-functions")], [
              html.text("Exporting functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-type-annotations")], [
              html.text("Function type annotations"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#referencing-functions")], [
              html.text("Referencing functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#labelled-arguments")], [
              html.text("Labelled arguments"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#operators")], [html.text("Operators")])]),
      html.li([], [html.a([attr.href("#constants")], [html.text("Constants")])]),
      html.li([], [html.a([attr.href("#blocks")], [html.text("Blocks")])]),
      html.li([], [
        html.a([attr.href("#data-types")], [html.text("Data types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#strings")], [html.text("Strings")])]),
          html.li([], [html.a([attr.href("#tuples")], [html.text("Tuples")])]),
          html.li([], [html.a([attr.href("#lists")], [html.text("Lists")])]),
          html.li([], [
            html.a([attr.href("#dictionaries")], [html.text("Dicts")]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#flow-control")], [html.text("Flow control")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#case")], [html.text("Case")])]),
          html.li([], [html.a([attr.href("#try")], [html.text("Try")])]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#type-aliases")], [html.text("Type aliases")]),
      ]),
      html.li([], [
        html.a([attr.href("#custom-types")], [html.text("Custom types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#records")], [html.text("Records")])]),
          html.li([], [html.a([attr.href("#unions")], [html.text("Unions")])]),
          html.li([], [
            html.a([attr.href("#opaque-custom-types")], [
              html.text("Opaque custom types"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#modules")], [html.text("Modules")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#imports")], [html.text("Imports")])]),
          html.li([], [
            html.a([attr.href("#named-imports")], [html.text("Named imports")]),
          ]),
          html.li([], [
            html.a([attr.href("#unqualified-imports")], [
              html.text("Unqualified imports"),
            ]),
          ]),
        ]),
      ]),
    ]),
    html.h2([attr.id("comments")], [html.text("Comments")]),
    html.h4([attr.id("python")], [html.text("Python")]),
    html.p([], [
      html.text("In Python, comments are written with a "),
      html.code([], [html.text("#")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "# Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "A docstring that occurs as the first statement in a module, function, class, or method definition will become the ",
      ),
      html.code([], [html.text("__doc__")]),
      html.text("attr of that object."),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def a_function():
    \"\"\"Return some important data.\"\"\"
    pass
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        " are used to document the following statement. Comments starting with ",
      ),
      html.code([], [html.text("////")]),
      html.text(" are used to document the current module."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
",
        ),
      ]),
    ]),
    html.h2([attr.id("variables")], [html.text("Variables")]),
    html.p([], [html.text("You can reassign variables in both languages.")]),
    html.h4([attr.id("python-1")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "size = 50
size = size + 100
size = 1
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Python has no specific variable keyword. You choose a name and that’s it!",
      ),
    ]),
    html.h4([attr.id("gleam-1")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam has the "),
      html.code([], [html.text("let")]),
      html.text("keyword before its variable names."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let size = 50
let size = size + 100
let size = 1
",
        ),
      ]),
    ]),
    html.h3([attr.id("match-operator")], [html.text("Match operator")]),
    html.h4([attr.id("python-2")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Python supports basic, one directional destructuring (also called unpacking).
Tuple of values can be unpacked and inner values can be assigned to left-hand variable names.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "(a, b) = (1, 2)
# a == 1
# b == 2

# works also for for-loops
for key, value in enumerate(a_dict):
    print(key, value)
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-2")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, "),
      html.code([], [html.text("let")]),
      html.text("and "),
      html.code([], [html.text("=")]),
      html.text(
        "can be used for pattern matching, but you’ll get compile errors if there’s a type mismatch, and a runtime error if there’s a value mismatch. For assertions, the equivalent ",
      ),
      html.code([], [html.text("let assert")]),
      html.text("keyword is preferred."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let #(x, _) = #(1, 2)
let assert [] = [1] // runtime error
let assert [y] = \"Hello\" // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h3([attr.id("variables-type-annotations")], [
      html.text("Variables type annotations"),
    ]),
    html.h4([attr.id("python-3")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Python is a dynamically typed language. Types are only checked at runtime and a variable can have different types in its lifetime.",
      ),
    ]),
    html.p([], [
      html.text(
        "Type hints are optional annotations that document the code with type information.
These annotations are accessible at runtime via the ",
      ),
      html.code([], [html.text("__annotations__")]),
      html.text("module-level variable."),
    ]),
    html.p([], [
      html.text(
        "These hints will mainly be used to inform static analysis tools like IDEs, linters…",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "some_list: list[int] = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-3")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam type annotations can optionally be given when binding variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let some_list: List(Int) = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Gleam will check the type annotation to ensure that it matches the type of the assigned value. It does not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.",
      ),
    ]),
    html.h2([attr.id("functions")], [html.text("Functions")]),
    html.h3([attr.id("python-4")], [html.text("Python")]),
    html.p([], [
      html.text("In Python, you can define functions with the "),
      html.code([], [html.text("def")]),
      html.text("keyword. In that case, you have to use the "),
      html.code([], [html.text("return")]),
      html.text("keyword to return a value other than "),
      html.code([], [html.text("None")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def sum(x, y):
    return x + y
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Anonymous functions returning a single expression can also be defined with the ",
      ),
      html.code([], [html.text("lambda")]),
      html.text("keyword and be assigned into variables."),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "mul = lambda x, y: x * y
mul(1, 2)
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-4")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s functions are declared using a syntax similar to Rust or JavaScript. Gleam’s anonymous functions have a similar syntax and don’t need a ",
      ),
      html.code([], [html.text(".")]),
      html.text("when called."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
",
        ),
      ]),
    ]),
    html.h3([attr.id("exporting-functions")], [html.text("Exporting functions")]),
    html.h4([attr.id("python-5")], [html.text("Python")]),
    html.p([], [
      html.text(
        "In Python, top level functions are exported by default. Functions starting with ",
      ),
      html.code([], [html.text("_")]),
      html.text(
        "are considered protected and should not be used outside of their defining scope.",
      ),
    ]),
    html.h4([attr.id("gleam-5")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, functions are private by default and need the "),
      html.code([], [html.text("pub")]),
      html.text("keyword to be public."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// this is public
pub fn sum(x, y) {
  x + y
}

// this is private
fn mul(x, y) {
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-type-annotations")], [
      html.text("Function type annotations"),
    ]),
    html.h4([attr.id("python-6")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Type hints can be used to optionally annotate function arguments and return types.",
      ),
    ]),
    html.p([], [
      html.text(
        "Discrepancies between type hints and actual values at runtime do not prevent interpretation of the code.",
      ),
    ]),
    html.p([], [
      html.text(
        "Static code analysers (IDE tooling, type checkers like mypy) are necessary to detect those errors.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def sum(x: int, y: int) -> int:
    return x + y

def mul(x: int, y: int) -> bool:
    # no errors from the interpreter.
    return x * y
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-6")], [html.text("Gleam")]),
    html.p([], [
      html.text("Functions can "),
      html.strong([], [html.text("optionally")]),
      html.text(
        " have their argument and return types annotated in Gleam. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool { // compile error, type mismatch
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("referencing-functions")], [
      html.text("Referencing functions"),
    ]),
    html.h4([attr.id("python-7")], [html.text("Python")]),
    html.p([], [
      html.text(
        "As long as functions are in scope they can be assigned to a new variable. There is no special syntax to assign a module function to a variable.",
      ),
    ]),
    html.h4([attr.id("gleam-7")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam has a single namespace for value and functions within a module, so there
is no need for a special syntax to assign a module function to a variable.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn identity(x) {
  x
}

fn main() {
  let func = identity
  func(100)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("labelled-arguments")], [html.text("Labelled arguments")]),
    html.p([], [
      html.text(
        "Both Python and Gleam have ways to give arguments names and in any order.",
      ),
    ]),
    html.h4([attr.id("python-8")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Keyword arguments are evaluated once at function definition time, and there is no evidence showing a noticeable performance penalty when using named arguments.",
      ),
    ]),
    html.p([], [html.text("When calling a function, arguments can be passed")]),
    html.ul([], [
      html.li([], [
        html.text("positionally, in the same order of the function declaration"),
      ]),
      html.li([], [html.text("by name, in any order")]),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def replace(inside: str, each: str, with_string: str):
    pass

# equivalent calls
replace('hello world', 'world', 'you')
replace(each='world', inside='hello world', with_string='you')
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-8")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam arguments can be given a label as well as an internal name. Contrary to Python, the name used at the call-site does not have to match the name used
for the variable inside the function.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "replace(each: \",\", with: \" \", inside: \"A,B,C\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "There is no performance cost to Gleam’s labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.",
      ),
    ]),
    html.h2([attr.id("operators")], [html.text("Operators")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Operator")]),
          html.th([], [html.text("Python")]),
          html.th([], [html.text("Gleam")]),
          html.th([], [html.text("Notes")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.text("Equal")]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Strictly equal to")]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [
            html.text(
              "Comparison in Gleam is always strict. (see note for Python)",
            ),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Reference equality")]),
          html.td([], [html.code([], [html.text("is")])]),
          html.td([], []),
          html.td([], [
            html.text("True only if the two objects have the same reference"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean and")]),
          html.td([], [html.code([], [html.text("and")])]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Logical and")]),
          html.td([], [html.code([], [html.text("and")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean or")]),
          html.td([], [html.code([], [html.text("or")])]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Logical or")]),
          html.td([], [html.code([], [html.text("or")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Remainder")]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
            html.text(", in Gleam negative values behave differently: Use "),
            html.code([], [html.text("int.modulo")]),
            html.text("to mimick Python’s behavior."),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Concatenate")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("<>")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("strings")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Pipe")]),
          html.td([], []),
          html.td([], [html.code([], [html.text("|>")])]),
          html.td([], [
            html.text(
              "Gleam’s pipe can pipe into anonymous functions. This operator does not exist in python",
            ),
          ]),
        ]),
      ]),
    ]),
    html.p([], [html.text("Some notes for Python:")]),
    html.ul([], [
      html.li([], [
        html.p([], [
          html.code([], [html.text("==")]),
          html.text("is by default comparing by value:"),
        ]),
        html.ul([], [
          html.li([], [
            html.text(
              "scalars will have their value compared
        ",
            ),
            html.ul([], [
              html.li([], [
                html.text("the only type cast will be for "),
                html.code([], [html.text("0")]),
                html.text("and "),
                html.code([], [html.text("1")]),
                html.text("that will be coerced to "),
                html.code([], [html.text("False")]),
                html.text("and "),
                html.code([], [html.text("True")]),
                html.text("respectively"),
              ]),
            ]),
          ]),
          html.li([], [
            html.text(
              "variables that point to the same object will be equal with ",
            ),
            html.code([], [html.text("==")]),
          ]),
        ]),
      ]),
      html.li([], [
        html.p([], [
          html.text("two objects with the same members values won’t be equal:"),
        ]),
        html.ul([], [
          html.li([], [
            html.text("no structural equality, "),
            html.em([], [html.text("unless")]),
            html.text("the "),
            html.code([], [html.text("__eq__")]),
            html.text("operator is redefined."),
          ]),
        ]),
      ]),
      html.li([], [
        html.text("Python operators are short-circuiting as in Gleam."),
      ]),
      html.li([], [
        html.text(
          "Python operators can be overloaded and be applied to any types with potential custom behaviors",
        ),
      ]),
    ]),
    html.h2([attr.id("constants")], [html.text("Constants")]),
    html.h4([attr.id("python-9")], [html.text("Python")]),
    html.p([], [
      html.text(
        "In Python, top-level declarations are in the global/module scope is the highest possible scope. Any variables and functions defined will be accessible from anywhere in the code.",
      ),
    ]),
    html.p([], [
      html.text("There is no notion of constant variables in Python."),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "from typing import Final

# in the global scope
THE_ANSWER: Final = 42
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-9")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam constants can be created using the "),
      html.code([], [html.text("const")]),
      html.text("keyword."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "const the_answer = 42

pub fn main() {
  the_answer
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("blocks")], [html.text("Blocks")]),
    html.h4([attr.id("python-10")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Python blocks are always associated with a function / conditional / class declarations… There is no way to create multi-line expressions blocks like in Gleam.",
      ),
    ]),
    html.p([], [html.text("Blocks are declared via indentation.")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def a_func():
    # A block here
    pass
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-10")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam braces "),
      html.code([], [html.text("{")]),
      html.code([], [html.text("}")]),
      html.text("are used to group expressions."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn main() {
  let x = {
    some_function(1)
    2
  }
  let y = x * {x + 10} // braces are used to change arithmetic operations order
  y
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("data-types")], [html.text("Data types")]),
    html.h3([attr.id("strings")], [html.text("Strings")]),
    html.p([], [
      html.text(
        "In Python, strings are stored as unicode code-points sequence. Strings can be encoded or decoded to/from a specific encoding.",
      ),
    ]),
    html.p([], [html.text("In Gleam all strings are UTF-8 encoded binaries.")]),
    html.h4([attr.id("python-11")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-11")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("tuples")], [html.text("Tuples")]),
    html.p([], [
      html.text(
        "Tuples are very useful in Gleam as they’re the only collection data type that allows mixed types in the collection.",
      ),
    ]),
    html.h4([attr.id("python-12")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Python tuples are immutable, fixed-size lists that can contain mixed value types. Unpacking can be used to bind a name to a specific value of the tuple.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "my_tuple = (\"username\", \"password\", 10)
_, password, _ = my_tuple
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-12")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let my_tuple = #(\"username\", \"password\", 10)
let #(_, password, _) = my_tuple
",
        ),
      ]),
    ]),
    html.h3([attr.id("lists")], [html.text("Lists")]),
    html.p([], [
      html.text(
        "Lists in Python are allowed to have values of mixed types, but not in Gleam.",
      ),
    ]),
    html.h4([attr.id("python-13")], [html.text("Python")]),
    html.p([], [
      html.text("Python can emulate the "),
      html.code([], [html.text("cons")]),
      html.text("operator of Gleam using the "),
      html.code([], [html.text("*")]),
      html.text("operator and unpacking:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "list = [2, 3, 4]
[head, *tail] = list
# head == 2
# tail == [3, 4]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-13")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam has a "),
      html.code([], [html.text("..")]),
      html.text("(known as "),
      html.code([], [html.text("cons")]),
      html.text(
        ") operator that works for lists destructuring and pattern matching. In Gleam lists are immutable so adding and removing elements from the start of a list is highly efficient.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h3([attr.id("dictionaries")], [html.text("Dictionaries")]),
    html.p([], [
      html.text("In Python, dictionaries can have keys of any type as long as:"),
    ]),
    html.ul([], [
      html.li([], [
        html.text("the key type is "),
        html.code([], [html.text("hashable")]),
        html.text(
          ", such as integers, strings, tuples (due to their immutable values), functions… and custom objects implementing the ",
        ),
        html.code([], [html.text("__hash__")]),
        html.text("method."),
      ]),
      html.li([], [
        html.text(
          "the key is unique in the dictionary.
and values of any type.",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "In Gleam, dicts can have keys and values of any type, but all keys must be of the same type in a given dict and all values must be of the same type in a given dict.",
      ),
    ]),
    html.p([], [
      html.text(
        "There is no dict literal syntax in Gleam, and you cannot pattern match on a dict. Dicts are generally not used much in Gleam, as custom types are more common.",
      ),
    ]),
    html.h4([attr.id("python-14")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "{\"key1\": \"value1\", \"key2\": \"value2\"}
{\"key1\": \"1\", \"key2\": 2}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-14")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import gleam/dict

dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", \"value2\")])
dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", 2)]) // Type error!
",
        ),
      ]),
    ]),
    html.h2([attr.id("flow-control")], [html.text("Flow control")]),
    html.h3([attr.id("case")], [html.text("Case")]),
    html.p([], [
      html.text(
        "Case is one of the most used control flows in Gleam. It can be seen as a switch
statement on steroids. It provides a terse way to match a value type to an
expression. Gleam’s ",
      ),
      html.code([], [html.text("case")]),
      html.text("expression is fairly similar to Python’s "),
      html.code([], [html.text("match")]),
      html.text("statement."),
    ]),
    html.h4([attr.id("python-15")], [html.text("Python")]),
    html.p([], [html.text("Matching on primitive types:")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def http_error(status):
    match status:
        case 400:
            return \"Bad request\"
        case 404:
            return \"Not found\"
        case 418:
            return \"I'm a teapot\"
",
        ),
      ]),
    ]),
    html.p([], [html.text("Matching on tuples with variable capturing:")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "match point:
    case (0, 0):
        print(\"Origin\")
    case (0, y):
        print(f\"Y={y}\")
    case (x, 0):
        print(f\"X={x}\")
    case (x, y):
        print(f\"X={x}, Y={y}\")
    case _:
        raise ValueError(\"Not a point\")
",
        ),
      ]),
    ]),
    html.p([], [html.text("Matching on type constructors:")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "match point:
    case Point(x=0, y=0):
        print(\"Origin is the point's location.\")
    case Point(x=0, y=y):
        print(f\"Y={y} and the point is on the y-axis.\")
    case Point(x=x, y=0):
        print(f\"X={x} and the point is on the x-axis.\")
    case Point():
        print(\"The point is located somewhere else on the plane.\")
    case _:
        print(\"Not a point\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("The match expression supports guards, similar to Gleam:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "match point:
    case Point(x, y) if x == y:
        print(f\"The point is located on the diagonal Y=X at {x}.\")
    case Point(x, y):
        print(f\"Point is not on the diagonal.\")
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-15")], [html.text("Gleam")]),
    html.p([], [
      html.text("The case operator is a top level construct in Gleam:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case some_number {
  0 -> \"Zero\"
  1 -> \"One\"
  2 -> \"Two\"
  n -> \"Some other number\" // This matches anything
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "The case operator especially coupled with destructuring to provide native pattern matching:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case xs {
  [] -> \"This list is empty\"
  [a] -> \"This list has 1 element\"
  [a, b] -> \"This list has 2 elements\"
  _other -> \"This list has more than 2 elements\"
}
",
        ),
      ]),
    ]),
    html.p([], [html.text("The case operator supports guards:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case xs {
  [a, b, c] if a >. b && a <=. c -> \"ok\"
  _other -> \"ko\"
}
",
        ),
      ]),
    ]),
    html.p([], [html.text("and disjoint union matching:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case number {
  2 | 4 | 6 | 8 -> \"This is an even number\"
  1 | 3 | 5 | 7 -> \"This is an odd number\"
  _ -> \"I'm not sure\"
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("try")], [html.text("Try")]),
    html.p([], [
      html.text(
        "Error management is approached differently in Python and Gleam.",
      ),
    ]),
    html.h4([attr.id("python-16")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Python uses the notion of exceptions to interrupt the current code flow and propagate the error to the caller.",
      ),
    ]),
    html.p([], [
      html.text("An exception is raised using the keyword "),
      html.code([], [html.text("raise")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def a_function_that_fails():
    raise Exception(\"an error\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "The callee block will be able to capture any exception raised in the block using a ",
      ),
      html.code([], [html.text("try/except")]),
      html.text("set of blocks:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "try:
    print(\"executed\")
    a_function_that_fails()
    print(\"not_executed\")
except Exception as e:
    print(\"doing something with the exception\", e)

",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-16")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In contrast in Gleam, errors are just containers with an associated value.",
      ),
    ]),
    html.p([], [
      html.text("A common container to model an operation result is "),
      html.code([], [html.text("Result(ReturnType, ErrorType)")]),
      html.text("."),
    ]),
    html.p([], [html.text("A Result is either:")]),
    html.ul([], [
      html.li([], [
        html.text("an "),
        html.code([], [html.text("Error(ErrorValue)")]),
      ]),
      html.li([], [
        html.text("or an "),
        html.code([], [html.text("Ok(Data)")]),
        html.text("record"),
      ]),
    ]),
    html.p([], [
      html.text(
        "Handling errors actually means to match the return value against those two scenarios, using a case for instance:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case int.parse(\"123\") {
  Error(e) -> io.println(\"That wasn't an Int\")
  Ok(i) -> io.println(\"We parsed the Int\")
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("In order to simplify this construct, we can use the "),
      html.code([], [html.text("use")]),
      html.text(
        "expression with the
",
      ),
      html.code([], [html.text("try")]),
      html.text("function from the "),
      html.code([], [html.text("gleam/result")]),
      html.text("module."),
    ]),
    html.ul([], [
      html.li([], [
        html.text("bind a value to the providing name if "),
        html.code([], [html.text("Ok(Something)")]),
        html.text("is matched"),
      ]),
      html.li([], [
        html.strong([], [html.text("interrupt the flow")]),
        html.text("and return "),
        html.code([], [html.text("Error(Something)")]),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let a_number = \"1\"
let an_error = \"ouch\"
let another_number = \"3\"

use int_a_number <- try(parse_int(a_number))
use attempt_int <- try(parse_int(an_error)) // Error will be returned
use int_another_number <- try(parse_int(another_number)) // never gets executed

Ok(int_a_number + attempt_int + int_another_number) // never gets executed
",
        ),
      ]),
    ]),
    html.h2([attr.id("type-aliases")], [html.text("Type aliases")]),
    html.p([], [
      html.text(
        "Type aliases allow for easy referencing of arbitrary complex types. Even though their type systems does not serve the same function, both Python and Gleam provide this feature.",
      ),
    ]),
    html.h3([attr.id("python-17")], [html.text("Python")]),
    html.p([], [
      html.text(
        "A simple variable can store the result of a compound set of types.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "type Headers = list[tuple[str, str]]

# can now be used to annotate a variable
headers: Headers = [(\"Content-Type\", \"application/json\")]
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-17")], [html.text("Gleam")]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("type")]),
      html.text("keyword can be used to create aliases:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub type Headers =
  List(#(String, String))

let headers: Headers = [#(\"Content-Type\", \"application/json\")]
",
        ),
      ]),
    ]),
    html.h2([attr.id("custom-types")], [html.text("Custom types")]),
    html.h3([attr.id("records")], [html.text("Records")]),
    html.p([], [
      html.text(
        "Custom type allows you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.",
      ),
    ]),
    html.h4([attr.id("python-18")], [html.text("Python")]),
    html.p([], [
      html.text(
        "Python uses classes to define user-defined, record-like types.
Properties are defined as class members and initial values are generally set in the constructor.",
      ),
    ]),
    html.p([], [
      html.text(
        "By default the constructor does not provide base initializers in the constructor so some boilerplate is needed:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "class Person:
    name: str
    age: int

    def __init__(self, name: str, age: int) -> None:
        self.name = name
        self.age = age

person = Person(name=\"Jake\", age=20)
# or with positional arguments Person(\"Jake\", 20)
name = person.name
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("More recent alternatives use "),
      html.code([], [html.text("dataclasses")]),
      html.text(
        "or leverage the
",
      ),
      html.code([], [html.text("NamedTuple")]),
      html.text("base type to generate a constructor with initializers."),
    ]),
    html.p([], [
      html.text("By default a class created with the "),
      html.code([], [html.text("dataclass")]),
      html.text(
        "decorator is mutable (although
you can pass options to the ",
      ),
      html.code([], [html.text("dataclass")]),
      html.text("decorator to change the behavior):"),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "from dataclasses import dataclass

@dataclass
class Person:
    name: str
    age: int

person = Person(name=\"Jake\", age=20)
name = person.name
person.name = \"John\"  # The name is now \"John\"
",
        ),
      ]),
    ]),
    html.p([], [
      html.code([], [html.text("NamedTuples")]),
      html.text("on the other hand are immutable:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "from typing import NamedTuple

class Person(NamedTuple):
    name: str
    age: int

person = Person(name=\"Jake\", age=20)
name = person.name

# cannot reassign a value
person.name = \"John\"  # error
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-18")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s custom types can be used in much the same way that structs are used in Elixir. At runtime, they have a tuple representation and are compatible with Erlang records.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Person {
  Person(name: String, age: Int)
}

let person = Person(name: \"Jake\", age: 35)
let name = person.name
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "An important difference to note is there is no OOP in Gleam. Methods can not be added to types.",
      ),
    ]),
    html.h3([attr.id("unions")], [html.text("Unions")]),
    html.p([], [
      html.text("In Python unions can be declared with the "),
      html.code([], [html.text("|")]),
      html.text("operator."),
    ]),
    html.p([], [
      html.text(
        "In Gleam functions must always take and receive one type. To have a union of
two different types they must be wrapped in a new custom type.",
      ),
    ]),
    html.h4([attr.id("python-19")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "def int_or_float(x: int | float) -> str:
    if isinstance(x, int):
        return f\"It's an integer: {x}\"
    else:
        return f\"It's a float: {x}\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-19")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type IntOrFloat {
  AnInt(Int)
  AFloat(Float)
}

fn int_or_float(x: IntOrFloat) {
  case x {
    AnInt(1) -> \"It's an integer: 1\"
    AFloat(1.0) -> \"It's a float: 1.0\"
  }
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("opaque-custom-types")], [html.text("Opaque custom types")]),
    html.p([], [
      html.text(
        "In Python, constructors cannot be marked as private. Opaque types can be
imperfectly emulated using a class method and some magic property that only
updates via the class factory method.",
      ),
    ]),
    html.p([], [
      html.text(
        "In Gleam, custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.",
      ),
    ]),
    html.h4([attr.id("python-20")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "from typing import NewType

# Is protected: people must not use it out side of this module!
_Identifier = NewType('Identifier', int)

def get_id() -> _Identifier:
    return _Identifier(100)
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-20")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub opaque type Identifier {
  Identifier(Int)
}

pub fn get_id() {
  Identifier(100)
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("modules")], [html.text("Modules")]),
    html.h4([attr.id("python-21")], [html.text("Python")]),
    html.p([], [
      html.text(
        "There is no special syntax to define modules as files are modules in Python",
      ),
    ]),
    html.h4([attr.id("gleam-21")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s file is a module and named by the file name (and its directory path). Since there is no special syntax to create a module, there can be only one module in a file.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file wibble.gleam
pub fn identity(x) {
  x
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file main.gleam
import wibble // if wibble was in a folder called `lib` the import would be `lib/wibble`
pub fn main() {
  wibble.identity(1)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("imports")], [html.text("Imports")]),
    html.h4([attr.id("python-22")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "# inside module src/nasa/moon_base.py
# imports module src/nasa/rocket_ship.py
from nasa import rocket_ship

def explore_space():
    rocket_ship.launch()
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-22")], [html.text("Gleam")]),
    html.p([], [
      html.text("Imports are relative to the root "),
      html.code([], [html.text("src")]),
      html.text("folder."),
    ]),
    html.p([], [
      html.text(
        "Modules in the same directory will need to reference the entire path from ",
      ),
      html.code([], [html.text("src")]),
      html.text(
        "for the target module, even if the target module is in the same folder.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// inside module src/nasa/moon_base.gleam
// imports module src/nasa/rocket_ship.gleam
import nasa/rocket_ship

pub fn explore_space() {
  rocket_ship.launch()
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("named-imports")], [html.text("Named imports")]),
    html.h4([attr.id("python-23")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "import unix.cat as kitty
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-23")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import unix/cat as kitty
",
        ),
      ]),
    ]),
    html.h3([attr.id("unqualified-imports")], [html.text("Unqualified imports")]),
    html.h4([attr.id("python-24")], [html.text("Python")]),
    html.pre([], [
      html.code([attr.class("language-python")], [
        html.text(
          "from animal.cat import Cat, stroke

def main():
    kitty = Cat(name=\"Nubi\")
    stroke(kitty)
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-24")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import animal/cat.{Cat, stroke}

pub fn main() {
  let kitty = Cat(name: \"Nubi\")
  stroke(kitty)
}
",
        ),
      ]),
    ]),
  ]
  |> layout.with_header("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn php(ctx: site.Context) -> fs.File {
  let meta =
    site.PageMeta(
      path: "cheatsheets/gleam-for-php-users",
      title: "Gleam for PHP users",
      meta_title: "Gleam for PHP users | Cheat sheets",
      subtitle: "Hello Hypertext crafters!",
      description: "A handy reminder of Gleam syntax for all Hypertext crafters out there.",
      preload_images: [],
      preview_image: option.None,
    )
  [
    html.ul([], [
      html.li([], [html.a([attr.href("#comments")], [html.text("Comments")])]),
      html.li([], [
        html.a([attr.href("#variables")], [html.text("Variables")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#match-operator")], [html.text("Match operator")]),
          ]),
          html.li([], [
            html.a([attr.href("#variables-type-annotations")], [
              html.text("Variables type annotations"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#functions")], [html.text("Functions")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#exporting-functions")], [
              html.text("Exporting functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-type-annotations")], [
              html.text("Function type annotations"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#referencing-functions")], [
              html.text("Referencing functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#labelled-arguments")], [
              html.text("Labelled arguments"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#operators")], [html.text("Operators")])]),
      html.li([], [html.a([attr.href("#constants")], [html.text("Constants")])]),
      html.li([], [html.a([attr.href("#blocks")], [html.text("Blocks")])]),
      html.li([], [
        html.a([attr.href("#data-types")], [html.text("Data types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#strings")], [html.text("Strings")])]),
          html.li([], [html.a([attr.href("#tuples")], [html.text("Tuples")])]),
          html.li([], [html.a([attr.href("#lists")], [html.text("Lists")])]),
          html.li([], [html.a([attr.href("#dicts")], [html.text("Dicts")])]),
          html.li([], [html.a([attr.href("#numbers")], [html.text("Numbers")])]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#flow-control")], [html.text("Flow control")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#case")], [html.text("Case")])]),
          html.li([], [html.a([attr.href("#piping")], [html.text("Piping")])]),
          html.li([], [html.a([attr.href("#try")], [html.text("Try")])]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#type-aliases")], [html.text("Type aliases")]),
      ]),
      html.li([], [
        html.a([attr.href("#custom-types")], [html.text("Custom types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#records")], [html.text("Records")])]),
          html.li([], [html.a([attr.href("#unions")], [html.text("Unions")])]),
          html.li([], [
            html.a([attr.href("#opaque-custom-types")], [
              html.text("Opaque custom types"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#modules")], [html.text("Modules")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#imports")], [html.text("Imports")])]),
          html.li([], [
            html.a([attr.href("#named-imports")], [html.text("Named imports")]),
          ]),
          html.li([], [
            html.a([attr.href("#unqualified-imports")], [
              html.text("Unqualified imports"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#architecture")], [html.text("Architecture")]),
      ]),
    ]),
    html.h2([attr.id("comments")], [html.text("Comments")]),
    html.h3([attr.id("php")], [html.text("PHP")]),
    html.p([], [
      html.text("In PHP, comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [html.text("Multi line comments may be written like so:")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "/*
 * Hello, Joe!
 */
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("In PHP, above "),
      html.code([], [html.text("trait")]),
      html.text(", "),
      html.code([], [html.text("interface")]),
      html.text(", "),
      html.code([], [html.text("class")]),
      html.text(", "),
      html.code([], [html.text("member")]),
      html.text(", "),
      html.code([], [html.text("function")]),
      html.text(
        "declarations
there can be ",
      ),
      html.code([], [html.text("docblocks")]),
      html.text("like so:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "/**
 * a very special trait.
 */
trait Wibble {}

/**
 * A Wabble class
 */
class Wabble {}

/**
 * A wubble function.
 *
 * @var string $str        String passed to wubble
 * @return string          An unprocessed string
 */
function wubble(string $str) : string { return $str; }
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Documentation blocks (docblocks) are extracted into generated API
documentation.",
      ),
    ]),
    html.h3([attr.id("gleam")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        "are used to document the following function,
constant, or type definition. Comments starting with ",
      ),
      html.code([], [html.text("////")]),
      html.text(
        "are used to
document the current module.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42

/// A main function
fn main() {}

/// A Dog type
type Dog {
  Dog(name: String, cuteness: Int)
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.code([], [html.text("//")]),
      html.text(
        "comments are not used while generating documentation files, while
",
      ),
      html.code([], [html.text("////")]),
      html.text("and "),
      html.code([], [html.text("///")]),
      html.text("will appear in them."),
    ]),
    html.h2([attr.id("variables")], [html.text("Variables")]),
    html.p([], [html.text("You can rebind variables in both languages.")]),
    html.h3([attr.id("php-1")], [html.text("PHP")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$size = 50;
$size = $size + 100;
$size = 1;
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "In local scope PHP has no specific variable keyword. You choose a name
and that’s it!",
      ),
    ]),
    html.p([], [
      html.text(
        "In class scope for property declaration PHP uses at least one related
modifier keyword to create properties such as: ",
      ),
      html.code([], [html.text("public")]),
      html.text(", "),
      html.code([], [html.text("private")]),
      html.text(
        ",
",
      ),
      html.code([], [html.text("protected")]),
      html.text(", "),
      html.code([], [html.text("static")]),
      html.text("or "),
      html.code([], [html.text("readonly")]),
      html.text("("),
      html.code([], [html.text("var")]),
      html.text("is deprecated)."),
    ]),
    html.h3([attr.id("gleam-1")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam has the "),
      html.code([], [html.text("let")]),
      html.text("keyword before its variable names."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let size = 50
let size = size + 100
let size = 1
",
        ),
      ]),
    ]),
    html.h3([attr.id("match-operator")], [html.text("Match operator")]),
    html.h4([attr.id("php-2")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP supports basic, one directional destructuring (also called unpacking).
Tuple of values can be unpacked and inner values can be assigned to left-hand
variable names.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "[$a, $b] = [1, 2];
// $a == 1
// $b == 2

[1 => $idx2] = ['wibble', 'wabble', 'wubble'];
// $idx2 == 'wabble'

[\"profession\" => $job] = ['name' => 'Joe', 'profession' => 'hacker'];
// $job == 'hacker'
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-2")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, "),
      html.code([], [html.text("let")]),
      html.text("and "),
      html.code([], [html.text("=")]),
      html.text(
        "can be used for pattern matching, but you’ll get
compile errors if there’s a type mismatch, and a runtime error if there’s
a value mismatch. For assertions, the equivalent ",
      ),
      html.code([], [html.text("let assert")]),
      html.text(
        "keyword is
preferred.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let #(a, _) = #(1, 2)
// a = 1
// `_` matches 2 and is discarded

let assert [] = [1] // runtime error
let assert [y] = \"Hello\" // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.p([], [html.text("Asserts should be used with caution.")]),
    html.h3([attr.id("variables-type-annotations")], [
      html.text("Variables type annotations"),
    ]),
    html.h4([attr.id("php-3")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP is a dynamically typed language. Types are only checked at runtime and
a variable can have different types in its lifetime.",
      ),
    ]),
    html.p([], [
      html.text(
        "PHP gradually introduced more and more type hints that are optional.
The type information is accessible via ",
      ),
      html.code([], [html.text("get_type()")]),
      html.text("at runtime."),
    ]),
    html.p([], [
      html.text(
        "These hints will mainly be used to inform static analysis tools like IDEs,
linters, etc.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class Wibble {
  private ?string $wabble;
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("PHP’s "),
      html.code([], [html.text("array")]),
      html.text("structure is an "),
      html.em([], [html.text("ordered map")]),
      html.text(
        ", as stated in the PHP manual,
and it can be treated as an array, dictionary, etc.
While creating arrays in PHP the type of its elements cannot be set explicitly
and each element can be of a different type:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$someList = [1, 2, 3];
$someTuple = [1, \"a\", true];
$someMap = [0 => 1, \"wibble\" => \"wabble\", true => false];
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Single variables cannot be type-annotated unless they are "),
      html.code([], [html.text("class")]),
      html.text("or "),
      html.code([], [html.text("trait")]),
      html.text("members."),
    ]),
    html.h4([attr.id("gleam-3")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam type annotations can optionally be given when binding variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let some_list: List(Int) = [1, 2, 3]
let some_string: String = \"Wibble\"
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Gleam will check the type annotation to ensure that it matches the type of the
assigned value. It does not need annotations to type check your code, but you
may find it useful to annotate variables to hint to the compiler that you want
a specific type to be inferred.",
      ),
    ]),
    html.h2([attr.id("functions")], [html.text("Functions")]),
    html.h3([attr.id("php-4")], [html.text("PHP")]),
    html.p([], [
      html.text("In PHP, you can define functions with the "),
      html.code([], [html.text("function")]),
      html.text("keyword. One or many "),
      html.code([], [html.text("return")]),
      html.text("keywords are optional."),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "function hello($name = 'Joe') : string
{
  if ($name == 'Joe') {
    return 'Welcome back, Joe!';
  }
  return \"Hello $name\";
}

function noop()
{
  // Will automatically return NULL
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Anonymous functions returning a single expression can also be defined and be
bound to variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$x = 2;
$phpAnonFn = function($y) use ($x) { return $x * $y; }; // Creates a new scope
$phpAnonFn(3); // 6
$phpArrowFn = fn ($y) => $x * $y; // Inherits the outer scope
$phpArrowFn(3); // 6
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-4")], [html.text("Gleam")]),
    html.p([], [html.text("Gleam’s functions are declared like so:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn sum(x, y) {
  x + y
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Gleam’s anonymous functions have the same basic syntax."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let mul = fn(x, y) { x * y }
mul(1, 2)
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "A difference between PHP’s and Gleam’s anonymous functions is that in PHP they
create a new local scope, in Gleam they close over the local scope, aka create
a copy and inherit all variables in the scope. This means that in Gleam you can
shadow local variables within anonymous functions but you cannot influence the
variable bindings in the outer scope. This is different for PHP’s arrow
functions where they inherit the scope like Gleam does.",
      ),
    ]),
    html.p([], [
      html.text(
        "The only difference between module functions and anonymous functions in Gleam
is that module functions heads may also feature argument labels, like so:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// In some module.gleam
pub fn distance(from x: Int, to y: Int) -> Int {
  x - y |> int.absolute_value()
}
// In some other function
distance(from: 1, to: -2) // 3
",
        ),
      ]),
    ]),
    html.h3([attr.id("exporting-functions")], [html.text("Exporting functions")]),
    html.h4([attr.id("php-5")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "In PHP, top level functions are exported by default. There is no notion of
private module-level functions.",
      ),
    ]),
    html.p([], [
      html.text(
        "However at class level, all properties are public, by default.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class Wibble {
  static $wabble = 5;
  private $wubble = 6;

  static function wobble() {
    return \"Hello Joe!\";
  }

  private static function webble() {
    return \"Hello Rasmus!\";
  }
}
echo Wibble::$wabble; // 5
echo Wibble::$wubble; // Error
echo Wibble::wobble(); // \"Hello Joe\"
echo Wibble::webble(); // Error
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-5")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, functions are private by default and need the "),
      html.code([], [html.text("pub")]),
      html.text(
        "keyword to be
marked as public.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// this is public
pub fn sum(x, y) {
  x + y
}

// this is private
fn mul(x, y) {
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("php-6")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "Global functions may exist in a global scope, and to execute functions or
create objects and invoke methods at some point they have to be called from
the global scope. Usually there is one ",
      ),
      html.code([], [html.text("index.php")]),
      html.text(
        "file whose global scope
acts as if it was the ",
      ),
      html.code([], [html.text("main()")]),
      html.text("function."),
    ]),
    html.h3([attr.id("gleam-6")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam does not support a global scope. Instead Gleam code is either
representing a library, which can be required as a dependency, and/or it
represents an application having a main module, whose name must match to the
application name and within that ",
      ),
      html.code([], [html.text("main()")]),
      html.text(
        "-function which will be called via
either ",
      ),
      html.code([], [html.text("gleam run")]),
      html.text("or when the "),
      html.code([], [html.text("entrypoint.sh")]),
      html.text("is executed."),
    ]),
    html.p([], [
      html.text(
        "In contrast to PHP, where any PHP file can contain a global scope that can
be invoked by requiring the file, in Gleam only code that is within functions
can be invoked.",
      ),
    ]),
    html.p([], [
      html.text(
        "On the Beam, Gleam code can also be invoked from other Erlang code, or it
can be invoked from browser’s JavaScript, Deno or NodeJS runtime calls.",
      ),
    ]),
    html.h3([attr.id("function-type-annotations")], [
      html.text("Function type annotations"),
    ]),
    html.h4([attr.id("php-7")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "Type hints can be used to optionally annotate function arguments and return
types.",
      ),
    ]),
    html.p([], [
      html.text(
        "Discrepancies between type hints and actual values at runtime do not prevent
interpretation of the code. Static code analysers (IDE tooling, type checkers
like ",
      ),
      html.code([], [html.text("phpstan")]),
      html.text(") will be required to detect those errors."),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "function sum(int $x, int $y) : int {
    return $x + $y;
}

function mul(int $x, int $y) : bool {
    # no errors from the interpreter.
    return $x * $y;
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-7")], [html.text("Gleam")]),
    html.p([], [
      html.text("Functions can "),
      html.strong([], [html.text("optionally")]),
      html.text(
        " have their argument and return types annotated in
Gleam. These type annotations will always be checked by the compiler and throw
a compilation error if not valid. The compiler will still type check your
program using type inference if annotations are omitted.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn add(x: Int, y: Int) -> Int {
  x + y
}

fn mul(x: Int, y: Int) -> Bool {
  x * y // compile error, type mismatch
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("referencing-functions")], [
      html.text("Referencing functions"),
    ]),
    html.h4([attr.id("php-8")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "As long as functions are in scope they can be assigned to a new variable.
As methods or static functions classes, functions can be accessed via
",
      ),
      html.code([], [html.text("$this->object_instance_method()")]),
      html.text("or "),
      html.code([], [html.text("self::static_class_function()")]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "Other than that only anonymous functions can be moved around the same way as
other values.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$doubleFn = function($x) { return $x + $x; };
// Some imaginary pushFunction
pushFunction($queue, $doubleFn);
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("However in "),
      html.code([], [html.text("PHP")]),
      html.text(
        "it is not possible to pass around global, class or instance
functions as values.",
      ),
    ]),
    html.h4([attr.id("gleam-8")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam has a single namespace for constants and functions within a module, so
there is no need for a special syntax to assign a module function to a
variable.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn identity(x) {
  x
}

fn main() {
  let func = identity
  func(100)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("labelled-arguments")], [html.text("Labelled arguments")]),
    html.p([], [
      html.text(
        "Both PHP and Gleam have ways to give arguments names and in any order.",
      ),
    ]),
    html.h4([attr.id("php-9")], [html.text("PHP")]),
    html.p([], [html.text("When calling a function, arguments can be passed:")]),
    html.ul([], [
      html.li([], [
        html.text("positionally, in the same order of the function declaration"),
      ]),
      html.li([], [html.text("by name, in any order")]),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// Some imaginary replace function
function replace(string $each, string $with, string $inside) {
  // TODO implementation
}
// Calling with positional arguments:
replace(\",\", \" \", \"A,B,C\");
// Calling with named arguments:
replace(inside: \"A,B,C\", each: \",\", with: \" \");
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-9")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam arguments can be given a label as well as an internal name.
Contrary to PHP, the name used at the call-site does not have to match
the name used for the variable inside the function.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn replace(inside str, each pattern, with replacement) {
  todo
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "replace(\",\", \" \", \"A,B,C\")
replace(inside: \"A,B,C\", each: \",\", with: \" \")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "There is no performance cost to Gleam’s labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.",
      ),
    ]),
    html.h2([attr.id("operators")], [html.text("Operators")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Operator")]),
          html.th([], [html.text("PHP")]),
          html.th([], [html.text("Gleam")]),
          html.th([], [html.text("Notes")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.text("Equal")]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Strictly equal to")]),
          html.td([], [html.code([], [html.text("===")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [
            html.text(
              "Comparison in Gleam is always strict. (see note for PHP)",
            ),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Reference equality")]),
          html.td([], [html.code([], [html.text("instanceof")])]),
          html.td([], []),
          html.td([], [
            html.text("True only if an object is an instance of a class"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("!==")])]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [
            html.text("Comparison in Gleam is always strict (see note for PHP)"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean and")]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Bool")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Logical and")]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean or")]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Bool")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Logical or")]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean not")]),
          html.td([], [html.code([], [html.text("xor")])]),
          html.td([], []),
          html.td([], [html.text("Not available in Gleam")]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean not")]),
          html.td([], [html.code([], [html.text("!")])]),
          html.td([], [html.code([], [html.text("!")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Bool")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Float")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Remainder")]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("Int")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Concatenate")]),
          html.td([], [html.code([], [html.text(".")])]),
          html.td([], [html.code([], [html.text("<>")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("String")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Pipe")]),
          html.td([], [html.code([], [html.text("->")])]),
          html.td([], [html.code([], [html.text("|>")])]),
          html.td([], [
            html.text("Gleam’s pipe can chain function calls. See note for PHP"),
          ]),
        ]),
      ]),
    ]),
    html.h3([attr.id("notes-on-operators")], [html.text("Notes on operators")]),
    html.ul([], [
      html.li([], [
        html.text(
          "For bitwise operators, which exist in PHP but not in Gleam,
see: ",
        ),
        html.a([attr.href("https://github.com/gleam-lang/bitwise")], [
          html.text("https://github.com/gleam-lang/bitwise"),
        ]),
        html.text("."),
      ]),
      html.li([], [
        html.code([], [html.text("==")]),
        html.text(
          "is by default comparing by value in PHP:
    ",
        ),
        html.ul([], [
          html.li([], [html.text("Types may be autocast to be comparable.")]),
          html.li([], [
            html.text("Two objects with the same members values will equal."),
          ]),
        ]),
      ]),
      html.li([], [
        html.code([], [html.text("===")]),
        html.text(
          "is for comparing by strict equality in PHP:
    ",
        ),
        html.ul([], [
          html.li([], [html.text("Types will not be autocast for comparison")]),
          html.li([], [
            html.text(
              "Two objects with the same members will not equal. Only if a variable binds
to the same reference it will equal.",
            ),
          ]),
        ]),
      ]),
      html.li([], [html.text("PHP operators are short-circuiting as in Gleam.")]),
      html.li([], [
        html.text(
          "Chains and pipes:
    ",
        ),
        html.ul([], [
          html.li([], [
            html.text(
              "In PHP chaining is usually done by constructing class methods that return
an object: ",
            ),
            html.code([], [html.text("$wibble->wabble(1)->wubble(2)")]),
            html.text("means "),
            html.code([], [html.text("wabble(1)")]),
            html.text(
              "is called as a method
of ",
            ),
            html.code([], [html.text("$wibble")]),
            html.text("and then "),
            html.code([], [html.text("wubble()")]),
            html.text(
              "is called as a method of the return value
(object) of the ",
            ),
            html.code([], [html.text("wabble(1)")]),
            html.text(
              "call. The objects in this chain usually
mutate to keep the changed state and carry it forward in the chain.",
            ),
          ]),
          html.li([], [
            html.text(
              "In contrast in Gleam piping, no objects are being returned but mere data
is pushed from left to right much like in unix tooling.",
            ),
          ]),
        ]),
      ]),
    ]),
    html.h2([attr.id("constants")], [html.text("Constants")]),
    html.h3([attr.id("php-10")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "In PHP, constants can only be defined within classes and traits.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class TheQuestion {
  public const theAnswer = 42;
}
echo TheQuestion::theAnswer; // 42
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-10")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam constants can be created using the "),
      html.code([], [html.text("const")]),
      html.text("keyword."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// the_question.gleam module
const the_answer = 42

pub fn main() {
  the_answer
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("They can also be marked public via the "),
      html.code([], [html.text("pub")]),
      html.text(
        "keyword and will then be
automatically exported.",
      ),
    ]),
    html.h2([attr.id("blocks")], [html.text("Blocks")]),
    html.h3([attr.id("php-11")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP blocks are always associated with a function / conditional / loop or
similar declaration. Blocks are limited to specific language constructs.
There is no way to create multi-line expressions blocks like in Gleam.",
      ),
    ]),
    html.p([], [html.text("Blocks are declared via curly braces.")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "function a_func() {
  // A block starts here
  if ($wibble) {
    // A block here
  } else {
    // A block here
  }
  // Block continues
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-11")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam curly braces, "),
      html.code([], [html.text("{")]),
      html.text("and "),
      html.code([], [html.text("}")]),
      html.text(", are used to group expressions."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn main() {
  let x = {
    some_function(1)
    2
  }
  // Braces are used to change precedence of arithmetic operators
  let y = x * {x + 10}
  y
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Unlike in PHP, in Gleam function blocks are always expressions, so are ",
      ),
      html.code([], [html.text("case")]),
      html.text(
        "blocks or arithmetic sub groups. Because they are expressions they always
return a value.",
      ),
    ]),
    html.p([], [
      html.text(
        "For Gleam the last value in a block’s expression is always the value being
returned from an expression.",
      ),
    ]),
    html.h2([attr.id("data-types")], [html.text("Data types")]),
    html.h3([attr.id("strings")], [html.text("Strings")]),
    html.p([], [
      html.text(
        "In PHP strings are stored as an array of bytes and an integer indicating the
length of the buffer. PHP itself has no information about how those bytes
translate to characters, leaving that task to the programmer. PHP’s
standard library however features a bunch of multi-byte compatible functions
and conversion functions between UTF-8, ISO-8859-1 and further encodings.",
      ),
    ]),
    html.p([], [html.text("PHP strings allow interpolation.")]),
    html.p([], [
      html.text(
        "In Gleam all strings are UTF-8 encoded binaries. Gleam strings do not allow
interpolation, yet. Gleam however offers a ",
      ),
      html.code([], [html.text("string_builder")]),
      html.text(
        "via its standard
library for performant string building.",
      ),
    ]),
    html.h4([attr.id("php-12")], [html.text("PHP")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$what = 'world';
'Hellø, world!';
\"Hellø, ${what}!\";
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-12")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("tuples")], [html.text("Tuples")]),
    html.p([], [
      html.text(
        "Tuples are very useful in Gleam as they’re the only collection data type that
allows mixed types in the collection.",
      ),
    ]),
    html.h4([attr.id("php-13")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP does not really support tuples, but its array type can easily be used to
mimick tuples. Unpacking can be used to bind a name to a specific value of
the tuple.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$myTuple = ['username', 'password', 10];
[$_, $pwd, $_] = $myTuple;
echo $pwd; // \"password\"
// Direct index access
echo $myTuple[0]; // \"username\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-13")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let my_tuple = #(\"username\", \"password\", 10)
let #(_, pwd, _) = my_tuple
io.print(pwd) // \"password\"
// Direct index access
io.print(my_tuple.0) // \"username\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("lists")], [html.text("Lists")]),
    html.p([], [
      html.text(
        "Arrays in PHP are allowed to have values of mixed types, but not in Gleam.",
      ),
    ]),
    html.h4([attr.id("php-14")], [html.text("PHP")]),
    html.p([], [
      html.text("PHP does not feature special syntax for list handling."),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$list = [2, 3, 4];
$head = array_slice($list, 0, 1)[0];
$tail = array_slice($list, 1);
# $head == 2
# $tail == [3, 4]
$arr = array_merge($tail, [1.1]);
# $arr == [3, 4, 1.1]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-14")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam has a "),
      html.code([], [html.text("cons")]),
      html.text(
        "operator that works for lists destructuring and
pattern matching. In Gleam lists are immutable so adding and removing elements
from the start of a list is highly efficient.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h3([attr.id("dicts")], [html.text("Dicts")]),
    html.p([], [
      html.text("In PHP, the "),
      html.code([], [html.text("array")]),
      html.text(
        "type can also be treated as a dictionary and can have keys of any type as long as:",
      ),
    ]),
    html.ul([], [
      html.li([], [
        html.text("the key type is "),
        html.code([], [html.text("null")]),
        html.text(", an "),
        html.code([], [html.text("int")]),
        html.text(", a "),
        html.code([], [html.text("string")]),
        html.text("or a "),
        html.code([], [html.text("bool")]),
        html.text(
          "(some conversions
occur, such as null to ",
        ),
        html.code([], [html.text("\"\"")]),
        html.text("and "),
        html.code([], [html.text("false")]),
        html.text("to "),
        html.code([], [html.text("0")]),
        html.text("as well as "),
        html.code([], [html.text("true")]),
        html.text("to "),
        html.code([], [html.text("1")]),
        html.text("and "),
        html.code([], [html.text("\"1\"")]),
        html.text("to "),
        html.code([], [html.text("1")]),
        html.text(
          ". Float indexes, which are not representing integers
indexes are deprecated due to being auto downcast to integers).",
        ),
      ]),
      html.li([], [html.text("the key is unique in the dictionary.")]),
      html.li([], [html.text("the values are of any type.")]),
    ]),
    html.p([], [
      html.text(
        "In Gleam, dicts can have keys and values of any type, but all keys must be of
the same type in a given dict and all values must be of the same type in a
given dict. The type of key and value can differ from each other.",
      ),
    ]),
    html.p([], [
      html.text(
        "There is no dict literal syntax in Gleam, and you cannot pattern match on a dict.
Dicts are generally not used much in Gleam, custom types are more common.",
      ),
    ]),
    html.h4([attr.id("php-15")], [html.text("PHP")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "[\"key1\" => \"value1\", \"key2\" => \"value2\"]
[\"key1\" => \"1\", \"key2\" => 2]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-15")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import gleam/dict

dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", \"value2\")])
dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", 2)]) // Type error!
",
        ),
      ]),
    ]),
    html.h3([attr.id("numbers")], [html.text("Numbers")]),
    html.p([], [
      html.text("PHP and Gleam both support "),
      html.code([], [html.text("Integer")]),
      html.text("and "),
      html.code([], [html.text("Float")]),
      html.text(
        ". Integer and Float sizes for
both depend on the platform: 64-bit or 32-bit hardware and OS and for Gleam
JavaScript and Erlang.",
      ),
    ]),
    html.h4([attr.id("php-16")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "While PHP differentiates between integers and floats it automatically converts
floats and integers for you, removing precision or adding floating point
decimals.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "1 / 2 // 0.5
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-16")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "1 / 2 // 0
1.5 + 10 // Compile time error
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("You can use the gleam standard library’s "),
      html.code([], [html.text("int")]),
      html.text("and "),
      html.code([], [html.text("float")]),
      html.text(
        "modules to convert
between floats and integers in various ways including ",
      ),
      html.code([], [html.text("rounding")]),
      html.text(", "),
      html.code([], [html.text("floor")]),
      html.text(
        ",
",
      ),
      html.code([], [html.text("ceiling")]),
      html.text("and many more."),
    ]),
    html.h2([attr.id("flow-control")], [html.text("Flow control")]),
    html.h3([attr.id("case")], [html.text("Case")]),
    html.p([], [
      html.code([], [html.text("case")]),
      html.text(
        "is how flow control is done in Gleam. It can be seen as a switch
statement on steroids. It provides a terse way to match a value type to an
expression. It is also used to replace ",
      ),
      html.code([], [html.text("if")]),
      html.text("/"),
      html.code([], [html.text("else")]),
      html.text("statements."),
    ]),
    html.h4([attr.id("php-17")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP features 3 different expressions to achieve similar goals:",
      ),
    ]),
    html.ul([], [
      html.li([], [
        html.code([], [html.text("if")]),
        html.text("/"),
        html.code([], [html.text("else if")]),
        html.text("/"),
        html.code([], [html.text("else")]),
        html.text("(does not return)"),
      ]),
      html.li([], [
        html.code([], [html.text("switch")]),
        html.text("/"),
        html.code([], [html.text("case")]),
        html.text("/"),
        html.code([], [html.text("break")]),
        html.text("/"),
        html.code([], [html.text("default")]),
        html.text("(does not return, does not autobreak)"),
      ]),
      html.li([], [html.code([], [html.text("match")]), html.text("(returns)")]),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "function http_error_impl_1($status) {
  if ($status === 400) {
      return \"Bad request\";
  } else if ($status === 404) {
      return \"Not found\";
  } else if ($status === 418) {
      return \"I'm a teapot\";
  } else {
    return \"Internal Server Error\";
  }
}

function http_error_impl_2($status) {
  switch ($status) {
    case \"400\": // Will work because switch ($status) compares non-strict as in ==
      return \"Bad request\";
      break; // Not strictly required here, but combined with weak typing multiple cases could be executed if break is omitted
    case 404:
      return \"Not found\";
      break;
    case 418:
      return \"I'm a teapot\";
      break;
    default:
      return \"Internal Server Error\";
  }
}

function http_error_impl_3($status) {
  return match($status) { // match($status) compares strictly
    400 => \"Bad request\",
    404 => \"Not found\",
    418 => \"I'm a teapot\",
    default => \"Internal Server Error\"
  };
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-17")], [html.text("Gleam")]),
    html.p([], [
      html.text("The case operator is a top level construct in Gleam:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case some_number {
  0 -> \"Zero\"
  1 -> \"One\"
  2 -> \"Two\"
  n -> \"Some other number\" // This matches anything
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "As all expressions the case expression will return the matched value.",
      ),
    ]),
    html.p([], [
      html.text(
        "They can be used to mimick if/else or if/elseif/else, with the exception that
any branch must return unlike in PHP, where it is possible to mutate a
variable of the outer block/scope and not return at all.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let is_status_within_4xx = status / 400 == 1
case status {
  400 -> \"Bad Request\"
  404 -> \"Not Found\"
  _ if is_status_within_4xx -> \"4xx\" // This works as of now
  // status if status / 400 == 1 -> \"4xx\" // This will work in future versions of Gleam
  _ -> \"I'm not sure\"
}
",
        ),
      ]),
    ]),
    html.p([], [html.text("if/else example:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case is_admin {
  True -> \"allow access\"
  False -> \"disallow access\"
}
",
        ),
      ]),
    ]),
    html.p([], [html.text("if/elseif/else example:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case True {
  _ if is_admin == True -> \"allow access\"
  _ if is_confirmed_by_mail == True -> \"allow access\"
  _ -> \"deny access\"
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Exhaustiveness checking at compile time, which is in the works, will make
certain that you must check for all possible values. A lazy and common way is
to check of expected values and have a catchall clause with a single underscore
",
      ),
      html.code([], [html.text("_")]),
      html.text(":"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case scale {
  0 -> \"none\"
  1 -> \"one\"
  2 -> \"pair\"
  _ -> \"many\"
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "The case operator especially coupled with destructuring to provide native pattern
matching:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case xs {
  [] -> \"This list is empty\"
  [a] -> \"This list has 1 element\"
  [a, b] -> \"This list has 2 elements\"
  _other -> \"This list has more than 2 elements\"
}
",
        ),
      ]),
    ]),
    html.p([], [html.text("The case operator supports guards:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case xs {
  [a, b, c] if a >. b && a <=. c -> \"ok\"
  _other -> \"ko\"
}
",
        ),
      ]),
    ]),
    html.p([], [html.text("…and disjoint union matching:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case number {
  2 | 4 | 6 | 8 -> \"This is an even number\"
  1 | 3 | 5 | 7 -> \"This is an odd number\"
  _ -> \"I'm not sure\"
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("piping")], [html.text("Piping")]),
    html.p([], [
      html.text(
        "In Gleam most functions, if not all, are data first, which means the main data
value to work on is the first argument. By this convention and the ability to
specify the argument to pipe into, Gleam allows writing functional, immutable
code, that reads imperative-style top down, much like unix tools and piping.",
      ),
    ]),
    html.h4([attr.id("php-18")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP does not offer pipes but it can chain calls by making functions return
objects which in turn ship with their list of methods.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// Imaginary PHP code
(new Session($request))
  ->authorize()
  ->setSuccessFlash('Logged in successfully!')
  ->setFailureFlash('Failed to login!')
  ->redirectToRequestedUrl();
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-18")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Imaginary Gleam code
request
|> session.new()
|> session.authorize()
|> flash.set_success_flash('Logged in successfully!')
|> flash.set_failure_flash('Failed to login!')
|> response.redirect_to_requested_url()
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Despite being similar to read and comprehend, the PHP code creates a session
object, and calls the authorize method of the session object: That session
object then returns another object, say an ",
      ),
      html.code([], [html.text("AuthorizedUser")]),
      html.text(
        "object - you don’t
know by looking at the code what object gets returned. However you know it must
implement a ",
      ),
      html.code([], [html.text("setSuccessFlash")]),
      html.text("method. At the last step of the chain "),
      html.code([], [html.text("redirect")]),
      html.text("is called on an object returned from "),
      html.code([], [html.text("setFailureFlash")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("In the Gleam code the request data is piped into "),
      html.code([], [html.text("session.new()")]),
      html.text(
        "’s first
argument and that return value is piped further down. It is readability sugar
for:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "response.redirect_to_requested_url(
  flash.set_failure_flash(
    flash.set_success_flash(
      session.authorize(
        session.new(request)
      ),
      'Logged in successfully!'
    ),
    'Failed to login!'
  )
)
",
        ),
      ]),
    ]),
    html.h3([attr.id("try")], [html.text("Try")]),
    html.p([], [
      html.text("Error management is approached differently in PHP and Gleam."),
    ]),
    html.h4([attr.id("php-19")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP uses the notion of exceptions to interrupt the current code flow and
pop up the error to the caller.",
      ),
    ]),
    html.p([], [
      html.text("An exception is raised using the keyword "),
      html.code([], [html.text("throw")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "function aFunctionThatFails() {
  throw new RuntimeException('an error');
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "The callee block will be able to capture any exception raised in the block
using a ",
      ),
      html.code([], [html.text("try/catch")]),
      html.text("set of blocks:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// callee block
try {
    echo 'this line will be executed and thus printed';
    aFunctionThatFails();
    echo 'this line will not be executed and thus not printed';
} catch (Throwable $e) {
    var_dump(['doing something with the exception', $e]);
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-19")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In contrast in Gleam, errors are just containers with an associated value.",
      ),
    ]),
    html.p([], [
      html.text(
        "A common container to model an operation result is
",
      ),
      html.code([], [html.text("Result(ReturnType, ErrorType)")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("A "),
      html.code([], [html.text("Result")]),
      html.text("is either:"),
    ]),
    html.ul([], [
      html.li([], [
        html.text("an "),
        html.code([], [html.text("Error(ErrorValue)")]),
      ]),
      html.li([], [
        html.text("or an "),
        html.code([], [html.text("Ok(Data)")]),
        html.text("record"),
      ]),
    ]),
    html.p([], [
      html.text(
        "Handling errors actually means to match the return value against those two
scenarios, using a case for instance:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case parse_int(\"123\") {
  Ok(i) -> io.println(\"We parsed the Int\")
  Error(e) -> io.println(\"That wasn't an Int\")
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("In order to simplify this construct, we can use the "),
      html.code([], [html.text("try")]),
      html.text("keyword that will:"),
    ]),
    html.ul([], [
      html.li([], [
        html.text("either bind a value to the providing name if "),
        html.code([], [html.text("Ok(Something)")]),
        html.text("is matched,"),
      ]),
      html.li([], [
        html.text("or "),
        html.strong([], [html.text("interrupt the current block’s flow")]),
        html.text("and return "),
        html.code([], [html.text("Error(Something)")]),
        html.text(
          "from
the given block.",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let a_number = \"1\"
let an_error = Error(\"ouch\")
let another_number = \"3\"

try int_a_number = parse_int(a_number)
try attempt_int = parse_int(an_error) // Error will be returned
try int_another_number = parse_int(another_number) // never gets executed

Ok(int_a_number + attempt_int + int_another_number) // never gets executed
",
        ),
      ]),
    ]),
    html.h2([attr.id("type-aliases")], [html.text("Type aliases")]),
    html.p([], [
      html.text(
        "Type aliases allow for easy referencing of arbitrary complex types.
PHP does not have this feature, though either regular classes or static classes
can be used to design custom types and class definitions in take can be aliased
using ",
      ),
      html.code([], [html.text("class_alias()")]),
      html.text("."),
    ]),
    html.h3([attr.id("php-20")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "A simple variable can store the result of a compound set of types.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class Point {
  // Can act as an opaque type and utilize Point
  // Can be class_aliased to Coordinate
}

class Triangle {
  // Can act as an opaque type definition and utilize Point
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-20")], [html.text("Gleam")]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("type")]),
      html.text("keyword can be used to create aliases."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub type Headers =
  List(#(String, String))
",
        ),
      ]),
    ]),
    html.h2([attr.id("custom-types")], [html.text("Custom types")]),
    html.h3([attr.id("records")], [html.text("Records")]),
    html.p([], [
      html.text(
        "Custom type allows you to define a collection data type with a fixed number of
named fields, and the values in those fields can be of differing types.",
      ),
    ]),
    html.h4([attr.id("php-21")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP uses classes to define user-defined, record-like types.
Properties are defined as class members and initial values are generally set in
the constructor.",
      ),
    ]),
    html.p([], [
      html.text(
        "By default the constructor does not provide base initializers in the
constructor so some boilerplate is needed:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class Person {
  public function __construct(public string $name, public int $age) { }
}
$person = new Person(name: \"Joe\", age: 40);
$person->name; // Joe
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-21")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s custom types can be used as structs. At runtime, they have a tuple
representation and are compatible with Erlang records (or JavaScript objects).",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Person {
  Person(name: String, age: Int)
}

let person = Person(name: \"Joe\", age: 40)
let name = person.name
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "An important difference to note is there is no Java-style object-orientation in
Gleam, thus methods can not be added to types. However opaque types exist,
see below.",
      ),
    ]),
    html.h3([attr.id("unions")], [html.text("Unions")]),
    html.p([], [
      html.text(
        "PHP generally does not support unions with a few exceptions such as:",
      ),
    ]),
    html.ul([], [
      html.li([], [html.text("type x or "), html.code([], [html.text("null")])]),
      html.li([], [
        html.code([], [html.text("Array")]),
        html.text("or "),
        html.code([], [html.text("Traversable")]),
        html.text("."),
      ]),
    ]),
    html.p([], [
      html.text(
        "In Gleam functions must always take and receive one type. To have a union of
two different types they must be wrapped in a new custom type.",
      ),
    ]),
    html.h4([attr.id("php-22")], [html.text("PHP")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class Wibble {
  public ?string $aStringOrNull;
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-22")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type IntOrFloat {
  AnInt(Int)
  AFloat(Float)
}

fn int_or_float(X) {
  case X {
    True -> AnInt(1)
    False -> AFloat(1.0)
  }
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("opaque-custom-types")], [html.text("Opaque custom types")]),
    html.p([], [
      html.text(
        "In PHP, constructors can be marked as private and opaque types can either be
modelled in an immutable way via static classes or in a mutable way via
a factory pattern.",
      ),
    ]),
    html.p([], [
      html.text(
        "In Gleam, custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.",
      ),
    ]),
    html.h4([attr.id("php-23")], [html.text("PHP")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class PointObject
{
  private function __construct(public int $x, public int $y) {
  }

  public static function spawn(int $x, int $y) {
    if ($x >= 0 && $x <= 99 && $y >= 0 && $y <= 99) {
      return new self($x, $y);
    }
    return false;
  }
}
PointObject::spawn(1, 2); // Returns a Point object
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "This requires mutation, but prohibits direct property changes.",
      ),
    ]),
    html.p([], [
      html.text("PHP allows to skip object mutation by using static classes:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "class PointStruct
{
  public static function spawn(int $x, int $y) {
    if ($x >= 0 && $x <= 99 && $y >= 0 && $y <= 99) {
      return compact('x', 'y') + ['struct' => __CLASS__];
    }
    return false;
  }
}
PointStruct::spawn(1, 2); // Returns an array managed by PointStruct
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "However PHP will in this case not prohibit the direct alteration the returned
structure, like Gleam’s custom types can.",
      ),
    ]),
    html.h4([attr.id("gleam-23")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// In the point.gleam opaque type module:
pub opaque type Point {
  Point(x: Int, y: Int)
}

pub fn spawn(x: Int, y: Int) -> Result(Point, Nil) {
  case x >= 0 && x <= 99 && y >= 0 && y <= 99 {
    True -> Ok(Point(x: x, y: y))
    False -> Error(Nil)
  }
}

// In the main.gleam module
pub fn main() {
  assert Ok(point) = Point.spawn(1, 2)
  point
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("modules")], [html.text("Modules")]),
    html.h3([attr.id("php-24")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP does not feature modules, but many other containers such as classes, traits
and interfaces. Historically a single file can contain many classes, traits and
interfaces one after another, though it is best practise to only contain one
such declaration per file.",
      ),
    ]),
    html.p([], [
      html.text(
        "Using PHP namespaces, these can be placed in a registry that does not need to
map to the source code file system hierarchy, but by convention should.",
      ),
    ]),
    html.p([], [
      html.text("In "),
      html.code([], [html.text("src/Wibble/Wabble.php")]),
      html.text(":"),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// Anything declared in this file will be inside namespace Wibble
namespace Wibble;

// Creation of (static) class Wabble in Wibble, thus as Wibble/Wabble
class Wabble {
  public static function identity($x) {
    return $x;
  }
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Making the static class available in the local scope and calling the function
",
      ),
      html.code([], [html.text("index.php")]),
      html.text("(aka PHP’s main function):"),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// After auto-loading has happened
use Wibble\\Wabble;

Wabble::identity(1); // 1
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-24")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Coming from PHP the closest thing PHP has that are similar to Gleam’s modules
are static classes: Collections of functions and constants grouped into a
static class.",
      ),
    ]),
    html.p([], [
      html.text("In comparison Gleam modules can also contain custom types."),
    ]),
    html.p([], [
      html.text("A gleam module name corresponds to its file name and path."),
    ]),
    html.p([], [
      html.text(
        "Since there is no special syntax to create a module, there can be only one
module in a file and since there is no way name the module the filename
always matches the module name which keeps things simple and transparent.",
      ),
    ]),
    html.p([], [
      html.text("In "),
      html.code([], [html.text("/src/wibble/wabble.gleam")]),
      html.text(":"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Creation of module function identity
// in module wabble
pub fn identity(x) {
  x
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Importing the "),
      html.code([], [html.text("wabble")]),
      html.text("module and calling a module function:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// In src/main.gleam
import wibble/wabble // if wibble was in a directory called `lib` the import would be `lib/wibble/wabble`.

pub fn main() {
  wabble.identity(1) // 1
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("imports")], [html.text("Imports")]),
    html.h4([attr.id("php-25")], [html.text("PHP")]),
    html.p([], [
      html.text("PHP features ways to load arbitrary PHP code: "),
      html.code([], [html.text("require")]),
      html.text(", "),
      html.code([], [html.text("include")]),
      html.text(
        "and
autoload such as ",
      ),
      html.code([], [html.text("spl_autoload_register")]),
      html.text(
        ". Once class paths are known and
registered for autoloading, they can brought into the scope of a file by using
the ",
      ),
      html.code([], [html.text("use")]),
      html.text(
        "statement which is part of PHP’s namespacing.
Also see ",
      ),
      html.a([attr.href("https://www.php-fig.org/psr/psr-4/")], [
        html.text("https://www.php-fig.org/psr/psr-4/"),
      ]),
      html.text("."),
    ]),
    html.p([], [
      html.text("Inside "),
      html.code([], [html.text("src/Nasa/MoonBase.php")]),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// Makes available src/nasa/RocketShip.php
use Nasa\\RocketShip;

class MoonBase {
  public static function exploreSpace() {
    RocketShip::launch();
  }
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-25")], [html.text("Gleam")]),
    html.p([], [
      html.text("Imports are relative to the app "),
      html.code([], [html.text("src")]),
      html.text("folder."),
    ]),
    html.p([], [
      html.text(
        "Modules in the same directory will need to reference the entire path from ",
      ),
      html.code([], [html.text("src")]),
      html.text(
        "for the target module, even if the target module is in the same folder.",
      ),
    ]),
    html.p([], [
      html.text("Inside module "),
      html.code([], [html.text("src/nasa/moon_base.gleam")]),
      html.text(":"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// imports module src/nasa/rocket_ship.gleam
import nasa/rocket_ship

pub fn explore_space() {
  rocket_ship.launch()
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("named-imports")], [html.text("Named imports")]),
    html.h4([attr.id("php-26")], [html.text("PHP")]),
    html.p([], [
      html.text(
        "PHP features namespaces which can be used to rename classes when they clash:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "// Source files must first be added to the auto-loader
use Unix\\Cat;
use Animal\\Cat as Kitty;
// Cat and Kitty are available
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-26")], [html.text("Gleam")]),
    html.p([], [html.text("Gleam has as similar feature:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import unix/cat
import animal/cat as kitty
// cat and kitty are available
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "This may be useful to differentiate between multiple modules that would have the same default name when imported.",
      ),
    ]),
    html.h3([attr.id("unqualified-imports")], [html.text("Unqualified imports")]),
    html.h4([attr.id("php-27")], [html.text("PHP")]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "use Animal\\Cat\\{
  Cat,
  function stroke
};
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-php")], [
        html.text(
          "$kitty = new Cat(name: \"Nubi\");
stroke($kitty);
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-27")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import animal/cat.{
  Cat,
  stroke
}

pub fn main() {
  let kitty = Cat(name: \"Nubi\")
  stroke(kitty)
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Importing common types such as "),
      html.code([], [html.text("gleam/order.{Lt, Eq, Gt}")]),
      html.text(
        "or
",
      ),
      html.code([], [html.text("gleam/option.{Some,None}")]),
      html.text("can be very helpful."),
    ]),
    html.h2([attr.id("architecture")], [html.text("Architecture")]),
    html.p([], [html.text("To iterate a few foundational differences:")]),
    html.ol([], [
      html.li([], [
        html.text(
          "Programming model: Java-style object-orientation VS functional immutable
programming",
        ),
      ]),
      html.li([], [
        html.text("Guarantees: weak dynamic typing VS strong static typing"),
      ]),
      html.li([], [
        html.text(
          "Runtime model: request-response script VS Erlang/OTP processes",
        ),
      ]),
      html.li([], [html.text("Error handling: exceptions VS result type")]),
      html.li([], [html.text("Language reach")]),
    ]),
    html.h3([attr.id("programming-model")], [html.text("Programming model")]),
    html.ul([], [
      html.li([], [
        html.text(
          "PHP mixes imperative, Java-style object-orientation and functional code
styles. Gleam offers only functional code style, though it can appear
imperative and reads easily thanks to pipes.",
        ),
      ]),
      html.li([], [
        html.text(
          "In Gleam, data structures are never mutated but always updated into new
structures. This allows processes that fail to simply restart as there are no
mutated objects that can be in an invalid state and take the whole
application down (such as in Go, Ruby or PHP).",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam offers syntax to make it easy to extract data out of custom types and
update data into new copies of custom types without ever mutating variables.
PHP sometimes directly mutates references of simple values such as when using
 ",
        ),
        html.code([], [html.text("reset()")]),
        html.text("or "),
        html.code([], [html.text("end()")]),
        html.text("or "),
        html.code([], [html.text("array_pop()")]),
        html.text("."),
      ]),
      html.li([], [
        html.text(
          "Gleam allows to rebind variables freely to make it easy to update data
structures by making a copy and binding it to the existing variable.",
        ),
      ]),
      html.li([], [
        html.text(
          "PHP features a massive, powerful but inconsistent standard library that is
always loaded and partially extended and deprecated with new PHP releases.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam allows you to opt into a smaller, well polished and consistent standard
library.",
        ),
      ]),
    ]),
    html.h3([attr.id("guarantees-and-types")], [
      html.text("Guarantees and types"),
    ]),
    html.ul([], [
      html.li([], [
        html.text(
          "PHP features opt-in static typing which is only checked at runtime.",
        ),
      ]),
      html.li([], [
        html.text(
          "PHP values tend to be automatically cast for comparison purposes or when used
as indexes in arrays. Gleam values are not automatically cast.",
        ),
      ]),
      html.li([], [
        html.text(
          "PHP allows comparison between most if not all values, even if it does not
make any sense say comparing a file ",
        ),
        html.code([], [html.text("resource")]),
        html.text("to a "),
        html.code([], [html.text("Date")]),
        html.text(
          "in terms of order.
Gleam’s comparison operators are very strict and limited, any other
comparisons and conversions must happen via function calls.",
        ),
      ]),
      html.li([], [
        html.text(
          "PHP’s checks happen at runtime, Gleam’s checks (for the most part) do not
and rely on the compiler to allow only type safe and sound code to be
compiled.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam’s type inference allows you to be lazy for almost all type definitions.
Gleam’s type system will always assist you in what types are expected and/or
conflicting. Gleam’s type system will help you discover APIs.",
        ),
      ]),
    ]),
    html.h3([attr.id("runtime-model")], [html.text("Runtime model")]),
    html.ul([], [
      html.li([], [
        html.text(
          "Gleam can run on Erlang/BEAM, on the browser but also Deno or NodeJS.",
        ),
      ]),
      html.li([], [
        html.text(
          "For Gleam on Erlang/BEAM the runtime model has some striking similarities
in practise: In PHP a script starts and runs. It allocates memory for this
script and frees it upon end or after the max execution time is exceeded
or the memory limit is exceeded.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam on Erlang/BEAM allows to processes requests in a similar isolation
level that PHP offers in contrast to applications running ",
        ),
        html.em([], [html.text("Go")]),
        html.text("or "),
        html.em([], [html.text("Ruby")]),
        html.text(
          ".
The level of isolation means that, very similar to PHP, if a process
crashes (in PHP read: if a request crashes) then the supervision system
can restart that process or after a while or amount of tries abort
repeating restarts on the process with that given input data. This means
Erlang/BEAM will yield similar robustness that PHP developers are used
to and similar isolation guarantees.",
        ),
      ]),
      html.li([], [
        html.text(
          "When executing Gleam code in fact its compiled Erlang or JavaScript is
executed. So in case there are runtime crashes, the crash log will show
Erlang (or browser-console/NodeJS/Deno) debug information. In Gleam
applications runtime errors should almost never happen but they are harder
to read, in PHP applications runtime errors much more often and are easier
to read.",
        ),
      ]),
    ]),
    html.h3([attr.id("error-handling")], [html.text("Error handling")]),
    html.ul([], [
      html.li([], [
        html.text(
          "Gleam will catch all errors that are expected to happen via the ",
        ),
        html.code([], [html.text("Result")]),
        html.text(
          "type. There can however be other errors, such as miss-behavior due
accidental to division by 0, crashes on RAM or storage limits, hardware
failures, etc. In these cases on the BEAM there are ways to manage these
via BEAM’s supervision trees.",
        ),
      ]),
      html.li([], [
        html.text(
          "In contrast PHP will use exceptions to handle errors and by doing so blurs
the line between expected errors and unexpected errors. Also function
signatures are enlarged de-facto by whatever exceptions they can throw
and thus function calls and return types become much harder to manage.",
        ),
      ]),
    ]),
    html.h3([attr.id("language-reach")], [html.text("Language reach")]),
    html.ul([], [
      html.li([], [
        html.text(
          "PHP is tailored towards web applications, servers, and static to low-dynamic
frontends.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam can be utilized as a JavaScript replacement to drive your frontend
application not just your backend web server.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam on Erlang/BEAM can be used to write non-blocking, massively concurrent
server applications comparable to RabbitMQ or multiplayer game servers.",
        ),
      ]),
    ]),
  ]
  |> layout.with_header("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn rust(ctx: site.Context) -> fs.File {
  let meta =
    site.PageMeta(
      path: "cheatsheets/gleam-for-rust-users",
      title: "Gleam for Rust users",
      meta_title: "Gleam for Rust users | Cheat sheet",
      subtitle: "Hello Rustaceans! 🦀",
      description: "A handy reminder of Gleam syntax for all Rustaceans out there.",
      preload_images: [],
      preview_image: option.None,
    )
  [
    html.ul([], [
      html.li([], [html.a([attr.href("#comments")], [html.text("Comments")])]),
      html.li([], [
        html.a([attr.href("#variables")], [html.text("Variables")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#match-operator")], [html.text("Match operator")]),
          ]),
          html.li([], [
            html.a([attr.href("#variables-type-annotations")], [
              html.text("Variables type annotations"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#functions")], [html.text("Functions")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#exporting-functions")], [
              html.text("Exporting functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-type-annotations")], [
              html.text("Function type annotations"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#function-overloading")], [
              html.text("Function overloading"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#referencing-function")], [
              html.text("Referencing functions"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#labelled-arguments")], [
              html.text("Labelled arguments"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#modules")], [html.text("Modules")])]),
      html.li([], [html.a([attr.href("#operators")], [html.text("Operators")])]),
      html.li([], [html.a([attr.href("#constants")], [html.text("Constants")])]),
      html.li([], [html.a([attr.href("#blocks")], [html.text("Blocks")])]),
      html.li([], [
        html.a([attr.href("#data-types")], [html.text("Data types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#strings")], [html.text("Strings")])]),
          html.li([], [html.a([attr.href("#tuples")], [html.text("Tuples")])]),
          html.li([], [html.a([attr.href("#lists")], [html.text("Lists")])]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#patterns")], [html.text("Patterns")])]),
      // html.li([], [
      //   html.a([attr.href("#flow-control")], [html.text("Flow control")]),
      //   html.text("TODO"),
      //   html.ul([], [
      //     html.li([], [
      //       html.a([attr.href("#case")], [html.text("Case")]),
      //       html.text("TODO"),
      //     ]),
      //     html.li([], [
      //       html.a([attr.href("#try")], [html.text("Try")]),
      //       html.text("TODO"),
      //     ]),
      //   ]),
      // ]),
      // html.li([], [
      //   html.a([attr.href("#type-aliases")], [html.text("Type aliases")]),
      //   html.text("TODO"),
      // ]),
      html.li([], [
        html.a([attr.href("#custom-types")], [html.text("Custom types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#records")], [html.text("Records")])]),
          html.li([], [html.a([attr.href("#unions")], [html.text("Unions")])]),
          // html.li([], [
        //   html.a([attr.href("#opaque-custom-types")], [
        //     html.text("Opaque custom types"),
        //   ]),
        //   html.text("TODO"),
        // ]),
        ]),
      ]),
      // html.li([], [
    //   html.a([attr.href("#modules")], [html.text("Modules")]),
    //   html.text("TODO"),
    //   html.ul([], [
    //     html.li([], [
    //       html.a([attr.href("#imports")], [html.text("Imports")]),
    //       html.text("TODO"),
    //     ]),
    //     html.li([], [
    //       html.a([attr.href("#nested-modules")], [html.text("Nested modules")]),
    //       html.text("TODO"),
    //     ]),
    //     html.li([], [
    //       html.a([attr.href("#first-class-modules")], [
    //         html.text("First class modules"),
    //       ]),
    //       html.text("TODO"),
    //     ]),
    //   ]),
    // ]),
    ]),
    html.h2([attr.id("comments")], [html.text("Comments")]),
    html.p([], [html.text("Comments look very similar in both languages.")]),
    html.h4([attr.id("rust")], [html.text("Rust")]),
    html.p([], [
      html.text("In Rust comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        "are used to document the following statement. Comments starting with ",
      ),
      html.code([], [html.text("//!")]),
      html.text("are used to document the current module."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "//! This module is very important.

/// The answer to life, the universe, and everything.
const answer: u64 = 42;
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        "are used to document the following statement. Comments starting with ",
      ),
      html.code([], [html.text("////")]),
      html.text("are used to document the current module."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
",
        ),
      ]),
    ]),
    html.h2([attr.id("variables")], [html.text("Variables")]),
    html.p([], [
      html.text(
        "You can declare and redeclare variables in both languages by using the ",
      ),
      html.code([], [html.text("let")]),
      html.text("keyword. Variables are immutable in both languages."),
    ]),
    html.h4([attr.id("rust-1")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let size = 50;
let size = size + 100;
let size = 1;
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-1")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let size = 50
let size = size + 100
let size = 1
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Gleam doesn’t have a "),
      html.code([], [html.text("mut")]),
      html.text(
        "keyword to mark variables as mutable, they’re always immutable.",
      ),
    ]),
    html.h3([attr.id("match-operator")], [html.text("Match operator")]),
    html.h4([attr.id("rust-2")], [html.text("Rust")]),
    html.p([], [
      html.text("In Rust, "),
      html.code([], [html.text("let")]),
      html.text("and "),
      html.code([], [html.text("=")]),
      html.text(
        "can be used for pattern matching, but you’ll get compile errors if there’s a type mismatch.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let [x] = [1];
let 2 = x; // compile error
let [y] = \"Hello\"; // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-2")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, "),
      html.code([], [html.text("let")]),
      html.text("and "),
      html.code([], [html.text("=")]),
      html.text(
        "can also be used for pattern matching, but you’ll get compile errors if there’s a type mismatch, and a runtime error if there’s a value mismatch. For assertions, the equivalent ",
      ),
      html.code([], [html.text("let assert")]),
      html.text("keyword is preferred."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let [x] = [1]
let assert 2 = x // runtime error
let assert [y] = \"Hello\" // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h3([attr.id("variables-type-annotations")], [
      html.text("Variables type annotations"),
    ]),
    html.p([], [
      html.text(
        "Both languages allow you to annotate variables with types in a similar style. The compilers will check that the type matches the variable’s assigned value. Both languages allow you to skip type annotation, and will instead infer the type from the provided value.",
      ),
    ]),
    html.h4([attr.id("rust-3")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let some_list: [u64; 3] = [1, 2, 3];
let other_list = [1, 2, 3];
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-3")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let some_list: List(Int) = [1, 2, 3]
let other_list = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.h2([attr.id("functions")], [html.text("Functions")]),
    html.h4([attr.id("rust-4")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "pub fn sum(x: u64, y: u64) -> u64 {
  x + y
}

let mul = |x, y| x * y;
mul(1, 2);
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-4")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s functions are declared using a syntax similar to Rust’s. Anonymous functions are a bit different from Rust, using the ",
      ),
      html.code([], [html.text("fn")]),
      html.text("keyword again."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
",
        ),
      ]),
    ]),
    html.h3([attr.id("exporting-functions")], [html.text("Exporting functions")]),
    html.p([], [
      html.text(
        "Both languages use the same system, where functions are private by default, and need the ",
      ),
      html.code([], [html.text("pub")]),
      html.text("keyword to be marked as public."),
    ]),
    html.h4([attr.id("rust-5")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "// this is public
pub fn sum(x: u64, y: u64) -> u64 {
    x + y
}

// this is private
fn mul(x: u64, y: u64) -> u64 {
    x * y
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-5")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// this is public
pub fn sum(x, y) {
  x + y
}

// this is private
fn mul(x, y) {
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-type-annotations")], [
      html.text("Function type annotations"),
    ]),
    html.h4([attr.id("rust-6")], [html.text("Rust")]),
    html.p([], [
      html.text("Rust functions "),
      html.strong([], [html.text("always")]),
      html.text("need type annotations."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "pub fn sum(x: u64, y: u64) -> u64 {
  x + y
}

pub fn mul(x: u64, y: u64) -> u64 {
  x * y
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-6")], [html.text("Gleam")]),
    html.p([], [
      html.text("Functions can "),
      html.strong([], [html.text("optionally")]),
      html.text(
        " have their argument and return types annotated in Gleam. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool { // compile error, type mismatch
  x * y
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-overloading")], [
      html.text("Function overloading"),
    ]),
    html.p([], [
      html.text(
        "Like Rust, Gleam does not support function overloading, so there can only
be 1 function with a given name, and the function can only have a single
implementation for the types it accepts.",
      ),
    ]),
    html.h3([attr.id("referencing-functions")], [
      html.text("Referencing functions"),
    ]),
    html.p([], [
      html.text(
        "Referencing functions in Gleam works like in Rust, without any special syntax.",
      ),
    ]),
    html.h4([attr.id("rust-7")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "fn identity(x: u64) -> u64 {
  x
}

fn main() {
  let func = identity;
  func(100);
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-7")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn identity(x) {
  x
}

fn main() {
  let func = identity
  func(100)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("labelled-arguments")], [html.text("Labelled arguments")]),
    html.p([], [
      html.text(
        "In Gleam arguments can be given a label as well as an internal name. As with
Erlang the name used at the call-site does not have to match the name used
for the variable inside the function.",
      ),
    ]),
    html.p([], [
      html.text(
        "There is no performance cost to Gleam’s labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "replace(each: \",\", with: \" \", inside: \"A,B,C\")
",
        ),
      ]),
    ]),
    html.p([], [html.text("There is no equivalent feature in Rust.")]),
    html.h2([attr.id("operators")], [html.text("Operators")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Operator")]),
          html.th([], [html.text("Rust")]),
          html.th([], [html.text("Gleam")]),
          html.th([], [html.text("Notes")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.text("Equal")]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], [html.code([], [html.text("==")])]),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.text("Not equal")]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], [html.code([], [html.text("!=")])]),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater than")]),
          html.td([], [html.code([], [html.text(">")])]),
          html.td([], [html.code([], [html.text(">.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Greater or equal")]),
          html.td([], [html.code([], [html.text(">=")])]),
          html.td([], [html.code([], [html.text(">=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less than")]),
          html.td([], [html.code([], [html.text("<")])]),
          html.td([], [html.code([], [html.text("<.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Less or equal")]),
          html.td([], [html.code([], [html.text("<=")])]),
          html.td([], [html.code([], [html.text("<=.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean and")]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [html.code([], [html.text("&&")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Boolean or")]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], [html.code([], [html.text("||")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Add")]),
          html.td([], [html.code([], [html.text("+")])]),
          html.td([], [html.code([], [html.text("+.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Subtract")]),
          html.td([], [html.code([], [html.text("-")])]),
          html.td([], [html.code([], [html.text("-.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Multiply")]),
          html.td([], [html.code([], [html.text("*")])]),
          html.td([], [html.code([], [html.text("*.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Divide")]),
          html.td([], [html.code([], [html.text("/")])]),
          html.td([], [html.code([], [html.text("/.")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Remainder")]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [html.code([], [html.text("%")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Concatenate")]),
          html.td([], []),
          html.td([], [html.code([], [html.text("<>")])]),
          html.td([], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("strings")]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Pipe")]),
          html.td([], []),
          html.td([], [html.code([], [html.text("⎮>")])]),
          html.td([], [
            html.text("Gleam’s pipe can pipe into anonymous functions"),
          ]),
        ]),
      ]),
    ]),
    html.h2([attr.id("constants")], [html.text("Constants")]),
    html.h4([attr.id("rust-8")], [html.text("Rust")]),
    html.p([], [
      html.text("In Rust constants can be created using the "),
      html.code([], [html.text("const")]),
      html.text("keyword, and have to be given a type annotation."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "const the_answer: u64 = 42;

pub fn main() {
  the_answer;
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "In Rust, public constants can be referenced from other modules.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "mod other_module {
  pub const the_answer: u64 = 42;
}

fn main() {
  other_module::the_answer;
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-8")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam constants can be created using the "),
      html.code([], [html.text("const")]),
      html.text("keyword, and can be optionally given a type annotation."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "const the_answer = 42

pub fn main() {
  the_answer
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Additionally, public constants can be referenced from other modules.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// In module other_module.gleam
pub const the_answer: Int = 42
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import other_module

fn main() {
  other_module.the_answer
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("blocks")], [html.text("Blocks")]),
    html.h4([attr.id("rust-9")], [html.text("Rust")]),
    html.p([], [
      html.text("In Rust braces "),
      html.code([], [html.text("{")]),
      html.code([], [html.text("}")]),
      html.text(
        "are used to group expressions, and arithmetic operations are grouped with parenthesis ",
      ),
      html.code([], [html.text("(")]),
      html.code([], [html.text(")")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let x = {
    println!(\"{}\", 1);
    2
};
let y = x * (x + 10); // parenthesis are used to change arithmetic operations order
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-9")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam braces "),
      html.code([], [html.text("{")]),
      html.code([], [html.text("}")]),
      html.text("are used to group both expressions and arithmetic operations."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let x = {
  print(1)
  2
}
let y = x * {x + 10} // braces are used to change arithmetic operations order
",
        ),
      ]),
    ]),
    html.h2([attr.id("data-types")], [html.text("Data types")]),
    html.h3([attr.id("strings")], [html.text("Strings")]),
    html.p([], [
      html.text(
        "In both Rust and Gleam all strings are UTF-8 encoded binaries.",
      ),
    ]),
    html.h4([attr.id("rust-10")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-10")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("tuples")], [html.text("Tuples")]),
    html.h4([attr.id("rust-11")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let my_tuple = (\"username\", \"password\", 10);
let (_, password, _) = my_tuple;
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-11")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Tuples are very useful in Gleam as they’re the only collection data type that allows mixed types in the collection.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let my_tuple = #(\"username\", \"password\", 10)
let #(_, password, _) = my_tuple
",
        ),
      ]),
    ]),
    html.h3([attr.id("lists")], [html.text("Lists")]),
    html.p([], [
      html.text(
        "Rust arrays and Gleam lists are similar, but Rust’s are slightly more limited.",
      ),
    ]),
    html.h4([attr.id("rust-12")], [html.text("Rust")]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let list = [1, 2, 3];

let other = [0, ..list]; // Compile error!
let [0, second_element, ..] = list; // Compile error!
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-12")], [html.text("Gleam")]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("cons")]),
      html.text(
        "operator works the same way both for pattern matching and for appending elements to the head of a list.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [1, 2, 3]
let list = [0, ..list]
let assert [0, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h2([attr.id("custom-types")], [html.text("Custom types")]),
    html.p([], [
      html.text(
        "Custom type allows you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.",
      ),
    ]),
    html.h4([attr.id("rust-13")], [html.text("Rust")]),
    html.p([], [
      html.text("Rust has Structs, which are declared using the "),
      html.code([], [html.text("struct")]),
      html.text("keyword."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "struct Person {
  name: String,
  age: u64,
}

let person = Person {
  name: \"Jake\".to_string(),
  age: 35,
};
let name = person.name;
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-13")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam’s custom types can be declared using the "),
      html.code([], [html.text("type")]),
      html.text(
        "keyword. At runtime, they have a tuple representation and are compatible with Erlang records.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Person {
  Person(name: String, age: Int)
}

let person = Person(name: \"Jake\", age: 35)
let name = person.name
",
        ),
      ]),
    ]),
    html.h3([attr.id("unions")], [html.text("Unions")]),
    html.h4([attr.id("rust-14")], [html.text("Rust")]),
    html.p([], [
      html.text("Rust’s union type is called Enum and declared with the "),
      html.code([], [html.text("enum")]),
      html.text("keyword:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "enum IpAddress {
  V4(u8, u8, u8, u8),
  V6(String)
}

let addr_v4 = IpAddress::V4(192, 168, 1, 1);
let addr_v6 = IpAddress::V6(\"::1\".to_string());
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-14")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam, custom types become unions by having multiple constructors:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type IpAddress {
  V4(Int, Int, Int, Int)
  V6(String)
}

let addr_v4 = V4(192, 168, 1, 1)
let addr_v6 = V6(\"::1\")
",
        ),
      ]),
    ]),
    html.h2([attr.id("flow-control")], [html.text("Flow control")]),
    html.h3([attr.id("case")], [html.text("Case")]),
    html.h4([attr.id("rust-15")], [html.text("Rust")]),
    html.p([], [
      html.text(
        "When you need to match a value against multiple possible patterns, Rust has the ",
      ),
      html.code([], [html.text("match")]),
      html.text(
        "expression.
Such matches are e.g. enums or string slices:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "enum MyEnum {
  A(i32),
  B,
  C,
}

let my_enum = MyEnum::A(10);

match my_enum {
  MyEnum::A(n) => do_a(n),
  MyEnum::B => do_b(),
  MyEnum::C => {
    do_sth();
    do_c()
  }
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "let my_str = \"abcd\";

match my_str {
  \"abc\" => do_sth(),
  \"abcd\" => do_sth_else(),
  _ => (),
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-15")], [html.text("Gleam")]),
    html.p([], [
      html.text("Similar to Rust’s "),
      html.code([], [html.text("match")]),
      html.text(", Gleam has "),
      html.code([], [html.text("case")]),
      html.text(":"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type MyEnum {
  A(Int)
  B
  C
}

let x = A(10)

case x {
  A(n) -> do_a(n)
  B -> do_b()
  C -> {
    do_sth()
    do_c()
  }
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("modules")], [html.text("Modules")]),
    html.h4([attr.id("rust-16")], [html.text("Rust")]),
    html.p([], [
      html.text("In Rust, the "),
      html.code([], [html.text("mod")]),
      html.text(
        "keyword allows to create a module. Multiple modules can be defined in a single file.",
      ),
    ]),
    html.p([], [
      html.text("Rust uses the "),
      html.code([], [html.text("use")]),
      html.text("keyword to import modules, and the "),
      html.code([], [html.text("::")]),
      html.text("operator to access properties and functions inside."),
    ]),
    html.pre([], [
      html.code([attr.class("language-rust")], [
        html.text(
          "mod wibble {
    pub fn identity(x: u64) -> u64 {
        x
    }
}

mod wobble {
    use super::wibble;

    fn main() {
        wibble::identity(1);
    }
}
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-16")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam, each file is a module, named by the file name (and its directory path). Since there is no special syntax to create a module, there can be only one module in a file.",
      ),
    ]),
    html.p([], [
      html.text("Gleam uses the "),
      html.code([], [html.text("import")]),
      html.text("keyword to import modules, and the dot "),
      html.code([], [html.text(".")]),
      html.text("operator to access properties and functions inside."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// In module wibble.gleam
pub fn identity(x) {
  x
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in module main.gleam
import wibble // if wibble was in a folder called `lib` the import would be `lib/wibble`
pub fn main() {
  wibble.identity(1)
}
",
        ),
      ]),
    ]),
  ]
  |> layout.with_header("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn elm(ctx: site.Context) -> fs.File {
  let meta =
    site.PageMeta(
      path: "cheatsheets/gleam-for-elm-users",
      title: "Gleam for Elm users",
      meta_title: "Gleam for Elm users | Cheat sheet",
      subtitle: "Hello delightful programmers!",
      description: "A handy reminder of Gleam syntax for all Elm enthusiasts out there.",
      preload_images: [],
      preview_image: option.None,
    )

  [
    html.h2([attr.id("overview")], [html.text("Overview")]),
    html.p([], [
      html.text(
        "Elm and Gleam have similar goals of providing a robust and sound type system with a friendly and approachable set of features.",
      ),
    ]),
    html.p([], [
      html.text(
        "They have some differences in their output and focus. Where Elm compiles to JavaScript, Gleam compiles to both Erlang and JavaScript, and where Elm is best suited for front-end browser based applications, Gleam targets back-end and front-end application development.",
      ),
    ]),
    html.p([], [
      html.text(
        "Another area in which Elm and Gleam differ is around talking to other languages.
Elm does not provide user-defined foreign function interfaces for interacting
with JavaScript code and libraries. All communication between Elm and JavaScript
has to go through the Elm ports. In contrast to this, Gleam makes it easy to
define interfaces for using Erlang or JavaScript code and libraries directly and
has no concept of ports.",
      ),
    ]),
    html.h2([attr.id("contents")], [html.text("Contents")]),
    html.ul([], [
      html.li([], [html.a([attr.href("#comments")], [html.text("Comments")])]),
      html.li([], [
        html.a([attr.href("#variables")], [html.text("Variables")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#variables-type-annotations")], [
              html.text("Variables type annotations"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#constants")], [html.text("Constants")])]),
      html.li([], [
        html.a([attr.href("#functions")], [html.text("Functions")]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#function-type-annotations")], [
              html.text("Function type annotations"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#labelled-arguments")], [
              html.text("Labelled arguments"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#modules")], [html.text("Modules")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#exports")], [html.text("Exports")])]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#blocks")], [html.text("Blocks")])]),
      html.li([], [
        html.a([attr.href("#data-types")], [html.text("Data types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#numbers")], [html.text("Numbers")])]),
          html.li([], [html.a([attr.href("#strings")], [html.text("Strings")])]),
          html.li([], [html.a([attr.href("#tuples")], [html.text("Tuples")])]),
          html.li([], [html.a([attr.href("#records")], [html.text("Records")])]),
          html.li([], [html.a([attr.href("#lists")], [html.text("Lists")])]),
          html.li([], [html.a([attr.href("#dicts")], [html.text("Dicts")])]),
        ]),
      ]),
      html.li([], [html.a([attr.href("#operators")], [html.text("Operators")])]),
      html.li([], [
        html.a([attr.href("#type-aliases")], [html.text("Type aliases")]),
      ]),
      html.li([], [
        html.a([attr.href("#custom-types")], [html.text("Custom types")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#maybe")], [html.text("Maybe")])]),
          html.li([], [html.a([attr.href("#result")], [html.text("Result")])]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#if-expressions")], [html.text("If expressions")]),
      ]),
      html.li([], [
        html.a([attr.href("#case-expressions")], [html.text("Case expressions")]),
      ]),
      html.li([], [html.a([attr.href("#commands")], [html.text("Commands")])]),
      html.li([], [
        html.a([attr.href("#talking-to-other-languages")], [
          html.text("Talking to other languages"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#architecture")], [html.text("Architecture")]),
      ]),
      html.li([], [
        html.a([attr.href("#package-management")], [
          html.text("Package management"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#implementation")], [html.text("Implementation")]),
      ]),
      html.li([], [
        html.a([attr.href("#other-concepts")], [html.text("Other concepts")]),
        html.ul([], [
          html.li([], [html.a([attr.href("#atoms")], [html.text("Atoms")])]),
          html.li([], [
            html.a([attr.href("#debugging")], [html.text("Debugging")]),
          ]),
        ]),
      ]),
    ]),
    html.h2([attr.id("comments")], [html.text("Comments")]),
    html.h4([attr.id("elm")], [html.text("Elm")]),
    html.p([], [
      html.text("In Elm, single line comments are written with a "),
      html.code([], [html.text("--")]),
      html.text("prefix and multiline comments are written with "),
      html.code([], [html.text("{- -}")]),
      html.text("and "),
      html.code([], [html.text("{-| -}")]),
      html.text("for documentation comments."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "-- Hello, Joe!

{- Hello, Joe!
   This is a multiline comment.
-}

{-| Determine the length of a list.
    length [1,2,3] == 3
-}
length : List a -> Int
length xs =
  foldl (\\_ i -> i + 1) 0 xs
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam comments are written with a "),
      html.code([], [html.text("//")]),
      html.text("prefix."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// Hello, Joe!
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Comments starting with "),
      html.code([], [html.text("///")]),
      html.text(
        "are used to document the following function, constant, or type definition. Comments starting with ",
      ),
      html.code([], [html.text("////")]),
      html.text("are used to document the current module."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
",
        ),
      ]),
    ]),
    html.p([], [html.text("There are no multiline comments in Gleam.")]),
    html.h2([attr.id("variables")], [html.text("Variables")]),
    html.h4([attr.id("elm-1")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, you assign variables in let-blocks and you cannot re-assign variables within a let-block.",
      ),
    ]),
    html.p([], [
      html.text(
        "You also cannot create a variable with the same name as a variable from a higher scope.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "let
    size = 50
    size = size + 100 -- Compile Error!
in
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-1")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam has the "),
      html.code([], [html.text("let")]),
      html.text(
        "keyword before its variable names. You can re-assign variables and you can shadow variables from other scopes. This does not mutate the previously assigned value.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let size = 50
let size = size + 100
let size = 1
",
        ),
      ]),
    ]),
    html.h3([attr.id("variables-type-annotations")], [
      html.text("Variables type annotations"),
    ]),
    html.p([], [
      html.text(
        "Both Elm and Gleam will check the type annotation to ensure that it matches the type of the assigned value. They do not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.",
      ),
    ]),
    html.h4([attr.id("elm-2")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, type annotations are optionally given on the line above the variable assignment. They can be provided in let-blocks but it frequently only provided for top level variables and functions.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "someList : List Int
someList = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-2")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam type annotations can optionally be given when binding variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let some_list: List(Int) = [1, 2, 3]
",
        ),
      ]),
    ]),
    html.h3([attr.id("constants")], [html.text("Constants")]),
    html.h4([attr.id("elm-3")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, constants can be defined at the top level of the module like any other value and exported if desired and reference from other modules.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "module Hikers exposing (theAnswer)

theAnswer: Int
theAnswer =
    42
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-3")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam constants can be created using the "),
      html.code([], [html.text("const")]),
      html.text("keyword."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "const the_answer = 42

pub fn main() {
  the_answer
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Gleam constants can be referenced from other modules."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file other_module.gleam
pub const the_answer: Int = 42
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import other_module

fn main() {
  other_module.the_answer
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("functions")], [html.text("Functions")]),
    html.h4([attr.id("elm-4")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, functions are defined as declarations that have arguments, or by assigning anonymous functions to variables.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "sum x y =
  x + y

mul =
  \\x y -> x * y

mul 3 2
-- 6
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-4")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s functions are declared using a syntax similar to Rust or JavaScript. Gleam’s anonymous functions are declared using the ",
      ),
      html.code([], [html.text("fn")]),
      html.text("keyword."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
",
        ),
      ]),
    ]),
    html.h3([attr.id("function-type-annotations")], [
      html.text("Function type annotations"),
    ]),
    html.h4([attr.id("elm-5")], [html.text("Elm")]),
    html.p([], [
      html.text("In Elm, functions can "),
      html.strong([], [html.text("optionally")]),
      html.text(
        " have their argument and return types annotated. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "sum : number -> number -> number
sum x y = x + y

mul : number -> number -> Bool -- Compile error
mul x y = x * y
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-5")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "All the same things are true of Gleam though the type annotations go inline in the function declaration, rather than above it.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool {
  x * y // compile error, type mismatch
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("labelled-arguments")], [html.text("Labelled arguments")]),
    html.h4([attr.id("elm-6")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "Elm has no built-in way to label arguments. Instead it would standard for a function to expect a record as an argument in which the field names would serve as the argument labels. This can be combined with providing a ‘defaults’ value of the same record type where callers can override only the fields that they want to differ from the default.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "defaultOptions =
  { inside = defaultString
  , each = defaultPattern,
  , with = defaultReplacement
  }

replace opts =
  doReplacement opts.inside opts.each opts.with
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "replace { each = \",\", with = \" \", inside = \"A,B,C\" }

replace { defaultOptions | inside = \"A,B,C,D\" }
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-6")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam arguments can be given a label as well as an internal name.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "replace(each: \",\", with: \" \", inside: \"A,B,C\")
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "There is no performance cost to Gleam’s labelled arguments as they are optimised to regular function calls at compile time, and all the arguments are fully type checked.",
      ),
    ]),
    html.h2([attr.id("modules")], [html.text("Modules")]),
    html.h4([attr.id("elm-7")], [html.text("Elm")]),
    html.p([], [
      html.text("In Elm, the "),
      html.code([], [html.text("module")]),
      html.text(
        "keyword allows to create a module. Each module maps to a single file. The module name must be explicitly stated and must match the file name.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "module One exposing (identity)

identity : a -> a
identity x =
    x
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-7")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "A Gleam file is a module, named by the file name (and its directory path). There is no special syntax to create a module. There can be only one module in a file.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file one.gleam
pub fn identity(x) {
  x
}
",
        ),
      ]),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// in file main.gleam
import one // if `one` was in a folder called `lib` the import would be `lib/one`

pub fn main() {
  one.identity(1)
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("exports")], [html.text("Exports")]),
    html.h4([attr.id("elm-8")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, exports are handled at the top of the file in the module declaration as a list of names.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "module Math exposing (sum)

-- this is public as it is in the export list
sum x y =
  x + y

-- this is private as it isn't in the export list
mul x y =
  x * y
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-8")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam, constants & functions are private by default and need the ",
      ),
      html.code([], [html.text("pub")]),
      html.text("keyword to be public."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "// this is public
pub fn sum(x, y) {
  x + y
}

// this is private
fn mul(x, y) {
  x * y
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("blocks")], [html.text("Blocks")]),
    html.h4([attr.id("elm-9")], [html.text("Elm")]),
    html.p([], [
      html.text("In Elm, expressions can be grouped using "),
      html.code([], [html.text("let")]),
      html.text("and "),
      html.code([], [html.text("in")]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "view =
  let
    x = 5
    y =
      let
         z = 4
         t = 3
      in
      z + (t * 5) -- Parenthesis are used to group arithmetic expressions
  in
  y + x
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-9")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam braces "),
      html.code([], [html.text("{")]),
      html.code([], [html.text("}")]),
      html.text("are used to group expressions."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub fn main() {
  let x = {
    print(1)
    2
  }
  let y = x * { x + 10 } // braces are used to change arithmetic operations order
  y
}
",
        ),
      ]),
    ]),
    html.h2([attr.id("data-types")], [html.text("Data types")]),
    html.h3([attr.id("numbers")], [html.text("Numbers")]),
    html.p([], [
      html.text("Both Elm and Gleam support "),
      html.code([], [html.text("Int")]),
      html.text("and "),
      html.code([], [html.text("Float")]),
      html.text("as separate number types."),
    ]),
    html.h4([attr.id("elm-10")], [html.text("Elm")]),
    html.p([], [
      html.text("Elm has a built-in "),
      html.code([], [html.text("number")]),
      html.text("concept that allows it to treat "),
      html.code([], [html.text("Int")]),
      html.text("and "),
      html.code([], [html.text("Float")]),
      html.text("generically so operators like "),
      html.code([], [html.text("+")]),
      html.text("can be used for two "),
      html.code([], [html.text("Int")]),
      html.text("values or two "),
      html.code([], [html.text("Float")]),
      html.text("values though not for an "),
      html.code([], [html.text("Int")]),
      html.text("and a "),
      html.code([], [html.text("Float")]),
      html.text("."),
    ]),
    html.h4([attr.id("gleam-10")], [html.text("Gleam")]),
    html.p([], [
      html.text("Operators in Gleam are not generic over "),
      html.code([], [html.text("Int")]),
      html.text("and "),
      html.code([], [html.text("Float")]),
      html.text("so there are separate symbols for "),
      html.code([], [html.text("Int")]),
      html.text("and "),
      html.code([], [html.text("Float")]),
      html.text("operations. For example, "),
      html.code([], [html.text("+")]),
      html.text("adds integers together whilst "),
      html.code([], [html.text("+.")]),
      html.text("adds floats together. The pattern of the additional "),
      html.code([], [html.text(".")]),
      html.text("extends to the other common operators."),
    ]),
    html.p([], [
      html.text(
        "Additionally, underscores can be added to both integers and floats for clarity.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "const one_million = 1_000_000
const two_million = 2_000_000.0
",
        ),
      ]),
    ]),
    html.h3([attr.id("strings")], [html.text("Strings")]),
    html.p([], [
      html.text(
        "In both Elm and Gleam all strings support unicode. Gleam uses UTF-8 binaries. Elm compiles to JavaScript which uses UTF-16 for its strings.",
      ),
    ]),
    html.p([], [html.text("Both languages use double quotes for strings.")]),
    html.h4([attr.id("elm-11")], [html.text("Elm")]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Strings in Elm are combined using the "),
      html.code([], [html.text("++")]),
      html.text("operator and functions like "),
      html.a(
        [
          attr.href(
            "https://package.elm-lang.org/packages/elm/core/latest/String#append",
          ),
        ],
        [html.code([], [html.text("String.append")])],
      ),
      html.text("and "),
      html.a(
        [
          attr.href(
            "https://package.elm-lang.org/packages/elm/core/latest/String#concat",
          ),
        ],
        [html.code([], [html.text("String.concat")])],
      ),
      html.text(":"),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "greeting =
    \"Hello, \" ++ \"world!\"

birthdayWishes =
    String.append \"Happy Birthday, \" person.name

holidayWishes =
    String.concat [ \"Happy \", holiday.name, person.name ]
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-11")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "\"Hellø, world!\"
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Similar to Elm, you can combine strings, for that Gleam has the operator ",
      ),
      html.code([], [html.text("<>")]),
      html.text("and also functions like "),
      html.a(
        [attr.href("https://hexdocs.pm/gleam_stdlib/gleam/string.html#append")],
        [html.code([], [html.text("string.append")])],
      ),
      html.text("and "),
      html.a(
        [attr.href("https://hexdocs.pm/gleam_stdlib/gleam/string.html#concat")],
        [html.code([], [html.text("string.concat")])],
      ),
      html.text("in the standard library."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let happy_new_year_wishes =
  \"Happy New Year \" <> person.name

let birthday_wishes =
  string.append(to: \"Happy Birthday \", suffix: person.name)

let holiday_wishes =
  string.concat([ \"Happy \", holiday.name, person.name ])
",
        ),
      ]),
    ]),
    html.h3([attr.id("tuples")], [html.text("Tuples")]),
    html.p([], [
      html.text(
        "Tuples are very useful in both Elm and Gleam as they’re the only collection data type that allows mixed types in the collection.",
      ),
    ]),
    html.h4([attr.id("elm-12")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, tuples are limited to only 2 or 3 entries. It is recommended to use records when needing larger numbers of entries.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "myTuple = (\"username\", \"password\", 10)
(_, password, _) = myTuple
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-12")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "There is no limit to the number of entries in Gleam tuples, but records are still recommended as giving names to fields adds clarity.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let my_tuple = #(\"username\", \"password\", 10)
let #(_, password, _) = my_tuple
",
        ),
      ]),
    ]),
    html.h3([attr.id("records")], [html.text("Records")]),
    html.p([], [
      html.text("Records are used to define and create structured data."),
    ]),
    html.h4([attr.id("elm-13")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "In Elm, you can declare records using curly braces containing key-value pairs:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "person =
  { name = \"Alice\"
  , age = 43
  }
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "The type of the record is derived by the compiler. In this case it would be ",
      ),
      html.code([], [html.text("{ name : String, age : number }")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("Records can also be created using a "),
      html.a([attr.href("#type-aliases")], [html.text("type alias")]),
      html.text("name as a constructor."),
    ]),
    html.p([], [html.text("Record fields can be accessed with a dot syntax:")]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "greeting person =
   \"Hello, \" ++ person.name ++ \"!\"
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Records cannot be updated because they are immutable. However, there
is a special syntax for easily creating a new record based on an
existing record’s fields:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "personWithSameAge = { person | name = \"Bob\" }
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-13")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "In Gleam, you cannot create records without creating a custom type first.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "type Person {
  Person(name: String, age: Int)
}

let person = Person(name: \"Alice\", age: 43)
",
        ),
      ]),
    ]),
    html.p([], [html.text("Record fields can be accessed with a dot syntax:")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "greeting = string.concat([\"Hello, \",  person.name, \"!\"])
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Records cannot be updated because they are immutable. However, there
is a special syntax for easily creating a new record based on an
existing record’s fields:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let person_with_same_age = Person(..person, name: \"Bob\")
",
        ),
      ]),
    ]),
    html.h3([attr.id("lists")], [html.text("Lists")]),
    html.p([], [
      html.text(
        "Both Elm and Gleam support lists. All entries have to be of the same type.",
      ),
    ]),
    html.h4([attr.id("elm-14")], [html.text("Elm")]),
    html.p([], [
      html.text("Elm has a built-in syntax for lists and the "),
      html.code([], [html.text("cons")]),
      html.text("operator ("),
      html.code([], [html.text("::")]),
      html.text(") for adding a new item to the head of a list."),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "list = [2, 3, 4]
anotherList = 1 :: list
yetAnotherList = \"hello\" :: list // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-14")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam also has a built-in syntax for lists and its own spread operator (",
      ),
      html.code([], [html.text("..")]),
      html.text(") for adding elements to the front of a list."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let list = [2, 3, 4]
let list = [1, ..list]
let another_list = [1.0, ..list] // compile error, type mismatch
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("The standard library provides the "),
      html.a([attr.href("https://hexdocs.pm/gleam_stdlib/gleam/list.html")], [
        html.text("gleam/list"),
      ]),
      html.text("module for interacting with lists. Functions like "),
      html.code([], [html.text("list.head")]),
      html.text("return an "),
      html.code([], [html.text("Option")]),
      html.text("value to account for the possibility of an empty list."),
    ]),
    html.h3([attr.id("dicts")], [html.text("Dicts")]),
    html.p([], [
      html.text(
        "Dict in Elm and Dict in Gleam have similar properties and purpose.",
      ),
    ]),
    html.p([], [
      html.text(
        "In Gleam, dicts can have keys and values of any type, but all keys must be of the same type in a given dict and all values must be of the same type in a given dict.",
      ),
    ]),
    html.p([], [
      html.text(
        "Like Elm, there is no dict literal syntax in Gleam, and you cannot pattern match on a dict.",
      ),
    ]),
    html.h4([attr.id("elm-15")], [html.text("Elm")]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "import Dict

Dict.fromList [ (\"key1\", \"value1\"), (\"key2\", \"value2\") ]
Dict.fromList [ (\"key1\", \"value1\"), (\"key2\", 2) ] -- Compile error
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-15")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import gleam/dict

dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", \"value2\")])
dict.from_list([#(\"key1\", \"value1\"), #(\"key2\", 2)]) // Type error!
",
        ),
      ]),
    ]),
    html.h2([attr.id("operators")], [html.text("Operators")]),
    html.p([], [
      html.text(
        "As Gleam does not treat integers and floats generically, there is a pattern of an extra ",
      ),
      html.code([], [html.text(".")]),
      html.text("to separate "),
      html.code([], [html.text("Int")]),
      html.text("operators from "),
      html.code([], [html.text("Float")]),
      html.text("operators."),
    ]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([attr("style", "text-align: left")], [html.text("Operator")]),
          html.th([attr("style", "text-align: left")], [html.text("Elm")]),
          html.th([attr("style", "text-align: left")], [html.text("Gleam  ")]),
          html.th([attr("style", "text-align: left")], [html.text("Notes")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Equal")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("==")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("==")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Not equal")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("/=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("!=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be of the same type"),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Greater than"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Greater than"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Greater or equal"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Greater or equal"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text(">=.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Less than")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Less than")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Less or equal"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Less or equal"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<=")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<=.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Boolean and"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("&&")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("&&")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Boolean or")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("||")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("||")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("bools")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Add")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("+")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("+")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Add")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("+")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("+.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Subtract")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("-")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("-")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Subtract")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("-")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("-.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Multiply")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("*")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("*")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Multiply")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("*")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("*.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Divide")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("//")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("/")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam Both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Divide")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("/")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("/.")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("floats")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Modulo")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("remainderBy")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("%")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text("In Gleam both values must be "),
            html.strong([], [html.text("ints")]),
          ]),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [
            html.text("Concatenate"),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("++")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("<>")]),
          ]),
          html.td([attr("style", "text-align: left")], []),
        ]),
        html.tr([], [
          html.td([attr("style", "text-align: left")], [html.text("Pipe")]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("|>")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.code([], [html.text("|>")]),
          ]),
          html.td([attr("style", "text-align: left")], [
            html.text(
              "Gleam’s pipe will try piping into the first position or Elm style as the only argument to a function, using whichever type checks.",
            ),
          ]),
        ]),
      ]),
    ]),
    html.h2([attr.id("type-aliases")], [html.text("Type Aliases")]),
    html.p([], [
      html.text(
        "Elm uses type aliases to define the layout of records. Gleam uses Custom Types to achieve a similar result.",
      ),
    ]),
    html.p([], [
      html.text(
        "Gleam’s custom types allow you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.",
      ),
    ]),
    html.h4([attr.id("elm-16")], [html.text("Elm")]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "type alias Person =
 { name : String
 , age : Int
 }

person = Person \"Jake\" 35
name = person.name
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-16")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam’s custom types can be used in much the same way. At runtime, they have a tuple representation and are compatible with Erlang records.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Person {
  Person(name: String, age: Int)
}

let person = Person(name: \"Jake\", age: 35)
let name = person.name
",
        ),
      ]),
    ]),
    html.h2([attr.id("custom-types")], [html.text("Custom Types")]),
    html.p([], [
      html.text(
        "Both Elm and Gleam have a similar concept of custom types. These allow you to list out the different states that a particular piece of data might have.",
      ),
    ]),
    html.h4([attr.id("elm-17")], [html.text("Elm")]),
    html.p([], [
      html.text("The following example might represent a user in a system:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "type User
  = LoggedIn String  -- A logged in user with a name
  | Guest            -- A guest user with no details
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "You must use a case-expression to interact with the contents of a value that uses a custom type:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "getName : User -> String
getName user =
    case user of
        LoggedIn name ->
            name

        Guest ->
            \"Guest user\"

",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "A custom type with a single entry can be used to help create opaque data types for your module’s API if only the type and not the single constructor is exported.",
      ),
    ]),
    html.h4([attr.id("gleam-17")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type User {
  LoggedIn(name: String)  // A logged in user with a name
  Guest                   // A guest user with no details
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Like in Elm, you must use a case-expression to interact with the contents of a value that uses a custom type.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn get_name(user) {
  case user {
    LoggedIn(name) -> name
    Guest -> \"Guest user\"
  }
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "In Gleam, a custom type with a single entry that has fields of its own fills the role of ",
      ),
      html.code([], [html.text("type alias")]),
      html.text("in Elm."),
    ]),
    html.p([], [
      html.text("In order to create an opaque data type, you can use the "),
      html.a(
        [
          attr.href(
            "https://tour.gleam.run/everything/#advanced-features-opaque-types",
          ),
        ],
        [html.code([], [html.text("opaque")])],
      ),
      html.text("keyword."),
    ]),
    html.h3([attr.id("maybe")], [html.text("Maybe")]),
    html.p([], [
      html.text(
        "Neither Gleam nor Elm have a concept of ‘null’ in their type system. Elm uses ",
      ),
      html.code([], [html.text("Maybe")]),
      html.text("to handle this case. Gleam uses a similar approach called "),
      html.code([], [html.text("Option")]),
      html.text("."),
    ]),
    html.h4([attr.id("elm-18")], [html.text("Elm")]),
    html.p([], [
      html.text("In Elm, "),
      html.code([], [html.text("Maybe")]),
      html.text("is defined as:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "type Maybe a
    = Just a
    | Nothing
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-18")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, "),
      html.code([], [html.text("Option")]),
      html.text("is defined as:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub type Option(a) {
  Some(a)
  None
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("The standard library provides the "),
      html.a([attr.href("https://hexdocs.pm/gleam_stdlib/gleam/option.html")], [
        html.text("gleam/option"),
      ]),
      html.text("module for interacting with "),
      html.code([], [html.text("Option")]),
      html.text("values."),
    ]),
    html.h3([attr.id("result")], [html.text("Result")]),
    html.p([], [
      html.text(
        "Neither Gleam nor Elm have exceptions and instead represent failures using the ",
      ),
      html.code([], [html.text("Result")]),
      html.text("type."),
    ]),
    html.h4([attr.id("elm-19")], [html.text("Elm")]),
    html.p([], [
      html.text("Elm’s "),
      html.code([], [html.text("Result")]),
      html.text("type is defined as:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "type Result error value
    = Ok value
    | Err error
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-19")], [html.text("Gleam")]),
    html.p([], [
      html.text("In Gleam, the "),
      html.code([], [html.text("Result")]),
      html.text(
        "type is defined in the compiler in order to support helpful warnings and error messages.",
      ),
    ]),
    html.p([], [
      html.text("If it were defined in Gleam, it would look like this:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "pub type Result(value, reason) {
  Ok(value)
  Error(reason)
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("The standard library provides the "),
      html.a([attr.href("https://hexdocs.pm/gleam_stdlib/gleam/result.html")], [
        html.text("gleam/result"),
      ]),
      html.text("module for interacting with "),
      html.code([], [html.text("Result")]),
      html.text("values."),
    ]),
    html.p([], [
      html.text("Similar to the Elm function "),
      html.code([], [html.text("Result.andThen")]),
      html.text(", the Gleam standard library includes a "),
      html.a(
        [attr.href("https://hexdocs.pm/gleam_stdlib/gleam/result.html#try")],
        [html.text("result.try")],
      ),
      html.text(
        "function that allows for chaining together functions that return ",
      ),
      html.code([], [html.text("Result")]),
      html.text("values. This can be used in conjunction with the "),
      html.code([], [html.text("use")]),
      html.text("keyword to allow for early returns from a function. A "),
      html.code([], [html.text("use")]),
      html.text("expression will take the value from the passed in "),
      html.code([], [html.text("Result")]),
      html.text(
        "and treat the rest of the function body as the function that should be called if the ",
      ),
      html.code([], [html.text("Result")]),
      html.text("is "),
      html.code([], [html.text("Ok")]),
      html.text(". If the passed in "),
      html.code([], [html.text("Result")]),
      html.text("is an "),
      html.code([], [html.text("Error")]),
      html.text(", the rest of the function body will not get called and the "),
      html.code([], [html.text("Error")]),
      html.text("will be immediately returned."),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let a_number = \"1\"
let an_error = \"ouch\"
let another_number = \"3\"

use int_a_number <- try(parse_int(a_number)) // parse_int(a_number) returns Ok(1) so int_a_number is bound to 1
use attempt_int <- try(parse_int(an_error)) // parse_int(an_error) returns an Error and will be returned
use int_another_number <- try(parse_int(another_number)) // never gets executed

Ok(int_a_number + attempt_int + int_another_number) // never gets executed
",
        ),
      ]),
    ]),
    html.h2([attr.id("if-expressions")], [html.text("If expressions")]),
    html.h4([attr.id("elm-20")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "Elm has syntax for if-expressions for control flow based on boolean values.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "description =
    if value then
        \"It's true!\"
    else
        \"It's not true.\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-20")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam has no built-in if-expression syntax and instead relies on matching on boolean values in case-expressions to provide this functionality:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "let description =
  case value {
    True -> \"It's true!\"
    False -> \"It's not true.\"
  }

description  // => \"It's true!\"
",
        ),
      ]),
    ]),
    html.h2([attr.id("case-expressions")], [html.text("Case expressions")]),
    html.p([], [
      html.text(
        "Both Gleam and Elm support case-expressions for pattern matching on values including custom types.",
      ),
    ]),
    html.h4([attr.id("elm-21")], [html.text("Elm")]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "getName : User -> String
getName user =
    case user of
        LoggedIn name ->
            name

        Guest ->
            \"Guest user\"
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-21")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "fn get_name(user) {
  case user {
    LoggedIn(name) -> name
    Guest -> \"Guest user\"
  }
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Pattern matching on multiple values at the same time is supported:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case x, y {
  1, 1 -> \"both are 1\"
  1, _ -> \"x is 1\"
  _, 1 -> \"y is 1\"
  _, _ -> \"neither is 1\"
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Guard expressions can also be used to limit when certain patterns are matched:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "case xs {
  [a, b, c] if a == b && b != c -> \"ok\"
  _other -> \"ko\"
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("For more information and examples, see the "),
      html.a(
        [
          attr.href(
            "https://tour.gleam.run/everything/#flow-control-case-expressions",
          ),
        ],
        [html.text("case expressions")],
      ),
      html.text("entry in the "),
      html.a([attr.href("https://tour.gleam.run/")], [
        html.text("Gleam language tour"),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("commands")], [html.text("Commands")]),
    html.h4([attr.id("elm-22")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "Elm is a pure language so all side-effects, eg. making an HTTP request, are managed by the command system. This means that functions for making HTTP requests return an opaque command value that you return to the runtime, normally via the update function, in order to execute the request.",
      ),
    ]),
    html.h4([attr.id("gleam-22")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam is not a pure language and so does not have a command system for managing side-effects. Any function can directly perform side effects and where necessary will manage success and failure using the ",
      ),
      html.code([], [html.text("Result")]),
      html.text("type or other more specific custom types."),
    ]),
    html.h2([attr.id("talking-to-other-languages")], [
      html.text("Talking to other languages"),
    ]),
    html.h4([attr.id("elm-23")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "Elm programs compile to JavaScript and primarily allow you to talk to JavaScript via ",
      ),
      html.a([attr.href("https://guide.elm-lang.org/interop/ports.html")], [
        html.text("ports"),
      ]),
      html.text(
        ". Elm does not have an accessible foreign function interface for calling JavaScript directly from Elm code. Only core modules can do that. Ports provide a message-passing interface between the Elm application and JavaScript. It is very safe. It is almost impossible to cause runtime errors in your Elm code by passing incorrect values to or from ports. This makes Elm a very safe language with very good guarantees against runtime exceptions but at the cost of some friction when the developer wants to interact with JavaScript.",
      ),
    ]),
    html.h4([attr.id("gleam-23")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam provides syntax for directly calling Erlang functions. The developer specifies the types for the Erlang function and the compiler assumes those types are accurate. This means less friction when calling Erlang code but also means less of a guarantee of safety as the developer might get the types wrong.",
      ),
    ]),
    html.p([], [
      html.text(
        "Gleam also provides a similar syntax for calling JavaScript functions via wrapper modules you provide.",
      ),
    ]),
    html.p([], [
      html.text(
        "Functions that call Erlang or JavaScript code directly use the ",
      ),
      html.code([], [html.text("@external")]),
      html.text("attr and use strings to refer to the module/function to call."),
    ]),
    html.p([], [
      html.text(
        "It is possible to call functions provided by other languages on the Erlang Virtual Machine but only via the Erlang name that those functions end up with.",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "@external(erlang, \"rand\", \"uniform\")
pub fn random_float() -> Float

// Elixir modules start with `Elixir.`
@external(erlang, \"Elixir.IO\", \"inspect\")
pub fn inspect(a) -> a

@external(erlang, \"calendar\", \"local_time\")
@external(javascript, \"./my_package_ffi.mjs\", \"now\")
pub fn now() -> DateTime
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("For more information and examples, see the "),
      html.a(
        [
          attr.href(
            "https://tour.gleam.run/everything/#advanced-features-externals",
          ),
        ],
        [html.text("Externals")],
      ),
      html.text("entry in the "),
      html.a([attr.href("https://tour.gleam.run/")], [
        html.text("Gleam language tour"),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("architecture")], [html.text("Architecture")]),
    html.h4([attr.id("elm-24")], [html.text("Elm")]),
    html.p([], [
      html.text(
        "Elm has ‘The Elm architecture’ baked into the language and the core modules. Generally speaking, all Elm applications follow the Elm architecture. Elm is generally focused on writing front-end browser applications and the architecture serves it well.",
      ),
    ]),
    html.h4([attr.id("gleam-24")], [html.text("Gleam")]),
    html.p([], [
      html.text(
        "Gleam does not have a set architecture. It is not focused on making front-end browser applications and so does not share the same constraints. As it compiles to Erlang, Gleam application architecture is influenced by Erlang approaches to building distributed, fault-tolerant systems including working with ",
      ),
      html.a(
        [attr.href("http://erlang.org/faq/introduction.html#idp32109712")],
        [html.text("OTP")],
      ),
      html.text(
        ". In order to create a type-safe version of the OTP approach, Gleam has its own ",
      ),
      html.a([attr.href("https://hexdocs.pm/gleam_otp/")], [
        html.text("gleam/otp"),
      ]),
      html.text("library."),
    ]),
    html.h2([attr.id("package-management")], [html.text("Package management")]),
    html.h4([attr.id("elm-25")], [html.text("Elm")]),
    html.p([], [
      html.text("Elm packages are installed via the "),
      html.code([], [html.text("elm install")]),
      html.text("command and are hosted on "),
      html.a([attr.href("https://package.elm-lang.org/")], [
        html.text("package.elm-lang.org"),
      ]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "All third-party Elm packages are written in pure Elm. It is not possible to publish an Elm package that includes JavaScript code unless you are in the core team. Some packages published under the ",
      ),
      html.code([], [html.text("elm")]),
      html.text("and "),
      html.code([], [html.text("elm-explorations")]),
      html.text("namespaces have JavaScript internals."),
    ]),
    html.h4([attr.id("gleam-25")], [html.text("Gleam")]),
    html.p([], [
      html.text("Gleam packages are installed via the "),
      html.code([], [html.text("gleam add")]),
      html.text("command and are hosted on "),
      html.a([attr.href("https://hex.pm/")], [html.text("hex.pm")]),
      html.text("with their documentation on "),
      html.a([attr.href("https://hexdocs.pm/")], [html.text("hexdocs.pm")]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "All Gleam packages can be published with a mix of Gleam and Erlang code. There are no restrictions on publishing packages with Erlang code or that wrap Erlang libraries.",
      ),
    ]),
    html.h2([attr.id("implementation")], [html.text("Implementation")]),
    html.h4([attr.id("elm-26")], [html.text("Elm")]),
    html.p([], [
      html.text("The Elm compiler is written in "),
      html.a([attr.href("https://www.haskell.org/")], [html.text("Haskell")]),
      html.text("and distributed primarily via "),
      html.a([attr.href("https://www.npmjs.com/")], [html.text("npm")]),
      html.text(
        ". The core libraries are written in a mix of Elm and JavaScript.",
      ),
    ]),
    html.h4([attr.id("gleam-26")], [html.text("Gleam")]),
    html.p([], [
      html.text("The Gleam compiler is written in "),
      html.a([attr.href("https://www.rust-lang.org/")], [html.text("Rust")]),
      html.text("and distributed as "),
      html.a([attr.href("https://github.com/gleam-lang/gleam/releases")], [
        html.text("precompiled binaries"),
      ]),
      html.text("or via some "),
      html.a(
        [
          attr.href(
            "https://gleam.run/getting-started/installing/#installing-gleam",
          ),
        ],
        [html.text("package managers")],
      ),
      html.text(
        ". The core libraries are written in a mix of Gleam and Erlang.",
      ),
    ]),
    html.h2([attr.id("other-concepts")], [html.text("Other concepts")]),
    html.h3([attr.id("atoms")], [html.text("Atoms")]),
    html.p([], [
      html.text(
        "Gleam has the concept of ‘atoms’ inherited from Erlang. Any value in a type definition in Gleam that does not have any arguments is an atom in the compiled Erlang code.",
      ),
    ]),
    html.p([], [
      html.text(
        "There are some exceptions to that rule for atoms that are commonly used and have types built-in to Gleam that incorporate them, such as ",
      ),
      html.code([], [html.text("Ok")]),
      html.text(", "),
      html.code([], [html.text("Error")]),
      html.text("and booleans."),
    ]),
    html.p([], [
      html.text(
        "In general, atoms are not used much in Gleam, and are mostly used for booleans, ",
      ),
      html.code([], [html.text("Ok")]),
      html.text(" and "),
      html.code([], [html.text("Error")]),
      html.text(" result types, and defining custom types."),
    ]),
    html.p([], [
      html.text(
        "Custom types in Elm can be used to achieve similar things to atoms.",
      ),
    ]),
    html.h4([attr.id("elm-27")], [html.text("Elm")]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "type Alignment
  = Left
  | Centre
  | Right
",
        ),
      ]),
    ]),
    html.h4([attr.id("gleam-27")], [html.text("Gleam")]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "type Alignment {
  Left
  Centre
  Right
}
",
        ),
      ]),
    ]),
    html.h3([attr.id("debugging")], [html.text("Debugging")]),
    html.h3([attr.id("elm-28")], [html.text("Elm")]),
    html.p([], [
      html.text("To aid debugging, Elm has a "),
      html.code([], [html.text("Debug.toString()")]),
      html.text("function:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-elm")], [
        html.text(
          "import Debug

Debug.toString [1,2] == \"[1,2]\"
",
        ),
      ]),
    ]),
    html.h3([attr.id("gleam-28")], [html.text("Gleam")]),
    html.p([], [
      html.text("To aid debugging, Gleam has a "),
      html.code([], [html.text("string.inspect()")]),
      html.text("function:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-gleam")], [
        html.text(
          "import gleam/string

string.inspect([1, 2, 3]) == \"[1, 2, 3]\"
",
        ),
      ]),
    ]),
  ]
  |> layout.with_header("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}
