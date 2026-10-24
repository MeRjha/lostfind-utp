
document.addEventListener("DOMContentLoaded", function () {

    const botonUsuario = document.getElementById("botonUsuario");
    const menuUsuario = document.getElementById("menuUsuario");

    const abrirPerfil = document.getElementById("abrirPerfil");
    const abrirConfiguracion = document.getElementById("abrirConfiguracion");
    const cerrarSesion = document.getElementById("cerrarSesion");

    const modalPerfil = document.getElementById("modalPerfil");
    const modalConfiguracion = document.getElementById("modalConfiguracion");

    const editarPerfil = document.getElementById("editarPerfil");
    const formConfiguracion = document.getElementById("formConfiguracion");

    if (!botonUsuario || !menuUsuario) {
        return;
    }

    function cerrarMenu() {
        menuUsuario.hidden = true;
        botonUsuario.setAttribute("aria-expanded", "false");
    }

    botonUsuario.addEventListener("click", function () {
        menuUsuario.hidden = !menuUsuario.hidden;

        botonUsuario.setAttribute(
            "aria-expanded",
            String(!menuUsuario.hidden)
        );
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

    abrirPerfil.addEventListener("click", function () {
        cerrarMenu();
        modalPerfil.showModal();
    });

    abrirConfiguracion.addEventListener("click", function () {
        cerrarMenu();
        modalConfiguracion.showModal();
    });

    editarPerfil.addEventListener("click", function () {
        modalPerfil.close();
        modalConfiguracion.showModal();
    });

    const botonesCerrar = document.querySelectorAll("[data-cerrar]");

    botonesCerrar.forEach(function (boton) {
        boton.addEventListener("click", function () {
            const nombreModal = boton.getAttribute("data-cerrar");
            document.getElementById(nombreModal).close();
        });
    });

    cerrarSesion.addEventListener("click", function () {
        cerrarMenu();
        alert("Falta conectar esta opción al cierre de sesión del sistema.");
    });

    formConfiguracion.addEventListener("submit", function (event) {
        event.preventDefault();

        const claveActual = document.getElementById("claveActual").value;
        const claveNueva = document.getElementById("claveNueva").value;
        const confirmarClave = document.getElementById("confirmarClave").value;

        if (claveActual || claveNueva || confirmarClave) {
            if (!claveActual || !claveNueva || !confirmarClave) {
                alert("Completa los tres campos para cambiar la contraseña.");
                return;
            }

            if (claveNueva !== confirmarClave) {
                alert("Las contraseñas nuevas no coinciden.");
                return;
            }
        }

        alert("Esta es una vista de prueba. Falta conectar los cambios con el sistema.");
    });

});
