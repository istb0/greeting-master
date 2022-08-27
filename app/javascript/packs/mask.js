//マスクフィルター切り替え
const maskfilter = document.getElementById('maskfilter');
const mask = document.getElementById('mask');

let wearingMask = maskfilter.checked;

maskfilter.addEventListener('click', () => {
  wearingMask = maskfilter.checked;
  wearingMask ? mic.appendChild(mask) : mic.removeChild(mask);
});

export { wearingMask };
