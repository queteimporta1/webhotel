package modelo.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBABase {

    protected Connection cn = null;
    protected PreparedStatement ps = null;
    protected ResultSet rs = null;
   protected CallableStatement cs = null;
     
    protected void CerrarConexion() {
        try {
            if (cn != null) {
                cn.close();
            }
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
             if (cs != null) {
                cs.close();
            }
        } catch (Exception ex) {
            System.out.println("Error al cerrar conexion: " + ex.getMessage());
        }
    }
}
