/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Docente;
import Objetos.Estudiante;
import Objetos.ObjetoPerdido;
import Objetos.PersonalSAE;
import Objetos.Reporte;
import Objetos.Sede;
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
public class ReporteDAO {

    private Connection con = ConexionBD.getInstancia().getConexion();

    public boolean crearReporte(Usuario usuario, ObjetoPerdido objetoPerdido,String estado) {
        try {
            PreparedStatement ps;
            ps = con.prepareStatement("INSERT INTO reporte_objeto_perdido (idUsuario, idObjetoPerdido, estado) VALUES (?, ?,?);");
            ps.setInt(1, usuario.getIdUsuario());
            ps.setInt(2, objetoPerdido.getIdObjeto());
            ps.setString(3, estado);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return false;
    }

    public Reporte obtenerReportes(Usuario usuario) {
        try {
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select idUsuario, idObjetoPerdido,fechaReporte, estado from reporte_objeto_perdido where idUsuario=?;");
            ps.setInt(1, usuario.getIdUsuario());
            res = ps.executeQuery();
            if (res.next()) {
                int idUsuario = res.getInt("u.idUsuario");
                String nombre = res.getString("idObjetoPerdido");
                String fecha = res.getString("fechaReporte");
                String estado = res.getString("estado");

            }
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }

    public List<Reporte> obtenerObjetosPerdidos(Usuario usuario) {
        try {
            List<Reporte> reportes = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select op.idObjetoPerdido, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,op.fechaPerdida,r.fechaReporte,r.estado from objeto as o inner join objeto_perdido as op on o.idObjeto=op.idObjeto inner join reporte_objeto_perdido as r on r.idObjetoPerdido=op.idObjetoPerdido where op.idUsuario=? order by o.fechaRegistro desc;");
            ps.setInt(1, usuario.getIdUsuario());
            res = ps.executeQuery();
            while (res.next()) {
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
                Date fechaReporte = res.getDate("r.fechaReporte");
                String estadoReporte = res.getString("r.estado");
                ObjetoPerdido objetoPerdido = new ObjetoPerdido(fechaPerdida, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoPerdido.setFechaRegistro(fechaRegistro);
                objetoPerdido.setIdObjeto(idObjeto);
                reportes.add(new Reporte(idObjeto, usuario, objetoPerdido, fechaReporte, estadoReporte));
            }
            return reportes;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }
    
    public List<Reporte> obtenerReportes(ObjetoPerdido objeto,Usuario usuario) {
        try {
            List<Reporte> reportes = new ArrayList<>();
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select op.idObjetoPerdido, o.imagen,o.categoria, o.nombre, o.color, o.marca, o.descripcion, o.lugarReferencia, o.fechaRegistro, o.estado,op.fechaPerdida,r.fechaReporte,r.estado from objeto as o inner join objeto_perdido as op on o.idObjeto=op.idObjeto inner join reporte_objeto_perdido as r on r.idObjetoPerdido=op.idObjetoPerdido where op.idObjetoPerdido=? order by o.fechaRegistro desc;");
            ps.setInt(1, objeto.getIdObjeto());
            res = ps.executeQuery();
            while (res.next()) {
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
                Date fechaReporte = res.getDate("r.fechaReporte");
                String estadoReporte = res.getString("r.estado");
                ObjetoPerdido objetoPerdido = new ObjetoPerdido(fechaPerdida, categoria, imagen, nombre, color, marca, descripcion, lugarReferencia, estado);
                objetoPerdido.setFechaRegistro(fechaRegistro);
                objetoPerdido.setIdObjeto(idObjeto);
                reportes.add(new Reporte(idObjeto, usuario, objetoPerdido, fechaReporte, estadoReporte));
            }
            return reportes;
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }

    public String cambiarEstado(String estado, int idObjeto) {
        try {
            PreparedStatement ps;
            ps = con.prepareStatement("Update reporte_objeto_perdido SET estado=? where idObjetoPerdido=?;");
            ps.setString(1, estado);
            ps.setInt(2, idObjeto);
            ps.executeUpdate();
            return "Estado cambiado con exito";
        } catch (SQLException e) {
            System.out.println(e);

        }
        return "Cambio de estado fallido";
    }
}
