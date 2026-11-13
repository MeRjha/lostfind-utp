package ClasesDAO;

import Objetos.EvidenciaReclamo;
import Objetos.SolicitudReclamo;
import Singlenton.ConexionBD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class SolicitudReclamoDAO {
    private static final String CONSULTA_BASE =
        "SELECT sr.idSolicitud, sr.idObjetoEncontrado, o.idObjeto, sr.idUsuario, sr.fechaSolicitud, " +
        "sr.sustentoPropiedad, sr.estado, sr.motivoRechazo, o.nombre AS nombreObjeto, o.categoria, o.imagen, " +
        "u.nombre AS nombreEstudiante, u.apellido AS apellidoEstudiante, u.correoInstitucional, " +
        "sUsuario.nombre AS sedeEstudiante, sObjeto.nombre AS sedeObjeto " +
        "FROM solicitud_reclamo sr JOIN objeto_encontrado oe ON sr.idObjetoEncontrado = oe.idObjeto " +
        "JOIN objeto o ON oe.idObjeto = o.idObjeto JOIN usuario u ON sr.idUsuario = u.idUsuario " +
        "LEFT JOIN sede sUsuario ON u.idSede = sUsuario.idSede " +
        "LEFT JOIN sede sObjeto ON o.idSede = sObjeto.idSede ";

    private SolicitudReclamo mapearSolicitud(ResultSet rs) throws SQLException {
        SolicitudReclamo s = new SolicitudReclamo();
        s.setIdSolicitud(rs.getInt("idSolicitud"));
        s.setIdObjetoEncontrado(rs.getInt("idObjetoEncontrado"));
        s.setIdObjeto(rs.getInt("idObjeto"));
        s.setIdUsuario(rs.getInt("idUsuario"));
        s.setFechaSolicitud(rs.getDate("fechaSolicitud"));
        s.setSustentoPropiedad(rs.getString("sustentoPropiedad"));
        s.setEstado(rs.getString("estado"));
        s.setMotivoRechazo(rs.getString("motivoRechazo"));
        s.setNombreObjeto(rs.getString("nombreObjeto"));
        s.setCategoria(rs.getString("categoria"));
        s.setImagen(rs.getString("imagen"));
        s.setNombreEstudiante(rs.getString("nombreEstudiante"));
        s.setApellidoEstudiante(rs.getString("apellidoEstudiante"));
        s.setCorreoInstitucional(rs.getString("correoInstitucional"));
        s.setSedeEstudiante(rs.getString("sedeEstudiante"));
        s.setSedeObjeto(rs.getString("sedeObjeto"));
        return s;
    }

    public List<SolicitudReclamo> listarSolicitudes(String estado, String categoria, Date fecha, String busqueda) {
        List<SolicitudReclamo> lista = new ArrayList<>();
        String sql = CONSULTA_BASE + "WHERE (? IS NULL OR sr.estado = ?) AND (? IS NULL OR o.categoria = ?) " +
            "AND (? IS NULL OR sr.fechaSolicitud = ?) AND (? = '' OR CAST(sr.idSolicitud AS CHAR) LIKE CONCAT('%', ?, '%') " +
            "OR o.nombre LIKE CONCAT('%', ?, '%') OR u.nombre LIKE CONCAT('%', ?, '%') " +
            "OR u.apellido LIKE CONCAT('%', ?, '%')) ORDER BY sr.fechaSolicitud DESC, sr.idSolicitud DESC";
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String e = estado == null || estado.trim().isEmpty() ? null : estado;
            String c = categoria == null || categoria.trim().isEmpty() ? null : categoria;
            String b = busqueda == null ? "" : busqueda.trim();
            ps.setString(1, e); ps.setString(2, e);
            ps.setString(3, c); ps.setString(4, c);
            ps.setDate(5, fecha); ps.setDate(6, fecha);
            for (int i = 7; i <= 11; i++) ps.setString(i, b);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapearSolicitud(rs));
            }
        } catch (SQLException ex) { System.out.println("Error al listar solicitudes: " + ex.getMessage()); }
        return lista;
    }

    public SolicitudReclamo obtenerSolicitudPorId(int idSolicitud) {
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(CONSULTA_BASE + "WHERE sr.idSolicitud = ?")) {
            ps.setInt(1, idSolicitud);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearSolicitud(rs);
            }
        } catch (SQLException ex) { System.out.println("Error al obtener solicitud: " + ex.getMessage()); }
        return null;
    }

    public boolean actualizarEstado(int idSolicitud, String nuevoEstado, int idPersonalSAE, String motivoRechazo) {
        if (idSolicitud <= 0 || idPersonalSAE <= 0 || nuevoEstado == null ||
            (!"APROBADO".equalsIgnoreCase(nuevoEstado) && !"RECHAZADO".equalsIgnoreCase(nuevoEstado))) return false;
        nuevoEstado = nuevoEstado.toUpperCase(Locale.ROOT);
        if ("RECHAZADO".equals(nuevoEstado)) {
            if (motivoRechazo == null || motivoRechazo.trim().isEmpty() || motivoRechazo.trim().length() > 500) return false;
            motivoRechazo = motivoRechazo.trim();
        } else motivoRechazo = null;

        try (Connection con = ConexionBD.getInstancia().getConexionNueva()) {
            con.setAutoCommit(false);
            try {
                int idUsuario, idObjetoEncontrado;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT idUsuario, idObjetoEncontrado, estado FROM solicitud_reclamo WHERE idSolicitud = ? FOR UPDATE")) {
                    ps.setInt(1, idSolicitud);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next() || !"PENDIENTE".equalsIgnoreCase(rs.getString("estado"))) {
                            con.rollback(); return false;
                        }
                        idUsuario = rs.getInt("idUsuario");
                        idObjetoEncontrado = rs.getInt("idObjetoEncontrado");
                    }
                }
                if ("APROBADO".equals(nuevoEstado)) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "SELECT idObjetoEncontrado FROM objeto_encontrado WHERE idObjetoEncontrado = ? FOR UPDATE")) {
                        ps.setInt(1, idObjetoEncontrado);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) { con.rollback(); return false; }
                        }
                    }
                    try (PreparedStatement ps = con.prepareStatement(
                            "SELECT COUNT(*) FROM solicitud_reclamo WHERE idObjetoEncontrado = ? AND estado = 'APROBADO'")) {
                        ps.setInt(1, idObjetoEncontrado);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next() && rs.getInt(1) > 0) { con.rollback(); return false; }
                        }
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE solicitud_reclamo SET estado = ?, idPersonalSAE = ?, motivoRechazo = ?, " +
                        "fechaResolucion = NOW() WHERE idSolicitud = ? AND estado = 'PENDIENTE'")) {
                    ps.setString(1, nuevoEstado); ps.setInt(2, idPersonalSAE);
                    ps.setString(3, motivoRechazo); ps.setInt(4, idSolicitud);
                    if (ps.executeUpdate() != 1) { con.rollback(); return false; }
                }
                String mensaje = "APROBADO".equals(nuevoEstado)
                    ? "Tu solicitud de reclamo #" + idSolicitud + " fue aprobada por el personal SAE."
                    : "Tu solicitud de reclamo #" + idSolicitud + " fue rechazada. Revisa el motivo en el detalle de tu solicitud.";
                try (PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO notificacion (idUsuario, mensaje, fechaEnvio, leida) VALUES (?, ?, CURRENT_DATE(), FALSE)")) {
                    ps.setInt(1, idUsuario); ps.setString(2, mensaje);
                    if (ps.executeUpdate() != 1) { con.rollback(); return false; }
                }
                con.commit();
                return true;
            } catch (SQLException ex) {
                try { con.rollback(); } catch (SQLException rollbackError) { ex.addSuppressed(rollbackError); }
                throw ex;
            }
        } catch (SQLException ex) {
            System.out.println("Error procesando reclamo SAE: " + ex.getMessage());
            return false;
        }
    }

    public List<EvidenciaReclamo> listarEvidenciasPorSolicitud(int idSolicitud) {
        List<EvidenciaReclamo> lista = new ArrayList<>();
        String sql = "SELECT idEvidencia, idSolicitud, urlArchivo, fechaSubida FROM evidencia_reclamo " +
                     "WHERE idSolicitud = ? ORDER BY fechaSubida ASC";
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idSolicitud);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EvidenciaReclamo e = new EvidenciaReclamo();
                    e.setIdEvidencia(rs.getInt("idEvidencia"));
                    e.setIdSolicitud(rs.getInt("idSolicitud"));
                    e.setUrlArchivo(rs.getString("urlArchivo"));
                    e.setFechaSubida(rs.getDate("fechaSubida"));
                    lista.add(e);
                }
            }
        } catch (SQLException ex) { System.out.println("Error al listar evidencias: " + ex.getMessage()); }
        return lista;
    }
}
