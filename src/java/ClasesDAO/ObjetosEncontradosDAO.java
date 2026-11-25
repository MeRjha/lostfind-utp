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
            ps = con.prepareStatement("select oe.idObjetoEncontrado, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,oe.fechaHallazgo from objeto as o inner join objeto_encontrado as oe on o.idObjeto=oe.idObjeto where o.categoria=?;");
            ps.setString(1, objetoPerdido.getCategoria());
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
    
        /** Objetos en seguimiento: registrados por el SAE sin resolver y reportes de estudiantes
     *  en búsqueda o con coincidencia. */
    public List<ObjetoEncontrado> obtenerObjetosEnSeguimiento(int idSede) {
        String cols = "o.idObjeto, o.imagen, o.categoria, o.nombre, o.color, o.marca, "
                + "o.descripcion, o.lugarReferencia, o.fechaRegistro";
        String sql = "SELECT " + cols + ", o.estado AS est, oe.fechaHallazgo AS fecha, 0 AS perdido "
                + "FROM objeto o INNER JOIN objeto_encontrado oe ON o.idObjeto = oe.idObjeto "
                + "WHERE o.idSede = ? AND o.estado <> 'ENCONTRADO' "
                + "UNION ALL "
                + "SELECT " + cols + ", r.estado AS est, op.fechaPerdida AS fecha, 1 AS perdido "
                + "FROM objeto o INNER JOIN objeto_perdido op ON o.idObjeto = op.idObjeto "
                + "INNER JOIN reporte_objeto_perdido r ON r.idObjetoPerdido = op.idObjetoPerdido "
                + "WHERE o.idSede = ? AND (r.estado LIKE '%squeda%' OR r.estado LIKE '%oincidencia%') "
                + "ORDER BY fecha DESC, idObjeto DESC";
        List<ObjetoEncontrado> lista = new ArrayList<>();
        try (Connection c = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idSede);
            ps.setInt(2, idSede);
            try (ResultSet res = ps.executeQuery()) {
                while (res.next()) {
                    String estado = res.getString("est");
                    if (res.getInt("perdido") == 1) {
                        estado = estado != null && estado.contains("squeda")
                        ? "Perdido: en búsqueda" : "Perdido: con coincidencia";
                    } else {
                        estado = "Registrado por SAE";
                    }
                    ObjetoEncontrado o = new ObjetoEncontrado(res.getDate("fecha"),
                            res.getString("categoria"), res.getString("imagen"), res.getString("nombre"),
                            res.getString("color"), res.getString("marca"), res.getString("descripcion"),
                            res.getString("lugarReferencia"), estado);
                    o.setFechaRegistro(res.getDate("fechaRegistro"));
                    o.setIdObjeto(res.getInt("idObjeto"));
                    lista.add(o);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar objetos en seguimiento: " + e.getMessage());
            return null;
        }
        return lista;
    }
}
