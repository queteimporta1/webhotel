<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Ubicación</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container-fluid mt-4">
            <div class="row">
                <div class="col-sm-3">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Sedes</h5>
                            <hr />
                            <ul class="list-group" id="listaSedes">
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- Mapa -->
                <div class="col-sm-9">
                    <div class="map">
                        <iframe id="gmap" src="https://www.google.com/maps?q=-12.16291,-76.978989&hl=es&z=14&output=embed"
                                width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"
                                referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />

        <script>
            const listSedes = [];

            function cargarMapa(ubicacion) {
                var iframe = document.getElementById("gmap");
                iframe.src = ubicacion;
            }

            function fnObtenerSedes() {
                var _params = {
                    "accion": "listar_sedes"
                };
                const listaSedes = document.getElementById("listaSedes");
                listaSedes.innerHTML = "";

                axios
                        .get("UbicacionControlador", {params: _params})
                        .then((response) => {
                            response = response.data;
                            response.forEach((sede, index) => {
                                const li = document.createElement("li");
                                li.className = "list-group-item list-group-item-action";
                                li.innerHTML = "<i class='fa-solid fa-arrow-right'></i> <span style='font-size:10px;'>"+ sede.departamento+"</span> <span class='badge rounded-pill badge-success'>"+sede.nombre+"</span>";
                                li.addEventListener("click", function () {
                                    cargarMapa(sede.ubicacion);
                                });

                                listaSedes.appendChild(li);
                            });
                        })
                        .catch((error) => {
                            console.dir(error);
                            fnToastr("error", "No se pudo cargar sedes.");
                        });
            }

            fnObtenerSedes();
        </script>
    </body>
</html>
