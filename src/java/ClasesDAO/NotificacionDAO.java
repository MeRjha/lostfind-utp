/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
/**
 *
 * @author Ariana
 */
public class NotificacionDAO {
    public boolean registrarNotificacion(int idUsuario, String mensaje) {

        if (idUsuario <= 0 || mensaje == null || mensaje.trim().isEmpty()) {
            return false;
        }

        String sql = "INSERT INTO notificacion "
                   + "(idUsuario, mensaje, fechaEnvio, leida) "
                   + "VALUES (?, ?, CURRENT_DATE(), FALSE)";

        try {
            Connection con = ConexionBD.getInstancia().getConexion();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idUsuario);
                ps.setString(2, mensaje.trim());

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error al registrar notificación: " + e.getMessage());
            return false;
        }
    }
    
        public List<Map<String, Object>> listarPorUsuario(int idUsuario, int limite) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT idNotificacion, mensaje, fechaEnvio, leida FROM notificacion "
                   + "WHERE idUsuario = ? ORDER BY idNotificacion DESC LIMIT ?";
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> n = new LinkedHashMap<>();
                    n.put("idNotificacion", rs.getInt("idNotificacion"));
                    n.put("mensaje", rs.getString("mensaje"));
                    n.put("fechaEnvio", String.valueOf(rs.getDate("fechaEnvio")));
                    n.put("leida", rs.getBoolean("leida"));
                    lista.add(n);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar notificaciones: " + e.getMessage());
        }
        return lista;
    }

    public int contarNoLeidas(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM notificacion WHERE idUsuario = ? AND leida = FALSE";
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            System.out.println("Error al contar notificaciones: " + e.getMessage());
            return 0;
        }
    }

    public boolean marcarLeidas(int idUsuario) {
        String sql = "UPDATE notificacion SET leida = TRUE WHERE idUsuario = ? AND leida = FALSE";
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error al marcar notificaciones: " + e.getMessage());
            return false;
        }
    }
}
