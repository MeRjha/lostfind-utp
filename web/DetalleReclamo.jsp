<%@page import="Objetos.Usuario, Objetos.SolicitudReclamo, Objetos.EvidenciaReclamo, java.util.List, java.text.SimpleDateFormat"%>
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
            if (usuario == null || !"PersonalSae".equals(usuario.getRol())) {
                response.sendRedirect("Inicio.jsp");
                return;
            }
            // Esta pantalla se alimenta del servlet: si se abre directo, se redirige.
            SolicitudReclamo sol = (SolicitudReclamo) request.getAttribute("solicitudSeleccionada");
            if (sol == null) {
                response.sendRedirect("GestionSolicitudesServlet");
                return;
            }
            List<EvidenciaReclamo> evidencias = (List<EvidenciaReclamo>) request.getAttribute("evidencias");
            String csrf = (String) request.getAttribute("csrfTokenSAE");
            boolean pendiente = "PENDIENTE".equalsIgnoreCase(sol.getEstado());
            SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
            String fechaSol = sol.getFechaSolicitud() == null ? "-" : fmt.format(sol.getFechaSolicitud());
            String nombreEst = (sol.getNombreEstudiante() == null ? "" : sol.getNombreEstudiante()) + " "
                    + (sol.getApellidoEstudiante() == null ? "" : sol.getApellidoEstudiante());
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

                <a class="saeVolver" href="GestionSolicitudesServlet">← Volver a reclamos</a>

                <section class="saeEncabezado">
                    <div class="saeTitulo">
                        <span class="saeIcono">🔎</span>
                        <div>
                            <h1>Solicitud de reclamo #<%=sol.getIdSolicitud()%></h1>
                            <p>Revisa el sustento y las evidencias antes de aprobar o rechazar la devolución.</p>
                        </div>
                    </div>
                    <div><%= etiqueta(sol.getEstado()) %></div>
                </section>

                <section class="saeDos">

                    <div class="saeColumna">
                        <article class="cuadroTarjetas">
                            <h2 class="saeSubtitulo">Datos de la solicitud</h2>
                            <dl class="saeDatos">
                                <div><dt>Estudiante</dt><dd><%=esc(nombreEst.trim())%></dd></div>
                                <div><dt>Correo</dt><dd><%=esc(sol.getCorreoInstitucional())%></dd></div>
                                <div><dt>Sede del estudiante</dt><dd><%= sol.getSedeEstudiante() == null ? "-" : esc(sol.getSedeEstudiante()) %></dd></div>
                                <div><dt>Fecha de solicitud</dt><dd><%=fechaSol%></dd></div>
                            </dl>
                            <h3 class="saeMini">Sustento de propiedad</h3>
                            <p class="saeSustento"><%=esc(sol.getSustentoPropiedad())%></p>
                            <h3 class="saeMini">Evidencias adjuntas</h3>
                            <div class="saeEvidencias">
                                <% if (evidencias == null || evidencias.isEmpty()) { %>
                                <p class="saeVacio">El estudiante no adjuntó evidencias.</p>
                                <% } else { for (EvidenciaReclamo ev : evidencias) { %>
                                <a href="<%=esc(ev.getUrlArchivo())%>" target="_blank" rel="noopener"><img src="<%=esc(ev.getUrlArchivo())%>" alt="Evidencia"></a>
                                <% } } %>
                            </div>
                        </article>

                        <article class="cuadroTarjetas">
                            <h2 class="saeSubtitulo">Historial del proceso</h2>
                            <ul class="saeTimeline">
                                <li><b><%=fechaSol%></b><span>El estudiante envió la solicitud de reclamo.</span></li>
                                <% if (!pendiente) { %>
                                <li><b>Resuelta</b><span>El SAE <%= "APROBADO".equalsIgnoreCase(sol.getEstado()) ? "aprobó" : "rechazó" %> la solicitud.<%= sol.getMotivoRechazo() == null ? "" : " Motivo: " + esc(sol.getMotivoRechazo()) %></span></li>
                                <% } %>
                            </ul>
                        </article>
                    </div>

                    <div class="saeColumna">
                        <article class="cuadroTarjetas">
                            <h2 class="saeSubtitulo">Objeto registrado</h2>
                            <img class="saeFotoObjeto" src="<%=esc(sol.getImagen())%>" alt="Foto del objeto">
                            <dl class="saeDatos">
                                <div><dt>Objeto</dt><dd><%=esc(sol.getNombreObjeto())%></dd></div>
                                <div><dt>Categoría</dt><dd><%=esc(sol.getCategoria())%></dd></div>
                                <div><dt>Sede donde se encuentra</dt><dd><%= sol.getSedeObjeto() == null ? "-" : esc(sol.getSedeObjeto()) %></dd></div>
                            </dl>
                        </article>

                        <article class="cuadroTarjetas saeDecision">
                            <h2 class="saeSubtitulo">Decisión del SAE</h2>
                            <form id="formDecision" method="post" action="GestionSolicitudesServlet">
                                <input type="hidden" name="csrfToken" value="<%=esc(csrf)%>">
                                <input type="hidden" name="idSolicitud" value="<%=sol.getIdSolicitud()%>">
                                <label for="motivoRechazo">Motivo (obligatorio si rechazas)</label>
                                <textarea id="motivoRechazo" name="motivoRechazo" rows="3" maxlength="500"<%= pendiente ? "" : " disabled" %>
                                          placeholder="Ej. Las características no coinciden con el objeto registrado."><%= pendiente ? "" : esc(sol.getMotivoRechazo()) %></textarea>
                                <div class="saeBotones">
                                    <button type="submit" name="accion" value="aprobar" class="saeBtn saeBtnVerde"<%= pendiente ? "" : " disabled" %>>✔ Aprobar</button>
                                    <button type="submit" name="accion" value="rechazar" class="saeBtn saeBtnRojo"<%= pendiente ? "" : " disabled" %>>✖ Rechazar</button>
                                    <a class="saeBtn saeBtnClaro" href="mailto:<%=esc(sol.getCorreoInstitucional())%>?subject=Reclamo%20LostFind%20%23<%=sol.getIdSolicitud()%>">✉ Contactar</a>
                                </div>
                            </form>
                            <% if (!pendiente) { %>
                            <p class="saeNota">Esta solicitud ya fue resuelta y no puede modificarse.</p>
                            <% } %>
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