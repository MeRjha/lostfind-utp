package Servlets;

import ClasesDAO.NotificacionDAO;
import Objetos.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "NotificacionesServlet", urlPatterns = {"/NotificacionesServlet"})
public class NotificacionesServlet extends HttpServlet {

    private final NotificacionDAO dao = new NotificacionDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        responder(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        responder(req, resp);
    }

    private void responder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession sesion = req.getSession(false);
        Usuario usuario = sesion == null ? null : (Usuario) sesion.getAttribute("usuario");
        if (usuario == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Sesión no iniciada.");
            return;
        }
        Map<String, Object> json = new LinkedHashMap<>();
        json.put("noLeidas", dao.contarNoLeidas(usuario.getIdUsuario()));
        json.put("items", dao.listarPorUsuario(usuario.getIdUsuario(), 20));

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        resp.getWriter().write(new Gson().toJson(json));
    }
}