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
function [H] = Pfiles__Ibs_Von_Seht_Like__HfromF(fr,a,b)
    % Ibs-von Seht and Wolemberg - style calculation
    % Compute depth of bedrock (H) by knowing the main resonant frequency (fr) and
    % the parameters a,b of the function H = H(f)
    %
    % The function H(f) is computed by regression 
    %
    % Inputs:
    % fr             main resonant frequence
    % a,b            parameter of the function connecting depth H and
    %                frequency f
    %
    % Outputs:
    % H              depth of bedrock
    %
    %a = 96;         from Ibs-von Seht and Wohlenberg 1999
    %b = -1.388;     from Ibs-von Seht and Wohlenberg 1999
    %
    %
    %
    % H = a*fr^b;
    H= a*(fr.^b);
end
