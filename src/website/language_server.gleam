import gleam/list
import gleam/string
import lustre/attribute as attr
import lustre/element.{type Element}
import lustre/element/html
import website/fs
import website/page
import website/site

pub type Section {
  Section(title: String, html: List(Element(Nil)), entries: List(Entry))
}

pub type Entry {
  Entry(title: String, html: List(Element(Nil)))
}

pub fn page(ctx: site.Context) -> fs.File {
  let sections = [
    Section("Project Status", project_status_html(), []),
    Section("Installation", installation_html(), [
      Entry("Helix", helix_installation_html()),
      Entry("Neovim", neovim_installation_html()),
      Entry("VS Code", vscode_installation_html()),
      Entry("Zed", zed_installation_html()),
      Entry("Other editors", other_editors_installation_html()),
    ]),
    Section("Features", [], [
      Entry("Multiple project support", multiple_project_support_html()),
      Entry("Project compilation", project_compilation_html()),
      Entry("Error and warning diagnostics", diagnostics_html()),
      Entry("Code formatting", formatting_html()),
      Entry("Hover", hover_html()),
      Entry("Go-to definition", goto_definition_html()),
      Entry("Go-to type definition", goto_type_definition_html()),
      Entry("Find references", find_references_html()),
      Entry("Code completion", code_completion_html()),
      Entry("Rename", rename_html()),
      Entry("Document symbols", document_symbols_html()),
      Entry("Signature help", signature_help_html()),
    ]),
    Section("Code actions", [], [
      Entry("Add annotations", add_annotations_html()),
      Entry("Add missing import", add_missing_import_html()),
      Entry("Add missing patterns", add_missing_patterns_html()),
      Entry("Case correction", case_correction_html()),
      Entry("Convert to and from pipe", convert_pipes_html()),
      Entry("Convert to and from use", convert_use_html()),
      Entry("Discard unused result", discard_unused_result_html()),
      Entry("Expand function capture", expand_function_capture_html()),
      Entry("Extract constant", extract_constant_html()),
      Entry("Extract variable", extract_variable_html()),
      Entry("Fill labels", fill_labels_html()),
      Entry("Fill unused fields", fill_unused_fields_html()),
      Entry("Generate decoder", generate_decoder_html()),
      Entry("Generate function", generate_function_html()),
      Entry("Generate to-JSON function", generate_to_json_function_html()),
      Entry("Inexhaustive let to case", inexhaustive_let_to_case_html()),
      Entry("Inline variable", inline_variable_html()),
      Entry("Interpolate string", interpolate_string_html()),
      Entry("Pattern match", pattern_match_html()),
      Entry("Qualify and unqualify", qualify_and_unqualify_html()),
      Entry("Remove echo", remove_echo_html()),
      Entry("Remove redundant tuples", remove_redundant_tuples_html()),
      Entry("Remove unused imports", remove_unused_imports_html()),
      Entry("Use label shorthand syntax", use_label_shorthand_syntax_html()),
      Entry("Wrap in block", wrap_in_block_html()),
    ]),
    Section("Security", security_html(), []),
    Section("Use outside Gleam projects", use_outside_gleam_projects_html(), []),
  ]

  let table_of_contents =
    html.ul(
      [],
      list.map(sections, fn(section) {
        html.li([], [
          html.a([attr.href("#" <> slug(section.title))], [
            html.text(section.title),
          ]),
          case section.entries {
            [] -> element.none()
            _ ->
              html.ul(
                [],
                list.map(section.entries, fn(entry) {
                  html.li([], [
                    html.a([attr.href("#" <> slug(entry.title))], [
                      html.text(entry.title),
                    ]),
                  ])
                }),
              )
          },
        ])
      }),
    )

  let content =
    list.flat_map(sections, fn(section) {
      list.flatten([
        [html.h1([attr.id(slug(section.title))], [html.text(section.title)])],
        section.html,
        list.flat_map(section.entries, fn(entry) {
          [
            html.h2([attr.id(slug(entry.title))], [html.text(entry.title)]),
            ..entry.html
          ]
        }),
      ])
    })

  let meta =
    page.PageMeta(
      path: "language-server",
      title: "The Gleam Language Server reference",
      description: "IDE features for all editors",
      preload_images: [],
    )

  [
    html.p([], [
      html.text(
        "The Gleam Language Server is a program that can provide IDE features
        to text editors that implement the language server protocol, such as VS
        Code and Neovim. This document details the current state of the
        language server and its features.",
      ),
    ]),
    table_of_contents,
    ..content
  ]
  |> page.page_layout("prose", meta, ctx)
  |> page.to_html_file(meta)
}

