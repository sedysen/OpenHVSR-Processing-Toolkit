%% Copyright 2017 by Samuel Bignardi.
%     www.samuelbignardi.com
%
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
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with OpenHVSR-Processing Toolkit.  If not, see <http://www.gnu.org/licenses/>.
%
%
%
gui_3D_190410();
%
% CHANGELOG
%
% Version 1.0.0 First release
% Version 2.0.0
%       * Optimized memory and space on disk usage
%       * Solved bug for ginput(2) in Matlab R2018a/R2018b
% Version 2.0.1
%       * bugfix with profiles discretization
%       * NEW custom profile names
%       * auto-creation of the "history.m" file
%       * [2019-01-13] bugfix, overlap of station locations once projected on the profile 
%       * [2019-01-30] bugfix, solved the issue with save elaboration function for large projects     
%
%       * [2019-03-30] new features:
%          >> Multiple additional peaks (i.e. besides F0) can now be selected and saved in a txt file
%          >> A profile image (Tab 2D views) can be saved as *.mat file      
%          >> A profile can be extracted from a bigger progect and saved as stand-alone project
%          >> A profile of "Confidence 95%" can now be generated
%



















%%