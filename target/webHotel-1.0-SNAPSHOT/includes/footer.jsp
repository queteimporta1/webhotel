<footer class="fondo_footer text-white py-3">
    <div class="container">
        <div class="row">
            <div class="col-md-6 mb-3 mb-md-0">
                <h5>REDES SOCIALES</h5>
            </div>

            <div class="col-md-6 mb-3 mb-md-0 text-center">
                <a href="https://wa.me/51991499144" target="_blank" class="text-white mx-2" title="WhatsApp">
                    <i class="fab fa-whatsapp fa-2x"></i>
                </a> 
                <a href="https://www.facebook.com/andy.martinezbarzola/" target="_blank"  class="text-white mx-2" title="Facebook">
                    <i class="fab fa-facebook fa-2x"></i>
                </a>
               <a href="https://youtube.com/@andymartinez-cw7wm?si=sqSS6SEr_sOiW12I" target="_blank"  class="text-white mx-2" title="Youtube">
                    <i class="fab fa-youtube fa-2x"></i>
                </a>
            </div>
        </div>
    </div>
</footer>

<div class="relative">
    <img src="${pageContext.request.contextPath}/assets/img/recursos/bot.gif" alt="Bot" class="bot-icon"/>

    <div class="tooltip">
        Pregúntame!
    </div>
</div>

<!-- Estilos -->
<style>
    .bot-icon {
        width: 80px;
        height: 80px;
        border-radius: 20px;
        position: fixed;
        right: 20px;
        bottom: 20px; 
    }

    .tooltip {
        position: fixed;
        right: 20px;
        bottom: 110px; 
        background-color: black;
        color: white;
        padding: 0.5rem;
        border-radius: 0.375rem;
        z-index: 50;
    }
</style>