<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Servicios</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-4">
            <h4 class="text-center">Nuestros Servicios</h4>
            <hr /> 
            <p>En el Hotel "El Paraíso", te ofrecemos una experiencia única con nuestros servicios diseñados especialmente para brindarte comodidad y satisfacción. Entre ellos, destacan:</p>

            <c:forEach var="item" items="${servicios}" varStatus="status">
                <div class="row mb-4">
                    <c:if test="${status.index % 2 == 0}">
                        <div class="col-md-4">
                            <img src="assets/img/recursos/servicios/${item.imagen}" class="img-fluid rounded" alt="${item.nombre}">
                        </div>
                        <div class="col-md-8">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">${item.nombre}</h5>
                                    <hr />
                                    <p class="card-text" style="text-align: justify;">${item.descripcion}</p>
                                    <h6 class="card-subtitle mb-2 text-muted">Precio por persona: S/${item.costo}</h6>
                                    <a href="ReservaControlador?accion=inicio" class="btn btn-primary">Reservar</a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${status.index % 2 != 0}">
                        <div class="col-md-8">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">${item.nombre}</h5>
                                    <hr />
                                    <p class="card-text" style="text-align: justify;">${item.descripcion}</p>
                                    <h6 class="card-subtitle mb-2 text-muted">Precio por persona: S/${item.costo}</h6>
                                    <a href="ReservaControlador?accion=inicio" class="btn btn-primary">Reservar</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <img src="assets/img/recursos/servicios/${item.imagen}" class="img-fluid rounded" alt="${item.nombre}">
                        </div>
                    </c:if>


                </div>
            </c:forEach> 
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
