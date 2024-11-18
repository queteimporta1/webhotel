package controlador;

import dto.UsuarioDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Cliente;
import modelo.Comentario;
import modelo.dao.ComentarioDAO;

public class ComentarioControlador extends HttpServlet {

    private ComentarioDAO comentarioDao = new ComentarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "guardar":
                guardar(request, response);
                break;
        }
    }

    protected void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        UsuarioDTO objLogeado = (UsuarioDTO) request.getSession().getAttribute("usuario");

        if (objLogeado != null) {
            Comentario obj = new Comentario();
            obj.setCliente(new Cliente(objLogeado.getId()));
            obj.setServicio(request.getParameter("servicio").trim());
            obj.setHabitacion(request.getParameter("habitacion").trim());
            obj.setAmbiente(request.getParameter("ambiente").trim());
            obj.setNroCalificacion(Integer.parseInt(request.getParameter("calificacion").trim()));
            obj.setDescripcion(request.getParameter("comentario").trim());

            String msg = comentarioDao.Guardar(obj);

            if (msg.equals("OK")) {
                request.getSession().setAttribute("success", "¡En Hora buena! Tu comentario se registró de forma correcta.");
            } else {
                request.getSession().setAttribute("error", msg);
            }
        }

        response.sendRedirect("index.jsp");
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
