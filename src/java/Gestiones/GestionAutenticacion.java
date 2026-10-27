/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Gestiones;

import ClasesDAO.UsuarioDAO;
import Objetos.Usuario;

/**
 *
 * @author Axel
 */
public class GestionAutenticacion {

    private UsuarioDAO usuariodao = new UsuarioDAO();

    public Usuario autenticar(String correo, String contraseña) {
        Usuario usuario = usuariodao.obtenerUsuario(correo);
        if (usuario == null) {
            System.out.println("NADAAAAAA");
            return null;
        }
        if (usuario.getCorreoInstitucional().equalsIgnoreCase(correo) && usuario.getContraseña().equalsIgnoreCase(contraseña)) {
            System.out.println("Si existe este todo bien");
            return usuario;
        }
        return null;
    }
}
