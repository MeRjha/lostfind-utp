/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.ObjetoEncontrado;
import Objetos.PersonalSAE;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 *
 * @author Ariana
 */
public class RegistroObjetoEncontradoDAO {
    private Connection con = ConexionBD.getInstancia().getConexion();
    public int registrarObjetoEncontrado(
            PersonalSAE personalSAE,
            ObjetoEncontrado objeto) {

        if (con == null || personalSAE == null || objeto == null) {
            return -1;
        }

        if (personalSAE.getSede() == null
                || objeto.getFechaHallazgo() == null
                || objeto.getImagen() == null
                || objeto.getImagen().trim().isEmpty()) {
            return -1;
        }

        boolean autocommitOriginal = true;

        try {
            autocommitOriginal = con.getAutoCommit();
            con.setAutoCommit(false);

            int idObjeto;

            String sqlObjeto = "INSERT INTO objeto "
                    + "(idSede, imagen, categoria, nombre, color, "
                    + "marca, descripcion, lugarReferencia, fechaRegistro, estado) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE, ?)";

            try (PreparedStatement ps = con.prepareStatement(
                    sqlObjeto, PreparedStatement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, personalSAE.getSede().getIdSede());
                ps.setString(2, objeto.getImagen());
                ps.setString(3, objeto.getCategoria());
                ps.setString(4, objeto.getNombre());
                ps.setString(5, objeto.getColor());
                ps.setString(6, objeto.getMarca());
                ps.setString(7, objeto.getDescripcion());
                ps.setString(8, objeto.getLugarReferencia());
                ps.setString(9, "Disponible para coincidencia");

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        con.rollback();
                        return -1;
                    }

                    idObjeto = rs.getInt(1);
                }
            }

            String sqlEncontrado = "INSERT INTO objeto_encontrado "
                    + "(idObjeto, idPersonalSAE, fechaHallazgo) "
                    + "VALUES (?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sqlEncontrado)) {

                ps.setInt(1, idObjeto);
                ps.setInt(2, personalSAE.getIdUsuario());
                ps.setDate(3, new java.sql.Date(
                        objeto.getFechaHallazgo().getTime()));

                ps.executeUpdate();
            }

            con.commit();

            objeto.setIdObjeto(idObjeto);

            return idObjeto;

        } catch (SQLException e) {

            try {
                con.rollback();
            } catch (SQLException ex) {
                System.out.println("Error al deshacer registro: " + ex);
            }

            System.out.println("Error al registrar objeto encontrado: " + e);
            return -1;

        } finally {

            try {
                con.setAutoCommit(autocommitOriginal);
            } catch (SQLException e) {
                System.out.println("Error al restaurar conexión: " + e);
            }
        }
    }
    
    
    public int registrarObjetoEncontrado(
            PersonalSAE personalSAE,
            ObjetoEncontrado objeto,
            int idSede) {

        Connection conexion = ConexionBD.getInstancia().getConexion();

        if (conexion == null || personalSAE == null || objeto == null
                || idSede <= 0) {
            return -1;
        }

        if (objeto.getNombre() == null || objeto.getNombre().trim().isEmpty()
                || objeto.getCategoria() == null || objeto.getCategoria().trim().isEmpty()
                || objeto.getFechaHallazgo() == null
                || objeto.getLugarReferencia() == null || objeto.getLugarReferencia().trim().isEmpty()
                || objeto.getDescripcion() == null || objeto.getDescripcion().trim().isEmpty()
                || objeto.getImagen() == null || objeto.getImagen().trim().isEmpty()) {
            return -1;
        }

        if (objeto.getNombre().length() > 100
                || objeto.getCategoria().length() > 50
                || objeto.getColor() != null && objeto.getColor().length() > 50
                || objeto.getMarca() != null && objeto.getMarca().length() > 50
                || objeto.getDescripcion().length() > 255
                || objeto.getLugarReferencia().length() > 150
                || objeto.getImagen().length() > 100) {
            return -1;
        }

        boolean autocommitOriginal = true;

        try {
            autocommitOriginal = conexion.getAutoCommit();
            conexion.setAutoCommit(false);

            int idObjeto;

            String sqlObjeto = "INSERT INTO objeto "
                    + "(idSede, imagen, categoria, nombre, color, "
                    + "marca, descripcion, lugarReferencia, fechaRegistro, estado) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE, ?)";

            try (PreparedStatement ps = conexion.prepareStatement(
                    sqlObjeto, PreparedStatement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, idSede);
                ps.setString(2, objeto.getImagen());
                ps.setString(3, objeto.getCategoria());
                ps.setString(4, objeto.getNombre());
                ps.setString(5, objeto.getColor());
                ps.setString(6, objeto.getMarca());
                ps.setString(7, objeto.getDescripcion());
                ps.setString(8, objeto.getLugarReferencia());
                ps.setString(9, "Disponible para coincidencia");

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        conexion.rollback();
                        return -1;
                    }

                    idObjeto = rs.getInt(1);
                }
            }

            String sqlEncontrado = "INSERT INTO objeto_encontrado "
                    + "(idObjeto, idPersonalSAE, fechaHallazgo) "
                    + "VALUES (?, ?, ?)";

            try (PreparedStatement ps = conexion.prepareStatement(sqlEncontrado)) {

                ps.setInt(1, idObjeto);
                ps.setInt(2, personalSAE.getIdUsuario());
                ps.setDate(3, new java.sql.Date(
                        objeto.getFechaHallazgo().getTime()));

                ps.executeUpdate();
            }

            conexion.commit();

            objeto.setIdObjeto(idObjeto);

            return idObjeto;

        } catch (SQLException e) {

            try {
                conexion.rollback();
            } catch (SQLException ex) {
                System.out.println("Error al deshacer registro: " + ex);
            }

            System.out.println("Error al registrar objeto encontrado: " + e);
            return -1;

        } finally {

            try {
                conexion.setAutoCommit(autocommitOriginal);
            } catch (SQLException e) {
                System.out.println("Error al restaurar conexión: " + e);
            }
        }
    }
}
