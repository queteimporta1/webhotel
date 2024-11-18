package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import modelo.Servicio;
import modelo.TipoHabitacion;

public class TipoHabitacionDAO extends DBABase {

    public ArrayList<TipoHabitacion> ListarTodos() {
        ArrayList<TipoHabitacion> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Tipo_Habitacion";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                TipoHabitacion obj = new TipoHabitacion();
                obj.setIdTipoHab(rs.getInt("id_tipo_hab"));
                obj.setNombreTipoHab(rs.getString("nombre_tipo_hab"));
                obj.setCosto(rs.getDouble("costo"));
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
