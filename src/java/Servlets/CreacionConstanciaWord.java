/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import Objetos.ObjetoEncontrado;
import Objetos.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.apache.poi.xwpf.usermodel.*;
import java.io.InputStream;
import org.apache.poi.util.Units;

/**
 *
 * @author Axel
 */
@MultipartConfig
@WebServlet(name = "CreacionConstanciaWord", urlPatterns = {"/CreacionConstanciaWord"})
public class CreacionConstanciaWord extends HttpServlet {

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
            out.println("<title>Servlet CreacionConstanciaWord</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreacionConstanciaWord at " + request.getContextPath() + "</h1>");
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

        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            response.sendError(401, "Sesion no iniciada");
            return;
        }

        Usuario usuario = (Usuario) sesion.getAttribute("usuario");
        ObjetoEncontrado objetoEncontrado
                = (ObjetoEncontrado) sesion.getAttribute("objetoPerdido");

        if (usuario == null || objetoEncontrado == null) {
            response.sendError(400, "Faltan los datos para generar la constancia");
            return;
        }

        String sustento = request.getParameter("sustento");
        String detalleAdicional = request.getParameter("detalleAdicional");

        if (sustento == null || sustento.isBlank()) {
            response.sendError(400, "Falta el sustento de propiedad");
            return;
        }

        Part evidencia = request.getPart("evidencia");
        String nombreEvidencia = "No se adjunto evidencia";

        if (evidencia != null && evidencia.getSize() > 0) {
            String nombreOriginal = evidencia.getSubmittedFileName();

            if (nombreOriginal != null && !nombreOriginal.isBlank()) {
                String nombreLimpio = nombreOriginal.replace("\\", "/");
                nombreEvidencia = nombreLimpio.substring(
                        nombreLimpio.lastIndexOf("/") + 1
                );
            }
        }

        try (XWPFDocument documento = new XWPFDocument()) {

            XWPFParagraph encabezado = documento.createParagraph();
            encabezado.setAlignment(ParagraphAlignment.CENTER);

            XWPFRun nombreSistema = encabezado.createRun();
            nombreSistema.setText("LOSTFIND");
            nombreSistema.setBold(true);
            nombreSistema.setFontSize(22);
            nombreSistema.setColor("173455");

            XWPFParagraph titulo = documento.createParagraph();
            titulo.setAlignment(ParagraphAlignment.CENTER);

            XWPFRun textoTitulo = titulo.createRun();
            textoTitulo.setText("CONSTANCIA DE SOLICITUD DE RECLAMO");
            textoTitulo.setBold(true);
            textoTitulo.setFontSize(14);
            textoTitulo.setColor("173455");

            agregarDato(documento, "Fecha de emision",
                    java.time.LocalDate.now(
                            java.time.ZoneId.of("America/Lima")
                    ).format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")));

            agregarSeccion(documento, "1. DATOS DEL ESTUDIANTE");

            agregarDato(documento, "Nombre completo",
                    usuario.getNombre() + " " + usuario.getApellido());

            agregarDato(documento, "Correo institucional",
                    usuario.getCorreoInstitucional());

            agregarSeccion(documento, "2. INFORMACION DEL OBJETO");

            agregarDato(documento, "ID del objeto",
                    String.valueOf(objetoEncontrado.getIdObjeto()));

            agregarDato(documento, "Nombre",
                    objetoEncontrado.getNombre());

            agregarDato(documento, "Categoria",
                    objetoEncontrado.getCategoria());

            agregarDato(documento, "Marca",
                    objetoEncontrado.getMarca());

            agregarDato(documento, "Color",
                    objetoEncontrado.getColor());

            agregarDato(documento, "Descripcion",
                    objetoEncontrado.getDescripcion());

            agregarDato(documento, "Lugar de referencia",
                    objetoEncontrado.getLugarReferencia());

            agregarDato(documento, "Fecha de hallazgo",
                    formatoFecha(objetoEncontrado.getFechaHallazgo()));

            agregarDato(documento, "Fecha de registro",
                    formatoFecha(objetoEncontrado.getFechaRegistro()));

            agregarSeccion(documento, "3. SUSTENTO DE PROPIEDAD");

            agregarTexto(documento, sustento);

            agregarSeccion(documento, "4. DETALLES ADICIONALES");

            agregarTexto(documento, detalleAdicional);

            agregarSeccion(documento, "5. EVIDENCIA DECLARADA");

            if (evidencia != null && evidencia.getSize() > 0) {

                String tipo = evidencia.getContentType();

                if ("image/png".equals(tipo) || "image/jpeg".equals(tipo)) {

                    int tipoImagen = "image/png".equals(tipo)
                            ? XWPFDocument.PICTURE_TYPE_PNG
                            : XWPFDocument.PICTURE_TYPE_JPEG;

                    XWPFParagraph parrafo = documento.createParagraph();
                    XWPFRun imagen = parrafo.createRun();

                    try (InputStream entrada = evidencia.getInputStream()) {
                        imagen.addPicture(
                                entrada,
                                tipoImagen,
                                nombreEvidencia,
                                Units.toEMU(300),
                                Units.toEMU(200)
                        );
                    } catch (org.apache.poi.openxml4j.exceptions.InvalidFormatException ex) {
                        throw new ServletException("Error al insertar la imagen", ex);
                    }

                } else {
                    agregarTexto(documento, nombreEvidencia);
                }

            } else {
                agregarTexto(documento, "No se adjunto evidencia");
            }

            agregarSeccion(documento, "6. DECLARACION");

            agregarTexto(documento,
                    "La presente constancia recoge la informacion proporcionada "
                    + "por el estudiante durante su solicitud de reclamo. "
                    + "No acredita automaticamente la propiedad del objeto "
                    + "ni autoriza su entrega. La solicitud esta sujeta "
                    + "a la verificacion correspondiente del personal SAE.");

            response.setContentType(
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            );

            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=\"Constancia_LostFind.docx\""
            );

            documento.write(response.getOutputStream());
        }
    }

    private void agregarSeccion(XWPFDocument documento, String titulo) {

        XWPFParagraph parrafo = documento.createParagraph();
        parrafo.setSpacingBefore(250);

        XWPFRun texto = parrafo.createRun();
        texto.setText(titulo);
        texto.setBold(true);
        texto.setFontSize(12);
        texto.setColor("173455");
    }

    private void agregarDato(XWPFDocument documento, String campo, String valor) {

        XWPFParagraph parrafo = documento.createParagraph();

        XWPFRun etiqueta = parrafo.createRun();
        etiqueta.setText(campo + ": ");
        etiqueta.setBold(true);
        etiqueta.setFontSize(10);

        XWPFRun contenido = parrafo.createRun();
        contenido.setText(
                valor == null || valor.isBlank() ? "No especificado" : valor
        );
        contenido.setFontSize(10);
    }

    private void agregarTexto(XWPFDocument documento, String valor) {

        XWPFParagraph parrafo = documento.createParagraph();

        XWPFRun texto = parrafo.createRun();
        texto.setText(
                valor == null || valor.isBlank() ? "No especificado" : valor
        );
        texto.setFontSize(10);
    }

    private String formatoFecha(java.util.Date fecha) {

        if (fecha == null) {
            return "No especificada";
        }

        return new java.text.SimpleDateFormat("dd/MM/yyyy").format(fecha);
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
