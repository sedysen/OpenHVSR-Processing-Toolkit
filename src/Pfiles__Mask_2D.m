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
function Pfiles__Mask_2D(h_fig,h_ax,X,Y)
% 30 November 2017
% Author: Samuel Bignardi Ph.D.
% this is supposed to be a P-file.
% Mask a 2D image keeping only the internal part of points 
%
% h_fig  handle to figure
% h_ax   handle to axis
% X      coordinates
% Y      coordinates
%
set(h_fig,'CurrentAxes',h_ax);
% vectors in colums
 

bdry = boundary(X,Y);  
Xb = X(bdry);% firs and last coordinates are the same point
Yb = Y(bdry);
ymin = min(Yb);
ymax = max(Yb);
%plot(h_ax, X(bdry),Y(bdry),'r');
for p = 2:length(Xb)
    yy=ymax;
    if Xb(p-1)~=Xb(p)
        if Xb(p-1)>Xb(p)
            x2 = Xb(p-1); x1 = Xb(p);% max
            y2 = Yb(p-1); y1 = Yb(p);
        else
            x2 = Xb(p); x1 = Xb(p-1);% max
            y2 = Yb(p); y1 = Yb(p-1);
        end   
        if x1~=x2 && ~(y1==ymax && y2==ymax)
            % compute rect of the two points
            mm = (y1-y2)/(x1-x2);
            qq = y1 - mm*x1;
            % check if all other segments have higher Y in the investigated
            % x-range
            for p2 = 2:length(Xb)
                if p2~=p
                    xin=x1; xfi=x2;%#ok
                    if Xb(p2-1)>Xb(p2)
                        x2e = Xb(p2-1); x1e = Xb(p2);% max
                        y2e = Yb(p2-1); y1e = Yb(p2);
                    else
                        x2e = Xb(p2); x1e = Xb(p2-1);% max
                        y2e = Yb(p2); y1e = Yb(p2-1);
                    end
                    % 
                    if (x1<=x1e && x1e<=x2) || (x1<=x2e && x2e<=x2) || (x1e<=x1 && x2<=x2e)% x-overlap
                        xin=max([x1,x1e]);
                        xfi=min([x2,x2e]);
                        %
                        if x1e~=x2e
                            % compute rect of the two points
                            mme = (y1e-y2e)/(x1e-x2e);
                            qqe = y1e - mme*x1e;
                            y1t = mme*xin +qqe;
                            y2t = mme*xfi +qqe;
                            %
                            y1r = mm*xin +qq;
                            y2r = mm*xfi +qq;

                            if (y1r<y1t && y2r<=y2t) || (y1r<=y1t && y2r<y2t)% new segment has higher y. the box is toward negative y
                                yy=ymin;
                                break;
                            end% compare y
                        end% rect not vertical
                    end
                end% no same segment
            end% check all segments
            Xpoli = [x2;  x1;  x1;  x2];
            Ypoli = [y2;  y1;  yy;    yy];
            fill(Xpoli, Ypoli, [1 1 1], 'EdgeColor','none')
        end
    end
    
end

%fprintf('MASK 2D called\n')



%
end% function