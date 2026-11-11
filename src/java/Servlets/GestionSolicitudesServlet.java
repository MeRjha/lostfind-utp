/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import ClasesDAO.SolicitudReclamoDAO;
import Objetos.SolicitudReclamo;
import Objetos.EvidenciaReclamo;
import Objetos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
/**
 *
 * @author Ariana
 */
@WebServlet(name = "GestionSolicitudesServlet", urlPatterns = {"/GestionSolicitudesServlet"})
public class GestionSolicitudesServlet extends HttpServlet {

   private final SolicitudReclamoDAO solicitudDAO =
            new SolicitudReclamoDAO();

    private Usuario obtenerPersonalSAE(HttpServletRequest request) {

        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            return null;
        }

        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario == null
                || !"PersonalSae".equalsIgnoreCase(usuario.getRol())) {
            return null;
        }

        return usuario;
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Usuario personalSAE = obtenerPersonalSAE(request);

        if (personalSAE == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para acceder a esta sección.");
            return;
        }

        String estado = request.getParameter("estado");
        String categoria = request.getParameter("categoria");
        String fechaTexto = request.getParameter("fecha");
        String busqueda = request.getParameter("busqueda");

        Date fecha = null;

        if (fechaTexto != null && !fechaTexto.trim().isEmpty()) {
            try {
                fecha = Date.valueOf(fechaTexto);
            } catch (IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "La fecha ingresada no es válida.");
                return;
            }
        }

        List<SolicitudReclamo> solicitudes =
                solicitudDAO.listarSolicitudes(
                        estado, categoria, fecha, busqueda);

        request.setAttribute("solicitudes", solicitudes);
        System.out.println("Solicitudes encontradas: " + solicitudes.size());
        
        String idTexto = request.getParameter("idSolicitud");

        if (idTexto != null && !idTexto.trim().isEmpty()) {

            try {
                int idSolicitud = Integer.parseInt(idTexto);

                SolicitudReclamo seleccionada =
                        solicitudDAO.obtenerSolicitudPorId(idSolicitud);

                if (seleccionada != null) {

                    List<EvidenciaReclamo> evidencias =
                            solicitudDAO.listarEvidenciasPorSolicitud(
                                    idSolicitud);

                    request.setAttribute("solicitudSeleccionada",
                            seleccionada);

                    request.setAttribute("evidencias", evidencias);
                }

            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "El código de solicitud no es válido.");
                return;
            }
        }

        request.getRequestDispatcher("/Sae.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Usuario personalSAE = obtenerPersonalSAE(request);

        if (personalSAE == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para realizar esta acción.");
            return;
        }

        String accion = request.getParameter("accion");
        String idTexto = request.getParameter("idSolicitud");

        try {

            int idSolicitud = Integer.parseInt(idTexto);

            SolicitudReclamo solicitud =
                    solicitudDAO.obtenerSolicitudPorId(idSolicitud);

            if (solicitud == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "No se encontró la solicitud.");
                return;
            }

            if (!"PENDIENTE".equalsIgnoreCase(solicitud.getEstado())) {
                response.sendError(HttpServletResponse.SC_CONFLICT,
                        "Esta solicitud ya fue resuelta.");
                return;
            }

            String nuevoEstado;

            if ("aprobar".equalsIgnoreCase(accion)) {
                nuevoEstado = "APROBADO";

            } else if ("rechazar".equalsIgnoreCase(accion)) {
                nuevoEstado = "RECHAZADO";

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Acción no válida.");
                return;
            }

            String motivoRechazo = null;

            if ("RECHAZADO".equals(nuevoEstado)) {
                motivoRechazo = request.getParameter("motivoRechazo");

                if (motivoRechazo == null || motivoRechazo.trim().isEmpty()) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Debes indicar el motivo del rechazo."
                    );
                    return;
                }

                motivoRechazo = motivoRechazo.trim();

                if (motivoRechazo.length() > 500) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "El motivo no puede superar los 500 caracteres."
                    );
                    return;
                }
            }

            boolean actualizado = solicitudDAO.actualizarEstado(
                    idSolicitud,
                    nuevoEstado,
                    personalSAE.getIdUsuario(),
                    motivoRechazo
            );

            if (actualizado) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/GestionSolicitudesServlet");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "No se pudo actualizar la solicitud.");
            }

        } catch (NumberFormatException | NullPointerException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "El código de solicitud no es válido.");
        }
    }
}
