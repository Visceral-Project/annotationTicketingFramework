CREATE VIEW `visceral_tickets_release`.`fullLatestAnnotation_view` AS
    select 
        `a`.`AnnotationID` AS `AnnotationID`,
        `a`.`PatientID` AS `PatientID`,
        `a`.`VolumeID` AS `VolumeID`,
        `a`.`AnnotationTypeID` AS `AnnotationTypeID`,
        `a`.`AnnotatorID` AS `AnnotatorID`,
        `a`.`StatusID` AS `StatusID`,
        `a`.`QCAnnotatorID` AS `QCAnnotatorID`,
        `a`.`Filename` AS `Filename`,
        `a`.`Comment` AS `Comment`,
        `v`.`Modality` AS `Modality`,
        `v`.`Bodyregion` AS `BodyRegion`,
        `at`.`Name` AS `AnnotationName`,
        `st`.`Name` AS `statusName`,
        `a`.`Timestamp` AS `Timestamp`,
        `at`.`category` AS `AnnotationCategory`
    from
        ((((`visceral_tickets_release`.`annotation` `a`
        join `visceral_tickets_release`.`annotation_latest_idx` ON (((`a`.`PatientID` = `annotation_latest_idx`.`PatientID`)
            and (`a`.`VolumeID` = `annotation_latest_idx`.`VolumeID`)
            and (`a`.`AnnotatorID` = `annotation_latest_idx`.`AnnotatorID`)
            and (`a`.`AnnotationTypeID` = `annotation_latest_idx`.`AnnotationTypeID`)
            and (`a`.`Timestamp` = `annotation_latest_idx`.`Timestamp`))))
        join `visceral_tickets_release`.`volume` `v` ON (((`a`.`PatientID` = `v`.`PatientID`)
            and (`a`.`VolumeID` = `v`.`VolumeID`))))
        join `visceral_tickets_release`.`annotationtype` `at` ON ((`a`.`AnnotationTypeID` = `at`.`AnnotationTypeID`)))
        join `visceral_tickets_release`.`status` `st` ON ((`a`.`StatusID` = `st`.`StatusID`)))
    where
        (`a`.`StatusID` > -(4))
    order by `a`.`PatientID` , `a`.`VolumeID` , `a`.`AnnotationTypeID`
