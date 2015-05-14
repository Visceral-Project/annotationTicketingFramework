function [ DBAnnotationTypes, status ] = dbGetAnnotationType( annotationTypeID, name, logFile)
%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%
%
% Description:
% Queries the VISCERAL DB table annotationtype given the ID or the name
% 
%
% Input: 
%   annotationTypeID         id of the annotation type table entry       
%   name                     name of the annotation type ('landmarks',...)
%  
%
% Output:
%   DBAnnotationTypes       Struct array, holding from the query returned
%                           annotation types
%
%
% Example:
% Query all entries of the table annotationType
% [ DBAnnotationTypes, status ] = dbGetAnnotationType( [], [], logFile)
%

functionName = 'dbGetAnnotationType';

% init jave mysql path
if ( isempty(strfind(javaclasspath, 'mysql-connector-java-5.1.18-bin.jar')) )
    javaaddpath('res/mysql-connector-java-5.1.18-bin.jar');
end

% establish db connection
[ conn, status ] = dbOpenConnection(logFile);

% init result struct
DBAnnotationTypes = [];

% check if connection is established
if ( status == 1 )
    
    sqlStatement = 'select * from annotationtype where 1=1';
    
    % add constraints
    if ( ~isempty(annotationTypeID) ); sqlStatement = [sqlStatement ' and annotationTypeID=' num2str(annotationTypeID) ]; end
    if ( ~isempty(name) ); sqlStatement = [sqlStatement ' and name="' name '"']; end
    
    % execute sql statement
    [ status, curs] = dbExecuteStatement(conn, sqlStatement, logFile);
    if ( status == 0 )
        dbLogMsg(['DB-WARNING (' functionName '): select statement failed!'], logFile);
        dbLogMsg('', logFile); return;
    end

    % fetch data
    newCurs = fetch(curs);
        
    %% post processing of results
    nRows = rows(newCurs);

    if ( nRows > 0 )

        DBAnnotationTypes = struct([]);
        
        for iRow = 1 : nRows

            DBAnnotationTypes(iRow).annotationTypeID  = newCurs.Data{iRow,1};
            DBAnnotationTypes(iRow).name   = newCurs.Data{iRow,2};
            DBAnnotationTypes(iRow).FileExtension   = newCurs.Data{iRow,3};
            DBAnnotationTypes(iRow).RemoteUploaddir = newCurs.Data{iRow,4};
            DBAnnotationTypes(iRow).fileNamePart   = newCurs.Data{iRow,5};
            DBAnnotationTypes(iRow).category   = newCurs.Data{iRow,6};

        end
    end

    % display that select was successfull
    if ( status == 1 ); dbLogMsg(['DB-INFO (' functionName '): ' num2str(nRows) ' volumes selected!'], logFile); end
    dbLogMsg('', logFile);
    
    % close db connection
    dbCloseConnection(conn, logFile);
else
    dbLogMsg(['DB-WARNING (' functionName '): no connection established!'], logFile);
end
