(function () {
    "use strict";

    const boton = document.getElementById("botonNotificaciones");
    const menu = document.getElementById("menuNotificaciones");
    if (!boton || !menu) return;   // la página no tiene campanita

    /* Carga los estilos sin tocar el <head> de cada página */
    const css = document.createElement("link");
    css.rel = "stylesheet";
    css.href = "notificaciones.css";
    document.head.appendChild(css);

    const globo = document.createElement("span");
    globo.className = "notiGlobo";
    globo.hidden = true;
    boton.appendChild(globo);

    const esc = t => String(t ?? "").replace(/[&<>"']/g,
            c => ({"&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"}[c]));
    const fecha = f => {
        const p = String(f || "").slice(0, 10).split("-");
        return p.length === 3 ? p[2] + "/" + p[1] + "/" + p[0] : "";
    };

    /* Datos de ejemplo mientras NotificacionesServlet no exista */
    const ejemplo = () => ({
        noLeidas: 2,
        items: [
            {idNotificacion: 3, mensaje: "Tu reclamo del Celular Samsung negro fue aprobado. Acércate al SAE para recogerlo.", fechaEnvio: "2026-10-24", leida: false},
            {idNotificacion: 2, mensaje: "Se encontró una posible coincidencia con tu objeto perdido.", fechaEnvio: "2026-10-22", leida: false},
            {idNotificacion: 1, mensaje: "Tu reporte de objeto perdido fue registrado.", fechaEnvio: "2026-10-20", leida: true}
        ]
    });

    let estado = {noLeidas: 0, items: [], simulado: false};

    async function cargar() {
        try {
            const r = await fetch("NotificacionesServlet", {method: "POST"});
            if (!r.ok) throw new Error(r.status);
            estado = Object.assign(await r.json(), {simulado: false});
        } catch (e) {
            if (!estado.simulado) estado = Object.assign(ejemplo(), {simulado: true});
        }
        pintar();
    }

    function pintar() {
        globo.hidden = estado.noLeidas <= 0;
        globo.textContent = estado.noLeidas > 9 ? "9+" : estado.noLeidas;

        menu.innerHTML = '<div class="notiTitulo"><h3>Notificaciones</h3>'
                + (estado.simulado ? "<small>Datos de ejemplo</small>" : "") + "</div>"
                + (estado.items.length
                        ? '<ul class="notiLista">' + estado.items.map(n =>
                            '<li class="notiItem' + (n.leida ? "" : " noLeida") + '">' + esc(n.mensaje)
                                    + "<span>" + fecha(n.fechaEnvio) + "</span></li>").join("") + "</ul>"
                        : '<p class="notiVacio">No tienes notificaciones.</p>');
    }

    async function marcarLeidas() {
        if (estado.noLeidas <= 0) return;
        try {
            const r = await fetch("MarcarLeidasServlet", {method: "POST"});
            if (!r.ok && r.status !== 404) return;   // error real: se queda sin leer
        } catch (e) {
        }
        estado.noLeidas = 0;
        estado.items.forEach(n => n.leida = true);
        globo.hidden = true;
        // el menú se vuelve a pintar al cerrarlo, para que el usuario alcance a ver cuáles eran nuevas
    }

    boton.addEventListener("click", () => {
        // script.js ya alternó el menú; se lee su estado después de eso
        setTimeout(() => {
            if (menu.hidden) pintar();
            else marcarLeidas();
        }, 0);
    });

    cargar();
    setInterval(() => { if (menu.hidden) cargar(); }, 60000);
})();