<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<footer class="fondo_contacto text-white py-4 mt-2">
    <div class="container">
        <div class="row">

            <div class="col-md-4 mb-3 mb-md-0 mt-5 text-center">
                <img src="assets/img/recursos/logo.png" alt="Logo" class="img-fluid" >
            </div>


            <div class="col-md-4 mb-3 mb-md-0">
                <h5>Conócenos</h5>
                <hr />
                <ol class="list-unstyled">
                    <li><a href="javascript:void(0)" class="text-white">Quienes somos</a></li>
                    <li><a href="javascript:void(0)" class="text-white">Servicios</a></li>
                    <li><a href="javascript:void(0)" class="text-white">Código de Ética</a></li>
                    <li><a href="javascript:void(0)" class="text-white">Políticas de Privacidad</a></li>
                    <li><a href="javascript:void(0)" class="text-white"
                           data-toggle="modal" data-target="#reclamacionesModal">Libro de Reclamaciones</a></li>
                    <li><a href="javascript:void(0)" class="text-white">Nuestros Valores</a></li>
                </ol>
            </div>


            <div class="col-md-4">
                <h5>Contacto</h5>
                <hr />
                <form>
                    <div class="form-group">
                        <label for="name">Nombre</label>
                        <input type="text" class="form-control" id="nombre" placeholder="Tu nombre">
                    </div>
                    <div class="form-group">
                        <label for="email">Correo</label>
                        <input type="email" class="form-control" id="correoEnv" placeholder="Tu correo">
                    </div>
                    <div class="form-group">
                        <label for="message">Mensaje</label>
                        <textarea class="form-control" id="mensaje" rows="3" placeholder="Tu mensaje"></textarea>
                    </div>
                    <br />
                    <button type="button" class="btn btn-success btn-sm" onclick="fnEnviarCorreoContacto()">Enviar</button>
                </form>
            </div>
        </div>
    </div>
</footer>

<div class="modal fade" id="reclamacionesModal" 
     data-backdrop="static" data-keyboard="false" tabindex="-1"
     aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">::: Libro de Reclamación :::</h5>
                <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="reclamacionesForm">
                    <div class="form-group">
                        <label for="sede">Sede: <span style="color: red">(*)</span></label>
                        <select class="form-control" id="sede" name="sede" required>
                            <option value="">::: Seleccione :::</option>
                            <c:forEach items="${app_sedes}" var="item">
                                <option value="${item.idSede}"
                                        >${item.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="celular">Número de Celular: <span style="color: red">(*)</span></label>
                        <input type="tel" class="form-control" id="celular" placeholder="Tu número de celular" required>
                    </div>
                    <div class="form-group">
                        <label for="nroDocumento">Número de Documento: <span style="color: red">(*)</span></label>
                        <input type="text" class="form-control" id="nroDocumentoReclamacion" placeholder="Tu número de documento" required>
                    </div>
                    <div class="form-group">
                        <label for="correoReclamacion">Correo: <span style="color: red">(*)</span></label>
                        <input type="email" class="form-control" id="correoReclamacion" placeholder="Tu correo" required>
                    </div>
                    <div class="form-group">
                        <label for="mensajeReclamacion">Mensaje: <span style="color: red">(*)</span></label>
                        <textarea class="form-control" id="mensajeReclamacion" rows="3" placeholder="Tu mensaje" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="archivos">Subir Archivos: (Opcional)</label>
                        <input type="file" class="form-control-file" id="archivos" multiple required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" onclick="fnEnviarReclamacion()">Enviar Reclamación</button>
            </div>
        </div>
    </div>
</div>


<script>
    function fnEnviarCorreoContacto() {
        var correo = document.getElementById("correoEnv").value;
        var mensaje = document.getElementById("mensaje").value;
        var nombre = document.getElementById("nombre").value;

        if (!nombre) {
            fnToastr("info", "Debe ingresar su nombre");
            return;
        }
        if (!correo) {
            fnToastr("info", "Debe ingresar un correo electronico");
            return;
        }
        if (!mensaje) {
            fnToastr("info", "Debe ingresar un mensaje");
            return;
        }

        var _params = {
            "accion": "enviar_contacto",
            "correo": correo,
            "mensaje": mensaje,
            "nombre": nombre
        };

        axios
                .get("CorreoControlador", {params: _params})
                .then((response) => {
                    response = response.data;

                    if (response.msg === "OK") {
                        fnToastr("success", "Correo enviado!");
                    } else {
                        console.error(response.msg);
                        fnToastr("error", "No se pudo enviar correo!");
                    }
                })
                .catch((error) => {
                    console.dir(error);
                    fnToastr("error", "No se pudo obtener consultar respuesta.");
                });
    }

    function fnEnviarReclamacion() {
        var sede = document.getElementById("sede").value;
        var celular = document.getElementById("celular").value;
        var nroDocumento = document.getElementById("nroDocumentoReclamacion").value;
        var correo = document.getElementById("correoReclamacion").value;
        var mensaje = document.getElementById("mensajeReclamacion").value;
        var archivos = document.getElementById("archivos").files;

        if (!sede || !celular || !nroDocumento || !correo || !mensaje) {
            fnToastr("info", "Por favor, completa todos los campos.");
            return;
        }

        var formData = new FormData();
        formData.append("accion", "enviar_reclamacion");
        formData.append("sede", sede);
        formData.append("celular", celular);
        formData.append("nroDocumento", nroDocumento);
        formData.append("correo", correo);
        formData.append("mensaje", mensaje);

        for (var i = 0; i < archivos.length; i++) {
            formData.append("archivos[]", archivos[i]);
        }

        axios.post("LibroReclamacionControlador", formData)
                .then((response) => {
                    response = response.data;

                    if (response.msg === "OK") {
                        fnToastr("success", "Reclamo enviado correctamente!");
                        $('#reclamacionesModal').modal('hide');
                        document.getElementById("reclamacionesForm").reset();
                    } else {
                        fnToastr("error", response.msg);
                    }
                })
                .catch((error) => {
                    console.dir(error);
                    fnToastr("error", "Error al enviar la reclamación.");
                });
    }
</script>
