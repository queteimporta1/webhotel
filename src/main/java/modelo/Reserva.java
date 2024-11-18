package modelo;

public class Reserva {

    private int idReserva;
    private int idSede;
    private int idCliente;
    private String nombreReservante;
    private String correo;
    private String nroDocumento;
    private String nroCelular;
    private String fechaReserva;
    private String horaReserva;
    private String fechaSalida;
    private String horaSalida;
    private double pagoBruto;
    private double pagoAdicion;
    private double pagoTotal;
    private String fechaMaxSalida;
    private DetalleReserva detalleReserva;

    public int getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(int idReserva) {
        this.idReserva = idReserva;
    }

    public int getIdSede() {
        return idSede;
    }

    public void setIdSede(int idSede) {
        this.idSede = idSede;
    }

    public String getNombreReservante() {
        return nombreReservante;
    }

    public void setNombreReservante(String nombreReservante) {
        this.nombreReservante = nombreReservante;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getNroDocumento() {
        return nroDocumento;
    }

    public void setNroDocumento(String nroDocumento) {
        this.nroDocumento = nroDocumento;
    }

    public String getNroCelular() {
        return nroCelular;
    }

    public void setNroCelular(String nroCelular) {
        this.nroCelular = nroCelular;
    }

    public String getFechaReserva() {
        return fechaReserva;
    }

    public void setFechaReserva(String fechaReserva) {
        this.fechaReserva = fechaReserva;
    }

    public String getHoraReserva() {
        return horaReserva;
    }

    public void setHoraReserva(String horaReserva) {
        this.horaReserva = horaReserva;
    }

    public String getFechaSalida() {
        return fechaSalida;
    }

    public void setFechaSalida(String fechaSalida) {
        this.fechaSalida = fechaSalida;
    }

    public String getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(String horaSalida) {
        this.horaSalida = horaSalida;
    }

    public double getPagoBruto() {
        return pagoBruto;
    }

    public void setPagoBruto(double pagoBruto) {
        this.pagoBruto = pagoBruto;
    }

    public double getPagoAdicion() {
        return pagoAdicion;
    }

    public void setPagoAdicion(double pagoAdicion) {
        this.pagoAdicion = pagoAdicion;
    }

    public double getPagoTotal() {
        return pagoTotal;
    }

    public void setPagoTotal(double pagoTotal) {
        this.pagoTotal = pagoTotal;
    }

    public DetalleReserva getDetalleReserva() {
        return detalleReserva;
    }

    public void setDetalleReserva(DetalleReserva detalleReserva) {
        this.detalleReserva = detalleReserva;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }
    
    

    @Override
    public String toString() {
        return "Reserva{" + "idReserva=" + idReserva + ", idSede=" + idSede + ", idCliente=" + idCliente + ", nombreReservante=" + nombreReservante + ", correo=" + correo + ", nroDocumento=" + nroDocumento + ", nroCelular=" + nroCelular + ", fechaReserva=" + fechaReserva + ", horaReserva=" + horaReserva + ", fechaSalida=" + fechaSalida + ", horaSalida=" + horaSalida + ", pagoBruto=" + pagoBruto + ", pagoAdicion=" + pagoAdicion + ", pagoTotal=" + pagoTotal + ", detalleReserva=" + detalleReserva + '}';
    }

    public String getFechaMaxSalida() {
        return fechaMaxSalida;
    }

    public void setFechaMaxSalida(String fechaMaxSalida) {
        this.fechaMaxSalida = fechaMaxSalida;
    }

}
