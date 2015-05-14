function dbLogMsg(msg, file_name,showInCmd)
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Writes a log message to a textfile
%
% Input: 
%   msg                           message to write
%   file_name                     log file path
%   showInCmd                     OPTIONAL - set this parameter if
%   logmessage should be displayed on the command line.

    % create timestamp
    c = clock();
    h = num2str(c(4));
    m = num2str(c(5));
    s = num2str(round(c(6)));
    if (length(h) == 1); h = ['0' h]; end
    if (length(m) == 1); m = ['0' m]; end
    if (length(s) == 1); s = ['0' s]; end
    timestmp = [num2str(c(1)) '-' num2str(c(2)) '-' num2str(c(3)) '|' h ':' m ':' s ];
    
    % add timestamp to msg
    msg = [timestmp ': ' msg];
    
    % write to log file
    fileID = fopen(file_name, 'a+');
    fprintf(fileID, [msg '\n']);
    
    % close file
    fclose(fileID);
    
    % write to std out
    if ( nargin > 2 ); fprintf([msg '\n']); end
end