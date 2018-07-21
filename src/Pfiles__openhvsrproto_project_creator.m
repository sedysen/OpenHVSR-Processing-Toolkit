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
function [file_format,SURVEYS,datafile_separator,datafile_columns,nameof_topography_file] = ...
    Pfiles__openhvsrproto_project_creator(fontsizeis,folder_name, ...
                SURVEYS,datafile_separator,datafile_columns)

% tabularasa
%fontsizeis = 14
% aa = 0
%%%-----------------------------
%%  
%%%
%% AUTHOR:  Dr. Samuel  Bignardi
%%          University Of Ferrara
%% 
%% Date:    20 May 2016
%%%-----------------------------
if ispc()
    ss = '\';
else
    ss = '/';
end


%% Main variables    ______________________________________________________
% geometrical properties
%SURVEYS = {}; 
%MODELS  = {};
nf = size(SURVEYS,1);
DFILES  = cell(nf,1);
for iii = 1:nf
    DFILES{iii}  = SURVEYS{iii,2};%{};% filename without path
end
last_point = [0, 0, 0];
last_data  = '';
last_data_path  = folder_name;
last_fs  = 250;
% last_modl = '';
% last_modl_path = folder_name;
%datafile_columns   = [1 2 3];% [FREQ. column Id][HVSR. column Id][standard dev. Id]
%datafile_separator = 'none';% in data files: separator between HEADER and DATA
% nameof_reference_model_file1 = '';
% nameof_reference_model_file2 = '';
 nameof_topography_file = [];


%% MAIN GUI ===============================================================
DSP = get(0,'ScreenSize');% [left, bottom, width, height]
main_l = 0.1 * DSP(3);
main_b = 0.1 * DSP(4);
main_w = 0.8 * DSP(3);
main_h = 0.8 * DSP(4);
h_gui = figure('Visible','on', ...
    'OuterPosition',[main_l, main_b, main_w, main_h], ...
    'NumberTitle','off');%  Create and then hide the GUI as it is being constructed.
set(h_gui,'MenuBar','none');    % Hide standard menu bar menus.
file_format = 'saf';

% 
%% PANEL 0
px0 = 0.0;
py0 = 0.0;
pw0 = 0.3;
ph0 = 1.0;
Panel0 = uipanel('FontSize',12,'Position',[px0, py0, pw0, ph0]); 
% %%    Buttons
nbuttons = 10; 
bh = 25; bw = 200;% buttons dimensions
bgap = 3;
blevel= 100;
bx = 5;% distances between buttons bottom edges
by = blevel + (1:nbuttons)*(bh + bgap); 

uicontrol('Style','pushbutton','parent',Panel0, ...
    'String','Setup how data is read (if not saf)', ...
    'Position',[bx, by(end), bw, bh], 'Enable','on', ...
    'Callback',{@B_datread_Callback});
uicontrol('Style','pushbutton','parent',Panel0, ...
    'String','Add Measurement location', ...
    'Position',[bx, by(end-1), bw, bh], 'Enable','on', ...
    'Callback',{@B_add_pnt_Callback});
uicontrol('Style','pushbutton','parent',Panel0, ...
    'String','Remove Measurement location', ...
    'Position',[bx, by(end-2), bw, bh], 'Enable','on', ...
    'Callback',{@B_rem_pnt_Callback});
uicontrol('Style','pushbutton','parent',Panel0, ...
    'String','Add topography', ...
    'Position',[bx, by(end-3), bw, bh], 'Enable','on', ...
    'Callback',{@B_add_topo_Callback});
uicontrol('Style','pushbutton','parent',Panel0, ...
    'String','Save and Exit', ...
    'Position',[bx, by(end-5), bw, bh], 'Enable','on', ...
    'Callback',{@B_save_Callback});

%% PANEL 1
px0 = 0.3;
py0 = 0.0;
pw0 = 0.7;
ph0 = 1.0;
Panel1 = uipanel('FontSize',12,'Position',[px0, py0, pw0, ph0]); 
%
cnames = {'X','Y','Z','Data File'};
columnformat = {'numeric', 'numeric', 'numeric', 'char'};
TB = uitable('Parent',Panel1,'ColumnName',cnames,'Units','normalized','Position',[0.0 0.0 1 1], ...
    'FontSize',fontsizeis,'ColumnFormat',columnformat , ...
    'ColumnWidth','auto','ColumnEditable',logical([1 1 1 0]));
set(TB,'ColumnWidth',{40 40 40 300})

