package modelo.dao;

import config.Conexion;

public class UsuarioDAO extends DBABase {

    public int CantInscritos() {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            String sql = "select count(1) from usuario";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }

    public int ExisteCorreo(String correo, int id) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            String sql = "select count(1) from usuario where correo=? and id_usuario !=?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setInt(2, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }

    public int ActualizarCorreo(int idUsuario, String nuevoCorreo) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            String sql = "UPDATE usuario SET correo = ? WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevoCorreo);
            ps.setInt(2, idUsuario);

            result = ps.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
    
    public int ActualizarPassword(int idUsuario, String nuevoPassword) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            String sql = "UPDATE usuario SET password = ? WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevoPassword);
            ps.setInt(2, idUsuario);

            result = ps.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
    
     public int ActualizarFoto(int idUsuario, String nuevaFoto) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            String sql = "UPDATE usuario SET foto = ? WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevaFoto);
            ps.setInt(2, idUsuario);

            result = ps.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
}
