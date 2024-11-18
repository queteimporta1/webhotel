<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Gest. Habitación</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-3">
            <div class="card">
                <div class="card-body">
                    <h5>Gest. Habitaciones</h5>
                    <hr />
                    <a href="HabitacionControlador?accion=nuevo" class="btn btn-success btn-sm">
                        <i class="fa fa-plus-circle" ></i> Nuevo
                    </a>

                    <div class="table-responsive mt-3">
                        <table class="table table-bordered table-striped dtTabla">
                            <thead>
                                <tr>
                                    <th class="text-white">Imagen</th>
                                    <th>ID</th>
                                    <th>Sede</th>
                                    <th>Tipo Habitación</th>
                                    <th># Habitación</th>
                                    <th>Costo</th>
                                    <th>Descripión</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${habitaciones}" var="item" >
                                    <tr>
                                        <td>
                                            <img src="assets/img/recursos/habitacion/${item.imagen}" 
                                                 onerror="src='assets/img/recursos/img_not_found.jpg'"
                                                 style="width: 90px; height: 90px;"/>
                                        </td>
                                        <td>${item.idHab}</td>
                                        <td>${item.sede.nombre}</td>
                                        <td>${item.tipoHab.nombreTipoHab}</td>
                                        <td>${item.nroHab}</td>
                                        <td>${item.tipoHab.costo}</td>
                                        <td>
                                            <ul>
                                                <li>${item.descripcionDucha} <i class="fa fa-shower"></i></li>
                                                <li>${item.descripcionCama} <i class="fa fa-bed"></i></li>
                                                <li>${item.descripcionPersonas} <i class="fa fa-users"></i></li>
                                                <li>${item.descripcionDesayuno} <i class="fa fa-apple-alt"></i></li>
                                            </ul>
                                        </td>
                                        <td>
                                            <a href="HabitacionControlador?accion=editar&id=${item.idHab}"
                                               class="btn btn-info btn-sm" title="Editar">
                                                <i class="fa fa-edit"></i>
                                            </a>
                                            <a href="javascript:void(0)" onclick="confirmEliminar(${item.idHab})"
                                               class="btn btn-danger btn-sm" title="Eliminar">
                                                <i class="fa fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>

    <script>
        function confirmEliminar(id) {
            Swal.fire({
                title: 'Confirmación Eliminación',
                text: '¿Desea eliminar la habitación con id ' + id + '?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#dc3545',
                confirmButtonText: 'Sí, eliminarlo!',
                cancelButtonText: 'Cancelar',
                background: '#f8f9fa'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'HabitacionControlador?accion=eliminar&id=' + id;
                }
            });
        }
    </script>
</html>
