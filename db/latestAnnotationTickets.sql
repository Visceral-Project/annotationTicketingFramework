DELIMITER $$
CREATE PROCEDURE `latestAnnotationTickets`(IN ANNOTATION_USER INT, IN ANNOTATION_STATUS INT)
BEGIN

      SELECT a.*, v.Modality, s.Name as Bodyregion, AnnotationTypeID, at.Name as Type FROM annotation a
        INNER JOIN (select PatientID, VolumeID, AnnotationTypeID, MAX(Timestamp) AS Timestamp FROM annotation
          GROUP BY PatientID, VolumeID, AnnotationTypeID) AS sq
          USING (PatientID, VolumeID, AnnotationTypeID, Timestamp)
        INNER JOIN volume v USING (PatientID, VolumeID)
        INNER JOIN annotationtype at ON (a.AnnotationTypeID=at.AnnotationTypeID)
      WHERE UserID = ANNOTATION_USER AND StatusID=ANNOTATION_STATUS
      ORDER BY a.PatientID, a.VolumeID, a.AnnotationTypeID;
  END$$
DELIMITER ;

