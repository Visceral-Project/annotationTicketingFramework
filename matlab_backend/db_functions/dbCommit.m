function [ status ] = dbCommit( conn, logFile )
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
% Commits changes to the DB

% commit changes
curs = exec(conn, 'commit');

% check if everything is fine
status = isempty(curs.Message);

% display status msg
if ( status == 0 )
    dbLogMsg(['dbCommit (WARNING): ' curs.Message], logFile);
else
    dbLogMsg('dbCommit: Commit done!', logFile);
end