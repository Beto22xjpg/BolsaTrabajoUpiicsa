-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-12-2025 a las 04:21:41
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bolsa_trabajo`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('estudiante','publicador','validador','administrador') NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `correo`, `password`, `rol`, `activo`, `fecha_registro`) VALUES
(1, 'Administrador', 'admin@alumno.ipn.mx', '123456', 'administrador', 1, '2025-12-02 21:04:05'),
(3, 'Publicador', 'publicador@alumno.ipn.mx', '123', 'publicador', 1, '2025-12-04 21:34:17'),
(4, 'Validador', 'validador@alumno.ipn.mx', '12345', 'validador', 1, '2025-12-04 21:35:24'),
(11, 'Estudiante', 'estudiante@alumno.ipn.mx', '12345', 'estudiante', 1, '2025-12-07 21:43:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacantes`
--

CREATE TABLE `vacantes` (
  `id` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `empresa` varchar(200) NOT NULL,
  `descripcion` text NOT NULL,
  `ubicacion` varchar(200) NOT NULL,
  `salario` varchar(50) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `modalidad` varchar(100) DEFAULT NULL,
  `horario` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `contacto_email` varchar(150) DEFAULT NULL,
  `contacto_tel` varchar(50) DEFAULT NULL,
  `contacto_web` varchar(255) DEFAULT NULL,
  `fecha_publicacion` datetime DEFAULT current_timestamp(),
  `id_publicador` int(11) NOT NULL,
  `estado` enum('pendiente','aprobada','rechazada') DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vacantes`
--

INSERT INTO `vacantes` (`id`, `titulo`, `empresa`, `descripcion`, `ubicacion`, `salario`, `categoria`, `modalidad`, `horario`, `tipo`, `direccion`, `contacto_email`, `contacto_tel`, `contacto_web`, `fecha_publicacion`, `id_publicador`, `estado`) VALUES
(11, 'Becario/a Sistemas Computacionales', 'Linde Mexico', 'Actividades: \nDesarrollo de aplicaciones \nMapeo de procesos \nSoporte y Mantenimiento', 'Ciudad de México, Azcapotzalco', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-07 16:24:27', 3, 'aprobada'),
(12, 'Becario DB', 'Kio tech', 'Desarrollo de bases de datos en proyecto', 'Cuajimalpa, santa fe', '0', 'Administración', 'Presencial', 'Tiempo completo', 'Proyecto', 'Cuajimalpa, santa fe', '', '', '', '2025-12-07 18:05:10', 3, 'aprobada'),
(13, 'Desarrollador FullStack', 'Google', 'Programación de front y back', 'CDMX, condesa', '0', 'Tecnología', 'Remota', 'Tiempo completo', 'Empleo', 'CDMX, condesa', 'Google@mx.com', '555788990098', 'google.com.mx', '2025-12-07 18:32:02', 3, 'aprobada'),
(14, 'Consultor ciberseguridad', 'Amazon', 'Ayuda a consultor de ciberseguridad', 'CDMX, santa fe edificio A', '0', 'Tecnología', 'Remota', 'Medio tiempo', 'Proyecto', 'CDMX, santa fe edificio A', 'Amazon@mexico.com', '55764356789', 'Amazon.com.mx', '2025-12-07 19:25:09', 3, 'aprobada'),
(15, 'Soporte', 'upiicsab', 'Ayuda en soporte', 'Iztacalco', '0', 'Administración', 'Presencial', 'Medio tiempo', 'Prácticas', 'Iztacalco', 'upiicsa@mx.com', '4456787543', 'upiicsa. com', '2025-12-07 19:29:01', 3, 'rechazada'),
(16, 'Becario de informática', 'ANCABE', 'Forma parte del programa de becarios que ANCABE administra para una empresa líder en su ramo al sur de la CDMX', 'Av Renato leduc 321, Toriello Guerra, Tlalpan CDMX, 14050', '0', 'Tecnología', 'Híbrida', 'Medio tiempo', 'Prácticas', 'Av Renato leduc 321, Toriello Guerra, Tlalpan CDMX, 14050', 'contacto@ancabe.org', '5586630328', 'ancabe.org', '2025-12-08 15:50:29', 3, 'aprobada'),
(17, 'especialista de ciberseguridad', 'totalplay', 'Mantener y gestionar control de accesos', 'cdmx', '0', 'Tecnología', 'Presencial', 'Tiempo completo', 'Empleo', 'cdmx', 'Totalplay@contacto.com', '5573836292', 'Totalplay.com', '2025-12-09 12:22:17', 3, 'rechazada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacantes_rechazos`
--

CREATE TABLE `vacantes_rechazos` (
  `id` int(11) NOT NULL,
  `id_vacante` int(11) NOT NULL,
  `motivo` text NOT NULL,
  `id_validador` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vacantes_rechazos`
--

INSERT INTO `vacantes_rechazos` (`id`, `id_vacante`, `motivo`, `id_validador`, `fecha`) VALUES
(6, 15, 'No cumple con la descripción', 4, '2025-12-07 19:29:47'),
(7, 17, 'Requisitos insuficientes', 4, '2025-12-09 12:25:05');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `vacantes`
--
ALTER TABLE `vacantes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_publicador` (`id_publicador`);

--
-- Indices de la tabla `vacantes_rechazos`
--
ALTER TABLE `vacantes_rechazos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vacante` (`id_vacante`),
  ADD KEY `id_validador` (`id_validador`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `vacantes`
--
ALTER TABLE `vacantes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `vacantes_rechazos`
--
ALTER TABLE `vacantes_rechazos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `vacantes`
--
ALTER TABLE `vacantes`
  ADD CONSTRAINT `vacantes_ibfk_1` FOREIGN KEY (`id_publicador`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `vacantes_rechazos`
--
ALTER TABLE `vacantes_rechazos`
  ADD CONSTRAINT `vacantes_rechazos_ibfk_1` FOREIGN KEY (`id_vacante`) REFERENCES `vacantes` (`id`),
  ADD CONSTRAINT `vacantes_rechazos_ibfk_2` FOREIGN KEY (`id_validador`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
