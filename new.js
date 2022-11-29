function showPride() {
  document.body.classList.toggle("pride");
}

if (new Date().getMonth() === 6) showPride();

for (let element of document.querySelectorAll("[data-show-pride]")) {
  element.addEventListener("click", showPride);
}

for (let element of document.querySelectorAll("[data-randomise-order]")) {
  let children = Array.from(element.children);
  children.sort(() => Math.random() - 0.5);
  element.replaceChildren(...children);
}
