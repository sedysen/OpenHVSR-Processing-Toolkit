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
function TOPOGRAPHY = load_topography(working_folder,TOPOGRAPHY_file_name) 

if ~isempty(TOPOGRAPHY_file_name)
    fprintf('[Loading Extra Topography]\n');
    %fid = fopen(strcat(working_folder, TOPOGRAPHY_file_name),'r');
    filename = strcat(working_folder, TOPOGRAPHY_file_name);
    TOPOGRAPHY = load(filename,'-ascii');

    fprintf('[Loading Done]\n');
end

end%function