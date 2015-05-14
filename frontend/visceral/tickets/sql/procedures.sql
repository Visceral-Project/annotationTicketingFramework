DELIMITER //
CREATE PROCEDURE setAnnotationStatus(IN ANNOTATION_ID INT, IN STATUS_ID INT, IN USER_ID INT)

   BEGIN
   INSERT INTO annotation ( AnnotationID, PatientID, VolumeID, UserID, StructureID, TypeID, Timestamp, StatusID, QCUserID, Filename, Comment)
     SELECT NULL as AnnotationID, PatientID, VolumeID, USER_ID, StructureID, TypeID, NOW() as `Timestamp`, STATUS_ID as StatusID, QCUserID, Filename, Comment FROM annotation oa
        WHERE oa.AnnotationID=ANNOTATION_ID;
   END //



CREATE PROCEDURE latestAnnotationTickets(IN ANNOTATION_USER INT, IN ANNOTATION_STATUS INT)
  BEGIN

      SELECT a.*, v.Modality, s.Name as Bodyregion, s.RadlexID, at.Name as Type FROM annotation a
        INNER JOIN (select PatientID, VolumeID, StructureID, MAX(Timestamp) AS Timestamp FROM annotation
          GROUP BY PatientID, VolumeID, StructureID) AS sq
          USING (PatientID, VolumeID, StructureID, Timestamp)
        INNER JOIN volume v USING (PatientID, VolumeID)
        INNER JOIN structure s ON (a.StructureID = s.RadlexID)
        INNER JOIN annotationtype at ON (a.TypeID=at.AnnotationTypeID)
      WHERE UserID = ANNOTATION_USER AND StatusID=ANNOTATION_STATUS
      ORDER BY a.PatientID, a.VolumeID, a.TypeID;
  END //



DELIMITER ;


