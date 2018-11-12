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
fprintf('READ: DEFAULT_VALUES.m\n')
fprintf('      Interface default values can be\n')
fprintf('      customized by editing this file.\n')
% 
% 
%
%%    Default values
default_values.window_width                             = 30;% (seconds)
default_values.window_overlap_pc                        = 50;% percent overlap
default_values.tap_percent                              =  5;% percent windows tapering
default_values.lta_window_length                        = 30;% long  term window length (s) 
default_values.sta_window_length                        =  1;% short term window length (s)
default_values.sta_lta_ratio                            =  4;% short-term-amplitude = pp_sta_lta_ratio * long-term-amplitude
default_values.pad_length                               = 'off';% pad windows to this length
default_values.frequence_min                            =  0.5;
default_values.frequence_max                            = 50;
default_values.smoothing_constant                       = 40; % number
%
%
%
%% data filters
%%   Bandpass: Butterworth IIR filter
default_values.Bandpss_Order = 4;
default_values.Lowpss_Order  = 4;
default_values.Highpss_Order = 4;











%%