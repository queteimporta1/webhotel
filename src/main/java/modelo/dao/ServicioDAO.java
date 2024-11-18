package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import modelo.Servicio;

public class ServicioDAO extends DBABase {

    public ArrayList<Servicio> ListarTodos() {
        ArrayList<Servicio> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Servicio";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Servicio obj = new Servicio();
                obj.setIdServicio(rs.getInt("id_servicio"));
                obj.setNombre(rs.getString("nombre_servicio"));
                obj.setCosto(rs.getDouble("costo"));
                obj.setImagen(rs.getString("imagen"));
                obj.setDescripcion(rs.getString("descripcion"));
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
