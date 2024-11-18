<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Consulta Historial</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-4">
            <div class="card">
                <div class="card-body">
                    <h3 class="text-center mb-4">Consulta de Historial de Reservas</h3>
                    <hr />

                    <form method="get" action="ReservaControlador" class="mt-3">
                        <div class="row">
                            <div class="form-group col-md-2">
                                <label>Fecha Inicio:</label>
                                <input value="${inicio}" name="inicio" type="date" class="form-control" required="" >
                            </div>

                            <div class="form-group col-md-2">
                                <label>Fecha Fin:</label>
                                <input value="${fin}" name="fin"  type="date" class="form-control" required="" >
                            </div>

                            <div class="form-group col-md-4 mt-4">
                                <input type="hidden" name="accion" value="consulta">
                                <button  type="submit" class="btn btn-primary btn-sm">
                                    <i class="fa fa-search"></i> Consultar
                                </button>
                            </div>

                        </div>
                    </form>

                    <div class="row mb-3">
                        <div class="col-md-12">
                            <div class="table-responsive mt-2">
                                <table class="table table-bordered table-striped dtTabla">
                                    <thead class="table-dark">
                                        <tr >
                                            <th class="text-center"># RESERVA</th>
                                            <th class="text-center">RESERVANTE</th>
                                            <th class="text-center">NRO DOCUMENTO</th>
                                            <th class="text-center">FECHA RESERVA</th>
                                            <th class="text-center">HORA RESERVA</th>
                                            <th class="text-center">SEDE</th>
                                            <th class="text-center">TIPO HAB.</th>
                                            <th class="text-center">NRO HAB.</th>
                                            <th class="text-center">ACCIÓN</th>
                                        </tr>
                                    </thead>
                                    <tbody >
                                        <c:forEach items="${reservas}" var="item" >
                                            <tr>
                                                <td>${item.idReserva}</td>
                                                <td>${item.nombreReservante}</td>
                                                <td>${item.nroDocumento}</td>
                                                <td>${item.fechaReserva}</td>
                                                <td>${item.horaReserva}</td>
                                                <td>${item.detalleReserva.habitacion.sede.nombre}</td>
                                                <td>${item.detalleReserva.habitacion.tipoHab.nombreTipoHab}</td>
                                                <td>${item.detalleReserva.habitacion.nroHab}</td>
                                                <td>
                                                    <button onclick="fnCargarDetalle(${item.idReserva})" class="btn btn-success btn-sm">
                                                        <i class="fas fa-hotel"></i> Detalle
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalReserva" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="exampleModalLabel">::: Detalle Reserva :::</h5>
                        <button type="button" class="btn-close" data-dismiss="modal"></button>
                    </div>

                    <form action="ReservaControlador" method="post">
                        <div class="modal-body">
                            <h5><span class='badge rounded-pill badge-primary'> Datos Personales </span></h5>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label>Nombre Completo</label>
                                    <input type="text" id="nombreCompleto" name="nombreCompleto" class="form-control" required disabled="">
                                </div>
                                <div class="col-md-6">
                                    <label>Celular</label>
                                    <input type="text" id="celular" name="celular" class="form-control" required disabled="">
                                </div>
                            </div> 


                            <h5><span class='badge rounded-pill badge-primary'> Datos Reserva </span></h5>
                            <div class="row mb-3">
                                <div class="col-md-3">
                                    <label>Fecha Reserva</label>
                                    <input type="text" id="fechaReserva" name="fechaReserva" class="form-control" required disabled="">
                                </div> 
                                <div class="col-md-3">
                                    <label>Hora Reserva</label>
                                    <input type="text" id="horaReserva" name="horaReserva" class="form-control" required disabled="">
                                </div>

                                <div class="col-md-2">
                                    <label>Fecha Salida</label>
                                    <input type="text" id="fechaSalida" name="fechaSalida" class="form-control" required disabled="">
                                </div>
                                <div class="col-md-2">
                                    <label>Hora Salida</label>
                                    <input type="text" id="horaSalida" name="horaSalida" class="form-control" required disabled="">
                                </div>
                                <div class="col-md-2">
                                    <label>Pago Total</label>
                                    <input type="text" id="pagoTotal" name="pagoTotal" class="form-control" required disabled="">
                                </div>  
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <div class="table-responsive mt-2">
                                        <table class="table table-bordered table-striped">
                                            <thead class="table-dark">
                                                <tr >
                                                    <th>SEDE</th>
                                                    <th>TIPO HABITACIÓN</th>
                                                    <th>NRO HABITACION</th>
                                                    <th>ADULTOS</th>
                                                    <th>NIÑOS</th>
                                                </tr>
                                            </thead>
                                            <tbody id="resultadoReserva">
                                            </tbody>
                                        </table>


                                        <table class="table table-bordered table-striped">
                                            <thead class="table-dark">
                                                <tr >
                                                    <th>#</th>
                                                    <th>SERVICIO</th>
                                                </tr>
                                            </thead>
                                            <tbody id="resultadoServicio">
                                            </tbody>
                                        </table>

                                        <h5><span class='badge rounded-pill badge-primary'> Datos Adicional Habitación </span></h5>

                                        <ul> 
                                            <li><span id="lblDesDucha"></span> <i class="fa fa-shower"></i></li>
                                            <li><span id="lblDesCama"></span> <i class="fa fa-bed"></i></li>
                                            <li><span id="lblPersonas"></span> <i class="fa fa-users"></i></li>
                                            <li><span id="lblDesayuno"></span> <i class="fa fa-apple-alt"></i></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>
    <script>

        function fnCargarDetalle(idReserva) {

            var _params = {
                "accion": "buscar_por_Id_JSON",
                "id": idReserva
            };

            axios
                    .get("ReservaControlador", {params: _params})
                    .then((response) => {
                        console.log(response);
                        let item = response.data;

                        document.getElementById("nombreCompleto").value = item.nombreReservante;
                        document.getElementById("celular").value = item.nroCelular;
                        document.getElementById("fechaReserva").value = item.fechaReserva;
                        document.getElementById("fechaSalida").value = item.fechaSalida;
                        document.getElementById("horaSalida").value = item.horaSalida;


                        document.getElementById("horaReserva").value = item.horaReserva;
                        document.getElementById("pagoTotal").value = item.pagoTotal.toFixed(2);

                        document.getElementById("lblDesDucha").innerHTML = item.detalleReserva.habitacion.descripcionDucha;
                        document.getElementById("lblDesCama").innerHTML = item.detalleReserva.habitacion.descripcionCama;
                        document.getElementById("lblPersonas").innerHTML = item.detalleReserva.habitacion.descripcionPersonas;
                        document.getElementById("lblDesayuno").innerHTML = item.detalleReserva.habitacion.descripcionDesayuno;

                        let tablaResserva = "";
                        tablaResserva += "<tr>";
                        tablaResserva += "<td>" + item.detalleReserva.habitacion.sede.nombre + "</td>";
                        tablaResserva += "<td>" + item.detalleReserva.habitacion.tipoHab.nombreTipoHab + "</td>";
                        tablaResserva += "<td>" + item.detalleReserva.habitacion.nroHab + "</td>";
                        tablaResserva += "<td>" + item.detalleReserva.cantAdultos + "</td>";
                        tablaResserva += "<td>" + item.detalleReserva.cantNinios + "</td>";
                        tablaResserva += "</tr>";

                        let tablaServicio = "";
                        tablaServicio += "<tr>";
                        if (item.detalleReserva.servicio !== null) {
                            tablaServicio += "<td>1</td>";
                            tablaServicio += "<td>" + item.detalleReserva.servicio.nombre + "</td>";
                        } else {
                            tablaServicio += "<td class='text-center' colspan='2'>No hay servicios</td>";
                        }
                        tablaServicio += "</tr>";

                        document.getElementById("resultadoReserva").innerHTML = tablaResserva;
                        document.getElementById("resultadoServicio").innerHTML = tablaServicio;

                        $("#modalReserva").modal("show");
                    })
                    .catch((error) => {
                        console.dir(error);
                        fnToastr("error", "No se pudo cargar reserva.");
                    });

        }
    </script>
</html>
