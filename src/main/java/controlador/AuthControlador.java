package controlador;

import com.google.gson.Gson;
import dto.UsuarioDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Cliente;
import modelo.Pais;
import modelo.TipoDocumento;
import modelo.Usuario;
import modelo.dao.AuthDAO;
import modelo.dao.ClienteDAO;
import modelo.dao.PaisDAO;
import modelo.dao.TipoDocumentoDAO;
import modelo.dao.UsuarioDAO;
import utils.ConstantesApp;

public class AuthControlador extends HttpServlet {

    private TipoDocumentoDAO tipoDocDao = new TipoDocumentoDAO();
    private PaisDAO paisDao = new PaisDAO();
    private AuthDAO authDao = new AuthDAO();
    private ClienteDAO clienteDao = new ClienteDAO();
    private UsuarioDAO usuarioDao = new UsuarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "login":
                Login(request, response);
                break;
            case "logout":
                Logout(request, response);
                break;
            case "new_account":
                NuevaCuenta(request, response);
                break;
            case "register":
                Register(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }

    protected void Register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String nroCelular = request.getParameter("nroCelular");
        String nroDocumento = request.getParameter("nroDocumento");
        int idTipoDocumento = Integer.parseInt(request.getParameter("tipoDocumento"));
        int idPais = Integer.parseInt(request.getParameter("pais"));
        String genero = request.getParameter("genero");
        String nombreCompleto = request.getParameter("nombreCompleto");

        Cliente cliente = new Cliente();
        cliente.setPais(new Pais(idPais));
        cliente.setTipoDocumento(new TipoDocumento(idTipoDocumento));
        cliente.setUsuario(new Usuario(correo, password));
        cliente.setNroCelular(nroCelular);
        cliente.setNroDocumento(nroDocumento);
        cliente.setNombreCompleto(nombreCompleto);
        cliente.setGenero(genero);

        if (usuarioDao.ExisteCorreo(correo, 0) == 0) {
            int result = clienteDao.registrar(cliente);

            if (result > 0) {
                request.getSession().setAttribute("success", "Cuenta registrada!");
                response.sendRedirect("auth?accion=new_account");
                return;
            } else {
                request.getSession().setAttribute("error", "No se pudo registrar cuenta");
            }
        } else {
            request.getSession().setAttribute("error", "El correo " + correo + " ya se encuentra registrado");
        }

        request.setAttribute("cliente", cliente);
        request.setAttribute("tipos_documentos", tipoDocDao.ListarTodos());
        request.setAttribute("paises", paisDao.ListarTodos());
        request.setAttribute("pais_peru", ConstantesApp.ID_PAIS_PERU);
        request.getRequestDispatcher("pagNuevaCuenta.jsp").forward(request, response);

    }

    protected void NuevaCuenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.setAttribute("tipos_documentos", tipoDocDao.ListarTodos());
        request.setAttribute("paises", paisDao.ListarTodos());
        request.setAttribute("pais_peru", ConstantesApp.ID_PAIS_PERU);
        request.getRequestDispatcher("pagNuevaCuenta.jsp").forward(request, response);

    }

    protected void Login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        UsuarioDTO obj = authDao.Login(correo, password);

        if (obj != null) {
            request.getSession().setAttribute("usuario", obj);
            if (obj.getIdRol() == ConstantesApp.ROL_CLIENTE) {
                request.getSession().setAttribute("esCliente", true);
                response.sendRedirect("index.jsp");
            } else {
                request.getSession().setAttribute("esCliente", false);
                response.sendRedirect("pagInicio.jsp");
            }
        } else {
            request.setAttribute("correo", correo);
            request.getSession().setAttribute("error", "Correo y/o contraseña incorrecto");
            request.getRequestDispatcher("pagLogin.jsp").forward(request, response);
        }
    }

    protected void Logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.getSession().setAttribute("usuario", null);
        request.getSession().setAttribute("esCliente", null);
        response.sendRedirect("pagLogin.jsp");

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
