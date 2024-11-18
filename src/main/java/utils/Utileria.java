package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class Utileria {

    public static String RUTA_IMG_USUARIOS = "src\\main\\webapp\\assets\\img\\recursos\\usuarios\\";
    public static String RUTA_ARCHIVOS_RECLAMACION = "src\\main\\webapp\\assets\\archivos\\libro\\";

    public static String StrFecha(Date fecha) {
        SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy");
        try {
            return sd.format(fecha);
        } catch (Exception ex) {
            return null;
        }
    }

    public static String guardarArchivo(String ruta, Part archivoPart, String nombreArchivo) {
        System.out.println("RUTA a subir: " + ruta);
        try {

            File archivo = new File(ruta);

            if (!archivo.exists()) {
                System.out.println("Archivo ruta no existe " + ruta);
                archivo.mkdirs();
            }

            Path path = Paths.get(ruta + nombreArchivo);
            archivo = new File(path.toAbsolutePath().toString());
            archivo.toPath();

            try (InputStream input = archivoPart.getInputStream()) {
                Files.copy(input, archivo.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
        return nombreArchivo;
    }

    public static String RutaAbsoluta(HttpServletRequest request, String carpeta) {
        String ruta = request.getServletContext().getRealPath("");
        return ruta.substring(0, ruta.indexOf("target")) + carpeta;
    }

    public static String generateUniqueImageName(String originalFileName) {
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));

        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String uniqueID = UUID.randomUUID().toString();

        return "img_" + timestamp + "_" + uniqueID + extension;
    }
}
