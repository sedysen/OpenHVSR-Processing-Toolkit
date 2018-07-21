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
function Pfiles__SparsePoints_to_Mesh_Surface(surface_locations,extra_locations,topmost,nx,ny, facecolr, edgecolr)
    %
    % THIS USES MESHGRID
    % topmost = topmost value for fake points
    locations = surface_locations;
    if ~isempty(extra_locations)
        % only X,Y of extra locations are considered
        next = size(extra_locations,1);
        zvec = topmost*ones(next,1);
        additive_points = [extra_locations(:,1:2), zvec];
        locations = [ surface_locations; additive_points ];
    end
    
    
    xq = linspace(min(locations(:,1)), max(locations(:,1)), nx);
    yq = linspace(min(locations(:,2)), max(locations(:,2)), ny);
    %
    bnd = boundary(locations(:,1) ,locations(:,2));
    xb = locations(bnd,1);
    yb = locations(bnd,2);
    
    %% extra points inside the boundary must be placed with a Z adequate to the data
    if ~isempty(extra_locations)
        %% find extra points inside boundary
        xtest = extra_locations(:,1);
        ytest = extra_locations(:,2);
        [in,on] = inpolygon(xtest,ytest,xb,yb);
        list = in.*not(on);
        %% interpolate data points
        % ifx increases along the raw
        % ify increases along the column
        [ifx,ify,interp_surface] = Pfiles__points_to_surface_grid(xq,yq,surface_locations);
        
        
        %% look for closest interpolated
        internal_extra = additive_points;
        for ii = 1:length(list);% show additive, in-boundary points 
            if list(ii)==1;% internal ponts 
                %% x-id
                xvec = abs(ifx(1,:)-xtest(ii)).';
                [r,~] = find(xvec==min(xvec));
                ir = r(1);
                
                %% y-id
                yvec = abs(ify(:,1)-ytest(ii));
                [r,~] = find(yvec==min(yvec));
                ic = r(1);
                %%
                if (~isempty(ir)) && (~isempty(ic))
                    internal_extra(ii,:) = [ifx(ir,ic), ify(ir,ic) interp_surface(ir,ic)];
                end
            end
        end
        locations = [ surface_locations; internal_extra];
    end
        
    %end
    
    
    %% Create surface 
    %[sfx,sfy,meshed_surface] = surface_compute();
    [sfx,sfy,meshed_surface] = Pfiles__points_to_surface_grid(xq,yq,locations);
    for ii = 1:size(meshed_surface,1)
        for jj = 1:size(meshed_surface,2)
            in = inpolygon(sfx(ii,jj),sfy(ii,jj),  xb,yb);
            if in==0
                meshed_surface(ii,jj) = NaN;
            end
        end
    end
    %
    %
    mesh(sfx,sfy,meshed_surface,'FaceColor',facecolr,'Edgecolor',edgecolr);
    grid 'off'
%     if ~isempty(additive_points)% additive points
%         hold on
%         plot3(additive_points(:,1),additive_points(:,2),additive_points(:,3),'diamondk')
%     end 
%     for ii = 1:length(list);% show additive, in-boundary points 
%         if list(ii)==1; 
%             hold on
%             plot(xtest(ii),ytest(ii),'squareb','MarkerFaceColor','b'); 
%         end
%     end
%     
%     for ii = 1:size(internal_extra,1);% show additive, in-boundary points 
%         if list(ii)==1; 
%             hold on
%             plot(internal_extra(ii,1),internal_extra(ii,2),'squareb','MarkerFaceColor','g'); 
%         end
%     end
    
    
    
    
%     %% SUBFUNCTIONS
%     function [sfx,sfy,meshed_surface] = surface_compute() 
%         [sfx,sfy,meshed_surface] = points_to_surface_grid(xq,yq,locations);
%     end

%
end % function
