document.addEventListener("DOMContentLoaded", iniciarPerfilYReporte);
document.addEventListener("DOMContentLoaded", iniciarReclamo);
document.addEventListener("DOMContentLoaded", iniciarObjetosEncontrados);
document.addEventListener("DOMContentLoaded", iniciarObjetosPerdidos);

function iniciarPerfilYReporte() {
    const botonUsuario = document.getElementById("botonUsuario");
        const menuUsuario = document.getElementById("menuUsuario");
        const modal = document.getElementById("modalUsuario");

        const temaGuardado = localStorage.getItem("temaLostFind") || "claro";

        document.body.classList.toggle("temaOscuro", temaGuardado === "oscuro");

        if (botonUsuario && menuUsuario && modal) {

            const tituloModal = document.getElementById("tituloModal");
            const vistaPerfil = document.getElementById("vistaPerfil");
            const vistaConfiguracion = document.getElementById("vistaConfiguracion");

            function cerrarMenu() {
                menuUsuario.hidden = true;
                botonUsuario.setAttribute("aria-expanded", "false");
            }

            function abrirModal(tipo) {
                cerrarMenu();

                vistaPerfil.hidden = tipo !== "perfil";
                vistaConfiguracion.hidden = tipo !== "configuracion";

                if (tipo === "perfil") {
                    tituloModal.textContent = "Mi perfil";
                } else {
                    tituloModal.textContent = "Configuración";
                }

                if (!modal.open) {
                    modal.showModal();
                }
            }

            botonUsuario.addEventListener("click", function () {
                menuUsuario.hidden = !menuUsuario.hidden;
                botonUsuario.setAttribute("aria-expanded", String(!menuUsuario.hidden));
            });

            document.getElementById("verPerfil").addEventListener("click", function () {
                abrirModal("perfil");
            });

            document.getElementById("verConfiguracion").addEventListener("click", function () {
                abrirModal("configuracion");
            });

            document.getElementById("cerrarModal").addEventListener("click", function () {
                modal.close();
            });

            const editarPerfil = document.getElementById("editarPerfil");

            if (editarPerfil) {
                editarPerfil.addEventListener("click", function () {
                    abrirModal("configuracion");
                });
            }

            document.getElementById("cerrarSesion").addEventListener("click", function () {
                cerrarMenu();
                alert("Falta conectar el cierre de sesión con el servidor.");
            });

            document.addEventListener("click", function (event) {

                if (!botonUsuario.contains(event.target) &&
                    !menuUsuario.contains(event.target)) {

                    cerrarMenu();
                }

            });

            document.addEventListener("keydown", function (event) {

                if (event.key === "Escape") {
                    cerrarMenu();
                }

            });

            const avisosCoincidencias = document.getElementById("avisosCoincidencias");
            const avisosObjetos = document.getElementById("avisosObjetos");

            if (avisosCoincidencias && avisosObjetos) {

                avisosCoincidencias.checked =
                    localStorage.getItem("avisosCoincidencias") !== "false";

                avisosObjetos.checked =
                    localStorage.getItem("avisosObjetos") === "true";

                avisosCoincidencias.addEventListener("change", function () {
                    localStorage.setItem(
                        "avisosCoincidencias",
                        avisosCoincidencias.checked
                    );
                });

                avisosObjetos.addEventListener("change", function () {
                    localStorage.setItem(
                        "avisosObjetos",
                        avisosObjetos.checked
                    );
                });

            }

            const opcionesTema = document.querySelectorAll('input[name="tema"]');

            opcionesTema.forEach(function (opcion) {

                opcion.checked = opcion.value === temaGuardado;

                opcion.addEventListener("change", function () {

                    document.body.classList.toggle(
                        "temaOscuro",
                        opcion.value === "oscuro"
                    );

                    localStorage.setItem("temaLostFind", opcion.value);

                });

            });

        }

        const formulario = document.getElementById("formReporte");

        if (formulario) {

            const descripcion = document.getElementById("descripcion");
            const contador = document.getElementById("contadorReporte");
            const foto = document.getElementById("foto");
            const nombreFoto = document.getElementById("nombreFoto");
            const fechaPerdida = document.getElementById("fechaPerdida");

            const hoy = new Date();
            const año = hoy.getFullYear();
            const mes = String(hoy.getMonth() + 1).padStart(2, "0");
            const dia = String(hoy.getDate()).padStart(2, "0");

            fechaPerdida.max = año + "-" + mes + "-" + dia;

            descripcion.addEventListener("input", function () {
                contador.textContent = descripcion.value.length + "/500";
            });

            foto.addEventListener("change", function () {

                const archivo = foto.files[0];

                if (!archivo) {
                    nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
                    return;
                }

                const tiposPermitidos = [
                    "image/jpeg",
                    "image/png",
                    "image/webp"
                ];

                if (!tiposPermitidos.includes(archivo.type)) {
                    alert("Solo se permiten imágenes JPG, PNG o WEBP.");
                    foto.value = "";
                    nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
                    return;
                }

                if (archivo.size > 5 * 1024 * 1024) {
                    alert("La foto no puede superar los 5 MB.");
                    foto.value = "";
                    nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
                    return;
                }

                nombreFoto.textContent = archivo.name;

            });

            formulario.addEventListener("reset", function () {
                contador.textContent = "0/500";
                nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
            });

            formulario.addEventListener("submit", function (event) {
                event.preventDefault();
                alert("Falta conectar el formulario con el servidor para guardar el reporte.");
            });

        }
}

