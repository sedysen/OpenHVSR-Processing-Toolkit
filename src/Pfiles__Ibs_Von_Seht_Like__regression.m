function [a,b] = Pfiles__Ibs_Von_Seht_Like__regression(Fr, H)
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

% _________________________________________________________________________
%% Note: a0=96      b0=-1.388   from Ibs-Von Seht FIELD DATA 
a0 = 96;% ---> 
b0 = -1.388;
% 
% %X = FB;
% X = FS;
% Y = HH;
beta0 = [a0,b0];
modelfunction = @(ab,F)ab(1)*(F.^ab(2));% function to be fit by the data
% model_fit = NonLinearModel.fit(X,Y,modelfunction,beta0)%% deprecated
model_fit = fitnlm(Fr,H, modelfunction, beta0);
%
% extract estimate of regression coefficients
a = model_fit.Coefficients.Estimate(1);
b = model_fit.Coefficients.Estimate(2);
%
end