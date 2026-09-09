// skilltree.js — draws the publication skill tree from www/tree.json.
//
// No dependencies. R (R/build_tree.R) has already done the thinking: positions, regions, labels,
// links and contribution scores all arrive in the JSON. This file only puts SVG on the page and
// handles hover / focus / click. Keep it that way: logic belongs in R, not here.
//
// Interaction (Phase 1): hover or keyboard-focus a hex → tooltip with title, venue, role and the
// six contribution bars. Click / Enter / Space pins the tooltip (also how touch works); Esc or a
// click elsewhere unpins. The click → detail panel is Phase 2.

(function () {
  'use strict';
  const root = document.getElementById('skilltree');
  const tip  = document.getElementById('skilltree-tooltip');
  if (!root || !tip) return;
  // Quarto's content column is its own stacking context (z-index 998, opacity .999), so a fixed
  // panel inside it can never rise above the fixed-top navbar (1030). Portal the overlays to <body>.
  document.body.appendChild(tip);
  const panelEl = document.getElementById('skilltree-panel');
  if (panelEl) document.body.appendChild(panelEl);

  const NS = 'http://www.w3.org/2000/svg';
  const CREDIT_LABELS = {
    conceptualization: 'Conceptualization', data: 'Data', analysis: 'Analysis',
    methods: 'Methods', writing: 'Writing', supervision: 'Supervision'
  };
  const ROLE_LABELS = { lead: 'Lead author', 'co-lead': 'Co-lead', contributing: 'Contributing author' };
  const STATUS_LABELS = { in_press: 'in press', preprint: 'preprint', published: '' };

  let pinned = null;   // the <g class="node"> whose tooltip is pinned, if any

  // --- tiny helpers ------------------------------------------------------------------------
  function svgEl(tag, attrs, parent) {
    const e = document.createElementNS(NS, tag);
    for (const k in attrs) e.setAttribute(k, attrs[k]);
    if (parent) parent.appendChild(e);
    return e;
  }
  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  }
  // point-up hexagon path centred on (cx, cy)
  function hexPath(cx, cy, w, h) {
    const p = [[cx, cy - h / 2], [cx + w / 2, cy - h / 4], [cx + w / 2, cy + h / 4],
               [cx, cy + h / 2], [cx - w / 2, cy + h / 4], [cx - w / 2, cy - h / 4]];
    return 'M' + p.map(q => q[0].toFixed(1) + ',' + q[1].toFixed(1)).join('L') + 'Z';
  }

  // --- tooltip -----------------------------------------------------------------------------
  const AREA_LABELS = { biosocial: 'Biosocial', criminology: 'Criminology', responders: 'First responder' };
  function areasText(n, areas) {
    return areas.filter(k => n.areas && n.areas[k] > 0).map(k => `${AREA_LABELS[k] || k} ${n.areas[k]}`).join(', ') || 'areas not rated';
  }
  function areasHTML(n, areas) {
    if (!n.areas || areas.every(k => n.areas[k] == null)) return '<div class="tt-unscored">Areas not yet rated.</div>';
    return '<div class="tt-areas">' + areas.map(k => {
      const v = n.areas[k] || 0;
      const dots = [1, 2, 3].map(i => `<i class="${i <= v ? 'on' : ''}"></i>`).join('');
      return `<span><span class="lab">${esc(AREA_LABELS[k] || k)}</span>${dots}</span>`;
    }).join('') + '</div>';
  }
  function tooltipHTML(n, credit, areas) {
    const meta = [n.year, n.venue, STATUS_LABELS[n.status]].filter(Boolean).join(' · ');
    const pos = (n.author_position && n.authors_n)
      ? `author ${n.author_position} of ${n.authors_n}`
      : (n.author_position ? `author ${n.author_position}` : '');
    let bars;
    if (n.scored) {
      bars = '<div class="tt-bars">' + credit.map(k => {
        const v = n.contribution[k] || 0;
        const cells = [1, 2, 3].map(i => `<span class="${i <= v ? 'on' : ''}"></span>`).join('');
        return `<span class="lab">${esc(CREDIT_LABELS[k] || k)}</span><span class="tt-bar">${cells}</span>`;
      }).join('') + '</div>';
    } else {
      bars = '<div class="tt-unscored">Contribution not yet scored.</div>';
    }
    return `<div class="tt-title">${esc(n.title)}</div>` +
           `<div class="tt-meta">${esc(meta)}${pos ? ' · ' + esc(pos) : ''}` +
           `<span class="tt-role">${esc(ROLE_LABELS[n.role] || n.role)}</span></div>` + areasHTML(n, areas) + bars;
  }
  let AREAS_ORDER = ['biosocial', 'criminology', 'responders'];
  function showTip(n, g, credit) {
    tip.innerHTML = tooltipHTML(n, credit, AREAS_ORDER);
    tip.style.setProperty('--node', n.colour);
    tip.hidden = false;
  }
  function placeTipAt(x, y) {
    const pad = 14, vw = window.innerWidth, vh = window.innerHeight;
    const r = tip.getBoundingClientRect();
    let left = x + pad, top = y + pad;
    if (left + r.width > vw - 8) left = x - r.width - pad;
    if (top + r.height > vh - 8) top = y - r.height - pad;
    tip.style.left = Math.max(8, left) + 'px';
    tip.style.top  = Math.max(8, top) + 'px';
  }
  function placeTipByNode(g) {
    const r = g.getBoundingClientRect();
    placeTipAt(r.right, r.top + r.height / 2);
  }
  function hideTip() { tip.hidden = true; }
  function unpin() {
    if (pinned) { pinned.classList.remove('pinned', 'lit', 'flipping'); const id = pinned.dataset.id; pinned = null; if (window._stLineage) window._stLineage(id, false); }
    tip.hidden = true;
    closePanel();
  }

  // --- detail panel ------------------------------------------------------------------------
  const panel = document.getElementById('skilltree-panel');
  const panelBody = panel ? panel.querySelector('.sp-body') : null;
  const EFFORT_LABELS = { 1: 'light', 2: 'modest', 3: 'substantial', 4: 'heavy', 5: 'consuming' };
  function ordinal(k) { const s = ['th', 'st', 'nd', 'rd'], v = k % 100; return k + (s[(v - 20) % 10] || s[v] || s[0]); }
  function panelHTML(n, credit, areas) {
    const status = STATUS_LABELS[n.status] || '';
    const meta = [n.year, n.venue, n.citation && !/in press|online first/i.test(n.citation) ? n.citation : '', status].filter(Boolean).join(' · ');
    let authors = '';
    if (n.author_position && n.authors_n) authors = `${ordinal(n.author_position)} of ${n.authors_n} authors`;
    else if (n.author_position) authors = `${ordinal(n.author_position)} author on a large team`;
    const areaDots = '<div class="sp-areas">' + areas.map(k => {
      const v = (n.areas && n.areas[k]) || 0;
      return `<span><span class="lab">${esc(AREA_LABELS[k] || k)}</span>${[1, 2, 3].map(i => `<i class="${i <= v ? 'on' : ''}"></i>`).join('')}</span>`;
    }).join('') + '</div>';
    const blurb = n.blurb ? `<p class="sp-blurb">${esc(n.blurb)}</p>` : `<p class="sp-blurb pending">Description to come.</p>`;
    let contrib;
    if (n.scored) {
      contrib = '<div class="sp-grid">' + credit.map(k => {
        const v = n.contribution[k] || 0;
        return `<span class="lab">${esc(CREDIT_LABELS[k] || k)}</span><span class="bar">${[1, 2, 3].map(i => `<span class="${i <= v ? 'on' : ''}"></span>`).join('')}</span><span class="num">${v}/3</span>`;
      }).join('') + '</div>';
    } else contrib = '<p class="sp-unscored">Contribution not yet scored.</p>';
    let effort;
    if (n.effort) {
      effort = `<div class="sp-effort"><span class="blocks">${[1, 2, 3, 4, 5].map(i => `<span class="${i <= n.effort ? 'on' : ''}"></span>`).join('')}</span><span class="lab">${esc(EFFORT_LABELS[n.effort] || n.effort)}</span></div>` +
               (n.effort_note ? `<p class="sp-note">${esc(n.effort_note)}</p>` : '');
    } else effort = '<p class="sp-unscored">Effort not yet rated.</p>';
    const link = n.link
      ? `<a class="sp-link" href="${esc(n.link)}" target="_blank" rel="noopener">${n.doi ? 'Read the article' : 'Open the article'} &rarr;</a>`
      : `<span class="sp-nolink">${n.status === 'in_press' ? 'In press — link to come.' : 'No public link yet.'}</span>`;
    return `<div class="sp-eyebrow">${esc(n.year)} · ${esc(ROLE_LABELS[n.role] || n.role)}</div>` +
           `<h2 class="sp-title">${esc(n.title)}</h2>` +
           `<div class="sp-meta">${esc(meta)}</div>` +
           (authors ? `<div class="sp-authors">${esc(authors)}</div>` : '') +
           blurb + areaDots +
           `<div class="sp-h">What I did</div>` + contrib +
           `<div class="sp-h">Effort</div>` + effort + link;
  }
  let lastFocus = null;
  function openPanel(n, g, credit) {
    if (!panel) return;
    panelBody.innerHTML = panelHTML(n, credit, AREAS_ORDER);
    panel.style.setProperty('--node', n.colour);
    panel.hidden = false;
    lastFocus = g;
    if (history.replaceState) history.replaceState(null, '', '#' + encodeURIComponent(n.id));
  }
  function closePanel() {
    if (!panel || panel.hidden) return;
    panel.hidden = true;
    if (history.replaceState && location.hash) history.replaceState(null, '', location.pathname + location.search);
    if (lastFocus && document.activeElement === panel.querySelector('.sp-close')) lastFocus.focus();
  }

  // --- draw ----------------------------------------------------------------------------------
  function draw(tree) {
    const m = tree.meta;
    const credit = m.credit || Object.keys(CREDIT_LABELS);
    if (m.areas) AREAS_ORDER = m.areas;
    const svg = svgEl('svg', {
      viewBox: `0 0 ${m.width} ${m.height}`, role: 'group',
      'aria-label': 'Publications on concentric rings by year, placed by direction between three research areas: biosocial, criminology and first-responder occupational'
    }, root);

    // the field: year rings (hexagon guides), three area axes, and Peter at the origin
    const gT = svgEl('g', { class: 'field' }, svg);
    // a soft glow behind the origin so the eye starts at the centre
    const defs = svgEl('defs', {}, svg);
    const grad = svgEl('radialGradient', { id: 'st-glow' }, defs);
    svgEl('stop', { offset: '0%', 'stop-color': '#FBFAF7', 'stop-opacity': '0.10' }, grad);
    svgEl('stop', { offset: '55%', 'stop-color': '#FBFAF7', 'stop-opacity': '0.025' }, grad);
    svgEl('stop', { offset: '100%', 'stop-color': '#FBFAF7', 'stop-opacity': '0' }, grad);
    if (m.origin) svgEl('circle', { cx: m.origin.x, cy: m.origin.y, r: Math.min(m.width, m.height) * 0.42, fill: 'url(#st-glow)' }, gT);
    m.rings.forEach(rg => svgEl('path', { class: 'ring-guide', d: rg.path }, gT));
    m.axes.forEach(a => svgEl('line', { class: 'axis', x1: a.x1, y1: a.y1, x2: a.x2, y2: a.y2, style: `stroke:${a.colour}` }, gT));
    if (m.origin) {
      const k = m.origin.scale || 1, ow = m.hex_w * k, oh = m.hex_h * k;
      svgEl('path', { class: 'origin-ring', d: hexPath(m.origin.x, m.origin.y, ow * 1.02, oh * 1.02) }, gT);
      svgEl('image', {
        class: 'origin', href: m.origin.sticker_src, x: m.origin.x - ow / 2, y: m.origin.y - oh / 2,
        width: ow, height: oh, preserveAspectRatio: 'xMidYMid meet', 'aria-hidden': 'true'
      }, gT);
    }

    // lineage edges (builds_on): parent → child beneath the nodes, a gradient from the parent's colour
    // to the child's, slightly bowed toward the origin so they read as branches rather than spokes
    const gE = svgEl('g', { class: 'edges' }, svg);              // long edges: beneath the nodes
    const gBridge = svgEl('g', { class: 'edges bridges' });        // neighbour welds: appended above the nodes later
    const edgesByNode = {};
    (tree.edges || []).forEach((e, i) => {
      const gid = `st-edge-${i}`;
      const lg = svgEl('linearGradient', { id: gid, gradientUnits: 'userSpaceOnUse', x1: e.x1, y1: e.y1, x2: e.x2, y2: e.y2 }, defs);
      svgEl('stop', { offset: '0%', 'stop-color': e.from_colour }, lg);
      svgEl('stop', { offset: '100%', 'stop-color': e.to_colour }, lg);
      let path, tip;
      if (e.adjacent) {
        // weld across the shared border, straight and thick, above the tiles
        path = svgEl('path', { class: 'edge bridge', d: `M${e.x1},${e.y1} L${e.x2},${e.y2}`, style: `stroke:url(#${gid})`, 'data-from': e.from, 'data-to': e.to }, gBridge);
      } else {
        // control point: the midpoint nudged toward the origin by a fraction of the edge length
        const mx = (e.x1 + e.x2) / 2, my = (e.y1 + e.y2) / 2;
        const ox = m.origin ? m.origin.x : m.width / 2, oy = m.origin ? m.origin.y : m.height / 2;
        const len = Math.hypot(e.x2 - e.x1, e.y2 - e.y1), dO = Math.hypot(ox - mx, oy - my) || 1;
        const bow = Math.min(len * 0.18, 40);
        const cx = mx + (ox - mx) / dO * bow, cy = my + (oy - my) / dO * bow;
        path = svgEl('path', { class: 'edge', d: `M${e.x1},${e.y1} Q${cx},${cy} ${e.x2},${e.y2}`, style: `stroke:url(#${gid})`, 'data-from': e.from, 'data-to': e.to }, gE);
        // a small dot at the child end marks direction without an arrowhead's clutter
        tip = svgEl('circle', { class: 'edge-tip', cx: e.x2, cy: e.y2, r: 5, style: `fill:${e.to_colour}` }, gE);
      }
      const parts = tip ? [path, tip] : [path];
      (edgesByNode[e.from] = edgesByNode[e.from] || []).push(...parts);
      (edgesByNode[e.to]   = edgesByNode[e.to]   || []).push(...parts);
    });
    const setLineage = window._stLineage = (id, on) => {
      const mine = edgesByNode[id] || [];
      if (!mine.length) { svg.classList.remove('has-hot'); return; }
      svg.classList.toggle('has-hot', on);
      svg.querySelectorAll('.edge.hot, .edge-tip.hot').forEach(el => el.classList.remove('hot'));
      if (on) mine.forEach(el => el.classList.add('hot'));
    };

    // nodes
    const gN = svgEl('g', { class: 'nodes' }, svg);
    const nodeToggles = {};
    tree.nodes.forEach(n => {
      const cls = `node role-${n.role} status-${n.status}` + (n.featured ? '' : ' muted');
      const label = [n.title, n.year, n.venue].filter(Boolean).join(', ') +
                    `. ${ROLE_LABELS[n.role] || n.role}. ${areasText(n, m.areas)}.` +
                    (n.scored ? '' : ' Contribution not yet scored.');
      const g = svgEl('g', {
        class: cls, tabindex: 0, role: 'button', 'data-id': n.id,
        'aria-label': label, style: `--node: ${n.colour}`
      }, gN);
      svgEl('image', {
        href: n.sticker_src, x: n.x - m.hex_w / 2, y: n.y - m.hex_h / 2,
        width: m.hex_w, height: m.hex_h, preserveAspectRatio: 'xMidYMid meet'
      }, g);
      svgEl('path', { class: 'hex-shade', d: hexPath(n.x, n.y, m.hex_w * 0.99, m.hex_h * 0.99) }, g);
      svgEl('path', { class: 'hex-ring', d: hexPath(n.x, n.y, m.hex_w * 0.96, m.hex_h * 0.96) }, g);

      // hover / focus: tooltip only. Nothing moves, so the pointer target never shifts underneath.
      g.addEventListener('mouseenter', e => { showTip(n, g, credit); placeTipAt(e.clientX, e.clientY); setLineage(n.id, true); });
      g.addEventListener('mousemove',  e => placeTipAt(e.clientX, e.clientY));
      g.addEventListener('mouseleave', () => { hideTip(); if (pinned) setLineage(pinned.dataset.id, true); else setLineage(n.id, false); });
      g.addEventListener('focus', () => { showTip(n, g, credit); placeTipByNode(g); setLineage(n.id, true); });
      g.addEventListener('blur', () => { hideTip(); if (pinned) setLineage(pinned.dataset.id, true); else setLineage(n.id, false); });
      // click / Enter / Space: flip the hex face-up and pin it; again (or Esc, or elsewhere) turns it back
      const toggle = e => {
        e.preventDefault(); e.stopPropagation();
        if (pinned === g) { unpin(); return; }
        unpin(); pinned = g;
        if (g.parentNode.lastChild !== g) g.parentNode.appendChild(g);   // paint above neighbours; a click, not a hover
        g.classList.add('pinned', 'flipping', 'lit');
        setLineage(n.id, true);
        tip.hidden = true;                                                  // the panel carries the detail now
        openPanel(n, g, credit);
      };
      nodeToggles[n.id] = toggle;
      g.addEventListener('click', toggle);
      g.addEventListener('keydown', e => { if (e.key === 'Enter' || e.key === ' ') toggle(e); });
    });

    svg.appendChild(gBridge);   // welds above the tiles

    // labels last, above everything: axis names past the outer ring, years on each ring's top edge
    const gL = svgEl('g', { class: 'labels' }, svg);
    m.axes.forEach(a => {
      const t = svgEl('text', { class: 'axis-label', x: a.label_x, y: a.label_y, 'text-anchor': a.anchor, style: `fill:${a.colour}` }, gL);
      t.textContent = a.label;
    });
    m.rings.forEach(rg => {
      const t = svgEl('text', { class: 'year-label' + (rg.label_over_hex ? ' over-hex' : ''), x: rg.label_x, y: rg.label_y }, gL);
      t.textContent = rg.year;
    });

    // legend, built from the same JSON as the drawing so nothing drifts: area colours as filled hexes,
    // roles and status as hex outlines drawn with the same stroke weights the nodes use
    const leg = document.getElementById('skilltree-legend');
    if (leg) {
      const icon = (opts) => `<svg class="lg-hex" viewBox="0 0 20 23" aria-hidden="true"><path d="${hexPath(10, 11.5, opts.w || 16, opts.h || 18.5)}" ` +
        `fill="${opts.fill || 'none'}" stroke="${opts.stroke || 'currentColor'}" stroke-width="${opts.sw || 1.5}" ${opts.dash ? 'stroke-dasharray="3 2.2"' : ''} stroke-linejoin="round"/></svg>`;
      const item = (html, text) => `<span class="lg-item">${html}${esc(text)}</span>`;
      leg.innerHTML =
        `<div class="lg-row">${m.axes.map(a => item(icon({ fill: a.colour, stroke: a.colour, sw: 1 }), a.label)).join('')}` +
        `<span class="lg-note">Rings are years, oldest at the centre. Direction is the mix of areas an article drew on; blends take a blended colour.</span></div>` +
        `<div class="lg-row">${item(icon({ sw: 3 }), 'Lead author')}${item(icon({ sw: 2 }), 'Co-lead')}${item(icon({ sw: 1 }), 'Contributing author')}` +
        `${item(icon({ sw: 1.5, dash: true }), 'In press or preprint')}` +
        `${item('<svg class="lg-hex" viewBox="0 0 20 23" aria-hidden="true"><path d="M2,19 Q6,9 18,4" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/><circle cx="18" cy="4" r="2.4" fill="currentColor"/></svg>', 'Builds on an earlier article')}` +
        `<span class="lg-note">Hover a hex for the summary and its lineage. Click to turn it over.</span></div>`;
    }

    document.addEventListener('keydown', e => { if (e.key === 'Escape') unpin(); });
    document.addEventListener('click', e => { if (!e.target.closest('.node') && !e.target.closest('.skilltree-panel')) unpin(); });
    if (panel) panel.querySelector('.sp-close').addEventListener('click', e => { e.stopPropagation(); unpin(); });

    // deep link: /skilltree.html#<id> opens that article, on load and whenever the hash changes
    const openFromHash = () => {
      const want = decodeURIComponent((location.hash || '').slice(1));
      if (!want || !nodeToggles[want]) return;
      const g = gN.querySelector(`[data-id="${want}"]`);
      if (pinned === g) return;
      nodeToggles[want]({ preventDefault() {}, stopPropagation() {} });
      if (g) g.scrollIntoView({ block: 'center' });
    };
    openFromHash();
    window.addEventListener('hashchange', openFromHash);
  }

  const src = root.dataset.src || 'www/tree.json';
  fetch(src, { cache: 'no-store' })
    .then(r => { if (!r.ok) throw new Error(`${src}: HTTP ${r.status}`); return r.json(); })
    .then(draw)
    .catch(err => {
      root.textContent = 'Could not load the tree data (run R/build_tree.R, then reload).';
      console.error('skilltree:', err);
    });
})();