fn wrap_in_block_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action wraps an assignment value or case expression clause
        value in a block, making it easy to add additional expressions.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "
pub fn f(pokemon_type: PokemonType) {
  case pokemon_type {
    Water -> soak()
    Fire -> burn()
  }
}",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("soak")]),
      html.text(
        " call the code action will be suggested, and if run the module will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn f(pokemon_type: PokemonType) {
  case pokemon_type {
    Water -> {
      soak()
    }
    Fire -> burn()
  }
}",
    ),
  ]
}

fn remove_echo_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("This code action removes "),
      html.code([], [html.text("echo")]),
      html.text("expressions, useful for once you have finished debugging."),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  echo 1 + 2
}",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("echo")]),
      html.text(
        " the code action will be suggested, and if run the module will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  1 + 2
}",
    ),
    html.text("If your module has multiple "),
    html.code([], [html.text("echo")]),
    html.text(" expressions within it they will all be removed."),
  ]
}

fn fill_unused_fields_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can add any fields that were not matched on in a pattern.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub type Pokemon {
  Pokemon(id: Int, name: String, moves: List(String))
}

pub fn main() {
  let Pokemon(..) = todo
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("..")]),
      html.text(
        "import the code action will be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub type Pokemon {
  Pokemon(id: Int, name: String, moves: List(String))
}

pub fn main() {
  let Pokemon(id:, name:, moves:) = todo
}
",
    ),
  ]
}

fn find_references_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server supports find references for these entities:",
      ),
    ]),
    html.ul([], [
      html.li([], [html.text("Functions.")]),
      html.li([], [html.text("Function arguments.")]),
      html.li([], [html.text("Constants.")]),
      html.li([], [html.text("Types")]),
      html.li([], [html.text("Custom type variants")]),
      html.li([], [html.text("Variables.")]),
    ]),
  ]
}

fn use_outside_gleam_projects_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server is unable to build Gleam code that are not in Gleam
projects. When one of these files is opened the language server will provide
code formatting but other features are not available.",
      ),
    ]),
  ]
}

fn security_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server does not perform code generation or compile Erlang or Elixir
code, so there is no chance of any code execution occurring due to opening a
file in an editor using the Gleam language server.",
      ),
    ]),
  ]
}

fn use_label_shorthand_syntax_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action updates calls and patterns to use the label shorthand syntax.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "case date {
  Day(day: day, month: month, year: year) -> todo
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the call that could use the shorthand syntax the code
action will be suggested, and if run the module will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "case date {
  Day(day:, month:, year:) -> todo
}
",
    ),
  ]
}

fn remove_redundant_tuples_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action removes redundant tuples from case expression subjects and
patterns.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "case #(a, b) {
  #(1, 2) -> todo
  _ -> todo
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the case expression the code action will be suggested,
and if run the module will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "case a, b {
  1, 2 -> todo
  _, _ -> todo
}
",
    ),
  ]
}

fn remove_unused_imports_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can be used to delete unused import statements from a module.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/io
import gleam/list

pub fn main() {
  io.println(\"Hello, Joe!\")
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the unused "),
      html.code([], [html.text("import gleam/list")]),
      html.text(
        "import the code action
will be suggested, and if run the module will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/io

pub fn main() {
  io.println(\"Hello, Joe!\")
}
",
    ),
  ]
}

fn qualify_and_unqualify_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "These code actions can be used to add or remove module qualifiers for types and
values.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/option.{Some}

pub fn main() {
  [Some(1), Some(2)]
}
",
    ),
    html.p([], [
      html.text("If your cursor is within one of the "),
      html.code([], [html.text("Some")]),
      html.text(
        "s then the “qualify” code action will
be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/option.{}

pub fn main() {
  [option.Some(1), option.Some(2)]
}
",
    ),
    html.p([], [
      html.text(
        "Note that the import statement has been updated as needed, and all instances of
the ",
      ),
      html.code([], [html.text("Some")]),
      html.text("constructor in the module have been qualified."),
    ]),
    html.p([], [
      html.text(
        "The “unqualify” action behaves the same, except it removes module qualifiers.",
      ),
    ]),
    html.p([], [
      html.text(
        "The “unqualify” action is available for types and custom type variants
constructors. The “qualify” action is available for all types and values.",
      ),
    ]),
  ]
}

