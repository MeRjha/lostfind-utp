package Servlets;

import Singlenton.Subidas;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Pattern;

/**
 * Entrega las fotos y evidencias subidas (carpeta definida en Singlenton.Subidas).
 * Ejemplo: uploads/3f2a....jpg
 */
@WebServlet(name = "ArchivoSubidoServlet", urlPatterns = {"/uploads/*"})
public class ArchivoSubidoServlet extends HttpServlet {

    // Solo nombres generados por el sistema (UUID + extensión): evita rutas como ../
    private static final Pattern NOMBRE_VALIDO = Pattern.compile("[A-Za-z0-9_-]{1,80}\\.(jpg|jpeg|png|webp|pdf)");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String info = request.getPathInfo();
        String nombre = (info == null || info.length() < 2) ? "" : info.substring(1);

        if (!NOMBRE_VALIDO.matcher(nombre).matches()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path base = Subidas.carpeta();
        Path archivo = base.resolve(nombre).normalize();
        if (!archivo.startsWith(base) || !Files.isRegularFile(archivo)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String tipo = getServletContext().getMimeType(nombre);
        response.setContentType(tipo != null ? tipo : "application/octet-stream");
        response.setContentLengthLong(Files.size(archivo));
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("Cache-Control", "public, max-age=3600");
        Files.copy(archivo, response.getOutputStream());
    }
}