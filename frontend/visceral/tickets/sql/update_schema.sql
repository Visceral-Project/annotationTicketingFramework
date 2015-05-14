

CREATE TABLE IF NOT EXISTS `status` (
  `StatusID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Description` VARCHAR(45) NULL,
  `Color` VARCHAR(32) DEFAULT "white",
  `QCAccessible` TINYINT NOT NULL DEFAULT 0,
  `AnnotatorAccessible` TINYINT NOT NULL DEFAULT 0,
  `SubmitOption` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`StatusID`))
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `structure` (
  `RadLexID` INT NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`RadLexID`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `annotationtype` (
  `AnnotationTypeID`INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `FileExtension` VARCHAR(255) NOT NULL,
  `RemoteUploadDir` VARCHAR(255) NOT NULL,
  `FileNamePart` VARCHAR(255) NOT NULL,
   PRIMARY KEY (`AnnotationTypeID`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `landmark` (
  `LandmarkID` INT NOT NULL AUTO_INCREMENT,
  `AnnotationID` INT NOT NULL,
  `StatusID` INT NOT NULL,
  `X` DOUBLE NULL,
  `Y` DOUBLE NULL,
  `Z` DOUBLE NULL,
  `Selected` TINYINT NULL,
  `Visible` TINYINT NULL,
  `Label` VARCHAR(255) NULL,
  PRIMARY KEY (`LandmarkID`),
  INDEX `annotation_lm_fk_idx`(`AnnotationID` ASC),
  INDEX `status_lm_fk_idx`(`StatusID` ASC),
  CONSTRAINT `annotation_lm_fk`
    FOREIGN KEY (`AnnotationID`)
    REFERENCES `annotation` (`AnnotationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `status_lm_fk`
    FOREIGN KEY (`StatusID`)
    REFERENCES `status` (`StatusID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = MyISAM;

ALTER TABLE patient CHANGE PatientID Name VARCHAR(255);
ALTER TABLE patient DROP PRIMARY KEY;
ALTER TABLE patient ADD PatientID INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST; 

CREATE TABLE IF NOT EXISTS `annotation` (
  `AnnotationID` INT NOT NULL AUTO_INCREMENT,
  `PatientID` INT NOT NULL,
  `VolumeID` INT NOT NULL,
  `UserID` INT NOT NULL,
  `StructureID` INT NOT NULL DEFAULT -1,
  `Type` ENUM('structure', 'landmark', 'lesion_careful', 'lesion_rough') NOT NULL,
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `StatusID` INT NOT NULL DEFAULT 0,
  `QCUserID` INT NOT NULL,
  `Filename` VARCHAR(255) NOT NULL,
  `Comment` VARCHAR(255) NULL,
  PRIMARY KEY (`AnnotationID`),
  INDEX `status_fk_idx` (`StatusID` ASC),
  INDEX `structure_fk_idx` (`StructureID` ASC),
  INDEX `user_fk_idx` (`UserID` ASC),
  INDEX `qc_user_fk_idx` (`UserID` ASC),
  INDEX `volume_fk_idx` (`VolumeID` ASC),
  INDEX `patient_fk_idx` (`PatientID` ASC),
  CONSTRAINT `status_fk`
    FOREIGN KEY (`StatusID`)
    REFERENCES `status` (`StatusID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `structure_fk`
    FOREIGN KEY (`StructureID`)
    REFERENCES `structure` (`RadLexID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `qc_user_fk`
    FOREIGN KEY (`QCUserID`)
    REFERENCES `annotator` (`AnnotatorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_fk`
    FOREIGN KEY (`UserID`)
    REFERENCES `annotator` (`AnnotatorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `volume_fk`
    FOREIGN KEY (`VolumeID`)
    REFERENCES `volume` (`VolumeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `patient_fk`
    FOREIGN KEY (`PatientID`)
    REFERENCES `patient` (`PatientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM;


/* add column for volume origin data */
ALTER TABLE volume ADD Origin VARCHAR(255) AFTER Filename;
UPDATE volume SET Origin='Heidelberg';

/* add quality check flag for annotators */

ALTER TABLE annotator ADD Qc TINYINT(1) DEFAULT 0 AFTER NumberOfAnnotations;

UPDATE annotator SET Qc=1 where AnnotatorID IN(13,14,4,2,15,16,17);
INSERT INTO annotator VALUES(0, '', 'No', 'Body', 0, 0, 0, 0, NULL);

/* ASSIGN STATUS VALUES */
INSERT INTO status VALUES(0, "pending", "ticket not received", "white", 0, 0);
INSERT INTO status VALUES(1, "ready", "ready for QC", "lightgreen", 0, 0);
INSERT INTO status VALUES(2, "QC failed (me)", "ticket will be reassigned to self", "red", 1, 0);
INSERT INTO status VALUES(3, "QC passed", "quality control complete", "green", 1, 0);
INSERT INTO status VALUES(4, "partial", "partially in volume", "lightblue", 1, 1, 1);

INSERT INTO status VALUES(-1, "QC failed (other)", "ticket wil be reassigned to other", "red", 1, 0);

INSERT INTO status VALUES(-2, "not in volume", "annotation is not in volume", "lightblue", 1, 1, 1);

INSERT INTO status VALUES(-4, "bad contrast", "structure has bad contrast", "lightblue", 1, 1, 1);
INSERT INTO status VALUES(-5, "unknown", "unknown", "white", 0, 0);
INSERT INTO status VALUES(-6, "not generated", "no ticket generated", "lightgray", 0, 0);


/*ASSIGN RADLEX VALUES */
INSERT INTO structure VALUES(-1, 'undefined');
INSERT INTO structure VALUES(1247, '');
INSERT INTO structure VALUES(1302, '');
INSERT INTO structure VALUES(1326, '');
INSERT INTO structure VALUES(170, '');
INSERT INTO structure VALUES(187, '');
INSERT INTO structure VALUES(237, '');
INSERT INTO structure VALUES(2473, '');
INSERT INTO structure VALUES(29193, '');
INSERT INTO structure VALUES(29662, '');
INSERT INTO structure VALUES(29663, '');
INSERT INTO structure VALUES(30324, '');
INSERT INTO structure VALUES(30325, '');
INSERT INTO structure VALUES(32248, '');
INSERT INTO structure VALUES(32249, '');
INSERT INTO structure VALUES(40357, '');
INSERT INTO structure VALUES(114, '');
INSERT INTO structure VALUES(480, '');
INSERT INTO structure VALUES(58, '');
INSERT INTO structure VALUES(7578, '');
INSERT INTO structure VALUES(86, '');
INSERT INTO structure VALUES(40358, '');
INSERT INTO structure VALUES(1385, '');
INSERT INTO structure VALUES(13858, '');
INSERT INTO structure VALUES(13859, '');
INSERT INTO structure VALUES(1389, '');
INSERT INTO structure VALUES(1392, '');
INSERT INTO structure VALUES(6815, '');
INSERT INTO structure VALUES(1178, '');
INSERT INTO structure VALUES(32252, '');
INSERT INTO structure VALUES(7772, '');
INSERT INTO structure VALUES(7773, '');
INSERT INTO structure VALUES(7774, '');
INSERT INTO structure VALUES(7775, '');


/*'structure','landmark','lesion_careful','lesion_rough */
INSERT INTO annotationtype VALUES(1, 'structure', 'gz', 'manual_annotations', NULL);
INSERT INTO annotationtype VALUES(2, 'landmark', 'fcsv', 'manual_landmark_annotations', 'LMannotation');
INSERT INTO annotationtype VALUES(3, 'careful lesion', 'fcsv', 'manual_careful_lesion_annotations', 'CarefulLesionAnnotation');
INSERT INTO annotationtype VALUES(4, 'rough lesion', 'fcsv', 'manual_rough_lesion_annotations', 'RoughLesionAnnotation');
