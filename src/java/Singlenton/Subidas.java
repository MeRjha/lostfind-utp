package Singlenton;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Carpeta donde se guardan las fotos y evidencias que suben los usuarios.
 * Está fuera del proyecto para que no se borre con "Clean and Build" y para que
 * todos los servlets (y Gemini) lean y escriban en el mismo lugar.
 */
public final class Subidas {

    /** Prefijo que se guarda en la base de datos; ArchivoSubidoServlet lo atiende en /uploads/*. */
    public static final String PREFIJO = "uploads/";

    private Subidas() {
    }

    /** Por defecto: ~/LostFind_uploads. Se puede cambiar con la variable de entorno LOSTFIND_UPLOADS. */
    public static Path carpeta() throws IOException {
        String indicada = System.getenv("LOSTFIND_UPLOADS");
        Path carpeta = (indicada == null || indicada.isBlank())
                ? Paths.get(System.getProperty("user.home"), "LostFind_uploads")
                : Paths.get(indicada.trim());
        Files.createDirectories(carpeta);
        return carpeta.toAbsolutePath().normalize();
    }
}