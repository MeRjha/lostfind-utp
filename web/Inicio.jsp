<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lost Find - Ingresar</title>
        <link rel="stylesheet" href="estilos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    </head>

    <body class="paginaInicio">
        <header class="header">
            <div class="contenedor nav-contenedor">
                <div class="logoContenedor">
                    <img class="logo" src="Imagenes/utpLogo.png" alt="logoUTP">
                    <div class="tituloLogo">
                        <h1>Lost Find</h1>
                        <p>Universidad Tecnológica del Perú</p>
                    </div>
                </div>

                <nav class="nav">
                    <ul class="nav-list">
                        <li><a href="#" data-ayuda="preguntas">&#x2753; Preguntas frecuentes</a></li>
                        <li><a href="#" data-ayuda="contacto">&#x260E; Contacto</a></li>
                        <li><a href="#" data-ayuda="guia">&#x1F4D6; Guía de usuario</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <main>
            <section class="hero">
                <div class="contenedor hero-grid">
                    <div class="contenedorFlex">
                        <div class="textImg">
                            <div class="hero-text">
                                <span class="badge">&#x1F6E1; Plataforma institucional</span>
                                <h1>LostFind</h1>
                                <p>Sistema de gestión de objetos perdidos y encontrados<br>
                                    Reporta, busca y recupera tus pertenencias dentro del campus UTP de manera rápida,
                                    segura y sencilla.</p>
                            </div>
                            <img src="Imagenes/LostFind.png" alt="objetos perdidos" width="700px">
                        </div>
                        <div class="contenedorCirculos">
                            <div class="text">
                                <div class="circulo"><span>&#x1f4c4;</span></div>
                                <h1>Registra</h1>
                                <p>Reporta tu objeto perdido en pocos pasos.</p>
                            </div>
                            <div class="text">
                                <div class="circulo"><span>&#x1f50e;</span></div>
                                <h1>Busca</h1>
                                <p>Explora los objetos encontrados en el campus.</p>
                            </div>
                            <div class="text">
                                <div class="circulo"><span>&#x1F4CE;</span></div>
                                <h1>Coincidencias</h1>
                                <p>Recibe sugerencias automáticas.</p>
                            </div>
                            <div class="text">
                                <div class="circulo"><span>&#x1F6E1;</span></div>
                                <h1>Recupera</h1>
                                <p>Proceso de reclamo seguro y verificado</p>
                            </div>
                        </div>
                    </div>

                    <form action="LoginServlet" method="POST">
                        <div class="cuadroIngreso">
                            <span class="badge">&#x1F393; Acceso institucional</span>
                            <h1><b>Ingresa a LostFind</b></h1>
                            <h4>Accede con tus credenciales institucionales de la Universidad Tecnológica del Perú.</h4><br>
                            <h4>Correo institucional</h4>
                            <input name="correo" type="text" placeholder="&#x1F4E7 usuario@utp.edu.pe"><br><br>
                            <div class="contraseña">
                                <h4>Contraseña</h4>
                                <a href=""><p style="color:#0B8FEA; font-weight: 600;">¿Olvidaste tu contraseña?</p></a>
                            </div>
                            <input name="contraseña" type="password" placeholder="&#x1F512 contraseña"><br><br>
                            <button class="btn">Iniciar sesión &#x2192;</button><br>
                            <div class="cuadro">
                                <div>&#x1F6E1 Acceso exclusivo para miembros de la comunidad UTP</div>
                            </div><br>
                            <h5 style="color:#0B8FEA; font-weight: 600;">¿No tienes acceso?</h5>
                            <h5 style="color:#0B8FEA; font-weight: 600;">Comunicate con el Servicio de Atención con el Estudiante</h5>
                        </div>
                    </form>
                </div>
            </section>
        </main>
        <footer class="footer">
            <div class="contenedor footer-contenedor">
                <div>
                    <a href="">&#x1F4DE; SAE - Servicio de Atención al Estudiante</a>
                </div>
                <div>
                    <p>Política de privacidad | Términos y condiciones | &copy; 2026 UTP</p>
                </div>
            </div>
        </footer>
        <!-- Modales del nav -->
        <dialog class="modalUsuario modalAyudaInicio" id="modalAyudaInicio" aria-labelledby="tituloAyudaInicio">
            <div class="tituloModal">
                <h2 id="tituloAyudaInicio">Ayuda de LostFind</h2>
                <button type="button" id="cerrarAyudaInicio" aria-label="Cerrar ventana">✕</button>
            </div>

            <section id="panelPreguntasInicio" class="panelAyudaInicio" hidden>
                <p class="introduccionAyuda">Resuelve las dudas más comunes sobre el uso de LostFind.</p>

                <details class="preguntaAyudaInicio">
                    <summary>¿Quiénes pueden utilizar LostFind?</summary>
                    <p>Los miembros de la comunidad UTP que tengan acceso a la plataforma mediante sus credenciales institucionales.</p>
                </details>
                <details class="preguntaAyudaInicio">
                    <summary>¿Cómo registro un objeto que perdí?</summary>
                    <p>Inicia sesión y selecciona «Reportar objeto perdido». Completa los datos del objeto, la fecha y el lugar de pérdida.</p>
                </details>
                <details class="preguntaAyudaInicio">
                    <summary>¿Dónde puedo buscar objetos encontrados?</summary>
                    <p>En la sección «Objetos encontrados» puedes explorar los artículos registrados por el SAE y utilizar los filtros de búsqueda.</p>
                </details>
                <details class="preguntaAyudaInicio">
                    <summary>¿Una coincidencia confirma que el objeto es mío?</summary>
                    <p>No. Una coincidencia indica que los datos se parecen. El SAE debe verificar la propiedad antes de autorizar una devolución.</p>
                </details>
                <details class="preguntaAyudaInicio">
                    <summary>¿Qué hago si no puedo iniciar sesión?</summary>
                    <p>Solicita orientación al Servicio de Atención al Estudiante (SAE) de la UTP mediante sus canales oficiales.</p>
                </details>
            </section>

            <section id="panelContactoInicio" class="panelAyudaInicio" hidden>
                <div class="bloqueContactoInicio">
                    <span class="iconoContactoInicio">☎️</span>
                    <h3>Servicio de Atención al Estudiante (SAE)</h3>
                    <p>Si necesitas ayuda para ingresar a LostFind, registrar un reporte o conocer el proceso de recuperación, comunícate con el SAE de tu sede mediante los canales oficiales de la UTP.</p>
                </div>
                <div class="mensajeContactoInicio">
                    <strong>Para una atención más rápida</strong>
                    <p>Indica tu sede, el tipo de consulta y, si se trata de un objeto perdido, su nombre y el lugar aproximado de pérdida.</p>
                </div>
            </section>

            <section id="panelGuiaInicio" class="panelAyudaInicio" hidden>
                <p class="introduccionAyuda">Conoce cómo utilizar LostFind en cuatro pasos.</p>

                <div class="pasoGuiaInicio">
                    <div class="iconoPasoGuiaInicio">🎓</div>
                    <h3>1. Inicia sesión</h3>
                    <p>Ingresa con tus credenciales institucionales para acceder a los servicios de LostFind.</p>
                </div>
                <div class="pasoGuiaInicio" hidden>
                    <div class="iconoPasoGuiaInicio">📝</div>
                    <h3>2. Reporta tu objeto</h3>
                    <p>Si perdiste algo, describe sus características y registra la fecha y el lugar donde ocurrió.</p>
                </div>
                <div class="pasoGuiaInicio" hidden>
                    <div class="iconoPasoGuiaInicio">🔎</div>
                    <h3>3. Busca coincidencias</h3>
                    <p>Revisa los objetos encontrados y las coincidencias que puedan relacionarse con tu reporte.</p>
                </div>
                <div class="pasoGuiaInicio" hidden>
                    <div class="iconoPasoGuiaInicio">🛡️</div>
                    <h3>4. Solicita la recuperación</h3>
                    <p>Si reconoces tu objeto, presenta una solicitud de reclamo con pruebas de propiedad para la validación del SAE.</p>
                </div>

                <div class="indicadoresGuiaInicio" aria-label="Progreso de la guía">
                    <span class="puntoGuiaInicio activo"></span>
                    <span class="puntoGuiaInicio"></span>
                    <span class="puntoGuiaInicio"></span>
                    <span class="puntoGuiaInicio"></span>
                </div>
                <p class="contadorGuiaInicio" id="contadorGuiaInicio" aria-live="polite">Paso 1 de 4</p>

                <div class="controlesGuiaInicio">
                    <button type="button" id="anteriorGuiaInicio" class="botonAnteriorGuiaInicio" disabled>← Anterior</button>
                    <button type="button" id="siguienteGuiaInicio" class="btn">Siguiente →</button>
                </div>
            </section>
        </dialog>

        <script src="script.js" defer></script>
    </body>
</html>
