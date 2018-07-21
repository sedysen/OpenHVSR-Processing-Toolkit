%% Copyright 2017 by Samuel Bignardi.
%
% This file is part of the program OpenHVSR-Processing Toolkit.
%
% OpenHVSR-Processing Toolkit is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% OpenHVSR-Processing Toolkit is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% You should have received a copy of the GNU General Public License
% along with OpenHVSR-Processing Toolkit.  If not, see <http://www.gnu.org/licenses/>.
%
%
%
function WLLS = Pfiles__load_wells(working_folder,SURVEYS,WELLS)

%% Load Input FILES
% loads one input file. The file is defined by its id
%
%  Same parameters order as Herak
%  vp  vs  rho  h  Qp  Qs

% 1. imput field data
N = size(WELLS,1);
%M = size(MODELS,1);

WLLS = cell(N,1);


fprintf('[Loading Wells]\n');
% WLLS is a cell of cells: each column is a well
% WLLS{1, well-1d}{1} = litotypes 
% WLLS{2, well-1d}{2} = thickness
%        
for m = 1:N% span on available wells
    FileName = WELLS{m,1};%% get filename for the well
    FullFilename = strcat(working_folder, FileName);
    %
    if exist(FullFilename, 'file') == 2
        fid = fopen(FullFilename,'r');
        temp = textscan(fid, '%s %s');
        % litotype = temp{1,1};<<-------------------------------- litotypes
        for l=1;size( temp{1,2},1)%<<---------------------------- thickness
            temp{1,2} = str2double(temp{1,2});
        end
        fprintf('Well[%d] %s.\n',m,FileName);
        WLLS{m,1} = temp;
    else
        WLLS{m,1} = [];
        %message = strcat('SAM: well file [',FileName,'] was not found. Only coordinates were retained.');
        %warning(message)
        fprintf('MESSAGE: well file named:[%s] was not found.\n',FileName)
        fprintf('         Only coordinates were retained.\n')
        fprintf('\n')
    end
end
fprintf('[Loading Done]\n');

end%function