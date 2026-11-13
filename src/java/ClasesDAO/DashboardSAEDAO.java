package ClasesDAO;

import Singlenton.ConexionBD;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class DashboardSAEDAO {

    private Connection conexion() throws SQLException { return ConexionBD.getInstancia().getConexionNueva(); }

    private int contarRegistros(String sql, Object... parametros) throws SQLException {
        try (Connection con = conexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < parametros.length; i++) ps.setObject(i + 1, parametros[i]);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        }
    }

    public Map<String, Integer> consultarAgrupados(String sql, Object... parametros) throws SQLException {
        Map<String, Integer> datos = new LinkedHashMap<>();
        try (Connection con = conexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < parametros.length; i++) ps.setObject(i + 1, parametros[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) datos.put(rs.getString(1), rs.getInt(2));
            }
        }
        return datos;
    }

    private String filtroMultiple(String columna, String[] valores, List<Object> parametros) {
        if (valores == null || valores.length == 0) return "";
        for (String valor : valores) parametros.add(valor);
        return " AND " + columna + " IN (" + String.join(",", Collections.nCopies(valores.length, "?")) + ")";
    }

    private Map<String, Integer> agrupadosPorFecha(String select, String tablas, String fecha,
            int anio, String[] meses, String[] categorias, String condicion, String grupo) throws SQLException {
        List<Object> p = new ArrayList<>();
        p.add(anio);
        String sql = "SELECT " + select + ", COUNT(*) " + tablas + " WHERE YEAR(" + fecha + ") = ?";
        sql += condicion + filtroMultiple("MONTH(" + fecha + ")", meses, p);
        sql += filtroMultiple("o.categoria", categorias, p) + " GROUP BY " + grupo + " ORDER BY 1";
        return consultarAgrupados(sql, p.toArray());
    }

    private int sumar(Map<String, Integer> datos) {
        return datos.values().stream().mapToInt(Integer::intValue).sum();
    }

    public int contarObjetosEncontrados() throws SQLException { return contarRegistros("SELECT COUNT(*) FROM objeto_encontrado"); }
    public int contarObjetosPerdidos() throws SQLException { return contarRegistros("SELECT COUNT(*) FROM objeto_perdido"); }
    public int contarCoincidencias() throws SQLException { return contarRegistros("SELECT COUNT(*) FROM coincidencia"); }
    public int contarReclamosPendientes() throws SQLException { return contarRegistros("SELECT COUNT(*) FROM solicitud_reclamo WHERE estado = 'PENDIENTE'"); }
    public int contarReclamosAprobados() throws SQLException { return contarRegistros("SELECT COUNT(*) FROM solicitud_reclamo WHERE estado = 'APROBADO'"); }
    public int contarObjetosAceptados() throws SQLException { return contarRegistros("SELECT COUNT(DISTINCT idObjetoEncontrado) FROM solicitud_reclamo WHERE estado = 'APROBADO'"); }
    public int contarObjetosBajoCustodia() throws SQLException {
        return contarRegistros("SELECT COUNT(*) FROM objeto_encontrado oe WHERE NOT EXISTS (SELECT 1 FROM solicitud_reclamo sr WHERE sr.idObjetoEncontrado = oe.idObjetoEncontrado AND sr.estado = 'APROBADO')");
    }

    public Map<String, Integer> obtenerObjetosPorCategoria() throws SQLException {
        return consultarAgrupados("SELECT o.categoria, COUNT(*) FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto GROUP BY o.categoria ORDER BY COUNT(*) DESC");
    }
    public Map<String, Integer> obtenerReclamosPorEstado() throws SQLException {
        return consultarAgrupados("SELECT estado, COUNT(*) FROM solicitud_reclamo GROUP BY estado ORDER BY estado");
    }
    public Map<String, Integer> obtenerEncontradosPorMes() throws SQLException {
        return consultarAgrupados("SELECT DATE_FORMAT(fechaHallazgo, '%Y-%m'), COUNT(*) FROM objeto_encontrado WHERE fechaHallazgo IS NOT NULL GROUP BY DATE_FORMAT(fechaHallazgo, '%Y-%m') ORDER BY 1");
    }
    public int contarEncontradosPorCategoria(String categoria) throws SQLException {
        return contarRegistros("SELECT COUNT(*) FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE o.categoria = ?", categoria);
    }
    public Map<String, Integer> obtenerEncontradosPorMes(String categoria) throws SQLException {
        return consultarAgrupados("SELECT DATE_FORMAT(oe.fechaHallazgo, '%Y-%m'), COUNT(*) FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE oe.fechaHallazgo IS NOT NULL AND o.categoria = ? GROUP BY DATE_FORMAT(oe.fechaHallazgo, '%Y-%m') ORDER BY 1", categoria);
    }
    public int contarEncontradosPorPeriodo(int dias) throws SQLException {
        return contarRegistros("SELECT COUNT(*) FROM objeto_encontrado WHERE fechaHallazgo >= ?", java.sql.Date.valueOf(LocalDate.now().minusDays(dias)));
    }
    public Map<String, Integer> obtenerObjetosPorCategoria(int dias) throws SQLException {
        return consultarAgrupados("SELECT o.categoria, COUNT(*) FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE oe.fechaHallazgo >= ? GROUP BY o.categoria ORDER BY COUNT(*) DESC", java.sql.Date.valueOf(LocalDate.now().minusDays(dias)));
    }
    public Map<String, Integer> obtenerEncontradosPorMes(int dias, String categoria) throws SQLException {
        List<Object> p = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(oe.fechaHallazgo, '%Y-%m'), COUNT(*) FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE oe.fechaHallazgo IS NOT NULL";
        if (dias > 0) { sql += " AND oe.fechaHallazgo >= ?"; p.add(java.sql.Date.valueOf(LocalDate.now().minusDays(dias))); }
        if (categoria != null && !categoria.trim().isEmpty()) { sql += " AND o.categoria = ?"; p.add(categoria.trim()); }
        return consultarAgrupados(sql + " GROUP BY DATE_FORMAT(oe.fechaHallazgo, '%Y-%m') ORDER BY 1", p.toArray());
    }

    // Filtros para Reporte SAE
    public Map<String, Integer> obtenerCategoriasFiltradas(int anio, String[] meses, String[] categorias) throws SQLException {
        List<Object> p = new ArrayList<>(); p.add(anio);
        String sql = "SELECT o.categoria, COUNT(*) FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE YEAR(oe.fechaHallazgo) = ?";
        sql += filtroMultiple("MONTH(oe.fechaHallazgo)", meses, p) + filtroMultiple("o.categoria", categorias, p);
        return consultarAgrupados(sql + " GROUP BY o.categoria ORDER BY COUNT(*) DESC", p.toArray());
    }
    public Map<String, Integer> obtenerEstadosFiltrados(int anio, String[] meses, String[] estados) throws SQLException {
        return obtenerEstadosFiltrados(anio, meses, estados, null);
    }
    public Map<String, Integer> obtenerEstadosFiltrados(int anio, String[] meses, String[] estados, String[] categorias) throws SQLException {
        List<Object> p = new ArrayList<>(); p.add(anio);
        String fecha = "IF(sr.estado = 'PENDIENTE', sr.fechaSolicitud, sr.fechaResolucion)";
        String sql = "SELECT sr.estado, COUNT(*) FROM solicitud_reclamo sr JOIN objeto_encontrado oe ON oe.idObjetoEncontrado = sr.idObjetoEncontrado JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE YEAR(" + fecha + ") = ?";
        sql += filtroMultiple("MONTH(" + fecha + ")", meses, p) + filtroMultiple("sr.estado", estados, p);
        sql += filtroMultiple("o.categoria", categorias, p);
        return consultarAgrupados(sql + " GROUP BY sr.estado ORDER BY sr.estado", p.toArray());
    }
    public int contarFiltrado(String tabla, int anio, String[] meses) throws SQLException {
        String fecha = switch (tabla) {
            case "objeto_encontrado" -> "fechaHallazgo";
            case "objeto_perdido" -> "fechaPerdida";
            case "coincidencia" -> "fechaGeneracion";
            default -> throw new IllegalArgumentException("Tabla no permitida");
        };
        List<Object> p = new ArrayList<>(); p.add(anio);
        String sql = "SELECT COUNT(*) FROM " + tabla + " WHERE YEAR(" + fecha + ") = ?";
        return contarRegistros(sql + filtroMultiple("MONTH(" + fecha + ")", meses, p), p.toArray());
    }
    public Map<String, Integer> obtenerMesesFiltrados(int anio, String[] meses, String[] categorias) throws SQLException {
        String fecha = "oe.fechaHallazgo", mes = "DATE_FORMAT(oe.fechaHallazgo, '%Y-%m')";
        return agrupadosPorFecha(mes, "FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto", fecha, anio, meses, categorias, "", mes);
    }
    public Map<String, Integer> obtenerAprobadosPorMes(int anio, String[] meses, String[] categorias) throws SQLException {
        String fecha = "sr.fechaResolucion", mes = "DATE_FORMAT(sr.fechaResolucion, '%Y-%m')";
        return agrupadosPorFecha(mes, "FROM solicitud_reclamo sr JOIN objeto_encontrado oe ON oe.idObjetoEncontrado = sr.idObjetoEncontrado JOIN objeto o ON o.idObjeto = oe.idObjeto", fecha, anio, meses, categorias, " AND sr.estado = 'APROBADO'", mes);
    }
    public int contarEncontradosFiltrados(int anio, String[] meses, String[] categorias) throws SQLException {
        return sumar(obtenerCategoriasFiltradas(anio, meses, categorias));
    }
    public int contarPerdidosFiltrados(int anio, String[] meses, String[] categorias) throws SQLException {
        List<Object> p = new ArrayList<>(); p.add(anio);
        String sql = "SELECT o.categoria, COUNT(*) FROM objeto_perdido op JOIN objeto o ON o.idObjeto = op.idObjeto WHERE YEAR(op.fechaPerdida) = ?";
        sql += filtroMultiple("MONTH(op.fechaPerdida)", meses, p) + filtroMultiple("o.categoria", categorias, p);
        return sumar(consultarAgrupados(sql + " GROUP BY o.categoria", p.toArray()));
    }
    public int contarCoincidenciasFiltradas(int anio, String[] meses, String[] categorias) throws SQLException {
        List<Object> p = new ArrayList<>(); p.add(anio);
        String sql = "SELECT o.categoria, COUNT(*) FROM coincidencia c JOIN objeto_perdido op ON op.idObjetoPerdido = c.idObjetoPerdido JOIN objeto o ON o.idObjeto = op.idObjeto WHERE YEAR(c.fechaGeneracion) = ?";
        sql += filtroMultiple("MONTH(c.fechaGeneracion)", meses, p) + filtroMultiple("o.categoria", categorias, p);
        return sumar(consultarAgrupados(sql + " GROUP BY o.categoria", p.toArray()));
    }
    public int contarSolicitudesFiltradas(int anio, String[] meses, String[] estados, String estado) throws SQLException {
        return obtenerEstadosFiltrados(anio, meses, estados).getOrDefault(estado, 0);
    }

    public List<Map<String, String>> obtenerActividadReciente() throws SQLException {
        String sql = "SELECT oe.fechaHallazgo, o.categoria FROM objeto_encontrado oe JOIN objeto o ON o.idObjeto = oe.idObjeto WHERE oe.fechaHallazgo IS NOT NULL ORDER BY oe.fechaHallazgo DESC, oe.idObjetoEncontrado DESC LIMIT 5";
        List<Map<String, String>> actividad = new ArrayList<>();
        try (Connection con = conexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> item = new LinkedHashMap<>();
                item.put("fecha", rs.getDate(1).toString());
                item.put("texto", "Objeto encontrado: " + rs.getString(2));
                actividad.add(item);
            }
        }
        return actividad;
    }
}