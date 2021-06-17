pub fn main() {
  let numerator = query_selector("[data-multiples-numerator]")
  let denominator = query_selector("[data-multiples-denominator]")
  let display = query_selector("[data-multiples-display]")
  let sync = fn() { sync(display, numerator, denominator) }
  set("onchange", on: numerator, to: sync)
  set("onchange", on: denominator, to: sync)
  sync()
}

fn sync(display, numerator, denominator) {
  let numerator = parse_int(get(numerator, "value"))
  let denominator = parse_int(get(denominator, "value"))
  let text = case numerator % denominator {
    0 ->
      to_string(numerator)
      |> append(" is a multiple of ")
      |> append(to_string(denominator))
    _ ->
      to_string(numerator)
      |> append(" is not a multiple of ")
      |> append(to_string(denominator))
  }
  set(on: display, property: "innerText", to: text)
}

external type Element

external fn query_selector(String) -> Element =
  "" "document.querySelector"

external fn get(from: Element, property: String) -> String =
  "" "Reflect.get"

external fn set(on: Element, property: String, to: anything) -> Bool =
  "" "Reflect.set"

external fn append(String, String) -> String =
  "" "String.prototype.concat.call"

external fn to_string(Int) -> String =
  "" "String"

external fn parse_int(String) -> Int =
  "" "parseInt"
