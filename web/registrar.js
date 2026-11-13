(function () {
    "use strict";
    if (document.body.dataset.pagina !== "registrar") return;

    const $ = (s, r = document) => r.querySelector(s);
    const TIPOS = ["image/jpeg", "image/png", "image/webp"];
    const MAX_FOTO = 5 * 1024 * 1024;

    const form = $("#formRegistro");
    const selSede = $("#idSede");
    const inFoto = $("#foto");
    const mensaje = $("#mensajeForm");
    const btnGuardar = $("#btnGuardar");
    let urlPrevia = null;

    const hoy = new Date(Date.now() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 10);
    $("#fechaHallazgo").max = hoy;

    function toast(texto) {
        const t = $("#saeToast");
        t.textContent = texto;
        t.hidden = false;
        clearTimeout(toast.id);
        toast.id = setTimeout(() => t.hidden = true, 3500);
    }

    function avisoMensaje(texto, ok) {
        mensaje.textContent = texto;
        mensaje.classList.toggle("ok", !!ok);
        mensaje.hidden = !texto;
    }

    const fecha = f => {
        const p = String(f || "").split("-");
        return p.length === 3 ? p[2] + "/" + p[1] + "/" + p[0] : "-";
    };

    /* ---------- Sedes (SedeServlet) ---------- */
    function elegirSedeDelUsuario() {
        const mia = selSede.dataset.sede;
        const opcion = Array.from(selSede.options).find(o => o.textContent.trim() === mia);
        if (opcion) selSede.value = opcion.value;
        previa();
    }

    async function cargarSedes() {
        try {
            const r = await fetch("SedeServlet");
            if (!r.ok) throw new Error(r.status);
            const sedes = await r.json();
            selSede.innerHTML = '<option value="">Selecciona una sede</option>' + sedes.map(s =>
                '<option value="' + s.idSede + '">' + String(s.nombre).replace(/[&<>"]/g,
                        c => ({"&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;"}[c])) + "</option>").join("");
            elegirSedeDelUsuario();
        } catch (e) {
            selSede.innerHTML = '<option value="">No se pudieron cargar las sedes</option>';
            const a = $("#saeAviso");
            a.textContent = "No se pudo cargar la lista de sedes. Verifica que hayas iniciado sesión como Personal SAE y que el servidor esté activo.";
            a.hidden = false;
        }
    }

    /* ---------- Vista previa en vivo ---------- */
    function previa() {
        const v = id => (form.elements[id].value || "").trim() || "-";
        $("#pvNombre").textContent = v("nombre");
        $("#pvCategoria").textContent = v("categoria");
        $("#pvColor").textContent = v("color");
        $("#pvMarca").textContent = v("marca");
        $("#pvLugar").textContent = v("lugarReferencia");
        $("#pvFecha").textContent = fecha(form.elements.fechaHallazgo.value);
        const op = selSede.options[selSede.selectedIndex];
        $("#pvSede").textContent = op && op.value ? op.textContent : "-";
        $("#contadorDescripcion").textContent = form.elements.descripcion.value.length + "/500";
    }

    function quitarFoto() {
        if (urlPrevia) URL.revokeObjectURL(urlPrevia);
        urlPrevia = null;
        inFoto.value = "";
        $("#imgPrevia").hidden = true;
        $("#imgPrevia").removeAttribute("src");
        $("#textoFoto").textContent = "Subir archivo";
    }

    inFoto.addEventListener("change", () => {
        const f = inFoto.files[0];
        avisoMensaje("");
        if (!f) return quitarFoto();
        if (!TIPOS.includes(f.type)) {
            quitarFoto();
            return avisoMensaje("Formato no permitido. Usa JPG, PNG o WEBP.");
        }
        if (f.size > MAX_FOTO) {
            quitarFoto();
            return avisoMensaje("La foto supera los 5 MB.");
        }
        if (urlPrevia) URL.revokeObjectURL(urlPrevia);
        urlPrevia = URL.createObjectURL(f);
        $("#imgPrevia").src = urlPrevia;
        $("#imgPrevia").hidden = false;
        $("#textoFoto").textContent = f.name;
    });

    form.addEventListener("input", previa);
    form.addEventListener("change", previa);

    form.addEventListener("reset", () => {
        setTimeout(() => {
            quitarFoto();
            avisoMensaje("");
            form.querySelectorAll(".invalido").forEach(c => c.classList.remove("invalido"));
            elegirSedeDelUsuario();
        }, 0);
    });

    /* ---------- Envío (RegistrarObjetoEncontradoServlet) ---------- */
    form.addEventListener("submit", async e => {
        e.preventDefault();
        avisoMensaje("");
        form.querySelectorAll(".invalido").forEach(c => c.classList.remove("invalido"));

        const faltan = Array.from(form.querySelectorAll("[required]")).filter(c => c.type !== "file" && !c.value.trim());
        if (!inFoto.files[0]) $("#textoFoto").parentElement.style.borderColor = "#d64545";
        else $("#textoFoto").parentElement.style.borderColor = "";
        if (faltan.length || !inFoto.files[0]) {
            faltan.forEach(c => c.classList.add("invalido"));
            if (faltan[0]) faltan[0].focus();
            return avisoMensaje("Completa todos los campos obligatorios (*) y adjunta una fotografía.");
        }

        btnGuardar.disabled = true;
        btnGuardar.textContent = "Guardando…";
        try {
            const r = await fetch("RegistrarObjetoEncontradoServlet", {method: "POST", body: new FormData(form)});
            let d = null;
            try { d = await r.json(); } catch (x) { }
            if (r.ok && d && d.exito) {
                form.reset();
                toast("Objeto registrado correctamente.");
                setTimeout(() => avisoMensaje("Objeto registrado correctamente. Ya puede generar coincidencias.", true), 10);
            } else if (r.status === 401 || r.status === 403) {
                avisoMensaje((d && d.mensaje) || "Tu sesión no tiene permiso para registrar objetos.");
            } else {
                avisoMensaje((d && d.mensaje) || "No se pudo registrar el objeto. Inténtalo de nuevo.");
            }
        } catch (x) {
            avisoMensaje("No se pudo conectar con el servidor.");
        } finally {
            btnGuardar.disabled = false;
            btnGuardar.textContent = "💾 Guardar registro";
        }
    });

    previa();
    cargarSedes();
})();