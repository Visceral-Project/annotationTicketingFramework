function [ DBAnnotators, status ] = dbGetAnnotators( annotatorID, contactInfo, qualityCheck, available, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Queries the VISCERAL DB table ANNOTATORS given specific fields. 
% 
%
% Input: 
%   annotatorID         desired annotator ID         
%   contactInfo         desired contact information   
%   qualityCheck        1 if only annotators part of the QC team should be
%                       returned
%   available           1 if only annotators that are available for
%                       annotation should be returned
%
% Output:
%   DBAnnotators       Struct array, holding from the query returned
%                      annotators
%
%
% Example:
% Query for all annotators that are part of the quality check team
% [ DBAnnotators, status ] = dbGetAnnotators( [], [], 1, [], logFile )

%% get data from db

functionName = 'dbGetAnnotators';
DBAnnotators = [];

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% check if connection is established
if ( status == 1 )
    
    sqlStatement = 'select * from annotator where 1=1';
    
    % add constraints
    if ( ~isempty(annotatorID) ); sqlStatement = [sqlStatement ' and annotatorid=' num2str(annotatorID)]; end
    if ( ~isempty(contactInfo) ); sqlStatement = [sqlStatement ' and contactinfo="' contactInfo '"']; end
    if ( ~isempty(qualityCheck) ); sqlStatement = [sqlStatement ' and Qc=' num2str(qualityCheck)]; end
    if ( ~isempty(available) ); sqlStatement = [sqlStatement ' and available=' num2str(available)]; end
    
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
    
    DBAnnotators = struct([]);
    for iRow = 1 : nRows
        cnt=1;
        DBAnnotators(iRow).annotatorID         = curs.Data{iRow,cnt}; cnt=cnt+1;
        DBAnnotators(iRow).contactInfo         = curs.Data{iRow,cnt}; cnt=cnt+1;
        DBAnnotators(iRow).firstName           = curs.Data{iRow,cnt}; cnt=cnt+1;
        DBAnnotators(iRow).surName             = curs.Data{iRow,cnt}; cnt=cnt+1;
        DBAnnotators(iRow).Qc                  = curs.Data{iRow,cnt}; cnt=cnt+1;
        DBAnnotators(iRow).available           = curs.Data{iRow,cnt}; cnt=cnt+1;
    end
end

% display that select was successfull
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): ' num2str(nRows) ' annotators selected!'], logFile); end
dbLogMsg('', logFile);
