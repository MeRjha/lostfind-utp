/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.EvidenciaReclamo;
import Objetos.SolicitudReclamo;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Ariana
 */
public class SolicitudReclamoDAO {
    private final String CONSULTA_BASE =
        "SELECT sr.idSolicitud, sr.idObjetoEncontrado, " +
        "o.idObjeto, sr.idUsuario, sr.fechaSolicitud, " +
        "sr.sustentoPropiedad, sr.estado, sr.motivoRechazo," +
        "o.nombre AS nombreObjeto, o.categoria, o.imagen, " +
        "u.nombre AS nombreEstudiante, u.apellido AS apellidoEstudiante, " +
        "u.correoInstitucional, " +
        "sUsuario.nombre AS sedeEstudiante, " +
        "sObjeto.nombre AS sedeObjeto " +
        "FROM solicitud_reclamo sr " +
        "INNER JOIN objeto_encontrado oe " +
        "ON sr.idObjetoEncontrado = oe.idObjetoEncontrado " +
        "INNER JOIN objeto o ON oe.idObjeto = o.idObjeto " +
        "INNER JOIN usuario u ON sr.idUsuario = u.idUsuario " +
        "LEFT JOIN sede sUsuario ON u.idSede = sUsuario.idSede " +
        "LEFT JOIN sede sObjeto ON o.idSede = sObjeto.idSede ";

    private SolicitudReclamo mapearSolicitud(ResultSet rs)
            throws SQLException {

        SolicitudReclamo solicitud = new SolicitudReclamo();

        solicitud.setIdSolicitud(rs.getInt("idSolicitud"));
        solicitud.setIdObjetoEncontrado(rs.getInt("idObjetoEncontrado"));
        solicitud.setIdObjeto(rs.getInt("idObjeto"));
        solicitud.setIdUsuario(rs.getInt("idUsuario"));

        solicitud.setFechaSolicitud(rs.getDate("fechaSolicitud"));
        solicitud.setSustentoPropiedad(rs.getString("sustentoPropiedad"));
        solicitud.setEstado(rs.getString("estado"));
        solicitud.setMotivoRechazo(rs.getString("motivoRechazo"));

        solicitud.setNombreObjeto(rs.getString("nombreObjeto"));
        solicitud.setCategoria(rs.getString("categoria"));
        solicitud.setImagen(rs.getString("imagen"));

        solicitud.setNombreEstudiante(rs.getString("nombreEstudiante"));
        solicitud.setApellidoEstudiante(rs.getString("apellidoEstudiante"));
        solicitud.setCorreoInstitucional(rs.getString("correoInstitucional"));

        solicitud.setSedeEstudiante(rs.getString("sedeEstudiante"));
        solicitud.setSedeObjeto(rs.getString("sedeObjeto"));

        return solicitud;
    }

    public List<SolicitudReclamo> listarSolicitudes(
            String estado, String categoria, Date fecha, String busqueda) {

        List<SolicitudReclamo> lista = new ArrayList<>();

        String sql = CONSULTA_BASE +
            "WHERE (? IS NULL OR sr.estado = ?) " +
            "AND (? IS NULL OR o.categoria = ?) " +
            "AND (? IS NULL OR sr.fechaSolicitud = ?) " +
            "AND (? = '' OR CAST(sr.idSolicitud AS CHAR) LIKE CONCAT('%', ?, '%') " +
            "OR o.nombre LIKE CONCAT('%', ?, '%') " +
            "OR u.nombre LIKE CONCAT('%', ?, '%') " +
            "OR u.apellido LIKE CONCAT('%', ?, '%')) " +
            "ORDER BY sr.fechaSolicitud DESC, sr.idSolicitud DESC";

        try {
            Connection con = ConexionBD.getInstancia().getConexion();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                if (estado == null || estado.trim().isEmpty()) {
                    ps.setNull(1, Types.VARCHAR);
                    ps.setNull(2, Types.VARCHAR);
                } else {
                    ps.setString(1, estado);
                    ps.setString(2, estado);
                }

                if (categoria == null || categoria.trim().isEmpty()) {
                    ps.setNull(3, Types.VARCHAR);
                    ps.setNull(4, Types.VARCHAR);
                } else {
                    ps.setString(3, categoria);
                    ps.setString(4, categoria);
                }

                if (fecha == null) {
                    ps.setNull(5, Types.DATE);
                    ps.setNull(6, Types.DATE);
                } else {
                    ps.setDate(5, fecha);
                    ps.setDate(6, fecha);
                }

                String texto = (busqueda == null) ? "" : busqueda.trim();

                ps.setString(7, texto);
                ps.setString(8, texto);
                ps.setString(9, texto);
                ps.setString(10, texto);
                ps.setString(11, texto);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        lista.add(mapearSolicitud(rs));
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al listar solicitudes: " + e.getMessage());
        }

        return lista;
    }

    public SolicitudReclamo obtenerSolicitudPorId(int idSolicitud) {

        String sql = CONSULTA_BASE + "WHERE sr.idSolicitud = ?";

        try {
            Connection con = ConexionBD.getInstancia().getConexion();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idSolicitud);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return mapearSolicitud(rs);
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener solicitud: " + e.getMessage());
        }

        return null;
    }
    
    public boolean actualizarEstado(int idSolicitud, String nuevoEstado,
                                    int idPersonalSAE, String motivoRechazo) {

        if (!"APROBADO".equalsIgnoreCase(nuevoEstado)
                && !"RECHAZADO".equalsIgnoreCase(nuevoEstado)) {
            return false;
        }

        // Si se rechaza, el motivo es obligatorio.
        if ("RECHAZADO".equalsIgnoreCase(nuevoEstado)) {

            if (motivoRechazo == null || motivoRechazo.trim().isEmpty()) {
                return false;
            }

            motivoRechazo = motivoRechazo.trim();

            if (motivoRechazo.length() > 500) {
                return false;
            }

        } else {
            // Si se aprueba, no debe existir motivo de rechazo.
            motivoRechazo = null;
        }

        String sql = "UPDATE solicitud_reclamo "
                   + "SET estado = ?, idPersonalSAE = ?, motivoRechazo = ? "
                   + "WHERE idSolicitud = ? AND estado = 'PENDIENTE'";

        try {
            Connection con = ConexionBD.getInstancia().getConexion();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, nuevoEstado.toUpperCase());
                ps.setInt(2, idPersonalSAE);
                ps.setString(3, motivoRechazo);
                ps.setInt(4, idSolicitud);

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error al actualizar solicitud: " + e.getMessage());
            return false;
        }
    }
    
    public List<EvidenciaReclamo> listarEvidenciasPorSolicitud(int idSolicitud) {

        List<EvidenciaReclamo> evidencias = new ArrayList<>();

        String sql = "SELECT idEvidencia, idSolicitud, urlArchivo, fechaSubida "
                   + "FROM evidencia_reclamo "
                   + "WHERE idSolicitud = ? "
                   + "ORDER BY fechaSubida ASC";

        try {
            Connection con = ConexionBD.getInstancia().getConexion();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idSolicitud);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        EvidenciaReclamo evidencia = new EvidenciaReclamo();

                        evidencia.setIdEvidencia(rs.getInt("idEvidencia"));
                        evidencia.setIdSolicitud(rs.getInt("idSolicitud"));
                        evidencia.setUrlArchivo(rs.getString("urlArchivo"));
                        evidencia.setFechaSubida(rs.getDate("fechaSubida"));

                        evidencias.add(evidencia);
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al listar evidencias: " + e.getMessage());
        }

        return evidencias;
    }
}
