package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import modelo.Pais;

public class PaisDAO extends DBABase {

    public ArrayList<Pais> ListarTodos() {
        ArrayList<Pais> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Pais "
                    + " order by nombre_pais asc";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Pais obj = new Pais();
                obj.setIdPais(rs.getInt("id_pais"));
                obj.setNombre(rs.getString("nombre_pais"));
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
