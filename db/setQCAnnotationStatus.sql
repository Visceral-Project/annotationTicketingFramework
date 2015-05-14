DELIMITER $$
CREATE PROCEDURE `setQCAnnotationStatus`(IN ANNOTATION_ID INT, IN STATUS_ID INT, IN Annotator_ID INT, IN QC_COMMENT VARCHAR(255))
BEGIN
INSERT INTO annotation ( AnnotationID, PatientID, VolumeID, AnnotationTypeID, AnnotatorID, Timestamp, StatusID, QCAnnotatorID, Filename, Comment)
     SELECT NULL as AnnotationID, PatientID, VolumeID, AnnotationTypeID, AnnotatorID, NOW() as `Timestamp`, STATUS_ID, Annotator_ID, Filename, QC_COMMENT FROM annotation oa
        WHERE oa.AnnotationID=ANNOTATION_ID;
  
END$$
DELIMITER ;

