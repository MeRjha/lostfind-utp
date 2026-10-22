<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lost Find - Ingresar</title>
        <link rel="stylesheet" href="estilos.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">

    </head>

    <body>
        <header class="header">
            <div class="contenedor nav-dashboard">
                <div class="superior">
                    <div class="logoContenedor">
                        <img class="logo" src="Imagenes/utpLogo.png" alt="logoUTP">
                        <div class="tituloLogo">
                            <h1>Lost Find</h1>
                            <p>Universidad Tecnológica del Perú</p>
                        </div>
                    </div>

                    <div>
                        <input class="input" type="text" placeholder="&#x1F50D Buscar, lugares o descripciones...">
                    </div>

                    <div>
                        <img class="fotoUsuario" src="Imagenes/fotoUsuario.jpg" alt="fotoUsuario">
                    </div>
                </div>


                <nav class="nav">
                    <ul class="nav-list">
                        <li><a href="" class="activo">Inicio</a></li>
                        <li><a href="">Objetos encontrados</a></li>
                        <li><a href="">Objetos perdidos</a></li>
                        <li><a href="">Buscar objeto</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <main>
            <section>
                <div class="contenedorDashboard">
                    <div class="contenedorBienvenida">
                        <div class="bienvenida">
                            <h1>Bienvenido a LostFind &#x1F44B</h1>
                            <p>Consulta, reporta y encuentra tus objetos de manera rápida.</p>
                        </div>

                        <div class="cuadroJuntos">
                            <div class="ordenJuntos">
                                <h1>&#x1F393;</h1>
                                <p><b>Juntos hacemos un campus más seguro</b><br>Reporta, comparte y ayuda a otros estudiantes.</p>
                            </div>
                        </div>
                    </div>

                    <div class="contenedorGrid">
                        <div class="cuadroTarjetas">
                            <div class="contenidoTarjetas">
                                <div class="circuloTarjeta rojo">
                                    &#x1F4DD;
                                </div>
                                <div>
                                    <h3>Reportar objeto perdido</h3>
                                    <p>Registra los detalles de tu objeto para recibir ayuda de la comunidad.</p>
                                </div>
                            </div>
                            <div>
                                <a href="" <button class="btn">Reportar ahora &#x2192;</button></a>
                            </div>
                        </div>
                        <div class="cuadroTarjetas azul">
                            <div class="contenidoTarjetas">
                                <div class="circuloTarjeta azul">
                                    &#x1F50E;
                                </div>
                                <div>
                                    <h3>Buscar objetos encontrados</h3>
                                    <p>Explora los objetos que han sido encontrados en el campus.</p>
                                </div>
                            </div>
                            <div>
                                <a href="" <button class="btn">Buscar ahora &#x2192;</button> </a>
                            </div>
                        </div>
                        <div class="cuadroTarjetas verde">
                            <div class="contenidoTarjetas">
                                <div class="circuloTarjeta verde">
                                    &#x1F465;
                                </div>
                                <div>
                                    <h3>Ver coincidencias</h3>
                                    <p>Revisa posibles coincidencias con tus objetos reportados.</p>
                                </div>
                            </div>
                            <div>
                                <a href="" <button class="btn">Ver coincidencias &#x2192;</button></a>
                            </div>
                        </div>
                    </div>
                    <hr class="lineaSeparadora">
                </div>
            </section>

            <section>
                <div class="contenedorDashboard">
                    <div class="objetosEncontrados">
                        <div>
                            <h1>Objetos encontrados recientemente</h1>
                            <p>Estos son algunos de los objetos que han sido reportados en el campus.</p>
                        </div>
                        <div>
                            <button class="verObjetos">Ver todos los objetos encontrados &#x2192;</button>
                        </div>
                    </div>
                    <div class="contenedorObjetos">
                        <article class="cuadroTarjetas">

                        </article>
                        <article class="cuadroTarjetas">

                        </article>
                        <article class="cuadroTarjetas">

                        </article>
                        <article class="cuadroTarjetas">

                        </article>
                    </div>
                </div>
            </section>
        </main>
        <footer class="footer">
            <div class="contenedor footer-contenedor">
                <div>
                    <a href="">&#x1F4DE SAE - Servicio de Atención al Estudiante</a>
                </div>

                <div>
                    <p>Política de privacidad | Términos y condiciones | &copy; 2026 UTP</p>
                </div>
            </div>
        </footer>
    </body>

</html>