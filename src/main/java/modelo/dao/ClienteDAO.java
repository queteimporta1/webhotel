package modelo.dao;

import config.Conexion;
import dto.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Cliente;
import modelo.Pais;
import modelo.TipoDocumento;
import modelo.Usuario;

public class ClienteDAO extends DBABase {

    public Cliente BuscarPorIdUsuario(int idUsuario) {
        Cliente objCli = null;
        Usuario objUsu = null;
        TipoDocumento objtTipoDoc = null;
        Pais objPais = null;

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Cliente c"
                    + " inner join Tipo_Documento t "
                    + " on t.id_tipo_doc = c.id_tipo_doc"
                    + " inner join Pais p "
                    + " on p.id_pais = c.id_pais "
                    + " inner join Usuario u "
                    + " on u.id_usuario = c.id_usuario"
                    + " where u.id_usuario=?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                objCli = new Cliente();
                objtTipoDoc = new TipoDocumento();
                objPais = new Pais();
                objUsu = new Usuario();
                objCli.setNombreCompleto(rs.getString("nombre_completo"));
                objCli.setNroCelular(rs.getString("nro_celular"));
                objCli.setNroDocumento(rs.getString("nro_documento"));
                objCli.setGenero(rs.getString("genero"));
                objCli.setFoto(rs.getString("foto"));
                objCli.setGenero(rs.getString("genero"));
                objtTipoDoc.setIdTipoDoc(rs.getInt("id_tipo_doc"));
                objtTipoDoc.setNombre(rs.getString("nombre_tipo_doc"));
                objPais.setNombre(rs.getString("nombre_pais"));
                objUsu.setCorreo(rs.getString("correo"));
                objCli.setPais(objPais);
                objCli.setTipoDocumento(objtTipoDoc);
                objCli.setUsuario(objUsu);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return objCli;
    }

    public int registrar(Cliente cliente) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            cs = cn.prepareCall("{CALL sp_insertar_cliente(?, ?, ?, ?, ?, ?, ?, ?)}");

            cs.setString(1, cliente.getUsuario().getCorreo());
            cs.setString(2, cliente.getUsuario().getPassword());
            cs.setInt(3, cliente.getPais().getIdPais());
            cs.setInt(4, cliente.getTipoDocumento().getIdTipoDoc());
            cs.setString(5, cliente.getNombreCompleto());
            cs.setString(6, cliente.getNroCelular());
            cs.setString(7, cliente.getNroDocumento());
            cs.setString(8, cliente.getGenero());
            rs = cs.executeQuery();

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
}
