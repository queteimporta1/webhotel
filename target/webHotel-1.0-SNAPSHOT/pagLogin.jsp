<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Login</title>
        <jsp:include page="includes/css.jsp" />
        <link href="assets/css/estilos/login.css" rel="stylesheet" type="text/css"/>
    </head>
    <body >
        <jsp:include page="includes/navegacion.jsp" />

        <div class="login-container">
            <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                <div class="card">
                    <div class="login-brand text-center">
                        <img src="assets/img/recursos/logo_login.png" alt="logo" 
                             class="shadow-light rounded-circle">
                    </div>

                    <div class="card-body">
                        <form method="POST" action="auth" >
                            <div class="form-group">
                                <label>Correo:</label>
                                <input value="${correo}" id="correo" type="email" class="form-control" name="correo" tabindex="1" required autofocus>
                            </div>

                            <div class="form-group">
                                <label class="control-label">Contraseña</label>
                                <input value="" id="password" type="password" class="form-control" name="password" tabindex="2" required>
                            </div>

                            <div class="form-group">
                                <input type="hidden" name="accion" value="login">
                                <button type="submit" class="btn btn-primary btn-lg btn-block" tabindex="4">
                                    Iniciar Sesíon
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-4 mb-3">
                            <div class="text-job text-muted">
                                <a href="auth?accion=new_account">
                                    ¿No tienes una cuenta? Regístrate.
                                </a>
                            </div>
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
</html>
