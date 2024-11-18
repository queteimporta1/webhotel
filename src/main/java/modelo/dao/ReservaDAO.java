package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modelo.DetalleReserva;
import modelo.Habitacion;
import modelo.Reserva;
import modelo.Sede;
import modelo.Servicio;
import modelo.TipoHabitacion;

public class ReservaDAO extends DBABase {

    public Map<String, Object> Guardar(Reserva obj) {
        Map<String, Object> resultado = new HashMap<>();

        try {
            cn = Conexion.getConnection();
            String sql = "{CALL sp_registrar_reserva(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, obj.getIdSede());
            ps.setInt(2, obj.getIdCliente());
            ps.setString(3, obj.getNombreReservante());
            ps.setString(4, obj.getCorreo());
            ps.setString(5, obj.getNroDocumento());
            ps.setString(6, obj.getNroCelular());

            ps.setString(7, obj.getFechaReserva());
            ps.setString(8, obj.getHoraReserva());
            ps.setDouble(9, obj.getPagoBruto());
            ps.setDouble(10, obj.getPagoAdicion());

            ps.setInt(11, obj.getDetalleReserva().getHabitacion().getIdHab());
            ps.setInt(12, obj.getDetalleReserva().getServicio().getIdServicio());
            ps.setInt(13, obj.getDetalleReserva().getCantAdultos());
            ps.setInt(14, obj.getDetalleReserva().getCantNinios());
            rs = ps.executeQuery();

            if (rs.next()) {
                resultado.put("msg", rs.getString("msg"));
                resultado.put("result", rs.getString("result"));
            }

        } catch (Exception ex) {
            resultado.put("msg", ex.getMessage());
            resultado.put("result", 0);
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return resultado;
    }

    public Reserva BuscarPorId(int idReserva) {
        Reserva reserva = null;

        try {
            cn = Conexion.getConnection();
            String sql = "SELECT r.*, dr.*, h.*, th.*, s.*, sd.nombre_sede  FROM Reserva r "
                    + "JOIN Detalle_Reserva dr ON r.id_reserva = dr.id_reserva "
                    + "JOIN Habitacion h ON dr.id_habitacion = h.id_habitacion "
                    + "JOIN Sede sd ON sd.id_sede = h.id_sede "
                    + "JOIN Tipo_Habitacion th ON h.id_tipo_hab = th.id_tipo_hab "
                    + "LEFT JOIN Servicio s ON dr.id_servicio = s.id_servicio "
                    + "WHERE r.id_reserva = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idReserva);
            rs = ps.executeQuery();

            if (rs.next()) {
                reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setIdSede(rs.getInt("id_sede"));
                reserva.setIdCliente(rs.getInt("id_cliente"));
                reserva.setNombreReservante(rs.getString("nombre_reservante"));
                reserva.setCorreo(rs.getString("correo"));
                reserva.setNroDocumento(rs.getString("nro_documento"));
                reserva.setNroCelular(rs.getString("nro_celular"));
                reserva.setFechaReserva(rs.getString("fecha_reserva"));
                reserva.setHoraReserva(rs.getString("hora_reserva"));
                reserva.setFechaSalida(rs.getString("fecha_salida"));
                reserva.setHoraSalida(rs.getString("hora_salida"));
                reserva.setPagoBruto(rs.getDouble("pago_bruto"));
                reserva.setPagoAdicion(rs.getDouble("pago_adicion"));
                reserva.setPagoTotal(rs.getDouble("pago_total"));
                reserva.setFechaMaxSalida(rs.getString("fecha_maxima_salida"));
              
                // Detalle de la reserva
                DetalleReserva detalleReserva = new DetalleReserva();

                TipoHabitacion tipoHabitacion = new TipoHabitacion();
                tipoHabitacion.setIdTipoHab(rs.getInt("id_tipo_hab"));
                tipoHabitacion.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                tipoHabitacion.setCosto(rs.getDouble("costo"));

                Habitacion habitacion = new Habitacion();
                habitacion.setIdHab(rs.getInt("id_habitacion"));
                habitacion.setNroHab(rs.getString("nro_habitacion"));
                habitacion.setDescripcionCama(rs.getString("descripcion_cama"));
                habitacion.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                habitacion.setDescripcionDucha(rs.getString("descripcion_ducha"));
                habitacion.setDescripcionPersonas(rs.getString("descripcion_personas"));
                habitacion.setTipoHab(tipoHabitacion);

                Sede sede = new Sede();
                sede.setNombre(rs.getString("nombre_sede"));
                habitacion.setSede(sede);
                detalleReserva.setHabitacion(habitacion);

                if (rs.getObject("id_servicio") != null) {
                    Servicio servicio = new Servicio();
                    servicio.setIdServicio(rs.getInt("id_servicio"));
                    servicio.setNombre(rs.getString("nombre_servicio"));
                    detalleReserva.setServicio(servicio);
                }

                detalleReserva.setCantAdultos(rs.getInt("cant_adultos"));
                detalleReserva.setCantNinios(rs.getInt("cant_niños"));
                detalleReserva.setCostoReserva(rs.getDouble("costo_reserva"));
                detalleReserva.setCostoServicio(rs.getDouble("costo_servicio"));

                reserva.setDetalleReserva(detalleReserva);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return reserva;
    }

    public List<Reserva> BuscarPorCliente(int idCliente) {
        List<Reserva> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "SELECT r.*, dr.*, h.*, th.*, s.* FROM Reserva r "
                    + "JOIN Detalle_Reserva dr ON r.id_reserva = dr.id_reserva "
                    + "JOIN Habitacion h ON dr.id_habitacion = h.id_habitacion "
                    + "JOIN Tipo_Habitacion th ON h.id_tipo_hab = th.id_tipo_hab "
                    + "LEFT JOIN Servicio s ON dr.id_servicio = s.id_servicio "
                    + "WHERE r.id_cliente = ? ";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            rs = ps.executeQuery();

            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setIdSede(rs.getInt("id_sede"));
                reserva.setIdCliente(rs.getInt("id_cliente"));
                reserva.setNombreReservante(rs.getString("nombre_reservante"));
                reserva.setCorreo(rs.getString("correo"));
                reserva.setNroDocumento(rs.getString("nro_documento"));
                reserva.setNroCelular(rs.getString("nro_celular"));
                reserva.setFechaReserva(rs.getString("fecha_reserva"));
                reserva.setHoraReserva(rs.getString("hora_reserva"));
                reserva.setFechaSalida(rs.getString("fecha_salida"));
                reserva.setHoraSalida(rs.getString("hora_salida"));
                reserva.setPagoBruto(rs.getDouble("pago_bruto"));
                reserva.setPagoAdicion(rs.getDouble("pago_adicion"));
                reserva.setPagoTotal(rs.getDouble("pago_total"));

                // Detalle de la reserva
                DetalleReserva detalleReserva = new DetalleReserva();

                TipoHabitacion tipoHabitacion = new TipoHabitacion();
                tipoHabitacion.setIdTipoHab(rs.getInt("id_tipo_hab"));
                tipoHabitacion.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                tipoHabitacion.setCosto(rs.getDouble("costo"));

                Habitacion habitacion = new Habitacion();
                habitacion.setIdHab(rs.getInt("id_habitacion"));
                habitacion.setNroHab(rs.getString("nro_habitacion"));
                habitacion.setDescripcionCama(rs.getString("descripcion_cama"));
                habitacion.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                habitacion.setDescripcionDucha(rs.getString("descripcion_ducha"));
                habitacion.setDescripcionPersonas(rs.getString("descripcion_personas"));
                habitacion.setTipoHab(tipoHabitacion);
                detalleReserva.setHabitacion(habitacion);

                if (rs.getObject("id_servicio") != null) {
                    Servicio servicio = new Servicio();
                    servicio.setIdServicio(rs.getInt("id_servicio"));
                    servicio.setNombre(rs.getString("nombre_servicio"));
                    detalleReserva.setServicio(servicio);
                }

                detalleReserva.setCantAdultos(rs.getInt("cant_adultos"));
                detalleReserva.setCantNinios(rs.getInt("cant_niños"));
                detalleReserva.setCostoReserva(rs.getDouble("costo_reserva"));
                detalleReserva.setCostoServicio(rs.getDouble("costo_servicio"));

                reserva.setDetalleReserva(detalleReserva);

                lista.add(reserva);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

    public List<Reserva> BuscarPorNroDocPendientes(String nroDoc) {
        List<Reserva> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "SELECT r.*, dr.*, h.*, th.*, s.*, sd.nombre_sede FROM Reserva r "
                    + "JOIN Detalle_Reserva dr ON r.id_reserva = dr.id_reserva "
                    + "JOIN Habitacion h ON dr.id_habitacion = h.id_habitacion "
                    + "JOIN Sede sd ON sd.id_sede = h.id_sede "
                    + "JOIN Tipo_Habitacion th ON h.id_tipo_hab = th.id_tipo_hab "
                    + "LEFT JOIN Servicio s ON dr.id_servicio = s.id_servicio "
                    + "WHERE r.nro_documento = ? AND r.fecha_salida IS NULL AND r.fecha_entrada IS NULL";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nroDoc);
            rs = ps.executeQuery();

            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setIdSede(rs.getInt("id_sede"));
                reserva.setIdCliente(rs.getInt("id_cliente"));
                reserva.setNombreReservante(rs.getString("nombre_reservante"));
                reserva.setCorreo(rs.getString("correo"));
                reserva.setNroDocumento(rs.getString("nro_documento"));
                reserva.setNroCelular(rs.getString("nro_celular"));
                reserva.setFechaReserva(rs.getString("fecha_reserva"));
                reserva.setHoraReserva(rs.getString("hora_reserva"));
                reserva.setFechaSalida(rs.getString("fecha_salida"));
                reserva.setHoraSalida(rs.getString("hora_salida"));
                reserva.setPagoBruto(rs.getDouble("pago_bruto"));
                reserva.setPagoAdicion(rs.getDouble("pago_adicion"));
                reserva.setPagoTotal(rs.getDouble("pago_total"));

                // Detalle de la reserva
                DetalleReserva detalleReserva = new DetalleReserva();

                TipoHabitacion tipoHabitacion = new TipoHabitacion();
                tipoHabitacion.setIdTipoHab(rs.getInt("id_tipo_hab"));
                tipoHabitacion.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                tipoHabitacion.setCosto(rs.getDouble("costo"));

                Habitacion habitacion = new Habitacion();
                habitacion.setIdHab(rs.getInt("id_habitacion"));
                habitacion.setNroHab(rs.getString("nro_habitacion"));
                habitacion.setDescripcionCama(rs.getString("descripcion_cama"));
                habitacion.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                habitacion.setDescripcionDucha(rs.getString("descripcion_ducha"));
                habitacion.setDescripcionPersonas(rs.getString("descripcion_personas"));
                habitacion.setTipoHab(tipoHabitacion);

                Sede sede = new Sede();
                sede.setNombre(rs.getString("nombre_sede"));

                habitacion.setSede(sede);
                detalleReserva.setHabitacion(habitacion);

                if (rs.getObject("id_servicio") != null) {
                    Servicio servicio = new Servicio();
                    servicio.setIdServicio(rs.getInt("id_servicio"));
                    servicio.setNombre(rs.getString("nombre_servicio"));
                    detalleReserva.setServicio(servicio);
                }

                detalleReserva.setCantAdultos(rs.getInt("cant_adultos"));
                detalleReserva.setCantNinios(rs.getInt("cant_niños"));
                detalleReserva.setCostoReserva(rs.getDouble("costo_reserva"));
                detalleReserva.setCostoServicio(rs.getDouble("costo_servicio"));

                reserva.setDetalleReserva(detalleReserva);

                lista.add(reserva);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

    public List<Reserva> ListarReservasConEntrada(int idSede) {
        List<Reserva> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "SELECT r.*, dr.*, h.*, th.*, s.*, sd.nombre_sede FROM Reserva r "
                    + "JOIN Detalle_Reserva dr ON r.id_reserva = dr.id_reserva "
                    + "JOIN Habitacion h ON dr.id_habitacion = h.id_habitacion "
                    + "JOIN Sede sd ON sd.id_sede = h.id_sede "
                    + "JOIN Tipo_Habitacion th ON h.id_tipo_hab = th.id_tipo_hab "
                    + "LEFT JOIN Servicio s ON dr.id_servicio = s.id_servicio "
                    + "WHERE r.fecha_salida IS NULL AND r.fecha_entrada IS NOT NULL AND h.id_sede = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idSede);
            rs = ps.executeQuery();

            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setIdSede(rs.getInt("id_sede"));
                reserva.setIdCliente(rs.getInt("id_cliente"));
                reserva.setNombreReservante(rs.getString("nombre_reservante"));
                reserva.setCorreo(rs.getString("correo"));
                reserva.setNroDocumento(rs.getString("nro_documento"));
                reserva.setNroCelular(rs.getString("nro_celular"));
                reserva.setFechaReserva(rs.getString("fecha_reserva"));
                reserva.setHoraReserva(rs.getString("hora_reserva"));
                reserva.setFechaSalida(rs.getString("fecha_salida"));
                reserva.setHoraSalida(rs.getString("hora_salida"));
                reserva.setPagoBruto(rs.getDouble("pago_bruto"));
                reserva.setPagoAdicion(rs.getDouble("pago_adicion"));
                reserva.setPagoTotal(rs.getDouble("pago_total"));

                // Detalle de la reserva
                DetalleReserva detalleReserva = new DetalleReserva();

                TipoHabitacion tipoHabitacion = new TipoHabitacion();
                tipoHabitacion.setIdTipoHab(rs.getInt("id_tipo_hab"));
                tipoHabitacion.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                tipoHabitacion.setCosto(rs.getDouble("costo"));

                Habitacion habitacion = new Habitacion();
                habitacion.setIdHab(rs.getInt("id_habitacion"));
                habitacion.setNroHab(rs.getString("nro_habitacion"));
                habitacion.setDescripcionCama(rs.getString("descripcion_cama"));
                habitacion.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                habitacion.setDescripcionDucha(rs.getString("descripcion_ducha"));
                habitacion.setDescripcionPersonas(rs.getString("descripcion_personas"));
                habitacion.setTipoHab(tipoHabitacion);

                Sede sede = new Sede();
                sede.setNombre(rs.getString("nombre_sede"));

                habitacion.setSede(sede);
                detalleReserva.setHabitacion(habitacion);

                if (rs.getObject("id_servicio") != null) {
                    Servicio servicio = new Servicio();
                    servicio.setIdServicio(rs.getInt("id_servicio"));
                    servicio.setNombre(rs.getString("nombre_servicio"));
                    detalleReserva.setServicio(servicio);
                }

                detalleReserva.setCantAdultos(rs.getInt("cant_adultos"));
                detalleReserva.setCantNinios(rs.getInt("cant_niños"));
                detalleReserva.setCostoReserva(rs.getDouble("costo_reserva"));
                detalleReserva.setCostoServicio(rs.getDouble("costo_servicio"));

                reserva.setDetalleReserva(detalleReserva);

                lista.add(reserva);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

    public int RegistrarEntrada(int idReserva) {
        int result = 0;
        try {
            cn = Conexion.getConnection();
            String sql = "UPDATE reserva SET fecha_entrada = NOW() "
                    + " WHERE id_reserva = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idReserva);
            result = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
    
    public int RegistrarSalida(int idReserva) {
        int result = 0;
        try {
            cn = Conexion.getConnection();
            String sql = "UPDATE reserva SET fecha_salida = current_date() , hora_salida= current_time() "
                    + " WHERE id_reserva = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idReserva);
            result = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
    
     public List<Reserva> ConsultaReservasConSalida(String inicio, String fin) {
        List<Reserva> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "SELECT r.*, dr.*, h.*, th.*, s.*, sd.nombre_sede FROM Reserva r "
                    + "JOIN Detalle_Reserva dr ON r.id_reserva = dr.id_reserva "
                    + "JOIN Habitacion h ON dr.id_habitacion = h.id_habitacion "
                    + "JOIN Sede sd ON sd.id_sede = h.id_sede "
                    + "JOIN Tipo_Habitacion th ON h.id_tipo_hab = th.id_tipo_hab "
                    + "LEFT JOIN Servicio s ON dr.id_servicio = s.id_servicio "
                    + "WHERE (r.fecha_reserva between ? AND ?) AND r.fecha_salida IS NOT NULL";
            ps = cn.prepareStatement(sql);
            ps.setString(1, inicio);
            ps.setString(2, fin);
            rs = ps.executeQuery();

            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setIdSede(rs.getInt("id_sede"));
                reserva.setIdCliente(rs.getInt("id_cliente"));
                reserva.setNombreReservante(rs.getString("nombre_reservante"));
                reserva.setCorreo(rs.getString("correo"));
                reserva.setNroDocumento(rs.getString("nro_documento"));
                reserva.setNroCelular(rs.getString("nro_celular"));
                reserva.setFechaReserva(rs.getString("fecha_reserva"));
                reserva.setHoraReserva(rs.getString("hora_reserva"));
                reserva.setFechaSalida(rs.getString("fecha_salida"));
                reserva.setHoraSalida(rs.getString("hora_salida"));
                reserva.setPagoBruto(rs.getDouble("pago_bruto"));
                reserva.setPagoAdicion(rs.getDouble("pago_adicion"));
                reserva.setPagoTotal(rs.getDouble("pago_total"));

                // Detalle de la reserva
                DetalleReserva detalleReserva = new DetalleReserva();

                TipoHabitacion tipoHabitacion = new TipoHabitacion();
                tipoHabitacion.setIdTipoHab(rs.getInt("id_tipo_hab"));
                tipoHabitacion.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                tipoHabitacion.setCosto(rs.getDouble("costo"));

                Habitacion habitacion = new Habitacion();
                habitacion.setIdHab(rs.getInt("id_habitacion"));
                habitacion.setNroHab(rs.getString("nro_habitacion"));
                habitacion.setDescripcionCama(rs.getString("descripcion_cama"));
                habitacion.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                habitacion.setDescripcionDucha(rs.getString("descripcion_ducha"));
                habitacion.setDescripcionPersonas(rs.getString("descripcion_personas"));
                habitacion.setTipoHab(tipoHabitacion);

                Sede sede = new Sede();
                sede.setNombre(rs.getString("nombre_sede"));

                habitacion.setSede(sede);
                detalleReserva.setHabitacion(habitacion);

                if (rs.getObject("id_servicio") != null) {
                    Servicio servicio = new Servicio();
                    servicio.setIdServicio(rs.getInt("id_servicio"));
                    servicio.setNombre(rs.getString("nombre_servicio"));
                    detalleReserva.setServicio(servicio);
                }

                detalleReserva.setCantAdultos(rs.getInt("cant_adultos"));
                detalleReserva.setCantNinios(rs.getInt("cant_niños"));
                detalleReserva.setCostoReserva(rs.getDouble("costo_reserva"));
                detalleReserva.setCostoServicio(rs.getDouble("costo_servicio"));

                reserva.setDetalleReserva(detalleReserva);

                lista.add(reserva);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

}
