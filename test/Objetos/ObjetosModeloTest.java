package Objetos;

import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;

public class ObjetosModeloTest {

    private Sede sede() {
        return new Sede(1, "UTP Lima Sur", "Villa El Salvador");
    }

    private Estudiante estudiante() {
        return new Estudiante(1, sede(), "Carlos", "Perez", "carlos@utp.edu.pe",
                "Demo1234", "Imagenes/fotoUsuario.jpg", "Estudiante", true);
    }

    @Test
    public void estudianteEsUsuarioYGuardaSusDatos() {
        Usuario u = estudiante();
        assertEquals(1, u.getIdUsuario());
        assertEquals("Carlos", u.getNombre());
        assertEquals("carlos@utp.edu.pe", u.getCorreoInstitucional());
        assertEquals("Estudiante", u.getRol());
        assertTrue(u.isActivo());
        assertEquals("Villa El Salvador", u.getSede().getUbicacion());
    }

    @Test
    public void usuarioPermiteActualizarDatos() {
        Usuario u = estudiante();
        u.setActivo(false);
        u.setNombre("Luis");
        assertFalse(u.isActivo());
        assertEquals("Luis", u.getNombre());
    }

    @Test
    public void rolesDeUsuarioSonSubclasesDeUsuario() {
        Usuario sae = new PersonalSAE(2, sede(), "Maria", "Lopez", "maria@utp.edu.pe", "x", "f.jpg", "PersonalSae", true);
        Usuario doc = new Docente(3, sede(), "Luis", "Torres", "luis@utp.edu.pe", "x", "f.jpg", "Docente", true);
        assertEquals("PersonalSae", sae.getRol());
        assertEquals("Docente", doc.getRol());
    }

    @Test
    public void objetoPerdidoConservaCaracteristicas() {
        Date fecha = new Date();
        ObjetoPerdido op = new ObjetoPerdido(fecha, "Electronico", "img.jpg", "Audifonos",
                "Negro", "Sony", "Con estuche", "Biblioteca", "Perdido");
        assertEquals("Audifonos", op.getNombre());
        assertEquals("Negro", op.getColor());
        assertEquals("Biblioteca", op.getLugarReferencia());
        assertEquals("Perdido", op.getEstado());
        assertEquals(fecha, op.getFechaPerdida());
    }

    @Test
    public void objetoEncontradoConservaFechaHallazgo() {
        Date fecha = new Date();
        ObjetoEncontrado oe = new ObjetoEncontrado(fecha, "Accesorio", "img.jpg", "Mochila",
                "Azul", "Totto", "Con llavero", "Pabellon A", "Encontrado");
        assertEquals(fecha, oe.getFechaHallazgo());
        assertEquals("Mochila", oe.getNombre());
    }

    @Test
    public void objetoPermiteCambiarEstado() {
        ObjetoEncontrado oe = new ObjetoEncontrado(new Date(), "Accesorio", "i.jpg", "Mochila",
                "Azul", "Totto", "-", "Pabellon A", "Encontrado");
        oe.setEstado("Entregado");
        assertEquals("Entregado", oe.getEstado());
    }

    @Test
    public void coincidenciaRelacionaObjetoPerdidoYEncontrado() {
        ObjetoPerdido op = new ObjetoPerdido(new Date(), "Accesorio", "a.jpg", "Mochila", "Azul", "Totto", "-", "Aula", "Perdido");
        ObjetoEncontrado oe = new ObjetoEncontrado(new Date(), "Accesorio", "b.jpg", "Mochila", "Azul", "Totto", "-", "Pabellon A", "Encontrado");
        Coincidencia c = new Coincidencia(op, oe, 87.5);
        assertSame(op, c.getObjetoPerdido());
        assertSame(oe, c.getObjetoEncontrado());
        assertEquals(87.5, c.getPorcentajeSimilitud(), 0.001);
    }

    @Test
    public void reporteAsociaUsuarioObjetoYEstado() {
        ObjetoPerdido op = new ObjetoPerdido(new Date(), "Accesorio", "a.jpg", "Mochila", "Azul", "Totto", "-", "Aula", "Perdido");
        Reporte r = new Reporte(1, estudiante(), op, new Date(), "Pendiente");
        assertEquals("Pendiente", r.getEstado());
        assertSame(op, r.getObjetoPerdido());
        assertEquals("Carlos", r.getUsuario().getNombre());
    }
}