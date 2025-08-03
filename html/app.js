const PRN = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'xen_clotheshop';
const nf  = new Intl.NumberFormat('hu-HU');

const app       = document.getElementById('app');
const tabList   = document.getElementById('tabList');
const controls  = document.getElementById('controls');
const sumPrice  = document.getElementById('sumPrice');
const toasts    = document.getElementById('toasts');
const btnCancel = document.getElementById('btnCancel');
const btnBuy    = document.getElementById('btnBuy');
const camLeft   = document.getElementById('camLeft');
const camRight  = document.getElementById('camRight');
const camIn     = document.getElementById('camIn');
const camOut    = document.getElementById('camOut');
const btnPeek   = document.getElementById('btnPeek');

const tabs = [
  { key: 'tshirt',    label: 'Póló',     fields: ['tshirt_1','tshirt_2'] },
  { key: 'torso',     label: 'Felső',    fields: ['torso_1','torso_2'] },
  { key: 'decals',    label: 'Dekor',    fields: ['decals_1','decals_2'] },
  { key: 'arms',      label: 'Kar',      fields: ['arms'] },
  { key: 'pants',     label: 'Nadrág',   fields: ['pants_1','pants_2'] },
  { key: 'shoes',     label: 'Cipő',     fields: ['shoes_1','shoes_2'] },
  { key: 'mask',      label: 'Maszk',    fields: ['mask_1','mask_2'] },
  { key: 'bags',      label: 'Táska',    fields: ['bags_1','bags_2'] },
  { key: 'bproof',    label: 'Mellény',  fields: ['bproof_1','bproof_2'] },
  { key: 'chain',     label: 'Lánc',     fields: ['chain_1','chain_2'] },
  { key: 'helmet',    label: 'Fejfedő',  fields: ['helmet_1','helmet_2'] },
  { key: 'glasses',   label: 'Szemüveg', fields: ['glasses_1','glasses_2'] },
  { key: 'ears',      label: 'Fül',      fields: ['ears_1','ears_2'] },
  { key: 'watches',   label: 'Óra',      fields: ['watches_1','watches_2'] },
  { key: 'bracelets', label: 'Karkötő',  fields: ['bracelets_1','bracelets_2'] },
];

let basePrice = {};
let activeTab = 'tshirt';
let basket    = {};
let state     = { sex: 'male' };
let previewTimer;
let hintShown = false;

const nui = (name, data={}) => fetch(`https://${PRN}/${name}`, {
  method: 'POST', headers: {'Content-Type':'application/json; charset=UTF-8'},
  body: JSON.stringify(data)
}).catch(e => console.warn('NUI call failed:', name, e));

const toast = msg => {
  const el = document.createElement('div');
  el.className = 'toast'; el.textContent = msg;
  toasts.appendChild(el);
  setTimeout(() => el.remove(), 2300);
};

function renderTabs() {
  tabList.replaceChildren(...tabs.map(tab => {
    const el = document.createElement('div');
    el.className = `tab${tab.key===activeTab?' active':''}`;
    el.dataset.tab = tab.key;
    el.innerHTML = `<span class="label">${tab.label}</span><span class="price">${nf.format(basePrice[tab.key]||0)} $</span>`;
    el.addEventListener('click', () => {
      activeTab = tab.key;
      renderTabs(); renderControls(); nui('focus', { group: activeTab });
    });
    return el;
  }));
}

function renderControls() {
  controls.innerHTML = '';
  const tab = tabs.find(t => t.key === activeTab);
  if (!tab) return;
  tab.fields.forEach((field, idx) => {
    const wrap = document.createElement('div'); wrap.className = 'ctrl';
    wrap.innerHTML = `
      <div class="label">${idx===0?'Típus':'Textúra'}</div>
      <div class="row">
        <button class="btn" data-d="-1">◀</button>
        <input class="input" data-field="${field}" type="number" value="0" min="0" />
        <button class="btn" data-d="1">▶</button>
      </div>`;
    const input = wrap.querySelector('input');
    wrap.addEventListener('click', e => {
      if (e.target.matches('button')) {
        const delta = +e.target.dataset.d;
        input.value = Math.max(0, +input.value + delta);
        onPreview(field, +input.value);
      }
    });
    input.addEventListener('change', () => {
      input.value = Math.max(0, +input.value);
      onPreview(field, +input.value);
    });
    controls.append(wrap);
  });
}

function recalcTotal() {
  const total = Object.entries(basket)
    .filter(([, used]) => used)
    .reduce((sum, [key]) => sum + (basePrice[key]||0), 0);
  sumPrice.textContent = `${nf.format(total)} $`;
}

function onPreview(key, value) {
  const tab = tabs.find(t => t.fields.includes(key));
  if (tab) basket[tab.key] = true;
  recalcTotal();
  clearTimeout(previewTimer);
  previewTimer = setTimeout(() => nui('previewChange', { key, value }), 10);
}

window.addEventListener('message', ({ data }) => {
  if (data.action === 'open') {
    basePrice = data.data.basePrice || {};
    state.sex = data.data.sex || 'male';
    basket = {};
    activeTab = 'tshirt';
    renderTabs(); renderControls(); nui('focus', { group: activeTab });
    app.style.display = 'block';
  }
  if (data.action === 'close') {
    app.style.display = 'none';
  }
});

btnCancel.onclick = () => nui('cancel');
btnBuy.onclick    = () => nui('purchase');
camLeft.onclick   = () => nui('cam', { cmd: 'rotLeft' });
camRight.onclick  = () => nui('cam', { cmd: 'rotRight' });
camIn.onclick     = () => nui('cam', { cmd: 'zoomIn' });
camOut.onclick    = () => nui('cam', { cmd: 'zoomOut' });
btnPeek.onclick   = () => {
  const peek = document.body.classList.toggle('peek');
  btnPeek.textContent = peek ? 'Mutat' : 'Elrejt';
};

app.style.display = 'none';
console.log('NUI PRN =', PRN);
