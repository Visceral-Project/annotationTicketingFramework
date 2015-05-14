

/*

AnnotationID | PatientID | VolumeID | UserID | StructureID | LandmarkID | Type      | Timestamp           | StatusID | QCUserID | Filename                          | Comment 
        5735 |  10000323 |        4 |      4 |        NULL |       NULL | landmark  | 2014-02-26 16:00:33 |        1 |        0 | 10000323_4_MRT1cefs_Ab_LMAnnotations_4.fcsv | NULL    |
        5736 |  10000067 |        3 |      4 |        NULL |       NULL | landmark  | 2014-02-26 16:00:33 |        1 |        0 | 10000067_3_MRT1_wb_LMAnnotations_4.fcsv     | NULL 

*/

INSERT INTO annotation VALUES(NULL, 10000067, 3, 4, NULL, NULL, 'landmark', NOW(), -1, 0, '10000067_3_MRT1_wb_LMAnnotations_4', NULL);
INSERT INTO annotation VALUES(NULL, 10000067, 3, 5, NULL, NULL, 'landmark', NOW(), 0, 0, '10000067_3_MRT1_wb_LMAnnotations_5', NULL);
INSERT INTO annotation VALUES(NULL, 10000067, 3, 4, NULL, NULL, 'landmark', NOW(), -1, 0, '10000067_3_MRT1_wb_LMAnnotations_4', NULL);
INSERT INTO annotation VALUES(NULL, 10000067, 3, 6, NULL, NULL, 'landmark', NOW(), -1, 0, '10000067_3_MRT1_wb_LMAnnotations_6', NULL);

INSERT INTO annotation VALUES(NULL, 10000323, 3, 6, NULL, NULL, 'landmark', NOW(), 2, 0, '10000323_4_MRT1cefs_Ab_LMAnnotations_6', NULL);
INSERT INTO annotation VALUES(NULL, 10000323, 3, 7, NULL, NULL, 'landmark', NOW(), -1, 0, '10000323_4_MRT1cefs_Ab_LMAnnotations_7', NULL);
INSERT INTO annotation VALUES(NULL, 10000323, 3, 2, NULL, NULL, 'landmark', NOW(), 3, 0, '10000323_4_MRT1cefs_Ab_LMAnnotations_2', NULL);
INSERT INTO annotation VALUES(NULL, 10000323, 3, 2, NULL, NULL, 'landmark', NOW(), -1, 0, '10000323_4_MRT1cefs_Ab_LMAnnotations_2', NULL);
INSERT INTO annotation VALUES(NULL, 10000323, 3, 2, NULL, NULL, 'landmark', NOW(), 3, 0, '10000323_4_MRT1cefs_Ab_LMAnnotations_2', NULL);
