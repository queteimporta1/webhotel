package modelo;

public class TipoDocumento {

    private int idTipoDoc;
    private String nombre;

    public TipoDocumento() {
    }

    public TipoDocumento(int idTipoDoc) {
        this.idTipoDoc = idTipoDoc;
    }

    public int getIdTipoDoc() {
        return idTipoDoc;
    }

    public void setIdTipoDoc(int idTipoDoc) {
        this.idTipoDoc = idTipoDoc;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

}
