/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;


import org.apache.poi.wp.usermodel.HeaderFooterType;
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
import ClasesDAO.SolicitudReclamoDAO;
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
        if (request.getParameter("consulta") != null) {
            HttpSession s = request.getSession(false);
            Usuario u = s == null ? null : (Usuario) s.getAttribute("usuario");
            ObjetoEncontrado o = s == null ? null : (ObjetoEncontrado) s.getAttribute("objetoPerdido");
            boolean existe = u != null && o != null
                    && new SolicitudReclamoDAO().obtenerSolicitudDeUsuario(u.getIdUsuario(), o.getIdObjeto()) != null;
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"existe\":" + existe + "}");
            return;
        }
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

                String accion = request.getParameter("accion");
        boolean enviar = "enviar".equals(accion);
        SolicitudReclamoDAO dao = new SolicitudReclamoDAO();

        if ("PersonalSae".equalsIgnoreCase(usuario.getRol())) {
            response.sendError(403, "El personal SAE no puede enviar reclamos");
            return;
        }

        String sustento = request.getParameter("sustento");
        String detalleAdicional = request.getParameter("detalleAdicional");
        String nombreEvidencia = "No se adjunto evidencia";
        String tipoEv = null;
        byte[] bytesEvidencia = null;

        if (enviar) {
            // ---- ENVIAR: guarda la solicitud y la evidencia, sin descargar nada ----
            if (sustento == null || sustento.isBlank()) {
                response.sendError(400, "Falta el sustento de propiedad");
                return;
            }
            Part evidencia = request.getPart("evidencia");
            String urlEvidencia = null;
            java.io.File archivoEvidencia = null;
            if (evidencia != null && evidencia.getSize() > 0) {
                tipoEv = evidencia.getContentType();
                String ext = "image/jpeg".equals(tipoEv) ? ".jpg" : "image/png".equals(tipoEv) ? ".png"
                        : "application/pdf".equals(tipoEv) ? ".pdf" : null;
                if (ext == null || evidencia.getSize() > 10L * 1024 * 1024) {
                    response.sendError(400, "Evidencia no valida (JPG, PNG o PDF de hasta 10 MB)");
                    return;
                }
                try (InputStream in = evidencia.getInputStream()) {
                    bytesEvidencia = in.readAllBytes();
                }
                String nombreArchivo = java.util.UUID.randomUUID() + ext;
                archivoEvidencia = new java.io.File(Singlenton.Subidas.carpeta().toFile(), nombreArchivo);
                java.nio.file.Files.write(archivoEvidencia.toPath(), bytesEvidencia);
                urlEvidencia = Singlenton.Subidas.PREFIJO + nombreArchivo;
            }

            String sustentoCompleto = sustento.trim();
            if (detalleAdicional != null && !detalleAdicional.isBlank()) {
                sustentoCompleto += "\n\nDetalle adicional: " + detalleAdicional.trim();
            }
            int idSolicitud = dao.crearSolicitud(
                    usuario.getIdUsuario(), objetoEncontrado.getIdObjeto(), sustentoCompleto, urlEvidencia);

            if (idSolicitud <= 0 && archivoEvidencia != null) {
                archivoEvidencia.delete();   // 0 = ya la habia enviado: no se guarda otra copia
            }
            if (idSolicitud == -1) {
                response.sendError(404, "El objeto no esta registrado como encontrado");
                return;
            }
            if (idSolicitud == -2) {
                response.sendError(409, "Este objeto ya fue entregado a otro estudiante");
                return;
            }
            if (idSolicitud == -3) {
                response.sendError(500, "No se pudo registrar la solicitud");
                return;
            }
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"exito\":true,\"idSolicitud\":" + idSolicitud
                    + ",\"yaExistia\":" + (idSolicitud == 0) + "}");
            return;
        }

        // ---- DESCARGAR: solo si ya envio la solicitud; el Word sale de lo guardado ----
        String[] guardada = dao.obtenerSolicitudDeUsuario(usuario.getIdUsuario(), objetoEncontrado.getIdObjeto());
        if (guardada == null) {
            response.sendError(409, "Primero envia la solicitud de reclamo");
            return;
        }
        String marca = "\n\nDetalle adicional: ";
        int corte = guardada[0].indexOf(marca);
        sustento = corte >= 0 ? guardada[0].substring(0, corte) : guardada[0];
        detalleAdicional = corte >= 0 ? guardada[0].substring(corte + marca.length()) : "";
        if (guardada[1] != null) {
            String archivo = guardada[1].substring(guardada[1].lastIndexOf('/') + 1);
            java.nio.file.Path base = Singlenton.Subidas.carpeta();
            java.nio.file.Path ruta = base.resolve(archivo).normalize();
            if (ruta.startsWith(base) && java.nio.file.Files.exists(ruta)) {
                bytesEvidencia = java.nio.file.Files.readAllBytes(ruta);
                nombreEvidencia = archivo;
                tipoEv = archivo.endsWith(".png") ? "image/png"
                        : archivo.endsWith(".pdf") ? "application/pdf" : "image/jpeg";
            }
        }

        try (XWPFDocument documento = new XWPFDocument()) {

            String emision = java.time.LocalDateTime.now(java.time.ZoneId.of("America/Lima"))
                    .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

            // ---- Logo UTP (opcional) ----
            String rutaLogo = getServletContext().getRealPath("/Imagenes/logoUTPConstancia.png");
            if (rutaLogo != null && new java.io.File(rutaLogo).exists()) {
                java.io.File logo = new java.io.File(rutaLogo);
                java.awt.image.BufferedImage li = javax.imageio.ImageIO.read(logo);
                int lw = 170;
                int lh = (int) (li.getHeight() * 170.0 / li.getWidth());
                XWPFParagraph pl = documento.createParagraph();
                pl.setAlignment(ParagraphAlignment.CENTER);
                pl.setSpacingBefore(200);
                try (InputStream in = new java.io.FileInputStream(logo)) {
                    pl.createRun().addPicture(in, XWPFDocument.PICTURE_TYPE_PNG, logo.getName(),
                            Units.toEMU(lw), Units.toEMU(lh));
                } catch (org.apache.poi.openxml4j.exceptions.InvalidFormatException ex) {
                    throw new ServletException("Error al insertar el logo", ex);
                }
            }

            // ---- Encabezado ----
            centrado(documento, "UNIVERSIDAD TECNOLÓGICA DEL PERÚ", 16, true, 500);
            centrado(documento, "SERVICIO DE ATENCIÓN AL ESTUDIANTE (SAE)", 12, false, 200);
            centrado(documento, "CONSTANCIA DE SOLICITUD DE RECLAMO", 14, true, 500);
            centrado(documento, "Sistema LostFind - Objetos perdidos y encontrados", 11, false, 60);

            // ---- Datos del estudiante ----
            XWPFParagraph sep = documento.createParagraph();
            sep.setSpacingBefore(300);
            campo(documento, "ESTUDIANTE", usuario.getNombre() + " " + usuario.getApellido());
            campo(documento, "CORREO INSTITUCIONAL", usuario.getCorreoInstitucional());

            // ---- Datos del objeto ----
            campo(documento, "OBJETO RECLAMADO", objetoEncontrado.getNombre());
            campo(documento, "CATEGORÍA", objetoEncontrado.getCategoria());
            campo(documento, "MARCA", objetoEncontrado.getMarca());
            campo(documento, "COLOR", objetoEncontrado.getColor());
            campo(documento, "LUGAR DE HALLAZGO", objetoEncontrado.getLugarReferencia());
            campo(documento, "FECHA DE HALLAZGO", formatoFecha(objetoEncontrado.getFechaHallazgo()));
            bloque(documento, "DESCRIPCIÓN DEL OBJETO", objetoEncontrado.getDescripcion());

            // ---- Sustento ----
            bloque(documento, "SUSTENTO DE PROPIEDAD", sustento);
            if (detalleAdicional != null && !detalleAdicional.isBlank()) {
                bloque(documento, "DETALLES ADICIONALES", detalleAdicional);
            }

            // ---- Evidencia ----
            if (bytesEvidencia != null && ("image/png".equals(tipoEv) || "image/jpeg".equals(tipoEv))) {
                bloque(documento, "EVIDENCIA ADJUNTA", null);
                int ancho = 320, alto = 240;
                java.awt.image.BufferedImage img = javax.imageio.ImageIO.read(new java.io.ByteArrayInputStream(bytesEvidencia));
                if (img != null) {
                    double esc = Math.min(1.0, Math.min(320.0 / img.getWidth(), 240.0 / img.getHeight()));
                    ancho = (int) (img.getWidth() * esc);
                    alto = (int) (img.getHeight() * esc);
                }
                XWPFParagraph pi = documento.createParagraph();
                pi.setAlignment(ParagraphAlignment.CENTER);
                XWPFRun imagen = pi.createRun();
                int tipoImagen = "image/png".equals(tipoEv)
                        ? XWPFDocument.PICTURE_TYPE_PNG : XWPFDocument.PICTURE_TYPE_JPEG;
                try (InputStream entrada = new java.io.ByteArrayInputStream(bytesEvidencia)) {
                    imagen.addPicture(entrada, tipoImagen, nombreEvidencia,
                            Units.toEMU(ancho), Units.toEMU(alto));
                } catch (org.apache.poi.openxml4j.exceptions.InvalidFormatException ex) {
                    throw new ServletException("Error al insertar la imagen", ex);
                }
            } else if (bytesEvidencia != null) {
                campo(documento, "EVIDENCIA ADJUNTA", "Archivo PDF adjunto a la solicitud");
            } else {
                campo(documento, "EVIDENCIA ADJUNTA", "No se adjuntó evidencia");
            }

            // ---- Declaración ----
            bloque(documento, "DECLARACIÓN",
                    "La presente constancia recoge la información proporcionada por el estudiante durante su "
                    + "solicitud de reclamo. No acredita automáticamente la propiedad del objeto ni autoriza su "
                    + "entrega. La solicitud está sujeta a la verificación correspondiente del personal SAE.");

            // ---- Firmas ----
            XWPFParagraph esp = documento.createParagraph();
            esp.setSpacingBefore(600);
            XWPFTable firmas = documento.createTable(1, 2);
            firmas.setWidth("100%");
            XWPFTable.XWPFBorderType ninguno = XWPFTable.XWPFBorderType.NONE;
            firmas.setTopBorder(ninguno, 0, 0, "FFFFFF");
            firmas.setBottomBorder(ninguno, 0, 0, "FFFFFF");
            firmas.setLeftBorder(ninguno, 0, 0, "FFFFFF");
            firmas.setRightBorder(ninguno, 0, 0, "FFFFFF");
            firmas.setInsideHBorder(ninguno, 0, 0, "FFFFFF");
            firmas.setInsideVBorder(ninguno, 0, 0, "FFFFFF");
            String[] roles = {"Firma del estudiante", "V.º B.º Personal SAE"};
            for (int i = 0; i < 2; i++) {
                XWPFParagraph pf = firmas.getRow(0).getCell(i).getParagraphs().get(0);
                pf.setAlignment(ParagraphAlignment.CENTER);
                XWPFRun rf = pf.createRun();
                rf.setFontFamily("Times New Roman");
                rf.setFontSize(11);
                rf.setText("______________________________");
                rf.addBreak();
                rf.setText(roles[i]);
            }

            // ---- Fecha de emisión (abajo, como el periodo académico) ----
            centrado(documento, "FECHA DE EMISIÓN: " + emision, 12, true, 600);

            response.setContentType(
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"Constancia_LostFind.docx\"");
            documento.write(response.getOutputStream());
        }
    }

    // ================= Ayudas de diseño =================

    private void centrado(XWPFDocument documento, String texto, int tam, boolean negrita, int antes) {
        XWPFParagraph p = documento.createParagraph();
        p.setAlignment(ParagraphAlignment.CENTER);
        p.setSpacingBefore(antes);
        XWPFRun r = p.createRun();
        r.setText(texto);
        r.setBold(negrita);
        r.setFontSize(tam);
        r.setFontFamily("Times New Roman");
    }

    /** Línea tipo "ETIQUETA: valor", como en la carátula. */
    private void campo(XWPFDocument documento, String etiqueta, String valor) {
        XWPFParagraph p = documento.createParagraph();
        p.setSpacingAfter(160);
        XWPFRun e = p.createRun();
        e.setText(etiqueta + ": ");
        e.setBold(true);
        e.setFontSize(12);
        e.setFontFamily("Times New Roman");
        XWPFRun v = p.createRun();
        v.setText(valor == null || valor.isBlank() ? "No especificado" : valor);
        v.setFontSize(12);
        v.setFontFamily("Times New Roman");
    }

    /** Etiqueta en negrita y debajo un párrafo justificado (para textos largos). */
    private void bloque(XWPFDocument documento, String etiqueta, String texto) {
        XWPFParagraph p = documento.createParagraph();
        p.setSpacingBefore(120);
        XWPFRun e = p.createRun();
        e.setText(etiqueta + ":");
        e.setBold(true);
        e.setFontSize(12);
        e.setFontFamily("Times New Roman");
        if (texto == null) {
            return;
        }
        XWPFParagraph t = documento.createParagraph();
        t.setAlignment(ParagraphAlignment.BOTH);
        t.setSpacingAfter(120);
        XWPFRun r = t.createRun();
        String[] lineas = (texto.isBlank() ? "No especificado" : texto).split("\n", -1);
        for (int i = 0; i < lineas.length; i++) {
            if (i > 0) {
                r.addBreak();
            }
            r.setText(lineas[i]);
        }
        r.setFontSize(12);
        r.setFontFamily("Times New Roman");
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
