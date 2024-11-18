<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.ConstantesApp"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-primary color_fondo">
    <div class="container-fluid">
        <button
            data-mdb-collapse-init
            class="navbar-toggler"
            type="button"
            data-mdb-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent"
            aria-expanded="false"
            aria-label="Toggle navigation"
            >
            <i class="fas fa-bars"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <a class="navbar-brand mt-2 mt-lg-0" href="#">
                <img
                    src="assets/img/recursos/logo.png"
                    height="25"
                    alt="Logo"
                    loading="lazy"
                    />
            </a>

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <c:if test="${sessionScope.usuario == null || (sessionScope.esCliente)}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="UbicacionControlador?accion=inicio">Ubicación</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="HabitacionControlador?accion=inicio">Habitaciones</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="ServicioControlador?accion=inicio">Servicios</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="pagNosostros.jsp">Nosotros</a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.usuario != null && (sessionScope.usuario.idRol == ConstantesApp.ROL_ADMIN)}">
                    <li class="nav-item dropdown">
                        <a data-mdb-dropdown-init class="nav-link dropdown-toggle text-white"
                           href="#" id="navbarDropdown" role="button" aria-expanded="false">
                            Gestión
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li>
                                <a class="dropdown-item" href="SedeControlador?accion=listar">Sede</a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="HabitacionControlador?accion=listar">Habitación</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="ReservaControlador?accion=consulta">Consulta Reserva</a>
                            </li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${sessionScope.usuario != null && (sessionScope.usuario.idRol == ConstantesApp.ROL_VENTA)}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="ReservaControlador?accion=form_registro">Registrar Reserva</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="ReservaControlador?accion=lista_entrada">Reserva Salida</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="ReservaControlador?accion=consulta">Consulta Reserva</a>
                    </li>
                </c:if>

            </ul>
        </div>

        <div class="d-flex align-items-center">
            <c:if test="${sessionScope.usuario == null}">
                <a href="auth?accion=new_account" class="btn btn-dark btn-sm">
                    <i class="fas fa-user-plus"></i> Registrarse
                </a>
                &nbsp;
                <a href="pagLogin.jsp" class="btn btn-dark btn-sm">
                    <i class="fa fa-user-lock"></i> Login
                </a>
                &nbsp;
                <a href="ReservaControlador?accion=inicio" class="btn btn-danger btn-sm">
                    <i class="fa fa-calendar-alt"></i> Reservar
                </a>
            </c:if>
            <c:if test="${sessionScope.usuario != null}">
                <div class="dropdown">
                    <a
                        data-mdb-dropdown-init
                        class="dropdown-toggle d-flex align-items-center hidden-arrow text-white"
                        href="#"
                        id="navbarDropdownMenuAvatar"
                        role="button"
                        aria-expanded="false"
                        >
                        ¡Hola, ${sessionScope.usuario.NombreCorto()}! &nbsp; <span class='badge rounded-pill badge-success'> ${sessionScope.usuario.nombreRol} </span>
                        &nbsp;
                        <c:if test="${sessionScope.usuario.foto != null}">
                            <img src="assets/img/recursos/usuarios/${sessionScope.usuario.foto}" 
                                 onerror="this.onerror=null; this.src='assets/img/recursos/avatar_hombre.png';" 
                                 class="rounded-circle"
                                 height="35"
                                 alt="Avatar"/>  
                        </c:if>
                        <c:if test="${sessionScope.usuario.foto == null}">
                            <c:choose>
                                <c:when test="${sessionScope.usuario.genero == 'M'}">
                                    <img src="assets/img/recursos/avatar_hombre.png" 
                                         class="rounded-circle"
                                         height="35"
                                         alt="Avatar"/>  
                                </c:when>
                                <c:otherwise>
                                    <img src="assets/img/recursos/avatar_mujer.jpg" 
                                         class="rounded-circle"
                                         height="35"
                                         alt="Avatar"/>  
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                    </a>
                    <ul
                        class="dropdown-menu dropdown-menu-end"
                        aria-labelledby="navbarDropdownMenuAvatar"
                        >
                        <li>
                            <a class="dropdown-item" href="perfil?accion=ver">Mi Perfil</a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="auth?accion=logout">Cerrar Sesión</a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>
</nav>