function iniciarReclamo() {
    const archivoEvidencia = document.getElementById("evidencia");
    const nombreEvidencia = document.getElementById("nombreEvidencia");
    const formReclamo = document.getElementById("formReclamo");

    if (archivoEvidencia) {
        archivoEvidencia.addEventListener("change", function () {
            const archivo = this.files[0];

            if (!archivo) {
                nombreEvidencia.textContent = "JPG, PNG o PDF (máx. 10 MB)";
                return;
            }

            const formatos = ["image/jpeg", "image/png", "application/pdf"];

            if (!formatos.includes(archivo.type)) {
                alert("Solo puedes subir archivos JPG, PNG o PDF.");
                this.value = "";
                nombreEvidencia.textContent = "JPG, PNG o PDF (máx. 10 MB)";
                return;
            }

            if (archivo.size > 10 * 1024 * 1024) {
                alert("El archivo no puede superar los 10 MB.");
                this.value = "";
                nombreEvidencia.textContent = "JPG, PNG o PDF (máx. 10 MB)";
                return;
            }

            nombreEvidencia.textContent = archivo.name;
        });
    }

    if (formReclamo) {
        formReclamo.addEventListener("submit", function (event) {
            event.preventDefault();

            alert("Formulario validado. Falta conectar el envío del reclamo con el servidor.");
        });
    }

}

