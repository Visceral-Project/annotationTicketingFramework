CREATE DATABASE  IF NOT EXISTS `visceral_tickets_release` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `visceral_tickets_release`;
-- MySQL dump 10.13  Distrib 5.5.41, for debian-linux-gnu (x86_64)
--
-- ------------------------------------------------------
-- Server version	5.1.73-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `annotation`
--

DROP TABLE IF EXISTS `annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotation` (
  `AnnotationID` int(11) NOT NULL AUTO_INCREMENT,
  `PatientID` varchar(256) NOT NULL,
  `VolumeID` int(11) NOT NULL,
  `AnnotationTypeID` int(11) NOT NULL,
  `AnnotatorID` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `StatusID` int(11) NOT NULL DEFAULT '0',
  `QCAnnotatorID` int(11) NOT NULL DEFAULT '0',
  `Filename` varchar(255) DEFAULT NULL,
  `Comment` longtext,
  PRIMARY KEY (`AnnotationID`),
  KEY `status_fk_idx` (`StatusID`),
  KEY `structure_fk_idx` (`AnnotationTypeID`),
  KEY `user_fk_idx` (`AnnotatorID`),
  KEY `qc_user_fk_idx` (`AnnotatorID`),
  KEY `volume_fk_idx` (`VolumeID`),
  KEY `patient_fk_idx` (`PatientID`),
  KEY `qc_user_fk` (`QCAnnotatorID`),
  KEY `master_join_idx` (`PatientID`,`VolumeID`,`AnnotatorID`,`AnnotationTypeID`,`Timestamp`),
  KEY `pat_vol_st_idx` (`PatientID`,`VolumeID`,`AnnotationTypeID`)
) ENGINE=MyISAM AUTO_INCREMENT=11053 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annotation`
--

LOCK TABLES `annotation` WRITE;
/*!40000 ALTER TABLE `annotation` DISABLE KEYS */;
INSERT INTO `annotation` VALUES (11052,'10001',2,-2,1,'2015-04-27 12:08:12',0,2,'10001_2_MRT1_Ab_lesions_1.fcsv',NULL),(11051,'10001',2,-1,1,'2015-04-27 12:08:11',0,2,'10001_2_MRT1_Ab_landmarks_1.fcsv',NULL),(11050,'10001',2,58,1,'2015-04-27 12:08:11',0,2,'10001_2_MRT1_Ab_58_1.nii.gz',NULL),(11049,'10001',2,1302,1,'2015-04-27 12:08:10',0,2,'10001_2_MRT1_Ab_1302_1.nii.gz',NULL),(11023,'10000001',3,-2,1,'2015-04-27 12:05:48',-4,0,'10000001_3_MRT1_wb_lesions_1.fcsv','null'),(11045,'10000001',3,1302,1,'2015-04-27 12:08:06',0,2,'10000001_3_MRT1_wb_1302_1.nii.gz',NULL),(11046,'10000001',3,58,1,'2015-04-27 12:08:07',0,2,'10000001_3_MRT1_wb_58_1.nii.gz',NULL),(11047,'10000001',3,-1,1,'2015-04-27 12:08:08',0,2,'10000001_3_MRT1_wb_landmarks_1.fcsv',NULL),(11048,'10000001',3,-2,1,'2015-04-27 12:08:09',0,2,'10000001_3_MRT1_wb_lesions_1.fcsv',NULL),(11042,'10000104',1,58,1,'2015-04-27 12:08:03',0,2,'10000104_1_CTce_ThAb_58_1.nii.gz',NULL),(11043,'10000104',1,-1,1,'2015-04-27 12:08:04',0,2,'10000104_1_CTce_ThAb_landmarks_1.fcsv',NULL),(11044,'10000104',1,-2,1,'2015-04-27 12:08:05',0,2,'10000104_1_CTce_ThAb_lesions_1.fcsv',NULL),(11025,'10000003',3,1302,1,'2015-04-27 12:07:48',0,2,'10000003_3_MRT1_wb_1302_1.nii.gz',NULL),(11041,'10000104',1,1302,1,'2015-04-27 12:08:02',0,2,'10000104_1_CTce_ThAb_1302_1.nii.gz',NULL),(11040,'10000100',1,-2,1,'2015-04-27 12:08:01',0,2,'10000100_1_CTce_ThAb_lesions_1.fcsv',NULL),(11039,'10000100',1,-1,1,'2015-04-27 12:08:01',0,2,'10000100_1_CTce_ThAb_landmarks_1.fcsv',NULL),(11038,'10000100',1,58,1,'2015-04-27 12:08:00',0,2,'10000100_1_CTce_ThAb_58_1.nii.gz',NULL),(11037,'10000100',1,1302,1,'2015-04-27 12:07:59',0,2,'10000100_1_CTce_ThAb_1302_1.nii.gz',NULL),(11036,'10000021',1,-2,1,'2015-04-27 12:07:58',0,2,'10000021_1_CT_wb_lesions_1.fcsv',NULL),(11035,'10000021',1,-1,1,'2015-04-27 12:07:57',0,2,'10000021_1_CT_wb_landmarks_1.fcsv',NULL),(11034,'10000021',1,58,1,'2015-04-27 12:07:56',0,2,'10000021_1_CT_wb_58_1.nii.gz',NULL),(11033,'10000021',1,1302,1,'2015-04-27 12:07:55',0,2,'10000021_1_CT_wb_1302_1.nii.gz',NULL),(11032,'10000020',1,-2,1,'2015-04-27 12:07:54',0,2,'10000020_1_CT_wb_lesions_1.fcsv',NULL),(11031,'10000020',1,-1,1,'2015-04-27 12:07:53',0,2,'10000020_1_CT_wb_landmarks_1.fcsv',NULL),(11030,'10000020',1,58,1,'2015-04-27 12:07:52',0,2,'10000020_1_CT_wb_58_1.nii.gz',NULL),(11029,'10000020',1,1302,1,'2015-04-27 12:07:51',0,2,'10000020_1_CT_wb_1302_1.nii.gz',NULL),(11028,'10000003',3,-2,1,'2015-04-27 12:07:51',0,2,'10000003_3_MRT1_wb_lesions_1.fcsv',NULL),(11027,'10000003',3,-1,1,'2015-04-27 12:07:50',0,2,'10000003_3_MRT1_wb_landmarks_1.fcsv',NULL),(11026,'10000003',3,58,1,'2015-04-27 12:07:49',0,2,'10000003_3_MRT1_wb_58_1.nii.gz',NULL);
/*!40000 ALTER TABLE `annotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annotationtype`
--

DROP TABLE IF EXISTS `annotationtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotationtype` (
  `AnnotationTypeID` int(11) NOT NULL,
  `Name` varchar(256) NOT NULL,
  `FileExtension` varchar(45) NOT NULL,
  `RemoteUploadDir` varchar(45) NOT NULL,
  `FileNamePart` varchar(45) DEFAULT NULL,
  `category` varchar(45) NOT NULL,
  PRIMARY KEY (`AnnotationTypeID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annotationtype`
--

LOCK TABLES `annotationtype` WRITE;
/*!40000 ALTER TABLE `annotationtype` DISABLE KEYS */;
INSERT INTO `annotationtype` VALUES (1302,'right lung','nii.gz','manual_annotations',NULL,'structure'),(58,'liver','nii.gz','manual_annotations',NULL,'structure'),(-1,'landmark','fcsv','manual_landmark_annotations','landmarks','landmark'),(-2,'lesion','fcsv','manual_lesion_annotations','lesions','lesion');
/*!40000 ALTER TABLE `annotationtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annotator`
--

DROP TABLE IF EXISTS `annotator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotator` (
  `AnnotatorID` int(11) NOT NULL,
  `ContactInfo` varchar(256) NOT NULL,
  `FirstName` varchar(256) DEFAULT NULL,
  `SurName` varchar(256) DEFAULT NULL,
  `Qc` tinyint(1) DEFAULT NULL,
  `Available` tinyint(1) NOT NULL DEFAULT '0',
  `Password` varchar(256) NOT NULL,
  PRIMARY KEY (`AnnotatorID`),
  UNIQUE KEY `ContactInfo` (`ContactInfo`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annotator`
