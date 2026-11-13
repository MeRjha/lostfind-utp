package Servlets;

import ClasesDAO.DashboardSAEDAO;
import ClasesDAO.ObjetosEncontradosDAO;
import ClasesDAO.SolicitudReclamoDAO;
import Objetos.ObjetoEncontrado;
import Objetos.SolicitudReclamo;
import Objetos.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardSAEServlet", urlPatterns = {"/DashboardSAEServlet"})
public class DashboardSAEServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        responder(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        responder(req, resp);
    }

    private String fecha(java.util.Date f) {
        return f == null ? "" : new SimpleDateFormat("yyyy-MM-dd").format(f);
    }

    private void responder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession sesion = req.getSession(false);
        Usuario usuario = sesion == null ? null : (Usuario) sesion.getAttribute("usuario");
        if (usuario == null || !"PersonalSae".equalsIgnoreCase(usuario.getRol())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso exclusivo para SAE.");
            return;
        }
        try {
            DashboardSAEDAO dao = new DashboardSAEDAO();
            String nombreSede = usuario.getSede() == null ? "" : usuario.getSede().getNombre();

            Map<String, Object> json = new LinkedHashMap<>();
            json.put("bajoCustodia", dao.contarObjetosBajoCustodia());
            json.put("reclamosPendientes", dao.contarReclamosPendientes());
            json.put("coincidencias", dao.contarCoincidencias());
            json.put("entregados", dao.contarObjetosAceptados());

            List<Map<String, Object>> recientes = new ArrayList<>();
            if (usuario.getSede() != null) {
                List<ObjetoEncontrado> lista = new ObjetosEncontradosDAO()
                        .obtenerObjetosRecientes(usuario.getSede().getIdSede());
                if (lista != null) {
                    for (ObjetoEncontrado o : lista) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("idObjeto", o.getIdObjeto());
                        m.put("nombre", o.getNombre());
                        m.put("categoria", o.getCategoria());
                        m.put("lugar", o.getLugarReferencia());
                        m.put("sede", nombreSede);
                        m.put("estado", o.getEstado());
                        m.put("fecha", fecha(o.getFechaHallazgo()));
                        m.put("imagen", o.getImagen());
                        recientes.add(m);
                    }
                }
            }
            json.put("recientes", recientes);

            List<Map<String, Object>> pendientes = new ArrayList<>();
            List<SolicitudReclamo> sol = new SolicitudReclamoDAO().listarSolicitudes("PENDIENTE", null, null, null);
            for (SolicitudReclamo s : sol.subList(0, Math.min(4, sol.size()))) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("idSolicitud", s.getIdSolicitud());
                m.put("objeto", s.getNombreObjeto());
                m.put("imagen", s.getImagen());
                m.put("estudiante", s.getNombreEstudiante() + " " + s.getApellidoEstudiante());
                m.put("fecha", fecha(s.getFechaSolicitud()));
                pendientes.add(m);
            }
            json.put("pendientes", pendientes);

            resp.setContentType("application/json;charset=UTF-8");
            resp.setHeader("Cache-Control", "no-store");
            resp.getWriter().write(new Gson().toJson(json));
        } catch (SQLException e) {
            getServletContext().log("Error al cargar el panel SAE", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo cargar el panel.");
        }
    }
}