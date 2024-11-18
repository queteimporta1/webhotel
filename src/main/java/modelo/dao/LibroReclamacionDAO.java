package modelo.dao;

import config.Conexion;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.ArchivoLibro;
import modelo.Cliente;
import modelo.LibroReclamacion;

public class LibroReclamacionDAO extends DBABase {

    public int registrar(LibroReclamacion obj) {
        int result = 0;

        try {
            cn = Conexion.getConnection();
            cn.setAutoCommit(false);

            ps = cn.prepareStatement("INSERT INTO Libro_Reclamacion "
                    + "(id_sede, id_cliente, nro_celular, nro_documento, correo, mensaje, fecha) VALUES (?, ?, ?, ?, ?, ?, NOW())", PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, obj.getSede().getIdSede()); 
            ps.setInt(2, obj.getCliente().getIdCliente()); 
            ps.setString(3, obj.getNroCelular());
            ps.setString(4, obj.getNroDocumento());
            ps.setString(5, obj.getCorreo());
            ps.setString(6, obj.getMensaje());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                result = rs.getInt(1);
                ps = cn.prepareStatement("{call sp_insertar_libro_archivos(?,?,?,?)}");
                for(ArchivoLibro arch: obj.getArchivos()){
                   ps.setString(1, arch.getArchivo().getNombreArchivo());
                   ps.setString(2, arch.getArchivo().getNombreOriginal());
                   ps.setString(3, arch.getArchivo().getTipoArchivo());
                   ps.setInt(4, result);
                   ps.executeUpdate();
                }
            }

            cn.commit();
        } catch (SQLException ex) {
            if (cn != null) {

            }
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return result;
    }
}
