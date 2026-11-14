package Objetos;

import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;

public class ReclamoModeloTest {

    @Test
    public void solicitudGuardaSusDatos() {
        SolicitudReclamo s = new SolicitudReclamo();
        java.sql.Date hoy = new java.sql.Date(System.currentTimeMillis());
        s.setIdSolicitud(5);
        s.setIdObjetoEncontrado(12);
        s.setIdUsuario(1);
        s.setFechaSolicitud(hoy);
        s.setSustentoPropiedad("Tiene mi nombre grabado");
        s.setEstado("PENDIENTE");
        s.setNombreObjeto("Casaca");
        s.setNombreEstudiante("Carlos");
        assertEquals(5, s.getIdSolicitud());
        assertEquals(12, s.getIdObjetoEncontrado());
        assertEquals(1, s.getIdUsuario());
        assertEquals(hoy, s.getFechaSolicitud());
        assertEquals("Tiene mi nombre grabado", s.getSustentoPropiedad());
        assertEquals("PENDIENTE", s.getEstado());
        assertEquals("Casaca", s.getNombreObjeto());
    }

    @Test
    public void solicitudGuardaMotivoDeRechazo() {
        SolicitudReclamo s = new SolicitudReclamo();
        s.setEstado("RECHAZADO");
        s.setMotivoRechazo("La marca no coincide");
        assertEquals("RECHAZADO", s.getEstado());
        assertEquals("La marca no coincide", s.getMotivoRechazo());
    }

    @Test
    public void evidenciaGuardaSuArchivo() {
        EvidenciaReclamo e = new EvidenciaReclamo();
        e.setIdSolicitud(5);
        e.setUrlArchivo("uploads/abc.png");
        assertEquals(5, e.getIdSolicitud());
        assertEquals("uploads/abc.png", e.getUrlArchivo());
    }

    @Test
    public void notificacionNaceSinLeerYSePuedeMarcar() {
        Notificacion n = new Notificacion();
        n.setIdUsuario(1);
        n.setMensaje("Tu reclamo fue aprobado");
        assertFalse(n.isLeida());
        n.setLeida(true);
        assertTrue(n.isLeida());
        assertEquals("Tu reclamo fue aprobado", n.getMensaje());
    }
}