function [ status ] = dbUpdateVolume( DBVolume, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Updates an entry of the VISCERAL ticketing DB table VOLUME, identified by
% patientID and volumeID
%
% Input: 
%  DBVolume             struct holding an entry of VOLUME
%   .patientID          
%   .volumeID           
%   .modality           OPTIONAL 
%   .bodyregion         OPTIONAL
%   .filename           OPTIONAL
%
% Output:
%   1 if update is successfull
%   0 if update failed

functionName = 'dbUpdateVolume';

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% check if connection is established
if ( status == 1 )
    
    % create sql statement
    sqlStatement = ['update volume ' ...
        'set patientID="' DBVolume.patientID '", ' ...
        'volumeID=' num2str(DBVolume.volumeID) ',' ...
        'modality="' DBVolume.modality '",' ...
        'bodyRegion="' DBVolume.bodyRegion '",' ...
        'filename="' DBVolume.filename '"',...
        ' where patientID="' DBVolume.patientID '"'...
        ' and volumeID=' num2str(DBVolume.volumeID)];
    
    % execute sql statement
    status = dbExecuteStatement(conn, sqlStatement, logFile);
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): update failed!'], logFile);
        dbLogMsg('', logFile); return;
    end
    
    % commit changes
    status = dbCommit(conn, logFile);
    
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): commit failed!'], logFile);
        dbLogMsg('', logFile); return;
    end
    
    dbCloseConnection(conn, logFile);
else
    dbLogMsg(['DB-WARNING (' functionName '): no connection established!'], logFile);
end

% display that insert was successfull
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): volume updated!'], logFile, 1); end
dbLogMsg('', logFile);
