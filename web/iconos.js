/* Cambia los emojis por iconos SVG (estilo línea, heredan el color del texto).
   Se incluye con <script src="iconos.js" defer></script>. Para quitarlos, basta con borrar esa línea. */
(function () {
    "use strict";
    const C = '<circle cx="12" cy="12" r="10"/>';
    const I = {
        "🚪": '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>',
        "📞": '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>',
        "🛡": '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/>',
        "✅": '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="M22 4 12 14.01l-3-3"/>',
        "📦": '<path d="m16.5 9.4-9-5.19M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><path d="m3.27 6.96 8.73 5.05 8.73-5.05M12 22.08V12"/>',
        "⏳": C + '<path d="M12 6v6l4 2"/>',
        "🔗": '<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>',
        "➕": '<path d="M12 5v14M5 12h14"/>',
        "📋": '<rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2M9 12h6M9 16h6"/>',
        "📈": '<path d="M22 7l-8.5 8.5-5-5L2 17"/><path d="M16 7h6v6"/>',
        "📝": '<path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4z"/>',
        "💾": '<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><path d="M17 21v-8H7v8M7 3v5h8"/>',
        "📊": '<path d="M18 20V10M12 20V4M6 20v-6"/>',
        "🗄": '<ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>',
        "👍": '<path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3z"/><path d="M7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"/>',
        "📤": '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>',
        "👁": '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>',
        "🖼": '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="m21 15-5-5L5 21"/>',
        "📍": '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
        "📷": '<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/>',
        "🔍": '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>',
        "🔎": '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>',
        "✔": '<path d="M20 6 9 17l-5-5"/>',
        "✖": '<path d="M18 6 6 18M6 6l12 12"/>',
        "✉": '<path d="M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z"/><path d="m22 6-10 7L2 6"/>',
        "📅": '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>',
        "🏢": '<rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4M8 6h.01M12 6h.01M16 6h.01M8 10h.01M12 10h.01M16 10h.01M8 14h.01M12 14h.01M16 14h.01"/>',
        "👤": '<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>',
        "➡": '<path d="M5 12h14M12 5l7 7-7 7"/>',
        "ℹ": C + '<path d="M12 16v-4M12 8h.01"/>'
    };
    const claves = Object.keys(I);
    const ER = new RegExp("(" + claves.join("|") + ")\\uFE0F?", "g");
    const OMITIR = {SCRIPT: 1, STYLE: 1, TEXTAREA: 1, OPTION: 1, TITLE: 1, SVG: 1, INPUT: 1};

    const st = document.createElement("style");
    st.textContent = ".ic{display:inline-block;width:1.15em;height:1.15em;vertical-align:-0.2em;flex-shrink:0}" +
        ".ic svg{display:block;width:100%;height:100%;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}";
    document.head.appendChild(st);

    function icono(c) {
        const s = document.createElement("span");
        s.className = "ic";
        s.setAttribute("aria-hidden", "true");
        s.innerHTML = '<svg viewBox="0 0 24 24" focusable="false">' + I[c] + "</svg>";
        return s;
    }

    function procesarTexto(n) {
        const t = n.nodeValue;
        ER.lastIndex = 0;
        if (!ER.test(t)) return;
        ER.lastIndex = 0;
        const f = document.createDocumentFragment();
        let ult = 0, m;
        while ((m = ER.exec(t))) {
            if (m.index > ult) f.appendChild(document.createTextNode(t.slice(ult, m.index)));
            f.appendChild(icono(m[1]));
            ult = m.index + m[0].length;
        }
        if (ult < t.length) f.appendChild(document.createTextNode(t.slice(ult)));
        n.parentNode.replaceChild(f, n);
    }

    function recorrer(raiz) {
        if (raiz.nodeType === 3) {
            if (raiz.parentNode && !OMITIR[raiz.parentNode.nodeName.toUpperCase()]) procesarTexto(raiz);
            return;
        }
        if (raiz.nodeType !== 1 || OMITIR[raiz.nodeName.toUpperCase()]) return;
        const w = document.createTreeWalker(raiz, NodeFilter.SHOW_TEXT, {
            acceptNode: n => OMITIR[n.parentNode.nodeName.toUpperCase()] || (n.parentNode.closest && n.parentNode.closest("svg"))
                    ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT
        });
        const lista = [];
        while (w.nextNode()) lista.push(w.currentNode);
        lista.forEach(procesarTexto);
    }

    recorrer(document.body);
    new MutationObserver(ms => ms.forEach(m => m.addedNodes.forEach(recorrer)))
            .observe(document.body, {childList: true, subtree: true});
})();