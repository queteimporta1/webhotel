package modelo.dao;

import config.Conexion;
import dto.UsuarioDTO;
import modelo.*;

public class AuthDAO extends DBABase {

    public UsuarioDTO Login(String correo, String password) {
        UsuarioDTO obj = null;

        try {
            cn = Conexion.getConnection();
            String sql = "{CALL sp_login(?,?)}";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                obj = new UsuarioDTO();
                obj.setId(rs.getInt("id"));
                obj.setIdUsuario(rs.getInt("id_usuario"));
                obj.setIdRol(rs.getInt("id_rol"));
                obj.setNombreRol(rs.getString("nombre_rol"));
                obj.setNombreUsuario(rs.getString("nombre_completo"));
                obj.setCorreo(rs.getString("correo"));
                obj.setFoto(rs.getString("foto"));
                obj.setGenero(rs.getString("genero"));
                obj.setPassword(rs.getString("password"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return obj;
    }
}
