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
  `fechaGeneracion` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`idCoincidencia`),
  KEY `idObjetoPerdido` (`idObjetoPerdido`),
  KEY `idObjetoEncontrado` (`idObjetoEncontrado`),
  CONSTRAINT `coincidencia_ibfk_1` FOREIGN KEY (`idObjetoPerdido`) REFERENCES `objeto_perdido` (`idObjetoPerdido`),
  CONSTRAINT `coincidencia_ibfk_2` FOREIGN KEY (`idObjetoEncontrado`) REFERENCES `objeto_encontrado` (`idObjetoEncontrado`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coincidencia`
--

LOCK TABLES `coincidencia` WRITE;
/*!40000 ALTER TABLE `coincidencia` DISABLE KEYS */;
INSERT INTO `coincidencia` VALUES (1,1,1,96.24,'2026-10-22'),(2,2,3,94.18,'2026-10-23'),(3,2,24,81.34,'2026-10-26'),(4,3,6,93.57,'2026-10-24'),(5,18,14,90.11,'2026-10-25'),(6,4,4,89.43,'2026-10-20'),(7,5,5,91.26,'2026-10-21'),(8,6,12,95.12,'2026-10-22'),(9,7,14,94.05,'2026-10-24'),(10,8,17,92.44,'2026-10-26'),(11,9,11,88.94,'2026-10-21'),(12,10,28,90.15,'2026-10-26'),(13,12,7,91.42,'2026-10-22'),(14,14,13,95.66,'2026-10-23'),(15,15,22,89.21,'2026-10-25'),(16,16,8,92.08,'2026-10-23');
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
  `fechaRegistro` date NOT NULL DEFAULT (curdate()),
  `estado` varchar(30) NOT NULL,
  PRIMARY KEY (`idObjeto`),
  KEY `idSede` (`idSede`),
  CONSTRAINT `objeto_ibfk_1` FOREIGN KEY (`idSede`) REFERENCES `sede` (`idSede`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto`
--

LOCK TABLES `objeto` WRITE;
/*!40000 ALTER TABLE `objeto` DISABLE KEYS */;
INSERT INTO `objeto` VALUES (1,1,'Imagenes/celular_samsung_negro.jpg','Tecnologia','Celular','Negro','Samsung','Celular negro con funda oscura y desgaste en un borde','Biblioteca, mesa de lectura','2026-10-21','ENCONTRADO'),(2,1,'Imagenes/celular_samsung_negro.jpg','Tecnologia','Celular','Negro','Samsung','Celular Samsung negro con funda oscura y una esquina marcada','Biblioteca, pabellon B','2026-10-20','PERDIDO'),(3,1,'Imagenes/celular_samsung_azul.jpg','Tecnologia','Celular','Azul','Samsung','Celular azul con protector transparente y pequena raya atras','Cafeteria, junto a ventana','2026-10-22','ENCONTRADO'),(4,1,'Imagenes/audifonos_jbl_blancos.jpg','Accesorios','Audifonos','Blanco','JBL','Audifonos inalambricos blancos con estuche de carga','Laboratorio de computo B302','2026-10-22','ENCONTRADO'),(5,1,'Imagenes/billetera_marron.jpg','Accesorios','Billetera','Marron','Sin marca','Billetera de cuero marron con doble compartimento','Patio principal, banca central','2026-10-19','ENCONTRADO'),(6,1,'Imagenes/laptop_lenovo_gris.jpg','Tecnologia','Laptop','Gris','Lenovo','Laptop gris de tamano mediano con funda negra','Aula B203, primera fila','2026-10-20','ENCONTRADO'),(7,1,'Imagenes/mochila_adidas_negra.jpg','Mochilas','Mochila','Negro','Adidas','Mochila negra deportiva con cierre frontal y llavero colgante','Pabellon B, segundo piso','2026-10-23','ENCONTRADO'),(8,1,'Imagenes/celular_xiaomi_azul.jpg','Tecnologia','Celular','Azul','Xiaomi','Celular azul Xiaomi con mica transparente','Cafeteria, zona de bandejas','2026-10-21','ENCONTRADO'),(9,1,'Imagenes/audifonos_sony_negros.jpg','Accesorios','Audifonos','Negro','Sony','Audifonos de diadema negros con almohadillas grandes','Biblioteca, estante lateral','2026-10-22','ENCONTRADO'),(10,1,'Imagenes/laptop_hp_plateada.jpg','Tecnologia','Laptop','Plateado','HP','Laptop plateada con funda de tela negra','Laboratorio de computo A204','2026-10-23','ENCONTRADO'),(11,1,'Imagenes/billetera_negra.jpg','Accesorios','Billetera','Negro','Sin marca','Billetera negra delgada con varios compartimentos','Patio principal, cerca de escaleras','2026-10-24','ENCONTRADO'),(12,1,'Imagenes/cartuchera_roja.jpg','Utiles','Cartuchera','Rojo','Faber Castell','Cartuchera roja con lapiceros y un resaltador','Aula B203, carpeta del fondo','2026-10-20','ENCONTRADO'),(13,1,'Imagenes/termo_stanley_plateado.jpg','Accesorios','Termo','Plateado','Stanley','Termo de acero plateado con tapa negra','Cafeteria, barra de bebidas','2026-10-21','ENCONTRADO'),(14,1,'Imagenes/cargador_apple_blanco.jpg','Tecnologia','Cargador','Blanco','Apple','Adaptador blanco con cable USB-C enrollado','Biblioteca, mesa 6','2026-10-22','ENCONTRADO'),(15,1,'Imagenes/llaves_llavero_azul.jpg','Accesorios','Llaves','Plateado','Sin marca','Tres llaves metalicas con llavero de color azul','Entrada principal, porteria','2026-10-23','ENCONTRADO'),(16,1,'Imagenes/cuaderno_norma_rojo.jpg','Utiles','Cuaderno','Rojo','Norma','Cuaderno universitario rojo de espiral','Aula A105, carpeta 12','2026-10-24','ENCONTRADO'),(17,1,'Imagenes/paraguas_verde.jpg','Accesorios','Paraguas','Verde','Sin marca','Paraguas verde plegable con mango oscuro','Entrada del pabellon B','2026-10-25','ENCONTRADO'),(18,1,'Imagenes/usb_kingston_azul.jpg','Tecnologia','Memoria USB','Azul','Kingston','Memoria USB azul de 64 GB con tapa','Laboratorio de computo C102','2026-10-25','ENCONTRADO'),(19,1,'Imagenes/lentes_negros.jpg','Accesorios','Lentes','Negro','Sin marca','Lentes de montura negra con estuche rigido','Biblioteca, area de lectura','2026-10-23','ENCONTRADO'),(20,1,'Imagenes/reloj_casio_negro.jpg','Accesorios','Reloj','Negro','Casio','Reloj digital con correa negra de goma','Patio principal, banca','2026-10-24','ENCONTRADO'),(21,1,'Imagenes/casaca_nike_negra.jpg','Ropa','Casaca','Negro','Nike','Casaca deportiva negra con cierre delantero','Aula C301, respaldo de silla','2026-10-25','ENCONTRADO'),(22,1,'Imagenes/audifonos_jbl_blancos.jpg','Accesorios','Audifonos','Blanco','JBL','Audifonos blancos JBL y estuche de carga con marcas de uso','Laboratorio de computo B302','2026-10-21','PERDIDO'),(23,1,'Imagenes/mochila_adidas_negra.jpg','Mochilas','Mochila','Negro','Adidas','Mochila negra Adidas con cierre frontal y llavero pequeno','Pabellon B, Aula B204','2026-10-22','PERDIDO'),(24,1,'Imagenes/mochila_puma_azul.jpg','Mochilas','Mochila','Azul','Puma','Mochila azul con bolsillo exterior y dos tirantes','Pabellon A, pasillo principal','2026-10-22','ENCONTRADO'),(25,1,'Imagenes/mochila_negra_simple.jpg','Mochilas','Mochila','Negro','Sin marca','Mochila negra lisa con dos cierres y sin logotipo','Biblioteca, casilleros','2026-10-24','ENCONTRADO'),(26,1,'Imagenes/celular_motorola_negro.jpg','Tecnologia','Celular','Negro','Motorola','Celular negro sin funda con camara circular','Pabellon C, pasillo','2026-10-24','ENCONTRADO'),(27,1,'Imagenes/audifonos_blancos_estuche.jpg','Accesorios','Audifonos','Blanco','JBL','Auriculares blancos con estuche ovalado y una mancha','Patio principal, mesa de espera','2026-10-25','ENCONTRADO'),(28,1,'Imagenes/termo_stanley_negro.jpg','Accesorios','Termo','Negro','Stanley','Termo negro de acero con tapa roscada','Aula B303, junto al proyector','2026-10-25','ENCONTRADO'),(29,1,'Imagenes/cartuchera_azul.jpg','Utiles','Cartuchera','Azul','Sin marca','Cartuchera azul de tela con cierre largo','Aula A105, ultima fila','2026-10-25','ENCONTRADO'),(30,1,'Imagenes/laptop_lenovo_negra.jpg','Tecnologia','Laptop','Negro','Lenovo','Portatil negro Lenovo con sticker pequeno en tapa','Biblioteca, sala de estudio','2026-10-25','ENCONTRADO'),(31,1,'Imagenes/cuaderno_norma_azul.jpg','Utiles','Cuaderno','Azul','Norma','Cuaderno azul de espiral con etiqueta en portada','Aula B104, escritorio del profesor','2026-10-26','ENCONTRADO'),(32,1,'Imagenes/casaca_adidas_negra.jpg','Ropa','Casaca','Negro','Adidas','Casaca deportiva negra con franjas claras','Cancha deportiva, graderias','2026-10-26','ENCONTRADO'),(33,1,'Imagenes/cargador_lenovo_negro.jpg','Tecnologia','Cargador','Negro','Lenovo','Cargador negro de laptop con cable largo','Aula C201, tomacorriente','2026-10-26','ENCONTRADO'),(34,1,'Imagenes/billetera_marron.jpg','Accesorios','Billetera','Marron','Sin marca','Billetera marron con bolsillo para monedas','Patio principal, cerca de cafeteria','2026-10-18','PERDIDO'),(35,1,'Imagenes/foto_laptop_estudiante.jpg','Tecnologia','Laptop','Gris','Lenovo','Laptop Lenovo gris con funda de tela y marcas en una esquina','Pabellon B, Aula B203','2026-10-19','PERDIDO'),(36,1,'Imagenes/termo_stanley_plateado.jpg','Accesorios','Termo','Plateado','Stanley','Termo plateado con tapa negra y una raya junto a la base','Cafeteria','2026-10-20','PERDIDO'),(37,1,'Imagenes/llaves_llavero_azul.jpg','Accesorios','Llaves','Plateado','Sin marca','Tres llaves con llavero azul de plastico','Entrada principal','2026-10-22','PERDIDO'),(38,1,'Imagenes/usb_kingston_azul.jpg','Tecnologia','Memoria USB','Azul','Kingston','USB azul de 64 gigas con una tapa suelta','Laboratorio de computo C102','2026-10-24','PERDIDO'),(39,1,'Imagenes/cartuchera_roja.jpg','Utiles','Cartuchera','Rojo','Faber Castell','Cartuchera roja con boligrafos y un resaltador amarillo','Aula B203','2026-10-19','PERDIDO'),(40,1,'Imagenes/cuaderno_norma_azul.jpg','Utiles','Cuaderno','Azul','Norma','Cuaderno azul espiral con apuntes de matematica','Aula B104','2026-10-25','PERDIDO'),(41,1,'Imagenes/casaca_nike_verde.jpg','Ropa','Casaca','Verde','Nike','Casaca verde con capucha, talla mediana','Cancha deportiva','2026-10-24','PERDIDO'),(42,1,'Imagenes/foto_celular_xiaomi_estudiante.jpg','Tecnologia','Celular','Azul','Xiaomi','Telefono azul Xiaomi con funda transparente','Cafeteria','2026-10-20','PERDIDO'),(43,1,'Imagenes/paraguas_negro.jpg','Accesorios','Paraguas','Negro','Sin marca','Paraguas negro largo con mango de madera','Pabellon A','2026-10-25','PERDIDO'),(44,1,'Imagenes/cargador_apple_blanco.jpg','Tecnologia','Cargador','Blanco','Apple','Cargador blanco USB-C con cable corto','Biblioteca','2026-10-21','PERDIDO'),(45,1,'Imagenes/mochila_negra_simple.jpg','Mochilas','Mochila','Negro','Sin marca','Mochila negra sin logotipo con bolsillo delantero','Biblioteca, segundo piso','2026-10-23','PERDIDO'),(46,1,'Imagenes/audifonos_sony_negros.jpg','Accesorios','Audifonos','Negro','Sony','Audifonos grandes negros con almohadillas de espuma','Biblioteca','2026-10-21','PERDIDO'),(47,1,'Imagenes/paraguas_gris.jpg','Accesorios','Paraguas','Gris','Sin marca','Paraguas gris compacto con mango de goma','Pabellon B, ingreso lateral','2026-10-25','PERDIDO'),(48,1,'Imagenes/llaves_llavero_azul.jpg','Accesorios','Llaves','Plateado','Sin marca','Juego de tres llaves con llavero azul ovalado','Entrada principal','2026-10-24','PERDIDO');
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
  PRIMARY KEY (`idObjetoEncontrado`),
  KEY `idObjeto` (`idObjeto`),
  KEY `idPersonalSAE` (`idPersonalSAE`),
  CONSTRAINT `objeto_encontrado_ibfk_1` FOREIGN KEY (`idObjeto`) REFERENCES `objeto` (`idObjeto`),
  CONSTRAINT `objeto_encontrado_ibfk_2` FOREIGN KEY (`idPersonalSAE`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto_encontrado`
--

LOCK TABLES `objeto_encontrado` WRITE;
/*!40000 ALTER TABLE `objeto_encontrado` DISABLE KEYS */;
INSERT INTO `objeto_encontrado` VALUES (1,1,2,'2026-10-20'),(2,3,2,'2026-10-21'),(3,4,2,'2026-10-22'),(4,5,2,'2026-10-18'),(5,6,2,'2026-10-20'),(6,7,2,'2026-10-22'),(7,8,2,'2026-10-20'),(8,9,2,'2026-10-21'),(9,10,2,'2026-10-23'),(10,11,2,'2026-10-23'),(11,12,2,'2026-10-19'),(12,13,2,'2026-10-20'),(13,14,2,'2026-10-22'),(14,15,2,'2026-10-22'),(15,16,2,'2026-10-24'),(16,17,2,'2026-10-25'),(17,18,2,'2026-10-24'),(18,19,2,'2026-10-23'),(19,20,2,'2026-10-24'),(20,21,2,'2026-10-25'),(21,24,2,'2026-10-21'),(22,25,2,'2026-10-24'),(23,26,2,'2026-10-24'),(24,27,2,'2026-10-24'),(25,28,2,'2026-10-25'),(26,29,2,'2026-10-25'),(27,30,2,'2026-10-24'),(28,31,2,'2026-10-26'),(29,32,2,'2026-10-26'),(30,33,2,'2026-10-26');
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto_perdido`
--

LOCK TABLES `objeto_perdido` WRITE;
/*!40000 ALTER TABLE `objeto_perdido` DISABLE KEYS */;
INSERT INTO `objeto_perdido` VALUES (1,2,4,'2026-10-19'),(2,22,4,'2026-10-20'),(3,23,4,'2026-10-21'),(4,34,5,'2026-10-17'),(5,35,6,'2026-10-18'),(6,36,7,'2026-10-20'),(7,37,8,'2026-10-21'),(8,38,9,'2026-10-23'),(9,39,10,'2026-10-18'),(10,40,1,'2026-10-25'),(11,41,5,'2026-10-23'),(12,42,6,'2026-10-19'),(13,43,7,'2026-10-24'),(14,44,8,'2026-10-20'),(15,45,9,'2026-10-22'),(16,46,10,'2026-10-20'),(17,47,4,'2026-10-24'),(18,48,4,'2026-10-23');
/*!40000 ALTER TABLE `objeto_perdido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reporte_objeto_perdido`
--

DROP TABLE IF EXISTS `reporte_objeto_perdido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reporte_objeto_perdido` (
  `idReporte` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idObjetoPerdido` int NOT NULL,
  `fechaReporte` date NOT NULL DEFAULT (curdate()),
  `estado` varchar(30) NOT NULL,
  PRIMARY KEY (`idReporte`),
  UNIQUE KEY `idObjetoPerdido` (`idObjetoPerdido`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `reporte_objeto_perdido_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `reporte_objeto_perdido_ibfk_2` FOREIGN KEY (`idObjetoPerdido`) REFERENCES `objeto_perdido` (`idObjetoPerdido`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reporte_objeto_perdido`
--

LOCK TABLES `reporte_objeto_perdido` WRITE;
/*!40000 ALTER TABLE `reporte_objeto_perdido` DISABLE KEYS */;
INSERT INTO `reporte_objeto_perdido` VALUES (1,4,1,'2026-10-20','✅ Coincidencia encontrada'),(2,4,2,'2026-10-21','✅ Coincidencia encontrada'),(3,4,3,'2026-10-22','⛔ Cerrado'),(4,5,4,'2026-10-18','✅ Coincidencia encontrada'),(5,6,5,'2026-10-19','✅ Coincidencia encontrada'),(6,7,6,'2026-10-21','✅ Coincidencia encontrada'),(7,8,7,'2026-10-22','✅ Coincidencia encontrada'),(8,9,8,'2026-10-24','✅ Coincidencia encontrada'),(9,10,9,'2026-10-19','✅ Coincidencia encontrada'),(10,1,10,'2026-10-26','✅ Coincidencia encontrada'),(11,5,11,'2026-10-24','? En búsqueda'),(12,6,12,'2026-10-20','✅ Coincidencia encontrada'),(13,7,13,'2026-10-25','? En búsqueda'),(14,8,14,'2026-10-21','✅ Coincidencia encontrada'),(15,9,15,'2026-10-23','✅ Coincidencia encontrada'),(16,10,16,'2026-10-21','✅ Coincidencia encontrada'),(17,4,17,'2026-10-24','? En búsqueda'),(18,4,18,'2026-10-24','✅ Coincidencia encontrada');
/*!40000 ALTER TABLE `reporte_objeto_perdido` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Carlos','Perez','carlos@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1),(2,'Maria','Lopez','maria@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','PersonalSae',1,1),(3,'Luis','Torres','luis@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Docente',1,1),(4,'Axel','Chumpitaz','u24228040@utp.edu.pe','Loquesea123@','Imagenes/descarga.jfif','Estudiante',1,1),(5,'Diego','Ramirez','u24210531@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1),(6,'Valeria','Rojas','u24210864@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1),(7,'Andrea','Mendoza','u24211308@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1),(8,'Joaquin','Castillo','u24210627@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1),(9,'Lucia','Herrera','u24211642@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1),(10,'Mateo','Salazar','u24210975@utp.edu.pe','Demo1234','Imagenes/fotoUsuario.jpg','Estudiante',1,1);
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

-- Dump completed on 2026-10-27  0:28:13
