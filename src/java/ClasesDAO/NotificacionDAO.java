/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

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
}
