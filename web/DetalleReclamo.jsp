<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Detalle del reclamo</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="stylesheet" href="efectos.css">
        <link rel="stylesheet" href="sae.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>
    <body class="paginaSAE" data-pagina="detalle">

        <%
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            String perfil = "Imagenes/fotoUsuario.jpg";
            String nombre = "Personal SAE";
            String rol = "Personal SAE";
            String sede = "UTP Lima Sur";
            if (usuario != null) {
                perfil = usuario.getFotoPerfil();
                nombre = usuario.getNombre();
                if (!"PersonalSae".equals(usuario.getRol())) {
                    rol = usuario.getRol();
                }
                if (usuario.getSede() != null) {
                    sede = usuario.getSede().getNombre();
                }
            }
            // TODO (backend): activar el control de acceso por rol
            if (usuario == null || !"PersonalSae".equals(usuario.getRol())) {
            response.sendRedirect("Inicio.jsp");
            return;
            }
        %>
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
                        <li><a href="DashboardSAE.jsp">Inicio</a></li>
                        <li><a href="RegistrarEncontrado.jsp">Registrar objeto</a></li>
                        <li><a href="GestionReclamos.jsp" class="activo">Reclamos</a></li>
                        <li><a href="ReportesSAE.jsp">Reportes</a></li>
                    </ul>
                </nav>

                <div class="contenedorUsuario">
                    <div class="nombreRol">
                        <span>Hola, <b><%=nombre%></b></span>
                        <p><%=rol%> UTP</p>
                    </div>
                    <button class="botonUsuario" id="botonUsuario" type="button"
                            aria-label="Menú del usuario" aria-expanded="false">
                        <img class="fotoUsuario" src="<%=perfil%>" alt="Foto del usuario">
                    </button>
                    <div class="menuUsuario" id="menuUsuario" hidden>
                        <button type="button" id="cerrarSesion">🚪 Cerrar sesión</button>
                    </div>
                </div>

            </div>
        </header>

        <main>
            <div class="contenedorDashboard saeContenido">

                <a class="saeVolver" href="GestionReclamos.jsp">← Volver a reclamos</a>

                <section class="saeEncabezado">
                    <div class="saeTitulo">
                        <span class="saeIcono">🔎</span>
                        <div>
                            <h1>Solicitud de reclamo <span id="detNumero"></span></h1>
                            <p>Revisa el sustento y las evidencias antes de aprobar o rechazar la devolución.</p>
                        </div>
                    </div>
                    <div id="detEstado"></div>
                </section>

                <div class="saeAviso" id="saeAviso" hidden>
                    Mostrando datos de ejemplo: el servicio aún no está conectado.
                </div>

                <section class="saeDos">

                    <div class="saeColumna">
                        <article class="cuadroTarjetas">
                            <h2 class="saeSubtitulo">Datos de la solicitud</h2>
                            <dl class="saeDatos" id="detSolicitud"></dl>
                            <h3 class="saeMini">Sustento de propiedad</h3>
                            <p class="saeSustento" id="detSustento"></p>
                            <h3 class="saeMini">Evidencias adjuntas</h3>
                            <div class="saeEvidencias" id="detEvidencias"></div>
                        </article>

                        <article class="cuadroTarjetas">
                            <h2 class="saeSubtitulo">Historial del proceso</h2>
                            <ul class="saeTimeline" id="detHistorial"></ul>
                        </article>
                    </div>

                    <div class="saeColumna">
                        <article class="cuadroTarjetas">
                            <h2 class="saeSubtitulo">Objeto registrado</h2>
                            <img class="saeFotoObjeto" id="detFoto" src="Imagenes/LostFind.png" alt="Foto del objeto">
                            <dl class="saeDatos" id="detObjeto"></dl>
                        </article>

                        <article class="cuadroTarjetas saeDecision">
                            <h2 class="saeSubtitulo">Decisión del SAE</h2>
                            <label for="comentario">Comentario (obligatorio si rechazas)</label>
                            <textarea id="comentario" rows="3" maxlength="255"
                                      placeholder="Ej. Las características no coinciden con el objeto registrado."></textarea>
                            <div class="saeBotones">
                                <button type="button" class="saeBtn saeBtnVerde" id="btnAprobar">✔ Aprobar</button>
                                <button type="button" class="saeBtn saeBtnRojo" id="btnRechazar">✖ Rechazar</button>
                                <a class="saeBtn saeBtnClaro" id="btnContactar" href="#">✉ Contactar</a>
                            </div>
                            <p class="saeNota" id="notaDecision" hidden></p>
                        </article>
                    </div>

                </section>

            </div>
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

        <div class="saeToast" id="saeToast" role="status" hidden></div>
        <script src="sae.js" defer></script>
        <script src="iconos.js" defer></script>
    </body>
</html>