<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Formulario de Reserva</title>
        <jsp:include page="includes/css.jsp" />
        <style>
            .panel {
                display: none;
            }
            .panel.active {
                display: block;
            }
            .step-indicator {
                margin-bottom: 20px;
            }
            .step {
                display: inline-block;
                padding: 10px 20px;
                background-color: lightgray;
                border-radius: 5px;
                margin-right: 10px;
            }
            .step.active {
                background-color: #eb694c;
                color: white;
            }
        </style>
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />
        <div class="container mt-3">
            <!-- Step Indicator -->
            <div class="step-indicator">
                <div class="step" id="step-1">Registro</div>
                <div class="step" id="step-2">Método de Pago</div>
                <div class="step" id="step-3">Finalizar</div>
            </div>

            <!-- Panel 1: Registro -->
            <div class="panel active" id="panel-1">
                <div class="card">
                    <div class="card-header">
                        Registro
                    </div>
                    <div class="card-body">
                        <form>
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="mb-3">
                                        <label for="nombre" class="form-label">Nombre Completo:</label>
                                        <input type="text" class="form-control" id="nombre" name="nombre" value="${cliente.nombreCompleto}" readonly="">
                                    </div>
                                </div> 
                                <div class="col-sm-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Correo Electrónico: <span style="color: red;">(*)</span></label>
                                        <input type="email" class="form-control" id="correo" name="correo" value="${cliente.usuario.correo}" required="">
                                    </div>
                                </div> 
                            </div>

                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="mb-3">
                                        <label for="tipoDocumento" class="form-label">Tipo de Documento:</label>
                                        <select class="form-select" id="tipoDocumento" name="tipoDocumento" disabled="">
                                            <option value="">::: Seleccione :::</option>
                                            <c:forEach items="${tipoDocumentos}" var="item">
                                                <option value="${item.idTipoDoc}"
                                                        ${cliente.tipoDocumento.idTipoDoc == item.idTipoDoc ? 'selected' : ''}
                                                        >${item.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                </div>
                                <div class="col-sm-3">
                                    <div class="mb-3">
                                        <label for="numeroDocumento" class="form-label">Número de Documento:</label>
                                        <input type="text" class="form-control" id="numeroDocumento" name="numeroDocumento"
                                               value="${cliente.nroDocumento}"   disabled="">
                                    </div>
                                </div>
                                <div class="col-sm-3">
                                    <div class="mb-3">
                                        <label for="celular" class="form-label">Número Celular</label>
                                        <input type="text" class="form-control" id="celular" name="celular"
                                               value="${cliente.nroCelular}" >
                                    </div>
                                </div>
                            </div>


                            <div class="mb-4">
                                <div class="accordion" id="accordionExample">
                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="headingOne">
                                            <button
                                                data-mdb-collapse-init
                                                class="accordion-button"
                                                type="button"
                                                data-mdb-target="#collapse1"
                                                aria-expanded="true"
                                                aria-controls="collapse1"
                                                >
                                                Reserva Habitación #1
                                            </button>
                                        </h2>
                                        <div id="collapse1" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-mdb-parent="#accordionExample">
                                            <div class="accordion-body">
                                                <div class="row">
                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Sede Hotel: <span style="color: red;">(*)</span></label>
                                                            <select class="form-select" id="sede" name="sede">
                                                                <option value="">::: Seleccione :::</option>
                                                                <c:forEach items="${sedes}" var="item">
                                                                    <option value="${item.idSede}"
                                                                            ${sessionScope.idSede == item.idSede ? "selected": ""}
                                                                            >${item.nombre}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Fecha Entrada: <span style="color: red;">(*)</span></label>
                                                            <input type="date" id="fecha" name="fecha"
                                                                   class="form-control" required value="${sessionScope.fecha}">
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Hora Entrada: <span style="color: red;">(*)</span></label>
                                                            <input type="time" id="hora" name="hora"
                                                                   class="form-control" required value="${sessionScope.hora}">
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Tipo de Habitación: <span style="color: red;">(*)</span></label>
                                                            <select id="tipoHabitacion" name="tipoHabitacion" class="form-control" required>
                                                                <option value="">::: Seleccione :::</option>
                                                                <c:forEach var="item" items="${tipohabitaciones}">
                                                                    <option value="${item.idTipoHab}"
                                                                            ${item.idTipoHab == sessionScope.idTipoHab ? 'selected' : ''}
                                                                            >${item.nombreTipoHab}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <button type="button" class="btn btn-success btn-sm"
                                                                id="btnConsultar" onclick="consultarHabitacion()">
                                                            <i class="fa fa-search" aria-hidden="true"></i> Consultar
                                                        </button>

                                                        <button type="button" class="btn btn-danger btn-sm"id="btnNuevo" 
                                                                onclick="nuevaBusquedaHabitacion()">
                                                            <i class="fa fa-refresh" aria-hidden="true"></i> Nuevo
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Servicios: <span style="font-style: italic;">(Opcional)</span></label>
                                                            <select class="form-select" id="servicios" name="servicios">
                                                                <option value="">::: Seleccione :::</option>

                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Número de Habitación: <span style="color: red;">(*)</span></label>
                                                            <select class="form-select" id="habitacion" name="habitacion">
                                                                <option value="">::: Seleccione :::</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Cantidad Adultos: <span style="color: red;">(*)</span></label>
                                                            <select class="form-select" id="cantAdultos" name="cantAdultos">
                                                                <option value="">::: Seleccione :::</option>
                                                                <option value="1">1</option>
                                                                <option value="2">2</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="col-sm-3">
                                                        <div class="mb-3">
                                                            <label>Cantidad Niños: </label>
                                                            <select class="form-select" id="cantNiños" name="cantNiños">
                                                                <option value="">::: Seleccione :::</option>
                                                                <option value="1">1</option>
                                                                <option value="2">2</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>        


                            <button type="button" class="btn btn-primary" onclick="irPaso2()">
                                <i class="fa fa-arrow-right"></i> Siguiente
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Panel 2: Método de Pago -->
            <div class="panel" id="panel-2">
                <div class="card">
                    <div class="card-header">
                        Método de Pago
                    </div>
                    <div class="card-body">
                        <form>
                            <div class="mb-3">
                                <label for="numeroCuenta" class="form-label">Número de Cuenta:  <span style="color: red;">(*)</span></label>
                                <input type="text" class="form-control" id="numeroCuenta" name="numeroCuenta" 
                                       required maxlength="20" onkeypress="return soloNumeros(event)">
                            </div>

                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="mb-3">
                                        <label for="fechaExpiracion" class="form-label">Fecha de Expiración (mm/yy):  <span style="color: red;">(*)</span></label>
                                        <input type="text" class="form-control" id="fechaExperiacion" name="fechaExpiracion" 
                                               required maxlength="5">
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="mb-3">
                                        <label for="cvv" class="form-label">CVV:  <span style="color: red;">(*)</span></label>
                                        <input type="text" class="form-control" id="cvv" name="cvv" 
                                               required  maxlength="3" onkeypress="return soloNumeros(event)">
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="montoTotal" class="form-label">Monto Total: <span id="montoTotal" style="font-size: 18px; font-weight: bold;"></span></label>
                            </div>
                            <button type="button" class="btn btn-primary" onclick="nextPanel(1)">
                                <i class="fa fa-arrow-left"></i> Anterior
                            </button>
                            <button type="button" class="btn btn-primary" onclick="irPaso3()">
                                <i class="fa fa-arrow-right"></i> Siguiente
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Panel 3: Finalizar -->
            <div class="panel" id="panel-3">
                <div class="card">
                    <div class="card-header">
                        Finalizar
                    </div>
                    <div class="card-body text-center">
                        <p>Gracias por su reserva.</p>
                        <a href="" id="descargarBoleta"
                           target="_blank"
                           class="btn btn-success">Descargar Boleta</a>

                        <br><br>
                        <button type="button" class="btn btn-secondary" onclick="irPaso1()">Volver a Realizar Reserva</button>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var today = new Date().toISOString().split('T')[0];
                document.getElementById("fecha").setAttribute("min", today);
                document.getElementById('fecha').addEventListener('keydown', function (event) {
                    event.preventDefault();
                });

                toggleFields(true);
                document.getElementById('btnConsultar').disabled = false;
                document.getElementById('btnNuevo').disabled = true;

                consultarServicios();
            });

            function nextPanel(panelNumber) {
                document.querySelectorAll('.panel').forEach(panel => {
                    panel.classList.remove('active');
                });

                // Resaltar los pasos
                document.querySelectorAll('.step').forEach(step => {
                    step.classList.remove('active');
                });

                // Mostrar el panel seleccionado
                document.getElementById('panel-' + panelNumber).classList.add('active');
                document.getElementById('step-' + panelNumber).classList.add('active');
            }

            function toggleFields(disable) {
                document.getElementById('servicios').disabled = disable;
                document.getElementById('habitacion').disabled = disable;
                document.getElementById('cantAdultos').disabled = disable;
                document.getElementById('cantNiños').disabled = disable;

                document.getElementById('sede').disabled = !disable;
                document.getElementById('fecha').disabled = !disable;
                document.getElementById('hora').disabled = !disable;
                document.getElementById('tipoHabitacion').disabled = !disable;

                document.getElementById('btnNuevo').disabled = disable;
                document.getElementById('btnConsultar').disabled = !disable;
            }

            const correo = document.getElementById("correo");
            const sede = document.getElementById("sede");
            const fecha = document.getElementById("fecha");
            const hora = document.getElementById("hora");
            const servicio = document.getElementById("servicios");
            const tipoHabitacion = document.getElementById("tipoHabitacion");
            const habitacion = document.getElementById("habitacion");
            const cantAdultos = document.getElementById("cantAdultos");
            const cantNiños = document.getElementById("cantNiños");
            const numeroCuenta = document.getElementById("numeroCuenta");
            const cvv = document.getElementById("cvv");
            const fechaExperiacion = document.getElementById("fechaExperiacion");
            const montoTotal = document.getElementById("montoTotal");
            const numeroDocumento = document.getElementById("numeroDocumento");
            const celular = document.getElementById("celular");

            let listHabitaciones = [];
            let listServicios = [];
            let pagoBruto = 0;
            let pagoAdicion = 0;

            function consultarHabitacion() {

                if (sede.value === "") {
                    fnToastr("info", "Debe seleccionar una sede.");
                    return;
                }

                if (fecha.value === "") {
                    fnToastr("info", "Debe seleccionar una fecha a reservar.");
                    return;
                }

                if (hora.value === "") {
                    fnToastr("info", "Debe seleccionar una hora a reservar.");
                    return;
                }

                if (tipoHabitacion.value === "") {
                    fnToastr("info", "Debe seleccionar un tipo de habitación.");
                    return;
                }

                var _params = {
                    "accion": "consultar_disponibilidad",
                    "fecha": fecha.value,
                    "hora": hora.value,
                    "idSede": sede.value,
                    "idTipoHab": tipoHabitacion.value
                };

                listHabitaciones = [];
                habitacion.innerHTML = '<option value="">::: Seleccione :::</option>';

                axios
                        .get("HabitacionControlador", {params: _params})
                        .then((response) => {
                            listHabitaciones = response.data;
                            response = response.data;
                            if (response.length > 0) {
                                response.forEach(item => {
                                    const option = document.createElement("option");
                                    option.value = item.idHab;
                                    option.text = item.nroHab;
                                    habitacion.appendChild(option);
                                });
                                toggleFields(false);
                            } else {
                                fnToastr("info", "Lo sentimos! No se encontraron habitaciones disponibles con el criterio de búsqueda.");
                            }
                        })
                        .catch((error) => {
                            console.dir(error);
                            fnToastr("error", "No se pudo obtener consultar respuesta.");
                        });
            }

            function consultarServicios() {
                var _params = {
                    "accion": "listar_servicios"
                };

                listServicios = [];
                servicio.innerHTML = '<option value="">::: Seleccione :::</option>';

                axios
                        .get("ServicioControlador", {params: _params})
                        .then((response) => {
                            listServicios = response.data;
                            response = response.data;
                            if (response.length > 0) {
                                response.forEach(item => {
                                    const option = document.createElement("option");
                                    option.value = item.idServicio;
                                    option.text = item.nombre;
                                    servicio.appendChild(option);
                                });

                            }
                        })
                        .catch((error) => {
                            console.dir(error);
                            fnToastr("error", "No se pudo obtener servicios.");
                        });
            }

            function irPaso2() {
                if (habitacion.value === "" || habitacion.value === null) {
                    fnToastr("info", "Debe seleccionar antes una habitación a reservar.");
                    return;
                }

                if (cantAdultos.value === "" || cantAdultos.value === null) {
                    fnToastr("info", "Debe seleccionar cantidad de adultos a hospedar.");
                    return;
                }

                let indiceHab = fnGetSelectedIndex("habitacion");
                let indiceServicio = fnGetSelectedIndex("servicios");

                pagoBruto = listHabitaciones[indiceHab - 1].tipoHab.costo;
                pagoAdicion = indiceServicio > 0 ? listServicios[indiceServicio - 1].costo : 0;

                montoTotal.innerHTML = "" + (pagoBruto + pagoAdicion).toFixed(2);
                nextPanel(2);
            }

            function irPaso3() {
                if (numeroCuenta.value === "") {
                    fnToastr("info", "Debe ingresar un número de cuenta.");
                    return;
                } else if (numeroCuenta.value.length < 12) {
                    fnToastr("info", "El número de cuenta debe tener contener entre 12 a 20 digitos.");
                    return;
                }

                if (fechaExperiacion.value === "") {
                    fnToastr("info", "Debe ingresar fecha de expiración.");
                    return;
                } else {
                    if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(fechaExperiacion.value)) {
                        fnToastr("info", "La fecha debe tener el formato MM/YY.");
                        return;
                    }
                }

                if (cvv.value === "") {
                    fnToastr("info", "Debe ingresar un CVV.");
                    return;
                } else if (!/^\d{3}$/.test(cvv.value)) {
                    fnToastr("info", "El CVV debe tener exactamente 3 dígitos.");
                    return;
                }

                var _params = {
                    "accion": "registrar",
                    "idHabitacion": habitacion.value,
                    "idServicio": servicio.value === "" ? 0 : servicio.value,
                    "idSede": sede.value,
                    "correo": correo.value,
                    "nroDocumento": numeroDocumento.value,
                    "nroCelular": celular.value,
                    "fechaReserva": fecha.value,
                    "horaReserva": hora.value,
                    "pagoBruto": pagoBruto,
                    "pagoAdicion": pagoAdicion,
                    "cantAdultos": cantAdultos.value,
                    "cantNinios": cantNiños.value === "" ? 0 : cantNiños.value
                };

                axios
                        .get("ReservaControlador", {params: _params})
                        .then((response) => {

                            response = response.data;

                            if (response.msg === "OK") {
                                fnToastr("success", "Tu reserva se realizó de forma correcta.");
                                nextPanel(3);
                                var idReserva = response.result;
                                document.getElementById("descargarBoleta").href = "ReservaControlador?accion=exportarPDF&id=" + idReserva;

                            } else {
                                fnToastr("error", "Lo sentimos! No se ha podido generar su reserva.");
                                console.log(response.result);
                            }
                        })
                        .catch((error) => {
                            console.dir(error);
                            fnToastr("error", "No se pudo generar reserva.");
                        });

            }

            function irPaso1() {
                sede.value = "";
                fecha.value = "";
                hora.value = "";
                servicio.value = "";
                tipoHabitacion.value = "";
                habitacion.value = "";
                cantAdultos.value = "";
                cantNiños.value = "";
                numeroCuenta.value = "";
                cvv.value = "";
                fechaExperiacion.value = "";
                nextPanel(1);
                toggleFields(true);
                document.getElementById('btnConsultar').disabled = false;
                document.getElementById('btnNuevo').disabled = true;
            }

            function nuevaBusquedaHabitacion() {
                toggleFields(true);
            }

        </script>
    </body>
</html>
