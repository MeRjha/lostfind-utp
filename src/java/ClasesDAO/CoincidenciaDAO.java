/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Coincidencia;
import Objetos.Objeto;
import Objetos.ObjetoEncontrado;
import Objetos.ObjetoPerdido;
import Objetos.Reporte;
import Objetos.Usuario;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Axel
 */
public class CoincidenciaDAO {

    private Connection con = ConexionBD.getInstancia().getConexion();

    public String crearCoincidencia(Coincidencia coincidencia) {
        try {
            PreparedStatement ps;
            ps = con.prepareStatement("INSERT INTO coincidencia (idObjetoPerdido, idObjetoEncontrado, porcentajeSimilitud) VALUES (?,?,?);", Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, coincidencia.getObjetoPerdido().getIdObjeto());
            ps.setInt(2, coincidencia.getObjetoEncontrado().getIdObjeto());
            ps.setDouble(3, coincidencia.getPorcentajeSimilitud());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                coincidencia.setIdCoincidencia(rs.getInt(1));
            }
            System.out.println("Coincidencia Creadaaa");
            return "Coincidencia creadas";
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }

    public List<Coincidencia> obtenerCoincidenciasDeUnObjetoPerdido(ObjetoPerdido objetoPerdido) {
        try {
            List<Coincidencia> coincidencias = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("SELECT oe.idObjetoEncontrado, o.imagen, o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado, oe.fechaHallazgo, c.porcentajeSimilitud,c.fechaGeneracion FROM objeto_perdido AS op INNER JOIN coincidencia AS c ON c.idObjetoPerdido = op.idObjetoPerdido INNER JOIN objeto_encontrado AS oe ON oe.idObjetoEncontrado = c.idObjetoEncontrado INNER JOIN objeto AS o ON o.idObjeto = oe.idObjeto WHERE op.idObjetoPerdido = ? ORDER BY o.fechaRegistro DESC;");
            ps.setInt(1, objetoPerdido.getIdObjeto());
            res = ps.executeQuery();
            while (res.next()) {
                int idObjeto = res.getInt("oe.idObjetoEncontrado");
                String imagen = res.getString("o.imagen");
                String categoria = res.getString("o.categoria");
                String nombre = res.getString("o.nombre");
                String color = res.getString("o.color");
                String marca = res.getString("o.marca");
                String descripcion = res.getString("o.descripcion");
                String lugarReferencia = res.getString("o.lugarReferencia");
                Date fechaRegistro = res.getDate("o.fechaRegistro");
                String estado = res.getString("o.estado");
                Date fechaHallazgo = res.getDate("oe.fechaHallazgo");
                double porcentajeSimilitud = res.getDouble("c.porcentajeSimilitud");
                Date fechaGeneracion = res.getDate("c.fechaGeneracion");
                ObjetoEncontrado objeto = new ObjetoEncontrado(fechaHallazgo, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objeto.setFechaRegistro(fechaRegistro);
                objeto.setIdObjeto(idObjeto);
                coincidencias.add(new Coincidencia(objetoPerdido, objeto, porcentajeSimilitud, fechaGeneracion));
            }
            return coincidencias;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }
}
