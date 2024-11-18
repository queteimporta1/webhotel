package controlador;

import com.google.gson.Gson;
import dto.UsuarioDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modelo.Cliente;
import modelo.Empleado;
import modelo.dao.ClienteDAO;
import modelo.dao.EmpleadoDAO;
import modelo.dao.ReservaDAO;
import modelo.dao.UsuarioDAO;
import utils.ConstantesApp;
import utils.Utileria;

@MultipartConfig(maxFileSize = 104857600, maxRequestSize = 104857600)
public class PerfilControlador extends HttpServlet {

    private ReservaDAO reservaDao = new ReservaDAO();
    private UsuarioDAO usuarioDao = new UsuarioDAO();
    private EmpleadoDAO empDao = new EmpleadoDAO();
    private ClienteDAO cliDao = new ClienteDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "ver":
                verPerfil(request, response);
                break;
            case "cambiar_correo":
                cambiarCorreo(request, response);
                break;
            case "cambiar_password":
                cambiarPassword(request, response);
                break;
            case "cambiar_foto":
                cambiarFoto(request, response);
                break;
        }
    }

    protected void cambiarFoto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UsuarioDTO objLogeado = (UsuarioDTO) request.getSession().getAttribute("usuario");

            Part archivoPart = request.getPart("foto");
            if (archivoPart.getSize() != 0) {
                String ruta = Utileria.RutaAbsoluta(request, Utileria.RUTA_IMG_USUARIOS);
                String imagen = Utileria.guardarArchivo(ruta, archivoPart, Utileria.generateUniqueImageName(archivoPart.getSubmittedFileName()));

                if (!imagen.equals("")) {

                    int result = usuarioDao.ActualizarFoto(objLogeado.getIdUsuario(), imagen);
                    if (result > 0) {
                        objLogeado.setFoto(imagen);
                        GuardarSesionLogeado(objLogeado, request);
                        request.getSession().setAttribute("success", "Foto actualizada!");
                    } else {
                        request.getSession().setAttribute("error", "No se pudo actualizar foto!");
                    }
                } else {
                    request.getSession().setAttribute("info", "No se pudo actualizar foto!");
                }
            }
        } catch (Exception ex) {
            request.getSession().setAttribute("error", ex.getMessage());
            ex.printStackTrace();

        }

        response.sendRedirect("perfil?accion=ver");
    }

    protected void cambiarPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> resultado = new HashMap<>();
        PrintWriter out = response.getWriter();
        String msg = "";
        try {

            String passwordActual = request.getParameter("password_actual");
            String passwordNuevo = request.getParameter("password_nuevo");

            UsuarioDTO objLogeado = (UsuarioDTO) request.getSession().getAttribute("usuario");

            if (!objLogeado.getPassword().equalsIgnoreCase(passwordActual)) {
                msg = "La contraseña actual proporcionado es incorrecta.";
            } else {
                int result = usuarioDao.ActualizarPassword(objLogeado.getIdUsuario(), passwordNuevo);

                if (result > 0) {
                    msg = "OK";
                    objLogeado.setPassword(passwordNuevo);
                    GuardarSesionLogeado(objLogeado, request);
                } else {
                    msg = "No se pudo actualizar contraseña";
                }
            }
        } catch (Exception ex) {
            msg = ex.getMessage();
            ex.printStackTrace();
        }

        resultado.put("msg", msg);
        out.print(new Gson().toJson(resultado));
    }

    protected void cambiarCorreo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> resultado = new HashMap<>();
        PrintWriter out = response.getWriter();
        String msg = "";
        try {

            String correoActual = request.getParameter("correo_actual");
            String correoNuevo = request.getParameter("correo_nuevo");

            UsuarioDTO objLogeado = (UsuarioDTO) request.getSession().getAttribute("usuario");

            if (!objLogeado.getCorreo().equalsIgnoreCase(correoActual)) {
                msg = "El correo proporcionado actual no figura registrado.";
            } else {
                if (usuarioDao.ExisteCorreo(correoNuevo, objLogeado.getIdUsuario()) == 0) {
                    int result = usuarioDao.ActualizarCorreo(objLogeado.getIdUsuario(), correoNuevo);

                    if (result > 0) {
                        msg = "OK";
                        objLogeado.setCorreo(correoNuevo);
                        GuardarSesionLogeado(objLogeado, request);
                    } else {
                        msg = "No se pudo actualizar correo";
                    }
                } else {
                    msg = "El correo " + correoNuevo + " no se encuentra disponible,ya que se encuentra registrado";
                }
            }
        } catch (Exception ex) {
            msg = ex.getMessage();
            ex.printStackTrace();
        }

        resultado.put("msg", msg);
        out.print(new Gson().toJson(resultado));
    }

    protected void verPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        UsuarioDTO objLogeado = (UsuarioDTO) request.getSession().getAttribute("usuario");

        GuardarSesionLogeado(objLogeado, request);

        request.setAttribute("reservas", reservaDao.BuscarPorCliente(objLogeado.getId()));
        request.getRequestDispatcher("pagPerfil.jsp").forward(request, response);
    }

    public void GuardarSesionLogeado(UsuarioDTO objLogeado, HttpServletRequest request) {
        if (objLogeado.getIdRol() == ConstantesApp.ROL_CLIENTE) {
            Cliente obj = cliDao.BuscarPorIdUsuario(objLogeado.getIdUsuario());
            request.setAttribute("cliente", obj);
        } else {
            Empleado obj = empDao.BuscarPorIdUsuario(objLogeado.getIdUsuario());
            request.setAttribute("empleado", obj);
        }
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