function iniciarObjetosEncontrados() {
    const listaObjetos = document.getElementById("listaObjetosEncontrados");

        if (!listaObjetos) {
            return;
        }

        const objetos = [
            { id: 1, nombre: "AirPods con estuche", categoria: "Accesorios", sede: "Lima Sur", lugar: "Biblioteca - piso 4", fecha: "2026-09-14", foto: "Imagenes/airpods.jpg", icono: "🎧" },
            { id: 2, nombre: "Mochila negra", categoria: "Mochilas", sede: "Lima Sur", lugar: "Aula A-207", fecha: "2026-09-14", foto: "Imagenes/mochila.jpg", icono: "🎒" },
            { id: 3, nombre: "iPhone 13", categoria: "Celulares", sede: "Lima Sur", lugar: "Cafetería central", fecha: "2026-09-13", foto: "Imagenes/iphone.jpg", icono: "📱" },
            { id: 4, nombre: "Billetera negra", categoria: "Accesorios", sede: "Lima Sur", lugar: "Sala de estudio - piso 3", fecha: "2026-09-12", foto: "Imagenes/billetera.jpg", icono: "👛" },
            { id: 5, nombre: "Audífonos Sony celestes", categoria: "Accesorios", sede: "Lima Sur", lugar: "Aula B-105", fecha: "2026-09-11", foto: "Imagenes/audifonos.jfif", icono: "🎧" },
            { id: 6, nombre: "Tomatodo beige", categoria: "Otros", sede: "Lima Sur", lugar: "Zona deportiva", fecha: "2026-09-11", foto: "Imagenes/tomatodo.jpg", icono: "🧴" },
            { id: 7, nombre: "Lentes con montura negra", categoria: "Accesorios", sede: "Lima Sur", lugar: "Biblioteca - piso 4", fecha: "2026-09-10", foto: "Imagenes/lentes.jpg", icono: "👓" },
            { id: 8, nombre: "iPad gris", categoria: "Tablets", sede: "Lima Sur", lugar: "Sala de cómputo", fecha: "2026-09-10", foto: "Imagenes/ipad.jpg", icono: "📱" },
            { id: 9, nombre: "Llaves con llavero UTP", categoria: "Otros", sede: "Lima Sur", lugar: "Ingreso principal", fecha: "2026-09-09", foto: "Imagenes/llaves.jpg", icono: "🔑" },
            { id: 10, nombre: "Gorra negra", categoria: "Accesorios", sede: "Lima Sur", lugar: "Zona deportiva", fecha: "2026-09-09", foto: "Imagenes/gorra.jpg", icono: "🧢" },
            { id: 11, nombre: "Polera gris", categoria: "Ropa", sede: "Lima Sur", lugar: "Aula C-302", fecha: "2026-09-08", foto: "Imagenes/polera.jpg", icono: "👕" },
            { id: 12, nombre: "Cuaderno A5", categoria: "Útiles", sede: "Lima Sur", lugar: "Biblioteca - piso 2", fecha: "2026-09-08", foto: "Imagenes/cuaderno.jpg", icono: "📓" },

            { id: 13, nombre: "Mouse inalámbrico", categoria: "Electrónica", sede: "Lima Centro", lugar: "Sala de cómputo", fecha: "2026-09-07", foto: "Imagenes/mouse.jpg", icono: "🖱️" },
            { id: 14, nombre: "Cartuchera azul", categoria: "Útiles", sede: "Lima Sur", lugar: "Aula B-105", fecha: "2026-09-07", foto: "Imagenes/cartuchera.jpg", icono: "✏️" },
            { id: 15, nombre: "Carné universitario", categoria: "Otros", sede: "Lima Sur", lugar: "Ingreso principal", fecha: "2026-09-06", foto: "Imagenes/carne.jpg", icono: "🪪" },
            { id: 16, nombre: "Botella negra", categoria: "Otros", sede: "Lima Centro", lugar: "Zona deportiva", fecha: "2026-09-06", foto: "Imagenes/botella.jpg", icono: "🧴" },
            { id: 17, nombre: "Batería portátil", categoria: "Electrónica", sede: "Lima Sur", lugar: "Biblioteca - piso 2", fecha: "2026-09-05", foto: "Imagenes/bateria.jpg", icono: "🔋" },
            { id: 18, nombre: "Calculadora gris", categoria: "Electrónica", sede: "Lima Sur", lugar: "Aula A-207", fecha: "2026-09-05", foto: "Imagenes/calculadora.jpg", icono: "🧮" },
            { id: 19, nombre: "Casaca beige", categoria: "Ropa", sede: "Lima Centro", lugar: "Sala de estudio", fecha: "2026-09-04", foto: "Imagenes/casaca.jpg", icono: "🧥" },
            { id: 20, nombre: "Cable USB-C", categoria: "Electrónica", sede: "Lima Sur", lugar: "Sala de cómputo", fecha: "2026-09-04", foto: "Imagenes/cable.jpg", icono: "🔌" },
            { id: 21, nombre: "Libro de Matemática", categoria: "Útiles", sede: "Lima Sur", lugar: "Biblioteca - piso 4", fecha: "2026-09-03", foto: "Imagenes/libro.jpg", icono: "📚" },
            { id: 22, nombre: "Paraguas azul", categoria: "Accesorios", sede: "Lima Centro", lugar: "Ingreso principal", fecha: "2026-09-03", foto: "Imagenes/paraguas.jpg", icono: "☂️" },
            { id: 23, nombre: "Memoria USB plateada", categoria: "Electrónica", sede: "Lima Sur", lugar: "Aula C-302", fecha: "2026-09-02", foto: "Imagenes/usb.jpg", icono: "💾" },
            { id: 24, nombre: "Llavero rojo", categoria: "Otros", sede: "Lima Centro", lugar: "Cafetería central", fecha: "2026-09-02", foto: "Imagenes/llavero.jpg", icono: "🔑" }
        ];

        const buscar = document.getElementById("buscarObjetos");
        const categoria = document.getElementById("filtroCategoria");
        const sede = document.getElementById("filtroSede");
        const lugar = document.getElementById("filtroLugar");
        const fecha = document.getElementById("filtroFecha");
        const orden = document.getElementById("ordenObjetos");

        const cantidad = document.getElementById("cantidadObjetos");
        const sinObjetos = document.getElementById("sinObjetos");
        const paginacion = document.getElementById("paginacionObjetos");

        let paginaActual = 1;
        const objetosPorPagina = 12;

        function normalizar(texto) {
            return texto.toLowerCase()
                    .normalize("NFD")
                    .replace(/[\u0300-\u036f]/g, "");
        }

        function mostrarFecha(valor) {
            const partes = valor.split("-");
            const meses = [
                "ene", "feb", "mar", "abr", "may", "jun",
                "jul", "ago", "sep", "oct", "nov", "dic"
            ];

            const dia = Number(partes[2]);
            const mes = meses[Number(partes[1]) - 1];

            return dia + " " + mes + " " + partes[0];
        }

        function mostrarObjetos() {

            const palabra = normalizar(buscar.value.trim());

            let resultados = objetos.filter(function (objeto) {

                const textoObjeto = normalizar(
                        objeto.nombre + " " +
                        objeto.categoria + " " +
                        objeto.lugar + " " +
                        objeto.sede
                        );

                const coincideNombre = textoObjeto.includes(palabra);
                const coincideCategoria = categoria.value === "" ||
                        objeto.categoria === categoria.value;

                const coincideSede = sede.value === "" ||
                        objeto.sede === sede.value;

                const coincideLugar = lugar.value === "" ||
                        normalizar(objeto.lugar).includes(normalizar(lugar.value));

                const coincideFecha = fecha.value === "" ||
                        objeto.fecha.startsWith(fecha.value);

                return coincideNombre &&
                        coincideCategoria &&
                        coincideSede &&
                        coincideLugar &&
                        coincideFecha;
            });

            if (orden.value === "recientes") {
                resultados.sort(function (a, b) {
                    return b.fecha.localeCompare(a.fecha);
                });
            }

            if (orden.value === "antiguos") {
                resultados.sort(function (a, b) {
                    return a.fecha.localeCompare(b.fecha);
                });
            }

            if (orden.value === "nombre") {
                resultados.sort(function (a, b) {
                    return a.nombre.localeCompare(b.nombre, "es");
                });
            }

            cantidad.textContent = "Se encontraron " + resultados.length +
                    (resultados.length === 1 ? " objeto" : " objetos");

            sinObjetos.hidden = resultados.length > 0;

            const totalPaginas = Math.ceil(resultados.length / objetosPorPagina);

            if (paginaActual > totalPaginas) {
                paginaActual = 1;
            }

            const inicio = (paginaActual - 1) * objetosPorPagina;
            const objetosPagina = resultados.slice(inicio, inicio + objetosPorPagina);

            let tarjetas = "";

            for (const objeto of objetosPagina) {

                tarjetas += `
                    <article class="tarjetaObjetoEncontrado">

                        <div class="imagenListaObjeto">
                            <span class="emojiListaObjeto">${objeto.icono}</span>

                            <img src="${objeto.foto}"
                                 alt="${objeto.nombre}"
                                 loading="lazy">
                        </div>

                        <h3>${objeto.nombre}</h3>

                        <p>🏷️ ${objeto.categoria}</p>
                        <p>📍 ${objeto.lugar}</p>
                        <p>📅 ${mostrarFecha(objeto.fecha)}</p>

                        <a class="enlaceDetalle"
                           href="DetalleCoincidencia.jsp?objeto=${objeto.id}">
                            Ver detalle →
                        </a>

                    </article>
                `;
            }

            listaObjetos.innerHTML = tarjetas;

            const imagenes = listaObjetos.querySelectorAll("img");

            imagenes.forEach(function (imagen) {
                imagen.addEventListener("error", function () {
                    imagen.style.display = "none";
                });
            });

            mostrarPaginacion(totalPaginas);
        }

        function mostrarPaginacion(totalPaginas) {

            paginacion.innerHTML = "";

            if (totalPaginas <= 1) {
                return;
            }

            function crearBoton(texto, numero, activo) {

                const boton = document.createElement("button");
                boton.type = "button";
                boton.textContent = texto;

                if (activo) {
                    boton.classList.add("actual");
                }

                if (numero < 1 || numero > totalPaginas) {
                    boton.disabled = true;
                }

                boton.addEventListener("click", function () {
                    paginaActual = numero;
                    mostrarObjetos();
                });

                paginacion.appendChild(boton);
            }

            crearBoton("‹", paginaActual - 1, false);

            for (let numero = 1; numero <= totalPaginas; numero++) {
                crearBoton(numero, numero, numero === paginaActual);
            }

            crearBoton("›", paginaActual + 1, false);
        }

        document.getElementById("botonBuscarObjetos").addEventListener("click", function () {
            paginaActual = 1;
            mostrarObjetos();
        });

        buscar.addEventListener("input", function () {
            paginaActual = 1;
            mostrarObjetos();
        });

        [categoria, sede, lugar, fecha, orden].forEach(function (filtro) {
            filtro.addEventListener("change", function () {
                paginaActual = 1;
                mostrarObjetos();
            });
        });

        document.getElementById("limpiarFiltros").addEventListener("click", function () {

            buscar.value = "";
            categoria.value = "";
            sede.value = "";
            lugar.value = "";
            fecha.value = "";
            orden.value = "recientes";

            paginaActual = 1;
            mostrarObjetos();
        });

        mostrarObjetos();
}

