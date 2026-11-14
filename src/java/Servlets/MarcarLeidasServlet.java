package Servlets;

import ClasesDAO.NotificacionDAO;
import Objetos.Usuario;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "MarcarLeidasServlet", urlPatterns = {"/MarcarLeidasServlet"})
public class MarcarLeidasServlet extends HttpServlet {

    private final NotificacionDAO dao = new NotificacionDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession sesion = req.getSession(false);
        Usuario usuario = sesion == null ? null : (Usuario) sesion.getAttribute("usuario");
        if (usuario == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Sesión no iniciada.");
            return;
        }
        if (dao.marcarLeidas(usuario.getIdUsuario())) {
            resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudieron marcar.");
        }
    }
}