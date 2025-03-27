pub fn main() {
  let increment = query_selector("[data-counter-increment]")
  let decrement = query_selector("[data-counter-decrement]")
  let display = query_selector("[data-counter-display]")
  let add = fn(diff) {
    set("innerText", on: display, to: get_value(display) + diff)
  }
  set("onclick", on: increment, to: fn() { add(1) })
  set("onclick", on: decrement, to: fn() { add(-1) })
}

fn get_value(element) {
  element
  |> get(property: "innerText")
  |> parse_int
}

external type Element

external fn query_selector(String) -> Element =
  "" "document.querySelector"

external fn get(from: Element, property: String) -> String =
  "" "Reflect.get"

external fn set(on: Element, property: String, to: anything) -> Bool =
  "" "Reflect.set"

external fn parse_int(String) -> Int =
  "" "parseInt"
