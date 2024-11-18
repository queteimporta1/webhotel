<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <title>Nosotros - Hotel Paraíso</title>
        <jsp:include page="includes/css.jsp" />
        <!--
        <style>
            h2 {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                color: #3c3c3c;
            }

            p {
                font-family: 'Roboto', sans-serif;
                color: #555;
                line-height: 1.7;
                margin-bottom: 1.5rem;
            }

            section {
                background-color: #f8f9fa;
                padding: 50px 30px;
                border-radius: 10px;
                margin-bottom: 50px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .valores {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                margin-top: 30px;
            }

            .valores .valor {
                background-color: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                transition: all 0.3s ease-in-out;
            }

            .valores .valor:hover {
                transform: translateY(-5px);
            }
            .valores .valor i {
                font-size: 36px;
                color: #007bff;
                margin-bottom: 10px;
            }

            .inversionista-contacto {
                font-family: 'Roboto', sans-serif;
                font-weight: 500;
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                transition: background-color 0.3s;
            }

            .inversionista-contacto:hover {
                background-color: #0056b3;
            }

            .highlight {
                background-color: #fff5e1;
                padding: 15px;
                border-left: 5px solid #f39c12;
            }

        </style>
        -->
        <style>
            h2 {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                color: #3c3c3c;
            }

            p {
                font-family: 'Roboto', sans-serif;
                color: #555;
                line-height: 1.7;
                margin-bottom: 1.5rem;
            }

            section {
                background-color: #f8f9fa;
                padding: 50px 30px;
                border-radius: 10px;
                margin-bottom: 50px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .valores {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                margin-top: 30px;
            }

            .valores .valor {
                background-color: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                transition: all 0.3s ease-in-out;
            }

            .valores .valor:hover {
                transform: translateY(-5px);
            }
            .valores .valor i {
                font-size: 36px;
                color: #007bff;
                margin-bottom: 10px;
            }

            .inversionista-contacto {
                font-family: 'Roboto', sans-serif;
                font-weight: 500;
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                transition: background-color 0.3s;
            }

            .inversionista-contacto:hover {
                background-color: #0056b3;
            }

            .highlight {
                background-color: #fff5e1;
                padding: 15px;
                border-left: 5px solid #f39c12;
            }

        </style>
    </head>
    <body>
        <jsp:include page="includes/navegacion.jsp" />

        <div class="container mt-5">
            <section class="highlight">
                <h2 class="text-center">Historia del Hospedaje</h2>
                <p>
                    El hotel se originó como una necesidad básica de alojamiento para los viajeros, aunque su verdadero auge se dio en los 2023, cuando los turistas viajaban para visitar lugares turísticos y necesitaban un lugar para hospedarse. 
                    Los monasterios y hospederías proporcionaban alojamiento básico, pero a medida que el comercio y los viajes aumentaron en la ciudad de Huancayo, se creó el <strong>Hotel Paraíso</strong>, brindando lujo y seguridad a los turistas y visitantes del Valle del Mantaro.
                </p>
            </section>

            <!-- Quiénes Somos -->
            <section class="highlight">
                <h2 class="text-center">¿Quiénes Somos?</h2>
                <p class="text-justify">
                    En <strong>Hotel Paraíso</strong> ofrecemos un refugio de tranquilidad y confort en el corazón de la sierra y la selva peruana. Combinamos hospitalidad de primer nivel con el encanto natural de nuestras ubicaciones, proporcionando una experiencia ideal tanto para escapadas románticas como para estadías familiares o VIP.
                </p>
            </section>

            <!-- Sobre Nosotros -->
            <section class="highlight">
                <h2 class="text-center">Sobre Nosotros</h2>
                <p>
                    <strong>Hotel Paraíso</strong> nació con el objetivo de unir la belleza de la sierra y la selva en un solo lugar. Desde nuestra primera apertura en Huancayo, ofrecemos habitaciones individuales, familiares, matrimoniales y VIP, además de instalaciones con piscina, campo deportivo y áreas recreativas rodeadas de naturaleza.
                </p>
            </section>

            <!-- Valores -->
            <section class="highlight">
                <h2 class="text-center">Nuestros Valores</h2>
                <div class="valores">
                    <div class="col-md-4 valor text-center">
                        <i class="fas fa-hands-helping"></i>
                        <h5>Hospitalidad</h5>
                        <p>Ofrecemos un servicio cálido y personalizado, haciendo que cada huésped se sienta como en casa.</p>
                    </div>
                    <div class="col-md-4 valor text-center">
                        <i class="fas fa-star"></i>
                        <h5>Calidad</h5>
                        <p>Mantenemos altos estándares en todas nuestras instalaciones, desde las habitaciones hasta las áreas recreativas.</p>
                    </div>
                    <div class="col-md-4 valor text-center">
                        <i class="fas fa-leaf"></i>
                        <h5>Sostenibilidad</h5>
                        <p>Respetamos el entorno natural y aplicamos prácticas sostenibles para reducir nuestro impacto ambiental.</p>
                    </div>
                    <div class="col-md-4 valor text-center">
                        <i class="fas fa-users"></i>
                        <h5>Diversidad</h5>
                        <p>Disponemos de una amplia variedad de servicios y alojamientos para satisfacer a cada visitante.</p>
                    </div>
                    <div class="col-md-4 valor text-center">
                        <i class="fas fa-lightbulb"></i>
                        <h5>Innovación</h5>
                        <p>Mejoramos continuamente nuestras instalaciones y servicios para brindar lo mejor a nuestros clientes.</p>
                    </div>
                </div>
            </section>

            <!-- Historia del Fundador -->
            <section class="highlight">
                <h2 class="text-center">Historia del Fundador</h2>
                <p class="text-center">
                    <strong>Jorge Quispe</strong>, nacido en Huancayo, fue un emprendedor visionario con un profundo amor por su tierra. Fundó el <strong>Hotel Paraíso</strong> en Huancayo, y tras su éxito, abrió un segundo hotel en La Merced, ofreciendo un refugio donde la comodidad y la naturaleza se unen en perfecta armonía.
                </p>
            </section>

            <!-- Inversionistas -->
            <section class="highlight">
                <h2 class="text-center">Inversionistas</h2>
                <div class="row text-center">
                    <div class="col-md-6 mb-4">
                        <h5><strong>Américo Coras</strong></h5>
                        <p>Dueño del Hotel Paraíso en Huancayo, modernizando el hotel mientras mantiene su esencia acogedora.</p>
                        <a href="mailto:Corasquispejorge_@gmail.com" class="inversionista-contacto">Contactar</a>
                    </div>
                    <div class="col-md-6 mb-4">
                        <h5><strong>Andy Martínez</strong></h5>
                        <p>Dueño del Hotel Paraíso en La Merced, impulsando el hotel con tecnología avanzada para atraer turistas a la selva central.</p>
                        <a href="mailto:gustavomart200329@gmail.com" class="inversionista-contacto">Contactar</a>
                    </div>
                </div>
            </section>
        </div>

        <jsp:include page="includes/js.jsp" />
        <jsp:include page="includes/alertas.jsp" />
        <jsp:include page="includes/contacto.jsp" />
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