fn pattern_match_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can generate an exhaustive case expression for variable or argument.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/list

pub fn run(items: List(Int)) -> Nil {
  let result = list.first(items)
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("result")]),
      html.text(
        "assignment then the code action will be
suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/list

pub fn run(items: List(Int)) -> Nil {
  let result = list.first(items)
  case result {
    Ok(value) -> todo
    Error(value) -> todo
  }
}
",
    ),
  ]
}

fn interpolate_string_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can split a string in order to interpolate a value.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn greet(name: String) -> String {
  \"Hello, !\"
}
",
    ),
    html.p([], [
      html.text("If your cursor is before the "),
      html.code([], [html.text("!")]),
      html.text(
        "character in the string then the code action
will be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn greet(name: String) -> String {
  \"Hello, \" <> todo <> \"!\"
}
",
    ),
    html.p([], [
      html.text(
        "If the cursor is selecting a valid Gleam name then that will be used as a
variable name in the interpolation.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn greet(name: String) -> String {
  \"Hello, name!\"
  //      ^^^^ This is selected
}
",
    ),
    page.highlighted_gleam_pre_code(
      "pub fn greet(name: String) -> String {
  \"Hello, \" <> name <> \"!\"
}
",
    ),
  ]
}

fn inline_variable_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can inline a variable that is used only once.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  let greeting = \"Hello!\"
  echo greeting
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("greeting")]),
      html.text(
        "variable then the code action will be
suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  echo \"Hello!\"
}
",
    ),
  ]
}

fn inexhaustive_let_to_case_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("This code action can convert from "),
      html.code([], [html.text("let")]),
      html.text("to "),
      html.code([], [html.text("case")]),
      html.text("when the pattern is not exhaustive."),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn unwrap_result(result: Result(a, b)) -> a {
  let Ok(inner) = result // error: inexhaustive
  inner
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("let")]),
      html.text(
        "assignment then the code action will be
suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn unwrap_result(result: Result(a, b)) -> a {
  let inner = case result {
    Ok(inner) -> inner
    Error(_) -> todo
  }
  inner
}
",
    ),
  ]
}

fn generate_to_json_function_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can generate a function that turns a custom type value into JSON using the ",
      ),
      html.code([], [html.text("gleam_json")]),
      html.text("library."),
    ]),
    page.highlighted_gleam_pre_code(
      "pub type Person {
  Person(name: String, age: Int)
}
",
    ),
    html.p([], [
      html.text("If your cursor is within "),
      html.code([], [html.text("pub type Person {")]),
      html.text(
        "definition then the code action will be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/json

pub type Person {
  Person(name: String, age: Int)
}

fn person_to_json(person: Person) -> json.Json {
  let Person(name:, age:) = person
  json.object([
    #(\"name\", json.string(person.name)),
    #(\"age\", json.int(person.age)),
  ])
}
",
    ),
  ]
}

fn generate_function_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can generate the definition of a local function that is being
used but does not yet exist.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  let items = [1, 2, 3]
  io.println(describe(items))
}
",
    ),
    html.p([], [
      html.text("If your cursor is within "),
      html.code([], [html.text("describe")]),
      html.text(
        "then the code action will be suggested,
and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/io

pub fn main() {
  let items = [1, 2, 3]
  io.println(describe(items))
}

fn describe(list: List(Int) -> String {
  todo
}
",
    ),
  ]
}

fn generate_decoder_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can generate a dynamic decoder function from a custom type
definition.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub type Person {
  Person(name: String, age: Int)
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("Person")]),
      html.text(
        "then the code action will be suggested,
and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/dynamic/decode

pub type Person {
  Person(name: String, age: Int)
}

fn person_decoder() -> decode.Decoder(Person) {
  use name <- decode.field(\"name\", decode.string)
  use age <- decode.field(\"age\", decode.int)
  decode.success(Person(name:, age:))
}
",
    ),
  ]
}

