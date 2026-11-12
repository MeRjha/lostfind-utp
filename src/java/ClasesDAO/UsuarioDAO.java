/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Docente;
import Objetos.Estudiante;
import Objetos.PersonalSAE;
import Objetos.Sede;
import Objetos.Usuario;
import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Axel
 */
public class UsuarioDAO {

    private Connection con = ConexionBD.getInstancia().getConexion();

    public UsuarioDAO() {
    }

    public Usuario obtenerUsuario(String correo) {
        try {
            PreparedStatement ps;
            ResultSet res;
            ps = con.prepareStatement("select u.idUsuario,u.nombre,u.apellido,u.correoInstitucional,u.contraseña,u.fotoPerfil,u.rol,u.activo,u.idSede,s.nombre,s.ubicacion from usuario as u inner join Sede as s on u.idSede=s.idSede where correoInstitucional=?;");
            ps.setString(1, correo);
            res = ps.executeQuery();
            if (res.next()) {
                int idUsuario = res.getInt("u.idUsuario");
                String nombre = res.getString("u.nombre");
                String apellido = res.getString("u.apellido");
                String correoInstitucional = res.getString("u.correoInstitucional");
                String contraseña = res.getString("u.contraseña");
                String fotoPerfil = res.getString("u.fotoPerfil");
                String rol = res.getString("u.rol");
                boolean activo = res.getBoolean("u.activo");
                int idSede = res.getInt("u.idSede");
                String nombreSede = res.getString("s.nombre");
                String ubicacion = res.getString("s.ubicacion");
                if (rol.equals("Estudiante")) {
                    return new Estudiante(idUsuario, new Sede(idSede, nombreSede, ubicacion), nombre, apellido, correoInstitucional, contraseña, fotoPerfil, rol, activo);
                } else if (rol.equals("PersonalSae")) {
                    return new PersonalSAE(idUsuario, new Sede(idSede, nombreSede, ubicacion), nombre, apellido, correoInstitucional, contraseña, fotoPerfil, rol, activo);
                } else {
                    return new Docente(idUsuario, new Sede(idSede, nombreSede, ubicacion), nombre, apellido, correoInstitucional, contraseña, fotoPerfil, rol, activo);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }
}
