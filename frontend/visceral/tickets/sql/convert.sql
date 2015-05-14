
/* migrate multiple annotation tables into a single, versioned annotation table */
/* actual tables: manualannotation, manuallandmarkannotation */

/*
  `ID` INT NOT NULL AUTO_INCREMENT,
  `PatientID` INT NOT NULL,
  `VolumeID` INT NOT NULL,
  `userId` INT NOT NULL,
  `structureId` INT NULL,
  `landmarkId` INT NULL,
  `type` ENUM('structure', 'landmark', 'lesion_careful', 'lesion_rough') NOT NULL,
  `filename` VARCHAR(255) NOT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT 'NOW()',
  `status` INT NOT NULL DEFAULT 0,
*/

INSERT INTO annotation (AnnotationID, PatientID, VolumeID, UserID, StructureID, LandmarkID, Type, Timestamp, StatusID, QCUserID, Filename, Comment) \
                     SELECT NULL, PatientID, VolumeID, AnnotatorID, RadlexID, NULL, 1, NOW(), AnnotationReceived, NULL, Filename, NULL FROM manualannotation;


INSERT INTO annotation (AnnotationID, PatientID, VolumeID, UserID, StructureID, LandmarkID, Type, Timestamp, StatusID, QCUserID, Filename, Comment) \
                     SELECT NULL, PatientID, VolumeID, AnnotatorID, NULL, NULL, 2, NOW(), AnnotationReceived, NULL, Filename, NULL FROM manuallandmarkannotation;

INSERT INTO volume (PatientID, VolumeID, Modality, Bodyregion, Filename, Origin, goldCorpus, silverCorpus, lesionAnnotation) \
                     SELECT PatientID, VolumeID, Modality, Bodyregion, Filename, 'Heidelberg', NULL, NULL, NULL FROM visceral_tickets.volume;

UPDATE annotation SET StatusID=-2 WHERE StatusID=2;
UPDATE annotation SET StatusID=-4 WHERE StatusID=3;

/* drop unused tables */
DROP TABLE automaticannotation;
DROP TABLE automaticlandmarkannotation;
DROP TABLE carefullesionannotation;
DROP TABLE manualannotation;
DROP TABLE manuallandmarkannotation;
DROP TABLE roughlesionannotation;

DROP TABLE perstructureperformance;
DROP TABLE pervolumeperformance;
DROP TABLE registration;


