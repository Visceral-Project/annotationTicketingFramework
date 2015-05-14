CREATE VIEW `visceral_tickets_release`.`annotation_latest_idx` AS
    select 
        `visceral_tickets_release`.`annotation`.`PatientID` AS `PatientID`,
        `visceral_tickets_release`.`annotation`.`VolumeID` AS `VolumeID`,
        `visceral_tickets_release`.`annotation`.`AnnotationTypeID` AS `AnnotationTypeID`,
        `visceral_tickets_release`.`annotation`.`AnnotatorID` AS `AnnotatorID`,
        max(`visceral_tickets_release`.`annotation`.`Timestamp`) AS `Timestamp`
    from
        `visceral_tickets_release`.`annotation`
    group by `visceral_tickets_release`.`annotation`.`PatientID` , `visceral_tickets_release`.`annotation`.`VolumeID` , `visceral_tickets_release`.`annotation`.`AnnotationTypeID` , `visceral_tickets_release`.`annotation`.`AnnotatorID`
