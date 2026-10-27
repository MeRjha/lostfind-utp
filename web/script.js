document.addEventListener("DOMContentLoaded", iniciarPerfilYReporte);
document.addEventListener("DOMContentLoaded", iniciarReclamo);
document.addEventListener("DOMContentLoaded", iniciarObjetosEncontrados);
document.addEventListener("DOMContentLoaded", function () {

    const parametros = new URLSearchParams(window.location.search);

    const accion = parametros.get("accion");

    if (accion === "coincidenciasPerdidos") {
        mostrarCoincidenciasDesdeObjetosPerdidos();
    } else if (accion === "coincidenciasReportes") {
        mostrarCoincidenciasDesdeReporte();
    }
});

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
                const divUsuario = document.getElementById("InfoUsuario");
                const usuario = JSON.parse(divUsuario.dataset.usuario);
                let correo = usuario.correoInstitucional;
                let codigo = correo.split("@")[0];
                let sede = usuario.sede.nombre;
                console.log("aqui" + usuario.fotoPerfil);
                vistaPerfil.innerHTML = `

                <div class="datosPerfil">
                    <img src="${usuario.fotoPerfil}" alt="Foto de perfil">
                    <h3 class="nombreUsuario">${usuario.nombre} ${usuario.apellido}</h3>
                    <p>${correo}</p>
                    <span class="badge">${usuario.rol} UTP</span>
                </div>

                <h3 class="subtituloModal">Información personal</h3>

                <div class="informacionPersonal">
                    <p><b>Nombre:</b> <span class="nombreUsuario">${usuario.nombre} ${usuario.apellido}</span></p>
                    <p><b>Correo:</b> ${correo}</p>
                    <p><b>Código:</b>  ${codigo}</p>
                    <p><b>Sede:</b> ${sede}</p>
                    <p><b>Tipo:</b> ${usuario.rol} UTP</p>
                </div>
            `;
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
            menuNotificaciones.hidden = true;
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
            window.location.href = "Inicio.jsp";
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


    }
}

function botonVerCoincidencias(boton) {
    let idObjetoPerdido = boton.dataset.idObjetoPerdido;
    sessionStorage.setItem("idObjetoPerdido", idObjetoPerdido);
    window.location.href = "Coincidencias.jsp?accion=coincidenciasPerdidos";
}

async function mostrarCoincidenciasDesdeObjetosPerdidos() {
    let idObjetoPerdido = sessionStorage.getItem("idObjetoPerdido");
    console.log("ID del ojeto Perdido: "+idObjetoPerdido);
    const datos = new URLSearchParams();
    datos.append("idObjetoPerdido", idObjetoPerdido);
    const respuesta = await fetch("CoincidenciaDesdeObjetosPerdidosServlet", {
        method: "POST",
        body: datos
    });
    if (!respuesta.ok) {
        throw new Error("Error al actualizar el reporte");
    }
    const listaReportes = await respuesta.json();
    let reporte = listaReportes[0];
    let resultado = `<div class="resumenReporte">
                            <div class="iconoReporteCoincidencia">📄</div>

                            <div>
                                <h2>Tu objeto reportado</h2>
                                <p>Aquí tienes un resumen del objeto que reportaste como perdido.</p>
                            </div>
                        </div>

                        <div class="detalleReporteCoincidencia">

                            <div class="imagenReporteCoincidencia">
                                <img src="${reporte.objetoPerdido.imagen}"
                                     alt="${reporte.objetoPerdido.nombre} ${reporte.objetoPerdido.marca} ${reporte.objetoPerdido.color}">
                            </div>

                            <div class="infoReporteCoincidencia">

                                <h3>${reporte.objetoPerdido.nombre} ${reporte.objetoPerdido.marca} ${reporte.objetoPerdido.color}</h3>

                                <div class="datosReporteCoincidencia">

                                    <div class="datoCoincidencia">
                                        <span>🏷️</span>
                                        <div>
                                            <strong>Categoría</strong>
                                            <p>${reporte.objetoPerdido.categoria}</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>🎨</span>
                                        <div>
                                            <strong>Color</strong>
                                            <p>${reporte.objetoPerdido.color}</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>📅</span>
                                        <div>
                                            <strong>Fecha de pérdida</strong>
                                            <p>${reporte.objetoPerdido.fechaPerdida}</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>📍</span>
                                        <div>
                                            <strong>Lugar</strong>
                                            <p>${reporte.objetoPerdido.lugarReferencia}</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>`;
    document.getElementById("tuObjetoPerdido").innerHTML = resultado;
    verCoincidenciaDelObjetoPerdido(reporte.objetoPerdido);
}

