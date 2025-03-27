function showPride() {
  document.body.classList.toggle("pride");
}

function expandSponsorsSection() {
  document.documentElement.style.setProperty("--sponsors-max-height", "5000px");
}

if (new Date().getMonth() === 5) showPride();

for (let element of document.querySelectorAll("[data-show-pride]")) {
  element.addEventListener("click", showPride);
}

for (let element of document.querySelectorAll("[data-randomise-order]")) {
  let children = Array.from(element.children);
  children.sort(() => Math.random() - 0.5);
  element.replaceChildren(...children);
}

for (let element of document.querySelectorAll("[data-expand-sponsors]")) {
  element.addEventListener("click", expandSponsorsSection);
}
