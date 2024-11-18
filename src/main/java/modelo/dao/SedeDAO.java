package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import modelo.Sede;

public class SedeDAO extends DBABase {

    public ArrayList<Sede> ListarTodos() {
        ArrayList<Sede> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Sede";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Sede obj = new Sede();
                obj.setIdSede(rs.getInt("id_sede"));
                obj.setNombre(rs.getString("nombre_sede"));
                obj.setCoordenadaLatitud(rs.getString("coordenada_latitud"));
                obj.setCoordenadaLongitud(rs.getString("coordenada_longitud"));
                obj.setDepartamento(rs.getString("departamento"));
                obj.setUbicacion(rs.getString("ubicacion"));
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
