<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Habitaciones</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <style>
        .hero-section {
            background-size: cover;
            background-position: center;
            color: white;
            text-align: center;
        }

        .search-box {
            background: linear-gradient(90deg, #7d84f0 0%, #3d97e7 100%);
            padding: 30px;
            border-radius: 10px;
        }
    </style>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="hero-section mt-4">
            <div class="container">
                <div class="search-box">
                    <form action="HabitacionControlador" method="GET">
                        <div class="row">
                            <div class="col-md-4">
                                <label>Sede Hotel </label>
                                <select class="form-select" id="sede" name="sede" required="">
                                    <option value="">::: Seleccione :::</option>
                                    <c:forEach items="${sedes}" var="item">
                                        <option value="${item.idSede}"
                                                ${item.idSede == sede ? "selected": ""}
                                                >${item.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label>Fecha Entrada</label>
                                <input type="date" id="fecha" name="fecha"
                                       class="form-control" required value="${fecha}">
                            </div>
                            <div class="col-md-2">
                                <label>Hora Entrada</label>
                                <input type="time" id="hora" name="hora"
                                       class="form-control" required value="${hora}">
                            </div>
                            <div class="col-md-2">
                                <label>Tipo de Habitación</label>
                                <select id="id" name="id" class="form-control" required>
                                    <option value="">::: Seleccione :::</option>
                                    <c:forEach var="item" items="${tipohabitaciones}">
                                        <option value="${item.idTipoHab}"
                                                ${item.idTipoHab == id ? 'selected' : ''}
                                                >${item.nombreTipoHab}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-2 mt-2">
                                <input type="hidden" name="accion" value="consultar">
                                <button type="submit" class="btn btn-success btn-lg">
                                    ​ <i class="fa fa-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="container mt-3">
            <c:forEach var="item" items="${habitaciones}" varStatus="status">
                <div class="row mb-3">
                    <div class="card h-100">
                        <div class="card-body d-flex">
                            <div class="col-md-5">
                                <h5 class="card-title"><span class='badge rounded-pill badge-primary'>${item.tipoHab.nombreTipoHab} - #${item.nroHab}</span></h5>
                                <ul>
                                    <li>${item.descripcionDucha} <i class="fa fa-shower"></i></li>
                                    <li>${item.descripcionCama} <i class="fa fa-bed"></i></li>
                                    <li>${item.descripcionPersonas} <i class="fa fa-users"></i></li>
                                    <li>${item.descripcionDesayuno} <i class="fa fa-apple-alt"></i></li>
                                </ul>

                            </div>

                            <div class="col-md-4">
                                <img src="assets/img/recursos/habitacion/${item.imagen}" 
                                     class="img-fluid rounded" style="width: 100%; height: 200px;">
                            </div>
                            <div class="col-md-3 text-center">
                                <a href="ReservaControlador?accion=inicio" class="btn btn-primary mt-5">Reservar</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>
    <script>
        var today = new Date().toISOString().split('T')[0];
        document.getElementById("fecha").setAttribute("min", today);
        document.getElementById('fecha').addEventListener('keydown', function (event) {
            event.preventDefault();
        });
    </script>
</html>
