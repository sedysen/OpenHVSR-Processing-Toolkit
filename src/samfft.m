function [FT,df] =samfft(D,Fs,pad_to)
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


% data is supposed to be a power of 2 in length

%% inputs
% Fs               sampling frequency
% pad_to        wanted data length (must be a power of 2)
%% outputs
% FT               Fourier transform (columnwise)
% df               frequency jumps
%%
% FT              positive freq. fourier transform.
% F               frequency vector.
% Fs              sampling frequency.
% df              distance between adjacent frequences
% NFFT            length of the fft pow of 2 vector
%
% FULLFT          full fourier transform.
% FULLF           frequency vector.
%
% SimmFT          simmetric fft.
% SimmF           frequency vector
%
% MFT             Matlab format FFT
%
%
    

    L=size(D,1);
    if pad_to>=L
        temp = D;
        D = zeros( pad_to, size(D,2));
        D(1:L,:) = temp;
    else
        warning('samfft: pad < length of data')
    end
    NFFT = pad_to;
    out_FT = fft(D,NFFT)/L;
    
    %fft coeff. arrangement in matlab
    %[0 f1 .....  fs/2                ]
    %[           -fs/2 ........... -f1]
    % 1 ..... (NFFT/2 +1) 
    %         (NFFT/2 +1)          NFFT] 
%     FULLFT = [out_FT((NFFT/2 +1):end,:);  out_FT(1:(NFFT/2 +1),:)];
%     FULLF = (Fs/2*linspace(-1,1, NFFT+1 )).';
%     
    FT = out_FT(1:NFFT/2+1,:);
    df = (0.5*Fs) / (NFFT/2+1);
end