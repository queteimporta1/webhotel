package modelo;

public class Comentario {
    private int idComentario;
    private Cliente cliente;
    private String descripcion;
    private String fecha;
    private String servicio;
    private String habitacion;
    private String ambiente;
    private int nroCalificacion;
    private double porcCalificacion;

    public int getIdComentario() {
        return idComentario;
    }

    public void setIdComentario(int idComentario) {
        this.idComentario = idComentario;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getServicio() {
        return servicio;
    }

    public void setServicio(String servicio) {
        this.servicio = servicio;
    }

    public String getHabitacion() {
        return habitacion;
    }

    public void setHabitacion(String habitacion) {
        this.habitacion = habitacion;
    }

    public String getAmbiente() {
        return ambiente;
    }

    public void setAmbiente(String ambiente) {
        this.ambiente = ambiente;
    }

    public int getNroCalificacion() {
        return nroCalificacion;
    }

    public void setNroCalificacion(int nroCalificacion) {
        this.nroCalificacion = nroCalificacion;
    }

    public double getPorcCalificacion() {
        return porcCalificacion;
    }

    public void setPorcCalificacion(double porcCalificacion) {
        this.porcCalificacion = porcCalificacion;
    }
    
    
    
}
