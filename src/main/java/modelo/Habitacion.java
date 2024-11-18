package modelo;

public class Habitacion {

    private int idHab;
    private String nroHab;
    private String descripcionDucha;
    private String descripcionCama;
    private String descripcionPersonas;
    private String descripcionDesayuno;
    private String imagen;
    private TipoHabitacion tipoHab;
    private Sede sede;

    public Habitacion(int idHab) {
        this.idHab = idHab;
    }

    public Habitacion() {
    }

    public int getIdHab() {
        return idHab;
    }

    public void setIdHab(int idHab) {
        this.idHab = idHab;
    }

    public String getNroHab() {
        return nroHab;
    }

    public void setNroHab(String nroHab) {
        this.nroHab = nroHab;
    }

    public String getDescripcionDucha() {
        return descripcionDucha;
    }

    public void setDescripcionDucha(String descripcionDucha) {
        this.descripcionDucha = descripcionDucha;
    }

    public String getDescripcionCama() {
        return descripcionCama;
    }

    public void setDescripcionCama(String descripcionCama) {
        this.descripcionCama = descripcionCama;
    }

    public String getDescripcionPersonas() {
        return descripcionPersonas;
    }

    public void setDescripcionPersonas(String descripcionPersonas) {
        this.descripcionPersonas = descripcionPersonas;
    }

    public String getDescripcionDesayuno() {
        return descripcionDesayuno;
    }

    public void setDescripcionDesayuno(String descripcionDesayuno) {
        this.descripcionDesayuno = descripcionDesayuno;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public TipoHabitacion getTipoHab() {
        return tipoHab;
    }

    public void setTipoHab(TipoHabitacion tipoHab) {
        this.tipoHab = tipoHab;
    }

    public Sede getSede() {
        return sede;
    }

    public void setSede(Sede sede) {
        this.sede = sede;
    }

    @Override
    public String toString() {
        return "Habitacion{" + "idHab=" + idHab + ", nroHab=" + nroHab + ", descripcionDucha=" + descripcionDucha + ", descripcionCama=" + descripcionCama + ", descripcionPersonas=" + descripcionPersonas + ", descripcionDesayuno=" + descripcionDesayuno + ", imagen=" + imagen + ", tipoHab=" + tipoHab + ", sede=" + sede + '}';
    }

}
