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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Axel
 */
public class ObjetosEncontradosDAO {

    private Connection con = ConexionBD.getInstancia().getConexion();

    public List<ObjetoEncontrado> obtenerObjetos(int idSede) {
        try {
            List<ObjetoEncontrado> objetosEncontrados = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select o.idObjeto, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,oe.fechaHallazgo from objeto as o inner join objeto_encontrado as oe on o.idObjeto=oe.idObjeto where idSede=?;");
            ps.setInt(1, idSede);
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
                Date fechaHallazgo = res.getDate("oe.fechaHallazgo");
                ObjetoEncontrado objetoEncontrado = new ObjetoEncontrado(fechaHallazgo, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoEncontrado.setFechaRegistro(fechaRegistro);
                objetoEncontrado.setIdObjeto(idObjeto);
                objetosEncontrados.add(objetoEncontrado);
            }
            return objetosEncontrados;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }

    public List<ObjetoEncontrado> obtenerObjetosRecientes(int idSede) {
        try {
            List<ObjetoEncontrado> objetosEncontrados = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select o.idObjeto, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,oe.fechaHallazgo from objeto as o inner join objeto_encontrado as oe on o.idObjeto=oe.idObjeto where o.idSede=? order by oe.fechaHallazgo desc limit 4;");
            ps.setInt(1, idSede);
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
                Date fechaHallazgo = res.getDate("oe.fechaHallazgo");
                ObjetoEncontrado objetoEncontrado = new ObjetoEncontrado(fechaHallazgo, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoEncontrado.setFechaRegistro(fechaRegistro);
                objetoEncontrado.setIdObjeto(idObjeto);
                objetosEncontrados.add(objetoEncontrado);
            }
            return objetosEncontrados;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }

    public String crearObjetoEncontrado(Usuario usuario, ObjetoPerdido objetoPerdido) {
        try {
            PreparedStatement ps;
            ps = con.prepareStatement("INSERT INTO reporte_objeto_perdido (idUsuario, idObjetoPerdido, estado) VALUES (?, ?,?);");
            ps.setInt(1, usuario.getIdUsuario());
            ps.setInt(2, objetoPerdido.getIdObjeto());
            ps.setString(3, "🕒 En búsqueda");
            ps.executeUpdate();
            return "Reporte realizado con exito";
        } catch (SQLException e) {
            System.out.println(e);

        }
        return "Reporte fallido. Intente nuevamente";
    }

    public List<ObjetoEncontrado> obtenerObjetosEncontradosSimilares(ObjetoPerdido objetoPerdido) {
        try {
            List<ObjetoEncontrado> objetosEncontrados = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select o.idObjeto, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,oe.fechaHallazgo from objeto as o inner join objeto_encontrado as oe on o.idObjeto=oe.idObjeto where o.categoria=? and o.nombre=?;");
            ps.setString(1, objetoPerdido.getCategoria());
            ps.setString(2, objetoPerdido.getNombre());
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
                Date fechaHallazgo = res.getDate("oe.fechaHallazgo");
                ObjetoEncontrado objetoEncontrado = new ObjetoEncontrado(fechaHallazgo, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoEncontrado.setFechaRegistro(fechaRegistro);
                objetoEncontrado.setIdObjeto(idObjeto);
                objetosEncontrados.add(objetoEncontrado);
            }
            return objetosEncontrados;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }
}
