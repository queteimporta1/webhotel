<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Formulario de Registro</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body onload="fnAjustarLongitudes()">
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container mt-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="text-center">Nueva Cuenta</h5>
                    <hr />
                    <form action="auth" method="post">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label>Nombre Completo:</label>
                                    <input type="text" id="nombreCompleto" name="nombreCompleto" 
                                           class="form-control" required value="${cliente.nombreCompleto}" onkeypress="return soloLetras(event)"/>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label>País:</label>
                                    <select id="pais" name="pais" class="form-control" required="" onchange="fnAjustarLongitudes()">
                                        <option value="">::: Seleccione :::</option>
                                        <c:forEach items="${paises}" var="item" >
                                            <option value="${item.idPais}"
                                                    ${cliente.pais.idPais == item.idPais ? "selected": ""}
                                                    >${item.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label>Género:</label>
                                    <select id="genero" name="genero" class="form-control" required="">
                                        <option value="">::: Seleccione :::</option>
                                        <option value="M" ${cliente.genero == "M" ? "selected": ""}>Masculino</option>
                                        <option value="F" ${cliente.genero == "F" ? "selected": ""}>Femenino</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label>Tipo de Documento:</label>
                                    <select id="tipoDocumento" name="tipoDocumento" class="form-control" required="">
                                        <option value="">::: Seleccione :::</option>
                                        <c:forEach items="${tipos_documentos}" var="item">
                                            <option value="${item.idTipoDoc}"
                                                    ${cliente.tipoDocumento.idTipoDoc == item.idTipoDoc ? "selected": ""}
                                                    >${item.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label>Número Documento:</label>
                                    <input type="text" id="nroDocumento" name="nroDocumento" class="form-control"
                                           required value="${cliente.nroDocumento}" onkeypress="return soloNumeros(event)"/>
                                </div>
                            </div>

                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label>Número Celular</label>
                                    <input type="text" id="nroCelular" name="nroCelular" class="form-control"
                                           required value="${cliente.nroCelular}" onkeypress="return soloNumeros(event)"/>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group mt-3">
                                    <label>Correo Electrónico</label>
                                    <input type="email" id="correo" name="correo" class="form-control" 
                                           required value="${cliente.usuario.correo}"/>
                                </div>

                            </div>
                            <div class="col-sm-6">
                                <div class="form-group mt-3">
                                    <label>Contraseña</label>
                                    <input type="password" id="password" name="password" class="form-control"
                                           required value="${cliente.usuario.password}"/>
                                </div>

                            </div>
                        </div>

                        <div class="form-group mt-4">
                            <input type="hidden" name="accion" value="register">
                            <button type="submit" class="btn btn-primary">Registrarse</button>
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
        function fnAjustarLongitudes() {
            const pais = document.getElementById("pais").value;
            const nroDocumento = document.getElementById("nroDocumento");
            const nroCelular = document.getElementById("nroCelular");

            if (parseInt(pais) === ${pais_peru}) {
                nroDocumento.maxLength = 8;
                nroCelular.maxLength = 9;
            } else {
                nroDocumento.maxLength = 20;
                nroCelular.maxLength = 15;
            }
        }
    </script>
</html>
