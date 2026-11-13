
package Servlets;

import ClasesDAO.DashboardSAEDAO;
import Objetos.Usuario;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/EstadisticasServlet")
public class EstadisticasServlet extends HttpServlet {

    private final DashboardSAEDAO dao = new DashboardSAEDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        HttpSession sesion = req.getSession(false);
        Object usuario = sesion == null ? null : sesion.getAttribute("usuario");
        if (!(usuario instanceof Usuario u) || !"PersonalSae".equalsIgnoreCase(u.getRol())) {
            resp.sendError(403, "Acceso exclusivo para SAE.");
            return;
        }

        try {
            int anio = Integer.parseInt(req.getParameter("anio") == null
                    ? String.valueOf(LocalDate.now().getYear()) : req.getParameter("anio"));

            String[] meses = req.getParameterValues("mes");
            String[] categorias = req.getParameterValues("categoria");
            String[] estadosFiltro = req.getParameterValues("estado");

            if (anio < 2000 || anio > 2100) throw new IllegalArgumentException();

            if (meses == null) meses = new String[]{String.valueOf(LocalDate.now().getMonthValue())};

            for (String mes : meses)
                if (!mes.matches("0?[1-9]|1[0-2]")) throw new IllegalArgumentException();

            if (estadosFiltro != null)
                for (String estado : estadosFiltro)
                    if (!Set.of("PENDIENTE", "APROBADO", "RECHAZADO").contains(estado))
                        throw new IllegalArgumentException();

            Map<String, Integer> porCategoria = dao.obtenerCategoriasFiltradas(anio, meses, categorias);
            Map<String, Integer> porEstado = dao.obtenerEstadosFiltrados(anio, meses, estadosFiltro, categorias);
            Map<String, Integer> encontradosMes = dao.obtenerMesesFiltrados(anio, meses, categorias);
            Map<String, Integer> aprobadosMes = dao.obtenerAprobadosPorMes(anio, meses, categorias);

            int encontrados = porCategoria.values().stream().mapToInt(Integer::intValue).sum();
            int perdidos = dao.contarPerdidosFiltrados(anio, meses, categorias);
            int coincidencias = dao.contarCoincidenciasFiltradas(anio, meses, categorias);
            int pendientes = porEstado.getOrDefault("PENDIENTE", 0);
            int aprobados = porEstado.getOrDefault("APROBADO", 0);
            int rechazados = porEstado.getOrDefault("RECHAZADO", 0);

            StringBuilder json = new StringBuilder("{\"indicadores\":{")
                    .append("\"registrados\":").append(encontrados)
                    .append(",\"objetosEncontrados\":").append(encontrados)
                    .append(",\"objetosPerdidos\":").append(perdidos)
                    .append(",\"coincidencias\":").append(coincidencias)
                    .append(",\"reclamosPendientes\":").append(pendientes)
                    .append(",\"reclamosAprobados\":").append(aprobados)
                    .append(",\"reclamosRechazados\":").append(rechazados)
                    .append("},\"porCategoria\":[");

            agregarAgrupados(json, porCategoria, "nombre");
            json.append("],\"reclamosPorEstado\":[");
            agregarAgrupados(json, porEstado, "estado");
            json.append("],\"porMes\":[");

            SortedSet<Integer> mesesSeleccionados = new TreeSet<>();
            for (String mes : meses) mesesSeleccionados.add(Integer.parseInt(mes));

            boolean primero = true;
            for (int mes : mesesSeleccionados) {
                if (!primero) json.append(",");
                String clave = String.format("%04d-%02d", anio, mes);
                json.append("{\"mes\":\"").append(clave)
                    .append("\",\"registrados\":").append(encontradosMes.getOrDefault(clave, 0))
                    .append(",\"aprobados\":").append(aprobadosMes.getOrDefault(clave, 0))
                    .append(",\"entregados\":0}");
                primero = false;
            }

            json.append("],\"actividad\":[");
            primero = true;
            for (Map<String, String> item : dao.obtenerActividadReciente()) {
                if (!primero) json.append(",");
                json.append("{\"fecha\":\"").append(escapar(item.get("fecha")))
                    .append("\",\"texto\":\"").append(escapar(item.get("texto"))).append("\"}");
                primero = false;
            }

            resp.getWriter().write(json.append("]}").toString());

        } catch (NumberFormatException e) {
            resp.sendError(400, "Año no válido.");
        } catch (IllegalArgumentException e) {
            resp.sendError(400, "Filtros no válidos.");
        } catch (SQLException e) {
            getServletContext().log("Error al obtener estadísticas SAE", e);
            resp.sendError(500, "No se pudieron consultar las estadísticas.");
        }
    }

    private void agregarAgrupados(StringBuilder json, Map<String, Integer> datos, String campo) {
        boolean primero = true;
        for (Map.Entry<String, Integer> e : datos.entrySet()) {
            if (!primero) json.append(",");
            json.append("{\"").append(campo).append("\":\"").append(escapar(e.getKey()))
                .append("\",\"total\":").append(e.getValue()).append("}");
            primero = false;
        }
    }

    private String escapar(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
