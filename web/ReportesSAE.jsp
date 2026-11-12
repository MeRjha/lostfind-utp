<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Reportes estadísticos</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="stylesheet" href="sae.css">
        <link rel="stylesheet" href="efectos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>
    <body class="paginaSAE" data-pagina="reportes">

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
                        <li><a href="GestionReclamos.jsp">Reclamos</a></li>
                        <li><a href="ReportesSAE.jsp" class="activo">Reportes</a></li>
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
                        <span class="saeIcono">📈</span>
                        <div>
                            <h1>Reportes estadísticos</h1>
                            <p>Indicadores de objetos, reclamos y coincidencias de la sede <%=sede%>.</p>
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

                <section class="cuadroTarjetas saeFiltros">
                    <select id="fPeriodo" aria-label="Periodo">
                        <option value="30">Últimos 30 días</option>
                        <option value="7">Últimos 7 días</option>
                        <option value="90">Últimos 3 meses</option>
                        <option value="0">Todo el tiempo</option>
                    </select>
                    <select id="fCategoria" aria-label="Categoría">
                        <option value="">Todas las categorías</option>
                        <option>Tecnologia</option>
                        <option>Accesorios</option>
                        <option>Ropa</option>
                        <option>Documentos</option>
                        <option>Otros</option>
                    </select>
                    <select id="fEstado" aria-label="Estado">
                        <option value="">Todos los estados</option>
                        <option value="PENDIENTE">Reclamo pendiente</option>
                        <option value="APROBADO">Reclamo aprobado</option>
                        <option value="RECHAZADO">Reclamo rechazado</option>
                    </select>
                    <button type="button" class="saeBtn" id="btnAplicar">Aplicar filtros</button>
                </section>

                <section class="saeGrid3" id="indicadores"></section>

                <section class="saeDos">
                    <article class="cuadroTarjetas">
                        <h2 class="saeSubtitulo">Objetos por categoría</h2>
                        <div class="saeBarras" id="grafCategoria"></div>
                    </article>
                    <article class="cuadroTarjetas">
                        <h2 class="saeSubtitulo">Estado de los reclamos</h2>
                        <div class="saeDonutCaja">
                            <div class="saeDonut" id="grafDonut"></div>
                            <ul class="saeLeyenda" id="leyendaDonut"></ul>
                        </div>
                    </article>
                </section>

                <section class="saeDos">
                    <article class="cuadroTarjetas">
                        <h2 class="saeSubtitulo">Registros y entregas por mes</h2>
                        <div class="saeColumnas" id="grafMeses"></div>
                        <div class="saeLeyendaFila">
                            <span><i class="reg"></i> Registrados</span>
                            <span><i class="ent"></i> Entregados</span>
                        </div>
                    </article>
                    <article class="cuadroTarjetas">
                        <h2 class="saeSubtitulo">Actividad reciente</h2>
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
    </body>
</html>