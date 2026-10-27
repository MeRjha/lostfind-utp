<%@page import="Objetos.Usuario"%>
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
                        <li><a href="ReportarObjeto.jsp">Buscar objeto</a></li>
                    </ul>
                </nav>

                <div class="contenedorUsuario">
                    <button class="botonUsuario" id="botonUsuario" type="button"
                            aria-label="Menú del usuario" aria-expanded="false">

                        <%
                            Usuario usuario = (Usuario) session.getAttribute("usuario");
                            String perfil = "Imagenes/fotoUsuario.jpg";
                            if (usuario!=null) {
                                perfil=usuario.getFotoPerfil();
                            }
                        %>
                        <img class="fotoUsuario"
                             src="<%=perfil%>"
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

            <div id="InfoUsuario" data-usuario='${sessionScope.usuarioJson}' >
                <div id="vistaPerfil">

                </div>
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

        <script src="script.js"></script>
        <script>mostrarReportes();</script>
    </body>
</html>
