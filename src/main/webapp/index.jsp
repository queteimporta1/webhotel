<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Inicio</title>
        <jsp:include page="includes/css.jsp" />
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container mt-3">
            <div id="carouselBasicExample" class="carousel slide carousel-fade" data-mdb-ride="carousel" data-mdb-carousel-init>
                <div class="carousel-indicators">
                    <button
                        type="button"
                        data-mdb-target="#carouselBasicExample"
                        data-mdb-slide-to="0"
                        class="active"
                        aria-current="true"
                        aria-label="Slide 1"
                        ></button>
                    <button
                        type="button"
                        data-mdb-target="#carouselBasicExample"
                        data-mdb-slide-to="1"
                        aria-label="Slide 2"
                        ></button>
                    <button
                        type="button"
                        data-mdb-target="#carouselBasicExample"
                        data-mdb-slide-to="2"
                        aria-label="Slide 3"
                        ></button>
                </div>

                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="https://hotelb.pe/wp-content/uploads/2020/08/home-banner5_03-min.jpg" class="d-block w-100" alt="Sunset Over the City"/>
                        <div class="carousel-caption d-none d-md-block">
                            <h4 class="texto_resaltado">
                                "Donde la comodidad se encuentra con el lujo en cada rincón."
                            </h4>
                            <h5 class="texto_resaltado">Fecha: ${app_fecha_actual} - Usuario Inscritos: ${app_cant_inscritos}</h5>
                        </div>
                    </div>

                    <div class="carousel-item">
                        <img src="https://hotelb.pe/wp-content/uploads/2020/09/home-banner7_03-min-1.jpg" class="d-block w-100" alt="Canyon at Nigh"/>
                        <div class="carousel-caption d-none d-md-block">
                            <h4 class="texto_resaltado">
                                "Tu oasis de tranquilidad en el corazón de la ciudad."
                            </h4>
                            <h5 class="texto_resaltado">Fecha: ${app_fecha_actual} - Usuario Inscritos: ${app_cant_inscritos}</h5>
                        </div>
                    </div>

                    <div class="carousel-item">
                        <img src="https://hotelb.pe/wp-content/uploads/2020/08/home-baner2_03-min.jpg" class="d-block w-100" alt="Cliff Above a Stormy Sea"/>
                        <div class="carousel-caption d-none d-md-block">
                            <h4 class="texto_resaltado">
                                "Descubre un hogar lejos de casa con el servicio que mereces."
                            </h4>
                            <h5 class="texto_resaltado">Fecha: ${app_fecha_actual} - Usuario Inscritos: ${app_cant_inscritos}</h5>
                        </div>
                    </div>
                </div>

                <button class="carousel-control-prev" type="button" data-mdb-target="#carouselBasicExample" data-mdb-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-mdb-target="#carouselBasicExample" data-mdb-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>

        <div class="container-fluid mt-3">
            <div class="row">
                <div class="col-sm-4">
                    <div class="container">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title text-center">Reseñas de Clientes</h5>
                                <hr />
                                <div class="d-flex align-items-center">
                                    <div class="mr-3">
                                        <span class="stars">★★★★★</span>
                                    </div>
                                    <div class="progress flex-grow-1" style="height: 10px;">
                                        <div class="progress-bar bg-primary" role="progressbar"
                                             style="width: ${app_porcCalificacion[4].porcCalificacion}%;"  
                                             aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="ml-3">&nbsp; ${app_porcCalificacion[4].porcCalificacion}%</div>
                                </div>

                                <div class="d-flex align-items-center mt-2" >
                                    <div class="mr-3">
                                        <span class="stars">★★★★</span><span class="empty-stars">★</span>
                                    </div>
                                    <div class="progress flex-grow-1" style="height: 10px;">
                                        <div class="progress-bar bg-primary" role="progressbar" 
                                             style="width: ${app_porcCalificacion[3].porcCalificacion}%;"
                                             aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="ml-3">&nbsp; ${app_porcCalificacion[3].porcCalificacion}%</div>
                                </div>

                                <div class="d-flex align-items-center mt-2">
                                    <div class="mr-3">
                                        <span class="stars">★★★</span><span class="empty-stars">★★</span>
                                    </div>
                                    <div class="progress flex-grow-1" style="height: 10px;">
                                        <div class="progress-bar bg-primary" role="progressbar" 
                                             style="width: ${app_porcCalificacion[2].porcCalificacion}%;" 
                                             aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="ml-3">&nbsp; ${app_porcCalificacion[2].porcCalificacion}%</div>
                                </div>

                                <div class="d-flex align-items-center mt-2">
                                    <div class="mr-3">
                                        <span class="stars">★★</span><span class="empty-stars">★★★</span>
                                    </div>
                                    <div class="progress flex-grow-1" style="height: 10px;">
                                        <div class="progress-bar bg-primary" role="progressbar" 
                                             style="width: ${app_porcCalificacion[1].porcCalificacion}%;" 
                                             aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="ml-3">&nbsp; ${app_porcCalificacion[1].porcCalificacion}%</div>
                                </div>

                                <div class="d-flex align-items-center mt-2">
                                    <div class="mr-3">
                                        <span class="stars">★</span><span class="empty-stars">★★★★</span>
                                    </div>
                                    <div class="progress flex-grow-1" style="height: 10px;">
                                        <div class="progress-bar bg-primary" 
                                             role="progressbar" 
                                             style="width: ${app_porcCalificacion[0].porcCalificacion}%;" 
                                             aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="ml-3">&nbsp; ${app_porcCalificacion[0].porcCalificacion}%</div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-8">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title text-center">Calificanos</h5>
                            <hr />
                            <c:if test="${sessionScope.usuario == null}">
                                <span style="color: red;">Nota: Recuerde que para realizar un comentario y calificación debe iniciar sesión primero.</span>
                            </c:if> 
                            <form action="comentario" method="post">
                                <div class="row">

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group row">
                                            <label class="col-sm-4 col-form-label">Servicio:</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="servicio" name="servicio">
                                                    <option value="NO CUMPLE">✘ NO CUMPLE</option>
                                                    <option value="SI CUMPLE">✔ SI CUMPLE</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label class="col-sm-4 col-form-label">Habitación:</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="habitacion" name="habitacion">
                                                    <option value="NO CUMPLE">✘ NO CUMPLE</option>
                                                    <option value="SI CUMPLE">✔ SI CUMPLE</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="col-sm-4 col-form-label">Ambiente:</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="ambiente" name="ambiente">
                                                    <option value="NO CUMPLE">✘ NO CUMPLE</option>
                                                    <option value="SI CUMPLE">✔ SI CUMPLE</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="col-sm-4 col-form-label">Calificación:</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="calificacion" name="calificacion">
                                                    <option value="1">1 ★</option>
                                                    <option value="2">2 ★★</option>
                                                    <option value="3">3 ★★★</option>
                                                    <option value="4">4 ★★★★</option>
                                                    <option value="5">5 ★★★★★</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">

                                        <div class="form-group">
                                            <label>Comentario:</label>
                                            <textarea ${sessionScope.usuario == null? 'disabled' : ''}
                                                class="form-control" id="comentario" name="comentario" rows="4" required=""></textarea>
                                        </div>

                                        <input type="hidden" name="accion" value="guardar">
                                        <button ${(sessionScope.usuario != null && (sessionScope.esCliente != null && sessionScope.esCliente == true)) ?
                                                  '' : 'disabled'}
                                            type="submit" class="btn btn-primary mt-2">Enviar</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${app_comentarios.size() > 0}">
                <div class="card mt-2 ">
                    <div class="card-body">
                        <h4 class="text-center">Comentarios</h4>
                        <hr />

                        <div id="comentariosCarousel" class="carousel slide" data-mdb-ride="carousel" 
                             data-mdb-carousel-init>

                            <div class="carousel-indicators">
                                <c:forEach var="item" items="${app_comentarios}" varStatus="status">
                                    <c:if test="${status.index % 3 == 0}">
                                        <button
                                            style="background-color: #1f6489"
                                            type="button"
                                            data-mdb-target="#comentariosCarousel"
                                            data-mdb-slide-to="${(status.index / 3).intValue()}"
                                            class="${status.index == 0 ? 'active' : ''} "
                                            aria-label="Slide ${status.index / 3 + 1}"
                                            ></button>
                                    </c:if>
                                </c:forEach>
                            </div>

                            <div class="carousel-inner">
                                <c:forEach var="item" items="${app_comentarios}" varStatus="status">
                                    <c:if test="${status.index % 3 == 0}">
                                        <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                                            <div class="row">
                                            </c:if>

                                            <div class="col-sm-4 mb-3">
                                                <ul class="list-group list-group-light">
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <div class="d-flex align-items-center">
                                                            <div class="ms-3">
                                                                <div class="row">
                                                                    <div class="col-sm-4 text-center">
                                                                        <c:if test="${item.cliente.foto != null}">
                                                                            <img src="${item.cliente.foto}" 
                                                                                 alt="" style="width: 75px; height: 75px"
                                                                                 class="rounded-circle" />  
                                                                        </c:if>
                                                                        <c:if test="${item.cliente.foto == null}">
                                                                            <c:choose>
                                                                                <c:when test="${item.cliente.genero == 'M'}">
                                                                                    <img src="assets/img/recursos/avatar_hombre.png" 
                                                                                         alt="Avatar" style="width: 75px; height: 75px"
                                                                                         class="rounded-circle" />  
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="assets/img/recursos/avatar_mujer.jpg" 
                                                                                         alt="Avatar" style="width: 75px; height: 75px"
                                                                                         class="rounded-circle" />  
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:if>
                                                                    </div>
                                                                    <div class="col-sm-8">
                                                                        <p class="fw-bold mb-1">${item.cliente.nombreCompleto}</p>
                                                                        <p class="text-muted mb-0">${item.cliente.usuario.correo}</p>
                                                                        <p>
                                                                            <c:choose>
                                                                                <c:when test="${item.nroCalificacion == 5}">
                                                                                    <span class="stars">★★★★★</span>
                                                                                </c:when>
                                                                                <c:when test="${item.nroCalificacion == 4}">
                                                                                    <span class="stars">★★★★</span><span class="empty-stars">★</span>
                                                                                </c:when>
                                                                                <c:when test="${item.nroCalificacion == 3}">
                                                                                    <span class="stars">★★★</span><span class="empty-stars">★★</span>
                                                                                </c:when>
                                                                                <c:when test="${item.nroCalificacion == 2}">
                                                                                    <span class="stars">★★</span><span class="empty-stars">★★★</span>
                                                                                </c:when>
                                                                                <c:when test="${item.nroCalificacion == 1}">
                                                                                    <span class="stars">★</span><span class="empty-stars">★★★★</span>
                                                                                </c:when>
                                                                            </c:choose>
                                                                            &nbsp;  &nbsp; <span class="badge rounded-pill badge-success">${item.fecha}</span>
                                                                        </p>
                                                                    </div>
                                                                </div>

                                                                <div class="row">
                                                                    <div class="col-sm-12">
                                                                        <p style="text-align: justify;">${item.descripcion}</p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </div>

                                            <c:if test="${(status.index + 1) % 3 == 0 || status.last}">
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>

                            <button class="carousel-control-prev" type="button" data-mdb-target="#comentariosCarousel" data-mdb-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-mdb-target="#comentariosCarousel" data-mdb-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>               

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var myCarousel = document.querySelector('#comentariosCarousel');
            var carousel = new bootstrap.Carousel(myCarousel, {
                interval: 10000,
                wrap: true
            });
        });
    </script>
</html>