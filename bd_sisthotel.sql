-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-11-2024 a las 14:18:18
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_sisthotel`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consultar_disponibilidad_habitacion` (IN `_nIdSede` INT, IN `_nFechaEntrada` DATE, IN `_nHora` TIME, IN `_nIdTipoHab` INT)   BEGIN
   -- Define la fecha y hora de entrada
   DECLARE _nFechaHoraEntrada DATETIME;
   DECLARE _nFechaHoraSalida DATETIME;
   
   SET _nFechaHoraEntrada = CONCAT(_nFechaEntrada, ' ', _nHora);
   
   SET _nFechaHoraSalida = DATE_ADD(_nFechaHoraEntrada, INTERVAL 12 HOUR);

   SELECT h.*, t.*
   FROM Habitacion h
   INNER JOIN tipo_habitacion t ON t.id_tipo_hab = h.id_tipo_hab
   WHERE h.id_tipo_hab = _nIdTipoHab
     AND h.id_sede = _nIdSede
     AND NOT EXISTS (
         SELECT 1
         FROM reserva r
         INNER JOIN detalle_reserva dr ON r.id_reserva = dr.id_reserva
         WHERE dr.id_habitacion = h.id_habitacion
           AND r.id_sede = h.id_sede
           AND (
               -- Verifica si las fechas de la nueva reserva chocan con una existente
               _nFechaHoraEntrada BETWEEN CONCAT(r.fecha_reserva, ' ', r.hora_reserva) 
                                    AND DATE_ADD(CONCAT(r.fecha_reserva, ' ', r.hora_reserva), INTERVAL 12 HOUR)
               OR
               _nFechaHoraSalida BETWEEN CONCAT(r.fecha_reserva, ' ', r.hora_reserva) 
                                    AND DATE_ADD(CONCAT(r.fecha_reserva, ' ', r.hora_reserva), INTERVAL 12 HOUR)
               OR
               CONCAT(r.fecha_reserva, ' ', r.hora_reserva) BETWEEN _nFechaHoraEntrada AND _nFechaHoraSalida
           )
     );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_cliente` (IN `p_correo` VARCHAR(100), IN `p_password` VARCHAR(200), IN `p_id_pais` INT, IN `p_id_tipo_doc` INT, IN `p_nombre_completo` VARCHAR(120), IN `p_nro_celular` VARCHAR(15), IN `p_nro_documento` VARCHAR(20), IN `p_genero` CHAR(1))   BEGIN
    DECLARE v_usuario_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @p2 = MESSAGE_TEXT;
        ROLLBACK;
        SELECT 0 AS 'result', @p2 AS 'msg';
    END;

    START TRANSACTION;
    
    INSERT INTO usuario(id_rol, correo, password, fecha_registro) 
    VALUES(2, p_correo, p_password, NOW());
    
    SET v_usuario_id = LAST_INSERT_ID();
    
    INSERT INTO cliente(id_usuario, id_pais, id_tipo_doc, nombre_completo, nro_celular, nro_documento, genero) 
    VALUES(v_usuario_id, p_id_pais, p_id_tipo_doc, p_nombre_completo, p_nro_celular, p_nro_documento, p_genero);

    SELECT ROW_COUNT() AS 'result', 'OK' AS 'msg';
    
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_libro_archivos` (IN `p_nombre_archivo` TEXT, IN `p_nombre_original` TEXT, IN `p_tipo_archivo` VARCHAR(100), IN `p_id_libro_reclamacion` INT)   BEGIN
    DECLARE v_id_archivo INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @p2 = MESSAGE_TEXT;
        ROLLBACK;
        SELECT 0 AS 'result', @p2 AS 'msg';
    END;

    START TRANSACTION;
    
    INSERT INTO Archivo_Adjunto(nombre_archivo,nombre_original,tipo_archivo) 
    VALUES(p_nombre_archivo,p_nombre_original,p_tipo_archivo);
    
    SET v_id_archivo = LAST_INSERT_ID();
    
    INSERT INTO Archivo_Libro(id_archivo,id_libro_reclamacion ) 
    VALUES(v_id_archivo, p_id_libro_reclamacion);
   
    SELECT ROW_COUNT() AS 'result', 'OK' AS 'msg';
    
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_porcentajeCalifiacion` ()   BEGIN
    WITH Calificaciones AS (
		SELECT
			nro_calificacion,
			COUNT(*) AS cantidad
		FROM
			Comentario
		GROUP BY
			nro_calificacion
	),
	Totales AS (
		SELECT
			SUM(cantidad) AS total_comentarios
		FROM
			Calificaciones
	),
	TodasCalificaciones AS (
		SELECT 1 AS nro_calificacion UNION ALL
		SELECT 2 UNION ALL
		SELECT 3 UNION ALL
		SELECT 4 UNION ALL
		SELECT 5
	)
	SELECT
		t.nro_calificacion AS nro,
		COALESCE(ROUND((c.cantidad * 100.0 / tot.total_comentarios), 2), 0) AS porcentaje
	FROM
		TodasCalificaciones t
	LEFT JOIN
		Calificaciones c ON t.nro_calificacion = c.nro_calificacion
	CROSS JOIN
		Totales tot
	ORDER BY
		t.nro_calificacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (`_correo` VARCHAR(100), `_password` VARCHAR(100))   BEGIN
      WITH RECURSIVE t AS (
	   SELECT u.id_rol, u.id_usuario , c.id_cliente as 'id', correo, password , nombre_completo , genero, foto
	   FROM Usuario u INNER JOIN Cliente c ON c.id_usuario = u.id_usuario
	   UNION ALL
	   
	   SELECT u.id_rol, u.id_usuario , e.id_empleado as 'id', correo, password , nombre_completo , genero, foto
	   FROM Usuario u INNER JOIN Empleado e ON e.id_usuario = u.id_usuario
	)
	SELECT r.id_rol , r.nombre_rol, t.id, t.id_usuario , t.correo , t.nombre_completo , t.genero, t.foto , t.password
	FROM t 
	INNER JOIN Rol r
	ON r.id_rol = t.id_rol
    WHERE correo = _correo AND password = _password;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_reserva` (IN `_pIdSede` INT, IN `_pIdCliente` INT, IN `_pNombreReservante` VARCHAR(150), IN `_pCorreo` VARCHAR(150), IN `_pNumeroDocumento` VARCHAR(20), IN `_proCelular` VARCHAR(15), IN `_pFechaReserva` DATE, IN `_pHoraReserva` TIME, IN `_pPagoBruto` DECIMAL(8,2), IN `_pPagoAdicion` DECIMAL(8,2), IN `_pIdHabitacion` INT, IN `_pIdServicio` INT, IN `_pCantAdultos` INT, IN `_pCantNinios` INT)   BEGIN
    DECLARE v_mensaje VARCHAR(255);
    DECLARE v_id_reserva INT;
    DECLARE v_servicio INT;
    DECLARE v_fecha_max DATETIME;
   
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @p2 = MESSAGE_TEXT; 
        ROLLBACK;
        SELECT 0 AS 'result', @p2 AS 'msg'; 
    END;

    START TRANSACTION;
    
	IF _pIdServicio = 0 THEN
		SET v_servicio = NULL;
	ELSE
		SET v_servicio = _pIdServicio;
    END IF;
    
	SET v_fecha_max = DATE_ADD(CONCAT(_pFechaReserva, ' ', _pHoraReserva), INTERVAL 12 HOUR);
    
    INSERT INTO Reserva (
        id_sede, 
        id_cliente, 
        nombre_reservante, 
        correo, 
        nro_documento, 
        nro_celular, 
        fecha_reserva, 
        hora_reserva, 
        pago_bruto, 
        pago_adicion,
        pago_total,
        fecha_maxima_salida
    )
    VALUES (
        _pIdSede, 
        _pIdCliente, 
        _pNombreReservante, 
        _pCorreo, 
        _pNumeroDocumento, 
        _proCelular, 
        _pFechaReserva, 
        _pHoraReserva, 
        _pPagoBruto, 
        _pPagoAdicion,
        (_pPagoBruto + _pPagoAdicion),
        v_fecha_max
    );

    SET v_id_reserva = LAST_INSERT_ID();

    INSERT INTO Detalle_Reserva (
        id_reserva, 
        id_habitacion, 
        id_servicio, 
        cant_adultos, 
        cant_niños, 
        costo_reserva, 
        costo_servicio
    )
    VALUES (
        v_id_reserva, 
        _pIdHabitacion, 
        v_servicio, 
        _pCantAdultos, 
        _pCantNinios, 
        _pPagoBruto, 
        _pPagoAdicion
    );

    COMMIT;
    SELECT v_id_reserva AS 'result', 'OK' AS 'msg';
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `format_email` (`name` TEXT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE formatted_name TEXT;
    
    -- Reemplazar caracteres acentuados por sus equivalentes sin acento
    SET formatted_name = REPLACE(name, 'á', 'a');
    SET formatted_name = REPLACE(formatted_name, 'é', 'e');
    SET formatted_name = REPLACE(formatted_name, 'í', 'i');
    SET formatted_name = REPLACE(formatted_name, 'ó', 'o');
    SET formatted_name = REPLACE(formatted_name, 'ú', 'u');
    SET formatted_name = REPLACE(formatted_name, 'Á', 'A');
    SET formatted_name = REPLACE(formatted_name, 'É', 'E');
    SET formatted_name = REPLACE(formatted_name, 'Í', 'I');
    SET formatted_name = REPLACE(formatted_name, 'Ó', 'O');
    SET formatted_name = REPLACE(formatted_name, 'Ú', 'U');
    
    -- Reemplazar espacios por puntos
    SET formatted_name = REPLACE(formatted_name, ' ', '.');
    
    -- Convertir a minúsculas
    SET formatted_name = LOWER(formatted_name);
    
    -- Concatenar con el dominio
    RETURN CONCAT(formatted_name, '@gmail.com');
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivo_adjunto`
--

CREATE TABLE `archivo_adjunto` (
  `id_archivo` int(11) NOT NULL,
  `nombre_archivo` text DEFAULT NULL,
  `nombre_original` text DEFAULT NULL,
  `tipo_archivo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivo_libro`
--

CREATE TABLE `archivo_libro` (
  `id_archivo_libro` int(11) NOT NULL,
  `id_archivo` int(11) DEFAULT NULL,
  `id_libro_reclamacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `id_pais` int(11) DEFAULT NULL,
  `id_tipo_doc` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `nombre_completo` varchar(120) DEFAULT NULL,
  `nro_celular` varchar(15) DEFAULT NULL,
  `nro_documento` varchar(20) DEFAULT NULL,
  `genero` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id_cliente`, `id_pais`, `id_tipo_doc`, `id_usuario`, `nombre_completo`, `nro_celular`, `nro_documento`, `genero`) VALUES
(1, 89, 1, 1, 'Juan Pérez', '912345678', '12345678', 'M'),
(2, 89, 1, 2, 'María García', '923456789', '23456789', 'F'),
(3, 89, 1, 3, 'Carlos Gómez', '934567890', '34567890', 'M'),
(4, 89, 1, 4, 'Ana Rodríguez', '945678901', '45678901', 'F'),
(5, 89, 1, 5, 'Luis Hernández', '956789012', '56789012', 'M'),
(6, 89, 1, 6, 'Isabel Martínez', '967890123', '67890123', 'F'),
(7, 89, 1, 7, 'Jorge Peralta', '978901234', '78901234', 'M'),
(8, 89, 1, 8, 'Laura Hernández', '989012345', '89012345', 'F'),
(9, 89, 1, 9, 'Alejandro Carbajal', '990123456', '90123456', 'M'),
(10, 89, 1, 10, 'Patricia López', '901234567', '01234567', 'F'),
(11, 89, 1, 11, 'Miguel León', '912345679', '12345679', 'M'),
(12, 89, 1, 12, 'Carmen Mendoza', '923456780', '23456780', 'F'),
(13, 89, 1, 13, 'Antonio Vázquez', '934567891', '34567891', 'M'),
(14, 89, 1, 14, 'Juana Paucar', '945678902', '45678902', 'F'),
(15, 89, 1, 15, 'Francisco García', '956789013', '56789013', 'M'),
(16, 89, 1, 16, 'Silvia Gomez', '967890124', '67890124', 'F'),
(17, 89, 1, 17, 'Ricardo Jiménez', '978901235', '78901235', 'M'),
(18, 89, 1, 18, 'Verónica Vásquez', '989012346', '89012346', 'F'),
(19, 89, 1, 19, 'Pedro Castro', '990123457', '90123457', 'M'),
(20, 89, 1, 20, 'Elena Servantes', '901234568', '01234568', 'F'),
(21, 89, 1, 21, 'David Mendoza', '912345680', '12345680', 'M'),
(22, 89, 1, 22, 'Nerea Álvarez', '923456781', '23456781', 'F'),
(23, 89, 1, 23, 'Óscar Salazar', '934567892', '34567892', 'M'),
(24, 89, 1, 24, 'Rosa Arias', '945678903', '45678903', 'F'),
(25, 89, 1, 25, 'Héctor Paredes', '956789014', '56789014', 'M'),
(26, 89, 1, 26, 'Raquel Fernández', '967890125', '67890125', 'F'),
(27, 89, 1, 27, 'Guillermo Huaman', '978901236', '78901236', 'M'),
(28, 89, 1, 28, 'Guillermo Mora', '989012347', '89012347', 'M'),
(29, 89, 1, 29, 'Hugo Cano', '990123458', '90123458', 'M'),
(30, 89, 1, 30, 'Marina Pinto', '901234569', '01234569', 'F'),
(31, 89, 1, 31, 'Esteban Alvarado', '912345681', '12345681', 'M'),
(32, 89, 1, 32, 'Aurora Sosa', '923456782', '23456782', 'F'),
(33, 89, 1, 33, 'Guillermo Fernández', '934567893', '34567893', 'M'),
(34, 89, 1, 34, 'Marta Sánchez', '945678904', '45678904', 'F'),
(35, 89, 1, 35, 'Luis Ramírez', '956789015', '56789015', 'M'),
(36, 89, 1, 36, 'Adriana Cordero', '967890126', '67890126', 'F'),
(37, 89, 1, 37, 'Ricardo Vargas', '978901237', '78901237', 'M'),
(38, 89, 1, 38, 'Lucía Gómez', '989012348', '89012348', 'F'),
(39, 89, 1, 39, 'José Ramírez', '990123459', '90123459', 'M'),
(40, 89, 1, 40, 'Carmen Fernández', '901234570', '01234570', 'F'),
(41, 89, 1, 41, 'Eduardo Morales', '912345682', '12345682', 'M'),
(42, 89, 1, 42, 'Beatriz Correa', '923456783', '23456783', 'F'),
(43, 89, 1, 43, 'Óscar Mendoza', '934567894', '34567894', 'M'),
(44, 89, 1, 44, 'Lucía Rodríguez', '945678905', '45678905', 'F'),
(45, 89, 1, 45, 'Javier González', '956789016', '56789016', 'M'),
(46, 89, 1, 46, 'Margarita Soto', '967890127', '67890127', 'F'),
(47, 89, 1, 47, 'Santiago Suárez', '978901238', '78901238', 'M'),
(48, 89, 1, 48, 'Laura Álvarez', '989012349', '89012349', 'F'),
(49, 89, 1, 49, 'Mario Ramírez', '990123460', '90123460', 'M'),
(50, 89, 1, 50, 'María Fernández', '901234571', '01234571', 'F'),
(51, 89, 1, 51, 'José Luis Fernández', '912345683', '12345683', 'M'),
(52, 89, 1, 52, 'Sofía Salazar', '923456784', '23456784', 'F'),
(53, 89, 1, 53, 'Felipe Castro', '934567895', '34567895', 'M'),
(54, 89, 1, 54, 'Aurora Morales', '945678906', '45678906', 'F'),
(55, 89, 1, 55, 'Óscar Díaz', '956789017', '56789017', 'M'),
(56, 89, 1, 56, 'Silvia Zambrano', '967890128', '67890128', 'F'),
(57, 89, 1, 57, 'Ricardo Aguilar', '978901239', '78901239', 'M'),
(58, 89, 1, 58, 'Marta Fernández', '989012350', '89012350', 'F'),
(59, 89, 1, 59, 'Javier Contreras', '990123461', '90123461', 'M'),
(60, 89, 1, 60, 'Patricia Hernández', '901234572', '01234572', 'F'),
(61, 89, 1, 61, 'Guillermo Morales', '912345684', '12345684', 'M'),
(62, 89, 1, 62, 'María Lopez', '923456785', '23456785', 'F'),
(63, 89, 1, 63, 'Alejandro Martínez', '934567896', '34567896', 'M'),
(64, 89, 1, 64, 'Elena López', '945678907', '45678907', 'F'),
(65, 89, 1, 65, 'Daniel Fernández', '956789018', '56789018', 'M'),
(66, 89, 1, 66, 'Silvia Carbajal', '967890129', '67890129', 'F'),
(67, 89, 1, 67, 'Ricardo Romero', '978901240', '78901240', 'M'),
(68, 89, 1, 68, 'Rosa Caceres', '989012351', '89012351', 'F'),
(69, 89, 1, 69, 'Eduardo Hernández', '990123462', '90123462', 'M'),
(70, 89, 1, 70, 'Marta Pérez', '901234573', '01234573', 'F'),
(71, 89, 1, 71, 'Santiago Fernández', '912345685', '12345685', 'M'),
(72, 89, 1, 72, 'Beatriz Díaz', '923456786', '23456786', 'F'),
(73, 89, 1, 73, 'Jorge Gómez', '934567897', '34567897', 'M'),
(74, 89, 1, 74, 'Raquel Castro', '945678908', '45678908', 'F'),
(75, 89, 1, 75, 'Guillermo López', '956789019', '56789019', 'M'),
(76, 98, 2, 80, 'Carlos Jimenez', '9654123659', '41236523', 'M');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentario`
--

CREATE TABLE `comentario` (
  `id_comentario` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_comentario` datetime DEFAULT NULL,
  `servicio` varchar(100) DEFAULT NULL,
  `habitacion` varchar(100) DEFAULT NULL,
  `ambiente` varchar(100) DEFAULT NULL,
  `nro_calificacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_reserva`
--

CREATE TABLE `detalle_reserva` (
  `id_detalle_reserva` int(11) NOT NULL,
  `id_reserva` int(11) DEFAULT NULL,
  `id_habitacion` int(11) DEFAULT NULL,
  `id_servicio` int(11) DEFAULT NULL,
  `cant_adultos` int(11) DEFAULT NULL,
  `cant_niños` int(11) DEFAULT NULL,
  `costo_reserva` decimal(8,2) DEFAULT NULL,
  `costo_servicio` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_reserva`
--

INSERT INTO `detalle_reserva` (`id_detalle_reserva`, `id_reserva`, `id_habitacion`, `id_servicio`, `cant_adultos`, `cant_niños`, `costo_reserva`, `costo_servicio`) VALUES
(15, 15, 1, 1, 1, 0, 50.00, 50.00),
(16, 16, 15, 2, 2, 1, 50.00, 80.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `id_empleado` int(11) NOT NULL,
  `id_pais` int(11) DEFAULT NULL,
  `id_tipo_doc` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `nombre_completo` varchar(120) DEFAULT NULL,
  `nro_celular` varchar(15) DEFAULT NULL,
  `nro_documento` varchar(20) DEFAULT NULL,
  `genero` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`id_empleado`, `id_pais`, `id_tipo_doc`, `id_usuario`, `nombre_completo`, `nro_celular`, `nro_documento`, `genero`) VALUES
(1, 89, 1, 76, 'Carlos Gutierrez', '963200156', '42100156', 'M'),
(2, 89, 1, 77, 'Mario Paucar', '998160156', '10236514', 'M');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitacion`
--

CREATE TABLE `habitacion` (
  `id_habitacion` int(11) NOT NULL,
  `id_tipo_hab` int(11) DEFAULT NULL,
  `nro_habitacion` varchar(10) DEFAULT NULL,
  `descripcion_ducha` varchar(200) DEFAULT NULL,
  `descripcion_cama` varchar(200) DEFAULT NULL,
  `descripcion_personas` varchar(200) DEFAULT NULL,
  `descripcion_desayuno` varchar(200) DEFAULT NULL,
  `imagen` text DEFAULT NULL,
  `id_sede` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `habitacion`
--

INSERT INTO `habitacion` (`id_habitacion`, `id_tipo_hab`, `nro_habitacion`, `descripcion_ducha`, `descripcion_cama`, `descripcion_personas`, `descripcion_desayuno`, `imagen`, `id_sede`) VALUES
(1, 1, '101', 'Ducha de agua fría', '1 cama de una plasa', '1 Adulto', 'Desayuno Continental', 'habitacion_101.png', 1),
(2, 2, '202', 'Ducha temperada', '1 camas de 2 plasas', '2 Adultos', 'Desayuno Buffet', 'habitacion_202.png', 1),
(3, 3, '303', '2 Duchas temperadas', '2 camas de 2 plasas', '3 Adultos y 1 niño', 'Desayuno Gourmet', 'habitacion_303.png', 1),
(4, 4, '404', '1 Jacuzzi', '1 cama de 2 plasas', '2 Adultos', 'Desayuno incluido', 'habitacion_404.png', 1),
(5, 1, '105', 'Ducha de agua fría', '1 cama de una plaza', '1 Adulto', 'Desayuno Continental', 'habitacion_101.png', 1),
(6, 1, '106', 'Ducha de agua fría', '1 cama de una plaza', '1 Adulto', 'Desayuno Continental', 'habitacion_101.png', 1),
(7, 2, '201', 'Ducha temperada', '1 cama de dos plazas', '2 Adultos', 'Desayuno Buffet', 'habitacion_202.png', 1),
(8, 2, '202', 'Ducha temperada', '1 cama de dos plazas', '2 Adultos', 'Desayuno Buffet', 'habitacion_202.png', 1),
(9, 3, '301', 'Ducha temperada', '2 camas de dos plazas', '3 Adultos', 'Desayuno Gourmet', 'habitacion_303.png', 1),
(10, 3, '302', 'Ducha temperada', '2 camas de dos plazas', '3 Adultos', 'Desayuno Gourmet', 'habitacion_303.png', 1),
(11, 4, '401', 'Jacuzzi', '1 cama de dos plazas', '2 Adultos', 'Desayuno incluido', 'habitacion_404.png', 1),
(12, 4, '402', 'Jacuzzi', '1 cama de dos plazas', '2 Adultos', 'Desayuno incluido', 'habitacion_404.png', 1),
(13, 1, '107', 'Ducha de agua fría', '1 cama de una plaza', '1 Adulto', 'Desayuno Continental', 'habitacion_101.png', 1),
(14, 2, '203', 'Ducha temperada', '1 cama de dos plazas', '2 Adultos', 'Desayuno Buffet', 'habitacion_202.png', 1),
(15, 1, '108', 'Ducha de agua fría', '1 cama de una plaza', '1 Adulto', 'Desayuno Continental', 'habitacion_101.png', 2),
(16, 2, '204', 'Ducha temperada', '1 cama de dos plazas', '2 Adultos', 'Desayuno Buffet', 'habitacion_202.png', 2),
(17, 2, '205', 'Ducha temperada', '1 cama de dos plazas', '2 Adultos', 'Desayuno Buffet', 'habitacion_202.png', 2),
(18, 3, '304', 'Ducha temperada', '2 camas de dos plazas', '3 Adultos', 'Desayuno Gourmet', 'habitacion_303.png', 2),
(19, 3, '305', 'Ducha temperada', '2 camas de dos plazas', '3 Adultos', 'Desayuno Gourmet', 'habitacion_303.png', 2),
(20, 4, '403', 'Jacuzzi', '1 cama de dos plazas', '2 Adultos', 'Desayuno incluido', 'habitacion_404.png', 2),
(21, 4, '404', 'Jacuzzi', '1 cama de dos plazas', '2 Adultos', 'Desayuno incluido', 'image.png', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro_reclamacion`
--

CREATE TABLE `libro_reclamacion` (
  `id_libro_reclamacion` int(11) NOT NULL,
  `id_sede` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nro_celular` varchar(15) DEFAULT NULL,
  `nro_documento` varchar(20) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `mensaje` text DEFAULT NULL,
  `fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pais`
--

CREATE TABLE `pais` (
  `id_pais` int(11) NOT NULL,
  `nombre_pais` varchar(70) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pais`
--

INSERT INTO `pais` (`id_pais`, `nombre_pais`) VALUES
(1, 'Australia'),
(2, 'Austria'),
(3, 'Azerbaiyán'),
(4, 'Anguilla'),
(5, 'Argentina'),
(6, 'Armenia'),
(7, 'Bielorrusia'),
(8, 'Belice'),
(9, 'Bélgica'),
(10, 'Bermudas'),
(11, 'Bulgaria'),
(12, 'Brasil'),
(13, 'Reino Unido'),
(14, 'Hungría'),
(15, 'Vietnam'),
(16, 'Haiti'),
(17, 'Guadalupe'),
(18, 'Alemania'),
(19, 'Países Bajos, Holanda'),
(20, 'Grecia'),
(21, 'Georgia'),
(22, 'Dinamarca'),
(23, 'Egipto'),
(24, 'Israel'),
(25, 'India'),
(26, 'Irán'),
(27, 'Irlanda'),
(28, 'España'),
(29, 'Italia'),
(30, 'Kazajstán'),
(31, 'Camerún'),
(32, 'Canadá'),
(33, 'Chipre'),
(34, 'Kirguistán'),
(35, 'China'),
(36, 'Costa Rica'),
(37, 'Kuwait'),
(38, 'Letonia'),
(39, 'Libia'),
(40, 'Lituania'),
(41, 'Luxemburgo'),
(42, 'México'),
(43, 'Moldavia'),
(44, 'Mónaco'),
(45, 'Nueva Zelanda'),
(46, 'Noruega'),
(47, 'Polonia'),
(48, 'Portugal'),
(49, 'Reunión'),
(50, 'Rusia'),
(51, 'El Salvador'),
(52, 'Eslovaquia'),
(53, 'Eslovenia'),
(54, 'Surinam'),
(55, 'Estados Unidos'),
(56, 'Tadjikistan'),
(57, 'Turkmenistan'),
(58, 'Islas Turcas y Caicos'),
(59, 'Turquía'),
(60, 'Uganda'),
(61, 'Uzbekistán'),
(62, 'Ucrania'),
(63, 'Finlandia'),
(64, 'Francia'),
(65, 'República Checa'),
(66, 'Suiza'),
(67, 'Suecia'),
(68, 'Estonia'),
(69, 'Corea del Sur'),
(70, 'Japón'),
(71, 'Croacia'),
(72, 'Rumanía'),
(73, 'Hong Kong'),
(74, 'Indonesia'),
(75, 'Jordania'),
(76, 'Malasia'),
(77, 'Singapur'),
(78, 'Taiwan'),
(79, 'Bosnia y Herzegovina'),
(80, 'Bahamas'),
(81, 'Chile'),
(82, 'Colombia'),
(83, 'Islandia'),
(84, 'Corea del Norte'),
(85, 'Macedonia'),
(86, 'Malta'),
(87, 'Pakistán'),
(88, 'Papúa-Nueva Guinea'),
(89, 'Perú'),
(90, 'Filipinas'),
(91, 'Arabia Saudita'),
(92, 'Tailandia'),
(93, 'Emiratos árabes Unidos'),
(94, 'Groenlandia'),
(95, 'Venezuela'),
(96, 'Zimbabwe'),
(97, 'Kenia'),
(98, 'Algeria'),
(99, 'Líbano'),
(100, 'Botsuana'),
(101, 'Tanzania'),
(102, 'Namibia'),
(103, 'Ecuador'),
(104, 'Marruecos'),
(105, 'Ghana'),
(106, 'Siria'),
(107, 'Nepal'),
(108, 'Mauritania'),
(109, 'Seychelles'),
(110, 'Paraguay'),
(111, 'Uruguay'),
(112, 'Congo (Brazzaville)'),
(113, 'Cuba'),
(114, 'Albania'),
(115, 'Nigeria'),
(116, 'Zambia'),
(117, 'Mozambique'),
(119, 'Angola'),
(120, 'Sri Lanka'),
(121, 'Etiopía'),
(122, 'Túnez'),
(123, 'Bolivia'),
(124, 'Panamá'),
(125, 'Malawi'),
(126, 'Liechtenstein'),
(127, 'Bahrein'),
(128, 'Barbados'),
(130, 'Chad'),
(131, 'Man, Isla de'),
(132, 'Jamaica'),
(133, 'Malí'),
(134, 'Madagascar'),
(135, 'Senegal'),
(136, 'Togo'),
(137, 'Honduras'),
(138, 'República Dominicana'),
(139, 'Mongolia'),
(140, 'Irak'),
(141, 'Sudáfrica'),
(142, 'Aruba'),
(143, 'Gibraltar'),
(144, 'Afganistán'),
(145, 'Andorra'),
(147, 'Antigua y Barbuda'),
(149, 'Bangladesh'),
(151, 'Benín'),
(152, 'Bután'),
(154, 'Islas Virgenes Británicas'),
(155, 'Brunéi'),
(156, 'Burkina Faso'),
(157, 'Burundi'),
(158, 'Camboya'),
(159, 'Cabo Verde'),
(164, 'Comores'),
(165, 'Congo (Kinshasa)'),
(166, 'Cook, Islas'),
(168, 'Costa de Marfil'),
(169, 'Djibouti, Yibuti'),
(171, 'Timor Oriental'),
(172, 'Guinea Ecuatorial'),
(173, 'Eritrea'),
(175, 'Feroe, Islas'),
(176, 'Fiyi'),
(178, 'Polinesia Francesa'),
(180, 'Gabón'),
(181, 'Gambia'),
(184, 'Granada'),
(185, 'Guatemala'),
(186, 'Guernsey'),
(187, 'Guinea'),
(188, 'Guinea-Bissau'),
(189, 'Guyana'),
(193, 'Jersey'),
(195, 'Kiribati'),
(196, 'Laos'),
(197, 'Lesotho'),
(198, 'Liberia'),
(200, 'Maldivas'),
(201, 'Martinica'),
(202, 'Mauricio'),
(205, 'Myanmar'),
(206, 'Nauru'),
(207, 'Antillas Holandesas'),
(208, 'Nueva Caledonia'),
(209, 'Nicaragua'),
(210, 'Níger'),
(212, 'Norfolk Island'),
(213, 'Omán'),
(215, 'Isla Pitcairn'),
(216, 'Qatar'),
(217, 'Ruanda'),
(218, 'Santa Elena'),
(219, 'San Cristobal y Nevis'),
(220, 'Santa Lucía'),
(221, 'San Pedro y Miquelón'),
(222, 'San Vincente y Granadinas'),
(223, 'Samoa'),
(224, 'San Marino'),
(225, 'San Tomé y Príncipe'),
(226, 'Serbia y Montenegro'),
(227, 'Sierra Leona'),
(228, 'Islas Salomón'),
(229, 'Somalia'),
(232, 'Sudán'),
(234, 'Swazilandia'),
(235, 'Tokelau'),
(236, 'Tonga'),
(237, 'Trinidad y Tobago'),
(239, 'Tuvalu'),
(240, 'Vanuatu'),
(241, 'Wallis y Futuna'),
(242, 'Sáhara Occidental'),
(243, 'Yemen'),
(246, 'Puerto Rico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promocion`
--

CREATE TABLE `promocion` (
  `id_promocion` int(11) NOT NULL,
  `descripcion_promo` text DEFAULT NULL,
  `tipo_operacion` varchar(100) DEFAULT NULL CHECK (`tipo_operacion` in ('PORCENTAJE','MONTO')),
  `valor_operacion` decimal(8,2) DEFAULT NULL,
  `cantidad_reservas` int(11) DEFAULT NULL,
  `fecha_inicio_ejecucion` date DEFAULT NULL,
  `fecha_fin_ejecucion` date DEFAULT NULL,
  `estado` int(11) DEFAULT NULL CHECK (`estado` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva`
--

CREATE TABLE `reserva` (
  `id_reserva` int(11) NOT NULL,
  `id_sede` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre_reservante` varchar(150) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `nro_documento` varchar(20) DEFAULT NULL,
  `nro_celular` varchar(15) DEFAULT NULL,
  `fecha_reserva` date DEFAULT NULL,
  `hora_reserva` time DEFAULT NULL,
  `fecha_salida` date DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `pago_bruto` decimal(8,2) DEFAULT NULL,
  `pago_adicion` decimal(8,2) DEFAULT NULL,
  `pago_total` decimal(8,2) DEFAULT NULL,
  `fecha_entrada` datetime DEFAULT NULL,
  `fecha_maxima_salida` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reserva`
--

INSERT INTO `reserva` (`id_reserva`, `id_sede`, `id_cliente`, `nombre_reservante`, `correo`, `nro_documento`, `nro_celular`, `fecha_reserva`, `hora_reserva`, `fecha_salida`, `hora_salida`, `pago_bruto`, `pago_adicion`, `pago_total`, `fecha_entrada`, `fecha_maxima_salida`) VALUES
(15, 1, 1, 'Juan Pérez', 'juan.perez@gmail.com', '12345678', '912345678', '2024-11-13', '08:22:00', '2024-11-13', '17:36:19', 50.00, 50.00, 100.00, '2024-11-13 07:26:05', '2024-11-13 20:22:00'),
(16, 2, 3, 'Carlos Gómez', 'carlos.gomez@gmail.com', '34567890', '934567890', '2024-11-13', '15:00:00', '2024-11-13', '17:55:55', 50.00, 80.00, 130.00, '2024-11-13 07:26:16', '2024-11-14 03:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Cliente'),
(3, 'Ventas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sede`
--

CREATE TABLE `sede` (
  `id_sede` int(11) NOT NULL,
  `nombre_sede` varchar(70) DEFAULT NULL,
  `coordenada_latitud` text DEFAULT NULL,
  `coordenada_longitud` text DEFAULT NULL,
  `ubicacion` text DEFAULT NULL,
  `departamento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sede`
--

INSERT INTO `sede` (`id_sede`, `nombre_sede`, `coordenada_latitud`, `coordenada_longitud`, `ubicacion`, `departamento`) VALUES
(1, 'HUANCAYO – TAMBO', '-12.0504912', '-75.2242268', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1159.4067511221663!2d-76.96592993118733!3d-12.196460298826842!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x9105b90060471d2f%3A0x3beefdc11d977338!2sGerald%20Quispe!5e0!3m2!1ses-419!2spe!4v1726548683311!5m2!1ses-419!2spe', 'HUANCAYO'),
(2, 'LA MERCED - CHANCHAMAYO', '-11.077975', '-75.328656', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3915.476621919309!2d-75.33094882576857!3d-11.077811489089855!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x9109733a533ad447%3A0xc9f937ae1074731e!2sLA%20MERCED%20CHANCHAMAYO!5e0!3m2!1ses!2sus!4v1726323791972!5m2!1ses!2sus', 'CHANCHAMAYO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `id_servicio` int(11) NOT NULL,
  `nombre_servicio` varchar(70) DEFAULT NULL,
  `costo` decimal(8,2) DEFAULT NULL,
  `imagen` text DEFAULT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicio`
--

INSERT INTO `servicio` (`id_servicio`, `nombre_servicio`, `costo`, `imagen`, `descripcion`) VALUES
(1, 'Piscina', 50.00, 'piscina.png', 'Nuestra piscina es el lugar perfecto para refrescarte después de un día de exploración o simplemente para desconectar y disfrutar del sol. Con agua cristalina y temperatura agradable durante todo el año, es ideal tanto para nadar como para disfrutar de un baño tranquilo. Los niños pueden disfrutar de una zona poco profunda, mientras que los adultos tienen a su disposición un área más profunda para nadar libremente. Por la noche, la iluminación suave crea un ambiente mágico, perfecto para una velada relajante bajo las estrellas.'),
(2, 'Campo', 80.00, 'campo.png', 'Disfruta de la emoción del deporte al aire libre en nuestro campo deportivo, un espacio diseñado para quienes buscan mantener un estilo de vida activo durante su estancia. Rodeado de un entorno natural impresionante, nuestro campo ofrece una superficie de césped bien cuidada, ideal para jugar fútbol, voleibol, y otras actividades recreativas. ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_documento`
--

CREATE TABLE `tipo_documento` (
  `id_tipo_doc` int(11) NOT NULL,
  `nombre_tipo_doc` varchar(70) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_documento`
--

INSERT INTO `tipo_documento` (`id_tipo_doc`, `nombre_tipo_doc`) VALUES
(1, 'DNI'),
(2, 'Carnet de Extranjeria'),
(3, 'Pasaporte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_habitacion`
--

CREATE TABLE `tipo_habitacion` (
  `id_tipo_hab` int(11) NOT NULL,
  `nombre_tipo_hab` varchar(70) DEFAULT NULL,
  `costo` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_habitacion`
--

INSERT INTO `tipo_habitacion` (`id_tipo_hab`, `nombre_tipo_hab`, `costo`) VALUES
(1, 'Cuarto individual', 50.00),
(2, 'Matrimonial', 100.00),
(3, 'Familiar', 80.00),
(4, 'VIP', 150.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `foto` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `id_rol`, `correo`, `password`, `fecha_registro`, `foto`) VALUES
(1, 2, 'juan.perez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(2, 2, 'maria.garcia@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(3, 2, 'carlos.gomez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(4, 2, 'ana.rodriguez@gmail.com', '123456', '2024-09-14 13:59:24', 'img_20241014091408_b7c75d23-3b42-4c73-b48f-c3387424da90.jpg'),
(5, 2, 'luis.hernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(6, 2, 'isabel.martinez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(7, 2, 'jorge.peralta@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(8, 2, 'laura.hernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(9, 2, 'alejandro.carbajal@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(10, 2, 'patricia.lopez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(11, 2, 'miguel.leon@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(12, 2, 'carmen.mendoza@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(13, 2, 'antonio.vazquez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(14, 2, 'juana.paucar@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(15, 2, 'francisco.garcia@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(16, 2, 'silvia.gomez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(17, 2, 'ricardo.jimenez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(18, 2, 'veronica.vasquez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(19, 2, 'pedro.castro@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(20, 2, 'elena.servantes@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(21, 2, 'david.mendoza@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(22, 2, 'nerea.alvarez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(23, 2, 'oscar.salazar@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(24, 2, 'rosa.arias@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(25, 2, 'hector.paredes@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(26, 2, 'raquel.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(27, 2, 'guillermo.huaman@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(28, 2, 'guillermo.mora@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(29, 2, 'hugo.cano@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(30, 2, 'marina.pinto@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(31, 2, 'esteban.alvarado@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(32, 2, 'aurora.sosa@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(33, 2, 'guillermo.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(34, 2, 'marta.sanchez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(35, 2, 'luis.ramirez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(36, 2, 'adriana.cordero@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(37, 2, 'ricardo.vargas@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(38, 2, 'lucia.gomez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(39, 2, 'jose.ramirez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(40, 2, 'carmen.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(41, 2, 'eduardo.morales@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(42, 2, 'beatriz.correa@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(43, 2, 'oscar.mendoza@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(44, 2, 'lucia.rodriguez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(45, 2, 'javier.gonzalez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(46, 2, 'margarita.soto@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(47, 2, 'santiago.suarez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(48, 2, 'laura.alvarez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(49, 2, 'mario.ramirez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(50, 2, 'maria.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(51, 2, 'jose.luis.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(52, 2, 'sofia.salazar@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(53, 2, 'felipe.castro@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(54, 2, 'aurora.morales@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(55, 2, 'oscar.diaz@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(56, 2, 'silvia.zambrano@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(57, 2, 'ricardo.aguilar@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(58, 2, 'marta.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(59, 2, 'javier.contreras@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(60, 2, 'patricia.hernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(61, 2, 'guillermo.morales@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(62, 2, 'maria.lopez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(63, 2, 'alejandro.martinez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(64, 2, 'elena.lopez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(65, 2, 'daniel.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(66, 2, 'silvia.carbajal@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(67, 2, 'ricardo.romero@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(68, 2, 'rosa.caceres@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(69, 2, 'eduardo.hernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(70, 2, 'marta.perez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(71, 2, 'santiago.fernandez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(72, 2, 'beatriz.diaz@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(73, 2, 'jorge.gomez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(74, 2, 'raquel.castro@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(75, 2, 'guillermo.lopez@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(76, 1, 'admin@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(77, 3, 'mario.paucar@gmail.com', '123456', '2024-09-14 13:59:24', NULL),
(80, 2, 'carlos.jimenez@gmail.com', '44656', '2024-10-13 16:37:31', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `archivo_adjunto`
--
ALTER TABLE `archivo_adjunto`
  ADD PRIMARY KEY (`id_archivo`);

--
-- Indices de la tabla `archivo_libro`
--
ALTER TABLE `archivo_libro`
  ADD PRIMARY KEY (`id_archivo_libro`),
  ADD KEY `id_archivo` (`id_archivo`),
  ADD KEY `id_libro_reclamacion` (`id_libro_reclamacion`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`),
  ADD KEY `id_pais` (`id_pais`),
  ADD KEY `id_tipo_doc` (`id_tipo_doc`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `comentario`
--
ALTER TABLE `comentario`
  ADD PRIMARY KEY (`id_comentario`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `detalle_reserva`
--
ALTER TABLE `detalle_reserva`
  ADD PRIMARY KEY (`id_detalle_reserva`),
  ADD KEY `id_habitacion` (`id_habitacion`),
  ADD KEY `id_reserva` (`id_reserva`),
  ADD KEY `id_servicio` (`id_servicio`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`id_empleado`),
  ADD KEY `id_pais` (`id_pais`),
  ADD KEY `id_tipo_doc` (`id_tipo_doc`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  ADD PRIMARY KEY (`id_habitacion`),
  ADD KEY `id_tipo_hab` (`id_tipo_hab`),
  ADD KEY `id_sede` (`id_sede`);

--
-- Indices de la tabla `libro_reclamacion`
--
ALTER TABLE `libro_reclamacion`
  ADD PRIMARY KEY (`id_libro_reclamacion`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_sede` (`id_sede`);

--
-- Indices de la tabla `pais`
--
ALTER TABLE `pais`
  ADD PRIMARY KEY (`id_pais`);

--
-- Indices de la tabla `promocion`
--
ALTER TABLE `promocion`
  ADD PRIMARY KEY (`id_promocion`);

--
-- Indices de la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `id_sede` (`id_sede`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indices de la tabla `sede`
--
ALTER TABLE `sede`
  ADD PRIMARY KEY (`id_sede`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  ADD PRIMARY KEY (`id_tipo_doc`);

--
-- Indices de la tabla `tipo_habitacion`
--
ALTER TABLE `tipo_habitacion`
  ADD PRIMARY KEY (`id_tipo_hab`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `id_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `archivo_adjunto`
--
ALTER TABLE `archivo_adjunto`
  MODIFY `id_archivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `archivo_libro`
--
ALTER TABLE `archivo_libro`
  MODIFY `id_archivo_libro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT de la tabla `comentario`
--
ALTER TABLE `comentario`
  MODIFY `id_comentario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_reserva`
--
ALTER TABLE `detalle_reserva`
  MODIFY `id_detalle_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  MODIFY `id_habitacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `libro_reclamacion`
--
ALTER TABLE `libro_reclamacion`
  MODIFY `id_libro_reclamacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `pais`
--
ALTER TABLE `pais`
  MODIFY `id_pais` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT de la tabla `promocion`
--
ALTER TABLE `promocion`
  MODIFY `id_promocion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reserva`
--
ALTER TABLE `reserva`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `sede`
--
ALTER TABLE `sede`
  MODIFY `id_sede` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  MODIFY `id_tipo_doc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_habitacion`
--
ALTER TABLE `tipo_habitacion`
  MODIFY `id_tipo_hab` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `archivo_libro`
--
ALTER TABLE `archivo_libro`
  ADD CONSTRAINT `archivo_libro_ibfk_1` FOREIGN KEY (`id_archivo`) REFERENCES `archivo_adjunto` (`id_archivo`),
  ADD CONSTRAINT `archivo_libro_ibfk_2` FOREIGN KEY (`id_libro_reclamacion`) REFERENCES `libro_reclamacion` (`id_libro_reclamacion`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_pais`) REFERENCES `pais` (`id_pais`),
  ADD CONSTRAINT `cliente_ibfk_2` FOREIGN KEY (`id_tipo_doc`) REFERENCES `tipo_documento` (`id_tipo_doc`),
  ADD CONSTRAINT `cliente_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `comentario`
--
ALTER TABLE `comentario`
  ADD CONSTRAINT `comentario_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `detalle_reserva`
--
ALTER TABLE `detalle_reserva`
  ADD CONSTRAINT `detalle_reserva_ibfk_1` FOREIGN KEY (`id_habitacion`) REFERENCES `habitacion` (`id_habitacion`),
  ADD CONSTRAINT `detalle_reserva_ibfk_2` FOREIGN KEY (`id_reserva`) REFERENCES `reserva` (`id_reserva`),
  ADD CONSTRAINT `detalle_reserva_ibfk_3` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`);

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`id_pais`) REFERENCES `pais` (`id_pais`),
  ADD CONSTRAINT `empleado_ibfk_2` FOREIGN KEY (`id_tipo_doc`) REFERENCES `tipo_documento` (`id_tipo_doc`),
  ADD CONSTRAINT `empleado_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `habitacion`
--
ALTER TABLE `habitacion`
  ADD CONSTRAINT `habitacion_ibfk_1` FOREIGN KEY (`id_tipo_hab`) REFERENCES `tipo_habitacion` (`id_tipo_hab`),
  ADD CONSTRAINT `habitacion_ibfk_2` FOREIGN KEY (`id_sede`) REFERENCES `sede` (`id_sede`);

--
-- Filtros para la tabla `libro_reclamacion`
--
ALTER TABLE `libro_reclamacion`
  ADD CONSTRAINT `libro_reclamacion_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `libro_reclamacion_ibfk_2` FOREIGN KEY (`id_sede`) REFERENCES `sede` (`id_sede`);

--
-- Filtros para la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`id_sede`) REFERENCES `sede` (`id_sede`),
  ADD CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
