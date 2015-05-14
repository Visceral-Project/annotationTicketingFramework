function [ status ] = dbRemoveAnnotation(DBAnnotation, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Removes an entry of the VISCERAL ticketing DB table ANNOTATION, by
% inserting the ticket again with status -4 = deleted.
%
% Input: 
%   DBAnnotation      STRUCT            holding fields for an annotation          
%   .volumeID                           volumeID of the volume
%   .patientID                          patientID of the volume
%   .annotatorID                        annotatorID of assigned annotator
%   .annotationTypeID                   ID of annotation type
%   .statusID           OPTIONAL        default 0 = pending ticket     
%   .qcAnnotatorID      OPTIONAL        default 0 = QC not assigned
%   .comment            OPTIONAL        default empty
%

% Output:
%   1 if remove succeeded
%   0 if remove failed


functionName = 'dbRemoveAnnotation';


%  add annotation status 4: deleted
DBAnnotation.statusID = -4;


[ status ] = dbAddAnnotation(DBAnnotation,logFile);
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): manual annotation removed!'], logFile, 1); end

dbLogMsg('', logFile);
