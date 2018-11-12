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
function contourf_2D_of_scattered_points__ScattInterpol(hfig,hax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, n_color_levels)

% use of scatteredinterpolant
%% Inputs:

% n_color_levels = 50;
% hfig: figure handle
% hax: axis handle
% nx: number of points alog x
% ny: number of points alog y
% dl: extra space
% %
% Xscatt  
% Yscatt 
% Vscatt x,y,z of the scattered points
% %

%% test 2-D scattered data show:
% close all
% clear
% clc
% 
% Xscatt = [ 0  10  5 0  10]'; 
% Yscatt = [ 0   0  5  10  10]';
% Vscatt = Xscatt+Yscatt;
set(hfig,'CurrentAxes',hax);

dd = 0;%dl/2;
F = scatteredInterpolant(Xscatt, Yscatt, Vscatt);% the interpolant 

Xlin = linspace(  (min(Xscatt)-dd),  (max(Xscatt)+dd), nx);
Ylin = linspace(  (min(Yscatt)-dd),  (max(Yscatt)+dd), ny);
[Xplan,Yplan] = meshgrid(Xlin,Ylin);

Vplan = F(Xplan,Yplan);

% mesh( Xplan, Yplan, Vplan );hold on;
%  figure
% contourf(Xplan, Yplan, Vplan);
clevels = linspace(min(Vscatt),max(Vscatt),n_color_levels);
% contourf(Xplan, Yplan, Vplan,clevels,'EdgeColor','none');

switch colorstyle
    case 'filled'
        contourf(Xplan,Yplan,Vplan,clevels,'EdgeColor','none');
    case 'lines '%<< mind the space
        contour(Xplan,Yplan,Vplan,clevels)%,'EdgeColor','none');
    otherwise
        warning('SAM: case failed: contourf_2D_of_scattered_points__2012b')
end

% hold(hax,'on')
%     colorbar
% fprintf('[end]')
end