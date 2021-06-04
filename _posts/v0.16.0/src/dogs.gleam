const url = "https://dog.ceo/api/breeds/image/random"

pub fn main() {
  let button = query_selector("[data-dogs-button]")
  let img = query_selector("[data-dogs-img]")
  new_dog(img)
  set(on: button, property: "onclick", to: fn() { new_dog(img) })
}

fn new_dog(img) {
  http_fetch(url)
  |> then(get_json_body)
  |> then(fn(json) {
    set(on: img, property: "src", to: get(json, "message"))
    resolve_promise(Nil)
  })
}

external type Element

external type Response

external type Json

external type Promise(value)

external fn query_selector(String) -> Element =
  "" "document.querySelector"

external fn get(from: Json, property: String) -> Json =
  "" "Reflect.get"

external fn set(on: Element, property: String, to: anything) -> Bool =
  "" "Reflect.set"

external fn http_fetch(String) -> Promise(Response) =
  "" "fetch"

external fn get_json_body(Response) -> Promise(Json) =
  "" "Response.prototype.json.call"

external fn then(Promise(a), fn(a) -> Promise(b)) -> Promise(b) =
  "" "Promise.prototype.then.call"

external fn resolve_promise(value) -> Promise(value) =
  "" "Promise.resolve"
