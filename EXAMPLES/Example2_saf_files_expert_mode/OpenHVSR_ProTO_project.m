% Example of a OpenHVSR-ProTO project file.
% It requires some basic knowledge of Matlab
%
% EXAMPLE OF USE OF THE HIDDEN VARIABLE "idx" TO ALLOW
% ENABLING/DISABLING MEASUREMENTS IN THE SURVEY.
% IN THIS EXAMPLE:
%    
%    * MEASUREMENTS 5 AND 6 WERE DISABLED 
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
idx = 0; 
idx=idx+1; SURVEYS{idx,1} = [446927,5059986,310]; SURVEYS{idx,2} = 'HVSR1.SAF';
idx=idx+1; SURVEYS{idx,1} = [445812,5059451,337]; SURVEYS{idx,2} = 'HVSR2.SAF';
idx=idx+1; SURVEYS{idx,1} = [446519,5060069,311]; SURVEYS{idx,2} = 'HVSR3.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [446457,5059891,312]; SURVEYS{idx,2} = 'HVSR4.SAF'; 
% DISABLED-> idx=idx+1; SURVEYS{idx,1} = [446332,5060177,312]; SURVEYS{idx,2} = 'HVSR5.SAF'; 
% DISABLED-> idx=idx+1; SURVEYS{idx,1} = [446070,5060311,312]; SURVEYS{idx,2} = 'HVSR6.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [445534,5060547,322]; SURVEYS{idx,2} = 'HVSR7.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [446244,5059937,314]; SURVEYS{idx,2} = 'HVSR8.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [445617,5060305,330]; SURVEYS{idx,2} = 'HVSR9.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [445884,5059989,330]; SURVEYS{idx,2} = 'HVSR10.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [446376,5059744,314]; SURVEYS{idx,2} = 'HVSR11.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [445807,5059777,333]; SURVEYS{idx,2} = 'HVSR12.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [444935,5061287,331]; SURVEYS{idx,2} = 'HVSR13.SAF';
idx=idx+1; SURVEYS{idx,1} = [445883,5060152,320]; SURVEYS{idx,2} = 'HVSR14.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [446725,5060004,306]; SURVEYS{idx,2} = 'HVSR15.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [446781,5059985,306]; SURVEYS{idx,2} = 'HVSR16.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [446108,5060108,312]; SURVEYS{idx,2} = 'HVSR17.SAF'; 
idx=idx+1; SURVEYS{idx,1} = [445762,5059942,330]; SURVEYS{idx,2} = 'HVSR18.SAF'; 
% NO FILE 19
idx=idx+1; SURVEYS{idx,1} = [446185,5059836,326]; SURVEYS{idx,2} = 'HVSR20.SAF';%19 
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