fn fill_labels_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("This code action can add any expected labels to a call."),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  Date()
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("Date()")]),
      html.text(
        "import the code action will be suggested,
and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  Date(year: todo, month: todo, day: todo)
}
",
    ),
  ]
}

fn extract_variable_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("This code action assigns assigns an expression to a variable."),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  list.each([\"Hello, Mike!\", \"Hello, Joe!\"], io.println)
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the list then code action will be suggested, and if
run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  let value = [\"Hello, Mike!\", \"Hello, Joe!\"]
  list.each(value, io.println)
}
",
    ),
  ]
}

fn extract_constant_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("This code action assigns assigns an expression to a constant."),
    ]),
    page.highlighted_gleam_pre_code(
      "const first = \"Hello, Mike!\"

pub fn main() {
  list.each([first, \"Hello, Joe!\"], io.println)
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the list then code action will be suggested, and if
run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "const first = \"Hello, Mike!\"

const values = [first, \"Hello, Joe!\"]

pub fn main() {
  list.each(values, io.println)
}
",
    ),
  ]
}

fn expand_function_capture_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action converts from the function capture syntax to an anonymous function.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  let add_eleven = int.add(_, 11)
  list.map([1, 2, 3], add_eleven)
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the function capture then code action will be
suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  list.map([1, 2, 3], fn(value) { int.add(value, 11) })
}
",
    ),
  ]
}

fn discard_unused_result_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("This code action assigns unused results to "),
      html.code([], [html.text("_")]),
      html.text(
        ", silencing the warning. Typically
it is better to handle the result than to ignore the possible failure.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  function_which_can_fail()
  io.println(\"Done!\")
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the result-returning-statement then code action
will be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  let _ = function_which_can_fail()
  io.println(\"Done!\")
}
",
    ),
  ]
}

fn convert_use_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("These code actions can be used to convert between the "),
      html.code([], [html.text("use")]),
      html.text(
        "syntax and the
regular function call syntax.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  use profile <- result.try(fetch_profile(user))
  render_welcome(user, profile)
}
",
    ),
    html.p([], [
      html.text("If your cursor is within one of the "),
      html.code([], [html.text("use")]),
      html.text(
        "expression then the code action will
be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn main() {
  result.try(fetch_profile(user), fn(profile) {
    render_welcome(user, profile)
  })
}
",
    ),
    html.p([], [
      html.text("The running the code action again will reverse this change."),
    ]),
  ]
}

fn convert_pipes_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("These code actions can be used to convert between the "),
      html.code([], [html.text("|>")]),
      html.text(
        "pipe syntax and the
regular function call syntax.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/list

pub fn main() {
  list.map([1, 2, 3], double)
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the list argument then the code action will be
suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/list

pub fn main() {
  [1, 2, 3] |> list.map(double)
}
",
    ),
    html.p([], [
      html.text("The running the code action again will reverse this change."),
    ]),
    html.p([], [
      html.text(
        "You can also choose to pipe arguments other than the first by selecting them in
your editor before triggering the code action.",
      ),
    ]),
  ]
}

fn case_correction_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can correct names written with the wrong case.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub main() {
  let myNumber = 100
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the name written with the wrong case then code action
will be suggested, and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub main() {
  let my_number = 100
}
",
    ),
  ]
}

fn document_symbols_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server supports listing document symbols, such as functions and
constants, for the current Gleam file.",
      ),
    ]),
  ]
}

fn add_missing_patterns_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can add missing patterns to an inexhaustive case expression.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn run(value: Bool) -> Nil {
  case value {}
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within the case expression then code action will be suggested,
and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn run(value: Bool) -> Nil {
  case value {
    True -> todo
    False -> todo
  }
}
",
    ),
  ]
}

