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
function [X,Y,Z,V,p1,p2] = smoothvolume3(X,Y,Z,V, xl,yl,zl, cutplanes)

%clc
% x-/x-
Lx = size(V,2);
xm  = floor(length(xl)*(cutplanes(1)));  if xm < 1; xm =1; end
xp  = floor(length(xl)*(cutplanes(2)));  if xp > Lx; xp =Lx; end
if(xm >= Lx); xm = floor(Lx/2); end
if(xp <= 1);  xp = floor(Lx/2); end
if(xm>=xp); xp=xm+1; end
% y-/y-
Ly = size(V,1);
ym  = floor(length(yl)*(cutplanes(3))); if ym < 1; ym =1; end
yp  = floor(length(yl)*(cutplanes(4))); if yp > Ly; yp =Ly; end
if(ym >= Ly); ym = floor(Ly/2); end
if(yp <= 1);  yp = floor(Ly/2); end
if(ym>=yp); yp=ym+1; end
% z-/z-
Lz = size(V,3);
zm  = floor(length(zl)*(cutplanes(5))); if zm < 1; zm =1; end
zp  = floor(length(zl)*(cutplanes(6))); if zp > Lz; zp =Lz; end
if(zm >= Lz); zm = floor(Lz/2); end
if(zp <= 1);  zp = floor(Lz/2); end
if(zm>=zp); zp=zm+1; end

% ym
% yp 
% xm
% xp
% zm
% zp
X = X(ym:yp, xm:xp, zm:zp);
Y = Y(ym:yp, xm:xp, zm:zp);
Z = Z(ym:yp, xm:xp, zm:zp);
V = V(ym:yp, xm:xp, zm:zp); 
% Dp=Dp(ym:yp, xm:xp, zm:zp); 
% Dm=Dm(ym:yp, xm:xp, zm:zp); 


hold on
val = -10

% V = smooth3(V);
[fo,vo] = isosurface(X,Y,Z,V,val);               % isosurface for the outside of the volume
[fe,ve,ce] = isocaps(X,Y,Z,V,val);               % isocaps for the end caps of the volume

p1 = patch('Faces', fo, 'Vertices', vo);       % draw the outside of the volume
p1.FaceColor = 'red';
p1.EdgeColor = 'none';

p2 = patch('Faces', fe, 'Vertices', ve, ...    % draw the end caps of the volume
   'FaceVertexCData', ce);
p2.FaceColor = 'interp';
p2.EdgeColor = 'none';





% p1 = patch( isosurface(X,Y,Z,Dp, 0.01),'FaceColor','red','EdgeColor','none');
% p2 = patch( isosurface(X,Y,Z,Dm, 0.01),'FaceColor','blue','EdgeColor','none');

%patch(isocaps(X,Y,Z,V, 5),'FaceColor','interp','EdgeColor','none');
%patch(isocaps(X,Y,Z,V, 5, 'enclose','above'),'FaceColor','interp','EdgeColor','none');

% p3 = patch( isocaps(X,Y,Z,V.*(V>0), 0.001, 'enclose','above'),'FaceColor','interp','EdgeColor','none');
% p4 = patch( isocaps(X,Y,Z,V.*(V<0), -0.001, 'enclose','below'),'FaceColor','interp','EdgeColor','none');

%min(min(min(X)))

% p1 = patch(isosurface(X,Y,Z,V),'FaceColor','interp','EdgeColor','none');
%p1 = patch(isosurface(X,Y,Z,V, 5),'FaceColor','interp','EdgeColor','none');
% isonormals(X,Y,Z,V,p1);
%p2 = patch(isocaps(X,Y,Z,V, 5),'FaceColor','interp','EdgeColor','none');




camlight left; 
camlight; 
lighting gouraud
view(3);
colorbar
hold off

xlabel('X');
ylabel('Y');
zlabel('Z');



end