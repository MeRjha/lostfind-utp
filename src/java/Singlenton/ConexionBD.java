/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Singlenton;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author Axel
 */
public class ConexionBD {

    // Instancia única (Singleton)
    private static ConexionBD instancia;
    // Objeto conexión
    private Connection conexion;

    // Constructor privado (Ahora queda limpio)
    private ConexionBD() {
    }

    // Método Singleton
    public static ConexionBD getInstancia() {
        // Crear solo una vez
        if (instancia == null) {
            instancia = new ConexionBD();
        }
        return instancia;
    }

    // Retorna la conexión (Corregido para evitar el "Connection closed")
    public Connection getConexion() {
        try {
            // Si la conexión nunca se creó, o si algún proceso ya la cerró, abrimos una nueva
            if (conexion == null || conexion.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/Bd_LostFind", "root", "root");
                System.out.println("🔌 [ConexionBD] ¡Nueva conexión física establecida con éxito!");
            }
        } catch (Exception e) {
            System.out.println("❌ Error al conectar BD: " + e);
        }
        return conexion;
    }
}
