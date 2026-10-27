/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Objeto;
import Objetos.ObjetoPerdido;
import Objetos.Usuario;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Axel
 */
public class ObjetoDAO {
    
    private Connection con = ConexionBD.getInstancia().getConexion();
    
    public String crearObjeto(Usuario usuario, Objeto objeto) {
        try {
            PreparedStatement ps;
            ps = con.prepareStatement("INSERT INTO objeto (idSede, imagen,categoria, nombre, color, marca, descripcion, lugarReferencia, estado) VALUES (?,?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, usuario.getSede().getIdSede());
            ps.setString(2, objeto.getImagen());
            ps.setString(3, objeto.getCategoria());
            ps.setString(4, objeto.getNombre());
            ps.setString(5, objeto.getColor());
            ps.setString(6, objeto.getMarca());
            ps.setString(7, objeto.getDescripcion());
            ps.setString(8, objeto.getLugarReferencia());
            ps.setString(9, objeto.getEstado());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                objeto.setIdObjeto(rs.getInt(1));
            }
            return "Objeto creado";
        } catch (SQLException e) {
            System.out.println(e);
            
        }
        return null;
    }
}
