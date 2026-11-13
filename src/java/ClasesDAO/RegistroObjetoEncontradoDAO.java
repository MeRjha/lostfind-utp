package ClasesDAO;

import Objetos.ObjetoEncontrado;
import Objetos.PersonalSAE;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegistroObjetoEncontradoDAO {

    public int registrarObjetoEncontrado(PersonalSAE personalSAE, ObjetoEncontrado objeto) {
        if (personalSAE == null || personalSAE.getSede() == null) return -1;
        return registrarObjetoEncontrado(personalSAE, objeto, personalSAE.getSede().getIdSede());
    }

    public int registrarObjetoEncontrado(PersonalSAE personalSAE, ObjetoEncontrado objeto, int idSede) {
        if (personalSAE == null || objeto == null || idSede <= 0 || personalSAE.getIdUsuario() <= 0
                || vacio(objeto.getNombre()) || vacio(objeto.getCategoria())
                || objeto.getFechaHallazgo() == null || vacio(objeto.getLugarReferencia())
                || vacio(objeto.getDescripcion()) || vacio(objeto.getImagen())) return -1;

        if (objeto.getNombre().length() > 100 || objeto.getCategoria().length() > 50
                || longitud(objeto.getColor()) > 50 || longitud(objeto.getMarca()) > 50
                || objeto.getDescripcion().length() > 255 || objeto.getLugarReferencia().length() > 150
                || objeto.getImagen().length() > 100) return -1;

        try (Connection con = ConexionBD.getInstancia().getConexionNueva()) {
            if (con == null) return -1;
            con.setAutoCommit(false);
            try {
                int idObjeto;
                String sql = "INSERT INTO objeto (idSede, imagen, categoria, nombre, color, marca, "
                        + "descripcion, lugarReferencia, fechaRegistro, estado) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, idSede);
                    ps.setString(2, objeto.getImagen());
                    ps.setString(3, objeto.getCategoria());
                    ps.setString(4, objeto.getNombre());
                    ps.setString(5, objeto.getColor());
                    ps.setString(6, objeto.getMarca());
                    ps.setString(7, objeto.getDescripcion());
                    ps.setString(8, objeto.getLugarReferencia());
                    ps.setString(9, "Disponible para coincidencia");
                    if (ps.executeUpdate() != 1) { con.rollback(); return -1; }
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) { con.rollback(); return -1; }
                        idObjeto = rs.getInt(1);
                    }
                }

                sql = "INSERT INTO objeto_encontrado (idObjeto, idPersonalSAE, fechaHallazgo) VALUES (?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, idObjeto);
                    ps.setInt(2, personalSAE.getIdUsuario());
                    ps.setDate(3, new java.sql.Date(objeto.getFechaHallazgo().getTime()));
                    if (ps.executeUpdate() != 1) { con.rollback(); return -1; }
                }
                con.commit();
                objeto.setIdObjeto(idObjeto);
                return idObjeto;
            } catch (SQLException e) {
                try { con.rollback(); } catch (SQLException ex) { e.addSuppressed(ex); }
                throw e;
            }
        } catch (SQLException e) {
            System.out.println("Error al registrar objeto encontrado: " + e);
            return -1;
        }
    }

    private boolean vacio(String valor) { return valor == null || valor.trim().isEmpty(); }
    private int longitud(String valor) { return valor == null ? 0 : valor.length(); }
}
