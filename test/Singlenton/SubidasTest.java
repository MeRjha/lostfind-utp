
package Singlenton;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.Test;
import static org.junit.Assert.*;

public class SubidasTest {

    @Test
    public void laCarpetaExisteYEsAbsoluta() throws IOException {
        Path carpeta = Subidas.carpeta();
        assertTrue(carpeta.isAbsolute());
        assertTrue(Files.isDirectory(carpeta));
    }

    @Test
    public void elPrefijoEsElQueEsperaElServlet() {
        assertEquals("uploads/", Subidas.PREFIJO);
    }

    @Test
    public void laCarpetaSePuedeEscribir() throws IOException {
        Path prueba = Files.createTempFile(Subidas.carpeta(), "test_", ".tmp");
        assertTrue(Files.exists(prueba));
        Files.delete(prueba);
    }
}