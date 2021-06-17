"use strict";

const url = "https://dog.ceo/api/breeds/image/random";

export function main() {
  let button = query_selector("[data-dogs-button]");
  let img = query_selector("[data-dogs-img]");
  new_dog(img);
  return set(button, "onclick", () => { return new_dog(img); });
}

function new_dog(img) {
  return then(
    then(fetch(url), get_json_body),
    (json) => {
      set(img, "src", get(json, "message"));
      return resolve_promise(undefined);
    },
  );
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

function fetch(arg0) {
  return globalThis.fetch(arg0)
}

function get_json_body(arg0) {
  return Response.prototype.json.call(arg0)
}

function then(arg0, arg1) {
  return Promise.prototype.then.call(arg0, arg1)
}

function resolve_promise(arg0) {
  return Promise.resolve(arg0)
}
