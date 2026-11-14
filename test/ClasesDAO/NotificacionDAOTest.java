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

public class NotificacionDAOTest {

    private final NotificacionDAO dao = new NotificacionDAO();
    private int idLuis, maxNotificacion;

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

    @Before
    public void preparar() throws SQLException {
        idLuis = consultarInt("SELECT idUsuario FROM usuario WHERE correoInstitucional = ?", "luis@utp.edu.pe");
        maxNotificacion = consultarInt("SELECT COALESCE(MAX(idNotificacion), 0) FROM notificacion");
        Assume.assumeTrue(idLuis > 0);
    }

    @After
    public void limpiar() throws SQLException {
        try (Connection con = ConexionBD.getInstancia().getConexionNueva();
             PreparedStatement ps = con.prepareStatement(
                     "DELETE FROM notificacion WHERE idUsuario = ? AND idNotificacion > ?")) {
            ps.setInt(1, idLuis);
            ps.setInt(2, maxNotificacion);
            ps.executeUpdate();
        }
    }

    @Test
    public void registrarSumaUnaNoLeida() {
        int antes = dao.contarNoLeidas(idLuis);
        assertTrue(dao.registrarNotificacion(idLuis, "Prueba JUnit"));
        assertEquals(antes + 1, dao.contarNoLeidas(idLuis));
    }

    @Test
    public void laNotificacionApareceEnLaLista() {
        dao.registrarNotificacion(idLuis, "Prueba JUnit lista");
        assertTrue(dao.listarPorUsuario(idLuis, 50).toString().contains("Prueba JUnit lista"));
    }

    @Test
    public void marcarLeidasDejaElContadorEnCero() {
        dao.registrarNotificacion(idLuis, "Prueba JUnit leida");
        assertTrue(dao.marcarLeidas(idLuis));
        assertEquals(0, dao.contarNoLeidas(idLuis));
    }
}