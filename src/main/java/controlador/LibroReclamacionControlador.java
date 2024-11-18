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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modelo.ArchivoAdjunto;
import modelo.ArchivoLibro;
import modelo.Cliente;
import modelo.LibroReclamacion;
import modelo.Sede;
import modelo.dao.LibroReclamacionDAO;
import utils.ConstantesApp;
import utils.Utileria;

@MultipartConfig(maxFileSize = 104857600, maxRequestSize = 104857600)
public class LibroReclamacionControlador extends HttpServlet {

    private LibroReclamacionDAO libroDao = new LibroReclamacionDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "enviar_reclamacion":
                enviarReclamacion(request, response);
                break;
        }
    }

    protected void enviarReclamacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        Map<String, Object> resultado = new HashMap<>();
        UsuarioDTO objLogeado = (UsuarioDTO) request.getSession().getAttribute("usuario");

        if (objLogeado != null) {
            if (objLogeado.getIdRol() == ConstantesApp.ROL_CLIENTE) {
                int idSede = Integer.parseInt(request.getParameter("sede"));
                String celular = request.getParameter("celular");
                String nroDocumento = request.getParameter("nroDocumento");
                String correo = request.getParameter("correo");
                String mensaje = request.getParameter("mensaje");
                int idCliente = 1;

                LibroReclamacion objLibro = new LibroReclamacion();
                objLibro.setSede(new Sede(idSede));
                objLibro.setCliente(new Cliente(idCliente));
                objLibro.setMensaje(mensaje);
                objLibro.setCorreo(correo);
                objLibro.setNroCelular(celular);
                objLibro.setNroDocumento(nroDocumento);

                List<ArchivoLibro> listaArchivos = new ArrayList<>();
                for (Part part : request.getParts()) {
                    String fileName = part.getSubmittedFileName();

                    if (fileName != null && !fileName.isEmpty()) {

                        String uniqueFileName = Utileria.generateUniqueImageName(fileName);
                        String ruta = Utileria.RutaAbsoluta(request, Utileria.RUTA_ARCHIVOS_RECLAMACION) + "\\";

                        String nombreArchivo = Utileria.guardarArchivo(ruta, part, uniqueFileName);
                        if (nombreArchivo.isEmpty()) {
                            resultado.put("msg", "Error al guardar el archivo: " + fileName);
                            out.print(new Gson().toJson(resultado));
                            out.flush();
                            return;
                        }

                        ArchivoAdjunto archivoAdjunto = new ArchivoAdjunto();
                        archivoAdjunto.setNombreArchivo(uniqueFileName);
                        archivoAdjunto.setNombreOriginal(fileName);
                        archivoAdjunto.setTipoArchivo(part.getContentType());

                        ArchivoLibro archivoLibro = new ArchivoLibro();
                        archivoLibro.setArchivo(archivoAdjunto);
                        listaArchivos.add(archivoLibro);
                    }
                }

                objLibro.setArchivos(listaArchivos);
                int result = libroDao.registrar(objLibro);
                resultado.put("msg", result > 0 ? "OK" : "No se pudo registrar libro de reclamación");

            } else {
                resultado.put("msg", "Lo sentimos! El reclamo solo son unicamente para los clientes.");
            }
        } else {
            resultado.put("msg", "Debe iniciar sesión para poder realizar un reclamo.");
        }

        out.print(new Gson().toJson(resultado));
        out.flush();
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
