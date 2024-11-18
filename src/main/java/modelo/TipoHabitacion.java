package modelo;

public class TipoHabitacion {

    private int idTipoHab;
    private String nombreTipoHab;
    private double costo;

    public TipoHabitacion() {
    }

    public TipoHabitacion(int idTipoHab) {
        this.idTipoHab = idTipoHab;
    }

    public int getIdTipoHab() {
        return idTipoHab;
    }

    public void setIdTipoHab(int idTipoHab) {
        this.idTipoHab = idTipoHab;
    }

    public String getNombreTipoHab() {
        return nombreTipoHab;
    }

    public void setNombreTipoHab(String nombreTipoHab) {
        this.nombreTipoHab = nombreTipoHab;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }

}
