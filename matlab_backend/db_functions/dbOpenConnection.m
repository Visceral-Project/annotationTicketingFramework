function [ conn, status ] = dbOpenConnection( logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Opens the connection to the VISCERAL ticketing DB
% DBName, dbUser, dbAdress and dbPort have to be set here!
%
%
% Output:
%   conn        the DB handle
%   status      1, if connection established, 0 otherwise

%% #TOMODIFY - insert the access information for your mysql db here:
dbName = 'visceral_tickets_release';
dbUser = '';
dbPwd = '';
dbAddress = '';
dbPort   = '3306';
conn = database(dbName,dbUser,dbPwd, ...
    'com.mysql.jdbc.Driver', ['jdbc:mysql://' dbAddress ':' dbPort '/']);

status = dbCheckConnStatus(conn, 0);

% display status msg
if ( status == 0 )
    dbLogMsg(['dbOpenConnection (WARNING): ' conn.Message], logFile);
else
    dbLogMsg('dbOpenConnection: DB Connection established!', logFile);
end
