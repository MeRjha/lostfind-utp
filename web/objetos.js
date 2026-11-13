(function () {
    "use strict";
    if (document.body.dataset.pagina !== "objetos") return;

    const $ = (s, r = document) => r.querySelector(s);
    const filas = Array.from(document.querySelectorAll("#tablaObjetos tbody tr[data-id]"));
    const modal = $("#objModal");
    const norm = t => String(t || "").toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");

    /* Color según el estado (la base guarda ENCONTRADO, Disponible..., etc.) */
    function claseEstado(e) {
        if (/revis|reclam|proceso/i.test(e)) return "objPendiente";
        if (/entreg|devuel|cerrad/i.test(e)) return "objNeutro";
        return "objAprobado";
    }
    document.querySelectorAll(".objEstado").forEach(s => s.classList.add(claseEstado(s.textContent)));

    /* Opciones del filtro de estado a partir de los datos reales */
    const selEstado = $("#fEstado");
    Array.from(new Set(filas.map(f => f.dataset.estado).filter(Boolean))).sort().forEach(e => {
        const o = document.createElement("option");
        o.value = e;
        o.textContent = e;
        selEstado.appendChild(o);
    });

    /* Filtros */
    function filtrar() {
        const q = norm($("#fBuscar").value), cat = $("#fCategoria").value, est = selEstado.value;
        let visibles = 0;
        filas.forEach(f => {
            const d = f.dataset;
            const texto = norm([d.nombre, d.marca, d.color, d.lugar, d.categoria, d.descripcion].join(" "));
            const ok = (!q || texto.includes(q)) && (!cat || d.categoria === cat) && (!est || d.estado === est);
            f.hidden = !ok;
            if (ok) visibles++;
        });
        $("#contador").textContent = visibles + (visibles === 1 ? " objeto" : " objetos");
        $("#filaVacia").hidden = visibles > 0;
    }
    $("#fBuscar").addEventListener("input", filtrar);
    $("#fCategoria").addEventListener("change", filtrar);
    selEstado.addEventListener("change", filtrar);

    /* Detalle */
    let abierto = null;
    function abrir(fila) {
        const d = fila.dataset;
        const v = x => x && x !== "null" ? x : "-";
        $("#mNombre").textContent = v(d.nombre);
        $("#mCategoria").textContent = v(d.categoria);
        $("#mColor").textContent = v(d.color);
        $("#mMarca").textContent = v(d.marca);
        $("#mLugar").textContent = v(d.lugar);
        $("#mSede").textContent = v(d.sede);
        $("#mFecha").textContent = v(d.fecha);
        $("#mRegistro").textContent = v(d.registro);
        $("#mDescripcion").textContent = v(d.descripcion);
        const est = $("#mEstado");
        est.textContent = v(d.estado);
        est.className = "saeEstado objEstado " + claseEstado(d.estado);
        $("#mImagen").src = d.imagen;
        modal.hidden = false;
        abierto = fila;
        $("#mCerrar").focus();
    }
    function cerrar() {
        modal.hidden = true;
        if (abierto) {
            const b = abierto.querySelector(".btnDetalle");
            if (b) b.focus();
        }
        abierto = null;
    }
    filas.forEach(f => f.querySelector(".btnDetalle").addEventListener("click", () => abrir(f)));
    $("#mCerrar").addEventListener("click", cerrar);
    modal.addEventListener("click", e => { if (e.target === modal) cerrar(); });
    document.addEventListener("keydown", e => { if (e.key === "Escape" && !modal.hidden) cerrar(); });

    /* ?id=NN abre ese objeto (viene del botón "Detalle" del panel) */
    const id = new URLSearchParams(location.search).get("id");
    if (id) {
        const fila = filas.find(f => f.dataset.id === id);
        if (fila) {
            fila.scrollIntoView({block: "center"});
            abrir(fila);
        }
    }
})();