/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import ClasesDAO.ObjetoDAO;
import ClasesDAO.ObjetoPerdidoDAO;
import ClasesDAO.ObjetosEncontradosDAO;
import ClasesDAO.ReporteDAO;
import Gestiones.GestionGemini;
import Objetos.Coincidencia;
import Objetos.ObjetoEncontrado;
import Objetos.ObjetoPerdido;
import Objetos.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author Axel
 */
@WebServlet(name = "ReporteServlet", urlPatterns = {"/ReporteServlet"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ReporteServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ReporteServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReporteServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part foto = request.getPart("foto");

        String rutaImagen = null;

        if (foto != null && foto.getSize() > 0) {

            String extension;

            switch (foto.getContentType()) {
                case "image/jpeg":
                    extension = ".jpg";
                    break;
                case "image/png":
                    extension = ".png";
                    break;
                case "image/webp":
                    extension = ".webp";
                    break;
                default:
                    response.sendError(400, "Formato no permitido");
                    return;
            }

            String nombre = UUID.randomUUID().toString() + extension;

            String carpeta = getServletContext().getRealPath("/Imagenes");;

            Path destino = Paths.get(carpeta, nombre);

            Files.createDirectories(destino.getParent());

            try (var entrada = foto.getInputStream()) {
                Files.copy(entrada, destino, StandardCopyOption.REPLACE_EXISTING);
            }

            rutaImagen = "Imagenes/" + nombre;
        }

        System.out.println("Imagen: " + rutaImagen);

        try {
            Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
            String categoria = (String) request.getParameter("categoria");
            String nombreObjeto = (String) request.getParameter("nombreObjeto");
            String color = (String) request.getParameter("color");
            String marca = (String) request.getParameter("marca");
            String fechaPerdidaString = ((String) request.getParameter("fechaPerdida"));
            SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date fechaPerdida = formato.parse(fechaPerdidaString);
            String ubicacion = (String) request.getParameter("ubicacion");
            String descripcion = (String) request.getParameter("descripcion");
            ObjetoPerdido objetoPerdido = new ObjetoPerdido(fechaPerdida, categoria, rutaImagen, nombreObjeto, color, marca, descripcion, ubicacion, "PERDIDO");
            String respuestaObjeto = new ObjetoDAO().crearObjeto(usuario, objetoPerdido);
            System.out.println(respuestaObjeto);
            List<Coincidencia> listaCoincidencia = new ArrayList<>();
            if (respuestaObjeto != null) {
                String respuesta = new ObjetoPerdidoDAO().crearObjetoPerdido(usuario.getIdUsuario(), objetoPerdido);
                System.out.println(respuesta);
                String estado = "🕒 En búsqueda";

                List<ObjetoEncontrado> objetosSimilares = new ObjetosEncontradosDAO().obtenerObjetosEncontradosSimilares(objetoPerdido);
                List<ObjetoEncontrado> objetosSimilaresMasDe80 = new ArrayList<>();
                objetosSimilares.forEach(objeto -> {
                    try {
                        double coincidencia = GestionGemini.compararObjetos(objetoPerdido.getDescripcion(), objetoPerdido.getImagen(), objeto.getDescripcion(), objeto.getImagen());
                        coincidencia = coincidencia * 100;
                        coincidencia = Math.round(coincidencia * 100.0) / 100.0;
                        if (coincidencia >= 75) {
                            objetosSimilaresMasDe80.add(objeto);
                            Coincidencia coincidencias = new Coincidencia(objetoPerdido, objeto, coincidencia);
                            listaCoincidencia.add(coincidencias);
                        }
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                });

                if (objetosSimilaresMasDe80.isEmpty()) {
                    boolean estadoReporte = new ReporteDAO().crearReporte(usuario, objetoPerdido, estado);
                    response.getWriter().println("<script> alert('Reporte realizado');</script>");
                    response.getWriter().println("<script>window.location.href='" + request.getContextPath() + "/ReportarObjeto.jsp'; </script>");
                } else {
                    estado = "✅ Coincidencia encontrada";
                    boolean estadoReporte = new ReporteDAO().crearReporte(usuario, objetoPerdido, estado);
                    request.getSession().setAttribute("listaCoincidencia", listaCoincidencia);
                    response.getWriter().println("<script>window.location.href='" + request.getContextPath() + "/Coincidencias.jsp?accion=coincidenciasReportes'; </script>");
                }
                
            }
        } catch (ParseException e) {

        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
