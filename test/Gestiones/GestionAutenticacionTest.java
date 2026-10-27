package Gestiones;

import Objetos.Usuario;
import org.junit.Test;
import static org.junit.Assert.*;

public class GestionAutenticacionTest {

    private final GestionAutenticacion gestion = new GestionAutenticacion();

    @Test
    public void autenticaConCredencialesCorrectas() {
        Usuario u = gestion.autenticar("carlos@utp.edu.pe", "Demo1234");
        assertNotNull(u);
        assertEquals("Carlos", u.getNombre());
        assertEquals("Estudiante", u.getRol());
    }

    @Test
    public void rechazaContrasenaIncorrecta() {
        assertNull(gestion.autenticar("carlos@utp.edu.pe", "incorrecta"));
    }

    @Test
    public void rechazaCorreoInexistente() {
        assertNull(gestion.autenticar("noexiste@utp.edu.pe", "Demo1234"));
    }

    @Test
    public void devuelveSubclaseSegunRol() {
        assertEquals("PersonalSae", gestion.autenticar("maria@utp.edu.pe", "Demo1234").getRol());
        assertEquals("Docente", gestion.autenticar("luis@utp.edu.pe", "Demo1234").getRol());
    }
}