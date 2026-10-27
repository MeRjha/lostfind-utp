/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Objeto;
import Objetos.ObjetoEncontrado;
import Objetos.ObjetoPerdido;
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
public class ObjetoPerdidoDAO {

    private Connection con = ConexionBD.getInstancia().getConexion();

    public String crearObjetoPerdido(int idUsuario, ObjetoPerdido objeto) {
        try {
            PreparedStatement ps;
            ps = con.prepareStatement("INSERT INTO objeto_perdido (idObjeto, idUsuario, fechaPerdida) VALUES (?, ?,?);", Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, objeto.getIdObjeto());
            ps.setInt(2, idUsuario);
            ps.setDate(3, new java.sql.Date(objeto.getFechaPerdida().getTime()));
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                objeto.setIdObjeto(rs.getInt(1));
            }
            return "Objeto perdido creado con exito";
        } catch (SQLException e) {
            System.out.println(e);

        }
        return "Objeto perdido fallido. Intente nuevamente";
    }

    public List<ObjetoPerdido> obtenerObjetosPerdidos(int idUsuario) {
        try {
            List<ObjetoPerdido> objetosPerdidos = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select o.idObjeto, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,op.fechaPerdida from objeto as o inner join objeto_perdido as op on o.idObjeto=op.idObjeto where op.idUsuario=? order by o.fechaRegistro asc;");
            ps.setInt(1, idUsuario);
            res = ps.executeQuery();
            while (res.next()) {
                int idObjeto = res.getInt("o.idObjeto");
                String imagen = res.getString("o.imagen");
                String categoria = res.getString("o.categoria");
                String nombre = res.getString("o.nombre");
                String color = res.getString("o.color");
                String marca = res.getString("o.marca");
                String descripcion = res.getString("o.descripcion");
                String lugarReferencia = res.getString("o.lugarReferencia");
                Date fechaRegistro = res.getDate("o.fechaRegistro");
                String estado = res.getString("o.estado");
                Date fechaPerdida = res.getDate("op.fechaPerdida");
                ObjetoPerdido objetoPerdido = new ObjetoPerdido(fechaPerdida, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoPerdido.setFechaRegistro(fechaRegistro);
                objetoPerdido.setIdObjeto(idObjeto);
                objetosPerdidos.add(objetoPerdido);
            }
            return objetosPerdidos;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }

    public ObjetoPerdido obtenerObjetoPerdido(int idObjetoPerdido) {
        try {
            ObjetoPerdido objetoPerdido = null;
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select op.idObjetoPerdido, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,op.fechaPerdida from objeto as o inner join objeto_perdido as op on o.idObjeto=op.idObjeto where op.idObjetoPerdido=? order by o.fechaRegistro asc;");
            ps.setInt(1, idObjetoPerdido);
            res = ps.executeQuery();
            if (res.next()) {
                int idObjeto = res.getInt("op.idObjetoPerdido");
                String imagen = res.getString("o.imagen");
                String categoria = res.getString("o.categoria");
                String nombre = res.getString("o.nombre");
                String color = res.getString("o.color");
                String marca = res.getString("o.marca");
                String descripcion = res.getString("o.descripcion");
                String lugarReferencia = res.getString("o.lugarReferencia");
                Date fechaRegistro = res.getDate("o.fechaRegistro");
                String estado = res.getString("o.estado");
                Date fechaPerdida = res.getDate("op.fechaPerdida");
                objetoPerdido = new ObjetoPerdido(fechaPerdida, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoPerdido.setFechaRegistro(fechaRegistro);
                objetoPerdido.setIdObjeto(idObjeto);
            }
            return objetoPerdido;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }
}
