/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Servlets;

import ClasesDAO.RegistroObjetoEncontradoDAO;
import Objetos.ObjetoEncontrado;
import Objetos.PersonalSAE;
import Objetos.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import ClasesDAO.ObjetoPerdidoDAO;
import ClasesDAO.NotificacionDAO;
import Objetos.ObjetoPerdido;
import java.util.List;
import Gestiones.GestionGemini;

/**
 *
 * @author Ariana
 */

@WebServlet(name = "RegistrarObjetoEncontradoServlet",
        urlPatterns = {"/RegistrarObjetoEncontradoServlet"})

@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class RegistrarObjetoEncontradoServlet extends HttpServlet{
    
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Path rutaImagen = null;

        try {
            HttpSession sesion = request.getSession(false);

            if (sesion == null) {
                responder(response, 401, false,
                        "Debe iniciar sesión.");
                return;
            }

            Usuario usuario = (Usuario) sesion.getAttribute("usuario");

            if (!(usuario instanceof PersonalSAE)) {
                responder(response, 403, false,
                        "No tiene permisos para registrar objetos.");
                return;
            }

            PersonalSAE personalSAE = (PersonalSAE) usuario;

            String nombre = request.getParameter("nombre");
            String categoria = request.getParameter("categoria");
            String color = request.getParameter("color");
            String marca = request.getParameter("marca");
            String fecha = request.getParameter("fechaHallazgo");
            String lugar = request.getParameter("lugarReferencia");
            String descripcion = request.getParameter("descripcion");
            String sedeTexto = request.getParameter("idSede");

            if (vacio(nombre) || vacio(categoria)
                    || vacio(fecha) || vacio(lugar)
                    || vacio(descripcion) || vacio(sedeTexto)) {

                responder(response, 400, false,
                        "Complete todos los campos obligatorios.");
                return;
            }

            int idSede;

            try {
                idSede = Integer.parseInt(sedeTexto);
                if (idSede <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                responder(response, 400, false,
                        "La sede seleccionada no es válida.");
                return;
            }

            LocalDate fechaHallazgo;

            try {
                fechaHallazgo = LocalDate.parse(fecha);
            } catch (Exception e) {
                responder(response, 400, false,
                        "La fecha de hallazgo no es válida.");
                return;
            }

            Part foto = request.getPart("foto");

            if (foto == null || foto.getSize() == 0) {
                responder(response, 400, false,
                        "Debe adjuntar una fotografía.");
                return;
            }

            String tipo = foto.getContentType();
            String extension;

            if ("image/jpeg".equalsIgnoreCase(tipo)) {
                extension = ".jpg";
            } else if ("image/png".equalsIgnoreCase(tipo)) {
                extension = ".png";
            } else if ("image/webp".equalsIgnoreCase(tipo)) {
                extension = ".webp";
            } else {
                responder(response, 400, false,
                        "Formato no permitido. Use JPG, PNG o WEBP.");
                return;
            }

            String nombreArchivo = UUID.randomUUID().toString()
                    + extension;

            String carpetaReal = getServletContext()
                    .getRealPath("/Imagenes");

            if (carpetaReal == null) {
                responder(response, 500, false,
                        "No se pudo acceder a la carpeta de imágenes.");
                return;
            }

            Path carpeta = Paths.get(carpetaReal);
            Files.createDirectories(carpeta);

            rutaImagen = carpeta.resolve(nombreArchivo);

            try (InputStream entrada = foto.getInputStream()) {
                Files.copy(entrada, rutaImagen);
            }

            String rutaRelativa = "Imagenes/" + nombreArchivo;

            ObjetoEncontrado objeto = new ObjetoEncontrado(
                    java.sql.Date.valueOf(fechaHallazgo),
                    categoria.trim(),
                    rutaRelativa,
                    nombre.trim(),
                    vacio(color) ? null : color.trim(),
                    vacio(marca) ? null : marca.trim(),
                    descripcion.trim(),
                    lugar.trim(),
                    "Disponible para coincidencia"
            );

            RegistroObjetoEncontradoDAO dao =
                    new RegistroObjetoEncontradoDAO();

            int idObjeto = dao.registrarObjetoEncontrado(
                    personalSAE, objeto, idSede
            );

            if (idObjeto == -1) {
                Files.deleteIfExists(rutaImagen);

                responder(response, 500, false,
                        "No se pudo registrar el objeto. Verifique los datos.");
                return;
            }
            
            // Buscar coincidencias con los objetos perdidos pendientes
            try {

                ObjetoPerdidoDAO objetoPerdidoDAO = new ObjetoPerdidoDAO();
                NotificacionDAO notificacionDAO = new NotificacionDAO();

                List<ObjetoPerdido> reportesPendientes
                        = objetoPerdidoDAO.obtenerReportesPendientesParaCoincidencia();

                for (ObjetoPerdido perdido : reportesPendientes) {

                    try {
                        double similitud = GestionGemini.compararObjetos(
                                perdido.getDescripcion(),
                                perdido.getImagen(),
                                objeto.getDescripcion(),
                                objeto.getImagen(),
                                carpeta
                        );
                        System.out.println(
                                "Similitud con reporte "
                                + perdido.getIdObjetoPerdido()
                                + ": " + (similitud * 100) + "%"
                        );
                        if (similitud >= 0.75) {

                            boolean actualizado
                                    = objetoPerdidoDAO.actualizarEstadoReporteCoincidencia(
                                            perdido.getIdObjetoPerdido()
                                    );
                            if (actualizado) {

                                String mensaje = "¡Encontramos una posible coincidencia "
                                        + "con tu objeto perdido: "
                                        + perdido.getNombre()
                                        + "! Ingresa a LostFind para revisarla.";

                                boolean notificado = notificacionDAO.registrarNotificacion(
                                        perdido.getIdUsuario(),
                                        mensaje
                                );

                                if (!notificado) {
                                    System.out.println(
                                            "No se pudo notificar al usuario "
                                            + perdido.getIdUsuario()
                                    );
                                }
                            }
                        }

                    } catch (Exception e) {
                        System.out.println(
                                "Error al comparar el reporte "
                                + perdido.getIdObjetoPerdido()
                                + ": " + e.getMessage()
                        );
                    }
                }

            } catch (Exception e) {
                System.out.println(
                        "Error durante la búsqueda de coincidencias: "
                        + e.getMessage()
                );
            }
            
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", true);
            resultado.put("mensaje", "Objeto registrado correctamente.");
            resultado.put("idObjeto", idObjeto);
            resultado.put("imagen", rutaRelativa);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(resultado));

        } catch (Exception e) {

            if (rutaImagen != null) {
                Files.deleteIfExists(rutaImagen);
            }

            System.out.println(
                    "Error en RegistrarObjetoEncontradoServlet: " + e
            );

            responder(response, 500, false,
                    "Ocurrió un error al procesar el registro.");
        }
    }

    private boolean vacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

    private void responder(HttpServletResponse response,
            int codigo, boolean exito, String mensaje)
            throws IOException {

        response.setStatus(codigo);

        Map<String, Object> resultado = new HashMap<>();
        resultado.put("exito", exito);
        resultado.put("mensaje", mensaje);

        response.getWriter().write(gson.toJson(resultado));
    }
}
