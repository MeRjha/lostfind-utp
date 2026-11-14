package ClasesDAO;

import Singlenton.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.junit.After;
import org.junit.Assume;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class SolicitudReclamoDAOTest {

    private final SolicitudReclamoDAO dao = new SolicitudReclamoDAO();
    private int idCarlos, idMaria, idObjetoLibre, maxNotificacion;

    private int consultarInt(String sql, Object... params) throws SQLException {
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private void ejecutar(String sql, Object... params) throws SQLException {
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            ps.executeUpdate();
        }
    }

    @Before
    public void preparar() throws SQLException {
        idCarlos = consultarInt("SELECT idUsuario FROM usuario WHERE correoInstitucional = ?", "carlos@utp.edu.pe");
        idMaria = consultarInt("SELECT idUsuario FROM usuario WHERE correoInstitucional = ?", "maria@utp.edu.pe");
        // Un objeto encontrado que todavía no tiene ninguna solicitud
        idObjetoLibre = consultarInt("SELECT idObjetoEncontrado FROM objeto_encontrado "
                + "WHERE idObjetoEncontrado NOT IN (SELECT idObjetoEncontrado FROM solicitud_reclamo) LIMIT 1");
        maxNotificacion = consultarInt("SELECT COALESCE(MAX(idNotificacion), 0) FROM notificacion");
        Assume.assumeTrue(idCarlos > 0 && idMaria > 0 && idObjetoLibre > 0);
    }

    @After
    public void limpiar() throws SQLException {
        if (idObjetoLibre > 0) {
            ejecutar("DELETE FROM evidencia_reclamo WHERE idSolicitud IN "
                    + "(SELECT idSolicitud FROM solicitud_reclamo WHERE idObjetoEncontrado = ?)", idObjetoLibre);
            ejecutar("DELETE FROM solicitud_reclamo WHERE idObjetoEncontrado = ?", idObjetoLibre);
            ejecutar("DELETE FROM notificacion WHERE idUsuario = ? AND idNotificacion > ?", idCarlos, maxNotificacion);
        }
    }

    @Test
    public void objetoInexistenteDevuelveMenosUno() {
        assertEquals(-1, dao.crearSolicitud(idCarlos, 9999999, "sustento", null));
    }

    @Test
    public void creaLaSolicitudYEvitaDuplicadas() {
        assertTrue(dao.crearSolicitud(idCarlos, idObjetoLibre, "Tiene mi nombre", "uploads/prueba.png") > 0);
        assertEquals(0, dao.crearSolicitud(idCarlos, idObjetoLibre, "otra vez", null));
    }

    @Test
    public void sinSolicitudNoHayNada() {
        assertNull(dao.obtenerSolicitudDeUsuario(idCarlos, idObjetoLibre));
    }

    @Test
    public void recuperaSustentoYEvidenciaGuardados() {
        dao.crearSolicitud(idCarlos, idObjetoLibre, "Tiene mi nombre", "uploads/prueba.png");
        String[] guardada = dao.obtenerSolicitudDeUsuario(idCarlos, idObjetoLibre);
        assertNotNull(guardada);
        assertEquals("Tiene mi nombre", guardada[0]);
        assertEquals("uploads/prueba.png", guardada[1]);
    }

    @Test
    public void aprobarNotificaYNoSePuedeResolverDosVeces() throws SQLException {
        int id = dao.crearSolicitud(idCarlos, idObjetoLibre, "Es mio", null);
        assertTrue(dao.actualizarEstado(id, "APROBADO", idMaria, null));
        assertFalse(dao.actualizarEstado(id, "RECHAZADO", idMaria, "Ya resuelto"));
        assertEquals("APROBADO", dao.obtenerSolicitudPorId(id).getEstado());
        assertEquals(1, consultarInt("SELECT COUNT(*) FROM notificacion WHERE idUsuario = ? AND idNotificacion > ?",
                idCarlos, maxNotificacion));
    }

    @Test
    public void objetoYaEntregadoNoAceptaMasSolicitudes() {
        int id = dao.crearSolicitud(idCarlos, idObjetoLibre, "Es mio", null);
        dao.actualizarEstado(id, "APROBADO", idMaria, null);
        assertEquals(-2, dao.crearSolicitud(idCarlos, idObjetoLibre, "Otra", null));
    }

    @Test
    public void rechazarExigeMotivo() {
        int id = dao.crearSolicitud(idCarlos, idObjetoLibre, "Es mio", null);
        assertFalse(dao.actualizarEstado(id, "RECHAZADO", idMaria, null));
        assertFalse(dao.actualizarEstado(id, "RECHAZADO", idMaria, "   "));
        assertTrue(dao.actualizarEstado(id, "RECHAZADO", idMaria, "La marca no coincide"));
        assertEquals("La marca no coincide", dao.obtenerSolicitudPorId(id).getMotivoRechazo());
    }

    @Test
    public void actualizarEstadoRechazaDatosInvalidos() {
        assertFalse(dao.actualizarEstado(0, "APROBADO", 1, null));
        assertFalse(dao.actualizarEstado(1, "APROBADO", 0, null));
        assertFalse(dao.actualizarEstado(1, "OTRO", 1, null));
        assertFalse(dao.actualizarEstado(1, null, 1, null));
    }
}