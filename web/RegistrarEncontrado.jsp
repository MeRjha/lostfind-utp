<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Registrar objeto encontrado</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="stylesheet" href="sae.css">
        <link rel="stylesheet" href="registrar.css">
        <link rel="stylesheet" href="efectos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>
    <body class="paginaSAE" data-pagina="registrar">

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
                        <li><a href="DashboardSAE.jsp">Inicio</a></li>
                        <li><a href="RegistrarEncontrado.jsp" class="activo">Registrar objeto</a></li>
                        <li><a href="GestionReclamos.jsp">Reclamos</a></li>
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
                        <span class="saeIcono">➕</span>
                        <div>
                            <h1>Registrar objeto encontrado</h1>
                            <p>Como integrante del SAE, registra un nuevo objeto encontrado en la sede <%=sede%>.</p>
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

                <div class="saeAviso" id="saeAviso" hidden></div>

                <div class="regLayout">

                    <!-- ============ Formulario ============ -->
                    <section class="cuadroTarjetas regTarjeta">
                        <h2 class="saeSubtitulo">📝 Información del objeto</h2>

                        <form id="formRegistro" novalidate>
                            <div class="regColumnas">

                                <div class="regCol">
                                    <div class="regCampo">
                                        <label for="nombre">Nombre del objeto <b>*</b></label>
                                        <input type="text" id="nombre" name="nombre" maxlength="100"
                                               placeholder="Ej. Mochila, celular, llaves, etc." required>
                                    </div>

                                    <div class="regCampo">
                                        <label for="categoria">Categoría <b>*</b></label>
                                        <select id="categoria" name="categoria" required>
                                            <option value="">Selecciona una categoría</option>
                                            <option value="Tecnología">Tecnología</option>
                                            <option value="Documentos">Documentos</option>
                                            <option value="Accesorios">Accesorios</option>
                                            <option value="Mochilas">Mochilas</option>
                                            <option value="Ropa">Ropa</option>
                                            <option value="Otros">Otros</option>
                                        </select>
                                    </div>

                                    <div class="regCampo">
                                        <label for="color">Color <b>*</b></label>
                                        <select id="color" name="color" required>
                                            <option value="">Selecciona un color</option>
                                            <option>Negro</option>
                                            <option>Blanco</option>
                                            <option>Gris</option>
                                            <option>Azul</option>
                                            <option>Rojo</option>
                                            <option>Verde</option>
                                            <option>Amarillo</option>
                                            <option>Naranja</option>
                                            <option>Marrón</option>
                                            <option>Rosado</option>
                                            <option>Morado</option>
                                            <option>Beige</option>
                                            <option>Plateado</option>
                                            <option>Dorado</option>
                                            <option>Varios colores</option>
                                        </select>
                                    </div>

                                    <div class="regCampo">
                                        <label for="marca">Marca o modelo</label>
                                        <input type="text" id="marca" name="marca" maxlength="50"
                                               placeholder="Ej. Samsung, Sony, Nike, etc.">
                                    </div>

                                    <div class="regCampo">
                                        <label for="fechaHallazgo">Fecha de hallazgo <b>*</b></label>
                                        <input type="date" id="fechaHallazgo" name="fechaHallazgo" required>
                                    </div>
                                </div>

                                <div class="regCol">
                                    <div class="regCampo">
                                        <label for="lugarReferencia">Lugar de hallazgo <b>*</b></label>
                                        <input type="text" id="lugarReferencia" name="lugarReferencia" maxlength="150"
                                               placeholder="Ej. Aula, biblioteca, cafetería, pasillo, etc." required>
                                    </div>

                                    <div class="regCampo">
                                        <label for="idSede">Sede <b>*</b></label>
                                        <select id="idSede" name="idSede" required
                                                data-sede="<%=sede.replace("\"", "&quot;")%>">
                                            <option value="">Cargando sedes…</option>
                                        </select>
                                    </div>

                                    <div class="regCampo">
                                        <label for="descripcion">Descripción <b>*</b></label>
                                        <textarea id="descripcion" name="descripcion" maxlength="500" required
                                                  placeholder="Describe el objeto con el mayor detalle posible…"></textarea>
                                        <span class="regContador" id="contadorDescripcion">0/500</span>
                                    </div>

                                    <div class="regCampo">
                                        <label for="foto">Foto del objeto <b>*</b></label>
                                        <input class="regArchivo" type="file" id="foto" name="foto"
                                               accept=".jpg,.jpeg,.png,.webp">
                                        <label class="regZonaFoto" for="foto">
                                            <span class="regIconoFoto">📤</span>
                                            <strong id="textoFoto">Subir archivo</strong>
                                            <small>JPG, PNG o WEBP (máx. 5 MB)</small>
                                        </label>
                                    </div>
                                </div>

                            </div>

                            <p class="regMensaje" id="mensajeForm" role="alert" hidden></p>

                            <div class="regBotones">
                                <button type="submit" class="saeBtn" id="btnGuardar">💾 Guardar registro</button>
                                <button type="reset" class="saeBtn saeBtnClaro" id="btnLimpiar">Limpiar</button>
                            </div>
                        </form>
                    </section>

                    <!-- ============ Vista previa y recomendaciones ============ -->
                    <aside class="regLateral">
                        <section class="cuadroTarjetas regTarjeta">
                            <h2 class="saeSubtitulo">👁️ Vista previa del registro</h2>
                            <div class="regPrevia">
                                <div class="regFotoPrevia" id="fotoPrevia">
                                    <span>🖼️</span>
                                    <img id="imgPrevia" alt="Vista previa de la foto" hidden>
                                </div>
                                <dl class="saeDatos regDatos">
                                    <div><dt>Nombre del objeto</dt><dd id="pvNombre">-</dd></div>
                                    <div><dt>Categoría</dt><dd id="pvCategoria">-</dd></div>
                                    <div><dt>Color</dt><dd id="pvColor">-</dd></div>
                                    <div><dt>Marca o modelo</dt><dd id="pvMarca">-</dd></div>
                                    <div><dt>Fecha de hallazgo</dt><dd id="pvFecha">-</dd></div>
                                    <div><dt>Lugar de hallazgo</dt><dd id="pvLugar">-</dd></div>
                                    <div><dt>Sede</dt><dd id="pvSede">-</dd></div>
                                    <div><dt>Estado</dt><dd><span class="saeEstado aprobado">Disponible para coincidencia</span></dd></div>
                                </dl>
                            </div>
                        </section>

                        <section class="cuadroTarjetas regTarjeta">
                            <h2 class="saeSubtitulo">ℹ️ Recomendaciones</h2>
                            <ul class="regTips">
                                <li><span>✅</span><div><strong>Verifica el estado del objeto</strong>
                                        <p>Asegúrate de que la información registrada sea correcta y completa.</p></div></li>
                                <li><span>📍</span><div><strong>Registra la fecha y lugar exactos</strong>
                                        <p>Esto facilitará que el dueño pueda identificar su objeto.</p></div></li>
                                <li><span>📷</span><div><strong>Adjunta una fotografía legible</strong>
                                        <p>La imagen debe mostrar claramente el objeto.</p></div></li>
                                <li><span>📝</span><div><strong>Sé descriptivo en la información</strong>
                                        <p>Incluye detalles que puedan ayudar en la coincidencia (características, accesorios, etc.).</p></div></li>
                            </ul>
                        </section>
                    </aside>

                </div>
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
        <script src="registrar.js" defer></script>
        <script src="iconos.js" defer></script>
    </body>
</html>
