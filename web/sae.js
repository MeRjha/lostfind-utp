/* Avisos propios de la página (reemplazan a alert y confirm del navegador): ver avisos.js */
(function () {
    if (!window.Avisos && !document.querySelector('script[src="avisos.js"]')) {
        const s = document.createElement("script");
        s.src = "avisos.js";
        document.head.appendChild(s);
    }
    window.avisar = window.avisar || function (m, t) { return window.Avisos ? Avisos.avisar(m, t) : alert(m); };
    window.confirmarAviso = window.confirmarAviso || function (m, o) { return window.Avisos ? Avisos.confirmar(m, o) : Promise.resolve(confirm(m)); };
})();

(function () {
    "use strict";

    const $ = (s, r = document) => r.querySelector(s);
    const esc = t => String(t ?? "").replace(/[&<>"']/g,
            c => ({"&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"}[c]));
    const fecha = f => {
        const p = String(f || "").slice(0, 10).split("-");
        return p.length === 3 ? p[2] + "/" + p[1] + "/" + p[0] : "-";
    };
    const ESTADOS = {
        PENDIENTE: ["Pendiente", "pendiente"],
        APROBADO: ["Aprobado", "aprobado"],
        RECHAZADO: ["Rechazado", "rechazado"]
    };

    /* Pide los datos al servlet. Si no existe o falla, usa los datos de ejemplo. */
    async function pedir(servlet, params, ejemplo) {
        try {
            const r = await fetch(servlet, {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: new URLSearchParams(params || {})
            });
            if (!r.ok) throw new Error(r.status);
            return {datos: await r.json(), simulado: false};
        } catch (e) {
            return {datos: ejemplo(), simulado: true};
        }
    }

    function aviso(simulado) {
        const a = $("#saeAviso");
        if (a) a.hidden = !simulado;
    }

    function toast(msg) {
        const t = $("#saeToast");
        t.textContent = msg;
        t.hidden = false;
        clearTimeout(toast.id);
        toast.id = setTimeout(() => t.hidden = true, 3500);
    }

    /* ---------- Cabecera: tema, menú de usuario, imágenes ---------- */
    function iniciarBase() {
        try {
            if (localStorage.getItem("temaLostFind") === "oscuro")
                document.body.classList.add("temaOscuro");
        } catch (e) {
        }

        const boton = $("#botonUsuario"), menu = $("#menuUsuario");
        if (boton && menu) {
            boton.addEventListener("click", () => {
                menu.hidden = !menu.hidden;
                boton.setAttribute("aria-expanded", String(!menu.hidden));
            });
            document.addEventListener("click", e => {
                if (!boton.contains(e.target) && !menu.contains(e.target)) menu.hidden = true;
            });
            $("#cerrarSesion").addEventListener("click", () => location.href = "Inicio.jsp");
        }

        document.addEventListener("error", e => {
            const img = e.target;
            if (img.tagName === "IMG" && !img.dataset.fb) {
                img.dataset.fb = "1";
                img.src = "Imagenes/LostFind.png";
            }
        }, true);
    }

    /* ---------- Pantalla 8: Dashboard ---------- */
    const ejemploDashboard = () => ({bajoCustodia: "–", reclamosPendientes: "–", coincidencias: "–", entregados: "–", recientes: [], pendientes: []});

    const dato = (icono, texto) => texto ? '<span class="dashDato">' + icono + " " + esc(texto) + "</span>" : "";

        async function dashboard() {
        const {datos: d, simulado} = await pedir("DashboardSAEServlet", {}, ejemploDashboard);
        aviso(simulado);
        $("#statCustodia").textContent = d.bajoCustodia;
        $("#statPendientes").textContent = d.reclamosPendientes;
        $("#statCoincidencias").textContent = d.coincidencias;
        $("#statEntregados").textContent = d.entregados;

        $("#listaRecientes").innerHTML = (d.recientes || []).length
                ? d.recientes.map(o => {
                    const est = o.estado || "Disponible";
                    return '<li class="dashItem"><img class="saeThumb" src="' + esc(o.imagen) + '" alt="">'
                            + '<div class="dashInfo"><strong>' + esc(o.nombre) + "</strong>"
                            + '<div class="dashDatos">' + dato("📍", o.lugar || o.categoria) + dato("🏢", o.sede)
                            + dato("📅", o.fecha ? fecha(o.fecha) : "") + "</div></div>"
                            + '<span class="saeEstado ' + (/revisi/i.test(est) ? "pendiente" : "aprobado") + '">' + esc(est) + "</span>"
                            + '<a class="saeBtn saeBtnClaro saeBtnChico" href="ObjetosSAE.jsp?id=' + encodeURIComponent(o.idObjeto) + '">Detalle ➡</a></li>';
                }).join("")
                : '<li class="saeVacio">Sin registros recientes</li>';

        cargarActividad();
    }

    /* Actividad reciente (la entrega EstadisticasServlet en el campo "actividad") */
    async function cargarActividad() {
        const lista = $("#actividad");
        if (!lista) return;
        let items = [];
        try {
            const r = await fetch("EstadisticasServlet");
            if (!r.ok) throw new Error(r.status);
            items = (await r.json()).actividad || [];
        } catch (e) {
            items = [];
        }
        lista.innerHTML = items.length
                ? items.map(a => "<li><b>" + fecha(a.fecha) + "</b><span>" + esc(a.texto) + "</span></li>").join("")
                : '<li class="saeVacio">Sin actividad reciente</li>';
    }

    /* ---------- Reclamos: la lista y el detalle los dibuja el servidor (JSP) ---------- */
    /* En el detalle solo validamos y confirmamos antes de enviar el formulario. */
        function detalle() {
        const f = $("#formDecision");
        if (!f) return;
        let confirmado = false;
        f.addEventListener("submit", async e => {
            if (confirmado) return;
            e.preventDefault();
            const boton = e.submitter;
            const accion = boton ? boton.value : "";
            if (accion === "rechazar" && !$("#motivoRechazo").value.trim()) {
                avisar("Escribe el motivo del rechazo.", "aviso");
                $("#motivoRechazo").focus();
                return;
            }
            const aprobar = accion === "aprobar";
            const quiere = await confirmarAviso(
                    aprobar ? "Se aprobará la devolución del objeto al estudiante." : "Se rechazará esta solicitud y el estudiante verá el motivo.",
                    {titulo: aprobar ? "¿Aprobar el reclamo?" : "¿Rechazar el reclamo?",
                        aceptar: aprobar ? "Sí, aprobar" : "Sí, rechazar", cancelar: "Volver", peligro: !aprobar});
            if (!quiere) return;
            confirmado = true;
            f.requestSubmit(boton);
        });
    }
    /* ---------- Pantalla 12: Reportes estadísticos ---------- */
    const MESES = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
    const etiquetaMes = m => MESES[parseInt(String(m).slice(5, 7), 10) - 1] || m;

    const ejemploStats = () => ({indicadores: {}, porCategoria: [], porMes: [], reclamosPorEstado: [], actividad: []});

    const COLORES = {PENDIENTE: "#f0a500", APROBADO: "#1e9e5a", RECHAZADO: "#d64545"};
    const INDICADORES = [
        ["registrados", "📦", "Objetos registrados"], ["objetosPerdidos", "🔍", "Objetos perdidos"],
        ["coincidencias", "🔗", "Coincidencias generadas"], ["reclamosAprobados", "✅", "Reclamos aprobados"],
        ["reclamosPendientes", "⏳", "Reclamos pendientes"], ["reclamosRechazados", "✖", "Reclamos rechazados"]];

    function pintarStats(d) {
        $("#indicadores").innerHTML = INDICADORES.map(i =>
            '<article class="cuadroTarjetas saeStat"><span class="saeStatIcono">' + i[1] + "</span><div><b>"
                    + esc(d.indicadores[i[0]] ?? 0) + "</b><p>" + i[2] + "</p></div></article>").join("");

        const maxC = Math.max(1, ...d.porCategoria.map(c => c.total));
        $("#grafCategoria").innerHTML = d.porCategoria.length
                ? d.porCategoria.map(c =>
                    '<div class="saeBarra"><span>' + esc(c.nombre) + '</span><div class="saeBarraFondo"><i style="width:'
                            + (c.total / maxC * 100) + '%"></i></div><b>' + c.total + "</b></div>").join("")
                : '<p class="saeVacio">Sin datos para los filtros elegidos</p>';

        const maxM = Math.max(1, ...d.porMes.map(m => Math.max(m.registrados, m.aprobados)));
        $("#grafMeses").innerHTML = d.porMes.map(m =>
            '<div class="saeMes"><div class="saeCols"><i class="reg" style="height:' + (m.registrados / maxM * 100)
                    + '%" title="Registrados: ' + m.registrados + '"></i><i class="ent" style="height:'
                    + (m.aprobados / maxM * 100) + '%" title="Aprobados: ' + m.aprobados + '"></i></div><span>'
                    + esc(etiquetaMes(m.mes)) + "</span></div>").join("");

        const total = d.reclamosPorEstado.reduce((s, e) => s + e.total, 0);
        let acum = 0;
        const tramos = d.reclamosPorEstado.map(e => {
            const ini = acum;
            acum += total ? e.total / total * 100 : 0;
            return (COLORES[e.estado] || "#999") + " " + ini + "% " + acum + "%";
        });
        $("#grafDonut").style.background = total ? "conic-gradient(" + tramos.join(", ") + ")" : "var(--cuadro)";
        $("#grafDonut").dataset.total = total;
        $("#leyendaDonut").innerHTML = d.reclamosPorEstado.map(e =>
            '<li><i style="background:' + (COLORES[e.estado] || "#999") + '"></i>'
                    + esc((ESTADOS[e.estado] || [e.estado])[0]) + " <b>" + e.total + "</b></li>").join("");
    }

    async function reportes() {
        const hoy = new Date();
        const selAnio = $("#fAnio"), selMes = $("#fMes");
        for (let a = hoy.getFullYear(); a >= hoy.getFullYear() - 3; a--)
            selAnio.insertAdjacentHTML("beforeend", '<option value="' + a + '">' + a + "</option>");
        selMes.value = String(hoy.getMonth() + 1);

        async function cargar() {
            const p = new URLSearchParams();
            p.append("anio", selAnio.value);
            if (selMes.value === "todos") for (let m = 1; m <= 12; m++) p.append("mes", m);
            else p.append("mes", selMes.value);
            if ($("#fCategoria").value) p.append("categoria", $("#fCategoria").value);
            if ($("#fEstado").value) p.append("estado", $("#fEstado").value);
            let datos, simulado = false;
            try {
                const r = await fetch("EstadisticasServlet?" + p.toString());
                if (!r.ok) throw new Error(r.status);
                datos = await r.json();
            } catch (e) {
                datos = ejemploStats();
                simulado = true;
            }
            aviso(simulado);
            pintarStats(datos);
        }
        $("#btnAplicar").addEventListener("click", cargar);
        cargar();
    }

        /* ---------- Menú de usuario: Mi perfil y Configuración (tema) ---------- */
    function iniciarMenuUsuario() {
        const menu = $("#menuUsuario"), boton = $("#botonUsuario"), info = $("#InfoUsuario");
        if (!menu || !boton || menu.querySelector("#verPerfil")) return;

        $("#cerrarSesion").insertAdjacentHTML("beforebegin",
                '<button type="button" id="verPerfil">👤 Mi perfil</button>'
                + '<button type="button" id="verConfiguracion">⚙️ Configuración</button><hr>');

        document.body.insertAdjacentHTML("beforeend",
                '<dialog class="modalUsuario" id="modalUsuario">'
                + '<div class="tituloModal"><h2 id="tituloModal">Mi perfil</h2>'
                + '<button type="button" id="cerrarModal" aria-label="Cerrar">✕</button></div>'
                + '<div id="vistaPerfil"></div>'
                + '<div id="vistaConfiguracion" hidden><div class="cuadroAjustes">'
                + '<div class="tituloAjustes"><span class="iconoAjustes">🎨</span><div><h3>Tema</h3>'
                + '<p>Selecciona el tema de la aplicación.</p></div></div>'
                + '<div class="opcionesTema">'
                + '<label><input type="radio" name="tema" value="claro"> Claro</label>'
                + '<label><input type="radio" name="tema" value="oscuro"> Oscuro</label>'
                + '</div></div></div></dialog>');

        const modal = $("#modalUsuario"), titulo = $("#tituloModal");
        const vPerfil = $("#vistaPerfil"), vConfig = $("#vistaConfiguracion");

        function abrir(tipo) {
            menu.hidden = true;
            boton.setAttribute("aria-expanded", "false");
            vPerfil.hidden = tipo !== "perfil";
            vConfig.hidden = tipo !== "configuracion";
            titulo.textContent = tipo === "perfil" ? "Mi perfil" : "Configuración";
            if (tipo === "perfil") {
                let u = {};
                try {
                    u = JSON.parse(info.dataset.usuario);
                } catch (e) {
                }
                const correo = String(u.correoInstitucional ?? "");
                const nombre = String(u.nombre ?? "") + " " + String(u.apellido ?? "");
                vPerfil.innerHTML = '<div class="datosPerfil"><img src="' + String(u.fotoPerfil ?? "") + '" alt="Foto de perfil">'
                        + '<h3 class="nombreUsuario">' + nombre + "</h3><p>" + correo
                        + '</p><span class="badge">Personal SAE UTP</span></div>'
                        + '<h3 class="subtituloModal">Información personal</h3><div class="informacionPersonal">'
                        + "<p><b>Nombre:</b> " + nombre + "</p><p><b>Correo:</b> " + correo + "</p>"
                        + "<p><b>Código:</b> " + correo.split("@")[0] + "</p>"
                        + "<p><b>Sede:</b> " + (u.sede ? u.sede.nombre : "-") + "</p>"
                        + "<p><b>Tipo:</b> Personal SAE UTP</p></div>";
            }
            if (!modal.open) modal.showModal();
        }

        $("#verPerfil").addEventListener("click", () => abrir("perfil"));
        $("#verConfiguracion").addEventListener("click", () => abrir("configuracion"));
        $("#cerrarModal").addEventListener("click", () => modal.close());

        let actual = "claro";
        try {
            actual = localStorage.getItem("temaLostFind") || "claro";
        } catch (e) {
        }
        document.querySelectorAll('input[name="tema"]').forEach(r => {
            r.checked = r.value === actual;
            r.addEventListener("change", () => {
                document.body.classList.toggle("temaOscuro", r.value === "oscuro");
                try {
                    localStorage.setItem("temaLostFind", r.value);
                } catch (e) {
                }
            });
        });
    }

    /* ---------- Arranque ---------- */
    document.addEventListener("DOMContentLoaded", () => {
        iniciarBase();
        iniciarMenuUsuario();
        const pagina = document.body.dataset.pagina;
        if (pagina === "dashboard") dashboard();
        else if (pagina === "detalle") detalle();
        else if (pagina === "reportes") reportes();
    });
})();