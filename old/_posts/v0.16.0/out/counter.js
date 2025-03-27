"use strict";

export function main() {
  let increment = query_selector("[data-counter-increment]");
  let decrement = query_selector("[data-counter-decrement]");
  let display = query_selector("[data-counter-display]");
  let add = (diff) => {
    return set(display, "innerText", get_value(display) + diff);
  };
  set(increment, "onclick", () => { return add(1); });
  return set(decrement, "onclick", () => { return add(-1); });
}

function get_value(element) {
  return parse_int(get(element, "innerText"));
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

function parse_int(arg0) {
  return parseInt(arg0)
}
