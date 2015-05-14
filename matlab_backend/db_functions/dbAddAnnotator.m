function [ status ] = dbAddAnnotator( annotatorID, contactInfo, surName, firstName,  qc, available, pwd, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
% Description:
% Inserts an entry to the VISCERAL ticketing DB table ANNOTATOR
%
% Input: 
%   annotatorID         ID of the annotator    
%   contactInfo         contact information (login username, e-mail)
%   surName                      
%   firstName                      
%   qc                  flag, indication if annotator is part of the
%                       quality check team
%   available           flag, indicating if the annotator is currently
%                       available for annotation
%   pwd                 password of the annotator
%
% Output:
%   1 if insert succeeded
%   0 if insert failed

functionName = 'dbAddAnnotator';

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% check if connection is established
if ( status == 1 )
    
    % create sql statement
    sqlStatement = ['insert into annotator (annotatorid, contactinfo, surname, firstname, available, performance, numberofannotations, qc, password) values (' ...
        num2str(annotatorID) ',"' contactInfo '","' surName '","' firstName '",' num2str(available) ',' num2str(performance) ',' num2str(numberOfAnnotations) ',' num2str(qc) ',"' pwd '")'];
    
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
if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): annotator added!'], logFile, 1); end

dbLogMsg('', logFile);


end