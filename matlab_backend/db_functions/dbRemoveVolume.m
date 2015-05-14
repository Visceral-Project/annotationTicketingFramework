function [ status ] = dbRemoveVolume( patientID, volumeID, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Removes an entry of the VISCERAL ticketing DB table VOLUME, identified by
% patientID and volumeID
%
% Input: 
%   patientID          
%   volumeID           
%
% Output:
%   1 if remove succeeded
%   0 if remove failed

functionName = 'dbRemoveVolume';

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% check if connection is established
if ( status == 1 )
    
    % create sql statement
    sqlStatement = ['delete from volume where patientid="' patientID '" and volumeid=' num2str(volumeID)];
    
    % execute sql statement
    status = dbExecuteStatement(conn, sqlStatement, logFile);
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): removing failed!'], logFile);
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

% display that removal was successfull
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): volume removed!'], logFile, 1); end

dbLogMsg('', logFile);
