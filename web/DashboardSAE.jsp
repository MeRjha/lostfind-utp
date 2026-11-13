<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Panel del SAE</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="stylesheet" href="sae.css">
        <link rel="stylesheet" href="efectos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>
    <body class="paginaSAE" data-pagina="dashboard">

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
                        <li><a href="DashboardSAE.jsp" class="activo">Inicio</a></li>
                        <li><a href="RegistrarEncontrado.jsp">Registrar objeto</a></li>
                        <li><a href="GestionSolicitudesServlet">Reclamos</a></li>
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

                <section class="saeEncabezado">
                    <div class="saeTitulo">
                        <span class="saeIcono">📊</span>
                        <div>
                            <h1>Panel del SAE</h1>
                            <p>Administra los objetos encontrados, las solicitudes de reclamo y el seguimiento general del sistema LostFind.</p>
                        </div>
                    </div>
                    <div class="saeAdmin">
                        <span>🛡️</span>
                        <div>
                            <strong>Acceso administrativo</strong>
                            <p><%=sede%></p>
                        </div>
                    </div>
                </section>

                <div class="saeAviso" id="saeAviso" hidden>
                    Mostrando datos de ejemplo: el servicio aún no está conectado.
                </div>

                <section class="saeGrid4">
                    <article class="cuadroTarjetas saeStat">
                        <span class="saeStatIcono">📦</span>
                        <div><b id="statCustodia">–</b><p>Objetos bajo custodia</p></div>
                    </article>
                    <article class="cuadroTarjetas saeStat">
                        <span class="saeStatIcono">⏳</span>
                        <div><b id="statPendientes">–</b><p>Solicitudes pendientes</p></div>
                    </article>
                    <article class="cuadroTarjetas saeStat">
                        <span class="saeStatIcono">🔗</span>
                        <div><b id="statCoincidencias">–</b><p>Coincidencias generadas</p></div>
                    </article>
                    <article class="cuadroTarjetas saeStat">
                        <span class="saeStatIcono">✅</span>
                        <div><b id="statEntregados">–</b><p>Objetos entregados</p></div>
                    </article>
                </section>

                <section class="saeDos">
                    <article class="cuadroTarjetas">
                        <div class="dashCabecera">
                            <h2 class="saeSubtitulo">Objetos recientes bajo custodia</h2>
                            <a class="dashVer" href="ObjetosEncontrados.jsp">Ver todos ➡</a>
                        </div>
                        <ul class="saeLista" id="listaRecientes"></ul>
                    </article>
                    <article class="cuadroTarjetas">
                        <div class="dashCabecera">
                            <h2 class="saeSubtitulo">Actividad reciente</h2>
                        </div>
                        <ul class="saeTimeline" id="actividad"></ul>
                    </article>
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
