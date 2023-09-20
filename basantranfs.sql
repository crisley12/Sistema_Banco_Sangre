-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-11-2022 a las 02:47:27
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `basantranfs`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DASHBOARD` ()   SELECT
	COUNT(*) as paciente,
	(SELECT COUNT(*) FROM
	medico) as medico,
	(SELECT COUNT(*) FROM
	usuario) as usuario
FROM
	paciente$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ELIMINAR_USUARIO` (IN `IDUSUARIO` INT)   UPDATE usuario SET
usu_estatus='ELIMINADO'
WHERE usu_id=IDUSUARIO$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INTENTO_USUARIO` (IN `USUARIO` VARCHAR(50))   BEGIN
DECLARE INTENTO INT;
SET @INTENTO:=(SELECT usu_intento FROM usuario WHERE usu_nombre=USUARIO);
IF @INTENTO = 2 THEN
	SELECT @INTENTO;
ELSE
	UPDATE usuario set
	usu_intento=@INTENTO+1
	WHERE usu_nombre=USUARIO;
		SELECT @INTENTO;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_AUDITORIA` ()   SELECT
	auditoria.audi_id, 
	auditoria.fecha, 
	auditoria.accion, 
	auditoria.usu_id,
	usu_nombre
FROM
	auditoria$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_CITA` ()   SELECT c.cita_id,c.cita_nroatencion,c.cita_feregistro,c.cita_estatus,p.paciente_id,concat_ws(' ',p.paciente_nombre,p.paciente_apepat,p.paciente_apemat) as paciente,c.medico_id,concat_ws(' ',m.medico_nombre,m.medico_apepart,m.medico_apemart) as medico, e.especialidad_id, e.especialidad_nombre, c.cita_descripcion 
FROM cita as c 
INNER JOIN paciente as p ON c.paciente_id=p.paciente_id
INNER JOIN medico as m on c.medico_id=m.medico_id
INNER JOIN especialidad as e ON e.especialidad_id=m.especialidad_id
WHERE c.cita_feregistro =CURDATE()
ORDER BY cita_id ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_CITAS_DIARIAS` ()   SELECT COUNT(*)
FROM cita as citas
WHERE citas.cita_feregistro=CURDATE()$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_ESPECIALIDAD` ()   SELECT * FROM especialidad WHERE especialidad_estatus='ACTIVO'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_COMBO_ROL` ()   SELECT
	rol.rol_id, 
	rol.rol_nombre
FROM
	rol$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_CONSULTA` (IN `FECHAINICIO` DATE, IN `FECHAFIN` DATE)   SELECT
	consulta.consulta_id, 
	consulta.consulta_descripcion, 
	consulta.consulta_diagnostico, 
	consulta.consulta_feregistro, 
	consulta.consulta_estatus, 
	cita.cita_nroatencion, 
	cita.cita_feregistro, 
	cita.medico_id, 
	cita.especialidad_id,
  cita.paciente_id,
	cita.cita_estatus, 
	cita.cita_descripcion, 
	cita.usu_id, 
	CONCAT_WS(' ',paciente.paciente_nombre,paciente.paciente_apepat,paciente.paciente_apemat) as paciente, 
paciente.paciente_nrodocumento, 
	CONCAT_WS(' ',medico.medico_nombre,medico.medico_apepart,medico.medico_apemart)as medico,
	especialidad.especialidad_nombre
FROM
	consulta
	INNER JOIN
	cita
	ON 
		consulta.cita_id = cita.cita_id
	INNER JOIN
	paciente
	ON 
		cita.paciente_id = paciente.paciente_id
	INNER JOIN
	medico
	ON 
		cita.medico_id = medico.medico_id
	INNER JOIN
	especialidad
	ON 
		cita.especialidad_id = especialidad.especialidad_id
		WHERE consulta.consulta_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_CONSULTA_HISTORIAL` ()   SELECT
	consulta.consulta_id, 
	consulta.consulta_descripcion, 
	consulta.consulta_diagnostico,
	paciente.paciente_nrodocumento,	
	CONCAT(' ',paciente.paciente_nombre,paciente.paciente_apepat,paciente.paciente_apemat) AS paciente, 
	historia.historia_id, 
	consulta.consulta_feregistro
FROM
	consulta
	INNER JOIN
	cita
	ON 
		consulta.cita_id = cita.cita_id
	INNER JOIN
	paciente
	ON 
		cita.paciente_id = paciente.paciente_id
	INNER JOIN
	historia
	ON 
		paciente.paciente_id = historia.paciente_id
		WHERE consulta.consulta_feregistro=CURDATE()$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_DOCTOR_COMBO` (IN `ID` INT)   SELECT `medico_id`,concat_ws(' ',`medico_nombre`,`medico_apepart`,`medico_apemart`)FROM medico where `especialidad_id` = ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_DONACIONES` ()   SELECT * FROM donaciones$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ESPECIALIDAD` ()   SELECT * FROM especialidad$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ESPECIALIDAD_COMBO` ()   SELECT especialidad_id,especialidad_nombre FROM especialidad$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_HISTORIAL` (IN `FECHAINICIO` DATE, IN `FECHAFIN` DATE)   SELECT
	fua.fua_id,
    fua.fua_fegistro,
    fua.historia_id,
    fua.consulta_id,
    consulta.consulta_diagnostico,
    CONCAT_WS(' ',paciente.paciente_nombre,paciente.paciente_apepat,paciente.paciente_apemat) AS paciente,
paciente.paciente_nrodocumento,
CONCAT_WS(' ', medico.medico_nombre,medico.medico_apepart,medico.medico_apemart) AS medico
FROM
fua
INNER JOIN
consulta
ON
fua.consulta_id = consulta.consulta_id
INNER JOIN
cita
ON
consulta.cita_id = cita.cita_id
INNER JOIN
paciente
ON
cita.paciente_id = paciente.paciente_id
INNER JOIN
medico
ON
cita.medico_id= medico.medico_id
WHERE fua.fua_fegistro BETWEEN FECHAINICIO AND FECHAFIN$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_INSUMO` ()   SELECT * FROM insumo$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_INSUMO_COMBO` ()   SELECT
	insumo.insumo_id, 
	insumo.insumo_nombre
FROM
	insumo$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_INSUMO_DETALLE` (IN `IDFUA` INT)   SELECT
	insumo.insumo_nombre, 
	detalle_insumo.detain_cantidad
FROM
	detalle_insumo
	INNER JOIN
	insumo
	ON 
		detalle_insumo.insumo_id = insumo.insumo_id
		WHERE detalle_insumo.fua_id=IDFUA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MEDICAMENTO` ()   SELECT * FROM medicamento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MEDICAMENTO_COMBO` ()   SELECT
	medicamento.medicamento_id, 
	medicamento.medicamento_nombre
FROM
	medicamento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MEDICAMENTO_DETALLE` (IN `IDFUA` INT)   SELECT
	medicamento.medicamento_nombre, 
	detalle_medicamento.detame_cantidad
FROM
	detalle_medicamento
	INNER JOIN
	medicamento
	ON 
		detalle_medicamento.medicamento_id = medicamento.medicamento_id
		WHERE detalle_medicamento.fua_id=IDFUA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MEDICO` ()   SELECT
medico.medico_id,
medico_nombre,
medico_apepart,
medico_apemart,
CONCAT_WS(' ',medico_nombre,medico_apepart,medico_apemart) as medico,
medico.medico_direccion,
medico.medico_movil,
medico.medico_sexo,
medico.medico_fenac,
medico.medico_nrodocumento,
medico.medico_colegiatura,
medico.especialidad_id,
medico.usu_id,
especialidad.especialidad_nombre,
usuario.usu_nombre,
usuario.rol_id,
usuario.usu_email,
sangre.sag_id,
sangre.tp_sangre
FROM
medico
INNER JOIN especialidad ON medico.especialidad_id= especialidad.especialidad_id
INNER JOIN usuario ON medico.usu_id = usuario.usu_id
INNER JOIN sangre ON medico.sag_id= sangre.sag_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PACIENTE` ()   SELECT
CONCAT_WS(' ',paciente_nombre,paciente_apepat,paciente_apemat) as paciente,
paciente.paciente_id,
paciente.paciente_nombre,
paciente.paciente_apepat,
paciente.paciente_apemat,
paciente.paciente_direccion,
paciente.paciente_movil,
paciente.paciente_sexo,
paciente_fenac,
paciente.paciente_nrodocumento,
paciente.paciente_estatus,
sangre.sag_id,
sangre.tp_sangre
FROM
paciente
INNER JOIN
sangre
ON
	paciente.sag_id= sangre.sag_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PACIENTE_CITA` ()   SELECT
	cita.cita_id, 
	cita.cita_nroatencion, 
	CONCAT_WS(' ',paciente.paciente_nombre,paciente.paciente_apepat,paciente.paciente_apemat)
FROM
	cita
	INNER JOIN
	paciente
	ON 
		cita.paciente_id = paciente.paciente_id
		WHERE cita_feregistro=CURDATE() AND cita_estatus='PENDIENTE'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PACIENTE_COMBO` ()   SELECT paciente_id,concat_ws(' ',paciente_nombre,paciente_apepat,paciente_apemat) FROM paciente$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PROCEDIMIENTO` ()   SELECT * FROM procedimiento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PROCEDIMIENTO_COMBO` ()   SELECT
	procedimiento.procedimiento_id, 
	procedimiento.procedimiento_nombre
FROM
	procedimiento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PROCEDIMIENTO_DETALLE` (IN `IDFUA` INT)   SELECT
	procedimiento.procedimiento_nombre
FROM
	detalle_procedimiento
	INNER JOIN
	procedimiento
	ON 
		detalle_procedimiento.procedimiento_id = procedimiento.procedimiento_id
		WHERE detalle_procedimiento.fua_id=IDFUA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SANGRE_COMBO` ()   SELECT 
	sangre.sag_id,
	sangre.tp_sangre
FROM 
	sangre$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_USUARIO` ()   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=0;
SELECT
@CANTIDAD:=@CANTIDAD+1 AS posicion,
	u.usu_id, 
	u.usu_nombre, 
	u.usu_sexo, 
	u.rol_id,
  u.usu_estatus,
	r.rol_nombre,
	u.usu_email
