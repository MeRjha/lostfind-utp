CREATE DATABASE  IF NOT EXISTS `bd_lostfind` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bd_lostfind`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: bd_lostfind
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `coincidencia`
--

DROP TABLE IF EXISTS `coincidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coincidencia` (
  `idCoincidencia` int NOT NULL AUTO_INCREMENT,
  `idObjetoPerdido` int NOT NULL,
  `idObjetoEncontrado` int NOT NULL,
  `porcentajeSimilitud` double NOT NULL,
  `fechaGeneracion` date NOT NULL,
  PRIMARY KEY (`idCoincidencia`),
  KEY `idObjetoPerdido` (`idObjetoPerdido`),
  KEY `idObjetoEncontrado` (`idObjetoEncontrado`),
  CONSTRAINT `coincidencia_ibfk_1` FOREIGN KEY (`idObjetoPerdido`) REFERENCES `objeto_perdido` (`idObjetoPerdido`),
  CONSTRAINT `coincidencia_ibfk_2` FOREIGN KEY (`idObjetoEncontrado`) REFERENCES `objeto_encontrado` (`idObjetoEncontrado`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coincidencia`
--

LOCK TABLES `coincidencia` WRITE;
/*!40000 ALTER TABLE `coincidencia` DISABLE KEYS */;
INSERT INTO `coincidencia` VALUES (1,1,1,95.5,'2026-10-21');
/*!40000 ALTER TABLE `coincidencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evidencia_reclamo`
--

DROP TABLE IF EXISTS `evidencia_reclamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evidencia_reclamo` (
  `idEvidencia` int NOT NULL AUTO_INCREMENT,
  `idSolicitud` int NOT NULL,
  `urlArchivo` varchar(255) NOT NULL,
  `fechaSubida` date NOT NULL,
  PRIMARY KEY (`idEvidencia`),
  KEY `idSolicitud` (`idSolicitud`),
  CONSTRAINT `evidencia_reclamo_ibfk_1` FOREIGN KEY (`idSolicitud`) REFERENCES `solicitud_reclamo` (`idSolicitud`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidencia_reclamo`
--

LOCK TABLES `evidencia_reclamo` WRITE;
/*!40000 ALTER TABLE `evidencia_reclamo` DISABLE KEYS */;
INSERT INTO `evidencia_reclamo` VALUES (1,1,'evidencias/celular.jpg','2026-10-22');
/*!40000 ALTER TABLE `evidencia_reclamo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacion`
--

DROP TABLE IF EXISTS `notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacion` (
  `idNotificacion` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `fechaEnvio` date NOT NULL,
  `leida` tinyint(1) NOT NULL,
  PRIMARY KEY (`idNotificacion`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `notificacion_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (1,1,'Se encontro una posible coincidencia con tu objeto perdido','2026-10-22',0);
/*!40000 ALTER TABLE `notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objeto`
--

DROP TABLE IF EXISTS `objeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objeto` (
  `idObjeto` int NOT NULL AUTO_INCREMENT,
  `idSede` int NOT NULL,
  `imagen` varchar(100) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `lugarReferencia` varchar(150) DEFAULT NULL,
  `fechaRegistro` date NOT NULL,
  `estado` varchar(30) NOT NULL,
  PRIMARY KEY (`idObjeto`),
  KEY `idSede` (`idSede`),
  CONSTRAINT `objeto_ibfk_1` FOREIGN KEY (`idSede`) REFERENCES `sede` (`idSede`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto`
--

LOCK TABLES `objeto` WRITE;
/*!40000 ALTER TABLE `objeto` DISABLE KEYS */;
INSERT INTO `objeto` VALUES (1,1,'Imagenes/mochilaEncontrada.jfif','Mochilas','Mochila','Negro','Lubaishigi','Mochila negra con franjas rojas','Biblioteca','2026-10-20','PERDIDO'),(2,1,'','Tecnologia','Celular','Negro','Samsung','Celular encontrado sobre una mesa','Biblioteca','2026-10-21','ENCONTRADO'),(3,1,'Imagenes/celularEncontrado.jfif','Tecnologia','Celular','Azul','Samsung','Celular azul con funda transparente','Cafeteria','2026-10-21','PERDIDO'),(4,1,'Imagenes/audifonosEncontrados.jfif','Accesorios','Audifonos','Blanco','JBL','Audifonos inalambricos blancos con estuche','Laboratorio de computo','2026-10-22','PERDIDO'),(5,1,'Imagenes/billeteraEncontrada.jfif','Accesorios','Billetera','Marron','Renzo Costa','Billetera de cuero marron con documentos personales','Patio principal','2026-10-23','PERDIDO'),(6,1,'Imagenes/laptopEncontrada.jfif','Tecnologia','Laptop','Gris','Lenovo','Laptop gris con pegatina en la tapa','Aula B203','2026-10-24','PERDIDO');
/*!40000 ALTER TABLE `objeto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objeto_encontrado`
--

DROP TABLE IF EXISTS `objeto_encontrado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objeto_encontrado` (
  `idObjetoEncontrado` int NOT NULL AUTO_INCREMENT,
  `idObjeto` int NOT NULL,
  `idPersonalSAE` int NOT NULL,
  `fechaHallazgo` date NOT NULL,
  `ubicacionCustodia` varchar(150) NOT NULL,
  PRIMARY KEY (`idObjetoEncontrado`),
  KEY `idObjeto` (`idObjeto`),
  KEY `idPersonalSAE` (`idPersonalSAE`),
  CONSTRAINT `objeto_encontrado_ibfk_1` FOREIGN KEY (`idObjeto`) REFERENCES `objeto` (`idObjeto`),
  CONSTRAINT `objeto_encontrado_ibfk_2` FOREIGN KEY (`idPersonalSAE`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto_encontrado`
--

LOCK TABLES `objeto_encontrado` WRITE;
/*!40000 ALTER TABLE `objeto_encontrado` DISABLE KEYS */;
INSERT INTO `objeto_encontrado` VALUES (1,1,2,'2026-10-21','Oficina SAE'),(2,3,2,'2026-10-21','Oficina SAE'),(3,4,2,'2026-10-23','Oficina SAE'),(4,5,2,'2026-10-24','Oficina SAE'),(5,6,2,'2026-10-20','Oficina SAE');
/*!40000 ALTER TABLE `objeto_encontrado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objeto_perdido`
--

DROP TABLE IF EXISTS `objeto_perdido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objeto_perdido` (
  `idObjetoPerdido` int NOT NULL AUTO_INCREMENT,
  `idObjeto` int NOT NULL,
  `idUsuario` int NOT NULL,
  `fechaPerdida` date NOT NULL,
  PRIMARY KEY (`idObjetoPerdido`),
  KEY `idObjeto` (`idObjeto`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `objeto_perdido_ibfk_1` FOREIGN KEY (`idObjeto`) REFERENCES `objeto` (`idObjeto`),
  CONSTRAINT `objeto_perdido_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto_perdido`
--

LOCK TABLES `objeto_perdido` WRITE;
/*!40000 ALTER TABLE `objeto_perdido` DISABLE KEYS */;
INSERT INTO `objeto_perdido` VALUES (1,2,1,'2026-10-19');
/*!40000 ALTER TABLE `objeto_perdido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede`
--

DROP TABLE IF EXISTS `sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede` (
  `idSede` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(150) NOT NULL,
  PRIMARY KEY (`idSede`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede`
--

LOCK TABLES `sede` WRITE;
/*!40000 ALTER TABLE `sede` DISABLE KEYS */;
INSERT INTO `sede` VALUES (1,'UTP Lima Sur','Villa El Salvador');
/*!40000 ALTER TABLE `sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitud_reclamo`
--

DROP TABLE IF EXISTS `solicitud_reclamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitud_reclamo` (
  `idSolicitud` int NOT NULL AUTO_INCREMENT,
  `idObjetoEncontrado` int NOT NULL,
  `idUsuario` int NOT NULL,
  `idPersonalSAE` int DEFAULT NULL,
  `fechaSolicitud` date NOT NULL,
  `sustentoPropiedad` varchar(255) NOT NULL,
  `estado` varchar(30) NOT NULL,
  PRIMARY KEY (`idSolicitud`),
  KEY `idObjetoEncontrado` (`idObjetoEncontrado`),
  KEY `idUsuario` (`idUsuario`),
  KEY `idPersonalSAE` (`idPersonalSAE`),
  CONSTRAINT `solicitud_reclamo_ibfk_1` FOREIGN KEY (`idObjetoEncontrado`) REFERENCES `objeto_encontrado` (`idObjetoEncontrado`),
  CONSTRAINT `solicitud_reclamo_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `solicitud_reclamo_ibfk_3` FOREIGN KEY (`idPersonalSAE`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitud_reclamo`
--

LOCK TABLES `solicitud_reclamo` WRITE;
/*!40000 ALTER TABLE `solicitud_reclamo` DISABLE KEYS */;
INSERT INTO `solicitud_reclamo` VALUES (1,1,1,NULL,'2026-10-22','El celular tiene una funda negra','PENDIENTE');
/*!40000 ALTER TABLE `solicitud_reclamo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `correoInstitucional` varchar(100) NOT NULL,
  `contraseña` varchar(255) NOT NULL,
  `fotoPerfil` varchar(255) NOT NULL,
  `rol` varchar(20) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  `idSede` int NOT NULL,
  PRIMARY KEY (`idUsuario`),
  KEY `idSede` (`idSede`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idSede`) REFERENCES `sede` (`idSede`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Axel','Chumpitaz','u24228040@utp.edu.pe','Loquesea123@','Imagenes/descarga.jfif','Estudiante',1,1),(2,'Carlos','Perez','carlos@utp.edu.pe','Demo1234','Imagenes/descarga.jfif','Estudiante',1,1),(3,'Maria','Lopez','maria@utp.edu.pe','Demo1234','Imagenes/descarga.jfif','PersonalSae',1,1),(4,'Luis','Torres','luis@utp.edu.pe','Demo1234','Imagenes/descarga.jfif','Docente',1,1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-24 21:42:21
