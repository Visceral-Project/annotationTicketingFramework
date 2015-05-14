DELIMITER $$
CREATE PROCEDURE `setAnnotationStatus`(IN ANNOTATION_ID INT, IN STATUS_ID INT, IN USER_ID INT)
BEGIN
   INSERT INTO annotation ( AnnotationID, PatientID, VolumeID, AnnotationTypeID, AnnotatorID, Timestamp, StatusID, QCAnnotatorID, Filename, Comment)
     SELECT NULL as AnnotationID, PatientID, VolumeID, AnnotationTypeID, USER_ID, NOW() as `Timestamp`, STATUS_ID as StatusID, QCAnnotatorID, Filename, Comment FROM annotation oa
        WHERE oa.AnnotationID=ANNOTATION_ID;
   END$$
DELIMITER ;

