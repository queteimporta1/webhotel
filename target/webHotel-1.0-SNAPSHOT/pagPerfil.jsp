<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Perfil</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />
        <div class="container-fluid mt-3">
            <div class="row">
                <div class="col-sm-4">
                    <div class="card">
                        <div class="card-body">
                            <h5>CUENTA DE USUARIO</h5>
                            <hr />
                            <div class="text-center mb-3">
                                <img src="assets/img/recursos/usuarios/${sessionScope.usuario.foto}" id="avatarPreview"
                                     onerror="this.onerror=null; this.src='assets/img/recursos/avatar_hombre.png';"
                                     alt="Avatar" class="rounded-circle" 
                                     style="width: 150px; height: 150px;">
                                <br>
                                <form action="perfil" id="uploadForm" method="post"
                                      enctype="multipart/form-data">
                                    <input type="file" class="form-control" id="customFile" name="foto" onchange="previewImage(event)" required=""/>
                                    <input type="hidden" name="accion" value="cambiar_foto">
                                    <button type="submit" class="btn btn-primary mt-2">
                                        <i class="fa fa-save"></i> Guardar Foto
                                    </button>
                                </form>
                            </div>


                            <c:if test="${cliente != null}">
                                <div class="user-info">
                                    <p><strong>Nombre:</strong> ${cliente.nombreCompleto}</p>
                                    <p><strong>Género:</strong> ${cliente.NombreGenero()}</p>
                                    <p><strong>Número ${cliente.tipoDocumento.nombre}:</strong> ${cliente.nroDocumento}</p>
                                    <p><strong>teléfono:</strong> ${cliente.nroCelular}</p>
                                    <p><strong>Pais:</strong> ${cliente.pais.nombre}</p>
                                </div>
                            </c:if>

                            <c:if test="${empleado != null}">
                                <div class="user-info">
                                    <p><strong>Nombre:</strong> ${empleado.nombreCompleto}</p>
                                    <p><strong>Género:</strong> ${empleado.NombreGenero()}</p>
                                    <p><strong>Número ${empleado.tipoDocumento.nombre}:</strong> ${cliente.nroDocumento}</p>
                                    <p><strong>teléfono:</strong> ${empleado.nroCelular}</p>
                                    <p><strong>Pais:</strong> ${empleado.pais.nombre}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="col-sm-8">
                    <div class="card">
                        <div class="card-body">
                            <h5>CAMBIAR CORREO</h5>
                            <hr />
                            <form>
                                <div class="row">
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label>Correo Actual:</label>
                                            <input type="email" class="form-control" 
                                                   name="correoActual" id="correoActual" >
                                        </div>
                                    </div>

                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label>Correo Nuevo:</label>
                                            <input type="email" class="form-control" 
                                                   name="correoNuevo" id="correoNuevo" >
                                        </div>
                                    </div>
                                    <div class="col-sm-4 mt-4">
                                        <div class="form-group">
                                            <button type="button" onclick="fnCambiarCorreo()" class="btn btn-primary btn-sm">
                                                <i class="fa fa-refresh"></i> Actualizar
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                            <br />
                            <h5>CAMBIAR CONTRASEÑA</h5>
                            <hr />
                            <form>
                                <div class="row">
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label>Contraseña Actual:</label>
                                            <input type="password" class="form-control" 
                                                   id="passwordActual" name="passwordActual" required="">
                                        </div>
                                    </div> 

                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label>Contraseña Nuevo:</label>
                                            <input type="password" class="form-control" 
                                                   id="passwordNuevo" name="passwordNuevo" required="">
                                        </div>
                                    </div>
                                    <div class="col-sm-4 mt-4">
                                        <div class="form-group">
                                            <button type="button" onclick="fnCambiarPassword()" class="btn btn-primary btn-sm">
                                                <i class="fa fa-refresh"></i> Actualizar
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>

                            <c:if test="${cliente != null}">
                                <br />
                                <span class="badge badge-success">OPERACIONES DE ACTIVIDADES</span>

                                <div class="table-responsive mt-2">
                                    <table class="table table-bordered table-striped">
                                        <thead class="table-dark">
                                            <tr >
                                                <th>CODIGO RESERVA</th>
                                                <th>NRO HABITACION</th>
                                                <th>ADULTOS</th>
                                                <th>NIÑOS</th>
                                                <th>RESERVACIONES ADICIONALES</th>
                                                <th>FECHA RESERVA</th>
                                                <th>DESCARGAR</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${reservas}" var="item" >
                                                <tr>
                                                    <td>${item.idReserva}</td>
                                                    <td>${item.detalleReserva.habitacion.nroHab}</td>
                                                    <td>${item.detalleReserva.cantAdultos}</td>
                                                    <td>${item.detalleReserva.cantNinios}</td>
                                                    <td>${item.detalleReserva.servicio == null ? "-":item.detalleReserva.servicio.nombre}</td>
                                                    <td>${item.fechaReserva} ${item.horaReserva}</td>
                                                    <td>
                                                        <a href="ReservaControlador?accion=exportarPDF&id=${item.idReserva}" 
                                                           class="btn btn-danger btn-sm" target="_blank" title="Descargar PDF">
                                                            <i class="fa fa-file-pdf"></i> 
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${reservas.size() == 0}">
                                                <tr>
                                                    <td colspan="7" class="text-center">No hay registros</td>
                                                </tr>
                                            </c:if>

                                        </tbody>
                                    </table>


                                </div>
                            </c:if>
                        </div>
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
        function fnCambiarPassword() {
            var passwordActual = document.getElementById("passwordActual").value;
            var passwordNuevo = document.getElementById("passwordNuevo").value;

            if (!passwordActual) {
                fnToastr("info", "Debe ingresar contraseña actual");
                return;
            }
            if (!passwordNuevo) {
                fnToastr("info", "Debe ingresar contraseña nueva a actualizar");
                return;
            }

            var _params = {
                "accion": "cambiar_password",
                "password_actual": passwordActual,
                "password_nuevo": passwordNuevo
            };

            axios
                    .get("perfil", {params: _params})
                    .then((response) => {
                        response = response.data;
                        if (response.msg === "OK") {
                            fnToastr("success", "Contraseña actualizado.");
                            document.getElementById("passwordActual").value = "";
                            document.getElementById("passwordNuevo").value = "";
                        } else {
                            fnToastr("error", response.msg);
                        }
                    })
                    .catch((error) => {
                        console.dir(error);
                        fnToastr("error", "No se pudo actualizar contraseña.");
                    });
        }

        function fnCambiarCorreo() {
            var correoActual = document.getElementById("correoActual").value;
            var correoNuevo = document.getElementById("correoNuevo").value;

            if (!correoActual) {
                fnToastr("info", "Debe ingresar correo actual");
                return;
            }
            if (!correoNuevo) {
                fnToastr("info", "Debe ingresar correo nuevo a actualizar");
                return;
            }

            var _params = {
                "accion": "cambiar_correo",
                "correo_actual": correoActual,
                "correo_nuevo": correoNuevo
            };

            axios
                    .get("perfil", {params: _params})
                    .then((response) => {
                        response = response.data;
                        if (response.msg === "OK") {
                            fnToastr("success", "Correo actualizado.");
                            document.getElementById("correoActual").value = "";
                            document.getElementById("correoNuevo").value = "";
                        } else {
                            fnToastr("error", response.msg);
                        }
                    })
                    .catch((error) => {
                        console.dir(error);
                        fnToastr("error", "No se pudo actualizar correo.");
                    });
        }

        function previewImage(event) {
            const avatarPreview = document.getElementById('avatarPreview');
            const file = event.target.files[0];
            const reader = new FileReader();
            reader.onload = function (e) {
                avatarPreview.src = e.target.result;
            }
            reader.readAsDataURL(file);
        }
    </script>
</html>
