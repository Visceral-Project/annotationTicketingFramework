function [ status ] = dbAddAnnotation(DBAnnotation,logFile)
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Inserts an entry to the VISCERAL ticketing DB table ANNOTATION
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
%   1 if insert succeeded
%   0 if insert failed

functionName = 'dbAddAnnotation';

if not(isfield(DBAnnotation,'patientID') && isfield(DBAnnotation,'volumeID') && isfield(DBAnnotation,'annotatorID') && isfield(DBAnnotation,'annotationTypeID') )
    error('missing field values')
end

% get volume of respective annotation ticket
DBVolume = dbGetVolumes(DBAnnotation.patientID, DBAnnotation.volumeID,[], [],logFile );

% get annotation type
[ DBAnnotationType, status ] = dbGetAnnotationType( DBAnnotation.annotationTypeID, [], logFile);

if strcmp(DBAnnotationType.fileNamePart,'null')
  DBAnnotation.filename = [DBAnnotation.patientID '_' num2str(DBAnnotation.volumeID) '_' DBVolume.modality '_' ...
            DBVolume.bodyRegion '_' num2str(DBAnnotationType.annotationTypeID) '_' num2str(DBAnnotation.annotatorID)];     
else
     DBAnnotation.filename = [DBAnnotation.patientID '_' num2str(DBAnnotation.volumeID) '_' DBVolume.modality '_' ...
            DBVolume.bodyRegion '_' DBAnnotationType.fileNamePart '_' num2str(DBAnnotation.annotatorID)];    
end

DBAnnotation.filename = [DBAnnotation.filename '.' DBAnnotationType.FileExtension];

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);


% check if connection is established
if ( status == 1 )
                                                sqlStatement = 'insert into annotation (PatientID, VolumeID, AnnotationTypeID, AnnotatorID';
    if isfield(DBAnnotation,'statusID');        sqlStatement = [sqlStatement ', StatusID']; end
    if isfield(DBAnnotation,'qcAnnotatorID');   sqlStatement = [sqlStatement ', QCAnnotatorID']; end
                                                sqlStatement = [sqlStatement ', filename'];
    if isfield(DBAnnotation,'comment');         sqlStatement = [sqlStatement ', Comment']; end
                                            
    sqlStatement = [sqlStatement ') '];
                                                
    sqlStatement= [sqlStatement 'values ("' num2str(DBAnnotation.patientID) '" ,' num2str(DBAnnotation.volumeID) ' ,' num2str(DBAnnotation.annotationTypeID) ' ,' num2str(DBAnnotation.annotatorID)];
    
    if isfield(DBAnnotation,'statusID');        sqlStatement = [sqlStatement ', ' num2str(DBAnnotation.statusID)]; end
    if isfield(DBAnnotation,'qcAnnotatorID');   sqlStatement = [sqlStatement ', ' num2str(DBAnnotation.qcAnnotatorID)]; end
                                                sqlStatement = [sqlStatement ', "' DBAnnotation.filename '"'];
    if isfield(DBAnnotation,'comment')
        %% strrep of comments
        comment = strrep(DBAnnotation.comment,'"','');
        DBAnnotation.comment = comment;
        sqlStatement = [sqlStatement ', "' DBAnnotation.comment '"']; 
    end
    sqlStatement = [sqlStatement ')'];
            
    % execute sql statement
    [ status, curs ]  = dbExecuteStatement(conn, sqlStatement, logFile);
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): insert failed!'], logFile);
        dbLogMsg('', logFile); return;
    end
    
    dbCloseConnection(conn, logFile);
else
    dbLogMsg(['DB-WARNING (' functionName '): no connection established!'], logFile);
end

% display that insert was successfull
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): new entries successfully inserted!'], logFile, 1); end

dbLogMsg('', logFile);