fn add_missing_import_html() -> List(Element(Nil)) {
  [
    html.p([], [html.text("This code action can add missing imports.")]),
    page.highlighted_gleam_pre_code(
      "pub fn main() -> Nil {
  io.println(\"Hello, world!\")
}
",
    ),
    html.p([], [
      html.text("If your cursor is within the "),
      html.code([], [html.text("io.println")]),
      html.text(
        "and there is an importable module with
the name ",
      ),
      html.code([], [html.text("io")]),
      html.text("and a function named "),
      html.code([], [html.text("println")]),
      html.text(
        "then code action will be suggested,
and if run the code will be updated to this:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "import gleam/io

pub fn main() -> Nil {
  io.println(\"Hello, world!\")
}
",
    ),
  ]
}

fn add_annotations_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "This code action can add type annotations to assignments and functions.",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn increment(x) {
  x + 1
}
",
    ),
    html.p([], [
      html.text(
        "If your cursor is within a function that does not have the all of the argument
types and the return type annotated then code action will be suggested, and if
run the code will be updated to include them:",
      ),
    ]),
    page.highlighted_gleam_pre_code(
      "pub fn increment(x: Int) -> Int {
  x + 1
}
",
    ),
    html.p([], [
      html.text("It can also be triggered on "),
      html.code([], [html.text("let")]),
      html.text("and "),
      html.code([], [html.text("use")]),
      html.text("assignments."),
    ]),
  ]
}

fn signature_help_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server can show the type of each argument when calling a function,
along with the labels of the arguments that have them.",
      ),
    ]),
  ]
}

fn rename_html() -> List(Element(Nil)) {
  [
    html.p([], [html.text("The langauge server is able to rename:")]),
    html.ul([], [
      html.li([], [html.text("Functions.")]),
      html.li([], [html.text("Function arguments.")]),
      html.li([], [html.text("Constants.")]),
      html.li([], [html.text("Types")]),
      html.li([], [html.text("Custom type variants")]),
      html.li([], [html.text("Variables.")]),
    ]),
  ]
}

fn code_completion_html() -> List(Element(Nil)) {
  [
    html.p([], [html.text("The language server support completion of:")]),
    html.ul([], [
      html.li([], [html.text("Function arguments.")]),
      html.li([], [
        html.text(
          "Functions and constants defined in other modules, automatically adding import statements if the module has not yet been imported.",
        ),
      ]),
      html.li([], [
        html.text("Functions and constants defined in the same module."),
      ]),
      html.li([], [html.text("Locally defined variables.")]),
      html.li([], [html.text("Modules in import statements.")]),
      html.li([], [html.text("Record fields.")]),
      html.li([], [html.text("Type constructors in type annotations.")]),
      html.li([], [
        html.text("Unqualified types and values in import statements."),
      ]),
    ]),
  ]
}

fn goto_type_definition_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server supports go-to type definition. When triggered on an
expression the language server will identify the types of all the values used in
the expression and present their definitions for you to view and to jump to.",
      ),
    ]),
  ]
}

fn goto_definition_html() -> List(Element(Nil)) {
  [
    html.p([], [html.text("The language server supports go-to definition for:")]),
    html.ul([], [
      html.li([], [html.text("Constants.")]),
      html.li([], [html.text("Functions.")]),
      html.li([], [
        html.text("Import statements, including unqualified values and types."),
      ]),
      html.li([], [html.text("Type annotations.")]),
      html.li([], [html.text("Variables.")]),
    ]),
  ]
}

fn hover_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server will show documentation, types, and other information when
hovering on:",
      ),
    ]),
    html.ul([], [
      html.li([], [html.text("Constants.")]),
      html.li([], [
        html.text("Import statements, including unqualified values and types."),
      ]),
      html.li([], [html.text("Module functions.")]),
      html.li([], [html.text("Module qualifiers.")]),
      html.li([], [html.text("Patterns.")]),
      html.li([], [html.text("Record fields.")]),
      html.li([], [
        html.text("The "),
        html.code([], [html.text("..")]),
        html.text("used to ignore additional fields in record pattern."),
      ]),
      html.li([], [html.text("Type annotations.")]),
      html.li([], [html.text("Values.")]),
    ]),
  ]
}

fn formatting_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server can format Gleam code using the Gleam formatter. You may
want to configure your code to run this automatically when you save a file.",
      ),
    ]),
  ]
}

