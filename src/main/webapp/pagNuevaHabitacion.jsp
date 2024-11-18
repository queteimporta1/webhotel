<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Formulario Habitación</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-3">
            <div class="card">
                <div class="card-body">
                    <h3>${habitacion.idHab == 0 ? "Nuevo": "Editar"} Habitacion</h3>
                    <hr />
                    <form action="HabitacionControlador" method="post" enctype="multipart/form-data" method="post">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="mb-3">
                                    <label>Sede: <span style="color: red;">(*)</span></label>
                                    <select class="form-control" name="idSede" required>
                                        <option value="">::: Seleccione :::</option>
                                        <c:forEach var="item" items="${sedes}">
                                            <option value="${item.idSede}" 
                                                    ${item.idSede == habitacion.sede.idSede ? 'selected' : ''}>
                                                ${item.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="mb-3">
                                    <label>Tipo Habitación: <span style="color: red;">(*)</span></label>
                                    <select class="form-control" name="idTipoHab" required>
                                        <option value="">::: Seleccione :::</option>
                                        <c:forEach var="item" items="${tipoHabitaciones}">
                                            <option value="${item.idTipoHab}" 
                                                    ${item.idTipoHab == habitacion.tipoHab.idTipoHab ? 'selected' : ''}>
                                                ${item.nombreTipoHab} 
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="col-sm-3">
                                <label>Nro Habitación: <span style="color: red;">(*)</span></label>
                                <input value="${habitacion.nroHab}" name="nroHab" type="text" maxlength="10" 
                                       class="form-control" required="">
                            </div>
                        </div> 

                        <div class="row">
                            <div class="col-sm-6">
                                <label>Descripción Ducha: <span style="color: red;">(*)</span></label>
                                <input value="${habitacion.descripcionDucha}" name="descripcionDucha" type="text" maxlength="100" 
                                       class="form-control" required="">
                            </div>
                            <div class="col-sm-6">
                                <label>Descripción Cama: <span style="color: red;">(*)</span></label>
                                <input value="${habitacion.descripcionCama}" name="descripcionCama" type="text" maxlength="100" 
                                       class="form-control" required="">
                            </div>
                        </div> 


                        <div class="row">
                            <div class="col-sm-6">
                                <label>Descripción Personas: <span style="color: red;">(*)</span></label>
                                <input value="${habitacion.descripcionPersonas}" name="descripcionPersonas" type="text" maxlength="100" 
                                       class="form-control" required="">
                            </div>
                            <div class="col-sm-6">
                                <label>Descripción Desayuno: <span style="color: red;">(*)</span></label>
                                <input value="${habitacion.imagen}" name="descripcionDesayuno" type="text" maxlength="100" 
                                       class="form-control" required="">
                            </div>
                        </div> 
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="mb-3">
                                    <label>Imagen:</label>
                                    <input type="file" name="imagen" class="form-control" accept="image/*" id="inputImagen" ${habitacion.idHab == 0 ? "required": ""}>
                                    <div style="margin-top: 10px; max-width: 100%; overflow: hidden;"> 
                                        <img id="vistaPrevia" src="assets/img/recursos/habitacion/${habitacion.imagen}" 
                                             onerror="src='assets/img/recursos/img_not_found.jpg'"
                                             alt="Vista Previa" style="display: ${habitacion.imagen != null ? 'block' : 'none'}; width: 300px; height: 300px; height: auto;">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-sm-12">
                                <input type="hidden" name="id" value="${habitacion.idHab}">
                                <input type="hidden" name="accion" value="guardar">
                                <button class="btn btn-primary btn-sm">
                                    <i class="fa fa-save"></i> Guardar
                                </button>
                                <a href="HabitacionControlador?accion=listar" 
                                   class="btn btn-dark btn-sm">
                                    <i class="fa fa-arrow-left"></i> Volver atras
                                </a>
                            </div>

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
        document.getElementById('inputImagen').addEventListener('change', function (event) {
            const file = event.target.files[0];
            const vistaPrevia = document.getElementById('vistaPrevia');

            if (file) {
                const reader = new FileReader();

                reader.onload = function (e) {
                    vistaPrevia.src = e.target.result;
                    vistaPrevia.style.display = 'block';
                }

                reader.readAsDataURL(file);
            } else {
                vistaPrevia.style.display = 'none';
            }
        });
    </script>
</html>
