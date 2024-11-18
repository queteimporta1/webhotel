package modelo;

import java.util.ArrayList;
import java.util.List;

public class LibroReclamacion {
    private int idLibroReclamacion;
    private Sede sede;
    private Cliente cliente;
    private String nroCelular;
    private String nroDocumento;
    private String correo;
    private String mensaje;
    private String fecha;
    private List<ArchivoLibro> archivos = new ArrayList<>();

    public int getIdLibroReclamacion() {
        return idLibroReclamacion;
    }

    public void setIdLibroReclamacion(int idLibroReclamacion) {
        this.idLibroReclamacion = idLibroReclamacion;
    }

    public Sede getSede() {
        return sede;
    }

    public void setSede(Sede sede) {
        this.sede = sede;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public String getNroCelular() {
        return nroCelular;
    }

    public void setNroCelular(String nroCelular) {
        this.nroCelular = nroCelular;
    }

    public String getNroDocumento() {
        return nroDocumento;
    }

    public void setNroDocumento(String nroDocumento) {
        this.nroDocumento = nroDocumento;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public List<ArchivoLibro> getArchivos() {
        return archivos;
    }

    public void setArchivos(List<ArchivoLibro> archivos) {
        this.archivos = archivos;
    }
    
    
}
