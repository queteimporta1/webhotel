package app;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Date;
import java.util.Map;
import modelo.dao.ComentarioDAO;
import modelo.dao.SedeDAO;
import modelo.dao.UsuarioDAO;
import utils.Utileria;

@WebFilter("/*")
public class AppFilter implements Filter {

    private SedeDAO sedeDao = new SedeDAO();
    private UsuarioDAO usuarioDao = new UsuarioDAO();
    private ComentarioDAO comentarioDao = new ComentarioDAO();

    public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        cargarDatos(((HttpServletRequest) request).getSession().getServletContext());
        chain.doFilter(request, response);
    }

    public void destroy() {

    }

    private void cargarDatos(ServletContext servletContext) {
        servletContext.setAttribute("app_sedes", sedeDao.ListarTodos());
        servletContext.setAttribute("app_cant_inscritos", usuarioDao.CantInscritos());
        servletContext.setAttribute("app_fecha_actual", Utileria.StrFecha(new Date()));
        servletContext.setAttribute("app_comentarios", comentarioDao.ListarTodos());
        servletContext.setAttribute("app_porcCalificacion", comentarioDao.listarPorcentajeCalificaciones());
    }
}
