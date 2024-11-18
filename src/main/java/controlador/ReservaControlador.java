package controlador;

import com.google.gson.Gson;
import dto.UsuarioDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modelo.DetalleReserva;
import modelo.Habitacion;
import modelo.Reserva;
import modelo.Servicio;
import modelo.Usuario;
import modelo.dao.ClienteDAO;
import modelo.dao.ReservaDAO;
import modelo.dao.SedeDAO;
import modelo.dao.ServicioDAO;
import modelo.dao.TipoDocumentoDAO;
import modelo.dao.TipoHabitacionDAO;
import utils.PDFResource;

public class ReservaControlador extends HttpServlet {

    private ReservaDAO reservaDao = new ReservaDAO();
    private SedeDAO sedeDao = new SedeDAO();
    private TipoHabitacionDAO tipoHabDao = new TipoHabitacionDAO();
    private TipoDocumentoDAO tipoDocDao = new TipoDocumentoDAO();
    private ClienteDAO clienteDao = new ClienteDAO();
    private ServicioDAO servicioDao = new ServicioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "form_registro":
                FormRegistro(request, response);
                break;
            case "buscar_pendientes_por_nrodoc":
                BuscarPendientesPorNroDoc(request, response);
                break;
            case "buscar_por_Id_JSON":
                BuscarPorIDJSON(request, response);
                break;
            case "inicio":
                InicioReserva(request, response);
                break;
            case "registrar":
                registrarReserva(request, response);
                break;
            case "exportarPDF":
                exportarPDF(request, response);
                break;
            case "registrar_entrada":
                RegistrarEntrada(request, response);
                break;
            case "registrar_salida":
                RegistrarSalida(request, response);
                break;
            case "lista_entrada":
                ListarReservasConEntradas(request, response);
                break;
            case "consulta":
                Consulta(request, response);
                break;
        }
    }

    protected void Consulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Reserva> lista;
        String inicio = "", fin = "";

        if (request.getParameter("inicio") != null && request.getParameter("fin") != null) {
            inicio = request.getParameter("inicio");
            fin = request.getParameter("fin");
            lista = reservaDao.ConsultaReservasConSalida(inicio, fin);
        } else {
            lista = new ArrayList<>();
        }
        
        request.setAttribute("reservas", lista);
        request.setAttribute("inicio", inicio);
        request.setAttribute("fin", fin);
        request.getRequestDispatcher("pagConsultaReserva.jsp").forward(request, response);
    }

    protected void BuscarPorIDJSON(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        PrintWriter out = response.getWriter();
        Reserva obj = reservaDao.BuscarPorId(id);
        out.print(new Gson().toJson(obj));
    }

    protected void ListarReservasConEntradas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        List<Reserva> lista;
        int id = 0;
        if (request.getParameter("idSede") == null) {
            lista = new ArrayList<>();
        } else {
            id = Integer.parseInt(request.getParameter("idSede").trim());
            lista = reservaDao.ListarReservasConEntrada(id);
        }

        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.setAttribute("reservas", lista);
        request.setAttribute("idSede", id);
        request.getRequestDispatcher("pagReservasConEntrada.jsp").forward(request, response);
    }

    protected void RegistrarEntrada(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("idReserva").trim());

        int result = reservaDao.RegistrarEntrada(id);

        if (result > 0) {
            request.getSession().setAttribute("success", "Entrada registrado correctamente.");
        } else {
            request.getSession().setAttribute("info", "No se pudo realizar entrada al hotel.");
        }

        response.sendRedirect("ReservaControlador?accion=form_registro");
    }

    protected void RegistrarSalida(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("idReserva").trim());
        int idSede = Integer.parseInt(request.getParameter("idSede").trim());
        int result = reservaDao.RegistrarSalida(id);

        if (result > 0) {
            request.getSession().setAttribute("success", "Salida registrada correctamente.");
        } else {
            request.getSession().setAttribute("info", "No se pudo realizar salida del hotel.");
        }

        response.sendRedirect("ReservaControlador?idSede=" + idSede + "&accion=lista_entrada");
    }

    protected void BuscarPendientesPorNroDoc(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String nro = request.getParameter("nro");
        PrintWriter out = response.getWriter();
        List<Reserva> lista = reservaDao.BuscarPorNroDocPendientes(nro);
        out.print(new Gson().toJson(lista));
    }

    protected void exportarPDF(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String fechaHora = sdf.format(new Date());
        int id = Integer.parseInt(request.getParameter("id"));
        String numeroReserva = String.valueOf(id);

        String nombreArchivo = "Reserva_" + numeroReserva + "_" + fechaHora + ".pdf";

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");

        try {
            PDFResource pdfResource = new PDFResource();

            String ruta = RutaAbsoluta();
            Reserva reserva = reservaDao.BuscarPorId(id);

            ByteArrayInputStream pdfStream = pdfResource.generateReservaPDF(response, reserva, ruta);

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = pdfStream.read(buffer)) != -1) {
                response.getOutputStream().write(buffer, 0, bytesRead);
            }

            response.getOutputStream().flush();
            response.getOutputStream().close();
            pdfStream.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error al generar el PDF", e);
        }
    }

    protected void registrarReserva(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> resultado = new HashMap<>();
        Reserva reserva = null;
        try {
            UsuarioDTO usuario = (UsuarioDTO) request.getSession().getAttribute("usuario");

            int idHabitacion = Integer.parseInt(request.getParameter("idHabitacion"));
            int idServicio = Integer.parseInt(request.getParameter("idServicio"));

            reserva = new Reserva();
            reserva.setIdSede(Integer.parseInt(request.getParameter("idSede")));
            reserva.setIdCliente(usuario.getId());
            reserva.setNombreReservante(usuario.getNombreUsuario());
            reserva.setCorreo(request.getParameter("correo"));
            reserva.setNroDocumento(request.getParameter("nroDocumento"));
            reserva.setNroCelular(request.getParameter("nroCelular"));
            reserva.setFechaReserva(request.getParameter("fechaReserva"));
            reserva.setHoraReserva(request.getParameter("horaReserva"));
            reserva.setPagoBruto(Double.parseDouble(request.getParameter("pagoBruto")));
            reserva.setPagoAdicion(Double.parseDouble(request.getParameter("pagoAdicion")));

            DetalleReserva detalle = new DetalleReserva();
            detalle.setHabitacion(new Habitacion(idHabitacion));
            detalle.setServicio(new Servicio(idServicio));
            detalle.setCantAdultos(Integer.parseInt(request.getParameter("cantAdultos")));
            detalle.setCantNinios(Integer.parseInt(request.getParameter("cantNinios")));
            reserva.setDetalleReserva(detalle);

            resultado = reservaDao.Guardar(reserva);

        } catch (Exception e) {
            resultado.put("error", "Error: " + e.getMessage());
        } finally {
            resultado.put("data", reserva);
            out.print(new Gson().toJson(resultado));
            out.flush();
        }
    }

    protected void InicioReserva(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        if (request.getSession().getAttribute("usuario") == null) {
            request.getSession().setAttribute("info", "Debe iniciar sesión primero para poder generar una reserva.");
            response.sendRedirect("pagLogin.jsp");
            return;
        }

        UsuarioDTO usuario = (UsuarioDTO) request.getSession().getAttribute("usuario");

        request.setAttribute("cliente", clienteDao.BuscarPorIdUsuario(usuario.getIdUsuario()));
        request.setAttribute("tipohabitaciones", tipoHabDao.ListarTodos());
        request.setAttribute("tipoDocumentos", tipoDocDao.ListarTodos());
        request.setAttribute("sedes", sedeDao.ListarTodos());
        request.getRequestDispatcher("pagReserva.jsp").forward(request, response);
    }

    protected void FormRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.getRequestDispatcher("pagRegistroEntrada.jsp").forward(request, response);
    }

    public String RutaAbsoluta() {
        String ubicacion = getServletContext().getRealPath("");
        String ruta = "src\\main\\webapp\\";

        return ubicacion.substring(0, ubicacion.indexOf("target")) + ruta;
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
