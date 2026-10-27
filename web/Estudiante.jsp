<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Estudiante</title>
        <link rel="stylesheet" href="estilos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    </head>

    <body class="paginaEstudiante">


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
                        <li><a href="Estudiante.jsp" class="activo">Inicio</a></li>
                        <li><a href="ObjetosEncontrados.jsp">Objetos encontrados</a></li>
                        <li><a href="ObjetosPerdidos.jsp">Objetos perdidos</a></li>
                        <li><a href="ReportarObjeto.jsp">Buscar objeto</a></li>
                    </ul>
                </nav>

                <%
                    Usuario usuario = (Usuario) session.getAttribute("usuario");
                    String perfil = "Imagenes/fotoUsuario.jpg";
                    String nombre = "???";
                    String rol = "???";
                    if (usuario != null) {
                        perfil = usuario.getFotoPerfil();
                        nombre = usuario.getNombre();
                        rol = usuario.getRol();
                    }

                %>
                <div class="contenedorUsuario">
                    <div class="campanita" id="botonNotificaciones"> 
                        <button type="button">🔔</button>
                    </div>
                    <div class="nombreRol" id="nombreUsuario">
                        <span>Hola, <b><%=nombre%></b></span>
                        <p><%=rol%> UTP</p>
                    </div>
                    <button class="botonUsuario" id="botonUsuario" type="button"
                            aria-label="Menú del usuario" aria-expanded="false">

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

                    <div class="menuNotificaciones" id="menuNotificaciones" hidden>
                        Proximamente
                    </div>
                </div>
            </div>
        </header>

        <main>
            <section>
                <div class="contenedorDashboard">

                    <div class="contenedorBienvenida">
                        <div class="bienvenida">
                            <h1>Bienvenido a LostFind 👋</h1>
                            <p>Consulta, reporta y encuentra tus objetos de manera rápida.</p>
                        </div>

                        <div class="cuadroJuntos">
                            <div class="ordenJuntos">
                                <span>🎓</span>
                                <p>
                                    <b>Juntos hacemos un campus más seguro</b>
                                    <br>
                                    Reporta, comparte y ayuda a otros estudiantes.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="contenedorGrid">

                        <article class="cuadroTarjetas">
                            <div class="contenidoTarjetas">
                                <div class="circuloTarjeta rojo">📝</div>
                                <div>
                                    <h3>Reportar objeto perdido</h3>
                                    <p>Registra los detalles de tu objeto para recibir ayuda de la comunidad.</p>
                                </div>
                            </div>
                            <a href="ReportarObjeto.jsp" class="btn">Reportar ahora →</a>
                        </article>

                        <article class="cuadroTarjetas">
                            <div class="contenidoTarjetas">
                                <div class="circuloTarjeta azul">🔎</div>
                                <div>
                                    <h3>Buscar objetos encontrados</h3>
                                    <p>Explora los objetos que han sido encontrados en el campus.</p>
                                </div>
                            </div>
                            <a href="ObjetosEncontrados.jsp" class="btn">Buscar ahora →</a>
                        </article>


                        <article class="cuadroTarjetas">
                            <div class="contenidoTarjetas">
                                <div class="circuloTarjeta verde">
                                    📋
                                </div>
                                <div>
                                    <h3>Mis objetos reportados</h3>
                                    <p>Consulta los objetos perdidos que reportaste y revisa su estado.</p>
                                </div>
                            </div>

                            <a href="ObjetosPerdidos.jsp" class="btn">
                                Ver mis reportes →
                            </a>
                        </article>


                    </div>

                    <hr class="lineaSeparadora">
                </div>
            </section>

            <section>
                <div class="contenedorDashboard">

                    <div class="objetosEncontrados">
                        <div>
                            <h2>Objetos encontrados recientemente</h2>
                            <p>Estos son algunos de los objetos que han sido reportados en el campus.</p>
                        </div>
                        <a href="ObjetosEncontrados.jsp" class="verObjetos">
                            Ver todos los objetos encontrados →
                        </a>
                    </div>

                    <div id="objetosRecientes" class="contenedorObjetos">



                    </div>
                </div>
            </section>
        </main>

        <footer class="footer">
            <div class="contenedor footer-contenedor">
                <div>
                    <a href="#">📞 SAE - Servicio de Atención al Estudiante</a>
                </div>
                <div>
                    <p>Política de privacidad | Términos y condiciones | &copy; 2026 UTP</p>
                </div>
            </div>
        </footer>

        <dialog class="modalUsuario" id="modalUsuario">

            <div class="tituloModal">
                <h2 id="tituloModal">Mi perfil</h2>
                <button type="button" id="cerrarModal" aria-label="Cerrar">✕</button>
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
                        <input type="checkbox" class="interruptor"
                               id="avisosCoincidencias" checked>
                    </label>

                    <label class="opcionNotificacion">
                        <span>Nuevos objetos encontrados en mi campus</span>
                        <input type="checkbox" class="interruptor"
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
                            <input type="radio" name="tema"
                                   value="claro" checked>
                            Claro
                        </label>

                        <label>
                            <input type="radio" name="tema"
                                   value="oscuro">
                            Oscuro
                        </label>

                    </div>

                </div>

            </div>

        </dialog>

        <script src="script.js"></script>
        <script>mostrarObjetosEncontradosRecientemente();</script>
    </body>
</html>