fn diagnostics_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "Any errors and warnings found when compiling Gleam code are surfaced in the
editor as language server diagnostics.",
      ),
    ]),
  ]
}

fn project_compilation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The language server will automatically compile code in Gleam projects opened in
        the editor. Code generation and Erlang compilation are not performed.",
      ),
    ]),
    html.p([], [
      html.text(
        "If any files are edited in the editor but not yet saved then these edited
versions will be used when compiling in the language server.",
      ),
    ]),
    html.p([], [
      html.text("The target specified in "),
      html.code([], [html.text("gleam.toml")]),
      html.text(
        "is used by the language server. If no
target is specified then it defaults to Erlang.",
      ),
    ]),
  ]
}

fn multiple_project_support_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "You can open Gleam files from multiple projects in one editor session and the
Gleam language server will understand which projects they each belong to, and
how to work with each of them.",
      ),
    ]),
  ]
}

fn other_editors_installation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "Any other editor that supports the Language Server Protocol can use the Gleam
        Language Server. Configure your editor to run ",
      ),
      html.code([], [html.text("gleam lsp")]),
      html.text("from the root of your workspace."),
    ]),
  ]
}

fn zed_installation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "When a Gleam file is opened, Zed will suggest to install the Gleam plugin, once installed the language server will automatically be started when you open a Gleam file.",
      ),
    ]),
  ]
}

fn vscode_installation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("Install the "),
      html.a(
        [
          attr.href(
            "https://marketplace.visualstudio.com/items?itemName=Gleam.gleam",
          ),
        ],
        [html.text("VS Code Gleam plugin")],
      ),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "The language server will then automatically started when you open a Gleam
file. If VS Code is unable to run the language server ensure that the ",
      ),
      html.code([], [html.text("gleam")]),
      html.text(" binary is included on VS Code’s "),
      html.code([], [html.text("PATH")]),
      html.text(", and consider restarting VS Code."),
    ]),
  ]
}

fn neovim_installation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("Neovim’s "),
      html.a([attr.href("https://github.com/neovim/nvim-lspconfig")], [
        html.code([], [html.text("nvim-lspconfig")]),
      ]),
      html.text(" includes configuration for Gleam. Install "),
      html.code([], [html.text("nvim-lspconfig")]),
      html.text(
        " with your preferred plugin manager and then add the language server to your ",
      ),
      html.code([], [html.text("init.lua")]),
      html.text("."),
    ]),
    html.code([], [html.text("require('lspconfig').gleam.setup({})")]),
    html.p([], [
      html.text(
        "The language server will then be automatically started when you open a Gleam file.",
      ),
    ]),
    html.p([], [
      html.text("If you are using "),
      html.a([attr.href("https://github.com/nvim-treesitter/nvim-treesitter")], [
        html.code([], [html.text("nvim-treesitter")]),
      ]),
      html.text(" you can run "),
      html.code([], [html.text(":TSInstall gleam")]),
      html.text(" to get syntax highlighting and other tree-sitter features."),
    ]),
  ]
}

fn helix_installation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "Helix supports the language server out-of-the-box. No additional
        configuration is required and Helix will automatically start the
        language server when a Gleam file is opened.",
      ),
    ]),
  ]
}

fn installation_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text("The Gleam Language Server is included in the regular "),
      html.code([], [html.text("gleam")]),
      html.text(
        " binary, so if you
have Gleam installed then you have the Gleam language server installed. You may
need to configure your editor to use the language server for Gleam code.",
      ),
    ]),
  ]
}

fn project_status_html() -> List(Element(Nil)) {
  [
    html.p([], [
      html.text(
        "The Gleam Language Server is an official Gleam project and the
          newest part of the Gleam toolchain. It is actively being developed and
          is rapidly improving, but it does not have all the features you might
          find in more mature language servers for older languages.",
      ),
    ]),
    html.p([], [
      html.text(
        "If you wish to to see what is currently being worked on you can view ",
      ),
      html.a([attr.href("https://github.com/orgs/gleam-lang/projects/4")], [
        html.text("the project roadmap"),
      ]),
      html.text(" on GitHub."),
    ]),
  ]
}

fn slug(text: String) -> String {
  text |> string.lowercase |> string.replace(" ", "-")
}