update_list();
%     
%%  Panel 0
    function B_datread_Callback(hObject, eventdata, handles)
        %% get coordinates
        % DEFAULT in ProTO: datafile_columns=[1 2 3];% [V  EW  NS]
        kind = 'Define Location';
        prompt = {'header/data separation string','Vertical in column','East in column','North in column','File extension (format)'};
        def = {datafile_separator, num2str(datafile_columns(1)), num2str(datafile_columns(2)), num2str(datafile_columns(3)), file_format};
        answer = inputdlg(prompt,kind,1,def);
        if(~isempty(answer))
            datafile_separator = answer{1};
            datafile_columns   = [str2double(answer{2}), str2double(answer{3}), str2double(answer{4})];
            file_format = answer{5};
        end
    end% H/V read
    
    function B_add_pnt_Callback(hObject, eventdata, handles)
        %% get coordinates
        kind = 'Define Location';
        switch file_format
            case 'saf'
                prompt = {'X','Y','Z'};
                def = {num2str(last_point(1)), num2str(last_point(2)), num2str(last_point(3))};
            otherwise
                prompt = {'X','Y','Z', 'Samp. Freq.'};
                def = {num2str(last_point(1)), num2str(last_point(2)), num2str(last_point(3)), num2str(last_fs)};
        end
        answer = inputdlg(prompt,kind,1,def);
        %
%         datafile = [];
%         datapath = [];
%         modlfile = [];
%         modlpath = [];
        if(~isempty(answer))
            [datafile,datapath] = uigetfile('*.*', 'H/V curve file', strcat(last_data_path,ss,last_data));
            last_data      = datafile;
            last_data_path = datapath;
        else
            return;
        end
%         if(~isempty(answer) && ~isempty(datafile))
%             [modlfile,modlpath] = uigetfile('*.*', 'Subsurface file', strcat(last_modl_path,ss,last_modl));
%             last_modl      = modlfile;
%             last_modl_path = modlpath;
%         end
        if(~isempty(answer) && ~isempty(datafile))
            id = size(SURVEYS,1)+1;
            SURVEYS{id,1} = [str2double(answer{1}), str2double(answer{2}), str2double(answer{3})];
            SURVEYS{id,2} = datafile;%strcat(datapath,datafile);  
            if length(answer)==4%~strcmp(file_format,'saf')
                SURVEYS{id,3} = answer{4};
                last_fs        = str2double(answer{4});
            end
            DFILES{id}    = datafile;
%             MODELS{id,1} = modlfile;%strcat(modlpath,modlfile);
%             MODELS{id,2} = id;
%             MFILES{id}   = modlfile;
            update_list();
        end
    end% Add point
    function B_rem_pnt_Callback(hObject, eventdata, handles)
        %% get coordinates
        kind = 'select data to remove';
        prompt = {'id'};
        def = {num2str(0)};
        answer = inputdlg(prompt,kind,1,def);
        
        if(~isempty(answer))
            id = str2double(answer{1})
            nr = size(SURVEYS,1);
            if (id>0) && (id<=nr)
                TSURVEYS   = {};    
                TDFILES    = {};
%                 TMODELS    = {};
%                 TMFILES    = {};
                count = 0;
                for ii=1:nr
                    if(ii~=id) 
                        count=count+1;
                        TSURVEYS{count,1} = SURVEYS{ii,1};
                        TSURVEYS{count,2} = SURVEYS{ii,2};
                        TDFILES {count}   = DFILES {ii};
%                         TMODELS {count,1} = MODELS {ii,1};
%                         TMODELS {count,2} = MODELS {ii,2};
%                         TMFILES {count}   = MFILES {ii};
                    end
                end
                SURVEYS = TSURVEYS;    
                DFILES  = TDFILES;
%                 MODELS  = TMODELS;
%                 MFILES  = TMFILES;
            end
            update_list();
        end
    end% Rem point
    function B_add_topo_Callback(hObject, eventdata, handles)
        [topofile,topopath] = uigetfile('*.*', 'H/V curve file', strcat(last_data_path,ss,last_data));
        if(~isempty(topofile))
            nameof_topography_file=topofile;
        end
    end% Add topo
    
    function B_save_Callback(hObject, eventdata, handles)
        close(h_gui)
    end


    function update_list()
        nr   = size(SURVEYS,1);
        DD = cell(nr,4);
        for ii = 1:nr 
            DD{ii,1} = SURVEYS{ii,1}(1);
            DD{ii,2} = SURVEYS{ii,1}(2);
            DD{ii,3} = SURVEYS{ii,1}(3);
            %
            DD{ii,4} = DFILES{ii};
%             DD{ii,5} = MFILES{ii};
        end
        set(TB,'Data',DD);
    end


     waitfor(h_gui);
end %function