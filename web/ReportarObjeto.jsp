<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Reportar objeto perdido</title>
        <link rel="stylesheet" href="estilos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    </head>

    <body class="paginaReportar">

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
            <div class="contenidoReporte">

                <section class="informacionReporte">

                    <div>
                        <span class="etiquetaReporte">📄 Reportar objeto perdido</span>

                        <h1>Reporta tu<br>objeto perdido</h1>

                        <p class="descripcionReporte">
                            Completa la información de tu pertenencia para que
                            el sistema compare tus datos con los objetos encontrados
                            registrados por el SAE.
                        </p>
                    </div>

                    <img class="imagenAvion"
                         src="Imagenes/papelAvion.png"
                         alt="Avión de papel con nubes y una lupa">

                    <div class="mensajeReporte">
                        <span class="iconoMensaje">🎓</span>
                        <div>
                            <h3>Juntos hacemos un campus más seguro</h3>
                            <p>Reporta, comparte y ayuda a otros estudiantes.</p>
                        </div>
                    </div>

                </section>

                <section class="tarjetaReporte">

                    <h2>Datos del objeto</h2>

                    <p class="subtituloReporte">
                        Completa todos los campos para un mejor resultado.
                    </p>

                    <form id="formReporte" action="ReporteServlet" method="post" enctype="multipart/form-data">

                        <div class="camposReporte">

                            <div class="campoReporte">
                                <label for="categoria">Categoría</label>
                                <select id="categoria" name="categoria" required>
                                    <option value="">Seleccionar categoría</option>
                                    <option value="Tecnología">Tecnología</option>
                                    <option value="Documentos">Documentos</option>
                                    <option value="Accesorios">Accesorios</option>
                                    <option value="Mochilas">Mochilas</option>
                                    <option value="Ropa">Ropa</option>
                                    <option value="Otros">Otros</option>
                                </select>
                            </div>

                            <div class="campoReporte">
                                <label for="nombreObjeto">Nombre del objeto</label>
                                <input type="text" id="nombreObjeto" name="nombreObjeto"
                                       placeholder="Ej. Audífonos" maxlength="100" required>
                            </div>

                            <div class="campoReporte">
                                <label for="color">Color</label>
                                <input type="text" id="color" name="color"
                                       placeholder="Ej. Azul" maxlength="50" required>
                            </div>

                            <div class="campoReporte">
                                <label for="marca">Marca</label>
                                <input type="text" id="marca" name="marca"
                                       placeholder="Ej. Sony" maxlength="50" required>
                            </div>

                            <div class="campoReporte">
                                <label for="fechaPerdida">Fecha de pérdida</label>
                                <input type="date" id="fechaPerdida"
                                       name="fechaPerdida" required>
                            </div>

                            <div class="campoReporte">
                                <label for="ubicacion">Ubicación</label>
                                <input type="text" id="ubicacion" name="ubicacion"
                                       placeholder="Ej. Biblioteca, Pabellón A"
                                       maxlength="150" required>
                            </div>

                            <div class="campoReporte">
                                <label for="descripcion">Descripción</label>
                                <textarea id="descripcion" name="descripcion"
                                          maxlength="500" required
                                          placeholder="Describe tu objeto con el mayor detalle posible (características, estado, etc.)."></textarea>
                                <span class="contadorReporte" id="contadorReporte">0/500</span>
                            </div>

                            <div class="campoReporte">
                                <label for="foto">Foto opcional</label>

                                <input class="archivoOculto" type="file"
                                       id="foto" name="foto"
                                       accept=".jpg,.jpeg,.png,.webp">

                                <label class="zonaFoto" for="foto">
                                    <span class="iconoFoto">📤</span>
                                    <strong>Subir archivo</strong>
                                    <span id="nombreFoto">JPG, PNG o WEBP (máx. 5 MB)</span>
                                </label>
                            </div>

                        </div>

                        <div class="botonesReporte">
                            <button class="botonEnviarReporte" type="submit">
                                📨 Enviar reporte
                            </button>

                            <button class="botonLimpiarReporte" type="reset">
                                🔄 Limpiar
                            </button>
                        </div>

                    </form>
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

        <script src="script.js" defer></script>
    </body>
</html>
