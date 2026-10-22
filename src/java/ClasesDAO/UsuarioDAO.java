/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ClasesDAO;

import Objetos.Estudiante;
import Objetos.PersonalSAE;
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
            ps = con.prepareStatement("select idUsuario,nombre,apellido,correoInstitucional,contraseña,rol,activo from usuario where correoInstitucional=?;");
            ps.setString(1, correo);
            res = ps.executeQuery();
            if (res.next()) {
                int idUsuario = res.getInt("idUsuario");
                String nombre = res.getString("nombre");
                String apellido = res.getString("apellido");
                String correoInstitucional = res.getString("correoInstitucional");
                String contraseña = res.getString("contraseña");
                String rol = res.getString("rol");
                boolean activo = res.getBoolean("activo");
                if (rol.equals("Estudiante")) {
                    return new Estudiante(idUsuario, nombre, apellido, correoInstitucional, contraseña, rol, activo);
                } else if (rol.equals("PersonalSae")) {
                    return new PersonalSAE(idUsuario, nombre, apellido, correoInstitucional, contraseña, rol, activo);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);

        }
        return null;
    }
}
