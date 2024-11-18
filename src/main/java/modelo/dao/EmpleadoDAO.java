package modelo.dao;

import config.Conexion;
import modelo.Cliente;
import modelo.Empleado;
import modelo.Pais;
import modelo.TipoDocumento;

public class EmpleadoDAO extends DBABase {

    public Empleado BuscarPorIdUsuario(int idUsuario) {
        Empleado objEmp = null;
        TipoDocumento objtTipoDoc = null;
        Pais objPais = null;

        try {
            cn = Conexion.getConnection();
            String sql = "select * from Empleado c"
                    + " inner join Tipo_Documento t "
                    + " on t.id_tipo_doc = c.id_tipo_doc"
                    + " inner join Pais p "
                    + " on p.id_pais = c.id_pais"
                    + " where id_usuario=?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                objEmp = new Empleado();
                objtTipoDoc = new TipoDocumento();
                objPais = new Pais();
                objEmp.setNombreCompleto(rs.getString("nombre_completo"));
                objEmp.setNroCelular(rs.getString("nro_celular"));
                objEmp.setNroDocumento(rs.getString("nro_documento"));
                objEmp.setGenero(rs.getString("genero"));
                objEmp.setFoto(rs.getString("foto"));
                objEmp.setGenero(rs.getString("genero"));
                objtTipoDoc.setNombre(rs.getString("nombre_tipo_doc"));
                objPais.setNombre(rs.getString("nombre_pais"));
                objEmp.setPais(objPais);
                objEmp.setTipoDocumento(objtTipoDoc);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return objEmp;
    }
}
