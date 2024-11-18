package modelo;

public class ArchivoLibro {

    private ArchivoAdjunto archivo;
    private LibroReclamacion libroReclamacion;

    public LibroReclamacion getLibroReclamacion() {
        return libroReclamacion;
    }

    public void setLibroReclamacion(LibroReclamacion libroReclamacion) {
        this.libroReclamacion = libroReclamacion;
    }

    public ArchivoAdjunto getArchivo() {
        return archivo;
    }

    public void setArchivo(ArchivoAdjunto archivo) {
        this.archivo = archivo;
    }

}
