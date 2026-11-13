<%@page import="Objetos.Usuario, Objetos.SolicitudReclamo, java.util.List, java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private static String esc(Object o) {
        if (o == null) return "";
        return o.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
    private static String etiqueta(String estado) {
        String e = estado == null ? "" : estado.toUpperCase();
        String texto = "PENDIENTE".equals(e) ? "Pendiente" : "APROBADO".equals(e) ? "Aprobado"
                : "RECHAZADO".equals(e) ? "Rechazado" : esc(estado);
        return "<span class=\"saeEstado " + e.toLowerCase() + "\">" + texto + "</span>";
    }
    private static String param(jakarta.servlet.http.HttpServletRequest r, String n) {
        String v = r.getParameter(n);
        return v == null ? "" : v.trim();
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Gestión de reclamos</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="stylesheet" href="sae.css">
        <link rel="stylesheet" href="efectos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>
    <body class="paginaSAE" data-pagina="reclamos">

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
            // Esta pantalla se alimenta del servlet: si se abre directo, se redirige.
            List<SolicitudReclamo> solicitudes = (List<SolicitudReclamo>) request.getAttribute("solicitudes");
            if (solicitudes == null) {
                response.sendRedirect("GestionSolicitudesServlet");
                return;
            }
            SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
            String fBusqueda = param(request, "busqueda");
            String fEstado = param(request, "estado");
            String fCategoria = param(request, "categoria");
            String fFecha = param(request, "fecha");
            String[] categorias = {"Tecnología", "Documentos", "Accesorios", "Mochilas", "Ropa", "Otros"};
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
                        <li><a href="ObjetosSAE.jsp">Objetos</a></li>
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

                <section class="saeEncabezado">
                    <div class="saeTitulo">
                        <span class="saeIcono">📋</span>
                        <div>
                            <h1>Gestión de reclamos</h1>
                            <p>Revisa las solicitudes de los estudiantes y valida la devolución de cada objeto.</p>
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

                <section class="cuadroTarjetas">
                    <form class="saeFiltros" method="get" action="GestionSolicitudesServlet">
                        <input type="search" name="busqueda" value="<%=esc(fBusqueda)%>"
                               placeholder="🔍 Buscar por N.º, objeto o estudiante..." aria-label="Buscar reclamos">
                        <select name="estado" aria-label="Filtrar por estado">
                            <option value="">Todos los estados</option>
                            <option value="PENDIENTE"<%= "PENDIENTE".equals(fEstado) ? " selected" : "" %>>Pendiente</option>
                            <option value="APROBADO"<%= "APROBADO".equals(fEstado) ? " selected" : "" %>>Aprobado</option>
                            <option value="RECHAZADO"<%= "RECHAZADO".equals(fEstado) ? " selected" : "" %>>Rechazado</option>
                        </select>
                        <select name="categoria" aria-label="Filtrar por categoría">
                            <option value="">Todas las categorías</option>
                            <% for (String c : categorias) { %>
                            <option value="<%=esc(c)%>"<%= c.equals(fCategoria) ? " selected" : "" %>><%=esc(c)%></option>
                            <% } %>
                        </select>
                        <input type="date" name="fecha" value="<%=esc(fFecha)%>" aria-label="Fecha de solicitud">
                        <button type="submit" class="saeBtn saeBtnChico">Filtrar</button>
                        <a class="saeBtn saeBtnClaro saeBtnChico" href="GestionSolicitudesServlet">Limpiar</a>
                        <span class="saeContador"><%=solicitudes.size()%> <%= solicitudes.size() == 1 ? "solicitud" : "solicitudes" %></span>
                    </form>
                </section>

                <section class="cuadroTarjetas saeTablaCaja">
                    <table class="saeTabla">
                        <thead>
                            <tr>
                                <th>Objeto</th>
                                <th>Estudiante</th>
                                <th>Fecha de solicitud</th>
                                <th>Estado</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (solicitudes.isEmpty()) { %>
                            <tr><td colspan="5" class="saeVacio">No hay solicitudes con esos filtros</td></tr>
                            <% } for (SolicitudReclamo r : solicitudes) { %>
                            <tr>
                                <td><div class="saeCeldaObjeto"><img class="saeThumb" src="<%=esc(r.getImagen())%>" alt="">
                                        <strong><%=esc(r.getNombreObjeto())%></strong></div></td>
                                <td><%=esc(r.getNombreEstudiante())%> <%=esc(r.getApellidoEstudiante())%></td>
                                <td><%= r.getFechaSolicitud() == null ? "-" : fmt.format(r.getFechaSolicitud()) %></td>
                                <td><%= etiqueta(r.getEstado()) %></td>
                                <td><a class="saeBtn saeBtnChico" href="GestionSolicitudesServlet?idSolicitud=<%=r.getIdSolicitud()%>">Revisar</a></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
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