--

LOCK TABLES `annotator` WRITE;
/*!40000 ALTER TABLE `annotator` DISABLE KEYS */;
INSERT INTO `annotator` VALUES (1,'annotator@meduniwien.ac.at','Max','Mustermann',0,1,'d370d9cd5625a534b858b567de7a324d04573eaf'),(2,'qcMember@meduniwien.ac.at','Mike','Mustermann',1,1,'d370d9cd5625a534b858b567de7a324d04573eaf');
/*!40000 ALTER TABLE `annotator` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `status` (
  `StatusID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Description` varchar(45) DEFAULT NULL,
  `Color` varchar(32) DEFAULT 'white',
  `QCAccessible` tinyint(4) NOT NULL DEFAULT '0',
  `AnnotatorAccessible` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`StatusID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (0,'pending','ticket not received','white',0,0),(1,'submitted','ready for QC','lightgreen',0,0),(2,'QC passed','annotated and checked','darkgreen',1,0),(-2,'bad contrast','annotation not possible','orange',1,1),(-1,'QC failed ','reassign ticket','red',1,0),(-4,'deleted','ticket has been deleted','lightgray',0,0),(-3,'not in volume','structure of interest does not occur in volum','orange',1,1);
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volume`
--

DROP TABLE IF EXISTS `volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `volume` (
  `PatientID` varchar(256) NOT NULL,
  `VolumeID` int(11) NOT NULL,
  `Modality` varchar(256) NOT NULL,
  `Bodyregion` varchar(256) NOT NULL,
  `Filename` varchar(256) NOT NULL,
  PRIMARY KEY (`PatientID`,`VolumeID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volume`
--

LOCK TABLES `volume` WRITE;
/*!40000 ALTER TABLE `volume` DISABLE KEYS */;
INSERT INTO `volume` VALUES ('10000003',3,'MRT1','wb','10000003_3_MRT1_wb.nii.gz'),('10000020',1,'CT','wb','10000020_1_CT_wb.nii.gz'),('10000021',1,'CT','wb','10000021_1_CT_wb.nii.gz'),('10000100',1,'CTce','ThAb','10000100_1_CTce_ThAb.nii.gz'),('10000104',1,'CTce','ThAb','10000104_1_CTce_ThAb.nii.gz'),('10000001',3,'MRT1','wb','10000001_3_MRT1_wb.nii.gz'),('10001',2,'MRT1','Ab','10001_2_MRT1_Ab.nii.gz');
/*!40000 ALTER TABLE `volume` ENABLE KEYS */;
UNLOCK TABLES;


