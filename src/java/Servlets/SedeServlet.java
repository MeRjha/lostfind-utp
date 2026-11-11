/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Servlets;

import ClasesDAO.SedeDAO;
import Objetos.Sede;
import Objetos.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ariana
 */

@WebServlet(name = "SedeServlet", urlPatterns = {"/SedeServlet"})
public class SedeServlet extends HttpServlet{
    
    private final SedeDAO sedeDAO = new SedeDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Usuario usuario = (Usuario) request.getSession(false)
                .getAttribute("usuario");

        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                "{\"error\":\"Debe iniciar sesión\"}"
            );
            return;
        }

        if (usuario.getRol() == null ||
            !usuario.getRol().equalsIgnoreCase("PersonalSAE")) {

            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write(
                "{\"error\":\"Acceso no autorizado\"}"
            );
            return;
        }

        List<Sede> sedes = sedeDAO.obtenerSedes();

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(sedes));
    }
}