async function verCoincidenciaDelObjetoPerdido(objetoPerdido) {
    const objetoEnviar = {
        ...objetoPerdido,
        fechaPerdida: convertirFecha(objetoPerdido.fechaPerdida),
        fechaRegistro: convertirFecha(objetoPerdido.fechaRegistro)
    };
    const datos = new URLSearchParams();
    datos.append("objetoPerdido", JSON.stringify(objetoEnviar));
    const respuesta = await fetch("VerCoincideciasDeUnObjetoPerdidoServlet", {
        method: "POST",
        body: datos
    }
    );
    if (!respuesta.ok) {
        throw new Error("Error al actualizar el reporte");
    }
    const listaCoincidencias = await respuesta.json();
    let resultado = "";
    for (let coincidencia of listaCoincidencias) {
        const coincidenciaJSON = encodeURIComponent(
                JSON.stringify(coincidencia)
                ).replace(/'/g, "%27");
        resultado += `
<article class="tarjetaCoincidenciaObjeto">

                            <div class="filaCoincidencia">

                                <img class="imagenCoincidenciaObjeto"
                                     src="${coincidencia.objetoEncontrado.imagen}"
                                     alt="${coincidencia.objetoEncontrado.nombre} ${coincidencia.objetoEncontrado.marca} ${coincidencia.objetoEncontrado.color}">

                                <div class="contenidoCoincidenciaObjeto">

                                    <h3>${coincidencia.objetoEncontrado.nombre} ${coincidencia.objetoEncontrado.marca} ${coincidencia.objetoEncontrado.color}</h3>

                                    <div class="estadoCoincidencia">
                                        <span class="porcentajeCoincidencia ${textoCoincidencia(coincidencia.porcentajeSimilitud)}">${coincidencia.porcentajeSimilitud}%</span>
                                        <span class="textoCoincidencia ${textoCoincidencia(coincidencia.porcentajeSimilitud)}Texto">Coincidencia ${textoCoincidencia(coincidencia.porcentajeSimilitud)}</span>
                                    </div>

                                    <div class="detalleCoincidenciaLista">
                                        <p>📍 ${coincidencia.objetoEncontrado.lugarReferencia}</p>
                                        <p>📅${coincidencia.objetoEncontrado.fechaHallazgo}</p>
                                    </div>

                                </div>
                            </div>

                            <button type="button" onclick="verDetalleCoincidencia('${coincidenciaJSON}')" class="btn">
                                Ver detalle →
                            </button>
                        </article>
`;
        document.getElementById("listaDeCoincidencias").innerHTML = resultado;
    }
}

function verDetalleCoincidencia(datos) {
    const coincidencia = JSON.parse(decodeURIComponent(datos));
    sessionStorage.setItem("coincidencia", JSON.stringify(coincidencia));
    window.location.href = "DetalleCoincidencia.jsp";
}
function mostrarBotonVolver(idPerdido) {
    document.getElementById("BotonVolver").innerHTML = `
<button onclick="botonVerCoincidencias(this)" class="volverDetalle" data-id-objeto-perdido="${idPerdido}">
                    ← Volver a coincidencias
                </button>
`;
}
function coincidenciaVer(coincidencia) {
    let porcentaje = coincidencia.porcentajeSimilitud;
    let texto = "";
    if (porcentaje > 80) {
        texto = "Coincidencia alta detectada por el sistema.";
    } else {
        texto = "Coincidencia media detectada por el sistema.";
    }
    document.getElementById("coincidenciaSistema").innerHTML = `
<h2>${porcentaje}% de similitud</h2>
                            <p>${texto}</p>
`;
}
function verCoincidenciaIndividual() {
    const coincidencia = JSON.parse(
            sessionStorage.getItem("coincidencia") || "null"
            );
    mostrarBotonVolver(coincidencia.objetoPerdido.idObjeto);
    coincidenciaVer(coincidencia);
    let resultado = `
 <article class="cuadroTarjetas fichaObjeto">

                        <div class="encabezadoFicha">
                            <span class="iconoFicha">📄</span>

                            <div>
                                <h2>Tu objeto reportado</h2>
                                <p>Información que registraste como objeto perdido.</p>
                            </div>
                        </div>

                        <div class="contenidoFicha">

                            <img src="${coincidencia.objetoPerdido.imagen}"
                                 alt="${coincidencia.objetoPerdido.nombre} ${coincidencia.objetoPerdido.marca} ${coincidencia.objetoPerdido.color}">

                            <div class="datosFicha">

                                <p>
                                    <b>🏷️ Nombre:</b>
                                    <span>${coincidencia.objetoPerdido.nombre} ${coincidencia.objetoPerdido.marca}</span>
                                </p>

                                <p>
                                    <b>📦 Categoría:</b>
                                    <span> ${coincidencia.objetoPerdido.categoria}</span>
                                </p>

                                <p>
                                    <b>🎨 Color:</b>
                                    <span>${coincidencia.objetoPerdido.color}</span>
                                </p>

                                <p>
                                    <b>📅 Fecha de pérdida:</b>
                                    <span>${coincidencia.objetoPerdido.fechaPerdida}</span>
                                </p>

                                <p>
                                    <b>📍 Lugar:</b>
                                    <span>${coincidencia.objetoPerdido.lugarReferencia}</span>
                                </p>

                                <p>
                                    <b>📝 Descripción:</b>
                                    <span>
                                       ${coincidencia.objetoPerdido.descripcion}
                                    </span>
                                </p>

                            </div>
                        </div>

                    </article>

                    <article class="cuadroTarjetas fichaObjeto">

                        <div class="encabezadoFicha">
                            <span class="iconoFicha">👥</span>

                            <div>
                                <h2>Objeto encontrado</h2>
                                <p>Información registrada por el SAE.</p>
                            </div>
                        </div>

                        <div class="contenidoFicha">

                            <img src="${coincidencia.objetoEncontrado.imagen}"
                                 alt="${coincidencia.objetoEncontrado.nombre} ${coincidencia.objetoEncontrado.marca} ${coincidencia.objetoEncontrado.color}">

                            <div class="datosFicha">

                                <p>
                                    <b>🏷️ Nombre:</b>
                                    <span>${coincidencia.objetoEncontrado.nombre} ${coincidencia.objetoEncontrado.marca}</span>
                                </p>

                                <p>
                                    <b>📦 Categoría:</b>
                                    <span>${coincidencia.objetoEncontrado.categoria}</span>
                                </p>

                                <p>
                                    <b>🎨 Color:</b>
                                    <span>${coincidencia.objetoEncontrado.color}</span>
                                </p>

                                <p>
                                    <b>📅 Fecha de hallazgo:</b>
                                    <span>${coincidencia.objetoEncontrado.fechaHallazgo}</span>
                                </p>

                                <p>
                                    <b>📍 Lugar encontrado:</b>
                                    <span>${coincidencia.objetoEncontrado.lugarReferencia}</span>
                                </p>

                                <p>
                                    <b>📝 Descripción:</b>
                                    <span>
                                        ${coincidencia.objetoEncontrado.descripcion}
                                    </span>
                                </p>

                            </div>
                        </div>

                    </article>

`;

    document.getElementById("comparacionObjetos").innerHTML = resultado;
    crearBotonesEnDetalle(coincidencia.objetoEncontrado);
}

function textoCoincidencia(porcentaje) {
    if (porcentaje > 80) {
        return "alta";
    } else {
        return "media";
    }
}
async function mostrarCoincidenciasDesdeReporte() {
    const respuesta = await fetch("CoincidenciaServlet", {
        method: "POST"
    });

    if (!respuesta.ok) {
        throw new Error("Error al obtener las coincidencias");
    }

    const listaCoincidencias = await respuesta.json();

    console.log(listaCoincidencias);

    let resultado2 = "";
    for (let coincidencia of listaCoincidencias) {
        const coincidenciaJSON = encodeURIComponent(
                JSON.stringify(coincidencia)
                ).replace(/'/g, "%27");
        let porcentaje = coincidencia.porcentajeSimilitud;

        resultado2 += `
<article class="tarjetaCoincidenciaObjeto">

                            <div class="filaCoincidencia">

                                <img class="imagenCoincidenciaObjeto"
                                     src="${coincidencia.objetoEncontrado.imagen}"
                                     alt="${coincidencia.objetoEncontrado.nombre} ${coincidencia.objetoEncontrado.marca} ${coincidencia.objetoEncontrado.color}">

                                <div class="contenidoCoincidenciaObjeto">

                                    <h3>${coincidencia.objetoEncontrado.nombre} ${coincidencia.objetoEncontrado.marca} ${coincidencia.objetoEncontrado.color}</h3>

                                    <div class="estadoCoincidencia">
                                        <span class="porcentajeCoincidencia ${textoCoincidencia(porcentaje)}">${porcentaje}%</span>
                                        <span class="textoCoincidencia ${textoCoincidencia(porcentaje)}Texto">Coincidencia ${textoCoincidencia(porcentaje)}</span>
                                    </div>

                                    <div class="detalleCoincidenciaLista">
                                        <p>📍 ${coincidencia.objetoEncontrado.lugarReferencia}</p>
                                        <p>📅${coincidencia.objetoEncontrado.fechaHallazgo}</p>
                                    </div>

                                </div>
                            </div>

                            <button type="button" onclick="verDetalleCoincidencia('${coincidenciaJSON}')" class="btn">
                                Ver detalle →
                            </button>
                        </article>
`;
    }
    let reporte = listaCoincidencias[0];
    let resultado = `<div class="resumenReporte">
                            <div class="iconoReporteCoincidencia">📄</div>

                            <div>
                                <h2>Tu objeto reportado</h2>
                                <p>Aquí tienes un resumen del objeto que reportaste como perdido.</p>
                            </div>
                        </div>

                        <div class="detalleReporteCoincidencia">

                            <div class="imagenReporteCoincidencia">
                                <img src="${reporte.objetoPerdido.imagen}"
                                     alt="${reporte.objetoPerdido.nombre} ${reporte.objetoPerdido.marca} ${reporte.objetoPerdido.color}">
                            </div>

                            <div class="infoReporteCoincidencia">

                                <h3>${reporte.objetoPerdido.nombre} ${reporte.objetoPerdido.marca} ${reporte.objetoPerdido.color}</h3>

                                <div class="datosReporteCoincidencia">

                                    <div class="datoCoincidencia">
                                        <span>🏷️</span>
                                        <div>
                                            <strong>Categoría</strong>
                                            <p>${reporte.objetoPerdido.categoria}</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>🎨</span>
                                        <div>
                                            <strong>Color</strong>
                                            <p>${reporte.objetoPerdido.color}</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>📅</span>
                                        <div>
                                            <strong>Fecha de pérdida</strong>
                                            <p>${reporte.objetoPerdido.fechaPerdida}</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>📍</span>
                                        <div>
                                            <strong>Lugar</strong>
                                            <p>${reporte.objetoPerdido.lugarReferencia}</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>`;
    document.getElementById("tuObjetoPerdido").innerHTML = resultado;
    document.getElementById("listaDeCoincidencias").innerHTML = resultado2;
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

        });
    }

}

