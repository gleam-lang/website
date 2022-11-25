function showPride() {
  document.body.classList.toggle("pride");
}

if (new Date().getMonth() === 6) showPride();

document
  .querySelector("[data-show-pride]")
  ?.addEventListener("click", showPride);
