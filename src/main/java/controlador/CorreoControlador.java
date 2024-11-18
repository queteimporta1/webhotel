package controlador;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import utils.CorreoUtil;

public class CorreoControlador extends HttpServlet {

    private CorreoUtil objCorreo = new CorreoUtil();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        switch (accion) {
            case "enviar_contacto":
                contacto(request, response);
                break;
        }
    }

    protected void contacto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HashMap<String, Object> data = new HashMap<>();
        try {
            String correo = request.getParameter("correo");
            String nombre = request.getParameter("nombre");
            String mensaje = request.getParameter("mensaje");

            String asunto = "Información";
            String cuerpo = "<html>"
                    + "<head>"
                    + "<style>"
                    + "body { font-family: Arial, sans-serif; line-height: 1.6; }"
                    + "h1 { color: #2c3e50; }"
                    + "p { margin: 0; padding: 0.5em 0; }"
                    + ".footer { margin-top: 20px; font-size: 0.9em; color: #7f8c8d; }"
                    + "</style>"
                    + "</head>"
                    + "<body>"
                    + "<h1>Estimado/a " + nombre + ",</h1>"
                    + "<p>Gracias por tu mensaje. A continuación, hemos recibido tu consulta:</p>"
                    + "<blockquote style='background: #f9f9f9; border-left: 5px solid #2c3e50; padding: 10px;'>"
                    + "<p><strong>Tu mensaje:</strong><br>" + mensaje + "</p>"
                    + "</blockquote>"
                    + "<p>Uno de nuestros representantes se pondrá en contacto contigo a la brevedad.</p>"
                    + "<p>Si deseas más información sobre nuestras habitaciones, servicios o tarifas, no dudes en visitar nuestra página web o contactarnos directamente.</p>"
                    + "<p>Esperamos poder atenderte pronto y que disfrutes de una estancia placentera en nuestro hotel.</p>"
                    + "<p>Atentamente,</p>"
                    + "<p>El equipo de Hotel El Paraiso</p>"
                    + "</div>"
                    + "</body>"
                    + "</html>";
            String msg = objCorreo.EnviarCorreo(asunto, cuerpo, correo, true);
            data.put("msg", msg);
        } catch (Exception ex) {
            data.put("msg", ex.getMessage());
        }

        out.print(new Gson().toJson(data));
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
