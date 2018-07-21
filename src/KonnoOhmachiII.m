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
function [SM]=KonnoOhmachiII(M,f,b)
% Samuel Bignardi
% 16-01-2013
%
% Usage:
%   KonnoOhmachi(M,f)
%   KonnoOhmachi(M,f,b)
%
%
%
% Konno Ohmachi smoothing
% SM  =>   sin( ( log10( f/fc ) )^b )  / (( log10( f/fc ) )^b)^4
%
% where,
%    f is the frequency,
%    fc is the central frequency where the smoothing is performed,
%    b is the bandwidth coefficient.
%
% The bandwidth of the smoothing function is constant on a logarithmic scale. 
% A small value of b will lead to a strong smoothing, 
% while a large value of b will lead to a low smoothing of the Fourier spectra
%
% This is the recommended option. The default (and generally used) value for b is 40.
%
%
%%__________________________________________
% f must be a column vector
nf=length(f);

if size(f,1)~=1 
    f=f';
    warning('f must be a row')
end
L  = size(M,2);
SM=0*M;
% limit = 0.1*max(M);
% a=tic;

for c=1:nf
    fc=f(c);
    if fc>0
        LO = b*log10( f./fc );
        mask = ( sin( LO )./ LO).^4;
    %     hh=figure;
    %     semilogx(f,mask)
    %     pause
    %     close(hh)


        Nnan = sum(isnan(mask));
        if Nnan>0
            found = 0;
            ii = 0;
            while found < Nnan
                ii = ii+1;
                if isnan(mask(ii))
                    mask(ii)=0;
                    found = found+1;
    %                 fprintf('corrected %d/%d\n',found,Nnan)
                end
            end    
        end  
        NRM = sum(mask);
        for cc=1:L%  works on a matrix, along columns
            SM(c,cc) = mask*M(:,cc)/NRM;
        end
    end
end
% toc(a)
% pause
% 
% figure
% semilogx(f,M(:,1),'k'); hold on
% semilogx(f,smooth(M(:,1)),'g'); hold on
% semilogx(f,SM(:,1),'--r'); hold on















%
%
end% function