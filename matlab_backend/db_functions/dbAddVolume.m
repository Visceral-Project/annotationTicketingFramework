function [ status ] = dbAddVolume( patientID, volumeID, modality, bodyRegion, fileName, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Adds a volume to the VISCERAL ticketing table VOLUME 
%
% Input: 
%   patientID           PrimaryKey
%   volumeID            PrimaryKey
%   modality            
%   annotatorID       
%   bodyRegion         
%   fileName            
%

functionName = 'dbAddVolume';

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% check if connection is established
if ( status == 1 )
    
    % create sql statement
    sqlStatement = ['insert into volume (patientid, volumeid, modality, bodyregion, filename) values ("' ... 
        patientID '",' num2str(volumeID) ',"' modality '","' bodyRegion '","'  fileName '")'];
    
    % execute sql statement
    status = dbExecuteStatement(conn, sqlStatement, logFile);
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): insert failed!'], logFile);
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
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): volume added!'], logFile, 1); end
dbLogMsg('', logFile);
