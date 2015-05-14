% This file contains example code for DB getter and setter functions to modify the ticketing  data base.
% DB functions are located at ./db_functions/
%
%
% Please contact Markus Krenn (markus.krenn@meduniwien.ac.at for further
% support.

%% initialize Framework - modify parts marked by #TOMODIFY of this file
initializeFramework;

% And modify DB access data in ./db_functions/dbOpenConnection
[ conn, status ] = dbOpenConnection( logFile );

%% (1) Manipulate volumes
% Get all volumes in the DB 
[ DBVolumes, status ] = dbGetVolumes( [], [], [], [], logFile);

for i = 1 : numel(DBVolumes)
   DBVol = DBVolumes(i);
   disp(DBVol); 
end

% Add volume
patientID = '10001';
volumeID = 2;
modality = 'MRT1';
bodyRegion = 'Ab';
fileName = '10001_2_MRT1_Ab.nii.gz';
dbAddVolume( patientID, volumeID, modality, bodyRegion, fileName, logFile );

% Get the new volume
patientID = '10001';
volumeID = 2;
modality = [];
bodyRegion = [];

[ newDBVolume, status ] = dbGetVolumes( patientID, volumeID, modality, bodyRegion, logFile);

% update volume
newDBVolume.modality = 'MRT2';
newDBVolume.filename = '10001_2_MRT2_wb.nii.gz';
[ status ] = dbUpdateVolume( dbVol, logFile );

% remove volume
[ status ] = dbRemoveVolume( newDBVolume.patientID, newDBVolume.volumeID, logFile );


%% (2) Generate tickets for all volumes in the DB

% get all volumes
[ DBVolumes, status ] = dbGetVolumes( [], [], [], [], logFile);

% get all types of annotations
[ DBAnnotationTypes, status ] = dbGetAnnotationType( [], [], logFile);

for iVolume = 1 : numel(DBVolumes)
    for iAnnotation = 1 : numel(DBAnnotationTypes)
        
        newDBAnn.patientID = DBVolumes(iVolume).patientID;
        newDBAnn.volumeID = DBVolumes(iVolume).volumeID;
        newDBAnn.annotationTypeID = DBAnnotationTypes(iAnnotation).annotationTypeID;
        newDBAnn.annotatorID = 1;        
        newDBAnn.statusID = 0;          % status 0 = pending
        newDBAnn.qcAnnotatorID = 2;
        dbAddAnnotation(newDBAnn,logFile);
    end
end

%% delete annotation ticket
% 1.) get all tickets
[ allDBTickets, status ] = dbGetAnnotation(  [], [], [],  [],[],[], logFile);

% select the first one
ticketToDelete = allDBTickets(1);

% 2.) remove a ticket (this adds the ticket with statusID=4 - deleted
dbRemoveAnnotation(ticketToDelete,logFile);
