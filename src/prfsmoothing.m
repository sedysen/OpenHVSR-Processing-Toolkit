function [OUT] = prfsmoothing(IN, smoothing_strategy, smoothing_radius)
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


    %% Smoothing ===========================================================
    nex = size(IN,2);
    nez = size(IN,1);
    r = smoothing_radius;
    SMOOTH = 0*IN;
    switch smoothing_strategy
        case 1
            %fprintf('Smoothing -1- layerwise\n');
            for k = 1:nez
                for i = 1:nex
                    imin = (i-r); if(imin <   1); imin =   1; end
                    imax = (i+r); if(imax > nex); imax = nex; end

                    is = imin:imax;
                    vals = IN(k,is);
                    SMOOTH(k,i) = sum( vals )/sum( vals>0 );
                end
            end
        case 2
            %fprintf('Smoothing -2- broad layer\n');
            for k = 1:nez
                for i = 1:nex
                    imin = (i-r); if(imin <   1); imin =   1; end
                    imax = (i+r); if(imax > nex); imax = nex; end

                    kmin = (k-1); if(kmin <   1); kmin =   1; end
                    kmax = (k+1); if(kmax > nez); kmax = nez; end

                    is = imin:imax;
                    ks = kmin:kmax;
                    vals = IN(ks,is); 
                    SMOOTH(k,i) = sum( vals )/sum( vals>0 );
                end
            end            
        case 3
            %fprintf('Smoothing -3- bubble\n');
            for k = 1:nez
                for i = 1:nex
                    imin = (i-r); if(imin <   1); imin =   1; end
                    imax = (i+r); if(imax > nex); imax = nex; end

                    kmin = (k-r); if(kmin <   1); kmin =   1; end
                    kmax = (k+r); if(kmax > nez); kmax = nez; end

                    is = imin:imax;
                    ks = kmin:kmax;
                    vals = IN(ks,is); 
                    SMOOTH(k,i) = sum( vals )/sum( vals>0 );
                end
            end
       otherwise
            SMOOTH = IN;
            %fprintf('Smoothing -0- NOT PERFORMED\n');
    end
    OUT = SMOOTH;
    %fname = strcat(colorkind,'_dir',dir,'_shot',sh,'.mat');
    %save(fname);
end


