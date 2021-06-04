pub fn main() {
  let input = query_selector("[data-hello-input]")
  let display = query_selector("[data-hello-display]")
  let sync = fn() {
    let text = get(from: input, property: "value")
    set("innerText", on: display, to: text)
  }
  set("oninput", on: input, to: sync)
}

external type Element

external fn query_selector(String) -> Element =
  "" "document.querySelector"

external fn get(from: Element, property: String) -> String =
  "" "Reflect.get"

external fn set(on: Element, property: String, to: anything) -> Bool =
  "" "Reflect.set"
