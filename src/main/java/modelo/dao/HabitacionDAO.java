package modelo.dao;

import config.Conexion;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import modelo.Habitacion;
import modelo.Sede;
import modelo.TipoHabitacion;

public class HabitacionDAO extends DBABase {

    public int Registrar(Habitacion obj) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            cs = cn.prepareCall("INSERT INTO habitacion(id_tipo_hab,nro_habitacion,descripcion_ducha,descripcion_cama,descripcion_personas,descripcion_desayuno,imagen,id_sede) VALUES(?,?,?,?,?,?,?,?)");

            cs.setInt(1, obj.getTipoHab().getIdTipoHab());
            cs.setString(2, obj.getNroHab());
            cs.setString(3, obj.getDescripcionDucha());
            cs.setString(4, obj.getDescripcionCama());
            cs.setString(5, obj.getDescripcionPersonas());
            cs.setString(6, obj.getDescripcionDesayuno());
            cs.setString(7, obj.getImagen());
            cs.setInt(8, obj.getSede().getIdSede());
            result = cs.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }

    public int Editar(Habitacion obj) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            cs = cn.prepareCall("UPDATE habitacion SET id_tipo_hab = ?, nro_habitacion = ?, descripcion_ducha = ?, descripcion_cama = ?, descripcion_personas = ?, descripcion_desayuno = ?, imagen = ?, id_sede = ? WHERE id_habitacion = ?");

            cs.setInt(1, obj.getTipoHab().getIdTipoHab());
            cs.setString(2, obj.getNroHab());
            cs.setString(3, obj.getDescripcionDucha());
            cs.setString(4, obj.getDescripcionCama());
            cs.setString(5, obj.getDescripcionPersonas());
            cs.setString(6, obj.getDescripcionDesayuno());
            cs.setString(7, obj.getImagen());
            cs.setInt(8, obj.getSede().getIdSede());
            cs.setInt(9, obj.getIdHab());

            result = cs.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
    public int EditarSinIMG(Habitacion obj) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            cs = cn.prepareCall("UPDATE habitacion SET id_tipo_hab = ?, nro_habitacion = ?, descripcion_ducha = ?, descripcion_cama = ?, descripcion_personas = ?, descripcion_desayuno = ?, id_sede = ? WHERE id_habitacion = ?");

            cs.setInt(1, obj.getTipoHab().getIdTipoHab());
            cs.setString(2, obj.getNroHab());
            cs.setString(3, obj.getDescripcionDucha());
            cs.setString(4, obj.getDescripcionCama());
            cs.setString(5, obj.getDescripcionPersonas());
            cs.setString(6, obj.getDescripcionDesayuno());
            cs.setInt(7, obj.getSede().getIdSede());
            cs.setInt(8, obj.getIdHab());

            result = cs.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
    public int Eliminar(int id) throws Exception {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            ps = cn.prepareStatement("DELETE FROM habitacion WHERE id_habitacion = ?");
            ps.setInt(1, id);
            result = ps.executeUpdate();
        } catch (SQLIntegrityConstraintViolationException e) {
            throw new Exception("No se puede eliminar el habitacion porque está referenciado en otros registros.");
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }

    public ArrayList<Habitacion> ListarTodos() {
        ArrayList<Habitacion> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "select * from habitacion h "
                    + " inner join tipo_habitacion t on t.id_tipo_hab = h.id_tipo_hab"
                    + " inner join sede s on s.id_sede = h.id_sede";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                TipoHabitacion objTh = new TipoHabitacion();
                Habitacion obj = new Habitacion();
                Sede objSede = new Sede();
                objTh.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                objTh.setCosto(rs.getDouble("costo"));
                objSede.setNombre(rs.getString("nombre_sede"));
                obj.setIdHab(rs.getInt("id_habitacion"));
                obj.setNroHab(rs.getString("nro_habitacion"));
                obj.setDescripcionCama(rs.getString("descripcion_cama"));
                obj.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                obj.setDescripcionDucha(rs.getString("descripcion_ducha"));
                obj.setDescripcionPersonas(rs.getString("descripcion_personas"));
                obj.setImagen(rs.getString("imagen"));
                obj.setTipoHab(objTh);
                obj.setSede(objSede);
                lista.add(obj);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

    public Habitacion BuscarPorId(int id) {
        Habitacion obj = null;

        try {
            cn = Conexion.getConnection();
            String sql = "select * from habitacion h "
                    + "inner join tipo_habitacion t "
                    + "on t.id_tipo_hab = h.id_tipo_hab"
                    + " where h.id_habitacion = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                TipoHabitacion objTh = new TipoHabitacion();
                Sede objSede = new Sede();
                obj = new Habitacion();
                objTh.setIdTipoHab(rs.getInt("id_tipo_hab"));
                objTh.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                objTh.setCosto(rs.getDouble("costo"));
                objSede.setIdSede(rs.getInt("id_sede"));
                obj.setIdHab(rs.getInt("id_habitacion"));
                obj.setNroHab(rs.getString("nro_habitacion"));
                obj.setDescripcionCama(rs.getString("descripcion_cama"));
                obj.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                obj.setDescripcionDucha(rs.getString("descripcion_ducha"));
                obj.setDescripcionPersonas(rs.getString("descripcion_personas"));
                obj.setImagen(rs.getString("imagen"));
                obj.setTipoHab(objTh);
                obj.setSede(objSede);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return obj;
    }

    public ArrayList<Habitacion> ListarDisponibles(String fecha, String hora, int idTipoHab, int idSede) {
        ArrayList<Habitacion> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "{call sp_consultar_disponibilidad_habitacion(?,?,?,?)}";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idSede);
            ps.setString(2, fecha);
            ps.setString(3, hora);
            ps.setInt(4, idTipoHab);
            rs = ps.executeQuery();

            while (rs.next()) {
                TipoHabitacion objTh = new TipoHabitacion();
                Habitacion obj = new Habitacion();
                objTh.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                objTh.setCosto(rs.getDouble("costo"));
                obj.setIdHab(rs.getInt("id_habitacion"));
                obj.setNroHab(rs.getString("nro_habitacion"));
                obj.setDescripcionCama(rs.getString("descripcion_cama"));
                obj.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                obj.setDescripcionDucha(rs.getString("descripcion_ducha"));
                obj.setDescripcionPersonas(rs.getString("descripcion_personas"));
                obj.setImagen(rs.getString("imagen"));
                obj.setTipoHab(objTh);
                lista.add(obj);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

    public ArrayList<Habitacion> ConsultarHabitacionDisponibles(
            int idSede, String fecha, String hora, int idTipoHab) {
        ArrayList<Habitacion> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "{CALL sp_consultar_disponibilidad_habitacion(?,?,?,?)}";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idSede);
            ps.setString(2, fecha);
            ps.setString(3, hora);
            ps.setInt(4, idTipoHab);
            rs = ps.executeQuery();

            while (rs.next()) {
                TipoHabitacion objTh = new TipoHabitacion();
                Habitacion obj = new Habitacion();
                objTh.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                objTh.setCosto(rs.getDouble("costo"));
                obj.setIdHab(rs.getInt("id_habitacion"));
                obj.setNroHab(rs.getString("nro_habitacion"));
                obj.setDescripcionCama(rs.getString("descripcion_cama"));
                obj.setDescripcionDesayuno(rs.getString("descripcion_desayuno"));
                obj.setDescripcionDucha(rs.getString("descripcion_ducha"));
                obj.setDescripcionPersonas(rs.getString("descripcion_personas"));
                obj.setImagen(rs.getString("imagen"));
                obj.setTipoHab(objTh);
                lista.add(obj);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }
}