function iniciarObjetosPerdidos() {
    const listaReportes = document.getElementById("listaReportes");

        if (!listaReportes) {
            return;
        }

        const buscarReportes = document.getElementById("buscarReportes");
        const ordenReportes = document.getElementById("ordenReportes");
        const cantidadReportes = document.getElementById("cantidadReportes");
        const sinReportes = document.getElementById("sinReportes");

        const reportes = Array.from(
            listaReportes.querySelectorAll(".reportePerdido")
        );

        function normalizarReporte(texto) {
            return texto.toLowerCase()
                    .normalize("NFD")
                    .replace(/[\u0300-\u036f]/g, "");
        }

        function mostrarReportes() {

            const palabra = normalizarReporte(buscarReportes.value.trim());

            const resultados = reportes.filter(function (reporte) {
                const nombre = normalizarReporte(reporte.dataset.nombre);

                return nombre.includes(palabra);
            });

            if (ordenReportes.value === "recientes") {
                resultados.sort(function (a, b) {
                    return b.dataset.fecha.localeCompare(a.dataset.fecha);
                });
            } else {
                resultados.sort(function (a, b) {
                    return a.dataset.fecha.localeCompare(b.dataset.fecha);
                });
            }

            reportes.forEach(function (reporte) {
                reporte.hidden = true;
            });

            resultados.forEach(function (reporte) {
                reporte.hidden = false;
                listaReportes.appendChild(reporte);
            });

            cantidadReportes.textContent =
                    "Se encontraron " + resultados.length +
                    (resultados.length === 1 ? " reporte" : " reportes");

            sinReportes.hidden = resultados.length > 0;
        }

        document.getElementById("formBuscarReportes")
                .addEventListener("submit", function (event) {

                    event.preventDefault();
                    mostrarReportes();
                });

        buscarReportes.addEventListener("input", mostrarReportes);

        ordenReportes.addEventListener("change", mostrarReportes);

        document.getElementById("cerrarNotificacion")
                .addEventListener("click", function () {

                    document.getElementById("notificacionPerdidos").hidden = true;
                });

        const botonesCancelar = document.querySelectorAll("[data-cancelar]");

        botonesCancelar.forEach(function (boton) {

            boton.addEventListener("click", function () {

                const confirmar = confirm(
                    "¿Deseas cancelar este reporte? Esta es una prueba visual."
                );

                if (!confirmar) {
                    return;
                }

                const reporte = boton.closest(".reportePerdido");

                const estado = reporte.querySelector(".etiquetaEstado");
                const descripcion = reporte.querySelector(".descripcionEstado");

                estado.className = "etiquetaEstado reporteCancelado";
                estado.textContent = "🚫 Cancelado";

                descripcion.textContent =
                        "El reporte fue cancelado en esta demostración.";

                boton.remove();

                alert("Estado actualizado solo en esta página de prueba.");
            });

        });

        const imagenesReportes = listaReportes.querySelectorAll("img");

        imagenesReportes.forEach(function (imagen) {

            imagen.addEventListener("error", function () {

                const contenedor = imagen.parentElement;
                const nombre = imagen.alt.toLowerCase();

                let icono = "📦";

                if (nombre.includes("mochila")) {
                    icono = "🎒";
                } else if (nombre.includes("iphone")) {
                    icono = "📱";
                } else if (nombre.includes("lentes")) {
                    icono = "👓";
                } else if (nombre.includes("gorra")) {
                    icono = "🧢";
                }

                imagen.remove();

                const emoji = document.createElement("span");
                emoji.textContent = icono;
                emoji.style.fontSize = "3rem";

                contenedor.appendChild(emoji);
            });

        });

        mostrarReportes();
}

