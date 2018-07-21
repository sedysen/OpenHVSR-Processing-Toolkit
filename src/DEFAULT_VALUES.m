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