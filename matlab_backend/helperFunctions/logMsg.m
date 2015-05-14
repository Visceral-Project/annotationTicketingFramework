function [] = logMsg(msg, file_name)

    % write to log file
    fileID = fopen(file_name, 'a+');
    fprintf(fileID, [msg '\n']);
    
    % write to std out
    fprintf([msg '\n']);
end