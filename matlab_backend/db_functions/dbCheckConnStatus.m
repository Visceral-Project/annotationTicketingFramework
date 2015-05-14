function [ status ] = dbCheckConnStatus( conn, showMsg, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Checks the status of a dabes connection
%
% Input: 
%   - conn          data base connection handle
%   - showMsg       1: show status and write to log file
%                   0: don't show status and write to log file
%   - logFile       path to log file
%
%
% Output:
%   1 if connection is open
%   0 if connection is closed

% get status
status = isconnection(conn);

if ( ~showMsg ); return; end;

% check for open connection
if( status )
    dbLogMsg('dbCheckConnStatus: DB Connection open!', logFile);
else
    dbLogMsg('dbCheckConnStatus: DB Connection closed!', logFile);
end
