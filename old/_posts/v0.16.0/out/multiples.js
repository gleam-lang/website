"use strict";

export function main() {
  let numerator = query_selector("[data-multiples-numerator]");
  let denominator = query_selector("[data-multiples-denominator]");
  let display = query_selector("[data-multiples-display]");
  let sync$1 = () => { return sync(display, numerator, denominator); };
  set(numerator, "onchange", sync$1);
  set(denominator, "onchange", sync$1);
  return sync$1();
}

function sync(display, numerator, denominator) {
  let numerator$1 = parse_int(get(numerator, "value"));
  let denominator$1 = parse_int(get(denominator, "value"));
  let text = (() => { let $ = numerator$1 % denominator$1;
    if ($ === 0) {
      return append(
        append(to_string(numerator$1), " is a multiple of "),
        to_string(denominator$1),
      );
    } else {
      return append(
        append(to_string(numerator$1), " is not a multiple of "),
        to_string(denominator$1),
      );
    } })();
  return set(display, "innerText", text);
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

function append(arg0, arg1) {
  return String.prototype.concat.call(arg0, arg1)
}

function to_string(arg0) {
  return String(arg0)
}

function parse_int(arg0) {
  return parseInt(arg0)
}
