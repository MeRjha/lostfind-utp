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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 *
 * @author Axel
 */

public class GestionGemini {

    private static final Logger logger =
            LoggerFactory.getLogger(GestionGemini.class);

    private static final String URL
            = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-2:embedContent";

    private static final Path CARPETA_IMAGENES = Path.of(
            "C:/Users/Axel/Documents/NetBeansProjects/lostfind-utp/web/Imagenes"
    ).toAbsolutePath().normalize();

    private static final long TAMANO_MAXIMO = 5L * 1024 * 1024;
    private static final HttpClient CLIENTE = HttpClient.newHttpClient();

    public static double compararDescripciones(String texto1, String texto2)
            throws Exception {
        return compararObjetos(texto1, "", texto2, "");
    }

    public static double compararObjetos(
            String descripcionPerdido, String imagenPerdido,
            String descripcionEncontrado, String imagenEncontrado) throws Exception {

        Path fotoPerdida = buscarImagen(imagenPerdido);
        Path fotoEncontrada = buscarImagen(imagenEncontrado);
        boolean soloTexto = fotoPerdida == null && fotoEncontrada == null;

        logger.debug("Iniciando comparacion de objetos. Solo texto: {}", soloTexto);

        if ((descripcionPerdido == null || descripcionPerdido.isBlank()) && fotoPerdida == null) {
            logger.warn("Objeto perdido sin descripcion ni imagen disponible");
            return 0;
        }

        if ((descripcionEncontrado == null || descripcionEncontrado.isBlank()) && fotoEncontrada == null) {
            logger.warn("Objeto encontrado sin descripcion ni imagen disponible");
            return 0;
        }

        double[] a = generarEmbedding(descripcionPerdido, fotoPerdida, soloTexto);
        double[] b = generarEmbedding(descripcionEncontrado, fotoEncontrada, soloTexto);

        if (a.length != b.length) {
            logger.error("Los embeddings tienen dimensiones diferentes");
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
            logger.warn("No se puede calcular la similitud porque un embedding tiene magnitud cero");
            return 0;
        }

        double coseno = producto / (Math.sqrt(magnitudA) * Math.sqrt(magnitudB));

        double resultado = Math.max(0, Math.min(1, coseno));

        logger.debug("Comparacion de objetos completada correctamente");

        return resultado;
    }

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

        Path archivoRelativo = Path.of(nombre);

        if (archivoRelativo.isAbsolute() || archivoRelativo.getNameCount() != 1
                || nombre.equals(".") || nombre.equals("..") || nombre.contains("/")) {

            logger.warn("Se intento acceder a una ruta de imagen no permitida");

            throw new IllegalArgumentException("Ruta de imagen no permitida: " + rutaGuardada);
        }

        Path archivo = CARPETA_IMAGENES.resolve(archivoRelativo).normalize();

        if (!archivo.startsWith(CARPETA_IMAGENES)) {
            logger.warn("La ruta de imagen esta fuera de la carpeta permitida");
            throw new IllegalArgumentException("Ruta de imagen no permitida");
        }

        if (!Files.isRegularFile(archivo)) {
            logger.warn("Imagen no encontrada; se utilizara solamente el texto");
            return null;
        }

        String extension = archivo.getFileName().toString().toLowerCase(Locale.ROOT);

        if (!(extension.endsWith(".jpg") || extension.endsWith(".jpeg")
                || extension.endsWith(".jfif") || extension.endsWith(".png"))) {

            logger.warn("Formato de imagen no admitido por Gemini Embedding 2; se utilizara solamente el texto");

            return null;
        }

        if (Files.size(archivo) > TAMANO_MAXIMO) {
            logger.warn("La imagen supera el limite de 5 MB; se utilizara solamente el texto");
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
            logger.warn("No se proporciono descripcion ni imagen para generar el embedding");
            throw new IllegalArgumentException("Se necesita descripcion o imagen");
        }

        JsonObject contenido = new JsonObject();
        contenido.add("parts", partes);

        JsonObject cuerpo = new JsonObject();
        cuerpo.add("content", contenido);

        String clave = System.getenv("GEMINI_API");

        if (clave == null || clave.isBlank()) {
            logger.error("La variable de entorno GEMINI_API no esta configurada");
            throw new IllegalStateException("No se encontro GEMINI_API");
        }

        logger.debug("Enviando solicitud a Gemini Embedding 2");

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

            logger.error("Error en la solicitud a Gemini. Codigo HTTP: {}",
                    respuesta.statusCode());

            throw new IllegalStateException("Gemini respondio "
                    + respuesta.statusCode());
        }

        JsonArray valores = JsonParser.parseString(respuesta.body())
                .getAsJsonObject()
                .getAsJsonObject("embedding")
                .getAsJsonArray("values");

        double[] vector = new double[valores.size()];

        for (int i = 0; i < valores.size(); i++) {
            vector[i] = valores.get(i).getAsDouble();
        }

        logger.debug("Embedding generado correctamente. Dimensiones: {}", vector.length);

        return vector;
    }

}

