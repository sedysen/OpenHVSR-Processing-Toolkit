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
function contourf_2D_of_scattered_points__2012b(hfig,hax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, n_color_levels)
set(hfig,'CurrentAxes',hax);
% use of TriScatteredInterp

%% test 2-D scattered data show:
% close all
% clear
% clc
% 
% Xscatt = [ 0   6   0   6   3]'; 
% Yscatt = [ 0   0   6   6   3]';
% Vscatt = [ 0   0   0   0   1]';
% nx=50;
% ny=nx;
% %ny=20;



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



%F = scatteredInterpolant(Xscatt, Yscatt, Vscatt);% the interpolant 

Xlin = linspace(  (min(Xscatt)),  (max(Xscatt)), nx);
Ylin = linspace(  (min(Yscatt)),  (max(Yscatt)), ny);
[Xplan,Yplan] = meshgrid(Xlin,Ylin);
%Vplan = F(Xplan,Yplan);


F = TriScatteredInterp(Xscatt, Yscatt, Vscatt,'linear');%'natural');

Vplan = F(Xplan,Yplan);
%meshed_surface = interp2(sfx2,sfy2,meshed_surface2, sfx,sfy, 'linear');

% mesh( Xplan, Yplan, Vplan );hold on;
%  figure
% contourf(Xplan, Yplan, Vplan);
clevels = linspace(min(Vscatt),max(Vscatt),n_color_levels);
%contourf(Xplan, Yplan, Vplan,clevels,'EdgeColor','none');
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