<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Gest. Sedes</title>
        <jsp:include page="includes/css.jsp" />
    </head> 
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-3">
            <div class="card">
                <div class="card-body">
                    <h5>Gest. Sedes</h5>
                    <hr />
                    <a href="#" class="btn btn-success btn-sm">
                        <i class="fa fa-plus-circle" ></i> Nuevo
                    </a>

                    <table class="table table-bordered table-striped mt-2">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Departamento</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${sedes}" var="item" >
                            <tr>
                                <td>${item.idSede}</td>
                                <td>${item.nombre}</td>
                                <td>${item.departamento}</td>
                                <td>
                                    <a href="#" 
                                       class="btn btn-info btn-sm" title="Editar">
                                        <i class="fa fa-edit"></i>
                                    </a>
                                    <a href="#" 
                                       class="btn btn-danger btn-sm" title="Eliminar">
                                        <i class="fa fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${sedes.size() == 0}">
                            <tr class="text-center">
                                <td colspan="4">No hay registros</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
