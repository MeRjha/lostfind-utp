<%@page import="Objetos.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Detalle de coincidencia</title>
        <link rel="stylesheet" href="estilos.css?v=5">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>

    <body class="paginaDetalle">

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
            <div class="contenedorDashboard contenidoDetalle">

                <div id="BotonVolver">
                    
                </div>
                <h1 class="tituloDetalle">
                    Detalle del objeto y solicitud de reclamo
                </h1>

                <p class="descripcionDetalle">
                    Compara la información del objeto reportado con el objeto
                    encontrado y envía tu solicitud de reclamo si consideras
                    que te pertenece.
                </p>

                <section class="avisoSimilitud">

                    <div class="resultadoSimilitud">
                        <span class="iconoSimilitud">✅</span>

                        <div id="coincidenciaSistema">
                            
                        </div>
                    </div>

                    <div class="explicacionSimilitud">
                        <span>ℹ️</span>

                        <p>
                            <b>Los detalles del objeto reportado y el objeto
                                encontrado son muy similares.</b>
                            <br>
                            Revisa la información y, si confirmas que es tuyo,
                            puedes enviar una solicitud de reclamo.
                        </p>
                    </div>

                </section>

                <section id="comparacionObjetos" class="comparacionObjetos">


                </section>

                <section class="cuadroTarjetas seccionReclamo">

                    <div class="encabezadoFicha">
                        <span class="iconoFicha">📝</span>

                        <div>
                            <h2>Solicitud de reclamo</h2>
                            <p>
                                Completa el sustento de propiedad para que
                                el SAE valide tu solicitud.
                            </p>
                        </div>
                    </div>

                    <form id="formReclamo" action="CreacionConstanciaWord" method="post" enctype="multipart/form-data">

                        <div class="camposReclamo">

                            <div class="campoReclamo">
                                <label for="sustento">
                                    Sustento de propiedad *
                                </label>

                                <textarea id="sustento"
                                          name="sustento"
                                          maxlength="1000"
                                          required
                                          placeholder="Describe una característica distintiva del objeto, el contexto en el que lo perdiste o cualquier dato que ayude a validar la propiedad."></textarea>
                            </div>

                            <div class="campoReclamo">
                                <label for="detalleAdicional">
                                    Detalle adicional (opcional)
                                </label>

                                <textarea id="detalleAdicional"
                                          name="detalleAdicional"
                                          maxlength="1000"
                                          placeholder="Puedes incluir cualquier información adicional que consideres relevante."></textarea>
                            </div>

                            <div class="campoReclamo">
                                <label for="evidencia">
                                    Adjuntar evidencia (opcional)
                                </label>

                                <input class="archivoOculto"
                                       type="file"
                                       id="evidencia"
                                       name="evidencia"
                                       accept=".jpg,.jpeg,.png,.pdf">

                                <label class="zonaEvidencia" for="evidencia">

                                    <span>📤</span>

                                    <strong>Haz clic para subir un archivo</strong>

                                    <small id="nombreEvidencia">
                                        JPG, PNG o PDF (máx. 10 MB)
                                    </small>

                                </label>
                            </div>

                        </div>

                        <label class="declaracionReclamo">
                            <input type="checkbox"
                                   name="declaracion"
                                   required>

                            Declaro que la información proporcionada es verdadera.
                        </label>

                        <div class="parteFinalReclamo">

                            <div class="mensajeReclamo">
                                ℹ️ Tu solicitud será revisada por el SAE y recibirás
                                una notificación con el resultado.
                            </div>

                            <div id="botonesDetalles" class="botonesReclamo">

                              

                            </div>

                        </div>

                    </form>

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

        <script src="script.js"></script>
        <script>verCoincidenciaIndividual();</script>
    </body>
</html>
