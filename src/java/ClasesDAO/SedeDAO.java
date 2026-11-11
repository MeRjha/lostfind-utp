/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Sede;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Ariana
 */
public class SedeDAO {
    public List<Sede> obtenerSedes() {

        List<Sede> sedes = new ArrayList<>();

        String sql = "SELECT idSede, nombre, ubicacion "
                   + "FROM sede ORDER BY nombre";

        try {
            Connection con = ConexionBD.getInstancia().getConexion();

            if (con == null) {
                System.out.println("No hay conexión con la BD.");
                return sedes;
            }

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Sede sede = new Sede(
                        rs.getInt("idSede"),
                        rs.getString("nombre"),
                        rs.getString("ubicacion")
                    );

                    sedes.add(sede);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al consultar sedes: " + e);
        }

        return sedes;
    }
}
