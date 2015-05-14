function [ status ] = dbCloseConnection( conn, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Closes a DB connection
%
% Input: 
%   - conn          data base connection handle
%   - logFile       path to log file
%
%
% Output:
%   1 connection closed
%   0 connection could not be closed

close(conn);
status = ~dbCheckConnStatus(conn, 0);

% display status msg
if( status == 0 )
    dbLogMsg('dbCloseConnection (WARNING): DB Connection can not be closed!', logFile);
else
    dbLogMsg('dbCloseConnection: DB Connection closed!', logFile);
end
