let script = document.createElement("script");
script.async = true;
script.defer = true;
script.src = "https://plausible.io/js/plausible.js";
script.dataset.dataDomain = "gleam.run";
document.body.appendChild(script);
