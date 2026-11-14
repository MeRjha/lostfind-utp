/* Avisos propios de LostFind: reemplazan a alert() y confirm() del navegador.
   Uso:  Avisos.avisar("Mensaje", "exito" | "error" | "aviso" | "info");
         const ok = await Avisos.confirmar("¿Seguro?", {titulo, aceptar, cancelar, peligro});
   También muestra un aviso cuando la URL trae ?aviso=codigo (lo usan los servlets al redirigir). */
(function () {
    "use strict";
    if (window.Avisos) {
        return;
    }

    const CSS = `
.avisosContenedor{position:fixed;top:20px;right:20px;z-index:10000;display:flex;flex-direction:column;gap:10px;width:min(380px,calc(100vw - 32px));pointer-events:none}
.avisoToast{pointer-events:auto;display:flex;align-items:flex-start;gap:12px;padding:14px 14px 14px 16px;border-radius:.9rem;
  background:var(--tarjetas,#fff);color:var(--text,#00085e);border:1px solid var(--borde,#ddf9ff);border-left:6px solid var(--botones,#0B8FEA);
  box-shadow:0 10px 30px rgba(0,18,60,.22);animation:avisoEntra .22s ease-out}
.avisoToast.saliendo{opacity:0;transform:translateX(16px);transition:all .2s ease}
.avisoToast p{margin:0;flex:1;font-size:.95rem;line-height:1.35}
.avisoIcono{display:grid;place-items:center;flex-shrink:0;width:24px;height:24px;border-radius:50%;color:#fff;font-size:.8rem;font-weight:700;background:var(--botones,#0B8FEA)}
.avisoToast--exito{border-left-color:#1e9e5a}.avisoToast--exito .avisoIcono{background:#1e9e5a}
.avisoToast--error{border-left-color:#d64545}.avisoToast--error .avisoIcono{background:#d64545}
.avisoToast--aviso{border-left-color:#f0a500}.avisoToast--aviso .avisoIcono{background:#f0a500}
.avisoCerrar{background:none;border:0;cursor:pointer;color:inherit;opacity:.55;font-size:.9rem;padding:2px 4px}
.avisoCerrar:hover{opacity:1}
.avisoFondo{position:fixed;inset:0;z-index:10001;display:grid;place-items:center;padding:16px;background:rgba(0,18,60,.55);animation:avisoFade .15s ease-out}
.avisoDialogo{width:min(440px,100%);padding:26px;border-radius:1.1rem;background:var(--tarjetas,#fff);color:var(--text,#00085e);
  border:1px solid var(--borde,#ddf9ff);box-shadow:0 20px 50px rgba(0,18,60,.35)}
.avisoDialogo h2{margin:0 0 8px;font-size:1.2rem}
.avisoDialogo p{margin:0 0 22px;line-height:1.45;opacity:.9}
.avisoBotones{display:flex;justify-content:flex-end;gap:10px;flex-wrap:wrap}
.avisoBtn{cursor:pointer;padding:10px 18px;border-radius:.7rem;font:inherit;font-weight:600;border:1px solid var(--botones,#0B8FEA);background:var(--botones,#0B8FEA);color:#fff}
.avisoBtn:hover{filter:brightness(1.08)}
.avisoBtn--claro{background:transparent;color:var(--botones,#0B8FEA)}
.avisoBtn--peligro{background:#d64545;border-color:#d64545}
@keyframes avisoEntra{from{opacity:0;transform:translateX(24px)}to{opacity:1;transform:none}}
@keyframes avisoFade{from{opacity:0}to{opacity:1}}
@media (max-width:560px){.avisosContenedor{top:10px;right:16px}.avisoBotones{flex-direction:column-reverse}.avisoBtn{width:100%}}
`;

    const estilo = document.createElement("style");
    estilo.textContent = CSS;
    document.head.appendChild(estilo);

    const ICONOS = {exito: "✔", error: "✖", aviso: "!", info: "i"};
    let contenedor = null;

    function obtenerContenedor() {
        if (!contenedor || !contenedor.isConnected) {
            contenedor = document.createElement("div");
            contenedor.className = "avisosContenedor";
            contenedor.setAttribute("aria-live", "polite");
            document.body.appendChild(contenedor);
        }
        return contenedor;
    }

    function avisar(mensaje, tipo, duracion) {
        tipo = ICONOS[tipo] ? tipo : "info";
        duracion = duracion === undefined ? 4500 : duracion;

        const caja = document.createElement("div");
        caja.className = "avisoToast avisoToast--" + tipo;
        caja.setAttribute("role", tipo === "error" ? "alert" : "status");

        const icono = document.createElement("span");
        icono.className = "avisoIcono";
        icono.textContent = ICONOS[tipo];

        const texto = document.createElement("p");
        texto.textContent = mensaje;

        const cerrar = document.createElement("button");
        cerrar.type = "button";
        cerrar.className = "avisoCerrar";
        cerrar.setAttribute("aria-label", "Cerrar aviso");
        cerrar.textContent = "✕";

        caja.append(icono, texto, cerrar);

        const quitar = () => {
            caja.classList.add("saliendo");
            setTimeout(() => caja.remove(), 200);
        };
        cerrar.addEventListener("click", quitar);

        obtenerContenedor().appendChild(caja);
        if (duracion > 0) {
            setTimeout(quitar, duracion);
        }
        return caja;
    }

    function confirmar(mensaje, opciones) {
        const o = Object.assign({titulo: "Confirmar", aceptar: "Aceptar", cancelar: "Cancelar", peligro: false}, opciones || {});

        return new Promise(resolver => {
            const fondo = document.createElement("div");
            fondo.className = "avisoFondo";

            const dialogo = document.createElement("div");
            dialogo.className = "avisoDialogo";
            dialogo.setAttribute("role", "alertdialog");
            dialogo.setAttribute("aria-modal", "true");

            const titulo = document.createElement("h2");
            titulo.textContent = o.titulo;
            const texto = document.createElement("p");
            texto.textContent = mensaje;

            const botones = document.createElement("div");
            botones.className = "avisoBotones";

            const btnCancelar = document.createElement("button");
            btnCancelar.type = "button";
            btnCancelar.className = "avisoBtn avisoBtn--claro";
            btnCancelar.textContent = o.cancelar;

            const btnAceptar = document.createElement("button");
            btnAceptar.type = "button";
            btnAceptar.className = "avisoBtn" + (o.peligro ? " avisoBtn--peligro" : "");
            btnAceptar.textContent = o.aceptar;

            botones.append(btnCancelar, btnAceptar);
            dialogo.append(titulo, texto, botones);
            fondo.appendChild(dialogo);
            document.body.appendChild(fondo);

            const teclas = e => {
                if (e.key === "Escape") {
                    cerrar(false);
                }
            };
            function cerrar(valor) {
                document.removeEventListener("keydown", teclas);
                fondo.remove();
                resolver(valor);
            }

            btnAceptar.addEventListener("click", () => cerrar(true));
            btnCancelar.addEventListener("click", () => cerrar(false));
            fondo.addEventListener("click", e => {
                if (e.target === fondo) {
                    cerrar(false);
                }
            });
            document.addEventListener("keydown", teclas);

            (o.peligro ? btnCancelar : btnAceptar).focus();
        });
    }

    window.Avisos = {avisar: avisar, confirmar: confirmar};

    /* Avisos que llegan por la URL (?aviso=codigo) después de una redirección del servidor */
    const CODIGOS = {
        "credenciales": ["error", "Correo y/o contraseña incorrectos."],
        "foto-obligatoria": ["aviso", "Adjunta una foto del objeto para poder buscar coincidencias."],
        "reporte-registrado": ["exito", "Reporte realizado. Te avisaremos si encontramos una coincidencia."],
        "reporte-error": ["error", "No se pudo registrar el reporte. Inténtalo de nuevo."],
        "reclamo-aprobado": ["exito", "Reclamo aprobado. El estudiante fue notificado."],
        "reclamo-rechazado": ["exito", "Reclamo rechazado. El estudiante fue notificado."]
    };

    function mostrarDesdeUrl() {
        const parametros = new URLSearchParams(window.location.search);
        const codigo = parametros.get("aviso");
        if (!codigo) {
            return;
        }
        if (CODIGOS[codigo]) {
            avisar(CODIGOS[codigo][1], CODIGOS[codigo][0]);
        }
        parametros.delete("aviso");
        const resto = parametros.toString();
        try {
            history.replaceState(null, "", window.location.pathname + (resto ? "?" + resto : "") + window.location.hash);
        } catch (e) {
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", mostrarDesdeUrl);
    } else {
        mostrarDesdeUrl();
    }
})();