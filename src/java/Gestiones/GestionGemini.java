/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Gestiones;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.Base64;
import java.util.Locale;

/**
 *
 * @author Axel
 */
public class GestionGemini {

    private static final String URL
            = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-2:embedContent";

    // Carpeta ORIGINAL de Imagenes de tu proyecto local de NetBeans.
    private static final Path CARPETA_IMAGENES = Path.of(
            "C:/Users/Axel/Documents/NetBeansProjects/lostfind-utp/web/Imagenes"
    ).toAbsolutePath().normalize();

    private static final long TAMANO_MAXIMO = 5L * 1024 * 1024;
    private static final HttpClient CLIENTE = HttpClient.newHttpClient();

    // Conserva el metodo que ya utilizabas para comparar solo descripciones.
    public static double compararDescripciones(String texto1, String texto2)
            throws Exception {
        return compararObjetos(texto1, "", texto2, "");
    }

    // Cada ruta puede ser null, "", o "Imagenes/nombre.jpg".
    public static double compararObjetos(
            String descripcionPerdido, String imagenPerdido,
            String descripcionEncontrado, String imagenEncontrado) throws Exception {

        Path fotoPerdida = buscarImagen(imagenPerdido);
        Path fotoEncontrada = buscarImagen(imagenEncontrado);
        boolean soloTexto = fotoPerdida == null && fotoEncontrada == null;

        if ((descripcionPerdido == null || descripcionPerdido.isBlank()) && fotoPerdida == null) {
            return 0;
        }
        if ((descripcionEncontrado == null || descripcionEncontrado.isBlank()) && fotoEncontrada == null) {
            return 0;
        }

        double[] a = generarEmbedding(descripcionPerdido, fotoPerdida, soloTexto);
        double[] b = generarEmbedding(descripcionEncontrado, fotoEncontrada, soloTexto);

        if (a.length != b.length) {
            throw new IllegalStateException("Los embeddings tienen dimensiones diferentes");
        }

        double producto = 0;
        double magnitudA = 0;
        double magnitudB = 0;

        for (int i = 0; i < a.length; i++) {
            producto += a[i] * b[i];
            magnitudA += a[i] * a[i];
            magnitudB += b[i] * b[i];
        }

        if (magnitudA == 0 || magnitudB == 0) {
            return 0;
        }

        double coseno = producto / (Math.sqrt(magnitudA) * Math.sqrt(magnitudB));
        return Math.max(0, Math.min(1, coseno));
    }

    // Se conserva para compatibilidad con tus primeras pruebas.
    public static double[] obtenerEmbedding(String descripcion) throws Exception {
        return generarEmbedding(descripcion, null, true);
    }

    private static Path buscarImagen(String rutaGuardada) throws Exception {
        if (rutaGuardada == null || rutaGuardada.isBlank()) {
            return null;
        }

        String nombre = rutaGuardada.trim().replace('\\', '/');
        if (nombre.startsWith("Imagenes/")) {
            nombre = nombre.substring("Imagenes/".length());
        }

        // Solo aceptamos el nombre del archivo dentro de la carpeta Imagenes.
        Path archivoRelativo = Path.of(nombre);
        if (archivoRelativo.isAbsolute() || archivoRelativo.getNameCount() != 1
                || nombre.equals(".") || nombre.equals("..") || nombre.contains("/")) {
            throw new IllegalArgumentException("Ruta de imagen no permitida: " + rutaGuardada);
        }
        Path archivo = CARPETA_IMAGENES.resolve(archivoRelativo).normalize();
        if (!archivo.startsWith(CARPETA_IMAGENES)) {
            throw new IllegalArgumentException("Ruta de imagen no permitida");
        }
        if (!Files.isRegularFile(archivo)) {
            System.err.println("Imagen no encontrada; se usara el texto: " + rutaGuardada);
            return null;
        }

        String extension = archivo.getFileName().toString().toLowerCase(Locale.ROOT);
        if (!(extension.endsWith(".jpg") || extension.endsWith(".jpeg")
                || extension.endsWith(".jfif") || extension.endsWith(".png"))) {
            System.err.println("Formato no admitido por Gemini Embedding 2; se usara el texto: " + rutaGuardada);
            return null;
        }
        if (Files.size(archivo) > TAMANO_MAXIMO) {
            System.err.println("La imagen supera 5 MB; se usara el texto: " + rutaGuardada);
            return null;
        }
        return archivo;
    }

    private static double[] generarEmbedding(String descripcion, Path imagen, boolean soloTexto)
            throws Exception {

        JsonArray partes = new JsonArray();

        if (descripcion != null && !descripcion.isBlank()) {
            JsonObject parteTexto = new JsonObject();
            String texto = soloTexto
                    ? "task: sentence similarity | query: " + descripcion
                    : descripcion;
            parteTexto.addProperty("text", texto);
            partes.add(parteTexto);
        }

        if (imagen != null) {
            String nombre = imagen.getFileName().toString().toLowerCase(Locale.ROOT);
            String mime = nombre.endsWith(".png") ? "image/png" : "image/jpeg";

            JsonObject datosImagen = new JsonObject();
            datosImagen.addProperty("mime_type", mime);
            datosImagen.addProperty("data", Base64.getEncoder()
                    .encodeToString(Files.readAllBytes(imagen)));

            JsonObject parteImagen = new JsonObject();
            parteImagen.add("inline_data", datosImagen);
            partes.add(parteImagen);
        }

        if (partes.isEmpty()) {
            throw new IllegalArgumentException("Se necesita descripcion o imagen");
        }

        JsonObject contenido = new JsonObject();
        contenido.add("parts", partes);
        JsonObject cuerpo = new JsonObject();
        cuerpo.add("content", contenido);

        String clave = System.getenv("GEMINI_API");
        if (clave == null || clave.isBlank()) {
            throw new IllegalStateException("No se encontro GEMINI_API");
        }

        HttpRequest solicitud = HttpRequest.newBuilder()
                .uri(URI.create(URL))
                .timeout(Duration.ofSeconds(60))
                .header("x-goog-api-key", clave)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(
                        cuerpo.toString(), StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> respuesta = CLIENTE.send(
                solicitud, HttpResponse.BodyHandlers.ofString());

        if (respuesta.statusCode() != 200) {
            throw new IllegalStateException("Gemini respondio "
                    + respuesta.statusCode() + ": " + respuesta.body());
        }

        JsonArray valores = JsonParser.parseString(respuesta.body())
                .getAsJsonObject().getAsJsonObject("embedding")
                .getAsJsonArray("values");

        double[] vector = new double[valores.size()];
        for (int i = 0; i < valores.size(); i++) {
            vector[i] = valores.get(i).getAsDouble();
        }
        return vector;
    }

}
