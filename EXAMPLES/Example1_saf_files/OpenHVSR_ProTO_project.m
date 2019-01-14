% Example of a OpenHVSR-ProTO project file.
% It requires some basic knowledge of Matlab
%
% IN THIS EXAMPLE:
%    
%    * ADDITIVE TOPOGRAPHICAL POINTS WERE INCLUDED
%    * A WELL WAS INCLUDED (FEATURE STILL UNDER DEVELOPMENT)
%
%% LIST OF DATA TO LOAd
% SURVEYS{?,1}: location
% SURVEYS{?,2}: filename
% SURVEYS{?,3}: sampling frequency (Not necessary for *.SAF files)
%
%
%% LIST OF MODELS TO LOAd
SURVEYS{1,1} = [446927,5059986,310]; SURVEYS{1,2} = 'HVSR1.SAF';
SURVEYS{2,1} = [445812,5059451,337]; SURVEYS{2,2} = 'HVSR2.SAF';
SURVEYS{3,1} = [446519,5060069,311]; SURVEYS{3,2} = 'HVSR3.SAF'; 
SURVEYS{4,1} = [446457,5059891,312]; SURVEYS{4,2} = 'HVSR4.SAF'; 
SURVEYS{5,1} = [446332,5060177,312]; SURVEYS{5,2} = 'HVSR5.SAF'; 
SURVEYS{6,1} = [446070,5060311,312]; SURVEYS{6,2} = 'HVSR6.SAF'; 
SURVEYS{7,1} = [445534,5060547,322]; SURVEYS{7,2} = 'HVSR7.SAF'; 
SURVEYS{8,1} = [446244,5059937,314]; SURVEYS{8,2} = 'HVSR8.SAF'; 
SURVEYS{9,1} = [445617,5060305,330]; SURVEYS{9,2} = 'HVSR9.SAF'; 
SURVEYS{10,1} = [445884,5059989,330]; SURVEYS{10,2} = 'HVSR10.SAF'; 
SURVEYS{11,1} = [446376,5059744,314]; SURVEYS{11,2} = 'HVSR11.SAF'; 
SURVEYS{12,1} = [445807,5059777,333]; SURVEYS{12,2} = 'HVSR12.SAF'; 
SURVEYS{13,1} = [444935,5061287,331]; SURVEYS{13,2} = 'HVSR13.SAF';
SURVEYS{14,1} = [445883,5060152,320]; SURVEYS{14,2} = 'HVSR14.SAF'; 
SURVEYS{15,1} = [446725,5060004,306]; SURVEYS{15,2} = 'HVSR15.SAF'; 
SURVEYS{16,1} = [446781,5059985,306]; SURVEYS{16,2} = 'HVSR16.SAF'; 
SURVEYS{17,1} = [446108,5060108,312]; SURVEYS{17,2} = 'HVSR17.SAF'; 
SURVEYS{18,1} = [445762,5059942,330]; SURVEYS{18,2} = 'HVSR18.SAF'; 
% NO FILE 19
SURVEYS{19,1} = [446185,5059836,326]; SURVEYS{19,2} = 'HVSR20.SAF'; 
%
%
%
%% ADDITIVE POINTS FOR CONTOURING
% load a XYZ ascii file containing extra (topographycal) points
TOPOGRAPHY_file_name = 'extra_topographycal_points.txt';
%
%
%
%% WELLS (FUTURE DEVELOPMENT)
% The list of wells is defined as
% 1: file-name containing the well data
% 2: location (for display purposes)
% 3: linked H/V measurements
%
% every well is defined by lito-type and thickness
% and can be linked to one or more H/V measurements
%
%
%