async function iniciarObjetosEncontrados() {
    const listaObjetos = document.getElementById("listaObjetosEncontrados");

    if (!listaObjetos) {
        return;
    }

    const objetos = await mostrarObjetosEncontrados();
    console.log("Objetos:", objetos);
    const buscar = document.getElementById("buscarObjetos");
    const categoria = document.getElementById("filtroCategoria");
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
        const partes = valor.split(" ");

        return partes[0] + " " + partes[2];
        console.log(partes[0]);
        console.log(partes[0] + " " + partes[2]);
        console.log(partes[2]);
    }

    function mostrarObjetos() {

        const palabra = normalizar(buscar.value.trim());

        let resultados = objetos.filter(function (objeto) {

            const textoObjeto = normalizar(
                    objeto.nombre + " " +
                    objeto.categoria + " " +
                    objeto.lugarReferencia + " "
                    );

            const coincideNombre = textoObjeto.includes(palabra);
            const coincideCategoria = categoria.value === "" ||
                    objeto.categoria === categoria.value;



            const coincideLugar = lugar.value === "" ||
                    normalizar(objeto.lugarReferencia).includes(normalizar(lugar.value));

            const coincideFecha = fecha.value === "" ||
                    mostrarFecha(objeto.fechaHallazgo) === fecha.value.toLowerCase();

            return coincideNombre &&
                    coincideCategoria &&
                    coincideLugar &&
                    coincideFecha;
        });

        if (orden.value === "recientes") {
            resultados.sort(function (a, b) {
                return b.fechaHallazgo.localeCompare(a.fechaHallazgo);
            });
        }

        if (orden.value === "antiguos") {
            resultados.sort(function (a, b) {
                return a.fechaHallazgo.localeCompare(b.fechaHallazgo);
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
                            <span class="emojiListaObjeto"></span>

                            <img src="${objeto.imagen}"
                                 alt="${objeto.nombre}"
                                 loading="lazy">
                        </div>

                        <h3>${objeto.nombre}</h3>

                        <p>🏷️ ${objeto.categoria}</p>
                        <p>📍 ${objeto.lugarReferencia}</p>
                        <p>📅 ${mostrarFecha(objeto.fechaHallazgo)}</p>

                        <a class="enlaceDetalle"
                           href="ReportarObjeto.jsp">
                            Solicitar Reclamo →
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

    [categoria, lugar, fecha, orden].forEach(function (filtro) {
        filtro.addEventListener("change", function () {
            paginaActual = 1;
            mostrarObjetos();
        });
    });

    document.getElementById("limpiarFiltros").addEventListener("click", function () {

        buscar.value = "";
        categoria.value = "";
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
        console.table(resultados.map(function (reporte) {
            return {
                nombre: reporte.dataset.nombre,
                fechaOriginal: reporte.dataset.fecha,
                fechaConvertida: convertirFecha(reporte.dataset.fecha)
            };
        }));
        if (ordenReportes.value === "recientes") {
            resultados.sort(function (a, b) {
                console.log(convertirFecha(b.dataset.fecha));
                console.log(convertirFecha(a.dataset.fecha));

                return convertirFecha(b.dataset.fecha).localeCompare(convertirFecha(a.dataset.fecha));
            });
        } else {
            resultados.sort(function (a, b) {
                return convertirFecha(a.dataset.fecha).localeCompare(convertirFecha(b.dataset.fecha));
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
            console.log("ID del botón:", boton.dataset.idObjetoPerdido);
            cambiarEstadoReserva("🚫 Cancelado", boton.dataset.idObjetoPerdido);
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
function cambiarEstadoReserva(estado, idObjeto) {
    const datos = new URLSearchParams();
    datos.append("idObjetoPerdido", idObjeto);
    datos.append("estado", estado);

    fetch("CambiaEstadoReporteServlet", {
        method: "POST",
        body: datos
    });
}
//modales del nav
document.addEventListener("DOMContentLoaded", iniciarAyudaInicio);
function convertirFecha(fecha) {
    const meses = {
        ene: "01", feb: "02", mar: "03", abr: "04",
        may: "05", jun: "06", jul: "07", ago: "08",
        sep: "09", oct: "10", nov: "11", dic: "12"
    };

    const [mes, dia, anio] = fecha.replace(/[.,]/g, "").split(" ");

    return `${anio}-${meses[mes]}-${dia.padStart(2, "0")}`;
}

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


async function mostrarObjetosEncontrados() {
    try {
        const respuesta = await fetch("ObjetosEncontradosServlet", {method: "POST"});
        if (!respuesta.ok) {
            throw new Error("Error al obtener los objetos perdidos");
        }
        const objetosPerdidos = await respuesta.json();
        return objetosPerdidos;
    } catch (error) {
        console.error("Error: ", error);
    }
}

async function mostrarObjetosEncontradosRecientemente() {
    try {
        const respuesta = await fetch("ObjetosServlet", {method: "POST"});
        if (!respuesta.ok) {
            throw new Error("Error al obtener los objetos perdidos");
        }
        const objetosPerdidos = await respuesta.json();
        let resultado = "";
        for (let objeto of objetosPerdidos) {
            resultado += `<article class="cuadroTarjetas tarjetaObjeto">
                            <img class="fotoObjeto"
                                 src="${objeto.imagen}"
                                 alt="${objeto.nombre}">
                            <h3>${objeto.nombre}</h3>
                            <p>📍 Encontrada en ${objeto.lugarReferencia}.</p>
                            <a href="ReportarObjeto.jsp" class="enlaceDetalle">Solicitar reclamo →</a>
                        </article> `;
        }
        document.getElementById("objetosRecientes").innerHTML = resultado;
    } catch (error) {
        console.error("Error: ", error);
    }
}
function nuevaCoincidenciaEncontrada(reportes) {
    let noti = document.getElementById("notificacionPerdidos");
    let resultado = "";
    for (let reporte of reportes) {
        if (reporte.estado === "✅ Coincidencia encontrada") {
            resultado += `<div class="notificacionPerdidos" id="notificacionPerdidos">

                <span class="iconoNotificacion">✅</span>

                    <div class="textoNotificacion">
                        <h3>¡Nueva coincidencia encontrada!</h3>
                        <p>
                            Encontramos un objeto similar a tu reporte de
                            "${reporte.objetoPerdido.nombre} ${reporte.objetoPerdido.marca} ${reporte.objetoPerdido.color}" .
                        </p>
                    </div>

                    <a href="Coincidencias.jsp"
                       class="botonCoincidencia">
                        Ver coincidencia →
                    </a>

                    <button type="button"
                            class="cerrarNotificacion"
                            id="cerrarNotificacion"
                            aria-label="Cerrar notificación">
                        ✕
                    </button>
</div>`;
        }
    }
    noti.innerHTML = resultado;
}
async function mostrarReportes() {
    try {
        const respuesta = await fetch("ReportesRealizadosServlet", {method: "POST"});
        if (!respuesta.ok) {
            throw new Error("Error al obtener los objetos perdidos");
        }
        const reportesUsuario = await respuesta.json();
        console.log("Este es el primero :" + reportesUsuario[0].fechaReporte);
        let resultado = "";
        for (let reporte of reportesUsuario) {
            resultado += `<article class="cuadroTarjetas reportePerdido" data-nombre="${reporte.objetoPerdido.nombre}" data-fecha="${reporte.objetoPerdido.fechaPerdida}">

                        <div class="imagenReportePerdido">
                            <img src="${reporte.objetoPerdido.imagen}"
                                 alt="${reporte.objetoPerdido.nombre}">
                        </div>

                        <div class="informacionReportePerdido">
                            <h3>${reporte.objetoPerdido.nombre}</h3>
                            <p>${reporte.objetoPerdido.categoria}</p>
                            <p>📍 ${reporte.objetoPerdido.lugarReferencia}</p>
                            <p>📅 ${reporte.objetoPerdido.fechaPerdida}</p>
                        </div>

                        <div class="estadoReporte">
                            <span class="etiquetaEstado ${cambiarClaseEstado(reporte.estado)}">
                                ${reporte.estado}
                            </span>

                            <p class="descripcionEstado">
                                ${mostrarDescripcionEstado(reporte.estado)}
                            </p>
                        </div>

                        <div class="accionesReporte">

                            <details class="detalleReportePerdido">
                                <summary>Ver detalle →</summary>

                                <div class="informacionDetalle">
                                    <p><b>Objeto:</b> ${reporte.objetoPerdido.nombre}</p>
                                    <p><b>Fecha:</b>${reporte.objetoPerdido.fechaPerdida}</p>
                                    <p><b>Lugar:</b> ${reporte.objetoPerdido.lugarReferencia}</p>
                                    <p><b>Estado:</b> ${reporte.estado}</p>
                                </div>
                            </details>

                            ${botonSegunEstado(reporte.estado, reporte.objetoPerdido.idObjeto)}

                        </div>

                    </article>`;
        }
        document.getElementById("listaReportes").innerHTML = resultado;
        iniciarObjetosPerdidos();

    } catch (error) {
        console.error("Error: ", error);
    }
}

async function descargarConstanciaWord() {

    const formulario = document.getElementById("formReclamo");

    const datos = new FormData(formulario);

    const respuesta = await fetch("CreacionConstanciaWord", {
        method: "POST",
        body: datos
    });

    if (!respuesta.ok) {
        throw new Error("No se pudo generar la constancia");
    }

    const archivo = await respuesta.blob();

    const url = URL.createObjectURL(archivo);

    const enlace = document.createElement("a");
    enlace.href = url;
    enlace.download = "Constancia_LostFind.docx";
    enlace.click();

    URL.revokeObjectURL(url);
}

async function crearBotonesEnDetalle(objetoEncontrado) {
    const datos = new URLSearchParams();

    datos.append("objetoPerdido", JSON.stringify(objetoEncontrado));

    await fetch("GuardarObjetoServlet", {
        method: "POST",
        body: datos
    });

    document.getElementById("botonesDetalles").innerHTML = `
                                <button type="submit" class="btn" onclick="descargarConstanciaWord()">
                                    Enviar solicitud de reclamo →
                                </button>
`;
}

function mostrarDescripcionEstado(estado) {
    if (estado === "🕒 En búsqueda") {
        return "Tu reporte está activo. Te notificaremos si hay coincidencias.";
    } else if (estado === "⛔ Cerrado") {
        return "El reporte fue cerrado.";
    } else if (estado === "✅ Coincidencia encontrada") {
        return "Se encontró un objeto que coincide con tu descripción.";
    } else {
        return "El reporte fue cancelado.";
    }
}

function cambiarClaseEstado(estado) {
    if (estado === "🕒 En búsqueda") {
        return "enBusqueda";
    } else if (estado === "⛔ Cerrado") {
        return "reporteCerrado";
    } else if (estado === "✅ Coincidencia encontrada") {
        return "coincidenciaEncontrada";
    } else {
        return "reporteCancelado";
    }
}

function botonSegunEstado(estado, idObjeto) {
    if (estado === "🕒 En búsqueda") {
        return `<button type="button"
                                    class="botonCancelarReporte"
                                    data-cancelar data-id-objeto-perdido="${idObjeto}">
                                🚫 Cancelar reporte
                            </button>`;
    } else if (estado === "⛔ Cerrado" || estado === "🚫 Cancelado") {
        return "";
    } else {
        return `<button type="button" 
                               class="botonVerCoincidencia" onclick="botonVerCoincidencias(this)" data-id-objeto-perdido="${idObjeto}">
                                💬 Ver coincidencia
                            </button>`;
    }
}
const botonNotificaciones = document.getElementById("botonNotificaciones");
const menuNotificaciones = document.getElementById("menuNotificaciones");
const menuUsuario = document.getElementById("menuUsuario");
botonNotificaciones.addEventListener("click", function () {
    menuNotificaciones.hidden = !menuNotificaciones.hidden;
    menuUsuario.hidden = true;
});