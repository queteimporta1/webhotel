<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Registro Entrada</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-4">
            <div class="card">
                <div class="card-body">

                    <h3 class="text-center mb-4">Registrar Entrada</h3>
                    <hr />

                    <form action="ReservaControlador" method="GET">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="nroDocumento">Nro Documento</label>
                                <div class="input-group">
                                    <input type="text" id="nroDocumento" name="nroDocumento" class="form-control" >
                                    <button onclick="fnConsultarReserva()" type="button" class="btn btn-primary"><i class="fa fa-search"></i> Consultar</button>
                                </div>
                            </div>
                        </div>

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

                            <div class="col-md-3">
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
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-12 text-center">
                                <input type="hidden" name="accion" id="accion" value="registrar_entrada">
                                <input type="hidden" name="idReserva" id="idReserva" value="">
                                <button type="submit" class="btn btn-success btn-lg" id="btnRegistrarEntrada" disabled="">
                                    <i class="fa fa-save"></i> Registrar Entrada
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <div class="modal fade" id="modalSelReserva" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="exampleModalLabel">::: Seleccione reserva :::</h5>
                        <button type="button" class="btn-close" data-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <div class="table-responsive mt-2">
                                    <table class="table table-bordered table-striped">
                                        <thead class="table-dark">
                                            <tr >
                                                <th class="text-center" style="width: 5px;">SELECCIONAR</th>
                                                <th class="text-center"># RESERVA</th>
                                                <th class="text-center">RESERVANTE</th>
                                                <th class="text-center">NRO DOCUMENTO</th>
                                                <th class="text-center">FECHA RESERVA</th>
                                                <th class="text-center">HORA RESERVA</th>
                                                <th class="text-center">SEDE</th>
                                                <th class="text-center">TIPO HAB.</th>
                                                <th class="text-center">NRO HAB.</th>
                                            </tr>
                                        </thead>
                                        <tbody id="resultadoSelReserva">

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>


        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />


        <script>
            let listReservas = [];
            function fnConsultarReserva() {
                document.getElementById("btnRegistrarEntrada").disabled = true;
                let nro = document.getElementById("nroDocumento").value;

                if (!nro) {
                    fnToastr("info", "Ingrese un numero de documento.");
                    return;
                }

                var _params = {
                    "accion": "buscar_pendientes_por_nrodoc",
                    "nro": nro
                };

                axios
                        .get("ReservaControlador", {params: _params})
                        .then((response) => {
                            listReservas = response.data;

                            if (listReservas.length > 0) {
                                if (listReservas.length === 1) {
                                    fnCargarDetalle(0);
                                } else {
                                    let tablaResserva = "";
                                    listReservas.forEach((item, index) => {
                                        tablaResserva += "<tr>";
                                        tablaResserva += "<td style='width: 5px;'>";
                                        tablaResserva += "<a href='javascript:fnCargarDetalle(" + index + ")' class='btn btn-success btn-sm' title='Seleccionar'>";
                                        tablaResserva += "<i class='fa fa-check-circle'></i>";
                                        tablaResserva += "</a>";
                                        tablaResserva += "</td>";

                                        tablaResserva += "<td>" + item.idReserva + "</td>";
                                        tablaResserva += "<td>" + item.nombreReservante + "</td>";
                                        tablaResserva += "<td>" + item.nroDocumento + "</td>";
                                        tablaResserva += "<td>" + item.fechaReserva + "</td>";
                                        tablaResserva += "<td>" + item.horaReserva + "</td>";

                                        tablaResserva += "<td>" + item.detalleReserva.habitacion.sede.nombre + "</td>";
                                        tablaResserva += "<td>" + item.detalleReserva.habitacion.tipoHab.nombreTipoHab + "</td>";
                                        tablaResserva += "<td>" + item.detalleReserva.habitacion.nroHab + "</td>";
                                        tablaResserva += "</tr>";
                                    });

                                    document.getElementById("resultadoSelReserva").innerHTML = tablaResserva;

                                    $("#modalSelReserva").modal("show");
                                }
                            } else {
                                fnToastr("info", "No se encontraron reservas pendientes");
                                fnResetearCampos();
                            }
                        })
                        .catch((error) => {
                            console.dir(error);
                            fnToastr("error", "No se pudo cargar reservas.");
                        });
            }

            function fnCargarDetalle(indice) {
                let item = listReservas[indice];
                document.getElementById("nombreCompleto").value = item.nombreReservante;
                document.getElementById("celular").value = item.nroCelular;
                document.getElementById("idReserva").value = item.idReserva;
                document.getElementById("fechaReserva").value = item.fechaReserva;
                document.getElementById("horaReserva").value = item.horaReserva;
                document.getElementById("pagoTotal").value = item.pagoTotal.toFixed(2);

                let tablaResserva = "";
                tablaResserva += "<tr>";
                tablaResserva += "<td>" + item.detalleReserva.habitacion.sede.nombre + "</td>";
                tablaResserva += "<td>" + item.detalleReserva.habitacion.tipoHab.nombreTipoHab + "</td>";
                tablaResserva += "<td>" + item.detalleReserva.habitacion.nroHab + "</td>";
                tablaResserva += "<td>" + item.detalleReserva.cantAdultos + "</td>";
                tablaResserva += "<td>" + item.detalleReserva.cantNinios + "</td>";
                tablaResserva += "</tr>";
                document.getElementById("resultadoReserva").innerHTML = tablaResserva;

                $("#modalSelReserva").modal("hide");
                document.getElementById("btnRegistrarEntrada").disabled = false;
            }

            function fnResetearCampos() {
                document.getElementById("nombreCompleto").value = "";
                document.getElementById("celular").value = "";
                document.getElementById("idReserva").value = "";
                document.getElementById("fechaReserva").value = "";
                document.getElementById("horaReserva").value = "";
                document.getElementById("pagoTotal").value = "";
                document.getElementById("resultadoReserva").innerHTML = "";
            }
        </script>
    </body>
</html>
