package modelo.dao;

import config.Conexion;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import modelo.*;

public class ComentarioDAO extends DBABase {

    public ArrayList<Comentario> ListarTodos() {
        ArrayList<Comentario> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "SELECT * FROM Comentario cm "
                    + " INNER JOIN Cliente c ON c.id_cliente = cm.id_cliente "
                    + " INNER JOIN Usuario u ON c.id_usuario = u.id_usuario "
                    + " ORDER BY fecha_comentario DESC";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Comentario obj = new Comentario();
                Cliente cli = new Cliente();
                Usuario usu = new Usuario();
                obj.setDescripcion(rs.getString("descripcion"));
                obj.setFecha(rs.getString("fecha_comentario"));
                obj.setNroCalificacion(rs.getInt("nro_calificacion"));
                cli.setFoto(rs.getString("foto"));
                cli.setGenero(rs.getString("genero"));
                cli.setNombreCompleto(rs.getString("nombre_completo"));
                usu.setCorreo(rs.getString("correo"));
                cli.setUsuario(usu);
                obj.setCliente(cli);
                lista.add(obj);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return lista;
    }

    public String Guardar(Comentario obj) {
        String msg = "";

        try {
            cn = Conexion.getConnection();
            String sql = "INSERT INTO Comentario (id_cliente, descripcion, fecha_comentario, servicio, habitacion, ambiente, nro_calificacion) "
                    + "VALUES (?, ?, NOW(), ?, ?, ?, ?)";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, obj.getCliente().getIdCliente());
            ps.setString(2, obj.getDescripcion());
            ps.setString(3, obj.getServicio());
            ps.setString(4, obj.getHabitacion());
            ps.setString(5, obj.getAmbiente());
            ps.setInt(6, obj.getNroCalificacion());

            msg = ps.executeUpdate() > 0 ? "OK" : "No se pudo registrar comentario.";

        } catch (Exception ex) {
            msg = ex.getMessage();
            ex.printStackTrace();
        } finally {
            CerrarConexion();
        }

        return msg;
    }

    public ArrayList<Comentario> listarPorcentajeCalificaciones() {
        ArrayList<Comentario> lista = new ArrayList<>();

        try {
            cn = Conexion.getConnection();
            String sql = "{CALL sp_listar_porcentajeCalifiacion()}";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Comentario obj = new Comentario();
                obj.setNroCalificacion(rs.getInt("nro"));
                obj.setPorcCalificacion(rs.getDouble("porcentaje"));
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
