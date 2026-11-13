package Servlets;

import ClasesDAO.NotificacionDAO;
import ClasesDAO.ObjetoPerdidoDAO;
import ClasesDAO.RegistroObjetoEncontradoDAO;
import Gestiones.GestionGemini;
import Objetos.ObjetoEncontrado;
import Objetos.ObjetoPerdido;
import Objetos.PersonalSAE;
import Objetos.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.*;

@WebServlet(name = "RegistrarObjetoEncontradoServlet", urlPatterns = {"/RegistrarObjetoEncontradoServlet"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class RegistrarObjetoEncontradoServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Path rutaImagen = null;
        boolean objetoGuardado = false;

        try {
            HttpSession sesion = request.getSession(false);
            if (sesion == null) { responder(response, 401, false, "Debe iniciar sesión."); return; }
            Usuario usuario = (Usuario) sesion.getAttribute("usuario");
            if (!(usuario instanceof PersonalSAE)) {
                responder(response, 403, false, "No tiene permisos para registrar objetos."); return;
            }
            PersonalSAE personalSAE = (PersonalSAE) usuario;
            String nombre = request.getParameter("nombre"), categoria = request.getParameter("categoria");
            String color = request.getParameter("color"), marca = request.getParameter("marca");
            String fecha = request.getParameter("fechaHallazgo"), lugar = request.getParameter("lugarReferencia");
            String descripcion = request.getParameter("descripcion"), sedeTexto = request.getParameter("idSede");

            if (vacio(nombre) || vacio(categoria) || vacio(fecha) || vacio(lugar) || vacio(descripcion) || vacio(sedeTexto)) {
                responder(response, 400, false, "Complete todos los campos obligatorios."); return;
            }

            int idSede;
            try {
                idSede = Integer.parseInt(sedeTexto);
                if (idSede <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                responder(response, 400, false, "La sede seleccionada no es válida."); return;
            }

            LocalDate fechaHallazgo;
            try { fechaHallazgo = LocalDate.parse(fecha); }
            catch (Exception e) { responder(response, 400, false, "La fecha de hallazgo no es válida."); return; }

            Part foto = request.getPart("foto");
            if (foto == null || foto.getSize() == 0) {
                responder(response, 400, false, "Debe adjuntar una fotografía."); return;
            }
            String tipo = foto.getContentType();
            String extension = "image/jpeg".equalsIgnoreCase(tipo) ? ".jpg"
                    : "image/png".equalsIgnoreCase(tipo) ? ".png"
                    : "image/webp".equalsIgnoreCase(tipo) ? ".webp" : null;
            if (extension == null) {
                responder(response, 400, false, "Formato no permitido. Use JPG, PNG o WEBP."); return;
            }

            String nombreArchivo = UUID.randomUUID() + extension;
            String carpetaReal = getServletContext().getRealPath("/Imagenes");
            if (carpetaReal == null) {
                responder(response, 500, false, "No se pudo acceder a la carpeta de imágenes."); return;
            }
            Path carpeta = Paths.get(carpetaReal);
            Files.createDirectories(carpeta);
            rutaImagen = carpeta.resolve(nombreArchivo);
            try (InputStream entrada = foto.getInputStream()) { Files.copy(entrada, rutaImagen); }
            String rutaRelativa = "Imagenes/" + nombreArchivo;

            ObjetoEncontrado objeto = new ObjetoEncontrado(
                    java.sql.Date.valueOf(fechaHallazgo), categoria.trim(), rutaRelativa, nombre.trim(),
                    vacio(color) ? null : color.trim(), vacio(marca) ? null : marca.trim(),
                    descripcion.trim(), lugar.trim(), "Disponible para coincidencia");
            int idObjeto = new RegistroObjetoEncontradoDAO().registrarObjetoEncontrado(personalSAE, objeto, idSede);
            if (idObjeto == -1) {
                Files.deleteIfExists(rutaImagen);
                responder(response, 500, false, "No se pudo registrar el objeto. Verifique los datos."); return;
            }
            objetoGuardado = true;
            buscarCoincidencias(objeto, carpeta);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", true);
            resultado.put("mensaje", "Objeto registrado correctamente.");
            resultado.put("idObjeto", idObjeto);
            resultado.put("imagen", rutaRelativa);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e) {
            if (!objetoGuardado && rutaImagen != null) Files.deleteIfExists(rutaImagen);
            System.out.println("Error en RegistrarObjetoEncontradoServlet: " + e);
            responder(response, 500, false, "Ocurrió un error al procesar el registro.");
        }
    }

    private void buscarCoincidencias(ObjetoEncontrado objeto, Path carpeta) {
        try {
            ObjetoPerdidoDAO perdidosDAO = new ObjetoPerdidoDAO();
            NotificacionDAO notificacionesDAO = new NotificacionDAO();
            List<ObjetoPerdido> pendientes = perdidosDAO.obtenerReportesPendientesParaCoincidencia();
            for (ObjetoPerdido perdido : pendientes) {
                try {
                    double similitud = GestionGemini.compararObjetos(
                            perdido.getDescripcion(), perdido.getImagen(),
                            objeto.getDescripcion(), objeto.getImagen(), carpeta);
                    System.out.println("Similitud con reporte " + perdido.getIdObjetoPerdido() + ": " + (similitud * 100) + "%");
                    if (similitud >= 0.75 && perdidosDAO.actualizarEstadoReporteCoincidencia(perdido.getIdObjetoPerdido())) {
                        String mensaje = "¡Encontramos una posible coincidencia con tu objeto perdido: "
                                + perdido.getNombre() + "! Ingresa a LostFind para revisarla.";
                        if (!notificacionesDAO.registrarNotificacion(perdido.getIdUsuario(), mensaje))
                            System.out.println("No se pudo notificar al usuario " + perdido.getIdUsuario());
                    }
                } catch (Exception e) {
                    System.out.println("Error al comparar el reporte " + perdido.getIdObjetoPerdido() + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println("Error durante la búsqueda de coincidencias: " + e.getMessage());
        }
    }

    private boolean vacio(String valor) { return valor == null || valor.trim().isEmpty(); }

    private void responder(HttpServletResponse response, int codigo, boolean exito, String mensaje) throws IOException {
        response.setStatus(codigo);
        Map<String, Object> resultado = new HashMap<>();
        resultado.put("exito", exito);
        resultado.put("mensaje", mensaje);
        response.getWriter().write(gson.toJson(resultado));
    }
}
