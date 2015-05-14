%
% Author: Markus Krenn @ CIR Lab (Medical University of Vienna)
% email:  markus.krenn@meduniwien.ac.at
%

%% clean up
clc;
close all;
clear all;

%% initialize paths
restoredefaultpath();

% add code paths
javaaddpath('resources/mysql-connector-java-5.1.18-bin.jar');
addpath(genpath('db_functions'));
addpath('helperFunctions');

% set file paths
curDir = pwd();
logFile = [curDir '/logFiles/log-File-' num2str(timestamp) '.txt'];

%% #TOMODIFY
dataDirectory = '/project/visceral/DATA/';

% volume and annotation paths
VisceralPaths.volumePath            = [ dataDirectory, 'volumes/' ];
VisceralPaths.manAnnPath            = [ dataDirectory, 'manual_annotations/' ];
VisceralPaths.manLmAnnPath          = [ dataDirectory, 'manual_landmark_annotations/' ];
VisceralPaths.manLesAnnPath         = [ dataDirectory, 'manual_lesion_annotations/' ];
