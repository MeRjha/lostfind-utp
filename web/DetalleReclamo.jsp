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
        <link rel="stylesheet" href="sae-reclamos.css">
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
            <div class="contenedorDashboard saeContenido saeReclamos">
                <%
                    String codigoSol = "REC-" + String.format("%04d", sol.getIdSolicitud());
                    String correoEst = sol.getCorreoInstitucional() == null ? "" : sol.getCorreoInstitucional();
                    String codigoEst = correoEst.contains("@") ? correoEst.substring(0, correoEst.indexOf('@')).toUpperCase() : "-";
                    boolean aprobada = "APROBADO".equalsIgnoreCase(sol.getEstado());
                    String fechaHall = sol.getFechaHallazgo() == null ? "-" : fmt.format(sol.getFechaHallazgo());
                %>

                <section class="saeEncabezado">
                    <div class="saeTitulo">
                        <a class="saeRedondo" href="GestionSolicitudesServlet" aria-label="Volver a reclamos">←</a>
                        <div>
                            <h1>Detalle de la solicitud de reclamo</h1>
                            <p>Revisa la información enviada por el estudiante y valida si corresponde la devolución del objeto.</p>
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

                <section class="reclamoGrid">

                    <div class="saeColumna">
                        <article class="cuadroTarjetas reclamoCard">
                            <h2 class="reclamoTitulo"><span class="reclamoIco">📄</span> Información de la solicitud</h2>
                            <div class="reclamoCampos tres">
                                <div><span class="reclamoEt">Código de solicitud</span><b class="reclamoGrande"><%=codigoSol%></b></div>
                                <div><span class="reclamoEt">Fecha de solicitud</span><b>📅 <%=fechaSol%></b></div>
                                <div><span class="reclamoEt">Estado</span><span><%= etiqueta(sol.getEstado()) %></span></div>
                            </div>
                        </article>

                        <article class="cuadroTarjetas reclamoCard">
                            <h2 class="reclamoTitulo"><span class="reclamoIco">👤</span> Datos del estudiante</h2>
                            <div class="reclamoCampos tres">
                                <div><span class="reclamoEt">Nombre completo</span><b><%=esc(nombreEst.trim())%></b></div>
                                <div><span class="reclamoEt">Código de estudiante</span><b><%=esc(codigoEst)%></b></div>
                                <div><span class="reclamoEt">Correo institucional</span><b><%=esc(correoEst)%></b></div>
                                <div><span class="reclamoEt">Sede</span><b>📍 <%= sol.getSedeEstudiante() == null ? "-" : esc(sol.getSedeEstudiante()) %></b></div>
                            </div>
                        </article>

                        <article class="cuadroTarjetas reclamoCard">
                            <h2 class="reclamoTitulo"><span class="reclamoIco">📦</span> Información del objeto</h2>
                            <div class="reclamoObjeto">
                                <img src="<%=esc(sol.getImagen())%>" alt="Foto del objeto">
                                <dl class="reclamoFilas">
                                    <div><dt>Nombre del objeto</dt><dd><%=esc(sol.getNombreObjeto())%></dd></div>
                                    <div><dt>Categoría</dt><dd><%=esc(sol.getCategoria())%></dd></div>
                                    <div><dt>Color</dt><dd><%= sol.getColor() == null || sol.getColor().isEmpty() ? "-" : esc(sol.getColor()) %></dd></div>
                                    <div><dt>Marca o modelo</dt><dd><%= sol.getMarca() == null || sol.getMarca().isEmpty() ? "-" : esc(sol.getMarca()) %></dd></div>
                                    <div><dt>Fecha de hallazgo</dt><dd><%=fechaHall%></dd></div>
                                    <div><dt>Lugar de hallazgo</dt><dd><%= sol.getLugarReferencia() == null ? "-" : esc(sol.getLugarReferencia()) %></dd></div>
                                    <div><dt>Sede del objeto</dt><dd><%= sol.getSedeObjeto() == null ? "-" : esc(sol.getSedeObjeto()) %></dd></div>
                                    <div><dt>Estado actual</dt><dd><span class="reclamoPunto"></span><%= sol.getEstadoObjeto() == null ? "-" : esc(sol.getEstadoObjeto()) %></dd></div>
                                </dl>
                            </div>
                        </article>
                    </div>

                    <div class="saeColumna">
                        <article class="cuadroTarjetas reclamoCard">
                            <h2 class="reclamoTitulo"><span class="reclamoIco">💬</span> Sustento del estudiante</h2>
                            <p class="saeSustento"><%=esc(sol.getSustentoPropiedad())%></p>
                            <h3 class="reclamoSub"><span class="reclamoIco">🖼️</span> Imágenes de evidencia</h3>
                            <% if (evidencias == null || evidencias.isEmpty()) { %>
                            <p class="saeVacio">El estudiante no adjuntó evidencias.</p>
                            <% } else { %>
                            <div class="reclamoEvid">
                                <% for (EvidenciaReclamo ev : evidencias) { %>
                                <a href="<%=esc(ev.getUrlArchivo())%>" target="_blank" rel="noopener"><img src="<%=esc(ev.getUrlArchivo())%>" alt="Evidencia"></a>
                                <% } %>
                            </div>
                            <% } %>
                        </article>

                        <article class="cuadroTarjetas reclamoCard">
                            <h2 class="reclamoTitulo"><span class="reclamoIco">🕒</span> Historial de la solicitud</h2>
                            <div class="reclamoPasos">
                                <div class="reclamoPaso hecho"><b>Solicitud enviada por el estudiante</b><small><%=fechaSol%></small></div>
                                <div class="reclamoPaso <%= pendiente ? "actual" : "hecho" %>"><b>En revisión por el SAE</b></div>
                                <% if (pendiente) { %>
                                <div class="reclamoPaso"><b>Resultado de validación</b><small>Pendiente</small></div>
                                <% } else { %>
                                <div class="reclamoPaso hecho"><b>Solicitud <%= aprobada ? "aprobada" : "rechazada" %></b><%= sol.getMotivoRechazo() == null ? "" : "<small>Motivo: " + esc(sol.getMotivoRechazo()) + "</small>" %></div>
                                <% } %>
                            </div>
                        </article>

                        <article class="cuadroTarjetas reclamoCard saeDecision">
                            <h2 class="reclamoTitulo"><span class="reclamoIco">✔️</span> Acciones</h2>
                            <form id="formDecision" method="post" action="GestionSolicitudesServlet">
                                <input type="hidden" name="csrfToken" value="<%=esc(csrf)%>">
                                <input type="hidden" name="idSolicitud" value="<%=sol.getIdSolicitud()%>">
                                <label for="motivoRechazo">Motivo (obligatorio si rechazas)</label>
                                <textarea id="motivoRechazo" name="motivoRechazo" rows="3" maxlength="500"<%= pendiente ? "" : " disabled" %>
                                          placeholder="Ej. Las características no coinciden con el objeto registrado."><%= pendiente ? "" : esc(sol.getMotivoRechazo()) %></textarea>
                                <div class="reclamoAcciones">
                                    <button type="submit" name="accion" value="aprobar" class="saeBtn btnAprobar"<%= pendiente ? "" : " disabled" %>>✔ Aprobar reclamo</button>
                                    <button type="submit" name="accion" value="rechazar" class="saeBtn btnRechazar"<%= pendiente ? "" : " disabled" %>>✖ Rechazar reclamo</button>
                                    <a class="saeBtn btnContactar" href="mailto:<%=esc(correoEst)%>?subject=Reclamo%20LostFind%20<%=codigoSol%>">💬 Contactar al estudiante</a>
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