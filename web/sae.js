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
    const etiqueta = e => {
        const x = ESTADOS[String(e).toUpperCase()] || [e, ""];
        return '<span class="saeEstado ' + x[1] + '">' + esc(x[0]) + "</span>";
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

    /* Envía una acción. Devuelve "ok", "simulado" (servlet inexistente) o "error". */
    async function enviar(servlet, params) {
        try {
            const r = await fetch(servlet, {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: new URLSearchParams(params)
            });
            if (r.ok) return "ok";
            return r.status === 404 ? "simulado" : "error";
        } catch (e) {
            return "simulado";
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
    const ejemploDashboard = () => ({
        bajoCustodia: 12, reclamosPendientes: 3, coincidencias: 8, entregados: 5,
        recientes: [
            {nombre: "Celular Samsung negro", categoria: "Tecnologia", fecha: "2026-10-21", imagen: "Imagenes/celular_samsung_negro.jpg"},
            {nombre: "Audífonos JBL blancos", categoria: "Accesorios", fecha: "2026-10-20", imagen: "Imagenes/audifonos_jbl_blancos.jpg"},
            {nombre: "Mochila Adidas negra", categoria: "Accesorios", fecha: "2026-10-19", imagen: "Imagenes/mochila_adidas_negra.jpg"}
        ],
        pendientes: [
            {idSolicitud: 1, objeto: "Celular Samsung negro", estudiante: "Carlos Perez", fecha: "2026-10-22"},
            {idSolicitud: 2, objeto: "Audífonos JBL blancos", estudiante: "Ana Rojas", fecha: "2026-10-23"},
            {idSolicitud: 3, objeto: "Laptop Lenovo gris", estudiante: "Luis Torres", fecha: "2026-10-24"}
        ]
    });

    async function dashboard() {
        const {datos: d, simulado} = await pedir("DashboardSAEServlet", {}, ejemploDashboard);
        aviso(simulado);
        $("#statCustodia").textContent = d.bajoCustodia;
        $("#statPendientes").textContent = d.reclamosPendientes;
        $("#statCoincidencias").textContent = d.coincidencias;
        $("#statEntregados").textContent = d.entregados;

        $("#listaRecientes").innerHTML = d.recientes.length
                ? d.recientes.map(o => '<li class="saeItem"><img class="saeThumb" src="' + esc(o.imagen) + '" alt="">'
                            + "<div><strong>" + esc(o.nombre) + "</strong><span>" + esc(o.categoria)
                            + " · " + fecha(o.fecha) + "</span></div></li>").join("")
                : '<li class="saeVacio">Sin registros recientes</li>';

        $("#listaPendientes").innerHTML = d.pendientes.length
                ? d.pendientes.map(p => '<li class="saeItem"><div><strong>' + esc(p.objeto) + "</strong><span>"
                            + esc(p.estudiante) + " · " + fecha(p.fecha) + "</span></div>"
                            + '<a class="saeBtn saeBtnChico" href="DetalleReclamo.jsp?id=' + encodeURIComponent(p.idSolicitud)
                            + '">Revisar</a></li>').join("")
                : '<li class="saeVacio">No hay reclamos pendientes</li>';
    }

    /* ---------- Pantalla 10: Gestión de reclamos ---------- */
    const ejemploReclamos = () => ([
        {idSolicitud: 1, objeto: "Celular Samsung negro", imagen: "Imagenes/celular_samsung_negro.jpg", estudiante: "Carlos Perez", fechaSolicitud: "2026-10-22", estado: "PENDIENTE"},
        {idSolicitud: 2, objeto: "Audífonos JBL blancos", imagen: "Imagenes/audifonos_jbl_blancos.jpg", estudiante: "Ana Rojas", fechaSolicitud: "2026-10-23", estado: "PENDIENTE"},
        {idSolicitud: 3, objeto: "Laptop Lenovo gris", imagen: "Imagenes/laptop_lenovo_gris.jpg", estudiante: "Luis Torres", fechaSolicitud: "2026-10-24", estado: "PENDIENTE"},
        {idSolicitud: 4, objeto: "Mochila Puma azul", imagen: "Imagenes/mochila_puma_azul.jpg", estudiante: "Marta Díaz", fechaSolicitud: "2026-10-19", estado: "APROBADO"},
        {idSolicitud: 5, objeto: "Paraguas negro", imagen: "Imagenes/paraguas_negro.jpg", estudiante: "Pedro Soto", fechaSolicitud: "2026-10-18", estado: "RECHAZADO"}
    ]);

    let reclamos = [];

    function pintarReclamos() {
        const q = $("#buscarReclamo").value.trim().toLowerCase();
        const est = $("#filtroEstado").value;
        const f = reclamos.filter(r => (!est || String(r.estado).toUpperCase() === est)
                    && (!q || (r.objeto + " " + r.estudiante).toLowerCase().includes(q)));
        $("#contadorReclamos").textContent = f.length + (f.length === 1 ? " solicitud" : " solicitudes");
        $("#tablaReclamos").innerHTML = f.length
                ? f.map(r => '<tr><td><div class="saeCeldaObjeto"><img class="saeThumb" src="' + esc(r.imagen) + '" alt="">'
                            + "<strong>" + esc(r.objeto) + "</strong></div></td>"
                            + "<td>" + esc(r.estudiante) + "</td><td>" + fecha(r.fechaSolicitud) + "</td>"
                            + "<td>" + etiqueta(r.estado) + "</td>"
                            + '<td><a class="saeBtn saeBtnChico" href="DetalleReclamo.jsp?id=' + encodeURIComponent(r.idSolicitud)
                            + '">Revisar</a></td></tr>').join("")
                : '<tr><td colspan="5" class="saeVacio">No hay solicitudes con esos filtros</td></tr>';
    }

    async function listaReclamos() {
        const {datos, simulado} = await pedir("ReclamosServlet", {}, ejemploReclamos);
        reclamos = datos;
        aviso(simulado);
        $("#buscarReclamo").addEventListener("input", pintarReclamos);
        $("#filtroEstado").addEventListener("change", pintarReclamos);
        pintarReclamos();
    }

    /* ---------- Pantalla 11: Detalle y validación ---------- */
    const ejemploDetalle = id => ({
        idSolicitud: id, estado: "PENDIENTE", fechaSolicitud: "2026-10-22",
        sustento: "El celular tiene una funda negra y una rajadura pequeña en la esquina inferior derecha. En la pantalla de bloqueo tiene una foto de mi perro.",
        estudiante: {nombre: "Carlos Perez", correo: "carlos@utp.edu.pe"},
        objeto: {nombre: "Celular Samsung negro", categoria: "Tecnologia", color: "Negro", marca: "Samsung",
            lugar: "Biblioteca, mesa de lectura", fechaHallazgo: "2026-10-21", imagen: "Imagenes/celular_samsung_negro.jpg"},
        evidencias: ["Imagenes/foto_celular_xiaomi_estudiante.jpg"],
        historial: [
            {fecha: "2026-10-21", texto: "El SAE registró el objeto encontrado."},
            {fecha: "2026-10-22", texto: "El estudiante envió la solicitud de reclamo."}
        ]
    });

    function dl(pares) {
        return pares.map(p => "<div><dt>" + esc(p[0]) + "</dt><dd>" + esc(p[1] || "-") + "</dd></div>").join("");
    }

    function pintarDetalle(d) {
        $("#detNumero").textContent = "#" + d.idSolicitud;
        $("#detEstado").innerHTML = etiqueta(d.estado);
        $("#detSolicitud").innerHTML = dl([
            ["Estudiante", d.estudiante.nombre], ["Correo", d.estudiante.correo],
            ["Fecha de solicitud", fecha(d.fechaSolicitud)]]);
        $("#detSustento").textContent = d.sustento;
        $("#detEvidencias").innerHTML = d.evidencias.length
                ? d.evidencias.map(u => '<a href="' + esc(u) + '" target="_blank" rel="noopener"><img src="' + esc(u) + '" alt="Evidencia"></a>').join("")
                : '<p class="saeVacio">El estudiante no adjuntó evidencias.</p>';
        $("#detHistorial").innerHTML = d.historial.map(h =>
            "<li><b>" + fecha(h.fecha) + "</b><span>" + esc(h.texto) + "</span></li>").join("");
        $("#detFoto").src = d.objeto.imagen;
        $("#detObjeto").innerHTML = dl([
            ["Objeto", d.objeto.nombre], ["Categoría", d.objeto.categoria], ["Color", d.objeto.color],
            ["Marca o modelo", d.objeto.marca], ["Lugar de hallazgo", d.objeto.lugar],
            ["Fecha de hallazgo", fecha(d.objeto.fechaHallazgo)]]);
        $("#btnContactar").href = "mailto:" + d.estudiante.correo + "?subject=Reclamo%20LostFind%20%23" + d.idSolicitud;

        const pendiente = String(d.estado).toUpperCase() === "PENDIENTE";
        $("#btnAprobar").disabled = !pendiente;
        $("#btnRechazar").disabled = !pendiente;
        $("#comentario").disabled = !pendiente;
        const nota = $("#notaDecision");
        nota.hidden = pendiente;
        nota.textContent = "Esta solicitud ya fue resuelta y no puede modificarse.";
    }

    async function detalle() {
        const id = new URLSearchParams(location.search).get("id") || "1";
        const {datos, simulado} = await pedir("DetalleReclamoServlet", {idSolicitud: id}, () => ejemploDetalle(id));
        aviso(simulado);
        pintarDetalle(datos);

        async function decidir(decision) {
            const comentario = $("#comentario").value.trim();
            if (decision === "rechazar" && !comentario) {
                toast("Escribe el motivo del rechazo.");
                $("#comentario").focus();
                return;
            }
            if (!confirm(decision === "aprobar" ? "¿Aprobar la devolución del objeto?" : "¿Rechazar esta solicitud?"))
                return;

            const r = await enviar("ValidarReclamoServlet", {idSolicitud: id, decision: decision, comentario: comentario});
            if (r === "ok") {
                const nuevo = await pedir("DetalleReclamoServlet", {idSolicitud: id}, () => datos);
                pintarDetalle(nuevo.datos);
                toast("Decisión registrada.");
            } else if (r === "simulado") {
                datos.estado = decision === "aprobar" ? "APROBADO" : "RECHAZADO";
                datos.historial.push({fecha: new Date().toISOString().slice(0, 10),
                    texto: "El SAE " + (decision === "aprobar" ? "aprobó" : "rechazó") + " la solicitud."
                            + (comentario ? " Comentario: " + comentario : "")});
                pintarDetalle(datos);
                toast("Simulación: el servicio aún no está conectado, no se guardó.");
            } else {
                toast("No se pudo registrar la decisión. Inténtalo de nuevo.");
            }
        }

        $("#btnAprobar").addEventListener("click", () => decidir("aprobar"));
        $("#btnRechazar").addEventListener("click", () => decidir("rechazar"));
    }

    /* ---------- Pantalla 12: Reportes estadísticos ---------- */
    const ejemploStats = () => ({
        indicadores: {registrados: 28, bajoCustodia: 12, entregados: 5, reclamosAprobados: 4, reclamosPendientes: 3, coincidencias: 8},
        porCategoria: [
            {nombre: "Tecnologia", total: 11}, {nombre: "Accesorios", total: 8},
            {nombre: "Ropa", total: 5}, {nombre: "Documentos", total: 3}, {nombre: "Otros", total: 1}],
        porMes: [
            {mes: "Jun", registrados: 3, entregados: 1}, {mes: "Jul", registrados: 5, entregados: 2},
            {mes: "Ago", registrados: 6, entregados: 3}, {mes: "Sep", registrados: 8, entregados: 4},
            {mes: "Oct", registrados: 12, entregados: 5}],
        reclamosPorEstado: [
            {estado: "PENDIENTE", total: 3}, {estado: "APROBADO", total: 4}, {estado: "RECHAZADO", total: 2}],
        actividad: [
            {fecha: "2026-10-24", texto: "Reclamo #3 recibido (Laptop Lenovo gris)."},
            {fecha: "2026-10-22", texto: "Reclamo #1 recibido (Celular Samsung negro)."},
            {fecha: "2026-10-21", texto: "Objeto registrado: Celular Samsung negro."}]
    });

    const COLORES = {PENDIENTE: "#f0a500", APROBADO: "#1e9e5a", RECHAZADO: "#d64545"};
    const INDICADORES = [
        ["registrados", "📦", "Objetos registrados"], ["bajoCustodia", "🗄️", "Bajo custodia"],
        ["entregados", "✅", "Entregados"], ["reclamosAprobados", "👍", "Reclamos aprobados"],
        ["reclamosPendientes", "⏳", "Reclamos pendientes"], ["coincidencias", "🔗", "Coincidencias generadas"]];

    function pintarStats(d) {
        $("#indicadores").innerHTML = INDICADORES.map(i =>
            '<article class="cuadroTarjetas saeStat"><span class="saeStatIcono">' + i[1] + "</span><div><b>"
                    + esc(d.indicadores[i[0]]) + "</b><p>" + i[2] + "</p></div></article>").join("");

        const maxC = Math.max(1, ...d.porCategoria.map(c => c.total));
        $("#grafCategoria").innerHTML = d.porCategoria.map(c =>
            '<div class="saeBarra"><span>' + esc(c.nombre) + '</span><div class="saeBarraFondo"><i style="width:'
                    + (c.total / maxC * 100) + '%"></i></div><b>' + c.total + "</b></div>").join("");

        const maxM = Math.max(1, ...d.porMes.map(m => Math.max(m.registrados, m.entregados)));
        $("#grafMeses").innerHTML = d.porMes.map(m =>
            '<div class="saeMes"><div class="saeCols"><i class="reg" style="height:' + (m.registrados / maxM * 100)
                    + '%" title="Registrados: ' + m.registrados + '"></i><i class="ent" style="height:'
                    + (m.entregados / maxM * 100) + '%" title="Entregados: ' + m.entregados + '"></i></div><span>'
                    + esc(m.mes) + "</span></div>").join("");

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

        $("#actividad").innerHTML = d.actividad.length
                ? d.actividad.map(a => "<li><b>" + fecha(a.fecha) + "</b><span>" + esc(a.texto) + "</span></li>").join("")
                : '<li class="saeVacio">Sin actividad en el periodo</li>';
    }

    async function reportes() {
        async function cargar() {
            const {datos, simulado} = await pedir("EstadisticasServlet", {
                periodo: $("#fPeriodo").value, categoria: $("#fCategoria").value, estado: $("#fEstado").value
            }, ejemploStats);
            aviso(simulado);
            pintarStats(datos);
        }
        $("#btnAplicar").addEventListener("click", cargar);
        cargar();
    }

    /* ---------- Arranque ---------- */
    document.addEventListener("DOMContentLoaded", () => {
        iniciarBase();
        const pagina = document.body.dataset.pagina;
        if (pagina === "dashboard") dashboard();
        else if (pagina === "reclamos") listaReclamos();
        else if (pagina === "detalle") detalle();
        else if (pagina === "reportes") reportes();
    });
})();