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
function tp = cosine_taper(signals,percent)
    % signals in columns

    tp = signals;
    Nr = size(signals,1);
    Nc = size(signals,2);
    n = fix( Nr*(percent/100) );
    if n>1
        mask = 0.5*(1 + cos(  [0:n-1]*pi/(n-1)) ).';

        linep = mask;
        linem = flipud(mask);
        for c = 1:Nc
            tp( 1:n, c ) = signals( 1:n, c ).*linem;
            tp( (Nr-n+1):Nr, c ) = signals( (Nr-n+1):Nr, c ).*linep;
        end
    end
end



