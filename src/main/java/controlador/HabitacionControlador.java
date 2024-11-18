package controlador;

import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import modelo.Habitacion;
import modelo.Sede;
import modelo.TipoHabitacion;
import modelo.dao.HabitacionDAO;
import modelo.dao.SedeDAO;
import modelo.dao.TipoHabitacionDAO;
import utils.FileUtil;

@MultipartConfig
public class HabitacionControlador extends HttpServlet {

    private SedeDAO sedeDao = new SedeDAO();
    private TipoHabitacionDAO tipoHabDao = new TipoHabitacionDAO();
    private HabitacionDAO habDao = new HabitacionDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "inicio":
                Inicio(request, response);
                break;
            case "consultar":
                Consultar(request, response);
                break;
            case "listar":
                Listar(request, response);
                break;
            case "nuevo":
                nuevo(request, response);
                break;
            case "guardar":
                guardar(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            case "consultar_disponibilidad":
                ConsultarHabitacionDisponibles(request, response);
                break;
        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int result = habDao.Eliminar(id);

            if (result > 0) {
                request.getSession().setAttribute("success", "Habitación con id " + id + " eliminado!");
            } else {
                request.getSession().setAttribute("error", "No se pudo eliminar la habitación con ID " + id);
            }
        } catch (Exception ex) {
            request.getSession().setAttribute("error", ex.getMessage());
        }

        response.sendRedirect("HabitacionControlador?accion=listar");
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Habitacion obj = new Habitacion();
        try {
            obj.setIdHab(Integer.parseInt(request.getParameter("id")));
            obj.setNroHab(request.getParameter("nroHab"));
            obj.setDescripcionDucha(request.getParameter("descripcionDucha"));
            obj.setDescripcionCama(request.getParameter("descripcionCama"));
            obj.setDescripcionPersonas(request.getParameter("descripcionPersonas"));
            obj.setDescripcionDesayuno(request.getParameter("descripcionDesayuno"));
            obj.setSede(new Sede(Integer.parseInt(request.getParameter("idSede"))));
            obj.setTipoHab(new TipoHabitacion(Integer.parseInt(request.getParameter("idTipoHab"))));

            Part archivoPart = request.getPart("imagen");
            if (archivoPart.getSize() != 0) {
                String ruta = FileUtil.RutaAbsoluta(request, FileUtil.RUTA_IMAGEN);
                String imagen = FileUtil.guardarArchivo(ruta, archivoPart, FileUtil.NomImagen());
                obj.setImagen(imagen);
            } else {
                obj.setImagen(null);
            }

            int result;

            if (obj.getIdHab() == 0) {
                result = habDao.Registrar(obj);
            } else {
                if (obj.getImagen() != null) {
                    result = habDao.Editar(obj);
                } else {
                    result = habDao.EditarSinIMG(obj);
                }
            }

            if (result > 0) {
                request.getSession().setAttribute("success", obj.getIdHab() == 0 ? "Habitación registrada!" : "Habitación modificado!");
                response.sendRedirect("HabitacionControlador?accion=listar");
                return;
            } else {
                request.getSession().setAttribute("error", "No se pudo guardar datos.");
            }
        } catch (Exception ex) {
            request.getSession().setAttribute("error", ex.getMessage());
        }

        request.setAttribute("habitacion", obj);
        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.setAttribute("tipoHabitaciones", tipoHabDao.ListarTodos());
        request.getRequestDispatcher("pagNuevaHabitacion.jsp").forward(request, response);

    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        Habitacion obj = habDao.BuscarPorId(id);

        if (obj != null) {
            request.setAttribute("habitacion", obj);
            request.setAttribute("sedes", sedeDao.ListarTodos());
            request.setAttribute("tipoHabitaciones", tipoHabDao.ListarTodos());
            request.getRequestDispatcher("pagNuevaHabitacion.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "No se encontro habitación con ID " + id);
            response.sendRedirect("HabitacionControlador?accion=listar");
        }
    }

    private void nuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("habitacion", new Habitacion());
        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.setAttribute("tipoHabitaciones", tipoHabDao.ListarTodos());
        request.getRequestDispatcher("pagNuevaHabitacion.jsp").forward(request, response);
    }

    protected void ConsultarHabitacionDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        int idSede = Integer.parseInt(request.getParameter("idSede"));
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        int idTipoHab = Integer.parseInt(request.getParameter("idTipoHab"));

        List<Habitacion> lista = habDao.ConsultarHabitacionDisponibles(idSede, fecha, hora, idTipoHab);

        out.print(new Gson().toJson(lista));
    }

    protected void Listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.setAttribute("habitaciones", habDao.ListarTodos());
        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.getRequestDispatcher("pagGestHabitacion.jsp").forward(request, response);
    }

    protected void Inicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.setAttribute("tipohabitaciones", tipoHabDao.ListarTodos());
        request.setAttribute("habitaciones", new ArrayList<>());
        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.getRequestDispatcher("pagHabitaciones.jsp").forward(request, response);
    }

    protected void Consultar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        int idTipoHab = Integer.parseInt(request.getParameter("id"));
        int idSede = Integer.parseInt(request.getParameter("sede"));

        ArrayList<Habitacion> lista = habDao.ListarDisponibles(fecha, hora,
                idTipoHab, idSede);

        if (lista.size() == 0) {
            request.getSession().setAttribute("info", "No se encontraron habitaciones disponibles con el criterio de busqueda.");
            request.getSession().removeAttribute("fecha");
            request.getSession().removeAttribute("hora");
            request.getSession().removeAttribute("idTipoHab");
            request.getSession().removeAttribute("idSede");
        } else {
            request.getSession().setAttribute("fecha", fecha);
            request.getSession().setAttribute("hora", hora);
            request.getSession().setAttribute("idTipoHab", idTipoHab);
            request.getSession().setAttribute("idSede", idSede);
        }

        request.setAttribute("tipohabitaciones", tipoHabDao.ListarTodos());
        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.setAttribute("habitaciones", lista);
        request.setAttribute("fecha", fecha);
        request.setAttribute("hora", hora);
        request.setAttribute("id", idTipoHab);
        request.setAttribute("sede", idSede);

        request.getRequestDispatcher("pagHabitaciones.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
