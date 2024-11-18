package utils;

import java.util.*;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.*;

public class CorreoUtil {

    private String correoEnvia = "recuperarUTP@gmail.com";
    private String contrasena = "yllhxwcjdnsaqplx";

    public String EnviarCorreo(String asunto, String cuerpo, String correo, boolean correoCc) {
        String result = "";
        Properties propiedad = new Properties();
        propiedad.setProperty("mail.smtp.host", "smtp.gmail.com");
        propiedad.setProperty("mail.smtp.starttls.enable", "true");
        propiedad.setProperty("mail.smtp.port", "587");
        propiedad.setProperty("mail.smtp.auth", "true");

        Session sesion = Session.getDefaultInstance(propiedad);
        MimeMessage mail = new MimeMessage(sesion);

        try {
            mail.setFrom(new InternetAddress(correoEnvia));
            mail.addRecipient(Message.RecipientType.TO, new InternetAddress(correo));

            if (correoCc == true) {
                mail.addRecipient(Message.RecipientType.CC, new InternetAddress(correoEnvia)); // Agregar CC
            }

            mail.setSubject(asunto);
            mail.addHeader("Content-Type", "text/html; charset=UTF-8");

            mail.setContent(cuerpo, "text/html");

            Transport transporte = sesion.getTransport("smtp");
            transporte.connect(correoEnvia, contrasena);

            transporte.sendMessage(mail, mail.getRecipients(Message.RecipientType.TO));
            transporte.close();

            result = "OK";
        } catch (Exception ex) {
            result = ex.getMessage();
            ex.printStackTrace();
        }
        return result;
    }
}
