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
                        <li><a href="">&#x2753; Preguntas frecuentes</a></li>
                        <li><a href="">&#x260E; Contacto</a></li>
                        <li><a href="">&#x1F4D6; Guía de usuario</a></li>
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
                                    segura y
                                    sencilla.</p>

                            </div>
                            <img src="Imagenes/LostFind.png" alt="objetos perdidos" width="700px">
                        </div>
                        <div class="contenedorCirculos">
                            <div class="text">
                                <div class="circulo">
                                    <span>&#x1f4c4;</span>
                                </div>
                                <h1>Registra</h1>
                                <p>Reporta tu objeto perdido en pocos pasos.</p>
                            </div>
                            <div class="text">
                                <div class="circulo">
                                    <span>&#x1f50e;</span>
                                </div>
                                <h1>Busca</h1>
                                <p>Explora los objetos encontrados en el campus.</p>
                            </div>
                            <div class="text">
                                <div class="circulo">
                                    <span>&#x1F4CE;</span>
                                </div>
                                <h1>Coincidencias</h1>
                                <p>Recibe sugerencias automáticas.</p>
                            </div>
                            <div class="text">
                                <div class="circulo">
                                    <span>&#x1F6E1;</span>
                                </div>
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
                                <a href="">
                                    <p style="color:#0B8FEA; font-weight: 600;">¿Olvidaste tu contraseña?</p>
                                </a>
                            </div>
                            <input name="contraseña" type="password" placeholder="&#x1F512 contraseña"><br>
                            <br>
                            <button class="btn">Iniciar sesión &#x2192;</button>
                            <br>
                            <div class="cuadro">
                                <div>&#x1F6E1 Acceso exclusivo para miembros de la comunidad UTP</div>
                            </div> <br>
                            <h5 style="color:#0B8FEA; font-weight: 600;">¿No tienes acceso?</h5>
                            <h5 style="color:#0B8FEA; font-weight: 600;">Comunicate con el Servicio de Atención con el
                                Estudiante</h5>
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
        
    </body>

</html>