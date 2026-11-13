<%@page import="Objetos.Usuario, Objetos.ObjetoEncontrado, ClasesDAO.ObjetosEncontradosDAO, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private static String esc(Object o) {
        if (o == null) return "";
        return o.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Objetos encontrados</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="stylesheet" href="sae.css">
        <link rel="stylesheet" href="objetos.css">
        <link rel="stylesheet" href="efectos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>
    <body class="paginaSAE" data-pagina="objetos">

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
            // Objetos encontrados de la sede del usuario, los mas recientes primero
            List<ObjetoEncontrado> objetos = new ArrayList<>();
            boolean errorDatos = false;
            if (usuario.getSede() != null) {
                List<ObjetoEncontrado> lista = new ObjetosEncontradosDAO().obtenerObjetos(usuario.getSede().getIdSede());
                if (lista == null) {
                    errorDatos = true;
                } else {
                    objetos = new ArrayList<>(lista);
                    objetos.sort((a, b) -> Integer.compare(b.getIdObjeto(), a.getIdObjeto()));
                }
            }
            SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
            String[] categorias = {"Tecnología", "Documentos", "Accesorios", "Mochilas", "Ropa", "Útiles", "Otros"};
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
                        <li><a href="ObjetosSAE.jsp" class="activo">Objetos</a></li>
                        <li><a href="GestionSolicitudesServlet">Reclamos</a></li>
                        <li><a href="ReportesSAE.jsp">Reportes</a></li>
                    </ul>
                </nav>

                <div class="contenedorUsuario">
                    <div class="nombreRol">
                        <span>Hola, <b><%=esc(nombre)%></b></span>
                        <p><%=esc(rol)%> UTP</p>
                    </div>
                    <button class="botonUsuario" id="botonUsuario" type="button"
                            aria-label="Menú del usuario" aria-expanded="false">
                        <img class="fotoUsuario" src="<%=esc(perfil)%>" alt="Foto del usuario">
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
                        <span class="saeIcono">📦</span>
                        <div>
                            <h1>Objetos encontrados</h1>
                            <p>Consulta los objetos que están bajo custodia del SAE en la sede <%=esc(sede)%>.</p>
                        </div>
                    </div>
                    <div class="saeAdmin">
                        <span>🛡️</span>
                        <div>
                            <strong>Acceso administrativo</strong>
                            <p><%=esc(sede)%></p>
                        </div>
                    </div>
                </section>

                <% if (errorDatos) { %>
                <div class="saeAviso" id="saeAviso">No se pudieron cargar los objetos. Revisa la conexión con la base de datos.</div>
                <% } %>

                <section class="cuadroTarjetas">
                    <div class="saeFiltros">
                        <input type="search" id="fBuscar" placeholder="Buscar por nombre, marca, color o lugar..." aria-label="Buscar objetos">
                        <select id="fCategoria" aria-label="Filtrar por categoría">
                            <option value="">Todas las categorías</option>
                            <% for (String c : categorias) { %>
                            <option value="<%=esc(c)%>"><%=esc(c)%></option>
                            <% } %>
                        </select>
                        <select id="fEstado" aria-label="Filtrar por estado">
                            <option value="">Todos los estados</option>
                        </select>
                        <a class="saeBtn saeBtnChico" href="RegistrarEncontrado.jsp">➕ Registrar</a>
                        <span class="saeContador" id="contador"><%=objetos.size()%> objetos</span>
                    </div>
                </section>

                <section class="cuadroTarjetas saeTablaCaja">
                    <table class="saeTabla" id="tablaObjetos">
                        <thead>
                            <tr>
                                <th>Objeto</th>
                                <th>Categoría</th>
                                <th>Lugar de hallazgo</th>
                                <th>Fecha de hallazgo</th>
                                <th>Estado</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (ObjetoEncontrado o : objetos) {
                                   String est = o.getEstado() == null ? "" : o.getEstado(); %>
                            <tr data-id="<%=o.getIdObjeto()%>"
                                data-nombre="<%=esc(o.getNombre())%>"
                                data-categoria="<%=esc(o.getCategoria())%>"
                                data-color="<%=esc(o.getColor())%>"
                                data-marca="<%=esc(o.getMarca())%>"
                                data-descripcion="<%=esc(o.getDescripcion())%>"
                                data-lugar="<%=esc(o.getLugarReferencia())%>"
                                data-fecha="<%= o.getFechaHallazgo() == null ? "-" : fmt.format(o.getFechaHallazgo()) %>"
                                data-registro="<%= o.getFechaRegistro() == null ? "-" : fmt.format(o.getFechaRegistro()) %>"
                                data-estado="<%=esc(est)%>"
                                data-imagen="<%=esc(o.getImagen())%>"
                                data-sede="<%=esc(sede)%>">
                                <td><div class="saeCeldaObjeto"><img class="saeThumb" src="<%=esc(o.getImagen())%>" alt="">
                                        <strong><%=esc(o.getNombre())%></strong></div></td>
                                <td><%=esc(o.getCategoria())%></td>
                                <td><%=esc(o.getLugarReferencia())%></td>
                                <td><%= o.getFechaHallazgo() == null ? "-" : fmt.format(o.getFechaHallazgo()) %></td>
                                <td><span class="saeEstado objEstado"><%=esc(est)%></span></td>
                                <td><button type="button" class="saeBtn saeBtnChico btnDetalle">Detalle ➡</button></td>
                            </tr>
                            <% } %>
                            <tr class="objVacio" id="filaVacia" <%= objetos.isEmpty() ? "" : "hidden" %>>
                                <td colspan="6" class="saeVacio">No hay objetos que coincidan con los filtros</td>
                            </tr>
                        </tbody>
                    </table>
                </section>

            </div>
        </main>

        <!-- Detalle del objeto -->
        <div class="objModal" id="objModal" hidden>
            <div class="objDialogo" role="dialog" aria-modal="true" aria-labelledby="mNombre">
                <button type="button" class="objCerrar" id="mCerrar" aria-label="Cerrar">✖</button>
                <div class="objFoto"><img id="mImagen" alt="Foto del objeto"></div>
                <div class="objInfo">
                    <h2 id="mNombre"></h2>
                    <span class="saeEstado objEstado" id="mEstado"></span>
                    <dl class="saeDatos">
                        <div><dt>Categoría</dt><dd id="mCategoria"></dd></div>
                        <div><dt>Color</dt><dd id="mColor"></dd></div>
                        <div><dt>Marca o modelo</dt><dd id="mMarca"></dd></div>
                        <div><dt>Lugar de hallazgo</dt><dd id="mLugar"></dd></div>
                        <div><dt>Sede</dt><dd id="mSede"></dd></div>
                        <div><dt>Fecha de hallazgo</dt><dd id="mFecha"></dd></div>
                        <div><dt>Fecha de registro</dt><dd id="mRegistro"></dd></div>
                    </dl>
                    <h3 class="saeMini">Descripción</h3>
                    <p class="saeSustento" id="mDescripcion"></p>
                </div>
            </div>
        </div>

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
        <script src="objetos.js" defer></script>
        <script src="iconos.js" defer></script>
    </body>
</html>