//modales del nav
document.addEventListener("DOMContentLoaded", iniciarAyudaInicio);

function iniciarAyudaInicio() {
    const modalAyuda = document.getElementById("modalAyudaInicio");

    if (!modalAyuda) {
        return;
    }

    const titulo = document.getElementById("tituloAyudaInicio");
    const panelPreguntas = document.getElementById("panelPreguntasInicio");
    const panelContacto = document.getElementById("panelContactoInicio");
    const panelGuia = document.getElementById("panelGuiaInicio");
    const pasos = Array.from(panelGuia.querySelectorAll(".pasoGuiaInicio"));
    const indicadores = panelGuia.querySelectorAll(".puntoGuiaInicio");
    const contador = document.getElementById("contadorGuiaInicio");
    const anterior = document.getElementById("anteriorGuiaInicio");
    const siguiente = document.getElementById("siguienteGuiaInicio");
    let pasoActual = 0;

    function mostrarPaso() {
        pasos.forEach(function (paso, indice) {
            paso.hidden = indice !== pasoActual;
        });

        indicadores.forEach(function (punto, indice) {
            punto.classList.toggle("activo", indice === pasoActual);
        });

        contador.textContent = "Paso " + (pasoActual + 1) + " de " + pasos.length;
        anterior.disabled = pasoActual === 0;
        siguiente.textContent = pasoActual === pasos.length - 1 ? "Finalizar" : "Siguiente →";
    }

    function abrirAyuda(tipo) {
        panelPreguntas.hidden = tipo !== "preguntas";
        panelContacto.hidden = tipo !== "contacto";
        panelGuia.hidden = tipo !== "guia";

        if (tipo === "preguntas") {
            titulo.textContent = "❓ Preguntas frecuentes";
        } else if (tipo === "contacto") {
            titulo.textContent = "☎️ Contacto";
        } else {
            titulo.textContent = "📖 Guía de usuario";
            pasoActual = 0;
            mostrarPaso();
        }

        if (!modalAyuda.open) {
            modalAyuda.showModal();
        }
    }

    document.querySelectorAll("[data-ayuda]").forEach(function (enlace) {
        enlace.addEventListener("click", function (evento) {
            evento.preventDefault();
            abrirAyuda(enlace.dataset.ayuda);
        });
    });

    document.getElementById("cerrarAyudaInicio").addEventListener("click", function () {
        modalAyuda.close();
    });

    anterior.addEventListener("click", function () {
        if (pasoActual > 0) {
            pasoActual--;
            mostrarPaso();
        }
    });

    siguiente.addEventListener("click", function () {
        if (pasoActual < pasos.length - 1) {
            pasoActual++;
            mostrarPaso();
        } else {
            modalAyuda.close();
        }
    });

    modalAyuda.addEventListener("click", function (evento) {
        if (evento.target === modalAyuda) {
            modalAyuda.close();
        }
    });
}