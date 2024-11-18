package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import modelo.TipoDocumento;

public class TipoDocumentoDAO extends DBABase {

    public ArrayList<TipoDocumento> ListarTodos() {
        ArrayList<TipoDocumento> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Tipo_Documento "
                    + " order by nombre_tipo_doc asc";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                TipoDocumento obj = new TipoDocumento();
                obj.setIdTipoDoc(rs.getInt("id_tipo_doc"));
                obj.setNombre(rs.getString("nombre_tipo_doc"));
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
