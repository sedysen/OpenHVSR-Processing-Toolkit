% Example of a OpenHVSR-ProTO project file.
% It requires some basic knowledge of Matlab
%
%
% EXAMPLE OF USE DATA LOADING WHEN FILE FORMAT IS NOT .txt
% BUT A HEADER/DATA STRUCTURE IS PRESENT 
%
% IN THIS EXAMPLE:
%    * ADDITIVE TOPOGRAPHICAL POINTS WERE INCLUDED
%    * A WELL WAS INCLUDED (FEATURE STILL UNDER DEVELOPMENT)
%
datafile_separator = 'header_data_separation_line';% this is the header/data separator in data files.
datafile_columns   = [1 3 2];%                        Index of columns must be specified [V  EW  NS]
%
%% LIST OF DATA TO LOAd
% SURVEYS{?,1}: location
% SURVEYS{?,2}: filename
% SURVEYS{?,3}: sampling frequency (DEFINED MANUALLY !!!)
%
%
%% LIST OF MODELS TO LOAd
SURVEYS{1,1} = [446927,5059986,310]; SURVEYS{1,2} = 'HVSR1.txt'; SURVEYS{1,3}=200;
SURVEYS{2,1} = [445812,5059451,337]; SURVEYS{2,2} = 'HVSR2.txt'; SURVEYS{2,3}=200;
SURVEYS{3,1} = [446519,5060069,311]; SURVEYS{3,2} = 'HVSR3.txt'; SURVEYS{3,3}=200;
SURVEYS{4,1} = [446457,5059891,312]; SURVEYS{4,2} = 'HVSR4.txt'; SURVEYS{4,3}=200;
SURVEYS{5,1} = [446332,5060177,312]; SURVEYS{5,2} = 'HVSR5.txt'; SURVEYS{5,3}=200;
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



