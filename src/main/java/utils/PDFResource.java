package utils;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import jakarta.servlet.http.HttpServletResponse;
import java.awt.Color;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import modelo.Reserva;
import modelo.Servicio;

public class PDFResource {

    private String logoPath = "assets\\img\\recursos\\logo_V1.png";

    public void ReporteDeAlumnosGeneral(HttpServletResponse response) throws Exception {
        Document documento = new Document();
        // INICIO ROTAR DOCUMENTO
        documento.setPageSize(PageSize.LETTER.rotate());
        documento.setMargins(-50, -50, 30, 20);
        // FIN ROTAR DOCUMENTO
        PdfWriter.getInstance(documento, response.getOutputStream());
        documento.open();

        Font fuenteTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, new BaseColor(25, 27, 26));

        PdfPTable tablaTitulo = new PdfPTable(1);
        PdfPCell celda = new PdfPCell(new Phrase("LISTADO GENERAL DE ALUMNOS", fuenteTitulo));
        celda.setBorder(0);
        celda.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        celda.setVerticalAlignment(PdfPCell.ALIGN_CENTER);
        tablaTitulo.addCell(celda);
        tablaTitulo.setSpacingAfter(20);

        documento.add(tablaTitulo);
        documento.close();
    }

    public ByteArrayInputStream generateReservaPDF(HttpServletResponse response,
            Reserva reserva, String rutaAbsoluta) throws Exception {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        Document documento = new Document(PageSize.A4);
        PdfWriter.getInstance(documento, stream);

        // Abrir documento
        documento.open();

        // Agregar logo
        Image logo = Image.getInstance(rutaAbsoluta + logoPath);
        logo.scaleToFit(100, 50); // Ajustar el tamaño del logo
        logo.setAlignment(Element.ALIGN_LEFT);
        documento.add(logo);

        // Agregar título
        Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
        PdfPTable tablaTitulo = new PdfPTable(1);
        tablaTitulo.setWidthPercentage(100);
        PdfPCell celdaTitulo = new PdfPCell(new Phrase("Detalle de Reserva", fontTitulo));
        celdaTitulo.setBorder(0);
        celdaTitulo.setHorizontalAlignment(Element.ALIGN_CENTER);
        celdaTitulo.setPadding(10);
        tablaTitulo.addCell(celdaTitulo);
        documento.add(tablaTitulo);

      // documento.add(new Phrase("\n"));

        // Información general de la reserva
        PdfPTable tablaReserva = new PdfPTable(2); // Crear tabla con 2 columnas
        tablaReserva.setWidthPercentage(100);
        tablaReserva.setSpacingBefore(10f);
        tablaReserva.setSpacingAfter(10f);

        // Agregar contenido a la tabla
        addTableCell(tablaReserva, "Codigo Reserva:", reserva.getIdReserva());
        addTableCell(tablaReserva, "Codigo Cliente:", reserva.getIdCliente());
        addTableCell(tablaReserva, "Nombre del Reservante:", reserva.getNombreReservante());
        addTableCell(tablaReserva, "Correo:", reserva.getCorreo());
        addTableCell(tablaReserva, "Nro Documento:", reserva.getNroDocumento());
        addTableCell(tablaReserva, "Nro Celular:", reserva.getNroCelular());
        addTableCell(tablaReserva, "Fecha Reserva:", reserva.getFechaReserva());
        addTableCell(tablaReserva, "Hora Reserva:", reserva.getHoraReserva());
        addTableCell(tablaReserva, "Fecha Salida:", reserva.getFechaSalida() == null ? "" : reserva.getFechaSalida());
        addTableCell(tablaReserva, "Hora Salida:", reserva.getHoraSalida() == null ? "" : reserva.getHoraSalida());

        // Añadir la tabla al documento
        documento.add(tablaReserva);

    //    documento.add(new Phrase("\n"));

        // Mostrar servicios si están disponibles
        if (reserva.getDetalleReserva().getServicio() != null) {
            // Título de servicios
            Font fontServicios = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.BLACK);
            PdfPTable tablaServiciosTitulo = new PdfPTable(1);
            tablaServiciosTitulo.setWidthPercentage(100);
            PdfPCell celdaServiciosTitulo = new PdfPCell(new Phrase("Servicios", fontServicios));
            celdaServiciosTitulo.setBorder(0);
            celdaServiciosTitulo.setHorizontalAlignment(Element.ALIGN_CENTER);
            celdaServiciosTitulo.setPadding(10);
            tablaServiciosTitulo.addCell(celdaServiciosTitulo);
            documento.add(tablaServiciosTitulo);

            // Tabla de servicios
            PdfPTable tablaServicios = new PdfPTable(2);
            tablaServicios.setWidthPercentage(100);
            tablaServicios.setSpacingBefore(10f);
            tablaServicios.setSpacingAfter(10f);

            Servicio servicio = reserva.getDetalleReserva().getServicio();
            addTableCell(tablaServicios, "Servicio:", servicio.getNombre());
            addTableCell(tablaServicios, "Precio:", reserva.getDetalleReserva().getCostoServicio());

            // Añadir tabla de servicios al documento
            documento.add(tablaServicios);
        }

        // Mostrar habitación si está disponible
        if (reserva.getDetalleReserva().getHabitacion() != null) {
            // Título de habitación
            Font fontHabitacion = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.BLACK);
            PdfPTable tablaHabitacionTitulo = new PdfPTable(1);
            tablaHabitacionTitulo.setWidthPercentage(100);
            PdfPCell celdaHabitacionTitulo = new PdfPCell(new Phrase("Habitación", fontHabitacion));
            celdaHabitacionTitulo.setBorder(0);
            celdaHabitacionTitulo.setHorizontalAlignment(Element.ALIGN_CENTER);
            celdaHabitacionTitulo.setPadding(10);
            tablaHabitacionTitulo.addCell(celdaHabitacionTitulo);
            documento.add(tablaHabitacionTitulo);

            // Tabla de habitación
            PdfPTable tablaHabitacion = new PdfPTable(2);
            tablaHabitacion.setWidthPercentage(100);
            tablaHabitacion.setSpacingBefore(10f);
            tablaHabitacion.setSpacingAfter(10f);

            addTableCell(tablaHabitacion, "Número de Habitación:", reserva.getDetalleReserva().getHabitacion().getNroHab());
            addTableCell(tablaHabitacion, "Tipo de Habitación:", reserva.getDetalleReserva().getHabitacion().getTipoHab().getNombreTipoHab());
            addTableCell(tablaHabitacion, "Descripción Cama:", reserva.getDetalleReserva().getHabitacion().getDescripcionCama());
            addTableCell(tablaHabitacion, "Descripción Desayuno:", reserva.getDetalleReserva().getHabitacion().getDescripcionDesayuno());
            addTableCell(tablaHabitacion, "Descripción Ducha:", reserva.getDetalleReserva().getHabitacion().getDescripcionDucha());
            addTableCell(tablaHabitacion, "Descripción Personas:", reserva.getDetalleReserva().getHabitacion().getDescripcionPersonas());

            // Añadir tabla de habitación al documento
            documento.add(tablaHabitacion);
        }
        
            
        // Información de pagos
        PdfPTable tablaPagos = new PdfPTable(2);
        tablaPagos.setWidthPercentage(100);
        tablaPagos.setSpacingBefore(10f);
        tablaPagos.setSpacingAfter(10f);

        addTableCell(tablaPagos, "Pago Bruto:", reserva.getPagoBruto());
        addTableCell(tablaPagos, "Pago Adicional:", reserva.getPagoAdicion());
        addTableCell(tablaPagos, "Pago Total:", reserva.getPagoTotal());

        // Añadir tabla de pagos al documento
        documento.add(tablaPagos);

        // Cerrar documento
        documento.close();

        return new ByteArrayInputStream(stream.toByteArray());
    }

    // Método auxiliar para agregar celdas a la tabla
    private void addTableCell(PdfPTable table, String header, Object value) {
        PdfPCell cellHeader = new PdfPCell(new Phrase(header));
        cellHeader.setBackgroundColor(BaseColor.LIGHT_GRAY);
        cellHeader.setPadding(5);
        table.addCell(cellHeader);

        PdfPCell cellValue = new PdfPCell(new Phrase(String.valueOf(value)));
        cellValue.setPadding(5);
        table.addCell(cellValue);
    }

}
