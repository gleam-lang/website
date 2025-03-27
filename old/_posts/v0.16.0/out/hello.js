"use strict";

export function main() {
  let input = query_selector("[data-hello-input]");
  let display = query_selector("[data-hello-display]");
  let sync = () => {
    let text = get(input, "value");
    return set(display, "innerText", text);
  };
  return set(input, "oninput", sync);
}

function query_selector(arg0) {
  return document.querySelector(arg0)
}

function get(from, property) {
  return Reflect.get(from, property)
}

function set(on, property, to) {
  return Reflect.set(on, property, to)
}
