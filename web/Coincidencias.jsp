<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LostFind - Coincidencias encontradas</title>
        <link rel="stylesheet" href="estilos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    </head>

    <body class="paginaCoincidencias">

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
                        <li><a href="Coincidencias.jsp" class="activo">Buscar objeto</a></li>
                    </ul>
                </nav>

                <div class="contenedorUsuario">
                    <button class="botonUsuario" id="botonUsuario" type="button"
                            aria-label="Menú del usuario" aria-expanded="false">

                        <img class="fotoUsuario"
                             src="Imagenes/fotoUsuario.jpg"
                             alt="Foto del usuario">
                    </button>

                    <div class="menuUsuario" id="menuUsuario" hidden>
                        <button type="button" id="verPerfil">👤 Mi perfil</button>
                        <button type="button" id="verConfiguracion">⚙️ Configuración</button>
                        <hr>
                        <button type="button" id="cerrarSesion">🚪 Cerrar sesión</button>
                    </div>
                </div>

            </div>
        </header>

        <main>
            <section class="seccionCoincidencias">
                <div class="contenedorDashboard">

                    <div class="volverInicio">
                        <a href="Estudiante.jsp" class="botonVolver">
                            ← Volver al inicio
                        </a>
                    </div>

                    <div class="cabeceraCoincidencias">
                        <div class="iconoTituloCoincidencias">🔎</div>

                        <div>
                            <h1>Coincidencias encontradas</h1>
                            <p>El sistema identificó posibles coincidencias para tu reporte registrado.</p>
                            <p>Revisa los resultados y selecciona el objeto que más se parezca al tuyo.</p>
                        </div>
                    </div>

                    <div class="tarjetaReporteCoincidencia">

                        <div class="resumenReporte">
                            <div class="iconoReporteCoincidencia">📄</div>

                            <div>
                                <h2>Tu objeto reportado</h2>
                                <p>Aquí tienes un resumen del objeto que reportaste como perdido.</p>
                            </div>
                        </div>

                        <div class="detalleReporteCoincidencia">

                            <div class="imagenReporteCoincidencia">
                                <img src="Imagenes/audifonos.jfif"
                                     alt="Audífonos Sony celestes">
                            </div>

                            <div class="infoReporteCoincidencia">

                                <h3>Audífonos Sony celestes</h3>

                                <div class="datosReporteCoincidencia">

                                    <div class="datoCoincidencia">
                                        <span>🏷️</span>
                                        <div>
                                            <strong>Categoría</strong>
                                            <p>Accesorios</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>🎨</span>
                                        <div>
                                            <strong>Color</strong>
                                            <p>Celeste</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>📅</span>
                                        <div>
                                            <strong>Fecha de pérdida</strong>
                                            <p>12 sep 2026</p>
                                        </div>
                                    </div>

                                    <div class="datoCoincidencia">
                                        <span>📍</span>
                                        <div>
                                            <strong>Lugar</strong>
                                            <p>Biblioteca - piso 4</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>

                    <hr class="lineaSeparadora">

                    <div class="tituloResultadosCoincidencia">
                        <h2>Resultados de coincidencia</h2>
                        <p>Estos objetos fueron encontrados y podrían coincidir con tu reporte.</p>
                    </div>

                    <div class="gridCoincidencias">

                        <article class="tarjetaCoincidenciaObjeto">

                            <div class="filaCoincidencia">

                                <img class="imagenCoincidenciaObjeto"
                                     src="Imagenes/audifonos.jfif"
                                     alt="Audífonos Sony inalámbricos celestes">

                                <div class="contenidoCoincidenciaObjeto">

                                    <h3>Audífonos Sony inalámbricos celestes</h3>

                                    <div class="estadoCoincidencia">
                                        <span class="porcentajeCoincidencia alta">92%</span>
                                        <span class="textoCoincidencia altaTexto">Coincidencia alta</span>
                                    </div>

                                    <div class="detalleCoincidenciaLista">
                                        <p>📍 Biblioteca piso 4</p>
                                        <p>🏫 Sede Lima Sur</p>
                                        <p>📅 13 sep 2026</p>
                                    </div>

                                </div>
                            </div>

                            <a href="DetalleCoincidencia.jsp" class="btn">
                                Ver detalle →
                            </a>
                        </article>

                        <article class="tarjetaCoincidenciaObjeto">

                            <div class="filaCoincidencia">

                                <img class="imagenCoincidenciaObjeto"
                                     src="Imagenes/audifonos.jfif"
                                     alt="Audífonos Bluetooth azules">

                                <div class="contenidoCoincidenciaObjeto">

                                    <h3>Audífonos Bluetooth color azul</h3>

                                    <div class="estadoCoincidencia">
                                        <span class="porcentajeCoincidencia alta">88%</span>
                                        <span class="textoCoincidencia altaTexto">Coincidencia alta</span>
                                    </div>

                                    <div class="detalleCoincidenciaLista">
                                        <p>📍 Aula A-207</p>
                                        <p>🏫 Sede Lima Sur</p>
                                        <p>📅 14 sep 2026</p>
                                    </div>

                                </div>
                            </div>

                            <a href="#" class="btn">Ver detalle →</a>
                        </article>

                        <article class="tarjetaCoincidenciaObjeto">

                            <div class="filaCoincidencia">

                                <img class="imagenCoincidenciaObjeto"
                                     src="Imagenes/audifonos.jfif"
                                     alt="Audífonos deportivos celestes">

                                <div class="contenidoCoincidenciaObjeto">

                                    <h3>Audífonos deportivos celestes</h3>

                                    <div class="estadoCoincidencia">
                                        <span class="porcentajeCoincidencia media">81%</span>
                                        <span class="textoCoincidencia mediaTexto">Coincidencia media</span>
                                    </div>

                                    <div class="detalleCoincidenciaLista">
                                        <p>📍 Cafetería central</p>
                                        <p>🏫 Sede Lima Sur</p>
                                        <p>📅 15 sep 2026</p>
                                    </div>

                                </div>
                            </div>

                            <a href="#" class="btn">Ver detalle →</a>
                        </article>

                    </div>

                </div>
            </section>
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

                <button type="button" id="cerrarModal"
                        aria-label="Cerrar ventana">
                    ✕
                </button>
            </div>

            <div id="vistaPerfil">

                <div class="datosPerfil">
                    <img src="Imagenes/fotoUsuario.jpg"
                         alt="Foto de perfil">

                    <h3>Nombre del usuario</h3>
                    <p>correo@utp.edu.pe</p>
                    <span class="badge">Estudiante UTP</span>
                </div>

                <h3 class="subtituloModal">Información personal</h3>

                <div class="informacionPersonal">
                    <p><b>Nombre:</b> Nombre del usuario</p>
                    <p><b>Correo:</b> correo@utp.edu.pe</p>
                    <p><b>Código:</b> Pendiente</p>
                    <p><b>Sede:</b> Pendiente</p>
                    <p><b>Tipo:</b> Estudiante UTP</p>
                </div>

                <h3 class="subtituloModal">Mi actividad</h3>

                <div class="actividadPerfil">
                    <div class="cuadroTarjetas">📝 Mis reportes: —</div>
                    <div class="cuadroTarjetas">🔎 Coincidencias: —</div>
                    <div class="cuadroTarjetas">💬 Mis reclamos: —</div>
                    <div class="cuadroTarjetas">📦 Recuperados: —</div>
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

    </body>
</html>

