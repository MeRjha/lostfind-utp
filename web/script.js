
document.addEventListener("DOMContentLoaded", function () {

    const botonUsuario = document.getElementById("botonUsuario");
    const menuUsuario = document.getElementById("menuUsuario");
    const modal = document.getElementById("modalUsuario");

    const temaGuardado = localStorage.getItem("temaLostFind") || "claro";

    document.body.classList.toggle("temaOscuro", temaGuardado === "oscuro");

    if (botonUsuario && menuUsuario && modal) {

        const tituloModal = document.getElementById("tituloModal");
        const vistaPerfil = document.getElementById("vistaPerfil");
        const vistaConfiguracion = document.getElementById("vistaConfiguracion");

        function cerrarMenu() {
            menuUsuario.hidden = true;
            botonUsuario.setAttribute("aria-expanded", "false");
        }

        function abrirModal(tipo) {
            cerrarMenu();

            vistaPerfil.hidden = tipo !== "perfil";
            vistaConfiguracion.hidden = tipo !== "configuracion";

            if (tipo === "perfil") {
                tituloModal.textContent = "Mi perfil";
            } else {
                tituloModal.textContent = "Configuración";
            }

            if (!modal.open) {
                modal.showModal();
            }
        }

        botonUsuario.addEventListener("click", function () {
            menuUsuario.hidden = !menuUsuario.hidden;
            botonUsuario.setAttribute("aria-expanded", String(!menuUsuario.hidden));
        });

        document.getElementById("verPerfil").addEventListener("click", function () {
            abrirModal("perfil");
        });

        document.getElementById("verConfiguracion").addEventListener("click", function () {
            abrirModal("configuracion");
        });

        document.getElementById("cerrarModal").addEventListener("click", function () {
            modal.close();
        });

        const editarPerfil = document.getElementById("editarPerfil");

        if (editarPerfil) {
            editarPerfil.addEventListener("click", function () {
                abrirModal("configuracion");
            });
        }

        document.getElementById("cerrarSesion").addEventListener("click", function () {
            cerrarMenu();
            alert("Falta conectar el cierre de sesión con el servidor.");
        });

        document.addEventListener("click", function (event) {

            if (!botonUsuario.contains(event.target) &&
                !menuUsuario.contains(event.target)) {

                cerrarMenu();
            }

        });

        document.addEventListener("keydown", function (event) {

            if (event.key === "Escape") {
                cerrarMenu();
            }

        });

        const avisosCoincidencias = document.getElementById("avisosCoincidencias");
        const avisosObjetos = document.getElementById("avisosObjetos");

        if (avisosCoincidencias && avisosObjetos) {

            avisosCoincidencias.checked =
                localStorage.getItem("avisosCoincidencias") !== "false";

            avisosObjetos.checked =
                localStorage.getItem("avisosObjetos") === "true";

            avisosCoincidencias.addEventListener("change", function () {
                localStorage.setItem(
                    "avisosCoincidencias",
                    avisosCoincidencias.checked
                );
            });

            avisosObjetos.addEventListener("change", function () {
                localStorage.setItem(
                    "avisosObjetos",
                    avisosObjetos.checked
                );
            });

        }

        const opcionesTema = document.querySelectorAll('input[name="tema"]');

        opcionesTema.forEach(function (opcion) {

            opcion.checked = opcion.value === temaGuardado;

            opcion.addEventListener("change", function () {

                document.body.classList.toggle(
                    "temaOscuro",
                    opcion.value === "oscuro"
                );

                localStorage.setItem("temaLostFind", opcion.value);

            });

        });

    }

    const formulario = document.getElementById("formReporte");

    if (formulario) {

        const descripcion = document.getElementById("descripcion");
        const contador = document.getElementById("contadorReporte");
        const foto = document.getElementById("foto");
        const nombreFoto = document.getElementById("nombreFoto");
        const fechaPerdida = document.getElementById("fechaPerdida");

        const hoy = new Date();
        const año = hoy.getFullYear();
        const mes = String(hoy.getMonth() + 1).padStart(2, "0");
        const dia = String(hoy.getDate()).padStart(2, "0");

        fechaPerdida.max = año + "-" + mes + "-" + dia;

        descripcion.addEventListener("input", function () {
            contador.textContent = descripcion.value.length + "/500";
        });

        foto.addEventListener("change", function () {

            const archivo = foto.files[0];

            if (!archivo) {
                nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
                return;
            }

            const tiposPermitidos = [
                "image/jpeg",
                "image/png",
                "image/webp"
            ];

            if (!tiposPermitidos.includes(archivo.type)) {
                alert("Solo se permiten imágenes JPG, PNG o WEBP.");
                foto.value = "";
                nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
                return;
            }

            if (archivo.size > 5 * 1024 * 1024) {
                alert("La foto no puede superar los 5 MB.");
                foto.value = "";
                nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
                return;
            }

            nombreFoto.textContent = archivo.name;

        });

        formulario.addEventListener("reset", function () {
            contador.textContent = "0/500";
            nombreFoto.textContent = "JPG, PNG o WEBP (máx. 5 MB)";
        });

        formulario.addEventListener("submit", function (event) {
            event.preventDefault();
            alert("Falta conectar el formulario con el servidor para guardar el reporte.");
        });

    }

});
