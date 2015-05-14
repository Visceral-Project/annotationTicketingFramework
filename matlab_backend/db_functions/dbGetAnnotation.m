function [ DBManAnnotations, status ] = dbGetAnnotation( patientID, volumeID, annotationTypeID,  annotatorID,annStatus,qcAnnotatorID, logFile)
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Queries the VISCERAL DB view fullLatestAnnotation_view given specific
% fields of the view. 
%
% This view holds only the latest entry of a ticket (identified by
% patientID, volumeID, annotatorID and annotationTypeID).
% 
%
% Input: 
%   patientID           patientID of the ticket      
%   volumeID            volumeID of the ticket 
%   annotationTypeID    ID of the tickets annotation type
%   annotatorID         ID of the ticket's assigned annotator
%   annStatus           status of the ticket (0=pending, 1=submitted,...)
%   qcAnnotatorID       annotator ID of the assigned QC annotator
%
% Output:
%   DBManAnnotations       Struct array, holding from the query returned
%                           annotation tickets
%
%
% Example:
% Query all annotation tickets that are pending (statusID=0) and assigned to annotator 1:
% [ DBManAnnotations, status ] = dbGetAnnotation( [], [], [],  1,0,[], logFile)
%

%% get data from db

functionName = 'dbGetAnnotations';
DBManAnnotations = [];

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% check if connection is established
if ( status == 1 )
    sqlStatement = 'select * from fullLatestAnnotation_view where 1=1';

    % add constraints
    if ( ~isempty(patientID) );         sqlStatement = [sqlStatement ' and PatientID like "' num2str(patientID) '"']; end
    if ( ~isempty(volumeID) );          sqlStatement = [sqlStatement ' and VolumeID=' num2str(volumeID)]; end
    if ( ~isempty(annotationTypeID) );       sqlStatement = [sqlStatement ' and annotationTypeID=' num2str(annotationTypeID)]; end
    if ( ~isempty(annotatorID) );       sqlStatement = [sqlStatement ' and AnnotatorID=' num2str(annotatorID)]; end
    if ( ~isempty(annStatus) ); sqlStatement = [sqlStatement ' and StatusID=' num2str(annStatus)]; end
    if ( ~isempty(qcAnnotatorID) );     sqlStatement = [sqlStatement ' and QCAnnotatorID=' num2str(qcAnnotatorID)]; end

    % execute sql statement
    [ status, curs] = dbExecuteStatement(conn, sqlStatement, logFile);
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): select statement failed!'], logFile);
        dbLogMsg('', logFile); return;
    end
    
    % fetch data
    curs = fetch(curs);
    
    dbCloseConnection(conn, logFile);
else
    dbLogMsg(['DB-WARNING (' functionName '): no connection established!'], logFile);
end


%% post processing of results

nRows = rows(curs);

if ( nRows > 0 )
    
    DBManAnnotations = struct([]);

    for iRow = 1 : nRows
        
        DBManAnnotations(iRow).patientID          = curs.Data{iRow,2}; 
        DBManAnnotations(iRow).volumeID           = curs.Data{iRow,3}; 
        DBManAnnotations(iRow).annotationTypeID   = curs.Data{iRow,4};
        DBManAnnotations(iRow).annotatorID        = curs.Data{iRow,5};        
        DBManAnnotations(iRow).statusID           = curs.Data{iRow,6};
        DBManAnnotations(iRow).qcAnnotatorID      = curs.Data{iRow,7}; 
        DBManAnnotations(iRow).filename           = curs.Data{iRow,8}; 
        DBManAnnotations(iRow).comment            = curs.Data{iRow,9}; 
        DBManAnnotations(iRow).timestamp          = curs.Data{iRow,14}; 
    end
end

% display that select was successfull
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): ' num2str(nRows) ' annotations selected!'], logFile); end
dbLogMsg('', logFile);