FROM
	usuario AS u
	INNER JOIN
	rol AS r
	ON 
		u.rol_id = r.rol_id
		WHERE usu_estatus!='ELIMINADO';
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_USUARIO_INACTIVO` ()   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=0;
SELECT
@CANTIDAD:=@CANTIDAD+1 AS posicion,
	u.usu_id, 
	u.usu_nombre, 
	u.usu_sexo, 
	u.rol_id,
  u.usu_estatus,
	r.rol_nombre,
	u.usu_email
FROM
	usuario AS u
	INNER JOIN
	rol AS r
	ON 
		u.rol_id = r.rol_id
		WHERE usu_estatus='ELIMINADO';
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_CITA` (IN `IDCITA` INT, IN `IDPACIENTE` INT, IN `IDDOCTOR` INT, IN `IDESPECIALIDAD` INT, IN `DESCRIPCION` TEXT, IN `ESTATUS` VARCHAR(10))   UPDATE cita SET
paciente_id=IDPACIENTE,
medico_id=IDDOCTOR,
especialidad_id=IDESPECIALIDAD,
cita_descripcion=DESCRIPCION,
cita_estatus=ESTATUS
where cita_id=IDCITA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_CONSULTA` (IN `IDCONSULTA` INT, IN `DESCRIPCION` VARCHAR(255), IN `DIAGNOSTICO` VARCHAR(255))   UPDATE consulta SET
consulta_descripcion=DESCRIPCION,
consulta_diagnostico=DIAGNOSTICO
WHERE consulta_id=IDCONSULTA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_CONTRA_USUARIO` (IN `IDUSUARIO` INT, IN `CONTRA` VARCHAR(250))   UPDATE usuario SET
usu_contrasena=CONTRA
WHERE usu_id=IDUSUARIO$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_DATOS_USUARIO` (IN `IDUSUARIO` INT, IN `SEXO` CHAR(1), IN `IDROL` INT, IN `EMAIL` VARCHAR(250))   UPDATE usuario SET
usu_sexo=SEXO,
rol_id=IDROL,
usu_email=EMAIL
WHERE usu_id=IDUSUARIO$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_ESPECIALIDAD` (IN `ID` INT, IN `ESPECIALIDADACTUAL` VARCHAR(50), IN `ESPECIALIDADNUEVA` VARCHAR(50), IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
 IF ESPECIALIDADACTUAL=ESPECIALIDADNUEVA THEN
	UPDATE especialidad SET
    especialidad_estatus=ESTATUS
    WHERE especialidad_id=ID;
    SELECT 1;
 ELSE
	SET @CANTIDAD:=(SELECT COUNT(*) FROM especialidad WHERE especialidad_nombre=ESPECIALIDADNUEVA);
    IF @CANTIDAD=0 THEN
    	UPDATE especialidad SET
        especialidad_nombre=ESPECIALIDADNUEVA,
        especialidad_estatus=ESTATUS
        WHERE especialidad_id=ID;
        SELECT 1;
    ELSE
    	SELECT 2;
    END IF;
 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_ESTATUS_USUARIO` (IN `IDUSUARIO` INT, IN `ESTATUS` VARCHAR(20))   UPDATE usuario SET
usu_estatus=ESTATUS
WHERE usu_id=IDUSUARIO$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_INSUMO` (IN `ID` INT, IN `INSUMOACTUAL` VARCHAR(50), IN `INSUMONUEVO` VARCHAR(50), IN `STOCK` INT, IN `FECHV` DATE, IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;

IF INSUMOACTUAL = INSUMONUEVO THEN
	UPDATE insumo SET
	insumo_stock= STOCK,
	insumo_fechf= FECHV,
	insumo_estatus= ESTATUS
	WHERE insumo_id= ID;
	SELECT 1;
ELSE
SET @CANTIDAD:=(SELECT COUNT(*) FROM insumo WHERE insumo_nombre=INSUMONUEVO);

IF @CANTIDAD = 0 THEN
	UPDATE insumo SET
	insumo_nombre=INSUMONUEVO,
	insumo_stock= STOCK,
	insumo_fechf= FECHV,
	insumo_estatus= ESTATUS
	WHERE insumo_id= ID;
	SELECT 1;
ELSE
	SELECT 2;
END IF;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_MEDICAMENTO` (IN `ID` INT, IN `MEDICAMENTOACTUAL` VARCHAR(50), IN `MEDICAMENTONUEVO` VARCHAR(50), IN `ALIAS` VARCHAR(50), IN `STOCK` INT, IN `FECHA` DATE, IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
IF MEDICAMENTOACTUAL= MEDICAMENTONUEVO THEN
	UPDATE medicamento SET
	medicamento_alias=ALIAS,
	medicamento_stock=STOCK,
	medicamento_fechf=FECHA,
	medicamento_estatus=ESTATUS
	WHERE medicamento_id=ID;
	SELECT 1;
ELSE

SET @CANTIDAD:=(SELECT COUNT(*) FROM medicamento WHERE medicamento_nombre=MEDICAMENTONUEVO);
	
	IF @CANTIDAD=0 THEN
		UPDATE medicamento SET
		medicamento_nombre=MEDICAMENTONUEVO,
		medicamento_alias=ALIAS,
		medicamento_stock=STOCK,
		medicamento_fechf=FECHA,
		medicamento_estatus=ESTATUS
		WHERE medicamento_id=ID;
		SELECT 1;
	ELSE
		SELECT 2;
	END IF;
	
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_MEDICO` (IN `IDMEDICO` INT, IN `NOMBRES` VARCHAR(50), IN `APEPAT` VARCHAR(50), IN `APEMAT` VARCHAR(50), IN `DIRECCION` VARCHAR(200), IN `MOVIL` CHAR(12), IN `SEXO` CHAR(2), IN `FECHANACIMIENTO` DATE, IN `SANGRE` INT, IN `NRDOCUMENTOACTUAL` CHAR(12), IN `NRDOCUMENTONUEVO` CHAR(12), IN `COLEGIATURAACTUAL` CHAR(12), IN `COLEGIATURANUEVO` CHAR(12), IN `ESPECIALIDAD` INT, IN `IDUSUARIO` INT, IN `EMAIL` VARCHAR(255))   BEGIN
DECLARE CANTIDAD INT;
IF NRDOCUMENTOACTUAL=NRDOCUMENTONUEVO OR COLEGIATURAACTUAL=COLEGIATURANUEVO THEN
	UPDATE usuario SET
    usu_email=EMAIL,
    usu_sexo=SEXO
    WHERE usu_id=IDUSUARIO;
    UPDATE medico SET
    medico_nombre=NOMBRES,
    medico_apepart=APEPAT,
    medico_apemart=APEMAT,
    medico_direccion=DIRECCION,
    medico_movil=MOVIL,
    medico_sexo=SEXO,
    medico_fenac=FECHANACIMIENTO,
		sag_id=SANGRE,
    medico_nrodocumento=NRDOCUMENTONUEVO,
    medico_colegiatura=COLEGIATURANUEVO,
    especialidad_id=ESPECIALIDAD
    WHERE medico_id=IDMEDICO;
    SELECT 1;
ELSE
	SET @CANTIDAD:=(SELECT COUNT(*) FROM medico WHERE medico_nrodocumento=NRDOCUMENTONUEVO OR medico_colegiatura=COLEGIATURANUEVO);
    IF @CANTIDAD=0 THEN
    UPDATE usuario SET
    usu_email=EMAIL,
    usu_sexo=SEXO
    WHERE usu_id=IDUSUARIO;
    UPDATE medico SET
    medico_nombre=NOMBRES,
    medico_apepart=APEPAT,
    medico_apemart=APEMAT,
    medico_direccion=DIRECCION,
    medico_movil=MOVIL,
    medico_sexo=SEXO,
    medico_fenac=FECHANACIMIENTO,
		sag_id=SANGRE,
    medico_nrodocumento=NRDOCUMENTONUEVO,
    medico_colegiatura=COLEGIATURANUEVO,
    especialidad_id=ESPECIALIDAD
    WHERE medico_id=IDMEDICO;
    SELECT 1;
   ELSE 
    SELECT 2;
   END IF;
    
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_PACIENTE` (IN `ID` INT, IN `NOMBRE` VARCHAR(50), IN `APEPAT` VARCHAR(50), IN `APEMAT` VARCHAR(50), IN `DIRECCION` VARCHAR(200), IN `MOVIL` CHAR(12), IN `FECHA` DATE, IN `SANGRE` INT, IN `SEXO` CHAR(1), IN `NRDOCUMENTOACTUAL` CHAR(12), IN `NRDOCUMENTONUEVO` CHAR(12), IN `ESTATUS` CHAR(10))   BEGIN
DECLARE CANTIDAD INT;
IF NRDOCUMENTOACTUAL=NRDOCUMENTONUEVO THEN
	UPDATE paciente SET
    paciente_nombre=NOMBRE,
    paciente_apepat=APEPAT,
    paciente_apemat=APEMAT,
    paciente_direccion=DIRECCION,
    paciente_movil=MOVIL,
		paciente_fenac=FECHA,
		sag_id=SANGRE,
    paciente_sexo=SEXO,
    paciente_estatus=ESTATUS
    WHERE paciente_id=ID;
    SELECT 1;
ELSE
SET @CANTIDAD:=(SELECT COUNT(*) FROM paciente where paciente_nrodocumento=NRDOCUMENTONUEVO);
 IF @CANTIDAD= 0 THEN
 UPDATE paciente SET
    paciente_nombre=NOMBRE,
    paciente_apepat=APEPAT,
    paciente_apemat=APEMAT,
    paciente_direccion=DIRECCION,
    paciente_movil=MOVIL,
		paciente_fenac=FECHA,
		sag_id=SANGRE,
    paciente_sexo=SEXO,
    paciente_nrodocumento=NRDOCUMENTONUEVO,
    paciente_estatus=ESTATUS
    WHERE paciente_id=ID;
    SELECT 1;
  ELSE
    SELECT 2;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_PROCEDIMIENTO` (IN `ID` INT, IN `PROCEDIMIENTOACTUAL` VARCHAR(50), IN `PROCEDIMIENTONUEVO` VARCHAR(50), IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
IF PROCEDIMIENTOACTUAL=PROCEDIMIENTONUEVO THEN
		UPDATE procedimiento SET
		procedimiento_estatus=ESTATUS
		WHERE procedimiento_id=ID;
		SELECT 1;
ELSE
		SET @CANTIDAD:=(SELECT count(*) FROM procedimiento WHERE procedimiento_nombre=PROCEDIMIENTONUEVO);
		if @CANTIDAD = 0 THEN
		UPDATE procedimiento SET
		procedimiento_estatus=ESTATUS,
		procedimiento_nombre=PROCEDIMIENTONUEVO
		WHERE procedimiento_id=ID;
		SELECT 1;
	ELSE
		SELECT 2;
		
		END IF;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_CITA` (IN `IDPACIENTE` INT, IN `IDDOCTOR` INT, IN `DESCRIPCION` TEXT, IN `IDUSUARIO` INT, IN `ESPECIALIDAD` INT)   BEGIN
DECLARE NUMCITA INT;
SET @NUMCITA:=(SELECT COUNT(*) +1 FROM cita WHERE cita_feregistro=CURDATE());
INSERT INTO cita(cita_nroatencion,cita_feregistro,medico_id,especialidad_id,paciente_id,cita_estatus,cita_descripcion,usu_id) VALUES(@NUMCITA,CURDATE(),IDDOCTOR,ESPECIALIDAD,IDPACIENTE,'PENDIENTE',DESCRIPCION,IDUSUARIO);
SELECT LAST_INSERT_ID();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_CONSULTA` (IN `ID` INT, IN `DESCRIPCION` VARCHAR(255), IN `DIAGNOSTICO` VARCHAR(255))   BEGIN
INSERT INTO consulta(consulta_descripcion,consulta_diagnostico,consulta_feregistro,consulta_estatus,cita_id) VALUES(DESCRIPCION,DIAGNOSTICO,CURDATE(),'ATENDIDA',ID);
UPDATE cita SET
cita_estatus='ATENDIDA'
WHERE cita_id=ID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_DONACIONES` (IN `PACIENTE` INT, IN `SANGRE` VARCHAR(255), IN `VOLUMEN` FLOAT, IN `FECHA` DATE)   BEGIN
	DECLARE CANTIDAD INT;
	SET @CANTIDAD :=(SELECT COUNT(*) FROM donaciones WHERE paciente_id=PACIENTE);
	IF @CANTIDAD=0 THEN
	INSERT INTO donaciones(sag_id,volumen,paciente_id,fecha_donaciones) VALUES(SANGRE,VOLUMEN,PACIENTE,FECHA);
	SELECT 1;
	ELSE
	SELECT 2;
	END IF;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_ESPECIALIDAD` (IN `ESPECIALIDAD` VARCHAR(50), IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM especialidad WHERE especialidad_nombre=ESPECIALIDAD);
IF @CANTIDAD= 0 THEN
INSERT INTO especialidad(especialidad_nombre,especialidad_fregistro,especialidad_estatus) VALUES(ESPECIALIDAD,CURDATE(),ESTATUS);
SELECT 1;

ELSE
SELECT 2;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_INSUMO` (IN `INSUMO` VARCHAR(50), IN `STOCK` INT, IN `FECHV` DATE, IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM insumo WHERE insumo_nombre=INSUMO);

IF @CANTIDAD = 0 THEN
INSERT INTO insumo(insumo_nombre,insumo_stock,insumo_fechf,insumo_fregistro,insumo_estatus)
VALUES(INSUMO,STOCK,FECHV,CURDATE(),ESTATUS);
SELECT 1;
ELSE
SELECT 2;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_MEDICAMENTO` (IN `MEDICAMENTO` VARCHAR(50), IN `ALIAS` VARCHAR(50), IN `STOCK` INT, IN `FECHA` DATE, IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM medicamento WHERE medicamento_nombre=MEDICAMENTO);
IF @CANTIDAD=0 THEN
	INSERT INTO medicamento(medicamento_nombre,medicamento_alias,medicamento_stock,medicamento_fregistro,medicamento_estatus,medicamento_fechf)
	VALUES(MEDICAMENTO,ALIAS,STOCK,CURDATE(),ESTATUS,FECHA);
	SELECT 1;
ELSE
	SELECT 2;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_MEDICO` (IN `NOMBRES` VARCHAR(50), IN `APEPAT` VARCHAR(50), IN `APEMAT` VARCHAR(50), IN `DIRECCION` VARCHAR(200), IN `MOVIL` CHAR(12), IN `SANGRE` VARCHAR(255), IN `SEXO` CHAR(2), IN `FECHANACIMIENTO` DATE, IN `NRDOCUMENTO` CHAR(12), IN `COLEGIATURA` CHAR(12), IN `ESPECIALIDAD` INT, IN `USUARIO` VARCHAR(20), IN `CONTRA` VARCHAR(255), IN `ROL` INT, IN `EMAIl` VARCHAR(255))   BEGIN 
DECLARE CANTIDADU INT; 
DECLARE CANTIDADME INT; 
 SET @CANTIDADU:=(SELECT COUNT(*) FROM usuario WHERE usu_nombre=USUARIO); 
 IF @CANTIDADU = 0 THEN
 SET @CANTIDADME:=(SELECT COUNT(*) FROM medico WHERE medico_nrodocumento=NRDOCUMENTO OR medico_colegiatura=COLEGIATURA); 
 IF @CANTIDADME= 0 THEN 
 INSERT INTO usuario(usu_nombre,usu_contrasena,usu_sexo,rol_id,usu_estatus,usu_email,usu_intento) 
 VALUES(USUARIO,CONTRA,SEXO,ROL,'ACTIVO',EMAIL,0); 
 INSERT INTo medico(medico_nombre,medico_apepart,medico_apemart,medico_direccion,medico_movil,sag_id,medico_sexo,medico_fenac,medico_nrodocumento,medico_colegiatura,especialidad_id,usu_id)
  VALUES(NOMBRES,APEPAT,APEMAT,DIRECCION,MOVIL,SANGRE,SEXO,FECHANACIMIENTO,NRDOCUMENTO,COLEGIATURA,ESPECIALIDAD,(SELECT MAX(usu_id) FROM usuario)); 
SELECT 1;
ELSE
SELECT 2;
END IF;
ELSE 
SELECT 2;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_PACIENTE` (IN `NOMBRE` VARCHAR(50), IN `APEPAT` VARCHAR(50), IN `APEMAT` VARCHAR(50), IN `DIRECCION` VARCHAR(200), IN `MOVIL` CHAR(12), IN `SEXO` CHAR(1), IN `FCHA` DATE, IN `NRDOCUMENTO` CHAR(12), IN `SANGRE` VARCHAR(255))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD :=(SELECT COUNT(*) FROM paciente where paciente_nrodocumento=NRDOCUMENTO);
IF @CANTIDAD=0 THEN
	INSERT INTO paciente(paciente_nombre,paciente_apepat,paciente_apemat,paciente_direccion,paciente_movil,paciente_sexo,paciente_fenac,paciente_nrodocumento,sag_id,paciente_estatus) VALUES(NOMBRE,APEPAT,APEMAT,DIRECCION,MOVIL,SEXO,FCHA,NRDOCUMENTO,SANGRE,'ACTIVO');
    SELECT 1;
   ELSE
    SELECT 2;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_PROCEDIMIENTO` (IN `PROCEDIMIENTO` VARCHAR(50), IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDA INT;
SET @CANTIDAD:=(SELECT count(*) FROM procedimiento WHERE procedimiento_nombre=PROCEDIMIENTO);
IF @CANTIDAD = 0 THEN
 INSERT INTO procedimiento(procedimiento_nombre,procedimiento_fecregistro,procedimiento_estatus)VALUES(PROCEDIMIENTO,CURDATE(),ESTATUS);
 SELECT 1;
ELSE
 SELECT 2;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_USUARIO` (IN `USU` VARCHAR(20), IN `CONTRA` VARCHAR(250), IN `SEXO` CHAR(1), IN `ROL` INT, IN `EMAIL` VARCHAR(250))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT count(*) FROM usuario WHERE usu_nombre= BINARY USU);
IF @CANTIDAD=0 THEN
	INSERT INTO usuario(usu_nombre,usu_contrasena,usu_sexo,rol_id,usu_estatus,usu_email,usu_intento) VALUES (USU,CONTRA,SEXO,ROL,'ACTIVO',EMAIL,0);
	SELECT 1;
ELSE
	SELECT 2;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGRISTRAR_DETALLE_INSUMO` (IN `IDFUA` INT, IN `IDINSUMO` INT, IN `CANTIDADINSUMO` INT)   INSERT INTO detalle_insumo(fua_id,insumo_id,detain_cantidad)values(IDFUA,IDINSUMO,CANTIDADINSUMO)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGRISTRAR_DETALLE_MEDICAMENTO` (IN `IDFUA` INT, IN `IDMEDICAMENTO` INT, IN `CANTIDAD` INT)   INSERT INTO detalle_medicamento(fua_id,medicamento_id,detame_cantidad)values(IDFUA,IDMEDICAMENTO,CANTIDAD)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGRISTRAR_DETALLE_PROCEDIMIENTO` (IN `ID` INT, IN `IDPROCEDIMIENTO` INT)   INSERT INTO detalle_procedimiento(fua_id,procedimiento_id)values(ID,IDPROCEDIMIENTO)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGRISTRAR_FUA` (IN `IDHISTORIAL` INT, IN `IDCONSULTA` INT)   BEGIN
	INSERT INTO fua(fua_fegistro,historia_id,consulta_id)VALUES(CURDATE(),IDHISTORIAL,IDCONSULTA);
	SELECT LAST_INSERT_ID();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RESETEAR_CON` (IN `USUARIO` VARCHAR(20))   BEGIN 
UPDATE usuario set
usu_intento=0
WHERE usu_nombre=USUARIO;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RESTAURAR_DATOS` ()   SELECT
	usuario.usu_estatus ='ELIMINADO', 
	paciente.paciente_estatus ='ELIMINADO',
	procedimiento.procedimiento_estatus ='ELIMINADO'
FROM
	usuario,
	paciente,
	procedimiento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RETABLECER_CONTRA` (IN `EMAIL` VARCHAR(255), IN `CONTRA` VARCHAR(255))   BEGIN
DECLARE  CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM usuario WHERE usu_email=EMAIL);
IF @CANTIDAD>0 THEN
	
	UPDATE usuario SET 
	usu_contrasena=CONTRA, 
	usu_intento=0
	WHERE usu_email=EMAIL;
	
	SELECT 1;
ELSE
	
	SELECT 2;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_STOCK_INSUMO_H` (IN `ID` INT)   SELECT
	insumo.insumo_id, 
	insumo.insumo_stock
FROM
	insumo
	WHERE insumo.insumo_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAER_STOCK_MEDICAMENTO_H` (IN `ID` INT)   SELECT
	medicamento.medicamento_nombre, 
	medicamento.medicamento_stock
FROM
	medicamento
	WHERE medicamento.medicamento_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VERIFICAR_USUARIO` (IN `USUARIO` VARCHAR(20))   SELECT
	usuario.usu_id, 
	usuario.usu_nombre, 
	usuario.usu_contrasena, 
	usuario.usu_sexo, 
	usuario.rol_id, 
	usuario.usu_estatus, 
	rol.rol_nombre,
	usuario.usu_intento
FROM
	usuario
	INNER JOIN rol ON usuario.rol_id = rol .rol_id
	WHERE usu_nombre = BINARY USUARIO$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `audi_id` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `accion` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_id` int(11) DEFAULT NULL,
  `usu_nombre` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`audi_id`, `fecha`, `accion`, `usu_id`, `usu_nombre`) VALUES
(1, '2022-06-30 00:00:00', 'Se inserto un nuevo usuario', 0, NULL),
(2, '2022-06-30 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(3, '2022-06-30 00:00:00', 'Se inserto un nuevo usuario', 0, NULL),
(4, '2022-06-30 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(5, '2022-06-30 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(6, '2022-07-05 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(7, '2022-07-06 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(8, '2022-07-06 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(9, '2022-07-06 00:00:00', 'Se modifico un nuevo insumo', 0, NULL),
(10, '2022-07-07 00:00:00', 'Se inserto un nuevo usuario', 0, NULL),
(11, '2022-07-11 00:00:00', 'Se modifico un nuevo insumo', 0, NULL),
(12, '2022-07-24 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(13, '2022-07-24 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(14, '2022-07-24 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(15, '2022-07-24 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(16, '2022-07-24 00:00:00', 'Se modifico un nuevo usuario', 0, NULL),
(17, '2022-07-24 15:16:18', 'Se modifico un nuevo insumo', 0, NULL),
(18, '2022-07-24 15:36:59', 'Se modifico un nuevo usuario', 0, NULL),
(19, '2022-07-24 15:37:31', 'Se modifico un nuevo usuario', 0, NULL),
(20, '2022-08-12 11:22:04', 'Se modifico un nuevo usuario', 0, NULL),
(21, '2022-08-12 11:24:59', 'Se modifico un nuevo usuario', 0, NULL),
(22, '2022-08-12 11:26:14', 'Se modifico un nuevo usuario', 0, NULL),
(23, '2022-08-12 11:26:59', 'Se modifico un nuevo usuario', 0, NULL),
(24, '2022-08-12 11:36:28', 'Se modifico un nuevo usuario', 0, NULL),
(25, '2022-08-14 04:31:06', 'Se modifico un nuevo usuario', 0, NULL),
(26, '2022-08-14 04:31:19', 'Se modifico un nuevo usuario', 0, NULL),
(27, '2022-08-16 21:18:19', 'Se modifico un nuevo usuario', 1, NULL),
(28, '2022-08-16 21:18:59', 'Se modifico un nuevo paciente', 0, NULL),
(29, '2022-08-16 21:19:21', 'Se modifico un nuevo usuario', 1, NULL),
(30, '2022-08-16 21:19:42', 'Se modifico un nuevo usuario', 1, NULL),
(31, '2022-08-16 21:20:09', 'Se modifico un nuevo usuario', 2, NULL),
(32, '2022-08-16 21:20:14', 'Se modifico un nuevo usuario', 1, NULL),
(33, '2022-08-16 21:34:10', 'Se modifico un nuevo usuario', 2, NULL),
(34, '2022-08-16 21:36:49', 'Se modifico un nuevo usuario', 1, NULL),
(35, '2022-08-16 21:37:04', 'Se modifico un nuevo usuario', 1, NULL),
(36, '2022-08-16 21:39:37', 'Se modifico un nuevo usuario', 1, NULL),
(37, '2022-08-16 21:42:34', 'Se modifico un nuevo usuario', 1, NULL),
(38, '2022-08-16 21:42:36', 'Se modifico un nuevo usuario', 1, NULL),
(39, '2022-08-16 21:43:04', 'Se modifico un nuevo usuario', 1, NULL),
(40, '2022-08-16 21:43:16', 'Se modifico un nuevo usuario', 1, NULL),
(41, '2022-08-16 21:43:17', 'Se modifico un nuevo usuario', 1, NULL),
(42, '2022-08-16 21:43:49', 'Se modifico un nuevo usuario', 1, NULL),
(43, '2022-08-16 21:43:57', 'Se modifico un nuevo usuario', 1, NULL),
(44, '2022-08-16 22:10:47', 'Se modifico un nuevo usuario', 1, NULL),
(45, '2022-08-16 22:15:24', 'Se modifico un nuevo usuario', 1, NULL),
(46, '2022-08-16 22:15:24', 'Se modifico un nuevo usuario', 1, NULL),
(47, '2022-08-16 22:15:44', 'Se modifico un nuevo usuario', 1, NULL),
(48, '2022-08-16 22:15:44', 'Se modifico un nuevo usuario', 1, NULL),
(49, '2022-08-16 22:15:53', 'Se modifico un nuevo usuario', 1, NULL),
(50, '2022-08-16 22:15:53', 'Se modifico un nuevo usuario', 1, NULL),
(51, '2022-08-16 22:15:59', 'Se modifico un nuevo usuario', 1, NULL),
(52, '2022-08-16 22:15:59', 'Se modifico un nuevo usuario', 1, NULL),
(53, '2022-08-16 22:16:06', 'Se modifico un nuevo usuario', 1, NULL),
(54, '2022-08-16 22:16:06', 'Se modifico un nuevo usuario', 1, NULL),
(55, '2022-08-16 22:16:09', 'Se modifico un nuevo usuario', 1, NULL),
(56, '2022-08-16 22:16:09', 'Se modifico un nuevo usuario', 1, NULL),
(57, '2022-08-16 22:16:15', 'Se modifico un nuevo usuario', 1, NULL),
(58, '2022-08-16 22:16:15', 'Se modifico un nuevo usuario', 1, NULL),
(59, '2022-08-16 22:17:01', 'Se modifico un nuevo usuario', 1, NULL),
(60, '2022-08-16 22:17:01', 'Se modifico un nuevo usuario', 1, NULL),
(61, '2022-08-16 22:17:09', 'Se modifico un nuevo usuario', 1, NULL),
(62, '2022-08-16 22:17:09', 'Se modifico un nuevo usuario', 1, NULL),
(63, '2022-08-16 22:17:11', 'Se modifico un nuevo usuario', 1, NULL),
(64, '2022-08-16 22:17:11', 'Se modifico un nuevo usuario', 1, NULL),
(65, '2022-08-16 22:18:44', 'Se modifico un nuevo usuario', 1, NULL),
(66, '2022-08-16 22:18:44', 'Se modifico un nuevo usuario', 1, NULL),
(67, '2022-08-16 22:18:45', 'Se modifico un nuevo usuario', 1, NULL),
(68, '2022-08-16 22:18:45', 'Se modifico un nuevo usuario', 1, NULL),
(69, '2022-08-16 22:18:47', 'Se modifico un nuevo usuario', 1, NULL),
(70, '2022-08-16 22:18:47', 'Se modifico un nuevo usuario', 1, NULL),
(71, '2022-08-16 22:19:02', 'Se modifico un nuevo usuario', 1, NULL),
(72, '2022-08-16 22:19:02', 'Se modifico un nuevo usuario', 1, NULL),
(73, '2022-08-16 22:19:04', 'Se modifico un nuevo usuario', 1, NULL),
(74, '2022-08-16 22:19:04', 'Se modifico un nuevo usuario', 1, NULL),
(75, '2022-08-16 22:19:56', 'Se modifico un nuevo usuario', 1, NULL),
(76, '2022-08-16 22:19:56', 'Se modifico un nuevo usuario', 1, NULL),
(77, '2022-08-16 22:19:57', 'Se modifico un nuevo usuario', 1, NULL),
(78, '2022-08-16 22:19:57', 'Se modifico un nuevo usuario', 1, NULL),
(79, '2022-08-16 22:19:58', 'Se modifico un nuevo usuario', 1, NULL),
(80, '2022-08-16 22:19:58', 'Se modifico un nuevo usuario', 1, NULL),
(81, '2022-08-16 22:20:00', 'Se modifico un nuevo usuario', 1, NULL),
(82, '2022-08-16 22:20:00', 'Se modifico un nuevo usuario', 1, NULL),
(83, '2022-08-16 22:21:45', 'Se modifico un nuevo usuario', 1, NULL),
(84, '2022-08-16 22:21:54', 'Se modifico un nuevo usuario', 1, NULL),
(85, '2022-08-16 22:22:12', 'Se modifico un nuevo usuario', 1, NULL),
(86, '2022-08-16 22:22:22', 'Se modifico un nuevo usuario', 1, NULL),
(87, '2022-08-16 22:26:28', 'Se modifico un nuevo usuario', 1, NULL),
(88, '2022-08-16 22:26:59', 'Se modifico un nuevo usuario', 1, NULL),
(89, '2022-08-16 22:27:08', 'Se modifico un nuevo usuario', 1, NULL),
(90, '2022-08-21 15:17:57', 'Se modifico un nuevo usuario', 1, NULL),
(91, '2022-08-21 15:18:11', 'Se modifico un nuevo usuario', 1, NULL),
(92, '2022-08-21 15:18:17', 'Se modifico un nuevo usuario', 1, NULL),
(93, '2022-08-21 15:18:25', 'Se modifico un nuevo usuario', 1, NULL),
(94, '2022-08-24 00:04:15', 'Se modifico un nuevo usuario', 1, NULL),
(95, '2022-08-27 01:39:29', 'Se modifico un nuevo usuario', 1, NULL),
(96, '2022-08-27 01:39:40', 'Se modifico un nuevo usuario', 3, NULL),
(97, '2022-08-27 01:39:44', 'Se modifico un nuevo usuario', 3, NULL),
(98, '2022-08-27 01:39:47', 'Se modifico un nuevo usuario', 3, NULL),
(99, '2022-08-27 01:39:53', 'Se modifico un nuevo usuario', 3, NULL),
(100, '2022-08-27 01:39:58', 'Se modifico un nuevo usuario', 3, NULL),
(101, '2022-08-27 01:40:04', 'Se modifico un nuevo usuario', 3, NULL),
(102, '2022-08-27 01:40:09', 'Se modifico un nuevo usuario', 2, NULL),
(103, '2022-08-27 01:41:46', 'Se modifico un nuevo usuario', 2, NULL),
(104, '2022-08-27 01:42:28', 'Se modifico un nuevo usuario', 1, NULL),
(105, '2022-08-27 01:45:39', 'Se modifico un nuevo usuario', 1, NULL),
(106, '2022-08-27 02:02:32', 'Se modifico un nuevo usuario', 3, NULL),
(107, '2022-08-27 02:02:35', 'Se modifico un nuevo usuario', 3, NULL),
(108, '2022-08-27 02:03:28', 'Se modifico un nuevo usuario', 3, NULL),
(109, '2022-08-27 02:03:42', 'Se modifico un nuevo usuario', 3, NULL),
(110, '2022-08-27 02:03:47', 'Se modifico un nuevo usuario', 3, NULL),
(111, '2022-08-27 02:03:50', 'Se modifico un nuevo usuario', 3, NULL),
(112, '2022-08-27 02:03:54', 'Se modifico un nuevo usuario', 2, NULL),
(113, '2022-08-27 02:03:57', 'Se modifico un nuevo usuario', 1, NULL),
(114, '2022-08-27 02:04:14', 'Se modifico un nuevo usuario', 1, NULL),
(115, '2022-08-27 02:04:16', 'Se modifico un nuevo usuario', 2, NULL),
(116, '2022-08-27 02:04:19', 'Se modifico un nuevo usuario', 3, NULL),
(117, '2022-08-28 23:09:09', 'Se modifico un nuevo usuario', 3, NULL),
(118, '2022-08-28 23:18:34', 'Se modifico un nuevo usuario', 3, NULL),
(119, '2022-08-28 23:25:33', 'Se modifico un nuevo usuario', 3, NULL),
(120, '2022-08-28 23:26:51', 'Se modifico un nuevo paciente', 0, NULL),
(121, '2022-08-28 23:27:47', 'Se modifico un nuevo usuario', 3, NULL),
(122, '2022-08-28 23:27:58', 'Se modifico un nuevo paciente', 0, NULL),
(123, '2022-08-28 23:28:25', 'Se modifico un nuevo paciente', 0, NULL),
(124, '2022-08-28 23:31:21', 'Se modifico un nuevo usuario', 3, NULL),
(125, '2022-08-31 12:21:35', 'Se modifico un nuevo usuario', 2, NULL),
(126, '2022-08-31 12:21:40', 'Se modifico un nuevo usuario', 2, NULL),
(127, '2022-08-31 12:21:46', 'Se modifico un nuevo usuario', 2, NULL),
(128, '2022-09-05 20:04:38', 'Se modifico un nuevo paciente', 0, NULL),
(129, '2022-09-12 23:06:58', 'Se modifico un nuevo usuario', 1, NULL),
(130, '2022-09-12 23:07:04', 'Se modifico un nuevo usuario', 1, NULL),
(131, '2022-09-12 23:07:43', 'Se modifico un nuevo usuario', 1, NULL),
(132, '2022-09-12 23:08:05', 'Se modifico un nuevo usuario', 3, NULL),
(133, '2022-09-12 23:08:13', 'Se modifico un nuevo usuario', 3, NULL),
(134, '2022-09-12 23:08:14', 'Se modifico un nuevo usuario', 3, NULL),
(135, '2022-09-12 23:08:29', 'Se modifico un nuevo usuario', 3, NULL),
(136, '2022-09-12 23:09:22', 'Se modifico un nuevo usuario', 3, NULL),
(137, '2022-09-13 22:52:38', 'Se modifico un nuevo paciente', 0, NULL),
(138, '2022-09-13 22:55:33', 'Se modifico un nuevo usuario', 3, NULL),
(139, '2022-09-13 22:55:41', 'Se modifico un nuevo usuario', 3, NULL),
(140, '2022-09-13 22:55:55', 'Se modifico un nuevo usuario', 3, NULL),
(141, '2022-09-13 22:58:58', 'Se modifico un nuevo insumo', 0, NULL),
(142, '2022-10-02 20:29:49', 'Se modifico un nuevo usuario', 3, NULL),
(143, '2022-10-02 20:29:56', 'Se modifico un nuevo usuario', 2, NULL),
(144, '2022-10-02 20:41:26', 'Se modifico un nuevo usuario', 2, NULL),
(145, '2022-10-02 20:42:54', 'Se modifico un nuevo usuario', 2, 'RG'),
(146, '2022-10-02 20:43:15', 'Se modifico un nuevo usuario', 3, 'nestor'),
(147, '2022-10-03 19:01:01', 'Se modifico un nuevo usuario', 3, 'nestor'),
(148, '2022-10-04 16:30:24', 'Se modifico un nuevo insumo', NULL, NULL),
(149, '2022-10-04 16:30:28', 'Se modifico un nuevo insumo', NULL, NULL),
(150, '2022-10-04 16:30:31', 'Se modifico un nuevo insumo', NULL, NULL),
(151, '2022-10-05 00:47:38', 'Se modifico un nuevo usuario', 3, 'nestor'),
(152, '2022-10-05 09:18:38', 'Se modifico un nuevo usuario', 3, 'nestor'),
(153, '2022-10-05 09:39:53', 'Se modifico un nuevo paciente', 0, NULL),
(154, '2022-10-07 16:54:05', 'Se modifico un nuevo paciente', 0, NULL),
(155, '2022-10-07 16:56:10', 'Se modifico un nuevo paciente', 0, NULL),
(156, '2022-10-07 16:57:23', 'Se modifico un nuevo paciente', 0, NULL),
(157, '2022-10-07 16:57:50', 'Se modifico un nuevo usuario', NULL, NULL),
(158, '2022-10-07 16:58:32', 'Se modifico un nuevo usuario', 2, 'RG'),
(159, '2022-10-10 18:36:57', 'Se inserto un nuevo usuario', 4, 'andrew'),
(160, '2022-10-11 10:04:22', 'Se modifico un nuevo insumo', NULL, NULL),
(161, '2022-10-11 10:04:22', 'Se modifico un nuevo insumo', NULL, NULL),
(162, '2022-10-21 10:35:02', 'Se modifico un nuevo usuario', 3, 'nestor'),
(163, '2022-10-21 10:35:30', 'Se modifico un nuevo usuario', 4, 'andrew'),
(164, '2022-10-21 16:40:13', 'Se modifico un nuevo usuario', 1, 'vero'),
(165, '2022-10-21 16:45:03', 'Se modifico un nuevo usuario', 1, 'vero'),
(166, '2022-10-21 16:45:20', 'Se modifico un nuevo usuario', 1, 'vero'),
(167, '2022-10-21 16:45:30', 'Se modifico un nuevo usuario', 1, 'vero'),
(168, '2022-10-21 16:45:48', 'Se modifico un nuevo usuario', 1, 'vero'),
(169, '2022-10-21 16:45:50', 'Se modifico un nuevo usuario', 1, 'vero'),
(170, '2022-10-21 16:46:23', 'Se modifico un nuevo usuario', 1, 'vero'),
(171, '2022-10-21 16:48:45', 'Se modifico un nuevo usuario', 1, 'vero'),
(172, '2022-10-21 16:48:47', 'Se modifico un nuevo usuario', 1, 'vero'),
(173, '2022-10-21 16:49:31', 'Se modifico un nuevo usuario', 1, 'vero'),
(174, '2022-10-21 16:50:50', 'Se modifico un nuevo usuario', 1, 'vero'),
(175, '2022-10-21 16:50:56', 'Se modifico un nuevo usuario', 1, 'vero'),
(176, '2022-10-25 01:43:18', 'Se modifico un nuevo usuario', 1, 'vero'),
(177, '2022-10-25 01:43:41', 'Se modifico un nuevo usuario', 1, 'vero'),
(178, '2022-10-26 00:09:28', 'Se modifico un nuevo usuario', 1, 'vero'),
(179, '2022-10-26 00:11:29', 'Se modifico un nuevo usuario', 1, 'vero'),
(180, '2022-10-26 00:11:41', 'Se modifico un nuevo usuario', 2, 'RG'),
(181, '2022-10-26 00:16:11', 'Se modifico un nuevo usuario', 3, 'nestor'),
(182, '2022-10-26 00:16:34', 'Se modifico un nuevo usuario', 1, 'vero'),
(183, '2022-10-26 00:17:28', 'Se modifico un nuevo usuario', 1, 'vero'),
(184, '2022-10-26 01:00:58', 'Se modifico un nuevo usuario', 1, 'vero'),
(185, '2022-10-26 02:20:06', 'Se modifico un nuevo usuario', 1, 'vero'),
(186, '2022-10-27 06:43:51', 'Se modifico un nuevo usuario', 1, 'vero'),
(187, '2022-10-27 06:47:57', 'Se modifico un nuevo usuario', 1, 'vero'),
(188, '2022-10-27 06:51:44', 'Se modifico un nuevo paciente', 0, NULL),
(189, '2022-10-27 06:54:43', 'Se modifico un nuevo usuario', 3, 'nestor'),
(190, '2022-10-27 06:55:56', 'Se modifico un nuevo usuario', 3, 'nestor'),
(191, '2022-10-27 06:56:24', 'Se modifico un nuevo usuario', 3, 'nestor'),
(192, '2022-10-27 06:56:56', 'Se modifico un nuevo usuario', 3, 'nestor'),
(193, '2022-10-27 06:58:54', 'Se modifico un nuevo usuario', 3, 'andrea'),
(194, '2022-10-27 06:59:27', 'Se modifico un nuevo usuario', 3, 'andrea'),
(195, '2022-10-27 07:01:18', 'Se modifico un nuevo usuario', 4, 'andrew'),
(196, '2022-10-27 07:27:21', 'Se inserto un nuevo usuario', 5, 'Laura'),
(197, '2022-10-27 07:32:47', 'Se inserto un nuevo usuario', 6, 'arfilio'),
(198, '2022-10-27 07:36:52', 'Se inserto un nuevo usuario', 7, 'lau'),
(199, '2022-10-27 09:52:19', 'Se modifico un nuevo usuario', 1, 'vero'),
(200, '2022-10-27 10:10:21', 'Se modifico un nuevo usuario', 1, 'vero'),
(201, '2022-10-27 10:15:06', 'Se modifico un nuevo usuario', 1, 'vero'),
(202, '2022-10-27 10:15:39', 'Se modifico un nuevo usuario', 2, 'RG'),
(203, '2022-10-27 10:45:07', 'Se modifico un nuevo usuario', 1, 'vero'),
(204, '2022-10-27 10:52:38', 'Se modifico un nuevo insumo', NULL, NULL),
(205, '2022-10-27 10:53:21', 'Se modifico un nuevo usuario', 4, 'andrew'),
(206, '2022-10-27 10:53:33', 'Se modifico un nuevo usuario', 7, 'lau'),
(207, '2022-10-27 10:53:37', 'Se modifico un nuevo usuario', 6, 'arfilio'),
(208, '2022-10-27 11:14:42', 'Se modifico un nuevo usuario', 1, 'vero'),
(209, '2022-10-27 11:23:24', 'Se modifico un nuevo usuario', 1, 'vero'),
(210, '2022-10-27 11:30:39', 'Se modifico un nuevo usuario', 6, 'arfilio'),
(211, '2022-10-27 11:30:56', 'Se modifico un nuevo usuario', 6, 'arfilio'),
(212, '2022-11-14 22:46:08', 'Se modifico un nuevo usuario', 1, 'vero');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cita`
--

CREATE TABLE `cita` (
  `cita_id` int(11) NOT NULL,
  `cita_nroatencion` int(11) DEFAULT NULL,
  `cita_feregistro` date DEFAULT NULL,
  `medico_id` int(11) DEFAULT NULL,
  `especialidad_id` int(11) DEFAULT NULL,
  `paciente_id` int(11) DEFAULT NULL,
  `cita_estatus` enum('PENDIENTE','CANCELADA','ATENDIDA') COLLATE utf8_spanish_ci NOT NULL,
  `cita_descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  `usu_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `cita`
--

INSERT INTO `cita` (`cita_id`, `cita_nroatencion`, `cita_feregistro`, `medico_id`, `especialidad_id`, `paciente_id`, `cita_estatus`, `cita_descripcion`, `usu_id`) VALUES
(1, 1, '2022-07-24', 1, 2, 1, 'PENDIENTE', 'xdf', 1),
(2, 1, '2022-08-31', 1, 2, 1, 'PENDIENTE', 'qwqwes', 1),
(3, 1, '2022-10-05', 1, 2, 1, 'ATENDIDA', 'wee', 1),
(4, 2, '2022-10-05', 1, NULL, 5, 'PENDIENTE', 'Por dolor', 1),
(5, 3, '2022-10-05', 1, NULL, 5, 'PENDIENTE', 'Por dolor', 1),
(6, 1, '2022-10-10', 1, NULL, 1, 'ATENDIDA', 'afsdfsdf', 1),
(7, 2, '2022-10-10', 1, NULL, 5, 'ATENDIDA', 'dfsdfsdfsd', 1),
(8, 3, '2022-10-10', 2, NULL, 2, 'ATENDIDA', 'dsdfsd', 1),
(9, 4, '2022-10-10', 2, NULL, 2, 'PENDIENTE', 'dsdfsd', 1),
(11, 5, '2022-10-10', 2, NULL, 1, 'PENDIENTE', 'fdgdfgdf', 2),
(12, 6, '2022-10-10', 2, 2, 1, 'ATENDIDA', 'fdgdfgdf', 2),
(13, 1, '2022-10-11', 1, 2, 1, 'ATENDIDA', 'dfsd', 1),
(14, 1, '2022-10-15', 1, 2, 1, 'ATENDIDA', 'sasas', 1),
(17, 1, '2022-10-21', 1, 2, 1, 'PENDIENTE', 'ffdfd', 1),
(18, 2, '2022-10-21', 1, 2, 1, 'PENDIENTE', 'sdfsdfsff', 1),
(19, 3, '2022-10-21', 1, 2, 5, 'PENDIENTE', 'cvbcvbfg', 1),
(20, 1, '2022-10-26', 1, 2, 1, 'PENDIENTE', 'dolor', 1),
(21, 1, '2022-10-27', 4, 5, 7, 'ATENDIDA', 'Donación', 1),
(22, 2, '2022-10-27', 1, 2, 9, 'PENDIENTE', 'Es jugador de LoL', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consulta`
--

CREATE TABLE `consulta` (
  `consulta_id` int(11) NOT NULL,
  `consulta_descripcion` text COLLATE utf8_spanish_ci DEFAULT NULL,
  `consulta_diagnostico` text COLLATE utf8_spanish_ci DEFAULT NULL,
  `consulta_feregistro` date DEFAULT NULL,
  `consulta_estatus` enum('ATENDIDA','PENDIENTE') COLLATE utf8_spanish_ci DEFAULT NULL,
  `cita_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `consulta`
--

INSERT INTO `consulta` (`consulta_id`, `consulta_descripcion`, `consulta_diagnostico`, `consulta_feregistro`, `consulta_estatus`, `cita_id`) VALUES
(1, 'dfgfg', 'ggffd', '2022-07-24', 'PENDIENTE', 1),
(2, 'dolor de cabeza', 'Ibuprofeno', '2022-10-05', 'PENDIENTE', 3),
(3, 'sdsd', 'sdfsdf', '2022-10-10', 'ATENDIDA', 6),
(4, 'sdfsd', 'sdfsdf', '2022-10-10', 'ATENDIDA', 7),
(5, 'sdfsd', 'sdfsdf', '2022-10-10', 'ATENDIDA', 8),
(6, 'sdfsd', 'sdfsdf', '2022-10-10', 'ATENDIDA', 12),
(7, 'czdfs', 'sdfsdf', '2022-10-11', 'ATENDIDA', 13),
(8, 'es', 'dfd', '2022-10-15', 'ATENDIDA', 14),
(9, 'Donación de Sangre', '1 Lit de sangre AB+', '2022-10-27', 'ATENDIDA', 21);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_insumo`
--

CREATE TABLE `detalle_insumo` (
  `detain_id` int(11) NOT NULL,
  `detain_cantidad` int(11) DEFAULT NULL,
  `insumo_id` int(11) DEFAULT NULL,
  `fua_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `detalle_insumo`
--

INSERT INTO `detalle_insumo` (`detain_id`, `detain_cantidad`, `insumo_id`, `fua_id`) VALUES
(1, 5, 3, 4),
(2, 3, 4, 4);

--
-- Disparadores `detalle_insumo`
--
DELIMITER $$
CREATE TRIGGER `TR_STOCK_INSUMO` AFTER INSERT ON `detalle_insumo` FOR EACH ROW BEGIN
DECLARE STOCKACTUAL DECIMAL(10,2);
SET @STOCKACTUAL:=(SELECT insumo_stock FROM insumo WHERE insumo_id=new.insumo_id);
UPDATE insumo SET
insumo_stock=@STOCKACTUAL-new.detain_cantidad
WHERE insumo_id=new.insumo_id;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_medicamento`
--

CREATE TABLE `detalle_medicamento` (
  `detame_id` int(11) NOT NULL,
  `detame_cantidad` int(11) DEFAULT NULL,
  `medicamento_id` int(11) DEFAULT NULL,
  `fua_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `detalle_medicamento`
--

INSERT INTO `detalle_medicamento` (`detame_id`, `detame_cantidad`, `medicamento_id`, `fua_id`) VALUES
(1, 1, 1, 3),
(2, 1, 3, 4),
(3, 8, 5, 4);

--
-- Disparadores `detalle_medicamento`
--
DELIMITER $$
CREATE TRIGGER `TR_STATUS_MEDICAMENTO` AFTER INSERT ON `detalle_medicamento` FOR EACH ROW BEGIN
DECLARE ESTATUS_STOCK VARCHAR(50);
SET @ESTATUS_STOCK:=(SELECT medicamento_estatus FROM medicamento WHERE medicamento_id=new.medicamento_id);
IF @ESTATUS_STOCK = 0 THEN
	UPDATE medicamento SET
	medicamento_estatus="AGOTADO"
	WHERE medicamento_stock=0 AND medicamento_id=new.medicamento_id;
	
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TR_STOCK_MEDICAMENTO` AFTER INSERT ON `detalle_medicamento` FOR EACH ROW BEGIN
DECLARE STOCKACTUAL DECIMAL(10,2);
SET @STOCKACTUAL:=(SELECT medicamento_stock FROM medicamento WHERE medicamento_id=new.medicamento_id);
UPDATE medicamento SET
medicamento_stock=@STOCKACTUAL-new.detame_cantidad
WHERE medicamento_id=new.medicamento_id;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_procedimiento`
--

CREATE TABLE `detalle_procedimiento` (
  `detaproce_id` int(11) NOT NULL,
  `procedimiento_id` int(11) DEFAULT NULL,
  `fua_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `detalle_procedimiento`
--

INSERT INTO `detalle_procedimiento` (`detaproce_id`, `procedimiento_id`, `fua_id`) VALUES
(1, 3, 4),
(2, 9, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `donaciones`
--

CREATE TABLE `donaciones` (
  `donaciones_id` int(11) NOT NULL,
  `sag_id` int(11) DEFAULT NULL,
  `volumen` float DEFAULT NULL,
  `paciente_id` int(11) DEFAULT NULL,
  `fecha_donaciones` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `donaciones`
--

INSERT INTO `donaciones` (`donaciones_id`, `sag_id`, `volumen`, `paciente_id`, `fecha_donaciones`) VALUES
(3, 1, 0.45, 1, '2022-10-10'),
(4, 1, 50, 2, '2022-10-17'),
(5, 1, 30, 5, '2022-10-11'),
(6, 1, 40, 6, '2022-10-11'),
(7, 5, 1, 7, '2022-10-27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidad`
--

CREATE TABLE `especialidad` (
  `especialidad_id` int(11) NOT NULL,
  `especialidad_nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `especialidad_fregistro` date DEFAULT NULL,
  `especialidad_estatus` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `especialidad`
--

INSERT INTO `especialidad` (`especialidad_id`, `especialidad_nombre`, `especialidad_fregistro`, `especialidad_estatus`) VALUES
(2, 'Medicina Genral', '2021-11-03', 'ACTIVO'),
(3, 'Medicina Interna', '2021-11-03', 'ACTIVO'),
(4, 'Redioterapeuta Oncólogo', '2021-11-05', 'ACTIVO'),
(5, 'Hermatólogo', '2021-11-05', 'ACTIVO'),
(6, 'Neurólogo', '2021-11-05', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fua`
--

CREATE TABLE `fua` (
  `fua_id` int(11) NOT NULL,
  `fua_fegistro` date DEFAULT NULL,
  `historia_id` int(11) DEFAULT NULL,
  `consulta_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `fua`
--

INSERT INTO `fua` (`fua_id`, `fua_fegistro`, `historia_id`, `consulta_id`) VALUES
(1, '2022-07-24', 1, 1),
(2, '2022-10-05', 1, 2),
(3, '2022-10-11', 1, 7),
(4, '2022-10-11', 1, 7),
(5, '2022-10-27', 7, 9),
(6, '2022-10-27', 7, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historia`
--

CREATE TABLE `historia` (
  `historia_id` int(11) NOT NULL,
  `paciente_id` int(11) DEFAULT NULL,
  `historia_feregistro` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `historia`
--

INSERT INTO `historia` (`historia_id`, `paciente_id`, `historia_feregistro`) VALUES
(1, 1, '2022-07-24'),
(2, 2, '2022-10-04'),
(5, 5, '2022-10-05'),
(6, 6, '2022-10-10'),
(7, 7, '2022-10-15'),
(8, 8, '2022-10-27'),
(9, 9, '2022-10-27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insumo`
--

CREATE TABLE `insumo` (
  `insumo_id` int(11) NOT NULL,
  `insumo_nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `insumo_stock` int(11) DEFAULT NULL,
  `insumo_fregistro` date DEFAULT NULL,
  `insumo_estatus` enum('ACTIVO','INACTIVO','AGOTADO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `insumo_fechf` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `insumo`
--

INSERT INTO `insumo` (`insumo_id`, `insumo_nombre`, `insumo_stock`, `insumo_fregistro`, `insumo_estatus`, `insumo_fechf`) VALUES
(1, 'GUANTES', 10, '2021-10-24', 'AGOTADO', '2022-06-09'),
(2, 'JRINGAS', 50, '2021-10-24', 'ACTIVO', '2022-07-07'),
(3, 'AGUJAS', 25, '2021-10-24', 'INACTIVO', '2022-06-09'),
(4, 'MASCARILLAS', 19, '2021-10-24', 'ACTIVO', '2022-06-07'),
(5, 'PINZAS', 12, '2021-10-24', 'ACTIVO', '2022-06-16'),
(6, 'ADHESIVOS', 10, '2021-10-24', 'INACTIVO', '2022-06-09'),
(11, 'VENDA', 15, '2021-10-25', 'ACTIVO', '2022-06-22'),
(12, 'Tapa Bocas', 2, '2022-03-27', 'ACTIVO', '2022-06-08'),
(13, 'GASAS', 10, '2022-03-27', 'ACTIVO', '2022-06-08'),
(14, 'Jeringa', 12, '2022-06-09', 'ACTIVO', '2022-06-15'),
(15, 'Jeringas', 23, '2022-06-09', 'ACTIVO', '2023-06-08');

--
-- Disparadores `insumo`
--
DELIMITER $$
CREATE TRIGGER `TR_AUDI_INS` AFTER UPDATE ON `insumo` FOR EACH ROW INSERT INTO auditoria(usu_id,fecha,accion,usu_nombre)
VALUES (usu_id,NOW(),"Se modifico un nuevo insumo",usu_nombre)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicamento`
--

CREATE TABLE `medicamento` (
  `medicamento_id` int(11) NOT NULL,
  `medicamento_nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medicamento_alias` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medicamento_stock` int(11) DEFAULT NULL,
  `medicamento_fregistro` date DEFAULT NULL,
  `medicamento_estatus` enum('ACTIVO','INACTIVO','AGOTADO','ELIMINADO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `medicamento_fechf` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `medicamento`
--

INSERT INTO `medicamento` (`medicamento_id`, `medicamento_nombre`, `medicamento_alias`, `medicamento_stock`, `medicamento_fregistro`, `medicamento_estatus`, `medicamento_fechf`) VALUES
(1, 'Loratadina', 'vera', 19, '2022-03-30', 'AGOTADO', '2022-06-09'),
(2, 'somatostatina', 'soma', 29, '2022-03-30', 'AGOTADO', '2022-06-29'),
(3, 'paracetamol', 'para', 29, '2022-03-30', 'AGOTADO', '2022-06-29'),
(4, 'verapamilloo', 've', 10, '2022-04-01', 'AGOTADO', '2022-06-29'),
(5, 'ibuprofeno', 'ibu', 32, '2022-04-01', 'AGOTADO', '2022-06-30'),
(6, 'acetaminofen', 'ace', 36, '2022-04-01', 'AGOTADO', '2022-06-28'),
(7, 'esomepraxol', 'eso', 45, '2022-06-10', 'AGOTADO', '2022-06-28'),
(8, 'losatan', 'lo', 26, '2022-06-10', 'AGOTADO', '2022-06-17'),
(9, 'valtasa', 'val', 26, '2022-06-10', 'AGOTADO', '2022-06-09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medico`
--

CREATE TABLE `medico` (
  `medico_id` int(11) NOT NULL,
  `medico_nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_apepart` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_apemart` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_direccion` varchar(200) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_movil` char(12) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_sexo` char(1) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_fenac` date DEFAULT NULL,
  `medico_nrodocumento` char(12) COLLATE utf8_spanish_ci DEFAULT NULL,
  `medico_colegiatura` char(12) COLLATE utf8_spanish_ci DEFAULT NULL,
  `especialidad_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `sag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `medico`
--

INSERT INTO `medico` (`medico_id`, `medico_nombre`, `medico_apepart`, `medico_apemart`, `medico_direccion`, `medico_movil`, `medico_sexo`, `medico_fenac`, `medico_nrodocumento`, `medico_colegiatura`, `especialidad_id`, `usu_id`, `sag_id`) VALUES
(1, 'Andrea', 'Nieto', 'Contreras', 'Las flores', '04162204090', 'F', '1990-05-07', '10749525', '2222222', 2, 3, 2),
(2, 'Desiree', 'Sanchez', 'Valero', 'las castra', '04246338650', 'F', '1998-11-09', '26309450', '2233333', 3, 4, 5),
(3, 'Laura', 'Colmenares', 'Palomo', 'cordero', '04147589654', 'F', '1995-04-12', '145896666', '25566', 4, 5, 5),
(4, 'Arfilio', 'Mora', 'Vivas', 'pirineos ', '04147895623', 'M', '1856-02-04', '201445555', '55555', 5, 6, 4),
(5, 'Laura', 'Colmerares', 'k', 'la castra', '04147562355', 'F', '1756-01-02', '14568896', '44444', 6, 7, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `paciente_id` int(11) NOT NULL,
  `paciente_nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_apepat` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_apemat` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_direccion` varchar(200) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_movil` char(12) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_sexo` char(1) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_fenac` date DEFAULT NULL,
  `paciente_nrodocumento` char(12) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_estatus` enum('ACTIVO','INACTIVO','ELIMINADO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `sag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`paciente_id`, `paciente_nombre`, `paciente_apepat`, `paciente_apemat`, `paciente_direccion`, `paciente_movil`, `paciente_sexo`, `paciente_fenac`, `paciente_nrodocumento`, `paciente_estatus`, `sag_id`) VALUES
(1, 'Celina', 'Contreras', 'Valero', 'Las Flores', '04246338650', 'M', '1978-01-03', '10749525', 'ACTIVO', 1),
(2, 'andrew', 'contreras', 'valero', 'las flores', '04246338650', 'M', '2022-10-03', '26309450', 'ACTIVO', 4),
(5, 'Ulianoff', 'Alcantara', 'Diaz', 'La concordia', '04143761186', 'M', '1977-09-05', '13708750', 'ACTIVO', 7),
(6, 'sdfsdfs', 'sdfsd', 'dsfs', 'dfsdf', '23242453', 'M', '2022-10-12', '23234', 'ACTIVO', 5),
(7, 'Edudaris', 'gonzales', 'gomez', 'la concordia', '04162204090', 'F', '2000-04-03', '30908340', 'ACTIVO', 6),
(8, 'FERNANDO', 'TORRES', 'ESPINOZA', 'AV SAN FELIPE', '0457888888', 'M', '2002-09-17', '29699756', 'ACTIVO', 8),
(9, 'Omar', 'Escobar', 'Gabilla', 'Orden de malta', '9999999999', 'F', '2022-02-27', '29887665', 'ACTIVO', 2);

--
-- Disparadores `paciente`
--
DELIMITER $$
CREATE TRIGGER `TR_AUDI_PACIT` AFTER UPDATE ON `paciente` FOR EACH ROW INSERT INTO auditoria(usu_id,fecha,accion)
VALUES (CURRENT_USER(),NOW(),"Se modifico un nuevo paciente")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TR_CREAR_HISTORIA` AFTER INSERT ON `paciente` FOR EACH ROW INSERT INTO 
historia(paciente_id,historia_feregistro)
VALUES (new.paciente_id,curdate())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procedimiento`
--

CREATE TABLE `procedimiento` (
  `procedimiento_id` int(11) NOT NULL,
  `procedimiento_nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `procedimiento_fecregistro` date DEFAULT NULL,
  `procedimiento_estatus` enum('ACTIVO','INACTIVO','ELIMINADO') COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `procedimiento`
--

INSERT INTO `procedimiento` (`procedimiento_id`, `procedimiento_nombre`, `procedimiento_fecregistro`, `procedimiento_estatus`) VALUES
(1, 'chequeo', '2021-10-24', 'INACTIVO'),
(2, 'Inspección médica', '2021-10-24', 'ACTIVO'),
(3, 'Palpación', '2021-10-24', 'ACTIVO'),
(4, 'Percusión(médica)', '2021-10-24', 'ACTIVO'),
(5, 'Medición de signos vitales', '2021-10-24', 'ACTIVO'),
(6, 'Electromiografia', '2021-10-24', 'ACTIVO'),
(7, 'Electrocardiografia', '2021-10-24', 'ACTIVO'),
(8, 'Masaje', '2021-10-24', 'ACTIVO'),
(9, 'Donación', '2022-03-26', 'ACTIVO'),
(10, 'palpasión', '2022-03-26', 'ACTIVO'),
(11, 'loca', '2022-03-26', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `rol_id` int(11) NOT NULL,
  `rol_nombre` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `rol_nombre`) VALUES
(1, 'ADMINISTRADOR'),
(2, 'RECEPCIONISTA'),
(3, 'MEDICO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sangre`
--

CREATE TABLE `sangre` (
  `sag_id` int(11) NOT NULL,
  `tp_sangre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `sangre`
--

INSERT INTO `sangre` (`sag_id`, `tp_sangre`) VALUES
(2, 'A-'),
(1, 'A+'),
(6, 'AB-'),
(5, 'AB+'),
(4, 'B-'),
(3, 'B+'),
(8, 'O-'),
(7, 'O+');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitud_sangre`
--

CREATE TABLE `solicitud_sangre` (
  `pedido_id` int(11) NOT NULL,
  `codi_refern` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente` text COLLATE utf8_spanish_ci DEFAULT NULL,
  `tp_sangre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `volumen` float DEFAULT NULL,
  `nombre_medico` int(11) DEFAULT NULL,
  `estatus` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha_pedido` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `usu_id` int(11) NOT NULL,
  `usu_nombre` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_contrasena` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_sexo` char(1) COLLATE utf8_spanish_ci DEFAULT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `usu_estatus` enum('ACTIVO','INATIVO','ELIMINADO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_email` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_intento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`usu_id`, `usu_nombre`, `usu_contrasena`, `usu_sexo`, `rol_id`, `usu_estatus`, `usu_email`, `usu_intento`) VALUES
(1, 'vero', '$2y$10$GU9cYfZJT/Z9Twm8EA8VBu/eS8PFTx5Rn5g5ml9YE5cFjlCo3rfOa', 'F', 1, 'ACTIVO', '', 0),
(2, 'RG', '$2y$10$e3Rl3YNnCbJQjKojVjKXIOkTNX.t74BEh9e3mgw.QrlDm6TnUZbha', 'F', 3, 'ACTIVO', 'gcrisleytahiry@gmail.com', 1),
(3, 'andrea', '$2y$10$.IiylTyhIQq2TgN6nyxJCeDh2VdmBZ2o9adTMZRyxLuyTEDf6Tfqu', 'F', 3, 'ACTIVO', 'andrea@gmail.com', 0),
(4, 'andrew', '$2y$10$vLQ96JvlLdsfepupggi9ru.eRJk19/6/az4/8HiAKouKe7eRdrm0O', 'F', 3, 'ACTIVO', 'andrew.contrera2012@gmail.com', 0),
(5, 'Laura', '$2y$10$AfmsvWjA0L/8txiW.AjC9.JyZcUWob3b3YfaMapHRgEcrgrEHh4ey', 'F', 3, 'ACTIVO', 'laura@gmail.com', 0),
(6, 'arfilio', '$2y$10$8egnBpyLMaYZPri1EJr89e2fD0pW1hVWBIsk6mOce0FCHqc52HqBG', 'M', 3, 'ELIMINADO', 'arfilio@gmail.com', 0),
(7, 'lau', '$2y$10$afUr56BHTFtYZ5kaA1jdeuii75mPBjtJ9jAKX810wxJ.VEK09r1Wy', 'F', 3, 'ELIMINADO', 'lau@gmail.com', 0);

--
-- Disparadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `TRIGGER_INSERT_USUARIO` AFTER INSERT ON `usuario` FOR EACH ROW INSERT INTO auditoria(usu_id,fecha,accion,usu_nombre)
VALUES (new.usu_id,NOW(),"Se inserto un nuevo usuario",new.usu_nombre)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TR_DELETE_USUARIO` AFTER DELETE ON `usuario` FOR EACH ROW INSERT INTO auditoria(usu_id,fecha,accion)
VALUES (CURRENT_USER(),NOW(),"Se ha eliminado un nuevo usuario")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TR_UPDATE_USUARIO` AFTER UPDATE ON `usuario` FOR EACH ROW INSERT INTO auditoria(usu_id,fecha,accion,usu_nombre)
VALUES (new.usu_id,NOW(),"Se modifico un nuevo usuario",new.usu_nombre)
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`audi_id`) USING BTREE,
  ADD KEY `usu_id` (`usu_id`);

--
-- Indices de la tabla `cita`
--
ALTER TABLE `cita`
  ADD PRIMARY KEY (`cita_id`) USING BTREE,
  ADD KEY `paciente_id` (`paciente_id`) USING BTREE,
  ADD KEY `medico_id` (`medico_id`) USING BTREE,
  ADD KEY `especialidad_id` (`especialidad_id`) USING BTREE,
  ADD KEY `usu_id` (`usu_id`) USING BTREE;

--
-- Indices de la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD PRIMARY KEY (`consulta_id`) USING BTREE,
  ADD KEY `cita_id` (`cita_id`) USING BTREE;

--
-- Indices de la tabla `detalle_insumo`
--
ALTER TABLE `detalle_insumo`
  ADD PRIMARY KEY (`detain_id`) USING BTREE,
  ADD KEY `fua_id` (`fua_id`) USING BTREE,
  ADD KEY `insumo_id` (`insumo_id`) USING BTREE;

--
-- Indices de la tabla `detalle_medicamento`
--
ALTER TABLE `detalle_medicamento`
  ADD PRIMARY KEY (`detame_id`) USING BTREE,
  ADD KEY `medicamento_id` (`medicamento_id`) USING BTREE,
  ADD KEY `fua_id` (`fua_id`) USING BTREE;

--
-- Indices de la tabla `detalle_procedimiento`
--
ALTER TABLE `detalle_procedimiento`
  ADD PRIMARY KEY (`detaproce_id`) USING BTREE,
  ADD KEY `fua_id` (`fua_id`) USING BTREE,
  ADD KEY `procedimiento_id` (`procedimiento_id`) USING BTREE;

--
-- Indices de la tabla `donaciones`
--
ALTER TABLE `donaciones`
  ADD PRIMARY KEY (`donaciones_id`) USING BTREE,
  ADD KEY `sag_id` (`sag_id`),
  ADD KEY `paciente_id` (`paciente_id`);

--
-- Indices de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  ADD PRIMARY KEY (`especialidad_id`) USING BTREE;

--
-- Indices de la tabla `fua`
--
ALTER TABLE `fua`
  ADD PRIMARY KEY (`fua_id`) USING BTREE,
  ADD KEY `historia_id` (`historia_id`) USING BTREE,
  ADD KEY `consulta_id` (`consulta_id`) USING BTREE;

--
-- Indices de la tabla `historia`
--
ALTER TABLE `historia`
  ADD PRIMARY KEY (`historia_id`) USING BTREE,
  ADD KEY `paciente_id` (`paciente_id`) USING BTREE;

--
-- Indices de la tabla `insumo`
--
ALTER TABLE `insumo`
  ADD PRIMARY KEY (`insumo_id`) USING BTREE;

--
-- Indices de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  ADD PRIMARY KEY (`medicamento_id`) USING BTREE;

--
-- Indices de la tabla `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`medico_id`) USING BTREE,
  ADD KEY `usu_id` (`usu_id`) USING BTREE,
  ADD KEY `FK_especialidad` (`especialidad_id`) USING BTREE,
  ADD KEY `sag_id` (`sag_id`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`paciente_id`) USING BTREE,
  ADD KEY `sag_id` (`sag_id`);

--
-- Indices de la tabla `procedimiento`
--
ALTER TABLE `procedimiento`
  ADD PRIMARY KEY (`procedimiento_id`) USING BTREE;

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`rol_id`) USING BTREE;

--
-- Indices de la tabla `sangre`
--
ALTER TABLE `sangre`
  ADD PRIMARY KEY (`sag_id`) USING BTREE,
  ADD KEY `tp_sangre` (`tp_sangre`);

--
-- Indices de la tabla `solicitud_sangre`
--
ALTER TABLE `solicitud_sangre`
  ADD PRIMARY KEY (`pedido_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`usu_id`) USING BTREE,
  ADD KEY `rol_id` (`rol_id`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `audi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=213;

--
-- AUTO_INCREMENT de la tabla `cita`
--
ALTER TABLE `cita`
  MODIFY `cita_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `consulta`
--
ALTER TABLE `consulta`
  MODIFY `consulta_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `detalle_insumo`
--
ALTER TABLE `detalle_insumo`
  MODIFY `detain_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `detalle_medicamento`
--
ALTER TABLE `detalle_medicamento`
  MODIFY `detame_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detalle_procedimiento`
--
ALTER TABLE `detalle_procedimiento`
  MODIFY `detaproce_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `donaciones`
--
ALTER TABLE `donaciones`
  MODIFY `donaciones_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  MODIFY `especialidad_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `fua`
--
ALTER TABLE `fua`
  MODIFY `fua_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `historia`
--
ALTER TABLE `historia`
  MODIFY `historia_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `insumo`
--
ALTER TABLE `insumo`
  MODIFY `insumo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  MODIFY `medicamento_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `medico`
--
ALTER TABLE `medico`
  MODIFY `medico_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `paciente_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `procedimiento`
--
ALTER TABLE `procedimiento`
  MODIFY `procedimiento_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `sangre`
--
ALTER TABLE `sangre`
  MODIFY `sag_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cita`
--
ALTER TABLE `cita`
  ADD CONSTRAINT `cita_ibfk_1` FOREIGN KEY (`medico_id`) REFERENCES `medico` (`medico_id`),
  ADD CONSTRAINT `cita_ibfk_2` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`especialidad_id`),
  ADD CONSTRAINT `cita_ibfk_3` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`paciente_id`),
  ADD CONSTRAINT `cita_ibfk_4` FOREIGN KEY (`usu_id`) REFERENCES `usuario` (`usu_id`);

--
-- Filtros para la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD CONSTRAINT `consulta_ibfk_1` FOREIGN KEY (`cita_id`) REFERENCES `cita` (`cita_id`);

--
-- Filtros para la tabla `detalle_insumo`
--
ALTER TABLE `detalle_insumo`
  ADD CONSTRAINT `detalle_insumo_ibfk_1` FOREIGN KEY (`insumo_id`) REFERENCES `insumo` (`insumo_id`),
  ADD CONSTRAINT `detalle_insumo_ibfk_2` FOREIGN KEY (`fua_id`) REFERENCES `fua` (`fua_id`);

--
-- Filtros para la tabla `detalle_medicamento`
--
ALTER TABLE `detalle_medicamento`
  ADD CONSTRAINT `detalle_medicamento_ibfk_1` FOREIGN KEY (`medicamento_id`) REFERENCES `medicamento` (`medicamento_id`),
  ADD CONSTRAINT `detalle_medicamento_ibfk_2` FOREIGN KEY (`fua_id`) REFERENCES `fua` (`fua_id`);

--
-- Filtros para la tabla `detalle_procedimiento`
--
ALTER TABLE `detalle_procedimiento`
  ADD CONSTRAINT `detalle_procedimiento_ibfk_1` FOREIGN KEY (`procedimiento_id`) REFERENCES `procedimiento` (`procedimiento_id`),
  ADD CONSTRAINT `detalle_procedimiento_ibfk_2` FOREIGN KEY (`fua_id`) REFERENCES `fua` (`fua_id`);

--
-- Filtros para la tabla `donaciones`
--
ALTER TABLE `donaciones`
  ADD CONSTRAINT `donaciones_ibfk_1` FOREIGN KEY (`sag_id`) REFERENCES `sangre` (`sag_id`),
  ADD CONSTRAINT `donaciones_ibfk_2` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`paciente_id`);

--
-- Filtros para la tabla `fua`
--
ALTER TABLE `fua`
  ADD CONSTRAINT `fua_ibfk_1` FOREIGN KEY (`historia_id`) REFERENCES `historia` (`historia_id`),
  ADD CONSTRAINT `fua_ibfk_2` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`consulta_id`);

--
-- Filtros para la tabla `historia`
--
ALTER TABLE `historia`
  ADD CONSTRAINT `historia_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`paciente_id`);

--
-- Filtros para la tabla `medico`
--
ALTER TABLE `medico`
  ADD CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`especialidad_id`),
  ADD CONSTRAINT `medico_ibfk_2` FOREIGN KEY (`usu_id`) REFERENCES `usuario` (`usu_id`),
  ADD CONSTRAINT `medico_ibfk_3` FOREIGN KEY (`sag_id`) REFERENCES `sangre` (`sag_id`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`sag_id`) REFERENCES `sangre` (`sag_id`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
