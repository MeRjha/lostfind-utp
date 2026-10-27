<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Objetos encontrados</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>

    <body class="paginaObjetos">

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
            <div class="contenedorDashboard contenidoObjetos">

                <section class="encabezadoObjetos">

                    <div class="tituloObjetos">
                        <span class="iconoTituloObjetos">📦</span>

                        <div>
                            <h1>Objetos encontrados</h1>
                            <p>
                                Revisa los objetos encontrados registrados por el SAE.
                                Si reconoces alguno, puedes ver más detalles y
                                solicitar su reclamo.
                            </p>
                        </div>
                    </div>

                    <div class="avisoObjetos">
                        <span>🛡️</span>

                        <div>
                            <h3>¿No encuentras tu objeto?</h3>
                            <p>También puedes reportar un objeto perdido.</p>

                            <a href="ReportarObjeto.jsp">
                                Reportar ahora →
                            </a>
                        </div>
                    </div>

                </section>

                <section class="cuadroTarjetas filtrosObjetos">

                    <div class="busquedaObjetos">

                        <input type="search"
                               id="buscarObjetos"
                               placeholder="🔍 Buscar por palabra clave (ej. mochila, celular, audífonos...)"
                               aria-label="Buscar objetos encontrados">

                        <button type="button" class="btn"
                                id="botonBuscarObjetos">
                            Buscar
                        </button>

                    </div>

                    <div class="opcionesFiltros">

                        <div class="campoFiltro">
                            <label for="filtroCategoria">Categoría</label>

                            <select id="filtroCategoria">
                                <option value="">Todas</option>
                                <option value="Accesorios">Accesorios</option>
                                <option value="Mochilas">Mochilas</option>
                                <option value="Celulares">Celulares</option>
                                <option value="Tablets">Tablets</option>
                                <option value="Electrónica">Electrónica</option>
                                <option value="Ropa">Ropa</option>
                                <option value="Útiles">Útiles</option>
                                <option value="Otros">Otros</option>
                            </select>
                        </div>

                       
                        <div class="campoFiltro">
                            <label for="filtroLugar">Lugar de hallazgo</label>

                            <select id="filtroLugar">
                                <option value="">Todos</option>
                                <option value="Biblioteca">Biblioteca</option>
                                <option value="Aula">Aulas</option>
                                <option value="Cafetería">Cafetería</option>
                                <option value="Sala">Salas de estudio</option>
                                <option value="Zona deportiva">Zona deportiva</option>
                                <option value="Ingreso">Ingreso principal</option>
                            </select>
                        </div>

                        <div class="campoFiltro">
                            <label for="filtroFecha">Fecha de hallazgo</label>

                            <select id="filtroFecha">
                                <option value="">Todas</option>
                                <option value="oct. 2026">Octubre 2026</option>
                                <option value="sep. 2026">Septiembre 2026</option>
                                <option value="ago. 2026">Agosto 2026</option>
                            </select>
                        </div>

                        <button type="button"
                                class="botonLimpiarObjetos"
                                id="limpiarFiltros">
                            🔄 Limpiar filtros
                        </button>

                    </div>

                </section>

                <section class="resultadosObjetos">

                    <div class="barraResultadosObjetos">

                        <p id="cantidadObjetos">
                            Se encontraron 0 objetos
                        </p>

                        <div class="ordenarObjetos">
                            <label for="ordenObjetos">Ordenar por:</label>

                            <select id="ordenObjetos">
                                <option value="recientes">Más recientes</option>
                                <option value="antiguos">Más antiguos</option>
                                <option value="nombre">Nombre A-Z</option>
                            </select>
                        </div>

                    </div>

                    <div class="listaObjetosEncontrados"
                         id="listaObjetosEncontrados">
                    </div>

                    <p class="sinObjetos" id="sinObjetos" hidden>
                        🔎 No se encontraron objetos con esos filtros.
                    </p>

                    <div class="paginacionObjetos"
                         id="paginacionObjetos">
                    </div>

                </section>

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

        <script src="script.js" defer></script>

    </body>
</html>
