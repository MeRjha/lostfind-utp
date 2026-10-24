<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Objetos perdidos</title>
        <link rel="stylesheet" href="estilos.css?v=6">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>

    <body class="paginaPerdidos">

        <header class="header">
            <div class="contenedor barraCoincidencias">

                <div class="logoContenedor">
                    <img class="logo" src="Imagenes/utpLogo.png" alt="Logo UTP">

                    <div class="tituloLogo">
                        <h1>Lost Find</h1>
                        <p>Universidad Tecnológica del Perú</p>
                    </div>
                </div>

                <nav class="nav">
                    <ul class="nav-list">
                        <li><a href="Estudiante.jsp">Inicio</a></li>
                        <li><a href="ObjetosEncontrados.jsp">Objetos encontrados</a></li>
                        <li><a href="ObjetosPerdidos.jsp" class="activo">Objetos perdidos</a></li>
                        <li><a href="Coincidencias.jsp">Buscar objeto</a></li>
                    </ul>
                </nav>

                <div class="contenedorUsuario">
                    <button class="botonUsuario" id="botonUsuario" type="button"
                            aria-label="Menú del usuario" aria-expanded="false">

                        <img class="fotoUsuario"
                             src="Imagenes/fotoUsuario.jpg"
                             alt="Foto del usuario">
                    </button>

                    <div class="menuUsuario" id="menuUsuario" hidden>
                        <button type="button" id="verPerfil">👤 Mi perfil</button>
                        <button type="button" id="verConfiguracion">⚙️ Configuración</button>
                        <hr>
                        <button type="button" id="cerrarSesion">🚪 Cerrar sesión</button>
                    </div>
                </div>

            </div>
        </header>

        <main>
            <div class="contenedorDashboard contenidoPerdidos">

                <section class="encabezadoPerdidos">

                    <div class="tituloPerdidos">
                        <span class="iconoTituloPerdidos">📄</span>

                        <div>
                            <h1>Objetos perdidos</h1>
                            <p>
                                Revisa tus reportes de objetos perdidos.
                                Puedes ver su estado y más detalles en cualquier momento.
                            </p>
                        </div>
                    </div>

                    <div class="avisoPerdidos">
                        <span>🛡️</span>

                        <div>
                            <h3>¿Encontraste tu objeto?</h3>
                            <p>
                                Revisa el detalle de tu reporte y las
                                coincidencias asociadas.
                            </p>
                        </div>
                    </div>

                </section>

                <div class="opcionesPerdidos">

                    <a href="ObjetosPerdidos.jsp" class="opcionActiva">
                        Mis reportes
                    </a>

                    <a href="ReportarObjeto.jsp">
                        Reportar nuevo objeto
                    </a>

                </div>

                <form class="cuadroTarjetas buscadorPerdidos"
                      id="formBuscarReportes">

                    <input type="search"
                           id="buscarReportes"
                           placeholder="🔍 Buscar en mis reportes..."
                           aria-label="Buscar en mis reportes">

                    <button class="btn" type="submit">
                        Buscar
                    </button>

                </form>

                <div class="notificacionPerdidos" id="notificacionPerdidos">

                    <span class="iconoNotificacion">✅</span>

                    <div class="textoNotificacion">
                        <h3>¡Nueva coincidencia encontrada!</h3>
                        <p>
                            Encontramos un objeto similar a tu reporte de
                            "Audífonos Sony celestes".
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

                </div>

                <div class="barraReportes">
                    <p id="cantidadReportes">Mis reportes</p>

                    <div class="ordenarReportes">
                        <label for="ordenReportes">Ordenar por:</label>

                        <select id="ordenReportes">
                            <option value="recientes">Más recientes</option>
                            <option value="antiguos">Más antiguos</option>
                        </select>
                    </div>
                </div>

                <section class="listaReportes" id="listaReportes">

                    <article class="cuadroTarjetas reportePerdido"
                             data-nombre="Mochila negra"
                             data-fecha="2026-09-14">

                        <div class="imagenReportePerdido">
                            <img src="Imagenes/mochila.jfif"
                                 alt="Mochila negra">
                        </div>

                        <div class="informacionReportePerdido">
                            <h3>Mochila negra</h3>
                            <p>🏷️ Mochilas</p>
                            <p>📍 Aula A-207</p>
                            <p>📅 14 sep 2026</p>
                        </div>

                        <div class="estadoReporte">
                            <span class="etiquetaEstado enBusqueda">
                                🕒 En búsqueda
                            </span>

                            <p class="descripcionEstado">
                                Tu reporte está activo. Te notificaremos si hay coincidencias.
                            </p>
                        </div>

                        <div class="accionesReporte">

                            <details class="detalleReportePerdido">
                                <summary>Ver detalle →</summary>

                                <div class="informacionDetalle">
                                    <p><b>Objeto:</b> Mochila negra</p>
                                    <p><b>Fecha:</b> 14 sep 2026</p>
                                    <p><b>Lugar:</b> Aula A-207</p>
                                    <p><b>Estado:</b> En búsqueda</p>
                                </div>
                            </details>

                            <button type="button"
                                    class="botonCancelarReporte"
                                    data-cancelar>
                                🚫 Cancelar reporte
                            </button>

                        </div>

                    </article>

                    <article class="cuadroTarjetas reportePerdido"
                             data-nombre="iPhone 13"
                             data-fecha="2026-09-13">

                        <div class="imagenReportePerdido">
                            <img src="Imagenes/iphone.jpg"
                                 alt="iPhone 13">
                        </div>

                        <div class="informacionReportePerdido">
                            <h3>iPhone 13</h3>
                            <p>🏷️ Celulares</p>
                            <p>📍 Cafetería central</p>
                            <p>📅 13 sep 2026</p>
                        </div>

                        <div class="estadoReporte">
                            <span class="etiquetaEstado coincidenciaEncontrada">
                                ✅ Coincidencia encontrada
                            </span>

                            <p class="descripcionEstado">
                                Se encontró un objeto que coincide con tu descripción.
                            </p>
                        </div>

                        <div class="accionesReporte">

                            <details class="detalleReportePerdido">
                                <summary>Ver detalle →</summary>

                                <div class="informacionDetalle">
                                    <p><b>Objeto:</b> iPhone 13</p>
                                    <p><b>Fecha:</b> 13 sep 2026</p>
                                    <p><b>Lugar:</b> Cafetería central</p>
                                    <p><b>Estado:</b> Coincidencia encontrada</p>
                                </div>
                            </details>

                            <a href="Coincidencias.jsp"
                               class="botonVerCoincidencia">
                                💬 Ver coincidencia
                            </a>

                        </div>

                    </article>

                    <article class="cuadroTarjetas reportePerdido"
                             data-nombre="Lentes con montura negra"
                             data-fecha="2026-09-10">

                        <div class="imagenReportePerdido">
                            <img src="Imagenes/lentes.jpg"
                                 alt="Lentes con montura negra">
                        </div>

                        <div class="informacionReportePerdido">
                            <h3>Lentes con montura negra</h3>
                            <p>🏷️ Accesorios</p>
                            <p>📍 Biblioteca - piso 4</p>
                            <p>📅 10 sep 2026</p>
                        </div>

                        <div class="estadoReporte">
                            <span class="etiquetaEstado reporteCerrado">
                                ⛔ Cerrado
                            </span>

                            <p class="descripcionEstado">
                                El reporte fue cerrado.
                            </p>
                        </div>

                        <div class="accionesReporte">

                            <details class="detalleReportePerdido">
                                <summary>Ver detalle →</summary>

                                <div class="informacionDetalle">
                                    <p><b>Objeto:</b> Lentes con montura negra</p>
                                    <p><b>Fecha:</b> 10 sep 2026</p>
                                    <p><b>Lugar:</b> Biblioteca - piso 4</p>
                                    <p><b>Estado:</b> Cerrado</p>
                                </div>
                            </details>

                        </div>

                    </article>

                    <article class="cuadroTarjetas reportePerdido"
                             data-nombre="Gorra negra"
                             data-fecha="2026-09-09">

                        <div class="imagenReportePerdido">
                            <img src="Imagenes/gorra.jpg"
                                 alt="Gorra negra">
                        </div>

                        <div class="informacionReportePerdido">
                            <h3>Gorra negra</h3>
                            <p>🏷️ Accesorios</p>
                            <p>📍 Zona deportiva</p>
                            <p>📅 9 sep 2026</p>
                        </div>

                        <div class="estadoReporte">
                            <span class="etiquetaEstado enBusqueda">
                                🕒 En búsqueda
                            </span>

                            <p class="descripcionEstado">
                                Tu reporte está activo. Te notificaremos si hay coincidencias.
                            </p>
                        </div>

                        <div class="accionesReporte">

                            <details class="detalleReportePerdido">
                                <summary>Ver detalle →</summary>

                                <div class="informacionDetalle">
                                    <p><b>Objeto:</b> Gorra negra</p>
                                    <p><b>Fecha:</b> 9 sep 2026</p>
                                    <p><b>Lugar:</b> Zona deportiva</p>
                                    <p><b>Estado:</b> En búsqueda</p>
                                </div>
                            </details>

                            <button type="button"
                                    class="botonCancelarReporte"
                                    data-cancelar>
                                🚫 Cancelar reporte
                            </button>

                        </div>

                    </article>

                </section>

                <p class="sinReportes" id="sinReportes" hidden>
                    🔎 No se encontraron reportes con ese nombre.
                </p>

            </div>
        </main>

        <footer class="footer">
            <div class="contenedor footer-contenedor">

                <div>
                    <a href="#">
                        📞 SAE - Servicio de Atención al Estudiante
                    </a>
                </div>

                <div>
                    <p>
                        Política de privacidad | Términos y condiciones |
                        &copy; 2026 UTP
                    </p>
                </div>

            </div>
        </footer>

        <dialog class="modalUsuario" id="modalUsuario">

            <div class="tituloModal">
                <h2 id="tituloModal">Mi perfil</h2>

                <button type="button" id="cerrarModal"
                        aria-label="Cerrar">
                    ✕
                </button>
            </div>

            <div id="vistaPerfil">

                <div class="datosPerfil">

                    <img src="Imagenes/fotoUsuario.jpg"
                         alt="Foto de perfil">

                    <h3 class="nombreUsuario">Nombre del usuario</h3>
                    <p>correo@utp.edu.pe</p>

                    <span class="badge">Estudiante UTP</span>
                </div>

                <h3 class="subtituloModal">Información personal</h3>

                <div class="informacionPersonal">
                    <p><b>Nombre:</b> <span class="nombreUsuario">Nombre del usuario</span></p>
                    <p><b>Correo:</b> correo@utp.edu.pe</p>
                    <p><b>Código:</b> Pendiente</p>
                    <p><b>Sede:</b> Pendiente</p>
                    <p><b>Tipo:</b> Estudiante UTP</p>
                </div>

                <h3 class="subtituloModal">Mi actividad</h3>

                <div class="actividadPerfil">
                    <div class="cuadroTarjetas">📝 Mis reportes: —</div>
                    <div class="cuadroTarjetas">🔎 Coincidencias: —</div>
                    <div class="cuadroTarjetas">💬 Mis reclamos: —</div>
                    <div class="cuadroTarjetas">📦 Recuperados: —</div>
                </div>

                <button type="button" class="btn" id="editarPerfil">
                    ⚙️ Configuración
                </button>

            </div>

            <div id="vistaConfiguracion" hidden>

                <div class="cuadroAjustes">

                    <div class="tituloAjustes">
                        <span class="iconoAjustes">🔔</span>

                        <div>
                            <h3>Notificaciones</h3>
                            <p>Elige qué notificaciones deseas recibir.</p>
                        </div>
                    </div>

                    <label class="opcionNotificacion">
                        <span>Nuevas coincidencias de mis objetos</span>

                        <input type="checkbox"
                               class="interruptor"
                               id="avisosCoincidencias"
                               checked>
                    </label>

                    <label class="opcionNotificacion">
                        <span>Nuevos objetos encontrados en mi campus</span>

                        <input type="checkbox"
                               class="interruptor"
                               id="avisosObjetos">
                    </label>

                </div>

                <div class="cuadroAjustes">

                    <div class="tituloAjustes">
                        <span class="iconoAjustes">🎨</span>

                        <div>
                            <h3>Tema</h3>
                            <p>Selecciona el tema de la aplicación.</p>
                        </div>
                    </div>

                    <div class="opcionesTema">

                        <label>
                            <input type="radio"
                                   name="tema"
                                   value="claro"
                                   checked>
                            Claro
                        </label>

                        <label>
                            <input type="radio"
                                   name="tema"
                                   value="oscuro">
                            Oscuro
                        </label>

                    </div>

                </div>

            </div>

        </dialog>

        <script src="script.js" defer></script>

    </body>
</html>
