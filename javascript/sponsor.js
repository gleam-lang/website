const sponsorLink = document.getElementsByClassName('sponsor-nav-link')[0]

sponsorLink.addEventListener('mouseover', scaleDecreaseHeart)

sponsorLink.addEventListener('mouseout',  scaleIncreaseHeart)

function scaleIncreaseHeart() {
  let svg = sponsorLink.getElementsByTagName('svg')[0];
  svg.setAttribute('transform', `scale(1)`);
}

function scaleDecreaseHeart(){
  let svg = sponsorLink.getElementsByTagName('svg')[0];
  svg.setAttribute('transform', `scale(1.2)`);
}
