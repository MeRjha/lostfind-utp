<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Coincidencias encontradas</title>
        <link rel="stylesheet" href="estilos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    </head>

    <body class="paginaCoincidencias">

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
                        <li><a href="ObjetosPerdidos.jsp">Objetos perdidos</a></li>
                        <li><a href="ReportarObjeto.jsp" class="activo">Buscar objeto</a></li>
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
            <section class="seccionCoincidencias">
                <div class="contenedorDashboard">

                    <div class="volverInicio">
                        <a href="Estudiante.jsp" class="botonVolver">
                            ← Volver al inicio
                        </a>
                    </div>

                    <div class="cabeceraCoincidencias">
                        <div class="iconoTituloCoincidencias">🔎</div>

                        <div>
                            <h1>Coincidencias encontradas</h1>
                            <p>El sistema identificó posibles coincidencias para tu reporte registrado.</p>
                            <p>Revisa los resultados y selecciona el objeto que más se parezca al tuyo.</p>
                        </div>
                    </div>

                    <div id="tuObjetoPerdido" class="tarjetaReporteCoincidencia">



                    </div>

                    <hr class="lineaSeparadora">

                    <div class="tituloResultadosCoincidencia">
                        <h2>Resultados de coincidencia</h2>
                        <p>Estos objetos fueron encontrados y podrían coincidir con tu reporte.</p>
                    </div>

                    <div id="listaDeCoincidencias" class="gridCoincidencias">

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

                <button type="button" id="cerrarModal"
                        aria-label="Cerrar ventana">
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
    </body>
</html>

