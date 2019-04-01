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
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with OpenHVSR-Processing Toolkit.  If not, see <http://www.gnu.org/licenses/>.
%
%
%
function gui_3D()
%% Clean memory
clear global
close all
clear
clc
feature('DefaultCharacterSet', 'UTF8');
% manage matlab warnings
warning ('off','all');
%% BETA FEATURES
experimental_directionality = 0;   delta_angle_allowed = 20;% [1]on [0]off
%
%
%% Special variables defined for special uses (to load project)
idx ='';
% i = 0;
% dx= 0;  %% probably unused
% x = 0;  %% probably unused
%
%
%% Set core variables
G = [];
H = [];
P = [];
default_values = [];
Pfiles_SET_ONOFF_FEAT%          extra features
Pfiles_IFLAGS%                  flags deciding components behavior
DEFAULT_VALUES%                default data-processing values
Pfiles__INTERNAL_VARIABLES%     contains private variables
%
%
%% Get USER preferences
USER_PREFERENCE_Move_over_suggestions                   = '';
USER_PREFERENCE_interface_objects_fontsize                = 0; 
USER_PREFERENCE_enable_Matlab_default_menu          = 0;
USER_PREFERENCE_hvsr_directional_reference_system  = '';
USER_PREFERENCES
%
%
%% Tool Variable
SURVEYS    = {};                                % Surveys Description [location][file-name][sampling frequency]
WELLS      = {};                                % drilled wells
DDAT       = {};                                % Field Data          {a row for each data file, 3 (V, E, N) }
FDAT       = {};                                % Filtered Field Data {a row for each data file, 3 (V, E, N) }
TOPOGRAPHY = [];
TOPOGRAPHY_file_name = '';
WLLS       = {};
receiver_locations     = [];                   % (3D) stations locations
reference_system  = [];
Status_bkground_color = 0.95*[1 1 1];
% obsolete: r_distance_from_profile = 50;                  % (3D)
%
BREAKS = [];%                                     breaks of the profile:
%
well_to_show                  = 0;
%
datafile_columns   = [1 2 3];% [V  EW  NS]
datafile_separator = 'none';% in data files: separator between HEADER and DDAT
temporary_profile = cell(1,3);% temporarily store here a profile matrix (To allow user output in txt): {matrix}{x}{z}  
%
%
%
%% Data properties
sampling_frequences = [];
%
%                                                                 must be smaller than this treshold.
%% Database: DTB =================
%%   DTB__status
DTB__status = [];%                                            DTB{s,1}.status                     [N,1] vector
DTB__elaboration_progress=[];%                      DTB{s,1}.alaboration_progress
%%   DTB__windows
DTB__windows__width_sec   = [];%         DTB{s,1}.windows.width_sec          [N,1] vector           
DTB__windows__number      = [];%          DTB{s,1}.windows.number             [N,1] vector 
DTB__windows__number_fft  = [];%         DTB{s,1}.windows.number_fft         [N,1] vector
DTB__windows__indexes     = {};%          DTB{s,1}.windows.indexes            [element is a Nwin*2 matrix]
DTB__windows__is_ok       = {};%            DTB{s,1}.windows.is_ok              [element is a Nwin*2 matrix]
DTB__windows__winv        = {};%          DTB{s,1}.windows.winv               [element is a Nwin*nf matrix]                 
DTB__windows__wine        = {};%         DTB{s,1}.windows.wine               [element is a Nwin*nf matrix]
DTB__windows__winn        = {};%         DTB{s,1}.windows.winn               [element is a Nwin*nf matrix]
DTB__windows__fftv        = {};%         DTB{s,1}.windows.fftv               [element is a Nwin*nf matrix]
DTB__windows__ffte        = {};%         DTB{s,1}.windows.ffte               [element is a Nwin*nf matrix]
DTB__windows__fftn        = {};%         DTB{s,1}.windows.fftn               [element is a Nwin*nf matrix]
DTB__windows__info = [];%                DTB{s,1}.windows.info = [1 x 6];    [N,6] vector                   
%%   DTB__elab_parameters        
DTB__elab_parameters__status = {};%           DTB{s,1}.elab_parameters.status
DTB__elab_parameters__hvsr_strategy = [];%    DTB{s,1}.elab_parameters.hvsr_strategy = get(T2_PA_HV,'Value');% picked from interface
DTB__elab_parameters__hvsr_freq_min = [];%    DTB{s,1}.elab_parameters.hvsr_freq_min = default_values.frequence_min;
DTB__elab_parameters__hvsr_freq_max = [];%    DTB{s,1}.elab_parameters.hvsr_freq_max = default_values.frequence_max;
DTB__elab_parameters__windows_width = [];%    DTB{s,1}.elab_parameters.windows_width = default_values.window_width;
DTB__elab_parameters__windows_overlap =  [];% DTB{s,1}.elab_parameters.windows_overlap = default_values.window_overlap_pc;
DTB__elab_parameters__windows_tapering = [];% DTB{s,1}.elab_parameters.windows_tapering = default_values.tap_percent;
DTB__elab_parameters__windows_sta_vs_lta=[];% DTB{s,1}.elab_parameters.windows_sta_vs_lta = default_values.sta_lta_ratio;
DTB__elab_parameters__windows_pad = {};%      DTB{s,1}.elab_parameters.windows_pad = default_values.pad_length;
DTB__elab_parameters__smoothing_strategy =[];%DTB{s,1}.elab_parameters.smoothing_strategy = get(T3_PA_wsmooth_strategy,'VAlue');
DTB__elab_parameters__smoothing_slider_val=[];%DTB{s,1}.elab_parameters.smoothing_slider_val = get(T3_PD_smooth_slider,'Value');
        %
        % filter
DTB__elab_parameters__filter_id = [];%            DTB{s,1}.elab_parameters.filter_id    = 1;
DTB__elab_parameters__filter_name={};%            DTB{s,1}.elab_parameters.filter_name  = 'none';
DTB__elab_parameters__filter_order=[];%           DTB{s,1}.elab_parameters.filter_order
DTB__elab_parameters__filterFc1=[];%              DTB{s,1}.elab_parameters.filterFc1
DTB__elab_parameters__filterFc2=[];%              DTB{s,1}.elab_parameters.filterFc2
DTB__elab_parameters__data_to_use=[];%            DTB{s,1}.elab_parameters.data_to_use
DTB__elab_parameters__THEfilter      ={};
%%   DTB__section
DTB__section__Min_Freq =[];%        DTB{s,1}.section.Min_Freq = 0.2;
DTB__section__Max_Freq =[];%        DTB{s,1}.section.Max_Freq = 100;
DTB__section__Frequency_Vector={};%        DTB{s,1}.section.Frequency_Vector = [];    [N*3 Matrix]
        %
DTB__section__V_windows ={};%        DTB{s,1}.section.V_windows = [];% filled runtime
DTB__section__E_windows ={};%        DTB{s,1}.section.E_windows = [];% filled runtime
DTB__section__N_windows ={};%        DTB{s,1}.section.N_windows = [];% filled runtime
        %
DTB__section__Average_V ={};%        DTB{s,1}.section.Average_V  = [];% filled runtime
DTB__section__Average_E ={};%        DTB{s,1}.section.Average_E = [];% filled runtime
DTB__section__Average_N ={};%        DTB{s,1}.section.Average_N = [];% filled runtime                    << compute_single_hv(dat_id)
        %
DTB__section__HV_windows ={};%       DTB{s,1}.section.HV_windows = [];% filled runtime
DTB__section__EV_windows ={};%       DTB{s,1}.section.EV_windows = [];% filled runtime
DTB__section__NV_windows ={};%       DTB{s,1}.section.NV_windows = [];% filled runtime
%%   DTB__hvsr
DTB__hvsr__curve_full ={};%              DTB{s,1}.hvsr.curve_full
%DTB{s,1}.hvsr.error_full = [];
DTB__hvsr__confidence95_full={};%        DTB{s,1}.hvsr.confidence95_full
DTB__hvsr__curve_EV_full ={};%           DTB{s,1}.hvsr.curve_EV_full
DTB__hvsr__curve_NV_full={};%            DTB{s,1}.hvsr.curve_NV_full 
%
DTB__hvsr__EV_all_windows={};%           DTB{s,1}.hvsr.EV_all_windows
DTB__hvsr__NV_all_windows={};%           DTB{s,1}.hvsr.NV_all_windows
DTB__hvsr__HV_all_windows={};%           DTB{s,1}.hvsr.HV_all_windows
%
DTB__hvsr__curve={};%        DTB{s,1}.hvsr.curve
        %DTB{s,1}.hvsr.error = [];
DTB__hvsr__confidence95={};%             DTB{s,1}.hvsr.confidence95 = [];
DTB__hvsr__standard_deviation={};%    DTB{s,1}.hvsr.standard_deviation = [];
DTB__hvsr__curve_EV={};%              DTB{s,1}.hvsr.curve_EV = [];
DTB__hvsr__curve_NV={};%              DTB{s,1}.hvsr.curve_NV = [];
        %
DTB__hvsr__peaks_idx={};%        DTB{s,1}.hvsr.peaks_idx = [];   %index of local maxima
DTB__hvsr__hollows_idx={};%        DTB{s,1}.hvsr.hollows_idx = [];   %index of local minima
DTB__hvsr__user_additional_peaks={};%        additional user-selected peaks [id in section, id in full curve, frequence, amplitude]190330
DTB__hvsr__user_main_peak_frequence = [];%        DTB{s,1}.hvsr.user_main_peak_frequence = NaN;
DTB__hvsr__user_main_peak_amplitude = [];%        DTB{s,1}.hvsr.user_main_peak_amplitude = NaN;
DTB__hvsr__user_main_peak_id_full_curve = [];%         DTB{s,1}.hvsr.hvsr.user_main_peak_id_full_curve = NaN; <<<<<< ISSUE
DTB__hvsr__user_main_peak_id_in_section = [];%        DTB{s,1}.hvsr.hvsr.user_main_peak_id_in_section = NaN;  <<<<<< ISSUE
DTB__hvsr__auto_main_peak_frequence= [];%        DTB{s,1}.hvsr.auto_main_peak_frequence = NaN;
DTB__hvsr__auto_main_peak_amplitude= [];%        DTB{s,1}.hvsr.auto_main_peak_amplitude = NaN;
DTB__hvsr__auto_main_peak_id_full_curve= [];%        DTB{s,1}.hvsr.auto_main_peak_id_full_curve= NaN;
DTB__hvsr__auto_main_peak_id_in_section= [];%;        DTB{s,1}.hvsr.auto_main_peak_id_in_section = NaN;
%
%%   DTB__hvsr180
DTB__hvsr180__angle_id = [];%        DTB{s,1}.hvsr180.angle_id = 1;% 1 = option-1 in uicontrol: off
DTB__hvsr180__angles = {};%        DTB{s,1}.hvsr180.angles = [];
DTB__hvsr180__angle_step = [];%        DTB{s,1}.hvsr180.angle_step = 0;
DTB__hvsr180__spectralratio = {};%        DTB{s,1}.hvsr180.spectralratio = [];
DTB__hvsr180__preferred_direction = {};%        DTB{s,1}.hvsr180.preferred_direction = [];
%%   DTB__well
DTB__well__well_id=[];%       DTB{s,1}.well.well_id   = 0;% 1 = option-1 in uicontrol: off
DTB__well__well_name={};%        DTB{s,1}.well.well_name = '';
DTB__well__bedrock_depth__KNOWN={};%       DTB{s,1}.well.bedrock_depth__KNOWN      = 'n.a.';% if  .well_name == ''; this depth must be computed, otherwise it is considered measured
DTB__well__bedrock_depth_source={};%       DTB{s,1}.well.bedrock_depth_source      = 'n.a.';
DTB__well__bedrock_depth__COMPUTED={};%       DTB{s,1}.well.bedrock_depth__COMPUTED   = 'n.a.';
DTB__well__bedrock_depth__IBS1999={};%       DTB{s,1}.well.bedrock_depth__IBS1999    = 'n.a.';
DTB__well__bedrock_depth__PAROLAI2002={};%        DTB{s,1}.well.bedrock_depth__PAROLAI2002= 'n.a.';
DTB__well__bedrock_depth__HINZEN2004={};%        DTB{s,1}.well.bedrock_depth__HINZEN2004 = 'n.a.';
%% Database =====================END
%% Temporary Parameters and variables
%amplitude_minimum_difference_perc = 15;
P.profile_name={};
%%
%
%% NEW AND TEMPORARY FEATURES xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%%    Reference models: vp  vs  rho  h  Qp  Qs
REFERENCE_MODEL_dH       = [];
REFERENCE_MODEL_zpoints  = [];
%% initial external routines
%litotypes = {};       %% Future evolutions
%run('Litotypes.m')    %% Future evolutions
%% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%% MAIN GUI ===============================================================
%% BUILD INTERFACE COMPONENTS
%% MENUS
if USER_PREFERENCE_enable_Matlab_default_menu == 0
    set(H.gui,'MenuBar','none');% Hide standard menu bar menus.
end
%%    Files
H.menu.files.a  = uimenu(H.gui,'Label','Files');
uimenu(H.menu.files.a,'Label','Create/Edit project','Callback',{@Menu_Project_Create});
uimenu(H.menu.files.a,'Label','Load project', 'Callback',{@Menu_Project_Load});
uimenu(H.menu.files.a,'Label','Save Elaboration',  'Callback',{@Menu_Save_elaboration},'Separator','on');
uimenu(H.menu.files.a,'Label','Resume Elaboration','Callback',{@Menu_Load_elaboration});
%
uimenu(H.menu.files.a,'Label','Save HVSR curves (txt)','Callback',{@Menu_save_hvsr_as_txt},'Separator','on');
uimenu(H.menu.files.a,'Label','Save Full Output set (txt)','Callback',{@Menu_save_full_results_as_txt_set});
%
uimenu(H.menu.files.a,'Label','Export as OpenHVSR project','Callback',{@Menu_export_as_OpenHVSR_project},'Separator','on');
%%    Settings
H.menu.settings.a  = uimenu(H.gui,'Label','Settings');
H.menu.settings.log = uimenu(H.menu.settings.a,'Label','Enable log','Checked','off','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.settings.compass = uimenu(H.menu.settings.a,'Label','Use compass mode for degrees','Checked','off','Callback',{@Menu_Settings_use_compass_mode_Callback});
%%    View
H.menu.view.a  = uimenu(H.gui,'Label','View');
%%       Tab:main
H.menu.view.Main = uimenu(H.menu.view.a,'Label','Tab:Main');
H.menu.main_Proportions = uimenu(H.menu.view.Main,'Label','Proportions','UserData',1,'Callback',{@CB_GUI_MENU_change_proportions,'Main'});
%%       Tab:Computations
H.menu.view.Computat = uimenu(H.menu.view.a,'Label','Tab:Computations');
H.menu.view.Computat_axis_orientation = uimenu(H.menu.view.Computat,'Label','View:Vertical','Checked','on','Callback',{@Viewmode_Vert_or_Horizontal});
%%       Tab:2D views
%%           Map
H.menu.view.view2d = uimenu(H.menu.view.a,'Label','Tab:2D views');
H.menu.view2d_Map = uimenu(H.menu.view.view2d,'Label','Map');
H.menu.view.view2d_Stations = uimenu(H.menu.view2d_Map,'Label','Show Stations','Checked','on','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.view.view2d_Mask = uimenu(H.menu.view2d_Map,'Label','Show Mask','Checked','on','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.view.view2d_ExtraPoints = uimenu(H.menu.view2d_Map,'Label','Show extra points','Checked','on','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.view.view2d_Angle_Annotation = uimenu(H.menu.view2d_Map,'Label','Show angles annotations','Checked','on','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.view.view2d_Station_Annotation = uimenu(H.menu.view2d_Map,'Label','Show station annotations','Checked','off','Callback',{@CB_GUI_MENU_change_checked_status});
%
H.menu.view.view2d_Proportions = uimenu(H.menu.view2d_Map,'Label','Proportions','UserData',1,'Callback',{@CB_GUI_MENU_change_proportions,'Map'});
%%           Profile
H.menu.view2d_Profile = uimenu(H.menu.view.view2d,'Label','Profile');
H.menu.view2d_Profile_smoothing = uimenu(H.menu.view2d_Profile,'Label','Smoothing');
H.menu.view2d_Profile_smoothing_childs = zeros(1,4);
H.menu.view2d_Profile_smoothing_childs(1) = uimenu(H.menu.view2d_Profile_smoothing,'Label','off','Callback',        {@Menu_profile_smoothing_strategy0_Callback});
H.menu.view2d_Profile_smoothing_childs(2) = uimenu(H.menu.view2d_Profile_smoothing,'Label','Layer','Callback',      {@Menu_profile_smoothing_strategy1_Callback});
H.menu.view2d_Profile_smoothing_childs(3) = uimenu(H.menu.view2d_Profile_smoothing,'Label','Broad Layer','Callback',{@Menu_profile_smoothing_strategy2_Callback});
H.menu.view2d_Profile_smoothing_childs(4) = uimenu(H.menu.view2d_Profile_smoothing,'Label','Bubble','Callback',     {@Menu_profile_smoothing_strategy3_Callback});
%
H.menu.view2d_Profile_normalization = uimenu(H.menu.view2d_Profile,'Label','Normalization');
H.menu.view2d_Profile_normalization_childs = zeros(1,4);
H.menu.view2d_Profile_normalization_childs(1) = uimenu(H.menu.view2d_Profile_normalization,'Label','off','Callback',                    {@Menu_profile_normalization_strategy0_Callback});
H.menu.view2d_Profile_normalization_childs(2) = uimenu(H.menu.view2d_Profile_normalization,'Label','At main peak','Callback',           {@Menu_profile_normalization_strategy1_Callback});
H.menu.view2d_Profile_normalization_childs(3) = uimenu(H.menu.view2d_Profile_normalization,'Label','Max amplitudes accounting all stations','Callback',{@Menu_profile_normalization_strategy2_Callback});
H.menu.view2d_Profile_normalization_childs(4) = uimenu(H.menu.view2d_Profile_normalization,'Label','Max amplitude in the profile','Callback',{@Menu_profile_normalization_strategy3_Callback});

%
H.menu.view2d_Profile_discretization = uimenu(H.menu.view2d_Profile,'Label','Discretization','Callback',{@Menu_profile_discretization_Callback});
H.menu.view2d_Profile_colorlimits = uimenu(H.menu.view2d_Profile,'Label','Color Limits','Callback',  {@Menu_profile_ColorLimits_Callback});  %{@Menu_View_clim});
%
H.menu.view2d_Profile_Proportions = uimenu(H.menu.view2d_Profile,'Label','Proportions','UserData',1,'Callback',{@CB_GUI_MENU_change_proportions,'Prof'});
%
%
%%       Tab:3D views
H.menu.view.view3d = uimenu(H.menu.view.a,'Label','Tab:3D views');
H.menu.view.view3d_SurfaceDiscr = uimenu(H.menu.view.view3d,'Label','Set Discretization','Callback',{@CB_view3d_surfaces_discretization});
%
H.menu.view.view3d_ExtraPoints = uimenu(H.menu.view.view3d,'Label','Show extra points','Checked','off','Callback',{@CB_GUI_MENU_change_checked_status});
% NOTE: extra points need that actual topographic Z is provided by the user
H.menu.view.view3d_Angle_Annotation = uimenu(H.menu.view.view3d,'Label','Show angles annotations','Checked','on','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.view.view3d_Station_Annotation = uimenu(H.menu.view.view3d,'Label','Show station annotations','Checked','off','Callback',{@CB_GUI_MENU_change_checked_status});

%
%
%%       Tab: IVS&W      
H.menu.view.IVSW = uimenu(H.menu.view.a,'Label','Tab:IVS&V');
H.menu.IVSW_Map  = uimenu(H.menu.view.IVSW,'Label','3D plot');
H.menu.view.IVSW_Surface = uimenu(H.menu.IVSW_Map,'Label','Show Surface','Checked','off','Callback',{@CB_GUI_MENU_change_checked_status});
H.menu.view.IVSW_SurfaceDiscr = uimenu(H.menu.IVSW_Map,'Label','Set Discretization','Callback',{@CB_IVSeW_surfaces_discretization});
H.menu.view.IVSW_Proportions = uimenu(H.menu.IVSW_Map,'Label','Proportions','UserData',1,'Callback',{@CB_GUI_MENU_change_proportions,'Ibs'});
%
%%       Colormap
H.menu.view.colormap = uimenu(H.menu.view.a,'Label','Colormap','Separator','on');
uimenu(H.menu.view.colormap,'Label','Jet','Callback', {@Menu_view_cmap_Jet});
uimenu(H.menu.view.colormap,'Label','Hot','Callback', {@Menu_view_cmap_Hot});
uimenu(H.menu.view.colormap,'Label','Bone','Callback',{@Menu_view_cmap_Bone});
uimenu(H.menu.view.colormap,'Label','Copper','Callback',{@Menu_view_cmap_Copper});
uimenu(H.menu.view.colormap,'Label','Parula','Callback',{@Menu_view_cmap_Parula});
%
%%       Hold on
H.menu.view.HoldOn = uimenu(H.menu.view.a,'Label','Hold on','Checked','off','Callback',{@CB_GUI_MENU_change_checked_status});
%%       EXTRA
H.menu.view.extra = uimenu(H.menu.view.a,'Label','Extra');
H.menu.extra_figure_all_hvsr = uimenu(H.menu.view.extra,'Label','figure: all hvsr''s','Callback',{@CB_figure_all_hvsr});
%
%
%%    About
H.menu.credits  = uimenu(H.gui,'Label','Credits','Callback',{@Menu_About_Credits});
%%
%% ************************* INTERFACE OBJECTS ****************************
%% Panels
Pnl = [];
Pfiles_PANELS
%% ABOUT MATLAB RELEASE: Get release and apply release-specific behavior  
[Matlab_Release,Matlab_Release_num, hTabGroup,SelectionChangeOption] = Pfiles_Function_MATLAB_Release(H.gui);
P.SelectionChangeOption = SelectionChangeOption;
%
%% TAB-1: ====================== Main
create_new_tab('Main');
set(H.TABS(P.tab_id),'ButtonDownFcn',{@CB_TAB_main_view_update})
%%     Panels
H.PANELS{P.tab_id}.A = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay1.A);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.A,'title','A');end
H.PANELS{P.tab_id}.B = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay1.B);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.B,'title','B');end
H.PANELS{P.tab_id}.C = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay1.C);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.C,'title','C');end
%
%%     Objets on panel A
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_objh );
objy = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_object_levels );
%%         Navigation H/V measurements
row = 2;
objw = 1;
objx = 0;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','measurements', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
objw = [0.3, 0.3,   0.3];
gapx = (1-sum(objw)) / (length(objw-1));
objx = [0, (objw(1)+ gapx), (sum(objw(1:2)) + 2*gapx)];
T1_PA_dat_bk = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_geo_back});
T1_PA_dat_gt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','go to', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_geo_goto});
T1_PA_dat_fw = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_geo_next});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T1_PA_dat_fw,'TooltipString',sprintf('Next location\n\n(exit the profiles-visualization mode, if it is active)'))
    set(T1_PA_dat_bk,'TooltipString',sprintf('Previous location\n\n(exit the profiles-visualization mode, if it is active)'))
    set(T1_PA_dat_gt,'TooltipString',sprintf('Go to a custom location\n\n(exit the profiles-visualization mode, if it is active)'))
end
%%         info
row = row+1;
objw = [0.3 0.7];
objx = [0  0.3];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Sampling fr.', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_info_sampling_freq= uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String',' ', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Length:', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_info_data_length = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','0', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
%
%%         Wells
row = row+2;
objw = 1;
objx = 0;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Wells', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
objw = [0.2, 0.2,   0.195, 0.195, 0.195];
gapx = 1-sum(objw)-0.005;
objx = [0, objw(1), (sum(objw(1:2)) + gapx), (sum(objw(1:3)) + gapx) , (sum(objw(1:4)) + gapx)];
T1_PA_well_bk = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_well_back});
T1_PA_well_fw = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CM_hAx_well_next});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T1_PA_well_fw,'TooltipString','Next well')
    set(T1_PA_well_bk,'TooltipString','Previous well')
end
%%         Profiles (if any)
row = row+2;
objw = 1;
objx = 0;
T1_PA_prof_0 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Profiles', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
objw = [0.2, 0.2,   0.195, 0.195, 0.195];
gapx = 1-sum(objw)-0.005;
objx = [0, objw(1), (sum(objw(1:2)) + gapx), (sum(objw(1:3)) + gapx) , (sum(objw(1:4)) + gapx)];
T1_PA_prof_bk = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_show_profile_back});
T1_PA_prof_fw = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_show_profile_next});
%
T1_PA_prof_add = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','add', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh], ...
    'Callback',{@CB_hAx_profile_addrec});
T1_PA_prof_rem = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','remove', ...
    'Units','normalized','Position',[objx(5), objy(row), objw(5), objh], ...
    'Callback',{@CB_hAx_profile_remrec});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    tipstring = sprintf('Profile Creation: (on this Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on "2D views" Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
    set(T1_PA_prof_0,'TooltipString',tipstring)
    set(T1_PA_prof_fw,'TooltipString',sprintf('Next profile.\nEnter the profile investigation mode.\nVisualize the profile to inspect which stations are included\nand which are not.'))
    set(T1_PA_prof_bk,'TooltipString',sprintf('Previous profile\nEnter the profile investigation mode.\nVisualize the profile to inspect which stations are included\nand which are not.'))
    set(T1_PA_prof_add,'TooltipString','Add single location to the selected profile')
    set(T1_PA_prof_rem,'TooltipString','Remove single location from the selected profile')
end
%
%
%%         Elaboration Info
objw = 1;
objx = 0;
row = row+2;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','=== Elaboration parameters in use ===', ...
    'Units','normalized','Position',[objx, objy(row), objw, objh]);
%%             Status
objw = [0.5  0.40  0.10];
objx = [0.0  0.50  0.90];
row = row+1;
T1_PA_id = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','File ID', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight','bold', ...
    'BackgroundColor',Status_bkground_color, ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_FileID = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight','bold', ...
    'BackgroundColor',Status_bkground_color, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
row = row+1;
T1_PA_status0 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Status', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight','bold', ...
    'BackgroundColor',Status_bkground_color, ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_status = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'FontWeight','bold', ...
    'BackgroundColor',Status_bkground_color, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_set_status});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Locked: no further elaboration needed.\nExclude: exclude from survey.');
    set(T1_PA_status,'TooltipString',hoveoverstring)
end
%%             Windows info
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','windows:  width (s)', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_windows_width = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','windows:  overlap (%)', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_windows_overlap = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','windows:  tapering (%)', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_windows_tapering = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);

%
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','windows:  STA/LTA', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_windows_sta_vs_lta = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','windows:  Padding', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_windows_pad = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
%%             Hvsr related
row = row+2;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','HVSR strategy', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_hvsr_strategy = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
%%             Frequence range
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','freq. min', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_hvsr_freq_min = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','freq. max', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_hvsr_freq_max = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%             Smoothing
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Smoothing:', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_smoothing_strategy = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
T1_PA_smoothing_parameter_value =  uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
%%             angular H/V 
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Directional HVSR', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PA_angular_sampling = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%        << extra objects>>
if strcmp(P.ExtraFeatures.development_help_features, 'on')
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','6', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','7', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','8', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','9', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','10', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','1', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','2', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
end
%
%%     Objets on panel B
%%         MAP Surveys locations
pos_axes_geo0 = [0.1 0.1 0.85 0.85];
hAx_geo_hcmenu = uicontextmenu;
uimenu(hAx_geo_hcmenu, 'Label', 'Define 2D profile',    'Callback', {@define_Profile});
uimenu(hAx_geo_hcmenu, 'Label', 'Discard  a profile',    'Callback', {@reset_one_Profile});
uimenu(hAx_geo_hcmenu, 'Label', 'Discard  ALL profiles',    'Callback', {@reset_Profile});
uimenu(hAx_geo_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,1}, 'Separator','on');
uimenu(hAx_geo_hcmenu, 'Label', 'Edit externally (profile)',    'Callback', {@plot_extern,2});
hAx_main_geo = axes('Parent',H.PANELS{P.tab_id}.B,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axes_geo0,'uicontextmenu',hAx_geo_hcmenu);
%%     Objets on panel C
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.C, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%         Info
row = 1;
objw = [0.15 0.85];
objx = [0  0.15];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','Data File:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PC_datafile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C,'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'BackgroundColor', [1 1 1]);
%
row = row  +2;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','Well File:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T1_PC_wellfile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C,'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'BackgroundColor', [1 1 1]);
%
row = row  +2;
objw = 0.2;
objx = 0.8;
ISBUSY1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C,'Units','normalized','Position',[objx, objy(row), objw, objh], ...
    'BackgroundColor', [0 0.8 0], 'String','Ready');
%% TAB-2: ===================== Fenestration
create_new_tab('Windowing');
%%     Panels
H.PANELS{P.tab_id}.A = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay2.A);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.A,'title','A');end
H.PANELS{P.tab_id}.B = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay2.B);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.B,'title','B');end
H.PANELS{P.tab_id}.C = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay2.C);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.C,'title','C');end
H.PANELS{P.tab_id}.D = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay2.D);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.D,'title','D');end
%
%%     Objets on panel A
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%         Navigation      
row=1;
objw = [0.33,  0.33,  0.33];
objx = [0.00,  0.33,  0.66];
T2_PA_dat_bk = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_geo_back});
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','go to', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_geo_goto});
T2_PA_dat_fw = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_geo_next});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T2_PA_dat_fw,'TooltipString','Next data')
    set(T2_PA_dat_bk,'TooltipString','Previous data')
end
%
%%         Parameters
%%         Windows width
row = row+2;
objw = [0.66,  0.34];
objx = [0,     0.66];
%row = row + 2;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Windows width (s)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_winsize = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.window_width), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%         Windows overlap
row = row + 1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Windows overlap (%)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_winoverlap = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.window_overlap_pc), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%         Filtering
row=row+1;
objw = [0.33,  0.33,  0.113,  0.113  0.113];
objx = [0.00,  0.33,  0.66,   0.773  0.886];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Filter', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T2_PA_filter = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'off','Band-pass','Low-pass','High-pass'}, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_Filter_switch});
T2_PA_filter_fmin = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String','', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh],...
    'enable','off');
T2_PA_filter_fmax = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String','', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh],...
    'enable','off');
T2_PA_filter_show = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','FR', ...
    'Units','normalized','Position',[objx(5), objy(row), objw(5), objh], ...
    'enable','off', ...
    'Callback',{@CB_Filter_test});

if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
     hoveoverstring = sprintf('Minimum frequency cutoff [Hz].\nBand-pass: used as low-freq. cutoff\nLow-pass: NOT used\nHigh-pass: NOT used');
     set(T2_PA_filter_fmin,'TooltipString',hoveoverstring)
     hoveoverstring = sprintf('Maximum frequency cutoff [Hz].\nBand-pass: used as high-freq. cutoff\nLow-pass: used as highest-freq point of passband.\nHigh-pass: used as 3dB point below the passband amplitude');
     set(T2_PA_filter_fmax,'TooltipString',hoveoverstring)
     
     set(T2_PA_filter_show,'TooltipString','Show the filter response.')
end
%%         Selector: data to use in computations
row = row+1;
objw =[0.33,  0.67];
objx =[0,     0.33];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Filtered data:', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T2_PA_dattoUSE = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'use only for STA/LTA automatic window selection','use filtered data for all computations'},'enable','off', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_data_to_use});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
     hoveoverstring = sprintf('Set if the filtered version of data\n will be used only for STA/LTA automatic windows selection\n or will be also used for spectral ratio computations.');
     set(T2_PA_dattoUSE,'TooltipString',hoveoverstring)
end
%%         Windows sta/lta
row = row + 2;
% objw = [0.33,  0.33,  0.113,  0.113  0.113];
% objx = [0.00,  0.33,  0.66,   0.773  0.886];
objw = [0.66,  0.34];
objx = [0,     0.66];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','STA window (s)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_winsSTA = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.sta_window_length ), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row = row + 1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','LTA window (s)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_winsLTA = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.lta_window_length ), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row = row + 1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','STA/LTA', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_wintstaltaratio = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.sta_lta_ratio), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%         Mouse over tips
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T3_P1_winsize,'TooltipString','Width of windows, in seconds.')
    set(T3_P1_winoverlap,'TooltipString','Percentage of windows overlap')
    hoveoverstring = sprintf('Automatic transient discard dased on the STA/LTA ratio.\n \nShort Term Average: average amplitude along the window\n\nLong Term Average: average amplitude along the entire recording');
    set(T3_P1_wintstaltaratio,'TooltipString',hoveoverstring)
end
%%         BUTTONS FOR WINDOWING
row = row+2;
objw = 1;
objx = 0;
% button
T2_window_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Window this data', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_compute_single_windowing});
row = row + 1;
T2_window_2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Window ALL data', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_compute_windowing_all});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T2_window_1,'TooltipString',sprintf('Windowing MUST be RUN again after a parameter is changed'))
    set(T2_window_2,'TooltipString',sprintf('Windowing MUST be RUN again after a parameter is changed'))
end
%%         Kind of data to show
row = row+1;
objw = [0.66,  0.34];
objx = [0,     0.66];
T2_PA_dattoshowtxt =uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Data to show', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T2_PA_dattoshow = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'Original','Filtered'}, 'enable','off', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_swich_dat_to_show});
%%         Mouse over tips
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('When data filtering is set and performed correctly the button on this line\n is enabled. It controls which data (filtered/unfiltered) is shown on the interface\n');
    set(T2_PA_dattoshowtxt,'TooltipString',hoveoverstring)
end
%%    Objets on panel B
%%        Geometry map
pos_axes_geo1  = [0.1 0.1 0.8 0.8];
hAx_geo1_hcmenu = uicontextmenu;
%uimenu(hAx_geo1_hcmenu, 'Label', 'Show',   'Callback', @CM_hAx_geo_show);
uimenu(hAx_geo1_hcmenu, 'Label', 'Define 2D profile',    'Callback', {@define_Profile,3});%, 'Separator','on');
uimenu(hAx_geo1_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,1}, 'Separator','on');
hAx_geo1= axes('Parent',H.PANELS{P.tab_id}.B,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axes_geo1,'uicontextmenu',hAx_geo1_hcmenu);
T2_PB_datafile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.B, ...
    'String','', ...
    'Units','normalized','Position',[0, 0.8, 1, 0.2]);
%%    Objets on panel C
%%        Plots: data
hAx_datN_hcmenu = uicontextmenu;
uimenu(hAx_datN_hcmenu , 'Label', 'Delete windows',   'Callback', {@CM_data_delete_win});
uimenu(hAx_datN_hcmenu , 'Label', 'Resume windows',   'Callback', @CM_data_resume_win);
%
uimenu(hAx_datN_hcmenu , 'Label', 'Show range',     'Callback', {@CM_data_SetrangeHax}, 'Separator','on');
uimenu(hAx_datN_hcmenu , 'Label', 'Show full time', 'Callback',{@CM_data_resetHax});
%
uimenu(hAx_datN_hcmenu , 'Label', 'Magnify vertical',     'enable','off', 'Separator','on')%,    'Callback', {@CM_show_win_data});
uimenu(hAx_datN_hcmenu , 'Label', 'Show full amplitudes', 'enable','off')%,    'Callback', {@CM_show_win_data});
%
uimenu(hAx_datN_hcmenu , 'Label', 'Edit externally',     'Callback', {@plot_extern,3}, 'Separator','on');
%
%
pos_axs_datV = [0.1 0.73    0.875 0.265];% pre-revision: [0.05 0.65    0.9 0.275];
hAx_datV= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_datV,'uicontextmenu',hAx_datN_hcmenu);
%
pos_axs_datE = [0.1 0.40    0.875 0.265];% pre-revision: [0.05 0.35    0.9 0.275]; 
hAx_datE= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_datE,'uicontextmenu',hAx_datN_hcmenu);
%
pos_axs_datN = [0.1 0.07    0.875 0.265];% pre-revision: [0.05 0.05    0.9 0.275];
hAx_datN= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_datN,'uicontextmenu',hAx_datN_hcmenu);
%
%%    Objets on panel D
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.D, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%
%%        Obj. row 1
row = 1;
objw = [0.2,    0.15,0.15,    0.15,0.15];
objx = [0        0.25,0.40    0.50,0.65 ];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.D, ...
    'String','windows samples', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
T2_PD_win_samples = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.D, ...
    'String','0', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
row=row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.D, ...
    'String','next power of 2:', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
T2_PD_win_samplespow2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.D, ...
    'String','', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
%
row = row  +3;
objw = 0.2;
objx = 0.8;
ISBUSY2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D,'Units','normalized','Position',[objx, objy(row), objw, objh], ...
    'BackgroundColor', [0 0.8 0], 'String','Ready');
%% TAB-3: ===================== Computations
create_new_tab('Computations');
set(H.TABS(P.tab_id),'ButtonDownFcn',{@CB_TAB_update_Computations})
%%    Panels
H.PANELS{P.tab_id}.A = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay2.A);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.A,'title','A');end
H.PANELS{P.tab_id}.B = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay2.B);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.B,'title','B');end
H.PANELS{P.tab_id}.C = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay2.C);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.C,'title','C');end
H.PANELS{P.tab_id}.D = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay2.D);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.D,'title','D');end
%%    Objets on panel A
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%         Navigation
row=1;
objw = [0.33,  0.33,  0.33];
objx = [0.00,  0.33,  0.66];
T3_PA_dat_bk = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_geo_back});
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','go to', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_geo_goto});
T3_PA_dat_fw = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_geo_next});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T3_PA_dat_fw,'TooltipString','Next data')
    set(T3_PA_dat_bk,'TooltipString','Previous data')
end
%%         HVSR strategy
objw = [0.33,  0.67];
objx = [0,     0.33];
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','HVSR', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T2_PA_HV = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'Average Squared','Simple Average','Total Energy'}, ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Selects how spectral ratio H/Vis computed\n \nHorizontal component average options: \nAverage Squared.: H = sqrt[ (E^2 + N^2)/2 ]\nSimple Average: H = (E+N)/2\nTotal Energy: HVSR = sqrt(E^2+N^2)');
    set(T2_PA_HV,'TooltipString',hoveoverstring)
end
%%         Frequence range
objw = [0.66  0.17  0.17];
objx = [0.0   0.66  0.83];
row=row+2;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Freq. range (Hz)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
hT3_PA_edit_fmin = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.frequence_min), ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
hT3_PA_edit_fmax = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.frequence_max), ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(hT3_PA_edit_fmin,'TooltipString','Minimum frequency investigated [Hz].')
    set(hT3_PA_edit_fmax,'TooltipString','Maximum frequency investigated [Hz].')
end
%%         Windows tapering
row = row + 1;
objw = [0.66  0.34];
objx = [0.0   0.66];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Windows tapering (%)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_wintapering = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.tap_percent), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Perform cosine tapering at both ends of each data window.\nExpressed as percentage of full window length.');
    set(T3_P1_wintapering,'TooltipString',hoveoverstring)
end
%%         Padding
row = row + 1;
objw = [0.66  0.34];
objx = [0.0   0.66];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Pad windows (samples)', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_wpadto = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.pad_length), ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_padding_set_next_pow2});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Pad the windows to a custom number of samples\nbefore performing any Fourier transforms.\n* If the requested number of samples is lower than the windows length (in samples)\nthe control will remain in "off" position.\n* Any input value will automatically be rounded to the next power of 2.\n* To switch off the padding, write "0" or "off".');
    set(T3_P1_wpadto,'TooltipString',hoveoverstring)
end
%%         Smoothing
objw = [0.33, 0.67];
objx = [0.0   0.33];
row = row+2;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Smoothing', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_PA_wsmooth_strategy = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'Konno-Ohmachi','Average'}, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_smoothing_slider});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T3_PA_wsmooth_strategy,'TooltipString','Strategy to smooth the computed HVSR.')
end
%%         Smoothing II
row = row + 1;
objw = [0.66,  0.34];
objx = [0.0,   0.66];
T3_PD_smooth_slider = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','slider',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'Value',(default_values.smoothing_constant/100), ...
    'Units','normalized','Position',[objx(1), (objy(row)-0.5*objh), objw(1), objh], ...
    'Callback',{@CB_smoothing_slider});% value [0 - 1]
T3_PA_wsmooth_amount = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String',num2str(default_values.smoothing_constant), ...
    'HorizontalAlignment','center', ...
    'BackgroundColor','w', ...
    'Units','normalized','Position',[objx(2), (objy(row)-0.5*objh), objw(2), objh]);
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Slider controlling the amount of smoothing\nbehavior depends on the chosen smoothing strategy.');
    set(T3_PD_smooth_slider,  'TooltipString',hoveoverstring)
    hoveoverstring = sprintf('Smoothing amount.\nThe amount of smoothing, controlled through the slider,\ndepends on the chosen smoothing strategy.');
    set(T3_PA_wsmooth_amount,  'TooltipString',hoveoverstring)
end
%%         Angles
row = row + 2;
objw = [0.66  0.34];
objx = [0.0   0.66];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Angular Sampling', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_P1_angular_samp= uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'off','45','30','15','10','5','2.5','1'}, ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Angular discretization to be used in computing\nthe "Directional spectral ratio".');
    set(T3_P1_angular_samp,  'TooltipString',hoveoverstring)
end
%%         BUTTONS FOR COMPUTING
row = row+2;
objw = 1;
objx = 0;
T3_compute_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Run computing on THIS data', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_compute_one});
row = row + 1;
T3_compute_2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Run computing on ALL data', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_compute_all});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T3_compute_1,'TooltipString',sprintf('Computation MUST be RUN again after a parameter is changed'))
    set(T3_compute_2,'TooltipString',sprintf('Computation MUST be RUN again after a parameter is changed'))
end
%
%%    Objets on panel B
pos_axes_geo2  = [0.1 0.1 0.8 0.8];
hAx_geo2_hcmenu = uicontextmenu;
uimenu(hAx_geo2_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,1});
hAx_geo2= axes('Parent',H.PANELS{P.tab_id}.B,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axes_geo2,'uicontextmenu',hAx_geo2_hcmenu);
T3_PB_datafile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.B, ...
    'String','', ...
    'Units','normalized','Position',[0, 0.8, 1, 0.2]);%T1_PC_datafile_txt
%%    Objets on panel C
%%         Spectrum axes
hAx_speN_hcmenu = uicontextmenu;
hAx_speN_hcmenu_1 = uimenu(hAx_speN_hcmenu , 'Label', 'Delete windows',    'Callback', {@CM_spectrum_delete_win});
hAx_speN_hcmenu_2 = uimenu(hAx_speN_hcmenu , 'Label', 'Resume windows',    'Callback', {@CM_spectrum_resume_win});
hAx_speN_hcmenu_5 = uimenu(hAx_speN_hcmenu , 'Label', 'Delete curves',     'Callback', {@CM_spectrum_delete_curves}, 'Separator','on');
hAx_speN_hcmenu_6 = uimenu(hAx_speN_hcmenu , 'Label', 'Resume curves',     'Callback', {@CM_spectrum_resume_curves});
hAx_speN_hcmenu_3 = uimenu(hAx_speN_hcmenu , 'Label', 'Use Manual Peak',   'Callback', {@CM_spectrum_select_main_peak}, 'Separator','on');
hAx_speN_hcmenu_4 = uimenu(hAx_speN_hcmenu , 'Label', 'Use Automatic Peak',     'Callback', {@CM_spectrum_deselect_main_peak});
%
hAx_speN_hcmenu_7 = uimenu(hAx_speN_hcmenu , 'Label', 'Select additional peak',   'Callback', {@CM_spectrum_select_additional_peak}, 'Separator','on');
hAx_speN_hcmenu_9 = uimenu(hAx_speN_hcmenu , 'Label', 'Remove last additional peak',   'Callback', {@CM_spectrum_discard_last_additional_peak_selections});
hAx_speN_hcmenu_8 = uimenu(hAx_speN_hcmenu , 'Label', 'Discard all additional peaks', 'Callback', {@CM_spectrum_discard_additional_peak_selections});
%
uimenu(hAx_speN_hcmenu , 'Label', 'Set vertical range',    'Callback',{@CM_speN_SetrangeVax}, 'Separator','on');
uimenu(hAx_speN_hcmenu , 'Label', 'Reset vertical range',  'Callback',{@CM_speN_resetVax});
uimenu(hAx_speN_hcmenu , 'Label', 'Set horizontal range',  'Callback',{@CM_speN_SetrangeHax}, 'Separator','on');
uimenu(hAx_speN_hcmenu , 'Label', 'Reset horizontal range','Callback',{@CM_speN_resetHax});
hAx_speN_hcmenu_Flog = uimenu(hAx_speN_hcmenu , 'Label', 'Frequency: set log',          'Callback',{@CM_set_log_freq}, 'Separator','on','Checked','on');
hAx_speN_hcmenu_Flin = uimenu(hAx_speN_hcmenu , 'Label', 'Frequency: set linear',       'Callback',{@CM_set_lin_freq});
uimenu(hAx_speN_hcmenu , 'Label', 'Edit externally',       'Callback',{@plot_extern,4}, 'Separator','on');

pos_axs_speV = [0.06 0.1    0.2725 0.9];%[0.05 0.05    0.275 0.9];
hAx_speV= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV,'uicontextmenu',hAx_speN_hcmenu,'UserData','V');
if Matlab_Release_num>2018.1; disableDefaultInteractivity(hAx_speV); end
pos_axs_speE = [0.39 0.1    0.2725 0.9];%[0.35 0.05   0.275 0.9];
hAx_speE= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE,'uicontextmenu',hAx_speN_hcmenu,'UserData','E');
pos_axs_speN = [0.72 0.1    0.2725 0.9];%[0.65 0.05    0.275 0.9];
hAx_speN= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN,'uicontextmenu',hAx_speN_hcmenu,'UserData','N');
%
%%    Objets on panel D
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.D, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%         visualizations
%          GROOP: group_radiobuttons_spectrum_views
%          Create radio buttons in the button group.
pos = [0 0 0.33 1];
%objy = 1.1*objy;
hP3_TA_buttongroup = uibuttongroup('parent',H.PANELS{P.tab_id}.D, ...
    'Title','Show', ...
    'Position',pos,P.SelectionChangeOption,{@CB_spectrum_selection});% <<<<<<< MATLAB VERSIONS
P3_TA_buttongroup_option{1} = 'windows ';%0 %<-space must stay
P3_TA_buttongroup_option{2} = 'contour ';%1%<-space must stay
P3_TA_buttongroup_option{3} = 'windows';% 2
P3_TA_buttongroup_option{4} = 'contour';% 3
P3_TA_buttongroup_option{5} = 'mean';%    4 hvsr(mode a)
P3_TA_buttongroup_option{6} = 'H-V';%     5 hvsr(mode b)
P3_TA_buttongroup_option{7} = 'all';%     6 hvsr(mode c)
P3_TA_buttongroup_option{8} = 'image';%   7 Directional (image)
P3_TA_buttongroup_option{9} = 'curves';%  8 Directional (curves)
%%            Spectrums
objw = [0.4 0.3 0.3];
objx = [0   0.4 0.7];
row=1;
%row=2; % FIX
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP3_TA_buttongroup, ...
    'String','Spectrum Tile', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_Option_1_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{1}, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_spectrum_of_windows});
%%            Spectal ratios
row=row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP3_TA_buttongroup, ...
    'String','HVSR Tile', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_Option_2_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{3}, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hvsr_of_windows});
%%            HVSR curve
row=row+1;
objw = [0.4 0.2 0.2 0.2];
objx = [0   0.4 0.6 0.8];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP3_TA_buttongroup, ...
    'String','Average HVSR', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_Option_3_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{5}, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hvsr_average_curve});
T3_Option_3_2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{6}, ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hvsr_H_V_Components_Compare});
T3_Option_3_3 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{7}, ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh], ...
    'Callback',{@CB_hvsr_all_windows_curves});
%%            HVSR directional curve
row=row+1;
objw = [0.4 0.3 0.3];
objx = [0   0.4 0.7];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP3_TA_buttongroup, ...
    'String','Directional HVSR', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_Option_4_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{8}, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hvsr_180_windows});
T3_Option_4_2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP3_TA_buttongroup, ...
    'String',P3_TA_buttongroup_option{9}, ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hvsr_180_curves});
%%            Mouse over tips
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    %hoveoverstring = sprintf('Angular discretization to be used in computing\nthe "Directional spectral ratio".');
    set(T3_Option_1_1,  'TooltipString','Tiled view of spectrums (side by side windows).')
% %     set(T3_Option_1_2,  'TooltipString','Tiled view of spectrums (smooth image).')
    %
    set(T3_Option_2_1,  'TooltipString','Tiled view of HVSR (side by side windows).')
% %     set(T3_Option_2_2,  'TooltipString','Tiled view of HVSR (smooth image).')
    %
    set(T3_Option_3_1,  'TooltipString','Show the mean HVSR curve.')
    set(T3_Option_3_2,  'TooltipString','Show comparison between horizontal and vertical.')
    set(T3_Option_3_3,  'TooltipString','Show curves of all windows.')
    %
    set(T3_Option_4_1,  'TooltipString','Show Direction dependent spectral ratio (as image).')
    set(T3_Option_4_2,  'TooltipString','Show Direction dependent spectral ratio (all computed curves).')
end
%%         Graphical Preferences
objw = [0.08 0.08 0.08 0.09];
objx = [0.33 0.41 0.49 0.57];
row=1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D, ...
    'String','Color axis', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T3_PD_mincolor = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',H.PANELS{P.tab_id}.D, ...
    'String','n.a.', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'callback', {@CB_Update_Computation_caxis});
T3_PD_maxcolor = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',H.PANELS{P.tab_id}.D, ...
    'String','n.a.', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'callback', {@CB_Update_Computation_caxis});
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton', ...
    'parent',H.PANELS{P.tab_id}.D, ...
    'String','reset', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh], ...
    'callback', {@CB_Reset_Computation_caxis});
row = row+2;
objw = [0.08 0.08 0.08 0.09];
objx = [0.33 0.41 0.49 0.57];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.D, ...
    'String','Peak:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
h_ThisPeakHz = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.D, ...
    'String','n.a', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%         update button
row = 2;
objw = 0.34;
objx = 0.66;
T3_update = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.D, ...
    'String','Update', ...
    'Units','normalized','Position',[objx, objy(row), objw, 2*objh], ...
    'Callback',{@CB_TAB_spectrum_view_update});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T3_update,'TooltipString',sprintf('Force update\n \n(ONLY GRAPHICS)'))
end
%
row = 5;
objw = 0.2;
objx = 0.8;
ISBUSY3 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D,'Units','normalized','Position',[objx, objy(row), objw, objh], ...
    'BackgroundColor', [0 0.8 0], 'String','Ready');
%% TAB-4: ====================== 2D view
create_new_tab('2D views');
set(H.TABS(P.tab_id),'ButtonDownFcn',{@CB_TAB_create_reference_scales})
%%     Panels
H.PANELS{P.tab_id}.A = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay1.A);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.A,'title','A');end
H.PANELS{P.tab_id}.B = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay1.B);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.B,'title','B');end
H.PANELS{P.tab_id}.C = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay1.C);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.C,'title','C');end
%
%%     Objets on panel A
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%         Visualizations
%%             Controls (Maps)
% Create three radio buttons in the button group. get(hP4_TA_buttongroup,'Value')
hP4_TA_buttongroup = uibuttongroup('parent',H.PANELS{P.tab_id}.A, ... %'Visible','off',...
    'Position',[0 0 1 1],P.SelectionChangeOption,{@CB_selection_2D_view});
P4_TA_buttongroup_option{1} = 'HVSR: Main peak frequence';
P4_TA_buttongroup_option{2} = 'HVSR: Main peak amplitude';
P4_TA_buttongroup_option{3} = 'HVSR: Direction at main peak';
P4_TA_buttongroup_option{4} = 'HVSR: freq-dependent contour';
%
row=1;
T4_2D_option_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP4_TA_buttongroup, ...
    'String',P4_TA_buttongroup_option{1}, ...
    'Units','normalized','Position',[0, objy(row), 1, objh]);
row=row+1;
T4_2D_option_2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP4_TA_buttongroup, ...
    'String',P4_TA_buttongroup_option{2}, ...
    'Units','normalized','Position',[0, objy(row), 1, objh]);
%
row=row+1;
objw=[0.7 0.15 0.15];
objx=[0.0 0.7 0.85];
T4_2D_option_3 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP4_TA_buttongroup, ...
    'String',P4_TA_buttongroup_option{3}, ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);

uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP4_TA_buttongroup, ...
    'String','Df (%)', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
h_deltafmainpeak = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',hP4_TA_buttongroup, ...
    'String','0', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
%
row=row+1;
objw=[0.7 0.1 0.1 0.1];
objx=[0.0 0.7 0.8 0.9];
T4_2D_option_4 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',hP4_TA_buttongroup, ...
    'String',P4_TA_buttongroup_option{4}, ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T4_2D_option_4a = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','-', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_2Dview_freq_DOWN});
T4_2D_option_4b = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','->', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_2Dview_freq_GOTO});
T4_2D_option_4c = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','+', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh], ...
    'Callback',{@CB_hAx_2Dview_freq_UP});
row=row+1;
T4_current_freq = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'Units','normalized','Position',[objx(2), objy(row), sum(objw(2:4)), objh]);
%%             Mouse over tips
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Show 2D interpolated values of F0\n(F0 = main peak''s frequency position).');
    set(T4_2D_option_1,'TooltipString',hoveoverstring)
    %
    hoveoverstring = sprintf('Show 2D interpolated values amplitude at F0\n(F0 = main peak''s frequency position).');
    set(T4_2D_option_2,'TooltipString',hoveoverstring)
    %
    hoveoverstring = sprintf('Show a 2D view of the preferential signal''s arrival\ndirection (Computed using the HVSR-directional option).\nRelative arrows length is proportional to the importance of the directional effect.\n \nIf df>0 the maximum and minimum angular directions computed on a buffer wide df [Hz]\nand centered on F0 is shown.\n(F0 = main peak''s frequency position).');
    set(T4_2D_option_3,'TooltipString',hoveoverstring)
    %
    hoveoverstring = sprintf('Show the 2D interpolated HVSR amplitude at a specific Frequency.');
    set(T4_2D_option_4,'TooltipString',hoveoverstring)
    set(T4_2D_option_4a,'TooltipString','Decrease frequecy')
    set(T4_2D_option_4b,'TooltipString','Select frequecy')
    set(T4_2D_option_4c,'TooltipString','Increase frequecy')
    %
    %
    %set(T3_P1_winoverlap,'TooltipString','Percentage of windows overlap')
    %hoveoverstring = sprintf('Automatic transient discard dased on the STA/LTA ratio.\n \nShort Term Average: average amplitude along the window\n\nLong Term Average: average amplitude along the entire recording');
    %set(T3_P1_wintstaltaratio,'TooltipString',hoveoverstring)
end
if strcmp(P.ExtraFeatures.development_help_features, 'on')
    row=row+1;
    uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
        'parent',hP4_TA_buttongroup, ...
        'String','opt 4', ...
        'Units','normalized','Position',[0, objy(row), 1, objh]);
    row=row+1;
    uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
        'parent',hP4_TA_buttongroup, ...
        'String','opt 5', ...
        'Units','normalized','Position',[0, objy(row), 1, objh]);
end
%%             Graphycal options
%      filled/contour
row=row+2;
objw=[0.5 0.5];
objx=[0.0 0.5];
% use extra points
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP4_TA_buttongroup, ...
    'String','Interpolation: use extra points:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
h_contour_extra_points = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup', ...
    'parent',hP4_TA_buttongroup, ...
    'String','no|yes', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
row=row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP4_TA_buttongroup, ...
    'String','Contour style:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
h_contour_color_style = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup', ...
    'parent',hP4_TA_buttongroup, ...
    'String','filled|lines', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%      filled/contour
row=row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',hP4_TA_buttongroup, ...
    'String','Contour levels:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
h_contour_color_levels = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',hP4_TA_buttongroup, ...
    'String','50', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%             Profiles
objw = 1;
objx = 0;
row = row+2;
T4_2D_Prf_0 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.A, ...
    'String','====== Profiles ======', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
% HVSR
row = row+1;
objw=[0.1 0.1 0.1 0.5];
objx=[0.0 0.1 0.2 0.5];
T4_2D_Prf_1a = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','-', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_profile_DOWN});
T4_2D_Prf_1b = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','->', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_profile_GOTO});
T4_2D_Prf_1c = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','+', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_profile_UP});
T4_2D_Prf_1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','HVSR', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh], ...
    'Callback',{@BT_show_property,1});
% E/V 
row = row+1;
objw=[0.3 0.5];
objx=[0.0 0.5];
h_shown_prof = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T4_2D_Prf_2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','E/V SR', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@BT_show_property,2});
% N/V
row = row+1;
T4_2D_Prf_3 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','N/V SR', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@BT_show_property,3});
% Confidence
row = row+1;
T4_2D_Prf_4 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Confidence 95%', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@BT_show_property,4});
%
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    tipstring = sprintf('Profile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
    set(T4_2D_Prf_0,'TooltipString',tipstring)
    %
    set(T4_2D_Prf_1,'TooltipString','Show the average HVSR in the profile.')
    set(T4_2D_Prf_1a,'TooltipString','Previous profile.')
    set(T4_2D_Prf_1b,'TooltipString','Go to profile.')
    set(T4_2D_Prf_1c,'TooltipString','Next profile.')
    %
    set(T4_2D_Prf_2,'TooltipString','Show the average E/V in the profile.')
    set(T4_2D_Prf_3,'TooltipString','Show the average N/V in the profile.')
    set(T4_2D_Prf_4,'TooltipString','Show 95% confidence in the profile.')
end
%
%
% 
%  
%%hP3_TA_buttongroup.Visible = 'on';
%%     Objets on panel B
%%         2D-Views
pos_axes_2DView = [0.1 0.1 0.85 0.85]; 
hAx_2D_hcmenu = uicontextmenu;
uimenu(hAx_2D_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,5});
uimenu(hAx_2D_hcmenu, 'Label', 'Export last visualized profile','Callback', {@export_last_profile});%, 'Separator','on');
uimenu(hAx_2D_hcmenu, 'Label', 'Export current profile as a stand-alone elaboration','Callback', {@export_current_profile_as_standalone_elaboration});%, 'Separator','on');
hAx_2DViews = axes('Parent',H.PANELS{P.tab_id}.B,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axes_2DView,'uicontextmenu',hAx_2D_hcmenu);
%%     Objets on panel C
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.C, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%        grid
row=1;
objw=[0.2 0.2 0.2];
objx=[0.2 0.4 0.6];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.C, ...
    'String','grid(x,y)', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh])
T4_dx = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.C, ...
    'String','100', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
T4_dy = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.C, ...
    'String','100', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
%%        arrows
row=row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.C, ...
    'String','arrows size', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh])
T4_arrow_scale = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.C, ...
    'String','0.1', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%        update button
row=row+1;
T4_update = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.C, ...
    'String','Update', ...
    'Units','normalized','Position',[0, objy(row), 1, objh], ...
    'Callback',{@CB_TAB_2D_views_Update});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T4_update,'TooltipString',sprintf('Update graphic'))
end
%
row = row  +2;
objw = 0.2;
objx = 0.8;
ISBUSY4 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C,'Units','normalized','Position',[objx, objy(row), objw, objh], ...
    'BackgroundColor', [0 0.8 0], 'String','Ready');
%%
%% TAB-5: ====================== 3D view
create_new_tab('3D views');
set(H.TABS(P.tab_id),'ButtonDownFcn',{@CB_TAB_create_reference_scales})
%%     Panels
H.PANELS{P.tab_id}.A = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay1.A);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.A,'title','A');end
H.PANELS{P.tab_id}.B = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay1.B);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.B,'title','B');end
H.PANELS{P.tab_id}.C = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay1.C);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.C,'title','C');end
%
%%     Objets on panel A
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_objh );
objy = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_object_levels );
%
%%         Viewed Quantity and navigation
% Freq -> depth (surface)
objw = 0.5;
objx = 0.0;
row = 1;
T5_3D_Option1 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Main Freq', ...
    'Units','normalized','Position',[objx(1), objy(row), objw, objh], ...
    'Callback',{@BT_show_plot3graph,1});
% Main Freq-Direction
row = row+1;
objw=[0.5 0.15 0.15];
objx=[0.0 0.7 0.85];
T5_3D_Option2 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Main Freq-Direction', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@BT_show_plot3graph,2});
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Df (%)', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
h_deltafmainpeak3D = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','0', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);

% Direction of full curves
objw = [ 0.5, 0.125, 0.125, 0.125, 0.125];
objx = [ 0.0, 0.500, 0.625, 0.750, 0.875];
row = row+2;
T5_3D_Option3 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','Direction of full curves', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@BT_show_plot3graph,3});
%
T5_3D_Option3a = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_geo_back_Vf});
T5_3D_Option3b = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','go to', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_geo_goto_Vf});
T5_3D_Option3c = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh], ...
    'Callback',{@CB_hAx_geo_next_Vf});
hT3did = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.A, ...
    'String','n.a.', ...
    'Units','normalized','Position',[objx(5), objy(row), objw(5), objh]);
%
row = row+1;
objw = [ 0.5, 0.25, 0.25];
objx = [ 0.0, 0.500, 0.75];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.A, ...
    'String','View frequency:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T5_3D_Option3_fmin = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String','0', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
T5_3D_Option3_fmax = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.A, ...
    'String','100', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
%
row=row+2;
objw=[0.5 0.5];
objx=[0.0 0.5];
% view mode
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Surface', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
h_view3d_mode = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','off|frame|interp', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
% use extra points
row=row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Interpolation: use extra points:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
h_bedrock_extra_points3d = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','no|yes', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    hoveoverstring = sprintf('Show a 3D interpolated view of F0\nDepth = -1/F0\n(F0 = main peak''s frequency position).');
    set(T5_3D_Option1,'TooltipString',hoveoverstring)
    %
    hoveoverstring = sprintf('Show a 3D interpolated viwew of F0\nand add preferential signal arrival direction\ncomputed using the HVSR-directional option ("Computations" Tab).\nDepth = -1/F0\n(F0 = main peak''s frequency position).');
    set(T5_3D_Option2,'TooltipString',hoveoverstring)
    %
    hoveoverstring = sprintf('Show the preferential signal arrival direction for the entire HVSR curve\ncomputed using the HVSR-directional option ("Computations" Tab).\nRed: F0 +/- 1Hz\n Yellow: F0 +/- 2.5Hz');
    set(T5_3D_Option3,'TooltipString',hoveoverstring)
    %
    set(T5_3D_Option3a,'TooltipString','Previous curve')
    set(T5_3D_Option3b,'TooltipString','Go to curve')
    set(T5_3D_Option3c,'TooltipString','Next curve')
end
%
%%     Objets: 3D representation
pos_axes  = [0.10 0.10 0.90 0.90];
hAx_3DViews_hcmenu = uicontextmenu;
uimenu(hAx_3DViews_hcmenu, 'Label', 'Edit externally','Callback', {@plot_extern,6});
hAx_3DViews = axes('Parent',H.PANELS{P.tab_id}.B,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position', pos_axes,'uicontextmenu',hAx_3DViews_hcmenu);
%%     Objets on panel C
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.C, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%        arrows
row=1;
objw=[0.2 0.2 0.2];
objx=[0.2 0.4 0.6];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text','parent',H.PANELS{P.tab_id}.C, ...
    'String','arrows length', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh])
T5_arrow_scale = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit','parent',H.PANELS{P.tab_id}.C, ...
    'String','0.1', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
%%        daspect/box/grid
objw=[0.2 0.2 0.2 0.2];
objx=[0.2 0.4 0.6 0.8];
row=row+1;
T5_daspect=uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','Aspect (x,y,z scaling)','Value',P.Flags.View_3D_daspect, ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_3Dview_daspect});
T5_daspect_x=uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','1', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
T5_daspect_y=uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','1', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh]);
T5_daspect_z=uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','1', ...
    'Units','normalized','Position',[objx(4), objy(row), objw(4), objh]);
%
row=row+1;
T5_box=uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','Box','Value',P.Flags.View_3D_box, ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_3Dview_box});
%
T5_grid=uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','radiobutton', ...
    'parent',H.PANELS{P.tab_id}.C, ...
    'String','Grid','Value',P.Flags.View_3D_grid, ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_3Dview_grid});
%%        update button
row=row+1;
T5_update = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.C, ...
    'String','Update', ...
    'Units','normalized','Position',[0, objy(row), 1, objh], ...
    'Callback',{@CB_TAB_3D_views_Update});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T5_update,'TooltipString',sprintf('Update graphic'))
end
%
row = row  +1;
objw = 0.2;
objx = 0.8;
ISBUSY5 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.C,'Units','normalized','Position',[objx, objy(row), objw, objh], ...
    'BackgroundColor', [0 0.8 0], 'String','Ready');
%% TAB-6: ====================== Malte Ibs-von Seht and Wohlenberg.
create_new_tab('IVS&W'); 
set(H.TABS(P.tab_id),'ButtonDownFcn',{@CB_TAB_update_IBSeW_statistics})
%%     Panels
H.PANELS{P.tab_id}.A = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay2.A);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.A,'title','A');end
H.PANELS{P.tab_id}.B = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay2.B);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.B,'title','B');end
H.PANELS{P.tab_id}.C = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units', 'normalized','Position',Pnl.Lay2.C);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.C,'title','C');end
H.PANELS{P.tab_id}.D = uipanel('parent',H.TABS(P.tab_id),'FontSize',USER_PREFERENCE_interface_objects_fontsize,'Units','normalized','Position',Pnl.Lay2.D);
if(strcmp(P.ExtraFeatures.tab_labels_enable_status,'on')); set(H.PANELS{P.tab_id}.D,'title','D');end
%
%%    Objets on panel A
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.A, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%
%%        Navigation      
row=1;
objw = [0.33,  0.33,  0.33];
objx = [0.00,  0.33,  0.66];
T6_PA_dat_bk = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','<<', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'Callback',{@CB_hAx_geo_back});
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','go to', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_hAx_geo_goto});
T6_PA_dat_fw = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.A, ...
    'String','>>', ...
    'Units','normalized','Position',[objx(3), objy(row), objw(3), objh], ...
    'Callback',{@CB_hAx_geo_next});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T6_PA_dat_fw,'TooltipString','Next location')
    set(T6_PA_dat_bk,'TooltipString','Previous location')
end
%
%%        Manual depth
objw = [ 0.4,  0.6];
objx = [0.00,  0.4];
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Bedrock depth', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T6_PA_BedrockDepth = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','edit',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', '', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_manual_bedrock_depth});
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Info. source: ', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T6_PA_BedrockDepthSource = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', '', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh]);
row = row+1;
T6_PA_Remove = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', 'delete', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_reset_bedrock_depth});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T6_PA_BedrockDepth,  'TooltipString','Edit to manually provide a known\n bedrock depth at this location.')
    hoveoverstring = sprintf('States which is the source of information about the\n depth of bedrock at this location.');
    set(T6_PA_BedrockDepthSource,  'TooltipString',hoveoverstring)
    set(T6_PA_Remove,  'TooltipString','Remove any information about the depth of bedrock at this location.')
end
%%        Regression
objw = [ 0.4,  0.6];
objx = [0.00,  0.4];
row = row+3;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Show regression:', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T6_PA_Regression = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'All','Computed','Ibs-von Seht (1999)','Parolai (2002)','Hinzen (2004)'}, ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_regression});
row = row+1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String','Show Bedrock:', ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T6_PA_Bedrock = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','popup',...
    'parent',H.PANELS{P.tab_id}.A, ...
    'String', {'off','Computed','Ibs-von Seht (1999)','Parolai (2002)','Hinzen (2004)','ALL'}, ...
    'HorizontalAlignment','left', ...
    'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'Callback',{@CB_regression});
%
%%    Objets on panel B
%%        Geometry map
pos_axes_geo3  = [0.1 0.1 0.8 0.8];
hAx_geo3_hcmenu = uicontextmenu;
uimenu(hAx_geo3_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,1});
hAx_geo3= axes('Parent',H.PANELS{P.tab_id}.B,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axes_geo3,'uicontextmenu',hAx_geo3_hcmenu);
T6_PB_datafile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.B, ...
    'String','', ...
    'Units','normalized','Position',[0, 0.8, 1, 0.2]);%T1_PC_datafile_txt
%%    Objets on panel C
hAx_IBS1_hcmenu = uicontextmenu;
uimenu(hAx_IBS1_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,7});
pos_axs_IBS1 = [0.075 0.1    0.275 0.9];
hAx_IBS1= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized', ...
    'FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Position',pos_axs_IBS1,'uicontextmenu',hAx_IBS1_hcmenu);
%
hAx_IBS2_hcmenu = uicontextmenu;
uimenu(hAx_IBS2_hcmenu, 'Label', 'Edit externally',    'Callback', {@plot_extern,8});
pos_axs_IBS2 = [0.45 0.05   0.5 0.9];
hAx_IBS2= axes('Parent',H.PANELS{P.tab_id}.C,'Units', 'normalized', ...
    'FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Position',pos_axs_IBS2, ...
    'uicontextmenu',hAx_IBS2_hcmenu);%'title','Bedrock depth', ...
%
%%    Objets on panel D
objh = get_normalheight_on_panel( H.PANELS{P.tab_id}.D, G.main_objh );
nobjy = 1/objh;
objy = (1-1/nobjy):(-1/nobjy):0;
%%        Info
row = 1;
objw = [0.15 0.85];
objx = [0  0.15];
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D, ...
    'String','Data File:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T6_PD_datafile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'HorizontalAlignment','left',...
    'parent',H.PANELS{P.tab_id}.D,'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'BackgroundColor', [1 1 1]);
%
row = row  +1;
uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize, ...
    'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D, ...
    'String','Well File:', ...
    'Units','normalized','Position',[objx(1), objy(row), objw(1), objh]);
T6_PD_wellfile_txt = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'HorizontalAlignment','left',...
    'parent',H.PANELS{P.tab_id}.D,'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'BackgroundColor', [1 1 1]);
%%        update button
row=row +2;
T6_update = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','pushbutton','parent',H.PANELS{P.tab_id}.D, ...
    'String','Update', ...
    'Units','normalized','Position',[0, objy(row), 1, objh], ...
    'Callback',{@CB_TAB_IBSeW_Update});
if strcmp(USER_PREFERENCE_Move_over_suggestions,'on')
    set(T6_update,'TooltipString',sprintf('Update graphic'))
end
%
row = row  +1;
objw = [0.8 0.2];
objx = [0   0.8];
IBSmessage= uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D,'Units','normalized','Position',[objx(1), objy(row), objw(1), objh], ...
    'String','');
ISBUSY6 = uicontrol('FontSize',USER_PREFERENCE_interface_objects_fontsize,'Style','text', ...
    'parent',H.PANELS{P.tab_id}.D,'Units','normalized','Position',[objx(2), objy(row), objw(2), objh], ...
    'BackgroundColor', [0 0.8 0], 'String','Ready');
%% Initializations before gui publication
%%    Menu selection
colormap('Jet')
spunta(H.menu.view2d_Profile_smoothing_childs, P.profile.smoothing_strategy);
spunta(H.menu.view2d_Profile_normalization_childs, P.profile.normalization_strategy);
%%    Default degree visualization
if(strcmp(USER_PREFERENCE_hvsr_directional_reference_system,'compass'))
    set(H.menu.settings.compass,'Checked','on');
end
%
%% Publish GUI and set history
working_folder = '';
last_project_name = 'OpenHVSR_ProTo__project.m';
last_elaboration_name = 'OpenHVSR_ProTo__Elaboration_main.mat';
last_log_number= 0;
if exist('history.m', 'file') == 2
history
end
Pfunction__publish_gui(H.gui,H.menu.credits,P.appname,P.appversion);
%plottools(H.gui,'off')
set(H.gui, 'MenuBar', 'none');
set(H.gui, 'ToolBar', 'none');
%removeToolbarExplorationButtons(H.gui)
fprintf('[READY !]\n');
%
%
%% ========================================================================
%% GUI CALLBACKS
%% ========================================================================
%%   MENU
%%      Files
%%        Project
    function Menu_Project_Create(~,~,~)
        folder_name = uigetdir(working_folder,'Select working Folder for the project');
        if(folder_name)
            [file_format,SURVEYS,datafile_separator,datafile_columns,nameof_topography_file] = ...
                Pfiles__openhvsrproto_project_creator(USER_PREFERENCE_interface_objects_fontsize,folder_name, ...
                SURVEYS,datafile_separator,datafile_columns);
            newprojectname = strcat(folder_name,'/OpenHVSR_ProTO_project.m');
            fid = fopen(newprojectname,'w');
            
            fprintf(fid,'%% This is a project-file to input the program\n');
            fprintf(fid,'%% %s, %s\n',P.appname,P.appversion);
            fprintf(fid,'%% Created using the interactive interface.\n');
            fprintf(fid,'%% The present file is created in expert mode, therefore\n');
            fprintf(fid,'%% each single dataset can be excluded from the project simply commenting the \n');
            fprintf(fid,'%% corresponding line. \n');
            fprintf(fid,'%%\n');
            if strcmp(file_format,'saf')
                fprintf(fid,'%% User defined the input file format as %s\n',file_format);
                fprintf(fid,'%% this format should be authomatically recognized so that the variables\n');
                fprintf(fid,'%% > datafile_separator\n');
                fprintf(fid,'%% > datafile_columns\n');
                fprintf(fid,'%% does not need to be set\n');
            else
                fprintf(fid,'\n');
                fprintf(fid,'%% User defined the input file as a custom format %s\n',file_format);
                fprintf(fid,'%% Determined how microtremor files are read\n');
                fprintf(fid,'%% datafile_columns:   describes the columnwise structure of the data\n');
                fprintf(fid,'%%     [Vertical component column Id][East component column Id][North component column Id]\n');
                fprintf(fid,'%% datafile_separator: in H/V curve files, is a string separator between HEADER and DDAT\n');
                fprintf(fid,'datafile_separator = ''%s'';\n', datafile_separator);
                fprintf(fid,'datafile_columns   = [%d %d %d];\n',datafile_columns);
            end
            fprintf(fid,'%%\n');
            fprintf(fid,'%%\n');
            fprintf(fid,'%%\n');
            fprintf(fid,'%% Microtremor recordings:\n');
            Nsurveys = size(SURVEYS,1);
            if Nsurveys>0
                stringline = 'idx=0;\n'; 
                fprintf(fid,stringline);
                for ir = 1:Nsurveys
                    stringline = strcat('idx=idx+1; SURVEYS{idx,1} = [',num2str(SURVEYS{ir,1}(1)),', ',num2str(SURVEYS{ir,1}(2)),', ',num2str(SURVEYS{ir,1}(3)),'];  SURVEYS{idx,2} = ''',SURVEYS{ir,2},'''');
                    fprintf(fid,stringline);
                    switch file_format
                        case 'saf'
                            stringline = ';\n';
                        otherwise
                           stringline = strcat('; SURVEYS{idx,3} = ',num2str(SURVEYS{ir,3}),''';\n'); 
                    end
                    fprintf(fid,stringline);
                end
            end
            fprintf(fid,'%%\n');
            fprintf(fid,'%%\n');
            fprintf(fid,'%%\n');
            %% check for topography file ADDITIVE POINTS FOR CONTOURING
            % load a XYZ ascii file containing extra (topographycal) points
            fprintf(fid,'%%\n');
            fprintf(fid,'%%\n');
            fprintf(fid,'%%\n');
            if length(nameof_topography_file)>2
                fprintf(fid,'%% Additional geometric points (topography):\n');
                stringline = strcat( 'TOPOGRAPHY_file_name = ''',nameof_topography_file,'''\n');
            else
                fprintf(fid,'%% NOTE: NO Additional geometric points (topography) were added\n');
                stringline = strcat( '%% TOPOGRAPHY_file_name = ''''\n');
            end
            fprintf(fid,stringline);
            %
            fclose(fid);
        end
    end
    function Menu_Project_Load(~,~,~)
        [file,thispath] = uigetfile('*.m','Load Project Script(.m)',strcat(working_folder,last_project_name) );
        if(file ~= 0)
            is_busy();
            %% reset
            MASTER_RESET();
            %% updating history
            working_folder = thispath;
            last_project_name = file;
            if get(H.menu.settings.log,'UserData')==1; last_log_number=last_log_number+1; end
            fid = fopen('history.m','w');
            fprintf(fid, 'working_folder = ''%s'';\n', working_folder);
            fprintf(fid, 'last_project_name = ''%s'';\n', last_project_name);
            fprintf(fid, 'last_elaboration_name = ''%s'';\n', last_elaboration_name);
            fprintf(fid, 'last_log_number = %d;\n', last_log_number);
            fclose(fid);
            %% logging
            if get(H.menu.settings.log,'UserData')==1
                today = date;
                logfolder = strcat(working_folder,'logs');
                if(~exist(logfolder,'dir'))% create log folder
                    logfolder_exist = mkdir(logfolder);% 1 yes /0
                    if(logfolder_exist==1)
                        fprintf('log folder created.\n');
                    else
                        fprintf('log folder creation failed.\n');
                    end
                else
                    fprintf('log folder found.\n');
                end
                logname = strcat(working_folder,'logs/LOG_n',num2str(last_log_number),'_',P.appname,'_',P.appversion,'_',today,'.log');
                set(0,'DiaryFile',logname)
                diary(logname);
                diary on;
                fprintf('logging on %s\n',get(0,'DiaryFile'))
            else
                fprintf('<<logging disabled>>\n')
            end            
            %% loading
            scriptname = strcat(thispath,file);
            run(scriptname);
            %>> warning('sampling_frequences(s)')
            [DDAT,SURVEYS] = load_data2(working_folder,SURVEYS, datafile_columns,datafile_separator);
            WLLS = Pfiles__load_wells(working_folder,SURVEYS,WELLS);
            %
            sampling_frequences = zeros(1, size(SURVEYS,1));
            for s=1:size(SURVEYS,1)%setup sampling frequence vector
                sampling_frequences(s) = SURVEYS{s,3};
            end
            %
            if ~isempty(TOPOGRAPHY_file_name)
                TOPOGRAPHY = load_topography(working_folder,TOPOGRAPHY_file_name);
            end
            %% check for the data to have the same time-scale (and uniform the data)
            check_for_data_uniformity();% this will change DDAT
            %% initializing
            INIT_tool_variables();
            %
            %% select first file authomatically and update graphics
            P.isshown.id= 1;
            Update_survey_locations(hAx_main_geo);
            Update_survey_locations(hAx_geo1);
            Update_survey_locations(hAx_geo2);
            Update_survey_locations(hAx_geo3);
            Graphic_Gui_update_elaboration_parameters();
            Graphic_update_data(0); 
            %% disable useless features
            %% Disable useless
            if isempty(TOPOGRAPHY)
                set(h_contour_extra_points,  'Value',1,'Enable','off');% on tab 4
                set(h_bedrock_extra_points3d,'Value',1,'Enable','off');% on tab 5
            else
                set(h_contour_extra_points,  'Enable','on');% on tab 4
                set(h_bedrock_extra_points3d,'Enable','on');% on tab 5
            end
            %% update busy status
            is_done();
        end
    end
    function Menu_export_as_OpenHVSR_project(~,~,~)
        if isempty(SURVEYS); return; end
        Ndata = size(SURVEYS,1);
        no_procede=0;
        for d = 1:Ndata
            if DTB__windows__number(d,1)>0
                no_procede = 1;  
            end
        end
        if no_procede==0
            fprintf('[NO DATA TO EXPORT]\n')
            return;
        end
        %
        folder_name = uigetdir(working_folder);
        if(folder_name)
            is_busy();
            % get info on subsurface
            titlestr = 'Subsurface';
            prompt = {'Vs min','Vs max','Vs bedrock', 'N-layers'};
            def = {'250', '500', '2500', '5'};
            answer = inputdlg(prompt,titlestr,1,def);
            
            if(~isempty(answer))
                VSmin = str2double(answer{1});
                VSmax = str2double(answer{2});
                VSbdr = str2double(answer{3});
                Nlays = ceil(str2double(answer{4}));
                TEMP_SUBSURFACE = 999*ones( (Nlays+1),6);
                %% VS
                TEMP_SUBSURFACE(1:Nlays, 2) = (linspace(VSmin,VSmax,Nlays)).';% VS
                TEMP_SUBSURFACE((Nlays+1),2)= VSbdr;
                %% VP
                TEMP_SUBSURFACE(:, 1) = 1.5*TEMP_SUBSURFACE(:, 2);% VP
                %% Rho
                TEMP_SUBSURFACE(:, 3) = 1.8;%% Rho
                TEMP_SUBSURFACE((Nlays+1),3)= 2.2;
                
                %% Qp/Qs
                TEMP_SUBSURFACE(1:Nlays, 6) = (linspace( 5,20,Nlays)).';% QS
                TEMP_SUBSURFACE(1:Nlays, 5) = (linspace(15,30,Nlays)).';% QP
                %
                %% Write files
                newprojectname = strcat(folder_name,'/OpenHVSR_project.m');
                fid = fopen(newprojectname,'w');
                %
                fprintf(fid,'%% This is a project-file to input the program OpenHVSR\n');
                fprintf(fid,'%% automatically written by the program:\n');
                fprintf(fid,'%% %s, %s\n',P.appname,version);
                fprintf(fid,'%% after the user selected the function\n');
                fprintf(fid,'%% "Export as OpenHVSR project"\n');
                fprintf(fid,'\n');
                fprintf(fid,'%% Actions performed to create this file:\n');
                fprintf(fid,'%%  1) This project file (designed for OpenHVSR) was created\n');
                fprintf(fid,'%%  2) Data files used for OpenHVSR_ProTo were copied in this folder.\n');
                fprintf(fid,'%%  3) Subsurface files were created. The subsurface described in\n');
                fprintf(fid,'%%     these files is just an example.\n');
                fprintf(fid,'%%     The user must edit these files in order to obtain\n');
                fprintf(fid,'%%     the best first guess model\n');
                fprintf(fid,'\n');
                fprintf(fid,'%% Determined how H/V files are read\n');
                fprintf(fid,'%% NOT NECESSARY: datafile_separator\n');
                fprintf(fid,'%% NOT NECESSARY: datafile_columns = [1 2 3]; set as default [FREQ][HVSR][standard deviation]\n');
                fprintf(fid,'\n');
                fprintf(fid,'\n');

                Nsurveys = size(SURVEYS,1);
                if Nsurveys>0
                    for ff = 1:Nsurveys
                        [~,s,~]=fileparts(SURVEYS{ff,2});
                        fname = strcat(folder_name,'/',s,'.hv');

                        ifmin = DTB__section__Frequency_Vector{ff,1}(1);
                        ifmax = DTB__section__Frequency_Vector{ff,1}(2);
                        df    = DTB__section__Frequency_Vector{ff,1}(3);
                        fr = df*( (ifmin-1):(ifmax-1) ).';
                        hv = DTB__hvsr__curve{ff,1};
                        % >>>  er = DTB{ff,1}.hvsr.error;% relative error
                        er = DTB__hvsr__standard_deviation{ff,1};% standard deviation
                        %
                        dd = [fr, hv, er]; 
                        save(fname,'dd','-ascii');
                        %
                        %
                        %% add a line in the project
                        is = num2str(ff);
                        stringline = strcat('SURVEYS{',is,',1} = [',num2str(SURVEYS{ff,1}(1)),', ',num2str(SURVEYS{ff,1}(2)),', ',num2str(SURVEYS{ff,1}(3)),'];\n');
                        fprintf(fid,stringline);
                        %fname = strcat(s,'_sinthetic.txt');
                        %fname = SURVEYS{ir,2};
                        fname = strcat(s,'.hv');
                        stringline = strcat('SURVEYS{',is,',2} = ''',fname,''';\n');
                        fprintf(fid,stringline);
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,'\n');
                    %
                    %% write subsurface files
                    for ir = 1:Nsurveys
                        %% HH
                        if ~isnan(DTB__hvsr__user_main_peak_frequence(ir,1))
                            F0 = DTB__hvsr__user_main_peak_frequence(ir,1);% user selection is always preferred
                        else
                            F0 = DTB__hvsr__auto_main_peak_frequence(ir,1);
                        end
                        VSmean = 0.5*(VSmin+VSmax);
                        Hmax = VSmean/(4*F0);% F0 = Vs/4H >> H = Vs/4F0
                        dH = Hmax/Nlays;
                        if dH<0.2; dH=0.2; end
                            
                        DUMMY_SUBSURFACE = TEMP_SUBSURFACE;% HH
                        DUMMY_SUBSURFACE(1:Nlays, 4) = dH*ones(Nlays,1);
                        %
                        [~,s,~]=fileparts(SURVEYS{ir,2});
                        % model
                        fname = strcat(folder_name,'/',s,'_subsurface.txt');
                        save(fname,'DUMMY_SUBSURFACE','-ascii');

                        is = num2str(ir);
                        fname = strcat(s,'_subsurface.txt');
                        stringline = strcat('MODELS{',is,',1} = ''',fname,''';\n');
                        fprintf(fid,stringline);
                        stringline = strcat('MODELS{',is,',2} = ',is,';\n');
                        fprintf(fid,stringline);
                    end
                end
                fprintf(fid,'\n');
                fprintf(fid,'\n');
                %% check for reference models 
                reference_model_file1 = strcat(folder_name,'/reference_model_dh.txt');
                reference_model_file2 = strcat(folder_name,'/reference_model_xz.txt');
                if(~isempty(REFERENCE_MODEL_dH))
                    save(reference_model_file1,'REFERENCE_MODEL_dH','-ascii');
                else
                    fprintf(fid,'%%  No reference subsurface (dh) was present.\n');
                end
                if(~isempty(REFERENCE_MODEL_zpoints))
                    save(reference_model_file2,'REFERENCE_MODEL_zpoints','-ascii');
                else
                    fprintf(fid,'%%  No reference subsurface (zpoints) was present.\n');
                end
            end
            is_done();
        end
        fprintf('[OpenHVSR-ProTO project Exported]\n')
    end
    function Menu_save_hvsr_as_txt(~,~,~)
        if isempty(SURVEYS); return; end
        Ndata = size(SURVEYS,1);
        no_procede=0;
        for d = 1:Ndata
            if DTB__windows__number(d,1)>0
                no_procede = 1;  
            end
        end
        if no_procede==0
            fprintf('[NO HV TO EXPORT]\n')
            return;
        end
        folder_name = uigetdir(working_folder);
        save_hvsr_on_ascii(folder_name);
    end
    function Menu_save_full_results_as_txt_set(~,~,~)
        if isempty(SURVEYS); return; end
        Ndata = size(SURVEYS,1);
        no_procede=0;
        for d = 1:Ndata
            if DTB__windows__number(d,1)>0
                no_procede = 1;  
            end
        end
        if no_procede==0
            fprintf('[NO DATA TO EXPORT]\n')
            return;
        end
        folder_name = uigetdir(working_folder);
        %
        %% save hvsr curves on file (in HV subfolder)
        subfolder = strcat(folder_name,'/HV');
        if exist(subfolder,'dir') == 0 
            mkdir(subfolder)
        end
        save_hvsr_on_ascii(subfolder); 
        %% A property as function of xy (3 column files).
        subfolder = strcat(folder_name,'/As_function_of_XY');
        if exist(subfolder,'dir') == 0 
            mkdir(subfolder)
        end
        save_xy_property_on_ascii(subfolder)
    end
%%        Elaboration
    function Menu_Save_elaboration(~,~,~)
        if isempty(SURVEYS); return; end
        [file,thispath] =  uiputfile('*.mat','Save elaboration', strcat(working_folder,'Elaboration.mat'));
%% =========================== V1.0.0-V1.0.1 
%         if(file ~= 0)
%             is_busy();
%             name = file(1:end-4);
%             datname = strcat(thispath,name,'_MAIN.mat');
%             save(datname, ...
%                 'file', ...
%                 'thispath', ...
%                 'DDAT', ...
%                 'FDAT', ...
%                 'Matlab_Release', ...
%                 'Matlab_Release_num', ...
%                 'SURVEYS', ...
%                 'TOPOGRAPHY', ...% MANUALLY PLACED HERE
%                 'WELLS', ...
%                 'WLLS', ...
%                 'datafile_columns', ...
%                 'datafile_separator', ...
%                 'receiver_locations', ...
%                 'reference_system', ...
%                 'sampling_frequences', ...
%                 ...% 'survey_boundingboox', ...
%                 'working_folder');
%             %
%             NN = size(SURVEYS,1);
%             sNN = num2str(NN);
%             for ii=1:NN
%                 fprintf('Save %d/%d',ii,NN) 
%                 datname = strcat(thispath,name,'_database_',num2str(ii),'of',sNN,'.mat');
%                 databas = DTB{ii,1};
%                 save(datname, 'databas');
%                 fprintf('..OK\n')
%             end
%             is_done();
%             fprintf('[Elaboration saved]\n')
%         end
%% ================================ 
%% =========================== V2.0.0 - V2.1.0 
        if(file ~= 0)
            is_busy();
            name = file(1:end-4);
            %%   MAIN
            datname = strcat(thispath,name,'_MAIN.mat');
            appname = P.appname;
            % save_version = 2;% 181111: version with one full DDAT FDAT
            save_version = 3;% 190131: version with split DDAT FDAT
            
            iprofile = P.profile;
            iprofile_ids = P.profile_ids;
            iprofile_line = P.profile_line;
            iprofile_onoff = P.profile_onoff;
            iprofile_name = P.profile_name;
            
            save(datname, ...
                'appname', ... %181111  just to check the correct data is loaded
                'save_version', ...%181111 discern which load function to run
                'file', ...
                'thispath', ...
                ...% 'DDAT', ... 190131:  DDAT FDAT are now split
                ...% 'FDAT', ... 190131:  DDAT FDAT are now split
                'Matlab_Release', ...
                'Matlab_Release_num', ...
                'SURVEYS', ...
                'TOPOGRAPHY', ...% MANUALLY PLACED HERE
                'WELLS', ...
                'WLLS', ...
                'datafile_columns', ...
                'datafile_separator', ...
                'receiver_locations', ...
                'reference_system', ...
                'sampling_frequences', ...
                ...% 'survey_boundingboox', ...
                'working_folder', ...
                'iprofile', ...
                'iprofile_ids', ...
                'iprofile_line', ...
                'iprofile_onoff', ...
                'iprofile_name');
            
            NN = size(SURVEYS,1);
            sNN = num2str(NN);
            for ii=1:NN% store database
                fprintf('Save %d/%d',ii,NN) 
                datname = strcat(thispath,name,'_database_',num2str(ii),'of',sNN,'.mat');
                %% COPY 
                %%   DTB__status
                iDTB__status = DTB__status(ii,1);%                                            
                iDTB__elaboration_progress = DTB__elaboration_progress(ii,1);
                %%   DTB__windows
                iDTB__windows__width_sec = DTB__windows__width_sec(ii,1);          
                iDTB__windows__number =DTB__windows__number(ii,1);
                iDTB__windows__number_fft = DTB__windows__number_fft(ii,1);
                iDTB__windows__indexes = DTB__windows__indexes{ii,1};
                iDTB__windows__is_ok = DTB__windows__is_ok{ii,1};
                iDTB__windows__winv = DTB__windows__winv{ii,1};                 
                iDTB__windows__wine = DTB__windows__wine{ii,1};
                iDTB__windows__winn = DTB__windows__winn{ii,1};
                iDTB__windows__fftv = DTB__windows__fftv{ii,1};
                iDTB__windows__ffte = DTB__windows__ffte{ii,1};
                iDTB__windows__fftn = DTB__windows__fftn{ii,1};
                iDTB__windows__info = DTB__windows__info(ii,:);                  
                %%   i = DTB__elab_parameters        
                iDTB__elab_parameters__status = DTB__elab_parameters__status{ii,1};
                iDTB__elab_parameters__hvsr_strategy = DTB__elab_parameters__hvsr_strategy(ii,1);
                iDTB__elab_parameters__hvsr_freq_min = DTB__elab_parameters__hvsr_freq_min(ii,1);
                iDTB__elab_parameters__hvsr_freq_max = DTB__elab_parameters__hvsr_freq_max(ii,1);
                iDTB__elab_parameters__windows_width = DTB__elab_parameters__windows_width(ii,1);
                iDTB__elab_parameters__windows_overlap = DTB__elab_parameters__windows_overlap(ii,1);
                iDTB__elab_parameters__windows_tapering = DTB__elab_parameters__windows_tapering(ii,1);
                iDTB__elab_parameters__windows_sta_vs_lta = DTB__elab_parameters__windows_sta_vs_lta(ii,1);
                iDTB__elab_parameters__windows_pad = DTB__elab_parameters__windows_pad{ii,1};
                iDTB__elab_parameters__smoothing_strategy = DTB__elab_parameters__smoothing_strategy(ii,1);
                iDTB__elab_parameters__smoothing_slider_val = DTB__elab_parameters__smoothing_slider_val(ii,1);
                        %
                        % filter
                iDTB__elab_parameters__filter_id = DTB__elab_parameters__filter_id(ii,1);
                iDTB__elab_parameters__filter_name = DTB__elab_parameters__filter_name{ii,1};
                iDTB__elab_parameters__filter_order = DTB__elab_parameters__filter_order(ii,1);
                iDTB__elab_parameters__filterFc1 = DTB__elab_parameters__filterFc1(ii,1);
                iDTB__elab_parameters__filterFc2 = DTB__elab_parameters__filterFc2(ii,1);
                iDTB__elab_parameters__data_to_use = DTB__elab_parameters__data_to_use(ii,1);
                iDTB__elab_parameters__THEfilter = DTB__elab_parameters__THEfilter{ii,1};
                %%   i = DTB__section
                iDTB__section__Min_Freq = DTB__section__Min_Freq(ii,1);
                iDTB__section__Max_Freq = DTB__section__Max_Freq(ii,1);
                iDTB__section__Frequency_Vector = DTB__section__Frequency_Vector{ii,1};
                        %
                iDTB__section__V_windows = DTB__section__V_windows{ii,1};
                iDTB__section__E_windows = DTB__section__E_windows{ii,1};
                iDTB__section__N_windows = DTB__section__N_windows{ii,1};
                        %
                iDTB__section__Average_V = DTB__section__Average_V{ii,1};
                iDTB__section__Average_E = DTB__section__Average_E{ii,1};
                iDTB__section__Average_N = DTB__section__Average_N{ii,1};
                        %
                iDTB__section__HV_windows = DTB__section__HV_windows{ii,1};
                iDTB__section__EV_windows = DTB__section__EV_windows{ii,1};
                iDTB__section__NV_windows = DTB__section__NV_windows{ii,1};
                %%   i = DTB__hvsr
                iDTB__hvsr__curve_full = DTB__hvsr__curve_full{ii,1};
                %DTB{s,1}.hvsr.error_full = [];
                iDTB__hvsr__confidence95_full = DTB__hvsr__confidence95_full{ii,1};
                iDTB__hvsr__curve_EV_full = DTB__hvsr__curve_EV_full{ii,1};
                iDTB__hvsr__curve_NV_full = DTB__hvsr__curve_NV_full{ii,1};
                %
                iDTB__hvsr__EV_all_windows = DTB__hvsr__EV_all_windows{ii,1};
                iDTB__hvsr__NV_all_windows = DTB__hvsr__NV_all_windows{ii,1};
                iDTB__hvsr__HV_all_windows = DTB__hvsr__HV_all_windows{ii,1};
                %
                iDTB__hvsr__curve = DTB__hvsr__curve{ii,1};
                        %DTB{s,1}.hvsr.error = [];
                iDTB__hvsr__confidence95 = DTB__hvsr__confidence95{ii,1};
                iDTB__hvsr__standard_deviation = DTB__hvsr__standard_deviation{ii,1};
                iDTB__hvsr__curve_EV = DTB__hvsr__curve_EV{ii,1};
                iDTB__hvsr__curve_NV = DTB__hvsr__curve_NV{ii,1};
                        %
                iDTB__hvsr__peaks_idx = DTB__hvsr__peaks_idx{ii,1};
                iDTB__hvsr__hollows_idx = DTB__hvsr__hollows_idx{ii,1};
                iDTB__hvsr__user_additional_peaks = DTB__hvsr__user_additional_peaks{ii,1};
                %
                iDTB__hvsr__user_main_peak_frequence = DTB__hvsr__user_main_peak_frequence(ii,1);
                iDTB__hvsr__user_main_peak_amplitude = DTB__hvsr__user_main_peak_amplitude(ii,1);
                iDTB__hvsr__user_main_peak_id_full_curve = DTB__hvsr__user_main_peak_id_full_curve(ii,1);
                iDTB__hvsr__user_main_peak_id_in_section = DTB__hvsr__user_main_peak_id_in_section(ii,1);
                iDTB__hvsr__auto_main_peak_frequence = DTB__hvsr__auto_main_peak_frequence(ii,1);
                iDTB__hvsr__auto_main_peak_amplitude = DTB__hvsr__auto_main_peak_amplitude(ii,1);
                iDTB__hvsr__auto_main_peak_id_full_curve = DTB__hvsr__auto_main_peak_id_full_curve(ii,1);
                iDTB__hvsr__auto_main_peak_id_in_section = DTB__hvsr__auto_main_peak_id_in_section(ii,1);
                %
                %%   i = DTB__hvsr180
                iDTB__hvsr180__angle_id = DTB__hvsr180__angle_id(ii,1);
                iDTB__hvsr180__angles = DTB__hvsr180__angles{ii,1};
                iDTB__hvsr180__angle_step = DTB__hvsr180__angle_step(ii,1);
                iDTB__hvsr180__spectralratio = DTB__hvsr180__spectralratio{ii,1};
                iDTB__hvsr180__preferred_direction = DTB__hvsr180__preferred_direction{ii,1};
                %%   i = DTB__well
                iDTB__well__well_id = DTB__well__well_id(ii,1);
                iDTB__well__well_name = DTB__well__well_name{ii,1};
                iDTB__well__bedrock_depth__KNOWN = DTB__well__bedrock_depth__KNOWN{ii,1};
                iDTB__well__bedrock_depth_source = DTB__well__bedrock_depth_source{ii,1};
                iDTB__well__bedrock_depth__COMPUTED = DTB__well__bedrock_depth__COMPUTED{ii,1};
                iDTB__well__bedrock_depth__IBS1999 = DTB__well__bedrock_depth__IBS1999{ii,1};
                iDTB__well__bedrock_depth__PAROLAI2002 = DTB__well__bedrock_depth__PAROLAI2002{ii,1};
                iDTB__well__bedrock_depth__HINZEN2004 = DTB__well__bedrock_depth__HINZEN2004{ii,1};
                %% Database =====================END

                save(datname, ...
                ... %%   DTB__status
                'iDTB__status', ...                                            
                'iDTB__elaboration_progress', ... 
                ...%%   DTB__windows
                'iDTB__windows__width_sec', ...          
                'iDTB__windows__number', ...
                'iDTB__windows__number_fft', ... 
                'iDTB__windows__indexes', ... 
                'iDTB__windows__is_ok', ... 
                'iDTB__windows__winv', ...                 
                'iDTB__windows__wine', ... 
                'iDTB__windows__winn', ... 
                'iDTB__windows__fftv', ... 
                'iDTB__windows__ffte', ... 
                'iDTB__windows__fftn', ... 
                'iDTB__windows__info', ...                 
                ...%%   DTB__elab_parameters        
                'iDTB__elab_parameters__status', ...
                'iDTB__elab_parameters__hvsr_strategy', ...
                'iDTB__elab_parameters__hvsr_freq_min', ...
                'iDTB__elab_parameters__hvsr_freq_max', ...
                'iDTB__elab_parameters__windows_width', ...
                'iDTB__elab_parameters__windows_overlap', ...
                'iDTB__elab_parameters__windows_tapering', ...
                'iDTB__elab_parameters__windows_sta_vs_lta', ...
                'iDTB__elab_parameters__windows_pad', ...
                'iDTB__elab_parameters__smoothing_strategy', ...
                'iDTB__elab_parameters__smoothing_slider_val', ...
                ...% filter
                'iDTB__elab_parameters__filter_id', ... 
                'iDTB__elab_parameters__filter_name', ... 
                'iDTB__elab_parameters__filter_order', ...
                'iDTB__elab_parameters__filterFc1', ...
                'iDTB__elab_parameters__filterFc2', ...
                'iDTB__elab_parameters__data_to_use', ...
                'iDTB__elab_parameters__THEfilter', ...
                ...%%   DTB__section
                'iDTB__section__Min_Freq', ...
                'iDTB__section__Max_Freq', ...
                'iDTB__section__Frequency_Vector', ...
                ...
                'iDTB__section__V_windows', ... 
                'iDTB__section__E_windows', ...
                'iDTB__section__N_windows', ... 
                ...
                'iDTB__section__Average_V', ... 
                'iDTB__section__Average_E', ... ;
                'iDTB__section__Average_N', ...
                ...
                'iDTB__section__HV_windows', ... 
                'iDTB__section__EV_windows', ...
                'iDTB__section__NV_windows', ...
                ...%%  DTB__hvsr
                'iDTB__hvsr__curve_full', ... 
                ...%DTB{s,1}.hvsr.error_full', ... [];
                'iDTB__hvsr__confidence95_full', ... 
                'iDTB__hvsr__curve_EV_full', ...
                'iDTB__hvsr__curve_NV_full', ...
                ...
                'iDTB__hvsr__EV_all_windows', ...
                'iDTB__hvsr__NV_all_windows', ...
                'iDTB__hvsr__HV_all_windows', ...
                'iDTB__hvsr__curve', ...
                ...        %DTB{s,1}.hvsr.error', ... [];
                'iDTB__hvsr__confidence95', ...
                'iDTB__hvsr__standard_deviation', ...
                'iDTB__hvsr__curve_EV', ...
                'iDTB__hvsr__curve_NV', ...
                ...
                'iDTB__hvsr__peaks_idx', ... 
                'iDTB__hvsr__hollows_idx', ...
                'iDTB__hvsr__user_additional_peaks', ... % 190330
                'iDTB__hvsr__user_main_peak_frequence', ...
                'iDTB__hvsr__user_main_peak_amplitude', ...
                'iDTB__hvsr__user_main_peak_id_full_curve', ...
                'iDTB__hvsr__user_main_peak_id_in_section', ...
                'iDTB__hvsr__auto_main_peak_frequence', ... 
                'iDTB__hvsr__auto_main_peak_amplitude', ... 
                'iDTB__hvsr__auto_main_peak_id_full_curve', ... 
                'iDTB__hvsr__auto_main_peak_id_in_section', ... 
                ...%%   DTB__hvsr180
                'iDTB__hvsr180__angle_id', ... 
                'iDTB__hvsr180__angles', ... 
                'iDTB__hvsr180__angle_step', ... 
                'iDTB__hvsr180__spectralratio', ...
                'iDTB__hvsr180__preferred_direction', ... 
                ...%%   DTB__well
                'iDTB__well__well_id', ... 
                'iDTB__well__well_name', ...
                'iDTB__well__bedrock_depth__KNOWN', ... 
                'iDTB__well__bedrock_depth_source', ... 
                'iDTB__well__bedrock_depth__COMPUTED', ... 
                'iDTB__well__bedrock_depth__IBS1999', ... 
                'iDTB__well__bedrock_depth__PAROLAI2002', ...
                'iDTB__well__bedrock_depth__HINZEN2004');   
                
                fprintf('..OK\n')
            end
            for ii=1:NN% store data
                fprintf('Store data %d/%d..',ii,NN)
                datname = strcat(thispath,name,'_data_',num2str(ii),'of',sNN,'.mat');
                iDDAT1 = DDAT{ii,1};
                iDDAT2 = DDAT{ii,2};
                iDDAT3 = DDAT{ii,3};
                iFDAT1 = [];
                iFDAT2 = [];
                iFDAT3 = [];
                if ~isempty(FDAT)
                    if (~isempty(FDAT{ii,1})) && (~isempty(FDAT{ii,2})) && (~isempty(FDAT{ii,3}))
                        iFDAT1 = FDAT{ii,1};
                        iFDAT2 = FDAT{ii,2};
                        iFDAT3 = FDAT{ii,3};
                    end
                end
                save(datname, 'iDDAT1', 'iDDAT2', 'iDDAT3',  'iFDAT1', 'iFDAT2', 'iFDAT3');
                fprintf('OK\n')
            end
            is_done();
            fprintf('[Elaboration saved]\n')
        end             
    end
    function Menu_Load_elaboration(~,~,~)
        [file,thispath] = uigetfile('*.mat','Resume Elaboration',strcat(working_folder,'/',last_elaboration_name));        
        if(file ~= 0)
            is_busy();
            %% reset
            MASTER_RESET();
            %% updating history
            working_folder = thispath;
            last_elaboration_name = file;
            if get(H.menu.settings.log,'UserData')==1; last_log_number=last_log_number+1; end
            
            fid = fopen('history.m','w');
            fprintf(fid, 'working_folder = ''%s'';\n', working_folder);
            fprintf(fid, 'last_project_name = ''%s'';\n', last_project_name);
            fprintf(fid, 'last_elaboration_name = ''%s'';\n', last_elaboration_name);
            fprintf(fid, 'last_log_number = %d;\n', last_log_number);
            fclose(fid);
       
            %% load the store data
            datname = strcat(thispath,file);
            BIN = load(datname, '-mat');
            if isfield(BIN,'save_version')% load split DDAT/FDAT after 190131
                if(BIN.save_version==2)% load the data
                    fprintf('[archive version:2 (From V2.0.0)]\n')
                end
                if(BIN.save_version==3)% load the data
                    fprintf('[archive version:3 (From V2.1.0)]\n')
                end
            else
                fprintf('[archive version:1 (From V1.0.0)]\n')
            end
            
            if isfield(BIN,'DDAT');  DDAT= BIN.DDAT; end% not present in 'save_version'==3
            if isfield(BIN,'FDAT');  FDAT= BIN.FDAT; end% not present in 'save_version'==3
            % NO LOAD Matlab_Release
            % NO LOAD Matlab_Release_num
            if isfield(BIN,'SURVEYS');  SURVEYS= BIN.SURVEYS; end
            if isfield(BIN,'TOPOGRAPHY');  TOPOGRAPHY= BIN.TOPOGRAPHY; end% MANUALLY PLACED HERE
            if isfield(BIN,'WELLS'); WELLS = BIN.WELLS; end
            if isfield(BIN,'WLLS');  WLLS= BIN.WLLS; end
            if isfield(BIN,'datafile_columns');  datafile_columns= BIN.datafile_columns; end
            if isfield(BIN,'datafile_separator');  datafile_separator= BIN.datafile_separator; end
            if isfield(BIN,'receiver_locations');  receiver_locations= BIN.receiver_locations; end
            if isfield(BIN,'reference_system');  reference_system= BIN.reference_system; end
            if isfield(BIN,'sampling_frequences');  sampling_frequences= BIN.sampling_frequences; end
            % if isfield(BIN,'survey_boundingboox');  survey_boundingboox= BIN.survey_boundingboox; end
            if isfield(BIN,'working_folder');  working_folder = BIN.working_folder; end
            %
            if isfield(BIN,'iprofile');  P.profile = BIN.iprofile; end% 190212
            if isfield(BIN,'iprofile_ids');  P.profile_ids = BIN.iprofile_ids; end% 190212
            if isfield(BIN,'iprofile_line');  P.profile_line = BIN.iprofile_line; end% 190212
            if isfield(BIN,'iprofile_onoff');  P.profile_onoff = BIN.iprofile_onoff; end% 190212
            if isfield(BIN, 'iprofile_name');  P.profile_name = BIN.iprofile_name; end% 190212
            
            %% Load the database
            INIT_DATA_RELATED();
            name = file(1:end-9);% discard the '_MAIN.mat' part.
            NN = size(SURVEYS,1);
            sNN = num2str(NN);
            if isfield(BIN,'save_version')% load split DDAT/FDAT after 190131
                if(BIN.save_version==3)% load the data
                    DDAT = cell(NN,3);
                    FDAT = cell(NN,3);
                    for ii=1:NN
                        datname = strcat(thispath,name,'_data_',num2str(ii),'of',sNN,'.mat');
                        loadeddata = load(datname);
                        DDAT{ii,1} = loadeddata.iDDAT1; 
                        DDAT{ii,2} = loadeddata.iDDAT2; 
                        DDAT{ii,3} = loadeddata.iDDAT3; 
                        FDAT{ii,1} = loadeddata.iFDAT1; 
                        FDAT{ii,2} = loadeddata.iFDAT2; 
                        FDAT{ii,3} = loadeddata.iFDAT3; 
                    end
                end
            end
            if isfield(BIN,'save_version')
                if( BIN.save_version==2 || BIN.save_version==3)% save_version=2->V2.0.0    save_version=3->V2.1.0   
                    %fprintf('[archive version:2 (From V2.0.0)]\n')
                    for ii=1:NN
                       fprintf('Loading measure %d/%d',ii,NN) 
                       datname = strcat(thispath,name,'_database_',num2str(ii),'of',sNN,'.mat');
                       loaded = load(datname);
                    %%   DTB__status
                        DTB__status(ii,1) = loaded.iDTB__status;                                             
                        DTB__elaboration_progress(ii,1) = loaded.iDTB__elaboration_progress; 
                        %%   DTB__windows
                        DTB__windows__width_sec(ii,1) = loaded.iDTB__windows__width_sec;           
                        DTB__windows__number(ii,1) = loaded.iDTB__windows__number;
                        DTB__windows__number_fft(ii,1) = loaded.iDTB__windows__number_fft; 
                        DTB__windows__indexes{ii,1} = loaded.iDTB__windows__indexes; 
                        DTB__windows__is_ok{ii,1} = loaded.iDTB__windows__is_ok; 
                        DTB__windows__winv{ii,1} = loaded.iDTB__windows__winv;                 
                        DTB__windows__wine{ii,1} = loaded.iDTB__windows__wine; 
                        DTB__windows__winn{ii,1} = loaded.iDTB__windows__winn; 
                        DTB__windows__fftv{ii,1} = loaded.iDTB__windows__fftv; 
                        DTB__windows__ffte{ii,1} = loaded.iDTB__windows__ffte; 
                        DTB__windows__fftn{ii,1} = loaded.iDTB__windows__fftn; 
                        DTB__windows__info(ii,:) = loaded.iDTB__windows__info;                   
                        %%   i = DTB__elab_parameters        
                        DTB__elab_parameters__status{ii,1} = loaded.iDTB__elab_parameters__status; 
                        DTB__elab_parameters__hvsr_strategy(ii,1) = loaded.iDTB__elab_parameters__hvsr_strategy; 
                        DTB__elab_parameters__hvsr_freq_min(ii,1) =  loaded.iDTB__elab_parameters__hvsr_freq_min; 
                        DTB__elab_parameters__hvsr_freq_max(ii,1) = loaded.iDTB__elab_parameters__hvsr_freq_max; 
                        DTB__elab_parameters__windows_width(ii,1) = loaded.iDTB__elab_parameters__windows_width; 
                        DTB__elab_parameters__windows_overlap(ii,1) = loaded.iDTB__elab_parameters__windows_overlap; 
                        DTB__elab_parameters__windows_tapering(ii,1) = loaded.iDTB__elab_parameters__windows_tapering; 
                        DTB__elab_parameters__windows_sta_vs_lta(ii,1) = loaded.iDTB__elab_parameters__windows_sta_vs_lta; 
                        DTB__elab_parameters__windows_pad{ii,1} = loaded.iDTB__elab_parameters__windows_pad; 
                        DTB__elab_parameters__smoothing_strategy(ii,1) = loaded.iDTB__elab_parameters__smoothing_strategy; 
                        DTB__elab_parameters__smoothing_slider_val(ii,1) = loaded.iDTB__elab_parameters__smoothing_slider_val; 
                                %
                                % filter
                        DTB__elab_parameters__filter_id(ii,1) = loaded.iDTB__elab_parameters__filter_id;
                        DTB__elab_parameters__filter_name{ii,1} = loaded.iDTB__elab_parameters__filter_name;
                        DTB__elab_parameters__filter_order(ii,1) = loaded.iDTB__elab_parameters__filter_order; 
                        DTB__elab_parameters__filterFc1(ii,1) = loaded.iDTB__elab_parameters__filterFc1;
                        DTB__elab_parameters__filterFc2(ii,1) = loaded.iDTB__elab_parameters__filterFc2; 
                        DTB__elab_parameters__data_to_use(ii,1) = loaded.iDTB__elab_parameters__data_to_use; 
                        DTB__elab_parameters__THEfilter{ii,1} =loaded.iDTB__elab_parameters__THEfilter;
                        %%   i = DTB__section
                        DTB__section__Min_Freq(ii,1) = loaded.iDTB__section__Min_Freq;
                        DTB__section__Max_Freq(ii,1) = loaded.iDTB__section__Max_Freq; 
                        DTB__section__Frequency_Vector{ii,1} = loaded.iDTB__section__Frequency_Vector;
                                %
                        DTB__section__V_windows{ii,1} = loaded.iDTB__section__V_windows;
                        DTB__section__E_windows{ii,1} = loaded.iDTB__section__E_windows; 
                        DTB__section__N_windows{ii,1} = loaded.iDTB__section__N_windows; 
                                %
                        DTB__section__Average_V{ii,1} = loaded.iDTB__section__Average_V; 
                        DTB__section__Average_E{ii,1} = loaded.iDTB__section__Average_E; 
                        DTB__section__Average_N{ii,1} = loaded.iDTB__section__Average_N; 
                                %
                        DTB__section__HV_windows{ii,1} = loaded.iDTB__section__HV_windows; 
                        DTB__section__EV_windows{ii,1} = loaded.iDTB__section__EV_windows;
                        DTB__section__NV_windows{ii,1} = loaded.iDTB__section__NV_windows; 
                        %%   i = DTB__hvsr
                        DTB__hvsr__curve_full{ii,1} = loaded.iDTB__hvsr__curve_full;
                        %DTB{s,1}.hvsr.error_full = [];
                        DTB__hvsr__confidence95_full{ii,1} = loaded.iDTB__hvsr__confidence95_full; 
                        DTB__hvsr__curve_EV_full{ii,1} = loaded.iDTB__hvsr__curve_EV_full;
                        DTB__hvsr__curve_NV_full{ii,1} = loaded.iDTB__hvsr__curve_NV_full; 
                        %
                        DTB__hvsr__EV_all_windows{ii,1} = loaded.iDTB__hvsr__EV_all_windows; 
                        DTB__hvsr__NV_all_windows{ii,1} = loaded.iDTB__hvsr__NV_all_windows; 
                        DTB__hvsr__HV_all_windows{ii,1} = loaded.iDTB__hvsr__HV_all_windows; 
                        %
                        DTB__hvsr__curve{ii,1} = loaded.iDTB__hvsr__curve;
                                %DTB{s,1}.hvsr.error = [];
                        DTB__hvsr__confidence95{ii,1} = loaded.iDTB__hvsr__confidence95; 
                        DTB__hvsr__standard_deviation{ii,1} = loaded.iDTB__hvsr__standard_deviation; 
                        DTB__hvsr__curve_EV{ii,1} = loaded.iDTB__hvsr__curve_EV;
                        DTB__hvsr__curve_NV{ii,1} = loaded.iDTB__hvsr__curve_NV; 
                        %
                        DTB__hvsr__peaks_idx{ii,1} = loaded.iDTB__hvsr__peaks_idx; 
                        DTB__hvsr__hollows_idx{ii,1} = loaded.iDTB__hvsr__hollows_idx; 
                        if isfield(loaded,'iDTB__hvsr__user_additional_peaks'); DTB__hvsr__user_additional_peaks{ii,1} = loaded.iDTB__hvsr__user_additional_peaks; end
                       %                       iDTB__hvsr__user_additional_peaks
                        DTB__hvsr__user_main_peak_frequence(ii,1) = loaded.iDTB__hvsr__user_main_peak_frequence; 
                        DTB__hvsr__user_main_peak_amplitude(ii,1) = loaded.iDTB__hvsr__user_main_peak_amplitude; 
                        DTB__hvsr__user_main_peak_id_full_curve(ii,1) = loaded.iDTB__hvsr__user_main_peak_id_full_curve; 
                        DTB__hvsr__user_main_peak_id_in_section(ii,1) = loaded.iDTB__hvsr__user_main_peak_id_in_section; 
                        DTB__hvsr__auto_main_peak_frequence(ii,1) = loaded.iDTB__hvsr__auto_main_peak_frequence;
                        DTB__hvsr__auto_main_peak_amplitude(ii,1) = loaded.iDTB__hvsr__auto_main_peak_amplitude; 
                        DTB__hvsr__auto_main_peak_id_full_curve(ii,1) = loaded.iDTB__hvsr__auto_main_peak_id_full_curve; 
                        DTB__hvsr__auto_main_peak_id_in_section(ii,1) = loaded.iDTB__hvsr__auto_main_peak_id_in_section; 
                        %
                        %%   i = DTB__hvsr180
                        DTB__hvsr180__angle_id(ii,1) = loaded.iDTB__hvsr180__angle_id;
                        DTB__hvsr180__angles{ii,1} = loaded.iDTB__hvsr180__angles;
                        DTB__hvsr180__angle_step(ii,1) = loaded.iDTB__hvsr180__angle_step; 
                        DTB__hvsr180__spectralratio{ii,1} = loaded.iDTB__hvsr180__spectralratio; 
                        DTB__hvsr180__preferred_direction{ii,1} = loaded.iDTB__hvsr180__preferred_direction; 
                        %%   i = DTB__well
                        DTB__well__well_id(ii,1) = loaded.iDTB__well__well_id;
                        DTB__well__well_name{ii,1} = loaded.iDTB__well__well_name; 
                        DTB__well__bedrock_depth__KNOWN{ii,1} = loaded.iDTB__well__bedrock_depth__KNOWN;
                        DTB__well__bedrock_depth_source{ii,1} = loaded.iDTB__well__bedrock_depth_source;
                        DTB__well__bedrock_depth__COMPUTED{ii,1} = loaded.iDTB__well__bedrock_depth__COMPUTED; 
                        DTB__well__bedrock_depth__IBS1999{ii,1} = loaded.iDTB__well__bedrock_depth__IBS1999;
                        DTB__well__bedrock_depth__PAROLAI2002{ii,1} = loaded.iDTB__well__bedrock_depth__PAROLAI2002;
                        DTB__well__bedrock_depth__HINZEN2004{ii,1} = loaded.iDTB__well__bedrock_depth__HINZEN2004;
                        %% Database =====================END
                       fprintf('..OK\n')
                       clear loaded
                    end  
                end
            else%                                      load V1.0.0 - V1.0.1  set of files
                %fprintf('[archive version:1 (From V1.0.0 - V1.0.1)]\n')
                for ii=1:NN
                   fprintf('Loading measure %d/%d',ii,NN) 
                   datname = strcat(thispath,name,'_database_',num2str(ii),'of',sNN,'.mat');
                   loaded = load(datname);
                   
                 %%   DTB__status
                    DTB__status(ii,1) = loaded.databas.status;                                            
                    if isfield(loaded.databas,'alaboration_progress'); DTB__elaboration_progress(ii,1) = loaded.databas.alaboration_progress; end
                 %%   DTB__windows
                    if isfield(loaded.databas,'wndows.width_sec'); DTB__windows__width_sec(ii,1) = loaded.databas.wndows.width_sec; end          
                    DTB__windows__number(ii,1) = loaded.databas.wndows.number;
                    DTB__windows__number_fft(ii,1) = loaded.databas.wndows.number_fft; 
                    DTB__windows__indexes{ii,1} = loaded.databas.wndows.indexes; 
                    DTB__windows__is_ok{ii,1} = loaded.databas.wndows.is_ok; 
                    DTB__windows__winv{ii,1} = loaded.databas.wndows.winv;                 
                    DTB__windows__wine{ii,1} = loaded.databas.wndows.wine; 
                    DTB__windows__winn{ii,1} = loaded.databas.wndows.winn; 
                    DTB__windows__fftv{ii,1} = loaded.databas.wndows.fftv; 
                    DTB__windows__ffte{ii,1} = loaded.databas.wndows.ffte; 
                    DTB__windows__fftn{ii,1} = loaded.databas.wndows.fftn; 
                    DTB__windows__info(ii,:) = loaded.databas.wndows.info;                   
                    %%  DTB__elab_parameters        
                    DTB__elab_parameters__status{ii,1} = loaded.databas.elab_parameters.status; 
                    DTB__elab_parameters__hvsr_strategy(ii,1) = loaded.databas.elab_parameters.hvsr_strategy; 
                    DTB__elab_parameters__hvsr_freq_min(ii,1) =  loaded.databas.elab_parameters.hvsr_freq_min; 
                    DTB__elab_parameters__hvsr_freq_max(ii,1) = loaded.databas.elab_parameters.hvsr_freq_max; 
                    DTB__elab_parameters__windows_width(ii,1) = loaded.databas.elab_parameters.windows_width; 
                    DTB__elab_parameters__windows_overlap(ii,1) = loaded.databas.elab_parameters.windows_overlap; 
                    DTB__elab_parameters__windows_tapering(ii,1) = loaded.databas.elab_parameters.windows_tapering; 
                    DTB__elab_parameters__windows_sta_vs_lta(ii,1) = loaded.databas.elab_parameters.windows_sta_vs_lta; 
                    DTB__elab_parameters__windows_pad{ii,1} = loaded.databas.elab_parameters.windows_pad; 
                    DTB__elab_parameters__smoothing_strategy(ii,1) = loaded.databas.elab_parameters.smoothing_strategy; 
                    DTB__elab_parameters__smoothing_slider_val(ii,1) = loaded.databas.elab_parameters.smoothing_slider_val; 
                            %
                            % filter
                    DTB__elab_parameters__filter_id(ii,1) = loaded.databas.elab_parameters.filter_id;
                    DTB__elab_parameters__filter_name{ii,1} = loaded.databas.elab_parameters.filter_name;
                    DTB__elab_parameters__filter_order(ii,1) = loaded.databas.elab_parameters.filter_order; 
                    DTB__elab_parameters__filterFc1(ii,1) = loaded.databas.elab_parameters.filterFc1;
                    DTB__elab_parameters__filterFc2(ii,1) = loaded.databas.elab_parameters.filterFc2; 
                    DTB__elab_parameters__data_to_use(ii,1) = loaded.databas.elab_parameters.data_to_use; 
                    if isfield(loaded.databas,'elab_parameters.THEfilter'); DTB__elab_parameters__THEfilter{ii,1} =loaded.databas.elab_parameters.THEfilter; end
                    %%  DTB__section
                    DTB__section__Min_Freq(ii,1) = loaded.databas.section.Min_Freq;
                    DTB__section__Max_Freq(ii,1) = loaded.databas.section.Max_Freq; 
                    DTB__section__Frequency_Vector{ii,1} = loaded.databas.section.Frequency_Vector;
                            %
                    DTB__section__V_windows{ii,1} = loaded.databas.section.V_windows;
                    DTB__section__E_windows{ii,1} = loaded.databas.section.E_windows; 
                    DTB__section__N_windows{ii,1} = loaded.databas.section.N_windows; 
                            %
                    DTB__section__Average_V{ii,1} = loaded.databas.section.Average_V; 
                    DTB__section__Average_E{ii,1} = loaded.databas.section.Average_E; 
                    DTB__section__Average_N{ii,1} = loaded.databas.section.Average_N; 
                            %
                    DTB__section__HV_windows{ii,1} = loaded.databas.section.HV_windows; 
                    DTB__section__EV_windows{ii,1} = loaded.databas.section.EV_windows;
                    DTB__section__NV_windows{ii,1} = loaded.databas.section.NV_windows; 
                    %%  DTB__hvsr
                    DTB__hvsr__curve_full{ii,1} = loaded.databas.hvsr.curve_full;
                    %DTB{s,1}.hvsr.error_full = [];
                    DTB__hvsr__confidence95_full{ii,1} = loaded.databas.hvsr.confidence95_full; 
                    DTB__hvsr__curve_EV_full{ii,1} = loaded.databas.hvsr.curve_EV_full;
                    DTB__hvsr__curve_NV_full{ii,1} = loaded.databas.hvsr.curve_NV_full; 
                    %
                    DTB__hvsr__EV_all_windows{ii,1} = loaded.databas.hvsr.EV_all_windows; 
                    DTB__hvsr__NV_all_windows{ii,1} = loaded.databas.hvsr.NV_all_windows; 
                    DTB__hvsr__HV_all_windows{ii,1} = loaded.databas.hvsr.HV_all_windows; 
                    %
                    DTB__hvsr__curve{ii,1} = loaded.databas.hvsr.curve;
                            %DTB{s,1}.hvsr.error = [];
                    DTB__hvsr__confidence95{ii,1} = loaded.databas.hvsr.confidence95; 
                    DTB__hvsr__standard_deviation{ii,1} = loaded.databas.hvsr.standard_deviation; 
                    DTB__hvsr__curve_EV{ii,1} = loaded.databas.hvsr.curve_EV;
                    DTB__hvsr__curve_NV{ii,1} = loaded.databas.hvsr.curve_NV; 
                            %
                    DTB__hvsr__peaks_idx{ii,1} = loaded.databas.hvsr.peaks_idx; 
                    DTB__hvsr__hollows_idx{ii,1} = loaded.databas.hvsr.hollows_idx; 
                            %DTB{s,1}.hvsr.main_peak_id = [];  %index of main peak (in the selected freq. range)
                            % hvsr peaks (authomatic/user)
                    DTB__hvsr__user_main_peak_frequence(ii,1) = loaded.databas.hvsr.user_main_peak_frequence; 
                    DTB__hvsr__user_main_peak_amplitude(ii,1) = loaded.databas.hvsr.user_main_peak_amplitude; 
                    %% 
                    if isfield(loaded.databas.hvsr,'user_main_peak_id_full_curve') 
                        if ~isnan(loaded.databas.hvsr.user_main_peak_id_full_curve)
                            DTB__hvsr__user_main_peak_id_full_curve(ii,1) = loaded.databas.hvsr.user_main_peak_id_full_curve; 
                        end
                    end
                    if isfield(loaded.databas.hvsr.hvsr,'user_main_peak_id_full_curve') 
                        if ~isnan(loaded.databas.hvsr.hvsr.user_main_peak_id_full_curve)
                            DTB__hvsr__user_main_peak_id_full_curve(ii,1) = loaded.databas.hvsr.hvsr.user_main_peak_id_full_curve; 
                        end
                    end
                    
                    if isfield(loaded.databas.hvsr,'user_main_peak_id_in_section')
                        if ~isnan(loaded.databas.hvsr.user_main_peak_id_in_section)
                            DTB__hvsr__user_main_peak_id_in_section(ii,1) = loaded.databas.hvsr.user_main_peak_id_in_section;
                        end
                    end
                    if isfield(loaded.databas.hvsr.hvsr,'user_main_peak_id_in_section')
                        if ~isnan(loaded.databas.hvsr.hvsr.user_main_peak_id_in_section)
                            DTB__hvsr__user_main_peak_id_in_section(ii,1) = loaded.databas.hvsr.hvsr.user_main_peak_id_in_section;
                        end
                    end
                    
                    %%
                    DTB__hvsr__auto_main_peak_frequence(ii,1) = loaded.databas.hvsr.auto_main_peak_frequence;
                    DTB__hvsr__auto_main_peak_amplitude(ii,1) = loaded.databas.hvsr.auto_main_peak_amplitude; 
                    DTB__hvsr__auto_main_peak_id_full_curve(ii,1) = loaded.databas.hvsr.auto_main_peak_id_full_curve; 
                    DTB__hvsr__auto_main_peak_id_in_section(ii,1) = loaded.databas.hvsr.auto_main_peak_id_in_section; 
                    %
                    %%  DTB__hvsr180
                    DTB__hvsr180__angle_id(ii,1) = loaded.databas.hvsr180.angle_id;
                    DTB__hvsr180__angles{ii,1} = loaded.databas.hvsr180.angles;
                    DTB__hvsr180__angle_step(ii,1) = loaded.databas.hvsr180.angle_step; 
                    DTB__hvsr180__spectralratio{ii,1} = loaded.databas.hvsr180.spectralratio; 
                    DTB__hvsr180__preferred_direction{ii,1} = loaded.databas.hvsr180.preferred_direction; 
                    %%  DTB__well
                    DTB__well__well_id(ii,1) = loaded.databas.well.well_id;
                    DTB__well__well_name{ii,1} = loaded.databas.well.well_name; 
                    DTB__well__bedrock_depth__KNOWN{ii,1} = loaded.databas.well.bedrock_depth__KNOWN;
                    DTB__well__bedrock_depth_source{ii,1} = loaded.databas.well.bedrock_depth_source;
                    DTB__well__bedrock_depth__COMPUTED{ii,1} = loaded.databas.well.bedrock_depth__COMPUTED; 
                    DTB__well__bedrock_depth__IBS1999{ii,1} = loaded.databas.well.bedrock_depth__IBS1999;
                    DTB__well__bedrock_depth__PAROLAI2002{ii,1} = loaded.databas.well.bedrock_depth__PAROLAI2002;
                    DTB__well__bedrock_depth__HINZEN2004{ii,1} = loaded.databas.well.bedrock_depth__HINZEN2004;
                    %% Database =====================END
                   
                   
                   fprintf('..OK\n')
                   clear loaded
                end
            end
            
            if isempty(DDAT)
                clc
                fprintf('======================================\n')
                fprintf('ERROR: Variable DDAT is empty.\n')
                fprintf('You are attempting to load an elaboration which was uncorrectly saved.\n')
                fprintf('Do not worry, your work can easily be recovered following the steps below.\n')
                fprintf('   Let''s assume that the failing file you are loading is named MyElaboration_MAIN.mat\n')
                fprintf('   located in ../../MyFolder\n')
                fprintf('\n')
                fprintf('  A) Verify you are using OpenHVSR Processing Toolkit version 2.1.0 or higher\n')
                fprintf('  B) create a backup copy of ../../MyFolder  (recommended)\n')
                fprintf(' \n')
                fprintf('  1) delete the file MyElaboration_MAIN.mat\n')
                fprintf('  2) load the project file (menu: Files->Load Project)\n')
                fprintf('     originally used to create the elaboration\n')
                fprintf('  3) save an empty elaboration (menu: Files->Save Elaboration)\n')
                fprintf('     into a new folder. Say ../../MyRecover\n')
                fprintf('     note: it must be saved with the same name of the elaboration we desire to recover\n')
                fprintf('           i.e. save as: MyElaboration.mat\n')
                fprintf('  4) copy all files containing "database" in their name, from  MyFolder to MyRecover\n')
                fprintf('     If correct, the database files present in MyRecover will be overwritten\n')
                fprintf(' \n')
                fprintf('If these guidelines are not sufficient, please do not hesitate to contact me\n')
                fprintf('at the following email: sedysen@gmail.com\n')
                fprintf(' \n')
                error('For safety, the program is terminated at this point and will need restart.\n')
                close(H.gui);%#ok
                return
            end
            fprintf('[Elaboration loaded correctly]\n')
            %% ========================================================================
            %% Update Interface
            P.isshown.id= 1;
            P.isshown.accepted_windows = DTB__windows__is_ok{P.isshown.id,1};
            %
            Update_survey_locations(hAx_main_geo);
            Update_survey_locations(hAx_geo1);
            Update_survey_locations(hAx_geo2);
            Update_survey_locations(hAx_geo3);
            Graphic_Gui_update_elaboration_parameters();
            Graphic_update_data(0);
            Graphic_update_spectrums(0);
            %% Disable useless
            if isempty(TOPOGRAPHY)
                set(h_contour_extra_points,  'Value',1,'Enable','off');% on tab 4
                set(h_bedrock_extra_points3d,'Value',1,'Enable','off');% on tab 5
            else
                set(h_contour_extra_points,  'Enable','on');% on tab 4
                set(h_bedrock_extra_points3d,'Enable','on');% on tab 5
            end           
            %%
            fprintf('[Ready!]\n')
            is_done();
        end
    end
%%      Settings
    function Menu_Settings_use_compass_mode_Callback(hObject,~,~)
        val = get(hObject,'Checked');
        if strcmp(val,'off')
            set(hObject,'Checked','on');
            USER_PREFERENCE_hvsr_directional_reference_system= 'compass';
        end
        if strcmp(val,'on')
            set(hObject,'Checked','off');
            USER_PREFERENCE_hvsr_directional_reference_system= '';
        end
    end
%%      View
%%          profile smoothing
    function Menu_profile_smoothing_strategy0_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.smoothing_strategy = 0; spunta(H.menu.view2d_Profile_smoothing_childs, P.profile.smoothing_strategy);
        Graphics_plot_2d_profile(0);
    end
    function Menu_profile_smoothing_strategy1_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.smoothing_strategy = 1;
        set_smoothing_radius();
        spunta(H.menu.view2d_Profile_smoothing_childs, P.profile.smoothing_strategy);
    end
    function Menu_profile_smoothing_strategy2_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.smoothing_strategy = 2;
        set_smoothing_radius();
        spunta(H.menu.view2d_Profile_smoothing_childs, P.profile.smoothing_strategy);
    end
    function Menu_profile_smoothing_strategy3_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.smoothing_strategy = 3;
        set_smoothing_radius();
        spunta(H.menu.view2d_Profile_smoothing_childs, P.profile.smoothing_strategy);
    end
    function set_smoothing_radius()
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        prompt = {'Smoothing Radius (0 = off)'};
        def = {num2str(P.profile.smoothing_radius)};
        answer = inputdlg(prompt,'Smoothing',1,def);
        P.profile.smoothing_radius = str2double(answer{1});
        Graphics_plot_2d_profile(0);
    end
%%          profile normalization
    function Menu_profile_normalization_strategy0_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.normalization_strategy = 0; 
        spunta(H.menu.view2d_Profile_normalization_childs, P.profile.normalization_strategy);
        Graphics_plot_2d_profile(0);
    end
    function Menu_profile_normalization_strategy1_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.normalization_strategy = 1;
        spunta(H.menu.view2d_Profile_normalization_childs, P.profile.normalization_strategy);
        Graphics_plot_2d_profile(0);
    end
    function Menu_profile_normalization_strategy2_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.normalization_strategy = 2;
        spunta(H.menu.view2d_Profile_normalization_childs, P.profile.normalization_strategy);
        Graphics_plot_2d_profile(0);
    end
    function Menu_profile_normalization_strategy3_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        P.profile.normalization_strategy = 3;
        spunta(H.menu.view2d_Profile_normalization_childs, P.profile.normalization_strategy);
        Graphics_plot_2d_profile(0);
    end
%%          profile discretization 
    function Menu_profile_discretization_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        prompt = {'Choose X-discretization'};
        def = {num2str( P.profile.N_X_points )};
        answer = inputdlg(prompt,'Set N of points',1,def);
        if(~isempty(answer))
            Npt = str2double(answer{1});
            Ncc = size( P.profile_ids{P.profile.id}, 1);
            if Npt < 2*Ncc
                Npt = 2*Ncc;
                warning('SAM: Number of points too low. Automatically corrected')
            end
            P.profile.N_X_points = Npt;
        end
        Graphics_plot_2d_profile(0);
    end
%%          prifile color limits
    function Menu_profile_ColorLimits_Callback(~,~,~)
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        prompt = {'Choose Color Limits',''};
        def = {num2str(P.profile.color_limits(1)), num2str(P.profile.color_limits(2))};
        answer = inputdlg(prompt,'Set color limits',1,def);
        if(~isempty(answer))
            A = str2double(answer{1});
            B = str2double(answer{2});
            if A<B
                P.profile.color_limits(1) = A;
                P.profile.color_limits(2) = B;
                caxis(hAx_2DViews, P.profile.color_limits);
            else
                warning('SAM: Profile: color limits chosen uncorrectly (not updated)')
            end
        end
       
    end
%%          colormap
    function Menu_view_cmap_Jet(~,~,~)
        P.colormapis = 'Jet';
        Update_Colormap()
    end
    function Menu_view_cmap_Hot(~,~,~)
        P.colormapis = 'Hot';
        Update_Colormap()
    end
    function Menu_view_cmap_Bone(~,~,~)
        P.colormapis = 'Bone';
        Update_Colormap();
    end    
    function Menu_view_cmap_Copper(~,~,~)
            P.colormapis = 'Copper';
            Update_Colormap();
    end
    function Menu_view_cmap_Parula(~,~,~)
            P.colormapis = 'Parula';
            Update_Colormap();
    end
    function Update_Colormap()
        colormap(hAx_speV, P.colormapis);
        colormap(hAx_speE, P.colormapis);
        colormap(hAx_speN, P.colormapis);
        colormap(hAx_2DViews, P.colormapis);
        colormap(hAx_3DViews, P.colormapis);
        drawnow
    end
%%          proportions
    function CB_GUI_MENU_change_proportions(~,~,mode)
        switch mode
            case 'Main'; vals =P.data_aspectis_main;      dof=2; prompt = {'X','Y'};
            case 'Map';  vals =P.data_aspectis_aerialmap; dof=2; prompt = {'X','Y'};
            case 'Prof'; vals =P.data_aspectis_profile;   dof=2; prompt = {'X','Z'};
            case 'Ibs';  vals =P.data_aspectis_IVSeW;     dof=3; prompt = {'X','Y','Z'};
            otherwise
                vals = [1, 1, 1];
        end
        if dof==2
            titlestr = 'Data aspect ratio: [daspect]';
            if ~isempty(vals)
                def = {num2str(vals(1)), num2str(vals(2)), num2str(vals(3))};
            else
                def = {'1','1','1'};
            end
            answer = inputdlg(prompt,titlestr,1,def);
        end
        if dof==3
            prompt = {'X','Y','Z'};
            titlestr = 'Data aspect ratio: [daspect]';
            if ~isempty(vals)
                def = {num2str(vals(1)), num2str(vals(2)), num2str(vals(3))};
            else
                def = {'1','1','1'};
            end
            answer = inputdlg(prompt,titlestr,1,def);
            
        end
        if(~isempty(answer)) 
            switch dof
                case 2; vec = [str2double(answer{1}), str2double(answer{2}), 1];
                case 3; vec = [str2double(answer{1}), str2double(answer{2}), str2double(answer{3})];
            end
            switch mode
                case 'Main'; P.data_aspectis_main = vec;
                case 'Map';  P.data_aspectis_aerialmap     = vec;
                case 'Prof'; P.data_aspectis_profile = vec;
                case 'Ibs';  P.data_aspectis_IVSeW   = vec;
            end
        end
    end
%%      About
    function Menu_About_Credits(~,~,~)
        msgbox(get(H.menu.credits,'UserData'),'CREDITS:')
    end
%% TAB-1 CALLBACKS ============= main
%% TAB-1, Panel Aplots_3D_update();
    function CB_hAx_geo_back(~,~,~)
        if isempty(SURVEYS); return; end
        if P.isshown.id ==0; return; end
        %
        %
        Ndat = size(SURVEYS,1);
        val = P.isshown.id;
        switch(P.isshown.id)
            case 0; val = Ndat;
            case 1; val = Ndat;
            otherwise; val = val -1;
        end
        P.isshown.id= val;
        P.isshown.accepted_windows = DTB__windows__is_ok{P.isshown.id,1};
        Graphic_Gui_update_elaboration_parameters();
        Update_survey_locations(hAx_main_geo);
        Update_survey_locations(hAx_geo1);
        Update_survey_locations(hAx_geo2);
        Update_survey_locations(hAx_geo3);
        Graphic_update_data(0);
        Graphic_update_spectrums(0);
        P.profile.id=0;% back to general visualization mode
    end
    function CB_hAx_geo_next(~,~,~)
        if isempty(SURVEYS); return; end
        if P.isshown.id ==0; return; end
        %
        %
        Ndat = size(SURVEYS,1);
        val = P.isshown.id;
        switch(P.isshown.id)
            case 0; val = 1;
            case Ndat; val = 1;
            otherwise; val = val +1;
        end
        P.isshown.id= val;
        P.isshown.accepted_windows = DTB__windows__is_ok{P.isshown.id,1};
        Graphic_Gui_update_elaboration_parameters();
        Update_survey_locations(hAx_main_geo);
        Update_survey_locations(hAx_geo1);
        Update_survey_locations(hAx_geo2);
        Update_survey_locations(hAx_geo3);
        Graphic_update_data(0);
        Graphic_update_spectrums(0);
        P.profile.id=0;% back to general visualization mode
    end
    function CB_hAx_geo_goto(~,~,~)
        if isempty(SURVEYS); return; end
        if P.isshown.id ==0; return; end
        %
        %
        Ndat = size(SURVEYS,1);
        prompt = {'Select Measurement ID'};
        def = {'0'};
        answer = inputdlg(prompt,'Unite with next',1,def);
        if(~isempty(answer))
            val = str2double(answer{1});
            if 0<val && val<=Ndat
                P.isshown.id= val;
                P.isshown.accepted_windows = DTB__windows__is_ok{P.isshown.id,1};
                Graphic_Gui_update_elaboration_parameters();
                Update_survey_locations(hAx_main_geo);
                Update_survey_locations(hAx_geo1);
                Update_survey_locations(hAx_geo2);
                Update_survey_locations(hAx_geo3);
                Graphic_update_data(0);
                Graphic_update_spectrums(0);
            end
        end
        P.profile.id=0;% back to general visualization mode
    end
    function CB_hAx_well_back(~,~,~)
        Nwll= size(WELLS,1);
        if(Nwll>0)
            val = well_to_show;
            switch(well_to_show)
                case 0; val = Nwll;
                case 1; val = Nwll;
                otherwise; val = val -1;
            end
            well_to_show = val;
            %
            Update_survey_locations(hAx_main_geo);
            Update_survey_locations(hAx_geo1);
            Update_survey_locations(hAx_geo2);
            Update_survey_locations(hAx_geo3);
        end
    end
    function CM_hAx_well_next(~,~,~)
        Nwll= size(WELLS,1);
        if(Nwll>0)
            val = well_to_show;
            switch(well_to_show)
                case 0; val = 1;
                case Nwll; val = 1;
                otherwise; val = val +1;
            end
            well_to_show = val;
            %
            Update_survey_locations(hAx_main_geo);
            Update_survey_locations(hAx_geo1);
            Update_survey_locations(hAx_geo2);
            Update_survey_locations(hAx_geo3);
        end
    end
    function CB_hAx_show_profile_back(~,~,~)
        if ~isempty(P.profile_ids)
            Ndat = size(P.profile_ids,1);
            val = P.profile.id;
            switch(P.profile.id)
                case 0; val = Ndat;
                case 1; val = Ndat;
                otherwise; val = val -1;
            end
            P.profile.id = val;
            Update_profile_locations(hAx_main_geo);
        else
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
    end
    function CB_hAx_show_profile_next(~,~,~)
        if ~isempty(P.profile_ids)
            Ndat = size(P.profile_ids,1);
            val = P.profile.id;
            switch(P.profile.id)
                case 0; val = 1;
                case Ndat; val = 1;
                otherwise; val = val +1;
            end
            P.profile.id = val;
            Update_profile_locations(hAx_main_geo);
        else
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
    end
    %
    function CB_hAx_profile_addrec(~,~,~)
        if P.profile.id==0; return; end
        if ~isempty(P.profile_ids)
            Ndat = size(SURVEYS,1);
            prompt = {'Select id'};
            def = {'0'};
            answer = inputdlg(prompt,'Add receiver',1,def);
            ispresent = 0;
            if(~isempty(answer))
                val = str2double(answer{1});
                if 1<=val && val<= Ndat
                    for ii=1:size(P.profile_ids{P.profile.id,1},1)
                        if val==P.profile_ids{P.profile.id,1}(ii,1)
                            ispresent=1;
                        end
                    end
                    if ispresent==0% add the point
                        additional = [];
                        xx    = P.profile_line{P.profile.id,1}(:,1);
                        yy    = P.profile_line{P.profile.id,1}(:,2);
                        recta_kind = 0;
                        if(xx(1)==xx(2)) % rect x=constant
                            recta_kind = 1;
                            dr = receiver_locations(val,2)-yy(1);
                            far = abs(receiver_locations(val,1)-xx(1));
                            additional = [val, dr, far];
                        end
                        if(yy(1)==yy(2)) % rect y=constant
                                recta_kind = 2;
                                dr = receiver_locations(val,1)-xx(1);
                                far = abs(receiver_locations(val,2)-yy(1));
                                additional = [val, dr, far];
                        end
                        if(recta_kind==0) % rect y=mx+q    q=y-mx
                            m1 = (yy(2)-yy(1))/(xx(2)-xx(1));
                            q1 = yy(1) - m1*xx(1);
                            dist = abs(receiver_locations(val,2) - (m1*receiver_locations(val,1) +q1))/sqrt(1+m1^2);% Equation 1
                            %% info
                            % r1:  y = m1 x + q1 (profile)
                            % r2:  y = m2 x + q2 (line through the receiver and perpendicular to r1)
                            %
                            % rect given endpoints
                            % r1 = m1 x + q1:    (ax +by +c = 0)
                            %     a = y2-y1
                            %     b = x2-x1
                            %     c = x2 y1 - y2 x1
                            %     m1 = -a/b = -(y2-y1)/(x2-x1) 
                            %     q1  = y1 -m1 x1
                            %
                            % distance of point p (receiver) from the rect r1 (the profile). (Equation 1)
                            % dist = |yp - m1 xp -q1 | / sqrt(1 + m1^1)
                            %
                            % rect (r2) through a point p and perpendicular to r1 (y=m1 x +q1):
                            % y = m2 xp + q2
                            % m2  = -1/m1
                            % q2 = yp - m2 xp == yp +xp/m1  (Equation 2)
                            %
                            % point of intersection of two rects
                            % [ y = m2 x + q2
                            % [ y = m1 x + q1
                            %
                            % [ y = m2 x + q2
                            % [ m2 x + q2 = m1 x + q1 -> x(m2-m1) = (q1-q2)
                            %
                            % [ y = m2 (q1-q2)/(m2-m1)+ q2
                            % [ x = (q1-q2)/(m2-m1) 
                            %%
                            m2 = -1/m1;
                            q2 = receiver_locations(val,2) + receiver_locations(val,1)/m1;%  (Equation 2)  
                            xp = (q1-q2)/(m2-m1);%             Point of intersection
                            yp = m2*(q1-q2)/(m2-m1)+q2;% Point of intersection 
                            drs= sqrt( (xx(1)-xp).^2 + (yy(1)-yp).^2 );% distances from beginning of profile
                            %
                            far = dist;
                            dr  = drs;
                            if(xp < xx)
                                dr = -dr;
                            end
                            % val = station-ID
                            % dr  = distance (along profile) from profile beginning
                            % far = distance from profile
                            additional = [val, dr, far];
                        end
                        %
                        % check for double entries (same longitudinal distance, to be avoided)     
                        if isempty(additional); return; end
                        [r,~]= find(P.profile_ids{P.profile.id,1}(:,2)==additional (2));
                        if ~isempty(r) 
                            Message = sprintf('COULD NOT ADD STATION TO THE PROFILE\nOnce projected, the selected station overlaps with station no. %d.',P.profile_ids{P.profile.id,1}( r(1), 1)   );
                            msgbox(Message,'INFO')
                            return; 
                        end
                        % if everything is Ok
                        P.profile_ids{P.profile.id,1} = [P.profile_ids{P.profile.id,1};  additional];
                        P.profile_onoff{P.profile.id,1}(val) = 1;
                        %
                        dummy = P.profile_ids{P.profile.id,1};
                        [~,idx] = sort(dummy(:,2)); % sort just the first column
                        sortedmat = dummy(idx,:);   % sort the whole matrix using the sort indices
                        P.profile_ids{P.profile.id,1}   = sortedmat;
                        %
                        set(h_shown_prof,'String',['prof. ',num2str(P.profile.id)])
                    end
                end
            end
            Update_profile_locations(hAx_main_geo);
            is_done();
        else
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
    end
    function CB_hAx_profile_remrec(~,~,~)
        if P.profile.id==0; return; end
        if ~isempty(P.profile_ids)
            Ndat = size(SURVEYS,1);
            prompt = {'Select id'};
            def = {'0'};
            answer = inputdlg(prompt,'Remove receiver',1,def);
            Nr = size(P.profile_ids{P.profile.id,1},1);
            Nn = 0;
            if(~isempty(answer))
                val = str2double(answer{1});
                if 1<=val && val<= Ndat
                    dummy_ids = 0*P.profile_ids{P.profile.id,1};
                    for ii = 1:Nr
                        if val~=P.profile_ids{P.profile.id,1}(ii,1)
                            Nn=Nn+1;
                            dummy_ids(Nn,:) = P.profile_ids{P.profile.id,1}(ii,:);
                        end
                    end
                    if Nn~=Nr% something changed
                        if Nn>1% two point (at least) must be present
                            dummy_ids = dummy_ids(1:Nn,:);
                            P.profile_ids{P.profile.id,1}   = dummy_ids;
                            % P.profile_line  > no update;
                            P.profile_onoff{P.profile.id,1}(val) = 0;
                            %
                            set(h_shown_prof,'String',['prof. ',num2str(P.profile.id)])
                        else
                            fprintf('MESSAGE: Profile cannot comprise less than 2 stations.\n')
                            fprintf('         Action was not performed,\n')
                            fprintf('         station was not removed,\n')
                            fprintf('         profile %d is unchanged.\n',P.profile.id)
                        end
                    end
                end
            end
            Update_profile_locations(hAx_main_geo);
            is_done();
        else
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
    end
    %
    function CB_set_status(~,~,~)
        if P.isshown.id
            switch DTB__status(P.isshown.id,1)
                case 1% if in progress, set done
                    DTB__status(P.isshown.id,1) = 0;
                    set(T1_PA_id     ,'BackgroundColor','g')
                    set(T1_PA_FileID ,'BackgroundColor','g')
                    set(T1_PA_status0,'BackgroundColor','g')
                    set(T1_PA_status ,'BackgroundColor','g')
                    %
                    set(T1_PA_status ,'String','Locked')
                case 0% if done, set excluded
                    DTB__status(P.isshown.id,1) = 2;
                    set(T1_PA_id     ,'BackgroundColor','r')
                    set(T1_PA_FileID ,'BackgroundColor','r')
                    set(T1_PA_status0,'BackgroundColor','r')
                    set(T1_PA_status ,'BackgroundColor','r')
                    %
                    set(T1_PA_status ,'String','Excluded')
                case 2% if excluded set unlocked
                    DTB__status(P.isshown.id,1) = 1;
                    set(T1_PA_id     ,'BackgroundColor',Status_bkground_color)
                    set(T1_PA_FileID ,'BackgroundColor',Status_bkground_color)
                    set(T1_PA_status0,'BackgroundColor',Status_bkground_color)
                    set(T1_PA_status ,'BackgroundColor',Status_bkground_color)
                    %
                    set(T1_PA_status ,'String','Unlocked')
            end
            % Propagate color
            switch(DTB__status(P.isshown.id,1))
                case 0
                    set(T2_PB_datafile_txt,'BackgroundColor','g');
                    set(T3_PB_datafile_txt,'BackgroundColor','g');
                    set(T6_PB_datafile_txt,'BackgroundColor','g');
                case 2
                    set(T2_PB_datafile_txt,'BackgroundColor','r');
                    set(T3_PB_datafile_txt,'BackgroundColor','r');
                    set(T6_PB_datafile_txt,'BackgroundColor','r');
                case 1
                    set(T2_PB_datafile_txt,'BackgroundColor',Status_bkground_color);
                    set(T3_PB_datafile_txt,'BackgroundColor',Status_bkground_color);
                    set(T6_PB_datafile_txt,'BackgroundColor',Status_bkground_color);
            end
        end
    end
%% TAB-2: ===================== fenestration
%% TAB-2, Panel-A
    function CB_swich_dat_to_show(~,~,~)
        Graphic_update_data(0);
    end
%% TAB-2, Panel-B
%% TAB-2, Panel-C
    function CM_data_delete_win(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__status(P.isshown.id,1)==1
            [xmi,xma] = getxrange();% sec
            
            dt = 1/sampling_frequences(P.isshown.id);
            n_of_windows = DTB__windows__number(P.isshown.id,1);
            for w = 1:n_of_windows
                ta = dt*( DTB__windows__indexes{P.isshown.id,1}(w,1) -1);
                tb = dt*(DTB__windows__indexes{P.isshown.id,1}(w,2) -1);
                if ( (xmi<ta) && (tb<xma) ) || ( (ta<xmi) && (xma<tb) )
                    %P.isshown.accepted_windows
                    DTB__windows__is_ok{P.isshown.id,1}(w)=0;
                end
            end
            Graphic_update_data(0);
            Graphic_update_spectrums(0);
        end
    end
    function CM_data_resume_win(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__status(P.isshown.id,1)==1
            [xmi,xma] = getxrange();% sec
            
            dt = 1/sampling_frequences(P.isshown.id);
            n_of_windows = DTB__windows__number(P.isshown.id,1);
            for w = 1:n_of_windows
                ta = dt*(DTB__windows__indexes{P.isshown.id,1}(w,1) -1);
                tb = dt*(DTB__windows__indexes{P.isshown.id,1}(w,2) -1);
                if ( (xmi<ta) && (tb<xma) ) || ( (ta<xmi) && (xma<tb) )
                    DTB__windows__is_ok{P.isshown.id,1}(w)=1;
                end
            end
            Graphic_update_data(0);
            Graphic_update_spectrums(0);
        end
    end
    %
    function CM_data_SetrangeHax(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        ii = P.isshown.id;
        dt = 1/sampling_frequences(ii);
        Tmin=0;
        Tmax = dt*( length(DDAT{P.isshown.id,1})-1 );
        P.TAB_Windowing.hori_axis_limits__time = Get_Range_Callback(Tmin,Tmax,'Time Range');       
        Graphic_update_data(0);
    end
    function CM_data_resetHax(~,~,~)
        P.TAB_Windowing.hori_axis_limits__time = [];
        Graphic_update_data(0);
    end
    %
    %
    function CM_spectrum_delete_win(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__status(P.isshown.id,1)==1
            [xmi,xma] = getxrange();% sec
            n_of_windows = DTB__windows__number(P.isshown.id,1);
            for w = 1:n_of_windows
                ta = w-0.5;
                tb =  w+0.5;
                if ( (xmi<ta) && (tb<xma) ) || ( (ta<xmi) && (xma<tb) )
                    DTB__windows__is_ok{P.isshown.id,1}(w)=0;
                end
            end
            Graphic_update_data(0);
            Graphic_update_spectrums(0);
        end
    end
    function CM_spectrum_resume_win(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__status(P.isshown.id,1)==1
            [xmi,xma] = getxrange();% sec
            n_of_windows = DTB__windows__number(P.isshown.id,1);
            for w = 1:n_of_windows
                ta = w-0.5;
                tb =  w+0.5;
                if ( (xmi<ta) && (tb<xma) ) || ( (ta<xmi) && (xma<tb) )
                    DTB__windows__is_ok{P.isshown.id,1}(w)=1;
                end
            end
            Graphic_update_data(0);
            Graphic_update_spectrums(0);
        end
    end
    %
    function CM_spectrum_delete_curves(~,~,~)
        axid = 0;
        if gca==hAx_speV
            axid = 1;
        end
        if gca==hAx_speE
            axid = 1;
        end
        if gca==hAx_speN
            axid = 1;
        end
        if axid>0
            delete_curve_set(axid);
        end
    end
    function CM_spectrum_resume_curves(~,~,~)
        axid = 0;
        if gca==hAx_speV
            axid = 1;
        end
        if gca==hAx_speE
            axid = 1;
        end
        if gca==hAx_speN
            axid = 1;
        end
        if axid>0
            resume_curve_set(axid);
        end
    end
    %
    function CM_spectrum_select_main_peak(~,~,~)
        select_main_peak();
    end
    function CM_spectrum_deselect_main_peak(~,~,~)
        deselect_main_peak();
    end
    %
    function CM_spectrum_select_additional_peak(~,~,~)
         select_additional_peak();
    end
    function CM_spectrum_discard_last_additional_peak_selections(~,~,~)
        discard_last_additional_peak();
    end
    function CM_spectrum_discard_additional_peak_selections(~,~,~)
        deselect_additional_peak();
    end
    %
    function CM_speN_SetrangeHax(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if P.Flags.spectrum_mode==0 || P.Flags.spectrum_mode==1 || P.Flags.spectrum_mode==2 || P.Flags.spectrum_mode==3
            % 0 spectrum
            % 1 spectrum
            % 2 hv of windows
            % 3 hv of windows
            if ~isempty(P.TAB_Computations.hori_axis_limits__windows)
                Imin = P.TAB_Computations.hori_axis_limits__windows(1);
                Imax = P.TAB_Computations.hori_axis_limits__windows(2);
            else
                ii = P.isshown.id;
                Imin=1;
                Imax=DTB__windows__number(ii,1);
            end
            P.TAB_Computations.hori_axis_limits__windows = Get_Range_Callback(Imin,Imax,'Windows ID');
        end
        if P.Flags.spectrum_mode==4 || P.Flags.spectrum_mode==5 || P.Flags.spectrum_mode==6
            % 4 hv curve (frequence axis)
            if ~isempty(P.TAB_Computations.hori_axis_limits__frequence)
                Fmin = P.TAB_Computations.hori_axis_limits__frequence(1);
                Fmax = P.TAB_Computations.hori_axis_limits__frequence(2);
            else
                ii = P.isshown.id;
                df = DTB__section__Frequency_Vector{ii,1}(3);
                Fmin = df*(DTB__section__Frequency_Vector{ii,1}(1)-1); 
                Fmax = df*(DTB__section__Frequency_Vector{ii,1}(2)-1);
            end
            P.TAB_Computations.hori_axis_limits__frequence = Get_Range_Callback(Fmin,Fmax,'Freq. Range');
        end
        
        if P.Flags.spectrum_mode==7
            % 5 hv 180 (angle axis)
            Amin = 0;
            Amax = 180;
            P.TAB_Computations.hori_axis_limits__angles = Get_Range_Callback(Amin,Amax,'Angle Range');
        end
        if P.Flags.spectrum_mode==8
            % hv 180 (angle axis) and curves 
            if ~isempty(P.TAB_Computations.hori_axis_limits__angles)
                Amin = P.TAB_Computations.hori_axis_limits__angles(1);
                Amax = P.TAB_Computations.hori_axis_limits__angles(2);
            else
                Amin = 0;
                Amax = 180;
            end
            if ~isempty(P.TAB_Computations.hori_axis_limits__angleshv)
                Fmin = P.TAB_Computations.hori_axis_limits__angleshv(1);
                Fmax = P.TAB_Computations.hori_axis_limits__angleshv(2);
            else
                ii = P.isshown.id;
                df = DTB__section__Frequency_Vector{ii,1}(3);
                Fmin = df*(DTB__section__Frequency_Vector{ii,1}(1)-1); 
                Fmax = df*(DTB__section__Frequency_Vector{ii,1}(2)-1);
            end
            [Arange,Frange] = Get_Range_X2_Callback(Amin,Amax,Fmin,Fmax,'Range','Angle','Freq.');
            P.TAB_Computations.hori_axis_limits__angles   = Arange;
            P.TAB_Computations.hori_axis_limits__angleshv = Frange;
        end
        Graphic_update_spectrums(0);
    end
    function CM_speN_resetHax(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        switch P.Flags.spectrum_mode
            case 0; P.TAB_Computations.hori_axis_limits__windows = [];% spectrum
            case 1; P.TAB_Computations.hori_axis_limits__windows = [];% spectrum
            case 2; P.TAB_Computations.hori_axis_limits__windows = [];% hv of windows
            case 3; P.TAB_Computations.hori_axis_limits__windows = [];% hv of windows
            case 4; P.TAB_Computations.hori_axis_limits__frequence = [];% hv curve
            case 5; P.TAB_Computations.hori_axis_limits__frequence = [];% hv curve
            case 6; P.TAB_Computations.hori_axis_limits__frequence = [];% hv curve 
            case 7; P.TAB_Computations.hori_axis_limits__angles  = [];% hv 180
            case 8 
                P.TAB_Computations.hori_axis_limits__angles  = [];% hv 180
                P.TAB_Computations.hori_axis_limits__angleshv= [];% all hv
            otherwise; warning('SAM: Graphic_update_spectrums: mode unespected. NO ACTION PERFORMED');
        end
        Graphic_update_spectrums(0);
    end
    function CM_speN_SetrangeVax(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if P.Flags.spectrum_mode==0 || P.Flags.spectrum_mode==1 || P.Flags.spectrum_mode==2 || P.Flags.spectrum_mode==3
            % 0 spectrum
            % 1 spectrum
            % 2 hv of windows
            % 3 hv of windows
            if ~isempty(P.TAB_Computations.vert_axis_limits__windows)
                Imin = P.TAB_Computations.vert_axis_limits__windows(1);
                Imax = P.TAB_Computations.vert_axis_limits__windows(2);
            else
                ii = P.isshown.id;
                Imin=DTB__section__Min_Freq(ii,1);
                Imax=DTB__section__Max_Freq(ii,1);
            end
            P.TAB_Computations.vert_axis_limits__windows = Get_Range_Callback(Imin,Imax,'Frequency [Hz]');
        end
        if P.Flags.spectrum_mode==4 || P.Flags.spectrum_mode==5 || P.Flags.spectrum_mode==6
            % 4 hv curve (frequence axis)
            if ~isempty(P.TAB_Computations.vert_axis_limits__frequence)
                Amin = P.TAB_Computations.vert_axis_limits__frequence(1);
                Amax = P.TAB_Computations.vert_axis_limits__frequence(2);
            else
                Amin = 0; 
                ii = P.isshown.id;
                if ~isnan(DTB__hvsr__auto_main_peak_amplitude(ii,1))
                    Amax = DTB__hvsr__auto_main_peak_amplitude(ii,1);
                else
                    Amax = 15;
                end
            end
            P.TAB_Computations.vert_axis_limits__frequence = Get_Range_Callback(Amin,Amax,'Amplitude');
        end
        if P.Flags.spectrum_mode==7
            % 5 hv 180 (angle axis)
            if ~isempty(P.TAB_Computations.vert_axis_limits__angles)
                Fmin = P.TAB_Computations.vert_axis_limits__angles(1);
                Fmax = P.TAB_Computations.vert_axis_limits__angles(2);
            else
                ii = P.isshown.id;
                Fmin=DTB__section__Min_Freq(ii,1);
                Fmax=DTB__section__Max_Freq(ii,1);
            end
            P.TAB_Computations.vert_axis_limits__angles = Get_Range_Callback(Fmin,Fmax,'Frequency [Hz]');
        end
        if P.Flags.spectrum_mode==8
            % hv 180 (angle axis) and curves 
            if ~isempty(P.TAB_Computations.vert_axis_limits__angles)
                Fmin = P.TAB_Computations.vert_axis_limits__angles(1);
                Fmax = P.TAB_Computations.vert_axis_limits__angles(2);
            else
                ii = P.isshown.id;
                Fmin=DTB__section__Min_Freq(ii,1);
                Fmax=DTB__section__Max_Freq(ii,1);
            end
            if ~isempty(P.TAB_Computations.vert_axis_limits__angleshv)
                Amin = P.TAB_Computations.vert_axis_limits__angleshv(1);
                Amax = P.TAB_Computations.vert_axis_limits__angleshv(2);
            else
                Amin = 0; 
                ii = P.isshown.id;
                if ~isnan(DTB__hvsr__auto_main_peak_amplitude(ii,1))
                    Amax = DTB__hvsr__auto_main_peak_amplitude(ii,1);
                else
                    Amax = 15;
                end
            end
            [Frange,AMrange] = Get_Range_X2_Callback(Fmin,Fmax,Amin,Amax,'Range','Freq.','Ampli.');
            P.TAB_Computations.vert_axis_limits__angles   = Frange;
            P.TAB_Computations.vert_axis_limits__angleshv = AMrange;
        end
        Graphic_update_spectrums(0);
    end
    function CM_speN_resetVax(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        switch P.Flags.spectrum_mode
            case 0; P.TAB_Computations.vert_axis_limits__windows = [];% spectrum
            case 1; P.TAB_Computations.vert_axis_limits__windows = [];% spectrum
            case 2; P.TAB_Computations.vert_axis_limits__windows = [];% hv of windows
            case 3; P.TAB_Computations.vert_axis_limits__windows = [];% hv of windows
            case 4; P.TAB_Computations.vert_axis_limits__frequence = [];% hv curve
            case 5; P.TAB_Computations.vert_axis_limits__frequence = [];% hv curve
            case 6; P.TAB_Computations.vert_axis_limits__frequence = [];% hv curve 
            case 7; P.TAB_Computations.vert_axis_limits__angles  = [];% hv 180
            case 8
                P.TAB_Computations.vert_axis_limits__angles  = [];% hv 180
                P.TAB_Computations.vert_axis_limits__angleshv= [];% all hv
            otherwise; warning('SAM: Graphic_update_spectrums: mode unespected. NO ACTION PERFORMED');
        end
        Graphic_update_spectrums(0);
    end
    function CM_set_lin_freq(~,~,~)
        P.Flags.SpectrumAxisMode = 1;
        set(hAx_speN_hcmenu_Flin ,'Checked','on');
        set(hAx_speN_hcmenu_Flog ,'Checked','off');
        Graphic_update_spectrums(0);
    end
    function CM_set_log_freq(~,~,~)
        P.Flags.SpectrumAxisMode = 0;
        set(hAx_speN_hcmenu_Flin ,'Checked','off');
        set(hAx_speN_hcmenu_Flog ,'Checked','on');
        Graphic_update_spectrums(0);
    end
%% TAB-2, Panel-D
    function CB_data_to_use(~,~,~)
        if get(T2_PA_dattoUSE,'Value')==2
            messgtxt = sprintf('WARNING:\nUse of filtered data in spectral ratio\ncomputation may severely alter\nthe shape of the curve and\nhide resonating peaks');
            msgbox(messgtxt)
        end
    end
    function CB_compute_single_windowing(~,~,~)
        if isempty(SURVEYS); return; end  
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end 
        %
        status = check_filter_status(P.isshown.id);
        if status==0
            compute_single_windowing(P.isshown.id);
            Graphic_update_data(0);
        end
    end
    function CB_compute_windowing_all(~,~,~)
        if isempty(SURVEYS); return; end  
        %
        compute_windowing_all();
        Graphic_update_data(0);
    end
    function CB_compute_one(~,~,~)
        if isempty(SURVEYS); return; end  
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_busy()
        status = database_single_computation(P.isshown.id);
        if status
            Graphic_update_spectrums(0);
        end
        is_done()
    end
    function CB_compute_all(~,~,~)
        if isempty(SURVEYS); return; end  
        %
        is_busy()
        if database_compute_all() == 1
            Graphic_update_spectrums(0);
            clc
            fprintf('ENTIRE DATABASE RECOMPUTED\n')
        else
            clc
            fprintf('APPARENTLY, THE WINDOWING\n')
            fprintf('OPERATION (TAB-2) WAS NOT\n')
            fprintf('PERFORMED.\n')
            fprintf('\n')
            fprintf('USE TAB-2 TO GENERATE THE TIME WINDOWS\n')
            fprintf('BEFORE USING TAB-3.\n')
        end
        is_done()
    end
%% TAB-3: ===================== computation
    function CB_TAB_update_Computations(~,~,~)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        %
        if DTB__windows__number(P.isshown.id,1)==0 % prevent computing when not windowed 
            set(T2_PA_HV,              'Enable','off')
            set(hT3_PA_edit_fmin,      'Enable','off')
            set(hT3_PA_edit_fmax,      'Enable','off')
            set(T3_P1_wintapering,     'Enable','off')
            set(T3_P1_wpadto,          'Enable','off')
            set(T3_PA_wsmooth_strategy,'Enable','off')
            set(T3_PA_wsmooth_amount,  'Enable','off')
            set(T3_PD_smooth_slider,   'Enable','off')
            set(T3_P1_angular_samp,    'Enable','off')
            set(T3_compute_1,'Enable','off', 'String','THIS data needs Windowing')
        else
            set(T2_PA_HV,              'Enable','on')
            set(hT3_PA_edit_fmin,      'Enable','on')
            set(hT3_PA_edit_fmax,      'Enable','on')
            set(T3_P1_wintapering,     'Enable','on')
            set(T3_P1_wpadto,          'Enable','on')
            set(T3_PA_wsmooth_strategy,'Enable','on')
            set(T3_PA_wsmooth_amount,  'Enable','on')
            set(T3_PD_smooth_slider,   'Enable','on')
            set(T3_P1_angular_samp,    'Enable','on')
            set(T3_compute_1,'Enable','on',  'String','Run computing on THIS data')
        end
    end
%% TAB-3, Panel-A
    function CB_Filter_switch(~,~,~)
        if (0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1)) 
            idfilter = get(T2_PA_filter,'Value');% 1  off, 2 bandpass, 3 lowpass, 4 Highpass
            switch idfilter
                case 2% BANDPASS
                    set(T2_PA_filter_fmin,'enable','on') 
                    set(T2_PA_filter_fmax,'enable','on')
                    set(T2_PA_filter_show,'enable','on') 
                    set(T2_PA_dattoUSE,   'enable','on')
                    %
                case 3% LOWPASS
                    set(T2_PA_filter_fmin,'enable','off','String',' ') 
                    set(T2_PA_filter_fmax,'enable','on')
                    set(T2_PA_filter_show,'enable','on')
                    set(T2_PA_dattoUSE,   'enable','on')
                case 4% HIGHPASS
                    set(T2_PA_filter_fmin,'enable','off','String',' ') 
                    set(T2_PA_filter_fmax,'enable','on')
                    set(T2_PA_filter_show,'enable','on')
                    set(T2_PA_dattoUSE,   'enable','on')
                otherwise% FILTER OFF (case 1 included)
                    set(T2_PA_filter_fmin,'enable','off','String',' ') 
                    set(T2_PA_filter_fmax,'enable','off','String',' ')
                    set(T2_PA_filter_show,'enable','off')
                    set(T2_PA_dattoUSE,'Value',1,'enable','off')
            end
            %if (iduse==1 && idfilter>1); set(T2_PA_dattoUSE,'Value',2,'Enable','on'); end
        else
            set(T2_PA_filter,'Value',1);
        end
    end
    function CB_Filter_test(~,~,~)
        if (0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1)) 
            status = check_filter_status(P.isshown.id);
            if status==0        
                idfilter = get(T2_PA_filter,'Value');% 1  off, 2 bandpass
                switch idfilter
                    case 1
                        set(T2_PA_filter_fmin,'String','') 
                        set(T2_PA_filter_fmax,'String','') 
                    case 2% BANDPASS
                        Fs = sampling_frequences(P.isshown.id);
                        Fc1 = str2double(get(T2_PA_filter_fmin,'String')); %cutoff frequency for the point 6 dB point below the passband value for the first cutoff. Specified in normalized frequency units. (FIR filters)
                        Fc2 = str2double(get(T2_PA_filter_fmax,'String')); %cutoff frequency for the point 6 dB point below the passband value for the second cutoff. Specified in normalized frequency units. (FIR filters)               
                        N = default_values.Bandpss_Order;%
                        dd = fdesign.bandpass('N,Fc1,Fc2',N,Fc1,Fc2,Fs);
                        Hdd = design(dd,'butter');
                        %freqz(Hd);
                        fvtool(Hdd)
                    case 3% LOWPASS
                        Fs = sampling_frequences(P.isshown.id);
                        Fc2 = str2double(get(T2_PA_filter_fmax,'String')); %cutoff frequency for the point 6 dB point below the passband value for the second cutoff. Specified in normalized frequency units. (FIR filters)                 
                        N = default_values.Lowpss_Order;
                        dd = fdesign.lowpass('N,Fc',N,Fc2,Fs);
                        Hdd = design(dd,'butter');
                        %freqz(Hd);
                        fvtool(Hdd)
                    case 4% HIGHPASS
                        Fs = sampling_frequences(P.isshown.id);
                        Fc2 = str2double(get(T2_PA_filter_fmax,'String')); %cutoff frequency for the point 6 dB point below the passband value for the second cutoff. Specified in normalized frequency units. (FIR filters)                 
                        N = default_values.Highpss_Order;
                        dd = fdesign.highpass('N,F3dB',N,Fc2,Fs);
                        Hdd = design(dd,'butter');
                        %freqz(Hd);
                        fvtool(Hdd)                        
                end
            end    
        end
    end
    function CB_padding_set_next_pow2(~,~,~)
        dat_id = P.isshown.id;
        if dat_id==0; set(T3_P1_wpadto,'string','off'); return; end
        %
        strg = get(T3_P1_wpadto,'string');
        if strcmp(strg,'off'); return; end
        %
        L = str2double(strg);
        LL=2^nextpow2(L);
        if ~isempty(DTB__windows__info)
            if DTB__windows__info(dat_id,2)>0
                pad0 = 2^nextpow2(DTB__windows__info(dat_id,2));  
                if LL>pad0
                    set(T3_P1_wpadto,'string',num2str(LL));
                    return;
                else
                    set(T3_P1_wpadto,'string','off');
                    return
                end
            end
        end
        %
        %
        set(T3_P1_wpadto,'string',num2str(LL));% default choice  
    end
%% TAB-3, Panel-D
    function CB_spectrum_selection(~,event)%(source,event)
        is_drawing();
        %        display(['Previous: ' event.OldValue.String]);
        %        display(['Current: ' event.NewValue.String]);
        %        display('------------------');
        %        switch event.NewValue.String%        Matlab: after 2014b
        switch get(event.NewValue,'string')%  Matlab: before 2014b
            case P3_TA_buttongroup_option{1}% spectrum (windows)
                P.Flags.spectrum_mode = 0;
            case P3_TA_buttongroup_option{2}% spectrum (contour)
                P.Flags.spectrum_mode = 1;
            case P3_TA_buttongroup_option{3}% hvsr (windows)
                P.Flags.spectrum_mode = 2;
            case P3_TA_buttongroup_option{4}% hvsr (contour)
                P.Flags.spectrum_mode = 3;
            case P3_TA_buttongroup_option{5}% hvsr mean curve
                P.Flags.spectrum_mode = 4;
            case P3_TA_buttongroup_option{6}% H-V comparison
                P.Flags.spectrum_mode = 5;
            case P3_TA_buttongroup_option{7}% hvsr all curves (was 6)
                P.Flags.spectrum_mode = 6;
            case P3_TA_buttongroup_option{8}% hv-180 image
                P.Flags.spectrum_mode = 7;    
            case P3_TA_buttongroup_option{9}% hv-180 curves
                P.Flags.spectrum_mode = 8;
            otherwise
                error('SAM: Unespected behavior of uibuttongroup')
        end
        %
        clc
        %P.Flags.spectrum_mode
        set(hAx_speN_hcmenu_1,'Enable','off')
        set(hAx_speN_hcmenu_2,'Enable','off')
        set(hAx_speN_hcmenu_3,'Enable','off')
        set(hAx_speN_hcmenu_4,'Enable','off')
        set(hAx_speN_hcmenu_5,'Enable','off')
        set(hAx_speN_hcmenu_6,'Enable','off')
        set(hAx_speN_hcmenu_7,'Enable','off')
        set(hAx_speN_hcmenu_8,'Enable','off')
        set(hAx_speN_hcmenu_9,'Enable','off')
        if(P.Flags.spectrum_mode<4)% 0-3, tiled view of spectre or HVSR curves
            set(hAx_speN_hcmenu_1,'Enable','on')
            set(hAx_speN_hcmenu_2,'Enable','on')
        end
        if(P.Flags.spectrum_mode==4)% 4, view of mean HVSR (mode a)
            set(hAx_speN_hcmenu_3,'Enable','on')
            set(hAx_speN_hcmenu_4,'Enable','on')
            set(hAx_speN_hcmenu_7,'Enable','on')
            set(hAx_speN_hcmenu_8,'Enable','on')
            set(hAx_speN_hcmenu_9,'Enable','on')
        end
        if(P.Flags.spectrum_mode==5)% 5, view of mean HVSR (mode b): compare VEN 
            set(hAx_speN_hcmenu_3,'Enable','on')
            set(hAx_speN_hcmenu_4,'Enable','on')
            set(hAx_speN_hcmenu_7,'Enable','on')
            set(hAx_speN_hcmenu_8,'Enable','on')
            set(hAx_speN_hcmenu_9,'Enable','on')
        end
        if(P.Flags.spectrum_mode==6)% 6, view of mean HVSR (mode c): all curves
            set(hAx_speN_hcmenu_5,'Enable','on')
            set(hAx_speN_hcmenu_6,'Enable','on')
        end
        drawnow
    end
    function CB_spectrum_of_windows(~,~,~)
        Graphic_update_spectrum_of_windows(0);
         is_done();
    end
    function CB_hvsr_of_windows(~,~,~)
        Graphic_update_hvsr_of_windows(0);
         is_done();
    end
    function CB_hvsr_average_curve(~,~,~)
        Graphic_update_hvsr_average_curve(0);
         is_done();
    end
    function CB_hvsr_all_windows_curves(~,~,~)
        Graphic_update_hvsr_all_curves(0);
         is_done();
    end
    function CB_hvsr_H_V_Components_Compare(~,~,~)
        Graphic_update_hvsr_H_V_Compare(0);
         is_done();
    end
    function CB_hvsr_180_windows(~,~,~)
        Graphic_update_hvsr_180_windows(0);
         is_done();
    end
    function CB_hvsr_180_curves(~,~,~)
        Graphic_update_hvsr_180_curves(0);
         is_done();
    end
    function CB_Update_Computation_caxis(~,~,~)
        %fprintf('CB_Update_Computation_caxis\n')
        rclr = [str2double(get(T3_PD_mincolor,'string')),  str2double(get(T3_PD_maxcolor,'string'))];
        if rclr(2)<=rclr(1)
           rclr = []; 
        end
        switch P.Flags.spectrum_mode
            case 0; P.TAB_Computations.custom_caxis_spectrum     = rclr;% spectrum 
            case 1; P.TAB_Computations.custom_caxis_spectrum     = rclr;% spectrum 
            case 2; P.TAB_Computations.custom_caxis_hvsr_windows = rclr;% hvsr windows
            case 3; P.TAB_Computations.custom_caxis_hvsr_windows = rclr;% hvsr windows
            case 4; P.TAB_Computations.custom_caxis_hvsr         = rclr;% hvsr curves
            case 5; P.TAB_Computations.custom_caxis_hvsr         = rclr;% hvsr curves
            case 6; P.TAB_Computations.custom_caxis_hvsr         = rclr;% hvsr curves    
            case 7; P.TAB_Computations.custom_caxis_directional  = rclr;% directional
            case 8; P.TAB_Computations.custom_caxis_directional  = rclr;% directional
        end
        Graphic_update_spectrums(0);
    end
    function CB_Reset_Computation_caxis(~,~,~)
        %fprintf('CB_Reset_Computation_caxis\n')
        switch P.Flags.spectrum_mode
            case 0; P.TAB_Computations.custom_caxis_spectrum     = [];% spectrum 
            case 1; P.TAB_Computations.custom_caxis_spectrum     = [];% spectrum 
            case 2; P.TAB_Computations.custom_caxis_hvsr_windows = [];% hvsr windows
            case 3; P.TAB_Computations.custom_caxis_hvsr_windows = [];% hvsr windows
            case 4; P.TAB_Computations.custom_caxis_hvsr         = [];% hvsr curves
            case 5; P.TAB_Computations.custom_caxis_hvsr         = [];% hvsr curves
            case 6; P.TAB_Computations.custom_caxis_hvsr         = [];% hvsr curves
            case 7; P.TAB_Computations.custom_caxis_directional  = [];% directional
            case 8; P.TAB_Computations.custom_caxis_directional  = [];% directional
        end
        Graphic_update_spectrums(0);
    end
    %
    function CB_smoothing_slider(~,~,~)
        setup_smoothing_value();
    end    
    function CB_TAB_spectrum_view_update(~,~,~)% just update graphics
        clc
        Graphic_update_spectrums(0);
    end
    function CB_TAB_main_view_update(~,~,~)
        Graphic_Gui_update_elaboration_parameters();
    end
    %    
    function define_Profile(~,~,~)
        if isempty(SURVEYS); return; end
        Np = size(receiver_locations,1);
        recta_kind = 0;
        if Matlab_Release_num>2017.1% Solve ginput issuewith R2017b and above
            [xx,yy] = sam2018b_ginput(2, hAx_main_geo);
        else
            [xx,yy] = ginput(2, hAx_main_geo);
        end
        if( (xx(1)==xx(2)) && (yy(1)==yy(2))); return; end
        dummy_ids = zeros(Np,3);
        dummy_line    = [xx,yy];
        dummy_onoff   = zeros(Np,1);% 
        lne = plot(hAx_main_geo,xx,yy,'k');
        %
        prompt = {'Select the ID of the farthest station','Custom name'};
        def = {'0','none'};
        % inputdlg(prompt,title,dims,definput)
        answer = inputdlg(prompt,'info request',[1 35],def);
        if(isempty(answer)); return; end
        %r_distance_from_profile = str2double(answer{1});
        id_farhest = str2double(answer{1});
        profile_name = answer{2};
        if (0<id_farhest) && (id_farhest<=Np)
            % filter measurement points
            found_ids = 0;
            if(xx(1)==xx(2)) % rect x=constant
                recta_kind = 1;
                r_distance_from_profile = abs(receiver_locations(id_farhest,1)-xx(1));
                for ii = 1:Np
                    if( abs(receiver_locations(ii,1)-xx(1)) <= r_distance_from_profile)
                        dr = receiver_locations(ii,2)-yy(1);
                        far = abs(receiver_locations(ii,1)-xx(1));
                        found_ids=found_ids+1;
                        dummy_ids(found_ids,1:3) = [ii, dr, far];
                    end
                end
            end
            if(yy(1)==yy(2)) % rect y=constant
                r_distance_from_profile = abs(receiver_locations(id_farhest,2)-yy(1));
                for ii = 1:Np
                    recta_kind = 2;
                    if( abs(receiver_locations(ii,2)-yy(1)) <= r_distance_from_profile)
                        dr = receiver_locations(ii,1)-xx(1);
                        far = abs(receiver_locations(ii,2)-yy(1));
                        found_ids=found_ids+1;
                        dummy_ids(found_ids,1:3) = [ii, dr, far];
                    end
                end
            end
            if(recta_kind==0)% rect y=mx+q    q=y-mx            
                m1 = (yy(2)-yy(1))/(xx(2)-xx(1));
                q1 = yy(1) - m1*xx(1);
                dist = abs(receiver_locations(:,2) - (m1*receiver_locations(:,1) +q1))/sqrt(1+m1^2);% Equation 1
                r_distance_from_profile = dist(id_farhest);
                %% info
                % r1:  y = m1 x + q1 (profile)
                % r2:  y = m2 x + q2 (line through the receiver and perpendicular to r1)
                %
                % rect given endpoints
                % r1 = m1 x + q1:    (ax +by +c = 0)
                %     a = y2-y1
                %     b = x2-x1
                %     c = x2 y1 - y2 x1
                %     m1 = -a/b = -(y2-y1)/(x2-x1) 
                %     q1  = y1 -m1 x1
                %
                % distance of point p (receiver) from the rect r1 (the profile). (Equation 1)
                % dist = |yp - m1 xp -q1 | / sqrt(1 + m1^1)
                %
                % rect (r2) through a point p and perpendicular to r1 (y=m1 x +q1):
                % y = m2 xp + q2
                % m2  = -1/m1
                % q2 = yp - m2 xp == yp +xp/m1  (Equation 2)
                %
                % point of intersection of two rects
                % [ y = m2 x + q2
                % [ y = m1 x + q1
                %
                % [ y = m2 x + q2
                % [ m2 x + q2 = m1 x + q1 -> x(m2-m1) = (q1-q2)
                %
                % [ y = m2 (q1-q2)/(m2-m1)+ q2
                % [ x = (q1-q2)/(m2-m1) 
                %%
                m2 = -1/m1;
                q2 = receiver_locations(:,2) + receiver_locations(:,1)/m1;%  (Equation 2)
                xp = (q1-q2)/(m2-m1);%             Point of intersection
                yp = m2*(q1-q2)/(m2-m1)+q2;% Point of intersection 
                drs= sqrt( (xx(1)-xp).^2 + (yy(1)-yp).^2 );% distances from beginning of profile
                %
                for ii = 1:Np
                    far = dist(ii);
                    dr  = drs(ii);
                    if(xp(ii) < xx(1))
                        dr = -dr;
                    end

                    if( dist(ii) <= r_distance_from_profile)
                        found_ids=found_ids+1;
                        dummy_ids(found_ids,1:3) = [ii, dr, far];% [station-ID][distance from profile beginning][distance from profile]
                        % val = station-ID
                        % dr  = distance (along profile) from profile beginning
                        % far = distance from profile
                    end
                end
            end
            if found_ids>0% some suitable measurement were found
                dummy_ids = dummy_ids(1:found_ids,:);
                if found_ids>1% at least two station per profile
                    if ~isempty(P.profile_ids)
                        pid = size(P.profile_ids,1) +1;
                    else
                        pid=1;
                        P.profile.ii=1;
                    end
                    %
                    [~,idx] = sort(dummy_ids(:,2)); % sort just the first column
                    sortedmat = dummy_ids(idx,:);   % sort the whole matrix using the sort indices
                    %
                    % check for double entries (same longitudinal distance, to be avoided)
                    original_sortedmat = sortedmat;
                    distance_checked = 0;
                    current_line=0; 
                    for pp=1:found_ids
                        [r,~]= find(original_sortedmat(:,2)==original_sortedmat(pp,2));
                        if original_sortedmat(pp,2) > distance_checked
                            current_line = current_line+1;
                            sortedmat( current_line, :) =  original_sortedmat(r(1),:);
                            distance_checked = original_sortedmat(pp,2); 
                        end
                    end
                    sortedmat = sortedmat(1:current_line,:);
                    if size(sortedmat,1)~=size(original_sortedmat,1)
                        Message = sprintf('MESSAGE: Some stations were not included in the profile\nbecause they would occupy the same location.');
                        %waitfor(warndlg(Message,'INFO'));
                        fprintf('%s\n',Message);
                    end
                    % set which surveys are included
                    dummy_onoff(sortedmat(:,1)) = 1; 
                    %
                    %
                    P.profile_ids{pid,1}   = sortedmat;
                    P.profile_line{pid,1}  = dummy_line;
                    P.profile_onoff{pid,1} = dummy_onoff;
                    P.profile_name{pid,1} = profile_name;
                    %
                    Update_survey_locations(hAx_main_geo);
                    Update_survey_locations(hAx_geo1);
                    Update_survey_locations(hAx_geo2);
                    Update_survey_locations(hAx_geo3);
                end
            end
        end
        delete(lne);
    end
    function reset_Profile(~,~,~)
        if isempty(SURVEYS); return; end
        P.profile_line = {};
        P.profile_ids  = {};
        P.profile_onoff = {};
        P.profile_name={};
        %  
        Update_survey_locations(hAx_main_geo);
        Update_survey_locations(hAx_geo1);
        Update_survey_locations(hAx_geo2);
        Update_survey_locations(hAx_geo3);
    end
    function reset_one_Profile(~,~,~)
        if isempty(SURVEYS); return; end
        if isempty(P.profile_ids); return; end
        if size(P.profile_ids,1)<2
            P.profile_line = {};
            P.profile_ids  = {};
            P.profile_onoff = {};
            P.profile_name={};
        else

            prompt = {'Select the ID of the profile to discard'};
            def = {'0'};% {num2str(r_distance_from_profile)};
            answer = inputdlg(prompt,'ID?',1,def);
            if(isempty(answer)); return; end
            p_id = str2double(answer{1});
            if p_id > size(P.profile_ids,1); return; end
            if p_id <1; return; end

            Nprf = size(P.profile_ids,1);
            temp_line = P.profile_line;
            temp_ids = P.profile_ids;
            temp_onoff  = P.profile_onoff;
            temp_name = P.profile_name;

            P.profile_line = cell(Nprf-1,1);
            P.profile_ids = cell(Nprf-1,1);    
            P.profile_onoff = cell(Nprf-1,1);
            P.profile_name = cell(Nprf-1,1);
            nowid = 0;
            for ipid = 1:Nprf 
                if ipid == p_id; continue; end
                nowid = nowid + 1;
                P.profile_line{nowid,1} = temp_line{ipid,1};
                P.profile_ids{nowid,1}  = temp_ids{ipid,1};  
                P.profile_onoff{nowid,1} = temp_onoff{ipid,1};
                P.profile_name{nowid,1}  = temp_name{ipid,1}; 
            end
        end
        %  
        Update_survey_locations(hAx_main_geo);
        Update_survey_locations(hAx_geo1);
        Update_survey_locations(hAx_geo2);
        Update_survey_locations(hAx_geo3);
    end
    function Viewmode_Vert_or_Horizontal(hObject, ~, ~)%(hObject, eventdata, handles)
        val = get(hObject,'Checked');
        if strcmp(val,'on')% set horizontal
            set(hObject,'Checked','off');
            %
            pos_V = [0.05 0.72    0.9 0.265];%[0.05 0.65    0.9 0.275];
            set(hAx_speV,'Position',pos_V);
            %
            pos_E = [0.05 0.39    0.9 0.265];%[0.05 0.35    0.9 0.275];
            set(hAx_speE,'Position',pos_E);
            %
            pos_N = [0.05 0.06    0.9 0.265];%[0.05 0.05    0.9 0.275];
            set(hAx_speN,'Position',pos_N);
        end
        if strcmp(val,'off')% set verical
            set(hObject,'Checked','on');
            %
            pos_V = [0.06 0.1    0.2725 0.9];%[0.05 0.05    0.275 0.9];
            set(hAx_speV,'Position',pos_V);
            %
            pos_E = [0.39 0.1    0.2725 0.9];%[0.35 0.05    0.275 0.9];
            set(hAx_speE,'Position',pos_E);
            %
            pos_N = [0.72 0.1    0.2725 0.9];%[0.65 0.05    0.275 0.9];
            set(hAx_speN,'Position',pos_N);
        end
        drawnow
    end
%% TAB-4 ====================== 2D Views
    function CB_selection_2D_view(~,event)%(source,event)
        if isempty(SURVEYS); return; end
        status = 0;
        for ss=1:size(SURVEYS,1)
            if DTB__windows__number(ss,1)~=0; status = 1; break; end
        end
        if status == 0; return; end
        %
        %
        %
        %        display(['Previous: ' event.OldValue.String]);
        %        display(['Current: ' event.NewValue.String]);
        %        display('------------------');
        % %       switch event.NewValue.String%        Matlab: after 2014b
        switch get(event.NewValue,'string')%  Matlab: before 2014b
            case P4_TA_buttongroup_option{1}
                P.Flags.View_2D_current_mode=P4_TA_buttongroup_option{1};
                S2Dview_hvsr_main_frequence();
            case P4_TA_buttongroup_option{2}
                P.Flags.View_2D_current_mode=P4_TA_buttongroup_option{2};
                S2Dview_hvsr_main_amplitude();
            case P4_TA_buttongroup_option{3}
                P.Flags.View_2D_current_mode=P4_TA_buttongroup_option{3};
                S2Dview_hvsr_direction_at_main_amplitude();
            case P4_TA_buttongroup_option{4}
                P.Flags.View_2D_current_mode=P4_TA_buttongroup_option{4};
                S2Dview_hvsr_slice_at_specific_frequence();
            
%             otherwise
%                 error('SAM: Unespected behavior of uibuttongroup')
        end
    end
    function S2Dview_hvsr_main_frequence()
        %fprintf('call to: CB_2Dview_hvsr_main_frequence\n');
        % hAx_2DViews
        Graphics_2dView_hvsr_main_frequence(0)
    end
    function S2Dview_hvsr_main_amplitude()
        Graphics_2dView_hvsr_main_amplitude(0)
    end
    function S2Dview_hvsr_direction_at_main_amplitude()
        Graphics_2dView_hvsr_direction_at_main_peak(0)
    end
    function S2Dview_hvsr_slice_at_specific_frequence()
        Graphics_2dView_slice_at_specific_frequence(0);
    end
    %    
    function CB_hAx_2Dview_freq_DOWN(~,~,~)
        if P.isshown.id ==0; return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        if size(DTB__hvsr__curve{P.isshown.id,1},1) < 1; return; end 
        %
        ii=P.isshown.id;
        Ndat = size(DTB__hvsr__curve{ii,1},1);
        val = P.Flags.View_2D_contour_freq_slice_id;
        switch(P.Flags.View_2D_contour_freq_slice_id)
            case 0; val = Ndat;
            case 1; val = Ndat;
            otherwise; val = val -1;
        end
        P.Flags.View_2D_contour_freq_slice_id = val;
        df = DTB__section__Frequency_Vector{ii,1}(3);
        currentf = df*(val-1);
        set(T4_current_freq,'String',num2str(currentf))
        S2Dview_hvsr_slice_at_specific_frequence();       
    end
    function CB_hAx_2Dview_freq_UP(~,~,~)
        if P.isshown.id ==0; return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        if size(DTB__hvsr__curve{P.isshown.id,1},1) < 1; return; end 
        ii=P.isshown.id;
        Ndat = size(DTB__hvsr__curve{ii,1},1);
        %
        val = P.Flags.View_2D_contour_freq_slice_id;
        switch(P.Flags.View_2D_contour_freq_slice_id)
            case 0; val = 1;
            case Ndat; val = 1;
            otherwise; val = val +1;
        end
        P.Flags.View_2D_contour_freq_slice_id = val;
        df = DTB__section__Frequency_Vector{ii,1}(3);
        currentf = df*(val-1);
        set(T4_current_freq,'String',num2str(currentf))

        S2Dview_hvsr_slice_at_specific_frequence();
    end
    function CB_hAx_2Dview_freq_GOTO(~,~,~)
        if P.isshown.id ==0; return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        if size(DTB__hvsr__curve{P.isshown.id,1},1) < 1; return; end 
        %
        ii=P.isshown.id;
        Ndat = size(DTB__hvsr__curve{ii,1},1);
        df = DTB__section__Frequency_Vector{ii,1}(3);
        currentf = df*(P.Flags.View_2D_contour_freq_slice_id-1);
        fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        
        prompt = {'Select approximate Frequency'};
        def = {num2str(currentf)};
        answer = inputdlg(prompt,'Unite with next',1,def);
        if(~isempty(answer))
            val = str2double(answer{1});
            mindiff = min( abs(fvec-val) );
            for jj=1:Ndat
                currentf = fvec(jj); 
                if( abs(currentf-val)<=mindiff   )
                    P.Flags.View_2D_contour_freq_slice_id = jj;
                    break
                end
            end
            set(T4_current_freq,'String',num2str(currentf))
            S2Dview_hvsr_slice_at_specific_frequence();
        end
        
    end
    %
    function BT_show_property(~,~,parameter_id)% OpenHVSR: BT_show_media
        if isempty(SURVEYS); return; end  
        if isempty(P.profile_ids)
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        if P.profile.id==0; P.profile.id=1; end
        %
        %P.property_23d_to_show = parameter_id;
        % PROFILE
        % property ID = 1:     HVSR
        % property ID = 2:     E-VSR
        % property ID = 3:     N-VSR
        % property ID = 4:     Confidence
        P.Flags.View_2D_current_mode = 'profile';
        P.Flags.View_2D_current_submode = parameter_id;
        Graphics_plot_2d_profile(0);
        if strcmp(P.profile_name{P.profile.id,1},'none')
            set(h_shown_prof,'String',['prof. ',num2str(P.profile.id)])   
        else
            set(h_shown_prof,'String',strcat('(',num2str(P.profile.id),') ',P.profile_name{P.profile.id,1})) 
        end
    end
    function CB_hAx_profile_DOWN(~,~,~)
        if isempty(SURVEYS); return; end  
        if isempty(P.profile_ids)
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        %
        Ndat = size(P.profile_ids,1);
        val = P.profile.id;
        switch(P.profile.id)
            case 0; val = Ndat;
            case 1; val = Ndat;
            otherwise; val = val -1;
        end
        P.profile.id = val;
        
        set(h_shown_prof,'String','wait...')
        P.Flags.View_2D_current_mode = 'profile';
        Graphics_plot_2d_profile(0)
        if strcmp(P.profile_name{P.profile.id,1},'none')
            set(h_shown_prof,'String',['prof. ',num2str(P.profile.id)])   
        else
            set(h_shown_prof,'String',strcat('(',num2str(P.profile.id),') ',P.profile_name{P.profile.id,1})) 
        end
    end
    function CB_hAx_profile_UP(~,~,~)
        if isempty(SURVEYS); return; end
        if isempty(P.profile_ids)
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        %
        Ndat = size(P.profile_ids,1);
        val = P.profile.id;
        switch(P.profile.id)
            case 0; val = 1;
            case Ndat; val = 1;
            otherwise; val = val +1;
        end
        P.profile.id = val;
        set(h_shown_prof,'String','wait...')
        P.Flags.View_2D_current_mode = 'profile';
        Graphics_plot_2d_profile(0)
        if strcmp(P.profile_name{P.profile.id,1},'none')
            set(h_shown_prof,'String',['prof. ',num2str(P.profile.id)])   
        else
            set(h_shown_prof,'String',strcat('(',num2str(P.profile.id),') ',P.profile_name{P.profile.id,1})) 
        end
    end
    function CB_hAx_profile_GOTO(~,~,~)
        if isempty(SURVEYS); return; end
        if isempty(P.profile_ids)
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        %
        Ndat = size(P.profile_ids,1);
        val = P.profile.id;
        prompt = {'Select Profile'};
        def = {num2str(val)};
        answer = inputdlg(prompt,'Unite with next',1,def);
        if(~isempty(answer))
            val = str2double(answer{1});
            if 1<=val && val<= Ndat
                P.profile.id = val;
                set(h_shown_prof,'String','wait...')
                P.Flags.View_2D_current_mode = 'profile';
                Graphics_plot_2d_profile(0)               
                if strcmp(P.profile_name{P.profile.id,1},'none')
                    set(h_shown_prof,'String',['prof. ',num2str(P.profile.id)])   
                else
                    set(h_shown_prof,'String',strcat('(',num2str(P.profile.id),') ',P.profile_name{P.profile.id,1})) 
                end
            end
        end
    end
    %
    function CB_TAB_2D_views_Update(~,~,~)
        if isempty(SURVEYS); return; end
        status = 0;
        for ss=1:size(SURVEYS,1)
            if DTB__windows__number(ss,1)~=0; status = 1; break; end
        end
        if status == 0; return; end
        %
        %
        switch P.Flags.View_2D_current_mode%  Matlab: before 2014b
            case P4_TA_buttongroup_option{1}
                S2Dview_hvsr_main_frequence();
            case P4_TA_buttongroup_option{2}
                S2Dview_hvsr_main_amplitude();
            case P4_TA_buttongroup_option{3}
                S2Dview_hvsr_direction_at_main_amplitude();
            case P4_TA_buttongroup_option{4}
                S2Dview_hvsr_slice_at_specific_frequence();    
            case 'profile'
                Graphics_plot_2d_profile(0);% H.gui,  hAx_2DViews, P.Flags.View_2D_current_submode);
            otherwise
                S2Dview_hvsr_main_frequence();%% option-1
        end       
    end
    function export_last_profile(~,~,~)
        if isempty(temporary_profile); return; end
        [file,thispath] =  uiputfile('*.mat','Save last profile', 'Last_Profile.mat');
        if(file ~= 0)
            datname = strcat(thispath,file);
            save(datname, 'temporary_profile');
        end
    end
    function export_current_profile_as_standalone_elaboration(~,~,~)
        if isempty(SURVEYS); return; end
        if P.profile.id==0; return; end
        if P.profile.id>size(P.profile_ids,1); P.profile.id=size(P.profile_ids,1); end
        
        % [file,thispath] =  uiputfile('*.mat','Save elaboration', strcat(working_folder,'Profile_',num2str(P.profile.id),'__Standalone_Elaboration.mat'));
        [file,thispath] =  uiputfile('*.mat','Save elaboration', strcat('Profile_',num2str(P.profile.id),'__Standalone_Elaboration.mat'));
        %% =========================== V2.0.0 - V2.1.0 
        if(file ~= 0)
            is_busy();
            N_hv_in_profile = size(P.profile_ids{P.profile.id,1},1);
            
            name = file(1:end-4);
            %%   MAIN
            datname = strcat(thispath,name,'_MAIN.mat');
            appname = P.appname;
            % save_version = 2;% 181111: version with one full DDAT FDAT
            save_version = 3;% 190131: version with split DDAT FDAT
            
            iprofile = P.profile;
            iprofile_ids  = cell(1); iprofile_ids{1}  = P.profile_ids{P.profile.id};%   Reduced for the profile
            iprofile_line = cell(1); iprofile_line{1} = P.profile_line{P.profile.id};%P.profile_line;%     Reduced for the profile
            iprofile_onoff= cell(1); iprofile_onoff{1}= P.profile_onoff{P.profile.id};%P.profile_onoff;%  Reduced for the profile
            iprofile_name = cell(1); iprofile_name{1} = P.profile_name{P.profile.id};% P.profile_name;%   Reduced for the profile
            
            %% extract relevant stuff
            Copy_of_SURVEYS = SURVEYS;
            %
            newid = 0;
            SURVEYS = cell(N_hv_in_profile, size(Copy_of_SURVEYS,2) );
            for iia=1:N_hv_in_profile
                ii =P.profile_ids{P.profile.id,1}(iia,1);
                newid = newid+1;
                for cc=1:size(Copy_of_SURVEYS,2)
                    iprofile_ids{1}(newid,1) = newid;% change station ids according to the new set
                    %
                    SURVEYS{newid,cc} = Copy_of_SURVEYS{ii,cc};
                end
            end
            
            save(datname, ...
                'appname', ... %181111  just to check the correct data is loaded
                'save_version', ...%181111 discern which load function to run
                'file', ...
                'thispath', ...
                ...% 'DDAT', ... 190131:  DDAT FDAT are now split
                ...% 'FDAT', ... 190131:  DDAT FDAT are now split
                'Matlab_Release', ...
                'Matlab_Release_num', ...
                'SURVEYS', ...% <----------------------------------------- Reduced for the profile
                'TOPOGRAPHY', ...% MANUALLY PLACED HERE
                'WELLS', ...
                'WLLS', ...
                'datafile_columns', ...
                'datafile_separator', ...
                'receiver_locations', ...
                'reference_system', ...
                'sampling_frequences', ...
                ...% 'survey_boundingboox', ...
                'working_folder', ...
                'iprofile', ...
                'iprofile_ids', ...% <------------------------------------ Reduced for the profile
                'iprofile_line', ...% <----------------------------------- Reduced for the profile
                'iprofile_onoff', ...% <---------------------------------- Reduced for the profile
                'iprofile_name');% <-------------------------------------- Reduced for the profile
            SURVEYS = Copy_of_SURVEYS;% restore the original SURVEY variable
            Global_NN = size(SURVEYS,1);
            NN =  N_hv_in_profile;
            sNN = num2str(NN);
            newid=0;
            for iia=1:N_hv_in_profile
                ii =P.profile_ids{P.profile.id,1}(iia,1);
                newid = newid+1;
                fprintf('Save %d/%d  as ID %d/%d',ii,Global_NN, newid,NN)
                %fprintf('Save %d/%d  as ID %d',ii,NN,newid) 
                datname = strcat(thispath,name,'_database_',num2str(newid),'of',sNN,'.mat');
                %% COPY 
                ID_IN_OROGINAL_PROJECT = ii;
                %%   DTB__status
                iDTB__status = DTB__status(ii,1);%                                            
                iDTB__elaboration_progress = DTB__elaboration_progress(ii,1);
                %%   DTB__windows
                iDTB__windows__width_sec = DTB__windows__width_sec(ii,1);          
                iDTB__windows__number =DTB__windows__number(ii,1);
                iDTB__windows__number_fft = DTB__windows__number_fft(ii,1);
                iDTB__windows__indexes = DTB__windows__indexes{ii,1};
                iDTB__windows__is_ok = DTB__windows__is_ok{ii,1};
                iDTB__windows__winv = DTB__windows__winv{ii,1};                 
                iDTB__windows__wine = DTB__windows__wine{ii,1};
                iDTB__windows__winn = DTB__windows__winn{ii,1};
                iDTB__windows__fftv = DTB__windows__fftv{ii,1};
                iDTB__windows__ffte = DTB__windows__ffte{ii,1};
                iDTB__windows__fftn = DTB__windows__fftn{ii,1};
                iDTB__windows__info = DTB__windows__info(ii,:);                  
                %%   i = DTB__elab_parameters        
                iDTB__elab_parameters__status = DTB__elab_parameters__status{ii,1};
                iDTB__elab_parameters__hvsr_strategy = DTB__elab_parameters__hvsr_strategy(ii,1);
                iDTB__elab_parameters__hvsr_freq_min = DTB__elab_parameters__hvsr_freq_min(ii,1);
                iDTB__elab_parameters__hvsr_freq_max = DTB__elab_parameters__hvsr_freq_max(ii,1);
                iDTB__elab_parameters__windows_width = DTB__elab_parameters__windows_width(ii,1);
                iDTB__elab_parameters__windows_overlap = DTB__elab_parameters__windows_overlap(ii,1);
                iDTB__elab_parameters__windows_tapering = DTB__elab_parameters__windows_tapering(ii,1);
                iDTB__elab_parameters__windows_sta_vs_lta = DTB__elab_parameters__windows_sta_vs_lta(ii,1);
                iDTB__elab_parameters__windows_pad = DTB__elab_parameters__windows_pad{ii,1};
                iDTB__elab_parameters__smoothing_strategy = DTB__elab_parameters__smoothing_strategy(ii,1);
                iDTB__elab_parameters__smoothing_slider_val = DTB__elab_parameters__smoothing_slider_val(ii,1);
                        %
                        % filter
                iDTB__elab_parameters__filter_id = DTB__elab_parameters__filter_id(ii,1);
                iDTB__elab_parameters__filter_name = DTB__elab_parameters__filter_name{ii,1};
                iDTB__elab_parameters__filter_order = DTB__elab_parameters__filter_order(ii,1);
                iDTB__elab_parameters__filterFc1 = DTB__elab_parameters__filterFc1(ii,1);
                iDTB__elab_parameters__filterFc2 = DTB__elab_parameters__filterFc2(ii,1);
                iDTB__elab_parameters__data_to_use = DTB__elab_parameters__data_to_use(ii,1);
                iDTB__elab_parameters__THEfilter = DTB__elab_parameters__THEfilter{ii,1};
                %%   i = DTB__section
                iDTB__section__Min_Freq = DTB__section__Min_Freq(ii,1);
                iDTB__section__Max_Freq = DTB__section__Max_Freq(ii,1);
                iDTB__section__Frequency_Vector = DTB__section__Frequency_Vector{ii,1};
                        %
                iDTB__section__V_windows = DTB__section__V_windows{ii,1};
                iDTB__section__E_windows = DTB__section__E_windows{ii,1};
                iDTB__section__N_windows = DTB__section__N_windows{ii,1};
                        %
                iDTB__section__Average_V = DTB__section__Average_V{ii,1};
                iDTB__section__Average_E = DTB__section__Average_E{ii,1};
                iDTB__section__Average_N = DTB__section__Average_N{ii,1};
                        %
                iDTB__section__HV_windows = DTB__section__HV_windows{ii,1};
                iDTB__section__EV_windows = DTB__section__EV_windows{ii,1};
                iDTB__section__NV_windows = DTB__section__NV_windows{ii,1};
                %%   i = DTB__hvsr
                iDTB__hvsr__curve_full = DTB__hvsr__curve_full{ii,1};
                %DTB{s,1}.hvsr.error_full = [];
                iDTB__hvsr__confidence95_full = DTB__hvsr__confidence95_full{ii,1};
                iDTB__hvsr__curve_EV_full = DTB__hvsr__curve_EV_full{ii,1};
                iDTB__hvsr__curve_NV_full = DTB__hvsr__curve_NV_full{ii,1};
                %
                iDTB__hvsr__EV_all_windows = DTB__hvsr__EV_all_windows{ii,1};
                iDTB__hvsr__NV_all_windows = DTB__hvsr__NV_all_windows{ii,1};
                iDTB__hvsr__HV_all_windows = DTB__hvsr__HV_all_windows{ii,1};
                %
                iDTB__hvsr__curve = DTB__hvsr__curve{ii,1};
                        %DTB{s,1}.hvsr.error = [];
                iDTB__hvsr__confidence95 = DTB__hvsr__confidence95{ii,1};
                iDTB__hvsr__standard_deviation = DTB__hvsr__standard_deviation{ii,1};
                iDTB__hvsr__curve_EV = DTB__hvsr__curve_EV{ii,1};
                iDTB__hvsr__curve_NV = DTB__hvsr__curve_NV{ii,1};
                        %
                iDTB__hvsr__peaks_idx = DTB__hvsr__peaks_idx{ii,1};
                iDTB__hvsr__hollows_idx = DTB__hvsr__hollows_idx{ii,1};
                iDTB__hvsr__user_additional_peaks = DTB__hvsr__user_additional_peaks{ii,1};
                %
                iDTB__hvsr__user_main_peak_frequence = DTB__hvsr__user_main_peak_frequence(ii,1);
                iDTB__hvsr__user_main_peak_amplitude = DTB__hvsr__user_main_peak_amplitude(ii,1);
                iDTB__hvsr__user_main_peak_id_full_curve = DTB__hvsr__user_main_peak_id_full_curve(ii,1);
                iDTB__hvsr__user_main_peak_id_in_section = DTB__hvsr__user_main_peak_id_in_section(ii,1);
                iDTB__hvsr__auto_main_peak_frequence = DTB__hvsr__auto_main_peak_frequence(ii,1);
                iDTB__hvsr__auto_main_peak_amplitude = DTB__hvsr__auto_main_peak_amplitude(ii,1);
                iDTB__hvsr__auto_main_peak_id_full_curve = DTB__hvsr__auto_main_peak_id_full_curve(ii,1);
                iDTB__hvsr__auto_main_peak_id_in_section = DTB__hvsr__auto_main_peak_id_in_section(ii,1);
                %
                %%   i = DTB__hvsr180
                iDTB__hvsr180__angle_id = DTB__hvsr180__angle_id(ii,1);
                iDTB__hvsr180__angles = DTB__hvsr180__angles{ii,1};
                iDTB__hvsr180__angle_step = DTB__hvsr180__angle_step(ii,1);
                iDTB__hvsr180__spectralratio = DTB__hvsr180__spectralratio{ii,1};
                iDTB__hvsr180__preferred_direction = DTB__hvsr180__preferred_direction{ii,1};
                %%   i = DTB__well
                iDTB__well__well_id = DTB__well__well_id(ii,1);
                iDTB__well__well_name = DTB__well__well_name{ii,1};
                iDTB__well__bedrock_depth__KNOWN = DTB__well__bedrock_depth__KNOWN{ii,1};
                iDTB__well__bedrock_depth_source = DTB__well__bedrock_depth_source{ii,1};
                iDTB__well__bedrock_depth__COMPUTED = DTB__well__bedrock_depth__COMPUTED{ii,1};
                iDTB__well__bedrock_depth__IBS1999 = DTB__well__bedrock_depth__IBS1999{ii,1};
                iDTB__well__bedrock_depth__PAROLAI2002 = DTB__well__bedrock_depth__PAROLAI2002{ii,1};
                iDTB__well__bedrock_depth__HINZEN2004 = DTB__well__bedrock_depth__HINZEN2004{ii,1};
                %% Database =====================END

                save(datname, ...
                ... %%   DTB__status
                'ID_IN_OROGINAL_PROJECT', ...% because the profile will hold a subset of the original measurements
                'iDTB__status', ...                                            
                'iDTB__elaboration_progress', ... 
                ...%%   DTB__windows
                'iDTB__windows__width_sec', ...          
                'iDTB__windows__number', ...
                'iDTB__windows__number_fft', ... 
                'iDTB__windows__indexes', ... 
                'iDTB__windows__is_ok', ... 
                'iDTB__windows__winv', ...                 
                'iDTB__windows__wine', ... 
                'iDTB__windows__winn', ... 
                'iDTB__windows__fftv', ... 
                'iDTB__windows__ffte', ... 
                'iDTB__windows__fftn', ... 
                'iDTB__windows__info', ...                 
                ...%%   DTB__elab_parameters        
                'iDTB__elab_parameters__status', ...
                'iDTB__elab_parameters__hvsr_strategy', ...
                'iDTB__elab_parameters__hvsr_freq_min', ...
                'iDTB__elab_parameters__hvsr_freq_max', ...
                'iDTB__elab_parameters__windows_width', ...
                'iDTB__elab_parameters__windows_overlap', ...
                'iDTB__elab_parameters__windows_tapering', ...
                'iDTB__elab_parameters__windows_sta_vs_lta', ...
                'iDTB__elab_parameters__windows_pad', ...
                'iDTB__elab_parameters__smoothing_strategy', ...
                'iDTB__elab_parameters__smoothing_slider_val', ...
                ...% filter
                'iDTB__elab_parameters__filter_id', ... 
                'iDTB__elab_parameters__filter_name', ... 
                'iDTB__elab_parameters__filter_order', ...
                'iDTB__elab_parameters__filterFc1', ...
                'iDTB__elab_parameters__filterFc2', ...
                'iDTB__elab_parameters__data_to_use', ...
                'iDTB__elab_parameters__THEfilter', ...
                ...%%   DTB__section
                'iDTB__section__Min_Freq', ...
                'iDTB__section__Max_Freq', ...
                'iDTB__section__Frequency_Vector', ...
                ...
                'iDTB__section__V_windows', ... 
                'iDTB__section__E_windows', ...
                'iDTB__section__N_windows', ... 
                ...
                'iDTB__section__Average_V', ... 
                'iDTB__section__Average_E', ... ;
                'iDTB__section__Average_N', ...
                ...
                'iDTB__section__HV_windows', ... 
                'iDTB__section__EV_windows', ...
                'iDTB__section__NV_windows', ...
                ...%%  DTB__hvsr
                'iDTB__hvsr__curve_full', ... 
                ...%DTB{s,1}.hvsr.error_full', ... [];
                'iDTB__hvsr__confidence95_full', ... 
                'iDTB__hvsr__curve_EV_full', ...
                'iDTB__hvsr__curve_NV_full', ...
                ...
                'iDTB__hvsr__EV_all_windows', ...
                'iDTB__hvsr__NV_all_windows', ...
                'iDTB__hvsr__HV_all_windows', ...
                'iDTB__hvsr__curve', ...
                ...        %DTB{s,1}.hvsr.error', ... [];
                'iDTB__hvsr__confidence95', ...
                'iDTB__hvsr__standard_deviation', ...
                'iDTB__hvsr__curve_EV', ...
                'iDTB__hvsr__curve_NV', ...
                ...
                'iDTB__hvsr__peaks_idx', ... 
                'iDTB__hvsr__hollows_idx', ...
                'iDTB__hvsr__user_additional_peaks', ...
                'iDTB__hvsr__user_main_peak_frequence', ...
                'iDTB__hvsr__user_main_peak_amplitude', ...
                'iDTB__hvsr__user_main_peak_id_full_curve', ...
                'iDTB__hvsr__user_main_peak_id_in_section', ...
                'iDTB__hvsr__auto_main_peak_frequence', ... 
                'iDTB__hvsr__auto_main_peak_amplitude', ... 
                'iDTB__hvsr__auto_main_peak_id_full_curve', ... 
                'iDTB__hvsr__auto_main_peak_id_in_section', ... 
                ...%%   DTB__hvsr180
                'iDTB__hvsr180__angle_id', ... 
                'iDTB__hvsr180__angles', ... 
                'iDTB__hvsr180__angle_step', ... 
                'iDTB__hvsr180__spectralratio', ...
                'iDTB__hvsr180__preferred_direction', ... 
                ...%%   DTB__well
                'iDTB__well__well_id', ... 
                'iDTB__well__well_name', ...
                'iDTB__well__bedrock_depth__KNOWN', ... 
                'iDTB__well__bedrock_depth_source', ... 
                'iDTB__well__bedrock_depth__COMPUTED', ... 
                'iDTB__well__bedrock_depth__IBS1999', ... 
                'iDTB__well__bedrock_depth__PAROLAI2002', ...
                'iDTB__well__bedrock_depth__HINZEN2004');   
                
                fprintf('..OK\n')
            end
            %
            newid=0;
            for iia=1:N_hv_in_profile
                ii =P.profile_ids{P.profile.id,1}(iia,1);
                newid = newid+1;
                fprintf('Store data %d/%d  as ID %d/%d',ii,Global_NN, newid,NN) 
                datname = strcat(thispath,name,'_data_',num2str(newid),'of',sNN,'.mat');
                iDDAT1 = DDAT{ii,1};
                iDDAT2 = DDAT{ii,2};
                iDDAT3 = DDAT{ii,3};
                iFDAT1 = [];
                iFDAT2 = [];
                iFDAT3 = [];
                if ~isempty(FDAT)
                    if (~isempty(FDAT{ii,1})) && (~isempty(FDAT{ii,2})) && (~isempty(FDAT{ii,3}))
                        iFDAT1 = FDAT{ii,1};
                        iFDAT2 = FDAT{ii,2};
                        iFDAT3 = FDAT{ii,3};
                    end
                end
                save(datname, 'iDDAT1', 'iDDAT2', 'iDDAT3',  'iFDAT1', 'iFDAT2', 'iFDAT3');
                fprintf('OK\n')
            end
            is_done();
            fprintf('[Profile stand-alone Elaboration saved]\n')
        end             
    end
%% TAB 5 ====================== 3D Views
    function CB_TAB_create_reference_scales(~,~,~)
        if ~isempty(SURVEYS)
            %% Generate a reference Frequence scale
            %fprintf('call to: CB_TAB_create_reference_scales\n')
            %fprintf('            will prepare common reference scales for 3D-view\n')
            % each dataset may have a different frequency sampling and band
            Ndat = size(SURVEYS,1);
            %
            tempfmin = 1e30;
            for s=1:Ndat%investigate all surveys
                temp=DTB__section__Min_Freq(s,1);
                if ~isempty(temp)
                    if temp<tempfmin
                        tempfmin = temp;
                    end
                end
            end
            tempfmax = -1e30;
            for s=1:Ndat%investigate all surveys
                temp=DTB__section__Max_Freq(s,1);
                if ~isempty(temp)
                    if temp>tempfmax
                        tempfmax = temp;
                    end
                end
            end
            %
            %
            %
            if ~isempty(tempfmin) && ~isempty(tempfmax)
                fmin = tempfmin;
                fmax = tempfmax;
                %
                % minimum df
                mindf = 1e30;
                mindf_found = 0;
                for s=2:Ndat%investigate all surveys
                    if ~isempty(DTB__section__Frequency_Vector{s,1})
                        temp = DTB__section__Frequency_Vector{s,1}(3);
                        if temp<mindf
                            mindf = temp;
                            mindf_found = 1;
                        end
                    end
                end

                if mindf_found == 1
                    %P.Reference_Freq_scale= fmin:mindf:fmax;
                    % substitute reference scale with a pre-defined, adjustable in future (DEVELOPMENT)
                    % simpler version
                    %
                    %         A =   0.1 : 0.1 :   0.9;
                    %         B =   1   : 1.5 :  200;
                    %         C = 100   : 2.5 : 200;
                    %         tmp = [A,B,C];
                    %             A = logspace(-2,0,50);
                    %             B = logspace(0,2,100); A=A(1:(end-1));
                    %             tmp = [A,B];
                    tmp = 0.1:0.025:300;
                    imin = 1;
                    imax = length(tmp);
                    dmin = 1000000000;
                    dmax = 1000000000;
                    %
                    for ii=1:length(tmp)
                        if abs(tmp(ii)-fmin) < dmin
                            imin = ii;
                            dmin = abs(tmp(ii)-fmin);
                        end
                        if abs(tmp(ii)-fmax) < dmax
                            imax = ii;
                            dmax = abs(tmp(ii)-fmax);
                        end
                    end
                    P.Reference_Freq_scale = tmp(imin:imax);
                    %% Compute Global amplitude range
                    Amin =  10e16;
                    Amax = -10e16;
                    for ii = 1:size(DTB__status,1)
                        if ~isnan(DTB__hvsr__user_main_peak_amplitude(ii,1))
                            Amp = DTB__hvsr__user_main_peak_amplitude(ii,1);
                        else
                            Amp = DTB__hvsr__auto_main_peak_amplitude(ii,1);
                        end
                        if Amax<Amp
                            Amax = Amp;
                        end
                        if Amp<Amin
                            Amin = Amp;
                        end
                    end
                    P.Flags.Global_MAX_Amplitude = Amax;
                    P.Flags.Global_MIN_Amplitude = Amin;
                    %% -------------
                end
            end
        end
    end
    function BT_show_plot3graph(~,~,mode)
        % parameter_id = 1:  ferquence as Z, direction
        if P.isshown.id_Vf ==0; P.isshown.id_Vf = 1; end
        Graphics_3dView_quiver(0, mode);
        P.Flags.View_3D_current_mode = 3;% quiver
        P.Flags.View_3D_current_submode = mode;
    end
    function CB_view3d_surfaces_discretization(~,~,~)
        prompt = {'X','Y'};
        def = {num2str(P.TAB_view3d_Discretization(1)), num2str(P.TAB_view3d_Discretization(2))};
        answer = inputdlg(prompt,'Set discretization',1,def);
        if(~isempty(answer))
            A = str2double(answer{1});
            B = str2double(answer{2});
            if A>9
                P.TAB_view3d_Discretization(1) = A;
            end
            if B>9
                P.TAB_view3d_Discretization(2) = B;
            end
            plots_3D_update();
        end
    end
    %
    function CB_hAx_geo_back_Vf(~,~,~)
        if isempty(SURVEYS); return; end
        %
        %
        Ndat = size(SURVEYS,1);
        val = P.isshown.id_Vf;
        switch(P.isshown.id_Vf)
            case 0; val = Ndat;
            case 1; val = Ndat;
            otherwise; val = val -1;
        end
        P.isshown.id_Vf= val;
        plots_3D_update();
    end
    function CB_hAx_geo_next_Vf(~,~,~)
        if isempty(SURVEYS); return; end
        %
        %
        Ndat = size(SURVEYS,1);
        val = P.isshown.id_Vf;
        switch(P.isshown.id_Vf)
            case 0; val = 1;
            case Ndat; val = 1;
            otherwise; val = val +1;
        end
        P.isshown.id_Vf= val;
        plots_3D_update();
    end
    function CB_hAx_geo_goto_Vf(~,~,~)
        if isempty(SURVEYS); return; end
        %
        %
        Ndat = size(SURVEYS,1);
        prompt = {'Select Measurement ID'};
        def = {'0'};
        answer = inputdlg(prompt,'Unite with next',1,def);
        if(~isempty(answer))
            val = str2double(answer{1});
            if 0<val && val<=Ndat
                P.isshown.id_Vf= val;
                plots_3D_update();
            end
        end
    end
    %
    function CB_3Dview_daspect(~,~,~)
        P.Flags.View_3D_daspect = get(T5_daspect,'Value');
    end
    function CB_3Dview_box(~,~,~)
        P.Flags.View_3D_box = get(T5_box,'Value');
    end
    function CB_3Dview_grid(~,~,~)
        P.Flags.View_3D_grid = get(T5_grid,'Value');
    end
    function CB_TAB_3D_views_Update(~,~,~)
        plots_3D_update();
    end
%% TAB-6 ====================== Ibs-von Seht & Wolemberg
    function CB_TAB_update_IBSeW_statistics(~,~,~)
        if ~isempty(SURVEYS)
            %fprintf('call to: CB_TAB_update_IBSeW_statistics\n')
            is_busy();
            Update_IBSeW_statistics();
            is_drawing();
            Graphics_IBSeW_plot_regression(0);
            is_done();
        end
    end
    function Update_IBSeW_statistics()
        clc
        % get known bedrock and corresponding F0
        Nhv = size(DTB__status,1);
        F0_list_known = zeros(Nhv,1);
        HH_list_known = zeros(Nhv,1);% bedrock depths
        F0_list_UNknown = zeros(Nhv,1);
        ID_list_UNknown = zeros(Nhv,1);% ID's of computed bedrock depths locations 
        cc=0;
        cu=0;
        used_hv = 0;
        for d = 1:Nhv% retrieve a list of f0-H pairs
            if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                Fo = DTB__hvsr__user_main_peak_frequence(d,1);% user selection is always preferred
            else
                Fo = DTB__hvsr__auto_main_peak_frequence(d,1);
            end
            con1 = ~isnan(Fo);% main resonant frequence exist
            con2 = strcmp(DTB__well__bedrock_depth_source{d,1},'lithology in file');% bedrock depth from file
            con3 = strcmp(DTB__well__bedrock_depth_source{d,1},'manual') && (DTB__well__bedrock_depth__KNOWN{d,1}>0);% bedrock depth not from file, but manually set
            % ----------------
            DTB__well__bedrock_depth__COMPUTED{d,1}    = DTB__well__bedrock_depth__KNOWN{d,1};% copy computed bedrock depths
            DTB__well__bedrock_depth__IBS1999{d,1}     = DTB__well__bedrock_depth__KNOWN{d,1};
            DTB__well__bedrock_depth__PAROLAI2002{d,1} = DTB__well__bedrock_depth__KNOWN{d,1};
            DTB__well__bedrock_depth__HINZEN2004{d,1}  = DTB__well__bedrock_depth__KNOWN{d,1};
            % ---------------
            if DTB__status(d,1) ~= 2% is excluded: ie will not partecipate i H-F0 pairs
                used_hv = used_hv +1;
                if  con1% F0 exist
                    if  (con2 || con3)
                        % depth is known
                        cc=cc+1;
                        F0_list_known(cc) = Fo;
                        HH_list_known(cc) = DTB__well__bedrock_depth__KNOWN{d,1};% bedrock depths  
                    else
                        % depth is unknown
                        cu=cu+1;
                        F0_list_UNknown(cu) = Fo;
                        ID_list_UNknown(cu) = d;
                    end
                end
            end
        end
        if cc>2 % otherwise regression makes no sense
            F0_list_known   = F0_list_known(1:cc);
            HH_list_known   = HH_list_known(1:cc);
            ID_list_UNknown = ID_list_UNknown(1:cu);
            F0_list_UNknown = F0_list_UNknown(1:cu);

            %
            %% COMPUTED use distributions to infer depth at other points
            P.regression_computed = [];
            if cc>3 % otherwise regression makes no sense
                % regression
                [aval,bval] = Pfiles__Ibs_Von_Seht_Like__regression(F0_list_known, HH_list_known);
                P.regression_computed = [aval,bval];
                %
                [HH_list_UNknown] = Pfiles__Ibs_Von_Seht_Like__HfromF(F0_list_UNknown,aval,bval);
                for ii = 1:cu
                    idd = ID_list_UNknown(ii);
                    DTB__well__bedrock_depth__COMPUTED{idd,1} = HH_list_UNknown(ii);% copy computed bedrock depths
                end
            end
            %% Ibs-von Seht and Wohlenberg 1999
            aval = P.regression_Ibs_von_Seht_1999(1);
            bval = P.regression_Ibs_von_Seht_1999(2);
            [THH1] = Pfiles__Ibs_Von_Seht_Like__HfromF(F0_list_UNknown,aval,bval);
            for ii = 1:cu
                idd = ID_list_UNknown(ii);
                DTB__well__bedrock_depth__IBS1999{idd,1} = THH1(ii);
            end
            %% Parolai et al. (2002)	108.0	?1.551
            aval = P.regression_Parolai_2002(1);
            bval = P.regression_Parolai_2002(2);
            [THH2] = Pfiles__Ibs_Von_Seht_Like__HfromF(F0_list_UNknown,aval,bval);
            for ii = 1:cu
                idd = ID_list_UNknown(ii);
                DTB__well__bedrock_depth__PAROLAI2002{idd,1} = THH2(ii);
            end
            %% Hinzen et al. (2004)	137.0	?1.190
            aval = P.regression_Hinzen_2004(1);
            bval = P.regression_Hinzen_2004(2);
            [THH3] = Pfiles__Ibs_Von_Seht_Like__HfromF(F0_list_UNknown,aval,bval);
            for ii = 1:cu
                idd = ID_list_UNknown(ii);
                DTB__well__bedrock_depth__HINZEN2004{idd,1} = THH3(ii);
            end
            %
            %Graphics_IBSeW_plot_regression(0);% plot distributions
            %Graphics_IBSeW_plot_depths(0);% plot obtained depths
            P.Flags.IBSeW_successful = 1;
            mssg = strcat('[F0-H pairs = ',num2str(cc),']    [Unknown H = ',num2str(cu),']');
            set(IBSmessage,'String',mssg)
        else
            cla(hAx_IBS2);
            P.Flags.IBSeW_successful = 0;
            mssg = 'Information insufficient to use IBS&W function';
            set(IBSmessage,'String',mssg)
            fprintf(strcat('MESSAGE: ',mssg,'.\n'))
            fprintf('Number of F0         = %d/%d\n',cc+cu, used_hv)
            fprintf('Number of F0-H pairs = %d/%d   (minimum 3)\n',cc, used_hv)
            fprintf('Number of unknown H  = %d/%d\n',cu, used_hv)
        end
    end
    function CB_manual_bedrock_depth(~,~,~)
        is_busy();
        %fprintf('call:CB_manual_bedrock_depth\n')        
        DTB__well__bedrock_depth__KNOWN{P.isshown.id,1} = str2double( get(T6_PA_BedrockDepth,'String') );
        DTB__well__bedrock_depth_source{P.isshown.id,1} = 'manual'; 
        %
        Update_IBSeW_statistics();
        if P.Flags.IBSeW_successful
            is_drawing();
            Graphics_IBSeW_plot_regression(0);
            Graphics_IBSeW_plot_depths(0);
        end
        Update_wells_info();
        is_done();
    end
    function CB_reset_bedrock_depth(~,~,~)     
        if P.isshown.id==0; return; end
        is_busy();
        %fprintf('call:CB_reset_bedrock_depth\n')        
        DTB__well__well_id(P.isshown.id,1) = 0;
        DTB__well__bedrock_depth_source{P.isshown.id,1} = 'n.a';
        DTB__well__bedrock_depth__KNOWN{P.isshown.id,1} = 'n.a.';
        %
        Update_IBSeW_statistics();
        if P.Flags.IBSeW_successful
            is_drawing();
            Graphics_IBSeW_plot_regression(0);
            Graphics_IBSeW_plot_depths(0);
        end
        Update_wells_info();
        is_done();
    end
    function CB_TAB_IBSeW_Update(~,~,~)
        if ~isempty(SURVEYS)
            %fprintf('call to: CB_TAB_update_IBSeW_statistics\n')
            is_busy();
            Update_IBSeW_statistics()
            if P.Flags.IBSeW_successful    
                is_drawing();
                Graphics_IBSeW_plot_regression(0);
                Graphics_IBSeW_plot_depths(0)
            end
            is_done();
        end
    end
    function CB_regression(~,~,~)
        is_drawing();
        Graphics_IBSeW_plot_regression(0);
        if P.Flags.IBSeW_successful
            Graphics_IBSeW_plot_depths(0);
        end
        is_done();
    end
    function CB_IVSeW_surfaces_discretization(~,~,~)
        is_drawing();
        prompt = {'X','Y'};
        def = {num2str(P.TAB_IBSeW_Discretization(1)), num2str(P.TAB_IBSeW_Discretization(2))};
        answer = inputdlg(prompt,'Set discretization',1,def);
        if(~isempty(answer))
            A = str2double(answer{1});
            B = str2double(answer{2});
            if A>9
                P.TAB_IBSeW_Discretization(1) = A;
            end
            if B>9
                P.TAB_IBSeW_Discretization(2) = B;
            end
        end
       Graphics_IBSeW_plot_depths(0);
       is_done();
    end
%% EXTRA ======================
    function CB_figure_all_hvsr(~,~,~)
        xmode = 0;
        figure('name','All HVSR');
        Ncrv = size(SURVEYS,1);
        colrs = Pfunctions__get_rgb_colors(Ncrv);% windows-colors
        nplots = 0;
        lgnd = cell(Ncrv,1);
        for ii = 1:Ncrv
            if ~isempty(DTB__section__Frequency_Vector{ii,1})% Fvec must be setted
                df = DTB__section__Frequency_Vector{ii,1}(3);
                Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
                HV = DTB__hvsr__curve{ii,1};
                %
                clr = colrs(ii,:);
                if xmode==0
                    semilogx(gca,Fvec, HV,'Color',clr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(gca,Fvec, HV,'Color',clr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(gca,'on');
                drawnow
                nplots = nplots+1;
                lgnd{nplots,1}=strcat('hv-',num2str(ii));
            end 
        end
        lgnd = lgnd(1:nplots);
        legend(lgnd);
    end% function
%%
%% *********************** MORE FUNCTIONS *********************************
%% INITs and Updates
    function INIT_tool_variables()
        fprintf('...init tool variables.\n')
        INIT_DATA_RELATED();
        INIT_LOCATIONS();
        fprintf('init done !!\n')
    end
    function INIT_LOCATIONS() % does nothing
        Np = size(SURVEYS,1);
        receiver_locations = zeros(Np,3);
        for p = 1:Np
            receiver_locations(p,1:3) = SURVEYS{p,1};
        end
        pointslist = [receiver_locations; TOPOGRAPHY];
        if size(pointslist,1)==1
            mins = 0.975*pointslist;
            maxs = 1.025*pointslist;
        else
            mins = min(pointslist);
            maxs = max(pointslist);
        end
%         survey_boundingboox = [ ...
%                 mins(1), maxs(1), ...
%                 mins(2), maxs(2), ...
%                 mins(3), maxs(3), ...
%                 ];% xmin, xmax, ymin, ymax
        ddd=min([(maxs(1)-mins(1)), (maxs(2)-mins(2))])/10;
        reference_system = [mins(1),mins(2),ddd];
        %
        %         % reciprocal weighted distances
        %         r_reciprocicity = zeros(Np);
        %         for pi = 1:Np
        %             for pj = 1:Np
        %                 if(pj>pi)% upper triangular matrix
        %                     r_reciprocicity(pi,pj) = sqrt( sum( (receiver_locations(pi,:)-receiver_locations(pj,:)).^2 ) );
        %                     r_reciprocicity(pj,pi) = r_reciprocicity(pi,pj);
        %                 end
        %             end
        %         end
        %
        %         %minimum distance: weight = 1.0
        %         % weight = 0.1
        %         r_reciprocicity = r_reciprocicity/max(max(r_reciprocicity));% normal: 1 = maximum distance
        %         r_reciprocicity = 1.1-r_reciprocicity;
        %         r_reciprocicity = r_reciprocicity - 1.1*eye(Np);
        %         r_reciprocicity = r_reciprocicity/max(max(r_reciprocicity));
    end
    function INIT_DATA_RELATED()
        Nsurveys = size(SURVEYS,1);
        %
        %%   DTB__status
        DTB__status = ones(Nsurveys,1);%                                   v2.0.0   
        DTB__elaboration_progress = zeros(Nsurveys,1);%                                   v2.0.0
        %%   DTB__windows.
        DTB__windows__info = zeros(Nsurveys,6);%                                   v2.0.0 
        DTB__windows__width_sec = ones(Nsurveys,1);%                       v2.0.0
        DTB__windows__number = ones(Nsurveys,1);%                          v2.0.0
        DTB__windows__number_fft = -ones(Nsurveys,1);%                     v2.0.0
        DTB__windows__indexes = cell(Nsurveys,1);%                         v2.0.0
        DTB__windows__is_ok   = cell(Nsurveys,1);%                         v2.0.0
        DTB__windows__winv = cell(Nsurveys,1);%                            v2.0.0
        DTB__windows__wine = cell(Nsurveys,1);%                            v2.0.0
        DTB__windows__winn = cell(Nsurveys,1);%                            v2.0.0
        DTB__windows__fftv = cell(Nsurveys,1);%                            v2.0.0
        DTB__windows__ffte = cell(Nsurveys,1);%                            v2.0.0
        DTB__windows__fftn = cell(Nsurveys,1);%                            v2.0.0
        %%   DTB__elab_parameters.
        DTB__elab_parameters__status = cell(Nsurveys,1);%       Filled later
        DTB__elab_parameters__hvsr_strategy = get(T2_PA_HV,'Value') *ones(Nsurveys,1);% picked from interface
        DTB__elab_parameters__hvsr_freq_min = default_values.frequence_min *ones(Nsurveys,1);
        DTB__elab_parameters__hvsr_freq_max = default_values.frequence_max *ones(Nsurveys,1);
        DTB__elab_parameters__windows_width = default_values.window_width *ones(Nsurveys,1);
        DTB__elab_parameters__windows_overlap = default_values.window_overlap_pc *ones(Nsurveys,1);
        DTB__elab_parameters__windows_tapering = default_values.tap_percent *ones(Nsurveys,1);
        DTB__elab_parameters__windows_sta_vs_lta = default_values.sta_lta_ratio *ones(Nsurveys,1);
        DTB__elab_parameters__windows_pad = cell(Nsurveys,1);
        DTB__elab_parameters__smoothing_strategy = get(T3_PA_wsmooth_strategy,'VAlue') *ones(Nsurveys,1);
        DTB__elab_parameters__smoothing_slider_val = get(T3_PD_smooth_slider,'Value') *ones(Nsurveys,1);
        %
        % filter
        DTB__elab_parameters__filter_id    = ones(Nsurveys,1);
        DTB__elab_parameters__filter_name  = cell(Nsurveys,1);%       Filled later
        DTB__elab_parameters__filter_order = NaN*ones(Nsurveys,1);
        DTB__elab_parameters__filterFc1    = NaN*ones(Nsurveys,1);
        DTB__elab_parameters__filterFc2    = NaN*ones(Nsurveys,1);
        DTB__elab_parameters__data_to_use  = zeros(Nsurveys,1);
        DTB__elab_parameters__THEfilter = cell(Nsurveys,1);
        %%   DTB__section.
        DTB__section__Min_Freq = 0.2 * ones(Nsurveys,1);
        DTB__section__Max_Freq = 100 * ones(Nsurveys,1);
        DTB__section__Frequency_Vector = cell(Nsurveys,1);
        %
        DTB__section__V_windows = cell(Nsurveys,1);
        DTB__section__E_windows = cell(Nsurveys,1);
        DTB__section__N_windows = cell(Nsurveys,1);
        %
        DTB__section__Average_V = cell(Nsurveys,1);
        DTB__section__Average_E = cell(Nsurveys,1);
        DTB__section__Average_N = cell(Nsurveys,1);% << compute_single_hv(dat_id)
        %
        DTB__section__HV_windows = cell(Nsurveys,1);
        DTB__section__EV_windows = cell(Nsurveys,1);
        DTB__section__NV_windows = cell(Nsurveys,1);
        %%   DTB__hvsr.
        DTB__hvsr__curve_full = cell(Nsurveys,1);
        %DTB{s,1}.hvsr.error_full = cell(Nsurveys,1);
        DTB__hvsr__confidence95_full = cell(Nsurveys,1);
        DTB__hvsr__curve_EV_full = cell(Nsurveys,1);
        DTB__hvsr__curve_NV_full = cell(Nsurveys,1);
        %
        DTB__hvsr__EV_all_windows = cell(Nsurveys,1);
        DTB__hvsr__NV_all_windows = cell(Nsurveys,1);
        DTB__hvsr__HV_all_windows = cell(Nsurveys,1);
        %
        DTB__hvsr__curve = cell(Nsurveys,1);
        %DTB{s,1}.hvsr.error = cell(Nsurveys,1);
        DTB__hvsr__confidence95 = cell(Nsurveys,1);
        DTB__hvsr__standard_deviation = cell(Nsurveys,1);
        DTB__hvsr__curve_EV = cell(Nsurveys,1);
        DTB__hvsr__curve_NV = cell(Nsurveys,1);
        %
        DTB__hvsr__peaks_idx = cell(Nsurveys,1);   %index of local maxima
        DTB__hvsr__hollows_idx = cell(Nsurveys,1);   %index of local minima
        DTB__hvsr__user_additional_peaks = cell(Nsurveys,1);% 190330 
        %
        DTB__hvsr__user_main_peak_frequence = NaN * ones(Nsurveys,1);
        DTB__hvsr__user_main_peak_amplitude = NaN * ones(Nsurveys,1);
        DTB__hvsr__user_main_peak_id_full_curve = NaN * ones(Nsurveys,1);
        DTB__hvsr__user_main_peak_id_in_section = NaN * ones(Nsurveys,1);
        %
        DTB__hvsr__auto_main_peak_frequence = NaN * ones(Nsurveys,1);
        DTB__hvsr__auto_main_peak_amplitude = NaN * ones(Nsurveys,1);
        DTB__hvsr__auto_main_peak_id_full_curve= NaN * ones(Nsurveys,1);
        DTB__hvsr__auto_main_peak_id_in_section = NaN * ones(Nsurveys,1);
        %
        %%   DTB__hvsr180.
        %       hvsr computed on 180 deg at a specified step
        %       clockwise? with respect to the north direction
        %       North here is assumed as positive Y axis and HVSR measurements are spposed to be
        %       performed all with the North-component of geophone
        %       oriented northworth
        DTB__hvsr180__angle_id = ones(Nsurveys,1);% 1 = option-1 in uicontrol: off
        DTB__hvsr180__angles = cell(Nsurveys,1);
        DTB__hvsr180__angle_step =zeros(Nsurveys,1);
        DTB__hvsr180__spectralratio = cell(Nsurveys,1);
        DTB__hvsr180__preferred_direction = cell(Nsurveys,1);
        %%   DTB__well.
        DTB__well__well_id = zeros(Nsurveys,1);% 1 = option-1 in uicontrol: off
        DTB__well__well_name = cell(Nsurveys,1);
        DTB__well__bedrock_depth__KNOWN = cell(Nsurveys,1);%       Filled later  % if  .well_name == ''; this depth must be computed, otherwise it is considered measured
        DTB__well__bedrock_depth_source = cell(Nsurveys,1);%       Filled later
        DTB__well__bedrock_depth__COMPUTED   = cell(Nsurveys,1);%       Filled later
        DTB__well__bedrock_depth__IBS1999          = cell(Nsurveys,1);%       Filled later
        DTB__well__bedrock_depth__PAROLAI2002= cell(Nsurveys,1);%       Filled later
        DTB__well__bedrock_depth__HINZEN2004  = cell(Nsurveys,1);%       Filled later
        %
        %% ----------------------------------------------------------------
        for s = 1:Nsurveys
            DTB__elab_parameters__status{s,1}       = 'Not confirmed';
            DTB__elab_parameters__windows_pad{s,1} = default_values.pad_length;
            DTB__elab_parameters__filter_name{s,1}  = 'none';
            %
            DTB__hvsr__user_additional_peaks{s,1} = [];
            %
            DTB__well__well_name{s,1}                                  = '';
            DTB__well__bedrock_depth__KNOWN{s,1}          = 'n.a.';
            DTB__well__bedrock_depth_source{s,1}               = 'n.a.';
            DTB__well__bedrock_depth__COMPUTED{s,1}   = 'n.a.';
            DTB__well__bedrock_depth__IBS1999{s,1}          = 'n.a.';
            DTB__well__bedrock_depth__PAROLAI2002{s,1} = 'n.a.';
            DTB__well__bedrock_depth__HINZEN2004{s,1}   = 'n.a.';
            %%
            sampling_frequences(s) = SURVEYS{s,3};
        end
        %% setup measurements-well connections
        for ww=1:size(WELLS,1)
            for datid = WELLS{ww,3}%data corresponding to well. Same well may be used for multiple HV measurements.
                DTB__well__well_id(datid,1)  = ww;% 1 = option-1 in uicontrol: off
                DTB__well__well_name{datid,1} = WELLS{ww,1};
                %
                if ~isempty(WLLS)
                    if ~isempty(WLLS{ww,1})% well has a descriptive file
                        DTB__well__bedrock_depth__KNOWN{datid,1} = sum(WLLS{ww,1}{2});
                        DTB__well__bedrock_depth_source{datid,1} = 'lithology in file';
                        % if  .well_name == ''; this depth must be computed, otherwise it is considered measured
                    else% well has no descriptive file (bedrock dept must set manually)
                        DTB__well__bedrock_depth__KNOWN{datid,1} = 'n.a.';
                        DTB__well__bedrock_depth_source{datid,1} = 'missing lithology file';
                    end
                end
            end
        end
    end% function
    function MASTER_RESET()
        clc
        fprintf('NEW LOAD...\n')
        %% Tool Variable
        SURVEYS    = {};                                % Surveys Description [location][file-name][sampling frequency]
        WELLS      = {};                                % drilled wells
        DDAT       = {};                                % Field Data          {a row for each data file, 3 (V, E, N) }
        FDAT       = {};                                % Filtered Field Data {a row for each data file, 3 (V, E, N) }
        TOPOGRAPHY = [];
        TOPOGRAPHY_file_name = '';
        WLLS       = {};
        receiver_locations     = [];                   % (3D) stations locations
        %
        BREAKS = [];%                                     breaks of the profile:
        %
        well_to_show                  = 0;
        %
        datafile_columns   = [1 2 3];% [V  EW  NS]
        datafile_separator = 'none';% in data files: separator between HEADER and DDAT
        %
        %
        %
        %% Data properties
        sampling_frequences = [];
        %
        %                                                                 must be smaller than this treshold.
        %% Database: DTB =================
        %%   DTB__status
        DTB__status = [];%                                            DTB{s,1}.status                     [N,1] vector
        DTB__elaboration_progress=[];%                      DTB{s,1}.alaboration_progress
        %%   DTB__windows
        DTB__windows__width_sec   = [];%         DTB{s,1}.windows.width_sec          [N,1] vector           
        DTB__windows__number      = [];%         DTB{s,1}.windows.number             [N,1] vector 
        DTB__windows__number_fft  = [];%         DTB{s,1}.windows.number_fft         [N,1] vector
        DTB__windows__indexes     = {};%         DTB{s,1}.windows.indexes            [element is a Nwin*2 matrix]
        DTB__windows__is_ok       = {};%         DTB{s,1}.windows.is_ok              [element is a Nwin*2 matrix]
        DTB__windows__winv        = {};%         DTB{s,1}.windows.winv               [element is a Nwin*nf matrix]                 
        DTB__windows__wine        = {};%         DTB{s,1}.windows.wine               [element is a Nwin*nf matrix]
        DTB__windows__winn        = {};%         DTB{s,1}.windows.winn               [element is a Nwin*nf matrix]
        DTB__windows__fftv        = {};%         DTB{s,1}.windows.fftv               [element is a Nwin*nf matrix]
        DTB__windows__ffte        = {};%         DTB{s,1}.windows.ffte               [element is a Nwin*nf matrix]
        DTB__windows__fftn        = {};%         DTB{s,1}.windows.fftn               [element is a Nwin*nf matrix]
        DTB__windows__info = [];%                DTB{s,1}.windows.info = [1 x 6];    [N,6] vector                   
        %%   DTB__elab_parameters        
        DTB__elab_parameters__status = {};%           DTB{s,1}.elab_parameters.status
        DTB__elab_parameters__hvsr_strategy = [];%    DTB{s,1}.elab_parameters.hvsr_strategy = get(T2_PA_HV,'Value');% picked from interface
        DTB__elab_parameters__hvsr_freq_min = [];%    DTB{s,1}.elab_parameters.hvsr_freq_min = default_values.frequence_min;
        DTB__elab_parameters__hvsr_freq_max = [];%    DTB{s,1}.elab_parameters.hvsr_freq_max = default_values.frequence_max;
        DTB__elab_parameters__windows_width = [];%    DTB{s,1}.elab_parameters.windows_width = default_values.window_width;
        DTB__elab_parameters__windows_overlap =  [];% DTB{s,1}.elab_parameters.windows_overlap = default_values.window_overlap_pc;
        DTB__elab_parameters__windows_tapering = [];% DTB{s,1}.elab_parameters.windows_tapering = default_values.tap_percent;
        DTB__elab_parameters__windows_sta_vs_lta=[];% DTB{s,1}.elab_parameters.windows_sta_vs_lta = default_values.sta_lta_ratio;
        DTB__elab_parameters__windows_pad = {};%      DTB{s,1}.elab_parameters.windows_pad = default_values.pad_length;
        DTB__elab_parameters__smoothing_strategy =[];%DTB{s,1}.elab_parameters.smoothing_strategy = get(T3_PA_wsmooth_strategy,'VAlue');
        DTB__elab_parameters__smoothing_slider_val=[];%DTB{s,1}.elab_parameters.smoothing_slider_val = get(T3_PD_smooth_slider,'Value');
            %
            % filter
        DTB__elab_parameters__filter_id = [];%            DTB{s,1}.elab_parameters.filter_id    = 1;
        DTB__elab_parameters__filter_name={};%            DTB{s,1}.elab_parameters.filter_name  = 'none';
        DTB__elab_parameters__filter_order=[];%           DTB{s,1}.elab_parameters.filter_order
        DTB__elab_parameters__filterFc1=[];%              DTB{s,1}.elab_parameters.filterFc1
        DTB__elab_parameters__filterFc2=[];%              DTB{s,1}.elab_parameters.filterFc2
        DTB__elab_parameters__data_to_use=[];%            DTB{s,1}.elab_parameters.data_to_use
        DTB__elab_parameters__THEfilter      ={};
        %%   DTB__section
        DTB__section__Min_Freq =[];%        DTB{s,1}.section.Min_Freq = 0.2;
        DTB__section__Max_Freq =[];%        DTB{s,1}.section.Max_Freq = 100;
        DTB__section__Frequency_Vector={};%        DTB{s,1}.section.Frequency_Vector = [];    [N*3 Matrix]
            %
        DTB__section__V_windows ={};%        DTB{s,1}.section.V_windows = [];% filled runtime
        DTB__section__E_windows ={};%        DTB{s,1}.section.E_windows = [];% filled runtime
        DTB__section__N_windows ={};%        DTB{s,1}.section.N_windows = [];% filled runtime
            %
        DTB__section__Average_V ={};%        DTB{s,1}.section.Average_V  = [];% filled runtime
        DTB__section__Average_E ={};%        DTB{s,1}.section.Average_E = [];% filled runtime
        DTB__section__Average_N ={};%        DTB{s,1}.section.Average_N = [];% filled runtime                    << compute_single_hv(dat_id)
            %
        DTB__section__HV_windows ={};%       DTB{s,1}.section.HV_windows = [];% filled runtime
        DTB__section__EV_windows ={};%       DTB{s,1}.section.EV_windows = [];% filled runtime
        DTB__section__NV_windows ={};%       DTB{s,1}.section.NV_windows = [];% filled runtime
        %%   DTB__hvsr
        DTB__hvsr__curve_full ={};%              DTB{s,1}.hvsr.curve_full
        %DTB{s,1}.hvsr.error_full = [];
        DTB__hvsr__confidence95_full={};%        DTB{s,1}.hvsr.confidence95_full
        DTB__hvsr__curve_EV_full ={};%           DTB{s,1}.hvsr.curve_EV_full
        DTB__hvsr__curve_NV_full={};%            DTB{s,1}.hvsr.curve_NV_full 
        %
        DTB__hvsr__EV_all_windows={};%           DTB{s,1}.hvsr.EV_all_windows
        DTB__hvsr__NV_all_windows={};%           DTB{s,1}.hvsr.NV_all_windows
        DTB__hvsr__HV_all_windows={};%           DTB{s,1}.hvsr.HV_all_windows
        %
        DTB__hvsr__curve={};%        DTB{s,1}.hvsr.curve
            %DTB{s,1}.hvsr.error = [];
        DTB__hvsr__confidence95={};%             DTB{s,1}.hvsr.confidence95 = [];
        DTB__hvsr__standard_deviation={};%    DTB{s,1}.hvsr.standard_deviation = [];
        DTB__hvsr__curve_EV={};%              DTB{s,1}.hvsr.curve_EV = [];
        DTB__hvsr__curve_NV={};%              DTB{s,1}.hvsr.curve_NV = [];
            %
        DTB__hvsr__peaks_idx={};%        DTB{s,1}.hvsr.peaks_idx = [];   %index of local maxima
        DTB__hvsr__hollows_idx={};%        DTB{s,1}.hvsr.hollows_idx = [];   %index of local minima
        DTB__hvsr__user_additional_peaks = {};% 190330
        %
        DTB__hvsr__user_main_peak_frequence = [];%        DTB{s,1}.hvsr.user_main_peak_frequence = NaN;
        DTB__hvsr__user_main_peak_amplitude = [];%        DTB{s,1}.hvsr.user_main_peak_amplitude = NaN;
        DTB__hvsr__user_main_peak_id_full_curve = [];%         DTB{s,1}.hvsr.hvsr.user_main_peak_id_full_curve = NaN; <<<<<< ISSUE
        DTB__hvsr__user_main_peak_id_in_section = [];%        DTB{s,1}.hvsr.hvsr.user_main_peak_id_in_section = NaN;  <<<<<< ISSUE
        DTB__hvsr__auto_main_peak_frequence= [];%        DTB{s,1}.hvsr.auto_main_peak_frequence = NaN;
        DTB__hvsr__auto_main_peak_amplitude= [];%        DTB{s,1}.hvsr.auto_main_peak_amplitude = NaN;
        DTB__hvsr__auto_main_peak_id_full_curve= [];%        DTB{s,1}.hvsr.auto_main_peak_id_full_curve= NaN;
        DTB__hvsr__auto_main_peak_id_in_section= [];%;        DTB{s,1}.hvsr.auto_main_peak_id_in_section = NaN;
        %
        %%   DTB__hvsr180
        DTB__hvsr180__angle_id = [];%        DTB{s,1}.hvsr180.angle_id = 1;% 1 = option-1 in uicontrol: off
        DTB__hvsr180__angles = {};%        DTB{s,1}.hvsr180.angles = [];
        DTB__hvsr180__angle_step = [];%        DTB{s,1}.hvsr180.angle_step = 0;
        DTB__hvsr180__spectralratio = {};%        DTB{s,1}.hvsr180.spectralratio = [];
        DTB__hvsr180__preferred_direction = {};%        DTB{s,1}.hvsr180.preferred_direction = [];
        %%   DTB__well
        DTB__well__well_id=[];%       DTB{s,1}.well.well_id   = 0;% 1 = option-1 in uicontrol: off
        DTB__well__well_name={};%        DTB{s,1}.well.well_name = '';
        DTB__well__bedrock_depth__KNOWN={};%       DTB{s,1}.well.bedrock_depth__KNOWN      = 'n.a.';% if  .well_name == ''; this depth must be computed, otherwise it is considered measured
        DTB__well__bedrock_depth_source={};%       DTB{s,1}.well.bedrock_depth_source      = 'n.a.';
        DTB__well__bedrock_depth__COMPUTED={};%       DTB{s,1}.well.bedrock_depth__COMPUTED   = 'n.a.';
        DTB__well__bedrock_depth__IBS1999={};%       DTB{s,1}.well.bedrock_depth__IBS1999    = 'n.a.';
        DTB__well__bedrock_depth__PAROLAI2002={};%        DTB{s,1}.well.bedrock_depth__PAROLAI2002= 'n.a.';
        DTB__well__bedrock_depth__HINZEN2004={};%        DTB{s,1}.well.bedrock_depth__HINZEN2004 = 'n.a.';
        %% Database =====================END
        %
        % NEW AND TEMPORARY FEATURES xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        %    Reference models: vp  vs  rho  h  Qp  Qs
        REFERENCE_MODEL_dH       = [];
        REFERENCE_MODEL_zpoints  = [];
        %% Clear Graphics
        cla(hAx_main_geo); 
        cla(hAx_geo1); 
        cla(hAx_datV); 
        cla(hAx_datE); 
        cla(hAx_datN); 
        cla(hAx_geo2); 
        cla(hAx_speV); 
        cla(hAx_speE); 
        cla(hAx_speN); 
        cla(hAx_2DViews); 
        cla(hAx_3DViews); 
        cla(hAx_geo3); 
        cla(hAx_IBS1); 
        cla(hAx_IBS2);
    end
%% Graphic
%%    field geometry
    function Update_survey_locations(hhdl)   
        if nargin>0
            if (hhdl==hAx_main_geo) || (hhdl==hAx_geo1) || (hhdl==hAx_geo2) || (hhdl==hAx_geo3) 
                set(H.gui,'CurrentAxes',hhdl);
                hold(hhdl,'off')
                cla(hhdl)
            end
        else
            figure('name','Survey geometry');
            hhdl  = gca; 
        end
        axes(hhdl)
        hold(hhdl,'on')
        %  
        Nhv = size(SURVEYS,1);
        XY= zeros(Nhv,2);
        for ri = 1:Nhv; XY(ri,1:2) = SURVEYS{ri,1}(1:2); end
        Nwl = size(WELLS,1);
        XYw= zeros(Nwl,2);
        
        for ri = 1:Nwl; XYw(ri,1:2) = WELLS{ri,2}(1:2); end
        %% plot measuremet locations
        for p = 1:Nhv% show
            colr = 'k';
            strg = strcat(' R',num2str(p));
            if DTB__status(p,1) == 2% if locked, is grayed out
                colr = 0.7*[1 1 1];
            end    
            plot(XY(p,1), XY(p,2), 'marker','o','Color',colr,'markerfacecolor',colr,'markersize',8);
            hold(hhdl,'on')
            text(XY(p,1), XY(p,2), strg,'HorizontalAlignment','left');
        end
        %
        %% plot wells
        if ~isempty(WLLS)
            Nwls = size(WELLS,1);
            for p = 1:Nwls
                xwll = WELLS{p,2}(1);
                ywll = WELLS{p,2}(2);
                plot(hhdl, xwll, ywll, 'marker','square','Color','b','markerfacecolor','b','markersize',10);
                hold(hhdl,'on')
                %text(hhdl,xwll, ywll, strcat(' W',num2str(p)),'HorizontalAlignment','left');
                text(xwll, ywll, strcat(' W',num2str(p)),'HorizontalAlignment','left');
            end
        end
        %% plot selected data
        if (P.isshown.id> 0)% selected data
            plot(hhdl, XY(P.isshown.id,1),XY(P.isshown.id,2),'or', 'markersize',15);
            hold(hhdl,'on')
            % if(hhdl==hAx_geo1); set(T3_P1_txt,'String',SURVEYS{P.isshown.id,2}); end
            if(hhdl==hAx_main_geo)
                %                 text(hhdl, XY(P.isshown.id,1),XY(P.isshown.id,2), ...
                %                     strcat('F0[',num2str(Main_peaks(P.isshown.id,1)),']'));
                set(T1_PA_FileID,'string',num2str(P.isshown.id));
                set(T1_PC_datafile_txt,'String',strcat('ID',num2str(P.isshown.id),': ',SURVEYS{P.isshown.id,2}));
                set(T2_PB_datafile_txt,'String',strcat('ID',num2str(P.isshown.id),': ',SURVEYS{P.isshown.id,2}));
                set(T3_PB_datafile_txt,'String',strcat('ID',num2str(P.isshown.id),': ',SURVEYS{P.isshown.id,2}));
                set(T6_PB_datafile_txt,'String',strcat('ID',num2str(P.isshown.id),': ',SURVEYS{P.isshown.id,2}));
                %
                switch(DTB__status(P.isshown.id,1))
                    case 0
                        set(T2_PB_datafile_txt,'BackgroundColor','g');
                        set(T3_PB_datafile_txt,'BackgroundColor','g');
                        set(T6_PB_datafile_txt,'BackgroundColor','g');
                    case 2
                        set(T2_PB_datafile_txt,'BackgroundColor','r');
                        set(T3_PB_datafile_txt,'BackgroundColor','r');
                        set(T6_PB_datafile_txt,'BackgroundColor','r');
                    case 1
                        set(T2_PB_datafile_txt,'BackgroundColor',Status_bkground_color);
                        set(T3_PB_datafile_txt,'BackgroundColor',Status_bkground_color);
                        set(T6_PB_datafile_txt,'BackgroundColor',Status_bkground_color);
                end
                %
                fs = sampling_frequences(P.isshown.id);
                set(T1_PA_info_sampling_freq,'String', num2str(fs) );
                ns = size(DDAT{P.isshown.id, 1},1);
                Lt = (ns-1)/fs;
                stringis = strcat( num2str(Lt),'(s)  (',num2str(ns),') samples' );
                set(T1_PA_info_data_length,'String', stringis);
            end
            if (hhdl==hAx_geo3)
                Update_wells_info();
            end            
        end
        %% plot selected Well
        if ~isempty(WELLS)
            if (well_to_show > 0)% selected well
                well_x = WELLS{well_to_show,2}(1);
                well_y = WELLS{well_to_show,2}(2);
                plot(hhdl, well_x,well_y,'squarer', 'markersize',15);
                hold(hhdl,'on')
                % % %  err.               if(hhdl==hAx_geo1); set(T3_P1_txt,'String',SURVEYS{P.isshown.id,2}); end
                if(hhdl==hAx_main_geo); set(T1_PC_wellfile_txt,'String',WELLS{well_to_show,1}); end
                
            end
        end
        %% plot reference system
%         hold on
%         xx = (reference_system(1)+0.2*reference_system(3))*[1,1];
%         yy = (reference_system(2)+0.2*reference_system(3))*[1,1];
%         uu = [reference_system(3),0];
%         vv = [0,reference_system(3)];
%         quiver(hhdl, xx,yy,uu,vv)
        %% Plot additive topographycal points
        if ~isempty(TOPOGRAPHY)
            for p = 1:size(TOPOGRAPHY,1)% show
                plot(hhdl, TOPOGRAPHY(p,1), TOPOGRAPHY(p,2), 'diamond','Color','y','markerfacecolor','y','markersize',8);
                hold(hhdl,'on')
                text(TOPOGRAPHY(p,1), TOPOGRAPHY(p,2), num2str(p));%, strcat(' a',num2str(p)),'HorizontalAlignment','left');
            end
        end
        %% breaks
        if(~isempty(BREAKS))
            for b=1:length(BREAKS)
                if BREAKS(b)==1
                    x0=SURVEYS{b-1,1}(1);
                    x1=SURVEYS{b  ,1}(1);
                    xmid = (x1+x0)/2;
                    plot(hhdl, [xmid,xmid],[min(XY(:,2))-1, max(XY(:,2))+1]/4,'--r');% break line
                end
            end
        end
        
        hold(hhdl,'on')
        %         xlim(hhdl, [0.95*min([XY(:,1);XYw(:,1)]), 1.05*max([XY(:,1);XYw(:,1)])]);
        %         ylim(hhdl, [0.95*min([XY(:,2);XYw(:,2)]), 1.05*max([XY(:,2);XYw(:,2)])]);
        xlabel(hhdl, 'X (E-W)','fontweight','bold')
        ylabel(hhdl, 'Y (N-S)','fontweight','bold')
        grid(hhdl,'on')
        
        daspect(hhdl, P.data_aspectis_main)
        %% subset profile
        if(~isempty(P.profile_line))
            for ii=1:size(P.profile_line,1)
                if(~isempty(P.profile_line{ii,1}))
                    plot(hhdl, P.profile_line{ii,1}(:,1), P.profile_line{ii,1}(:,2),'r','linewidth',2); hold(hhdl,'on')
                    if strcmp(P.profile_name{ii,1},'none')
                        text(P.profile_line{ii,1}(end,1), P.profile_line{ii,1}(end,2),strcat('Prof.',num2str(ii))); hold(hhdl,'on')
                    else
                        text(P.profile_line{ii,1}(end,1), P.profile_line{ii,1}(end,2),strcat('(',num2str(ii),') ',P.profile_name{ii,1})); hold(hhdl,'on')
                    end
                end
            end
        end
        drawnow
    end
    function Update_profile_locations(hhdl)
        if nargin>0
            if (hhdl==hAx_main_geo)
                set(H.gui,'CurrentAxes',hhdl);
                hold(hhdl,'off')
                cla(hhdl)
            end
        else
            figure('name','Survey geometry');
            hhdl  = gca; 
            %get(h_fig,'CurrentAxes');
        end
        hold(hhdl,'on')
        %
        Nhv = size(SURVEYS,1);
        XY= zeros(Nhv,2);
        for ri = 1:Nhv; XY(ri,1:2) = SURVEYS{ri,1}(1:2); end
        
        hold(hhdl,'on')
        %% plot measuremet locations (color depending on profile)
        for p = 1:Nhv% show
            colr = [0 0 0];
            if ~isempty(P.profile_onoff{P.profile.id,1})
                if P.profile_onoff{P.profile.id,1}(p) == 1;  colr = [0.0 1.0 0.0];  end% Point is included in the profile
            end
            plot(XY(p,1), XY(p,2), 'marker','o','Color',colr,'markerfacecolor',colr,'markersize',8);
            hold(hhdl,'on')
            text(XY(p,1), XY(p,2), strcat(' R',num2str(p)),'HorizontalAlignment','left');
        end
        %% subset profile
        %plot(hhdl, P.profile_line{P.profile.id,1}(:,1), P.profile_line{P.profile.id,1}(:,2),'r','linewidth',2); hold(hhdl,'on')
        %text(P.profile_line{P.profile.id,1}(end,1), P.profile_line{P.profile.id,1}(end,2),strcat('Prof.',num2str(P.profile.id))); hold(hhdl,'on')
        if(~isempty(P.profile_line))
            for ii=1:size(P.profile_line,1)
                colr = 'k';
                linw = 1;
                if(~isempty(P.profile_line{ii,1}))
                    if ii==P.profile.id
                        colr = 'r';
                        linw = 2;
                    end
                    plot(hhdl, P.profile_line{ii,1}(:,1), P.profile_line{ii,1}(:,2),colr,'linewidth',linw); hold(hhdl,'on')
                    if strcmp(P.profile_name{ii,1},'none')
                        text(P.profile_line{ii,1}(end,1), P.profile_line{ii,1}(end,2),strcat('Prof.',num2str(ii))); hold(hhdl,'on')
                    else
                        text(P.profile_line{ii,1}(end,1), P.profile_line{ii,1}(end,2),strcat('(',num2str(ii),') ',P.profile_name{ii,1})); hold(hhdl,'on')
                    end
                end
            end
        end
        drawnow
    end
%%    various
    function [xmi,xma] = getxrange()
        k = waitforbuttonpress;
        if k == 0
            %disp('Button click')
            point1 = get(gca,'CurrentPoint');    % button down detected
            rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            p2 = max(point1,point2);             % calculate locations
            xmi = p1(1);
            offset = abs(p2-p1);
            xma = p1(1)+offset(1);
            
        end
    end
    function [xmi,xma, ymi,yma] = getxyrange()
        k = waitforbuttonpress;
        if k == 0
            %disp('Button click')
            point1 = get(gca,'CurrentPoint');    % button down detected
            rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            p2 = max(point1,point2);             % calculate locations
            %
            offset = abs(p2-p1);
            xmi = p1(1);
            xma = p1(1)+offset(1);
            %
            ymi = p1(2);
            yma = p1(2)+offset(2);
        end
    end
    function select_main_peak()
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        %
        %
        clc
        [xmi,xma] = getxrange();
        fprintf('Freq. range selected [%f][%f]\n',xmi,xma)
        if xmi==xma
            fprintf('Peak unsuccessful.\n')
            return; 
        end
        
        %         nf = P.ELAB_PARAMETERS{P.isshown.id,1}.WNDOWS_INFO(5);
        df = DTB__windows__info(P.isshown.id, 4);
        idx_shift = DTB__section__Frequency_Vector{P.isshown.id,1}(1);
        %
        ifmin = fix(xmi/df);% expressed on the full freq scale
        ifmax = fix(xma/df);
        %         df* (ifmin)
        %         df* (ifmax)
        %
        %local_idx = [ifmin:ifmax] - idx_shift +1;
        min_local_idx = ifmin - idx_shift +1;
        max_local_idx = ifmax - idx_shift +1;
        if min_local_idx < 1; min_local_idx =1; end
        if max_local_idx >size(DTB__hvsr__curve{P.isshown.id,1},1)
            max_local_idx =size(DTB__hvsr__curve{P.isshown.id,1},1);
        end
        local_idx = min_local_idx:max_local_idx;
        amax = max( DTB__hvsr__curve{P.isshown.id,1}(local_idx) );
        imax = find( DTB__hvsr__curve{P.isshown.id,1}(local_idx)== amax);
        imax = imax(1);
        imax = local_idx(imax);
        DTB__hvsr__user_main_peak_frequence(P.isshown.id,1) = df*(imax+idx_shift-1);
        DTB__hvsr__user_main_peak_amplitude(P.isshown.id,1) = amax;
        DTB__hvsr__user_main_peak_id_full_curve(P.isshown.id,1) = idx_shift+imax-1;
        DTB__hvsr__user_main_peak_id_in_section(P.isshown.id,1) = imax;
        
        
        Graphic_update_hvsr_average_curve(0);
    end
    function deselect_main_peak()
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        %
        DTB__hvsr__user_main_peak_frequence(P.isshown.id,1) = NaN;
        DTB__hvsr__user_main_peak_amplitude(P.isshown.id,1) = NaN;
        DTB__hvsr__user_main_peak_id_full_curve(P.isshown.id,1) = NaN;
        DTB__hvsr__user_main_peak_id_in_section(P.isshown.id,1) = NaN;
        Graphic_update_hvsr_average_curve(0);
    end
    function select_additional_peak()
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        %
        %
        clc
        [xmi,xma] = getxrange();
        fprintf('Freq. range selected [%f][%f]\n',xmi,xma)
        if xmi==xma
            fprintf('Peak unsuccessful.\n')
            return; 
        end
        
        %         nf = P.ELAB_PARAMETERS{P.isshown.id,1}.WNDOWS_INFO(5);
        df = DTB__windows__info(P.isshown.id, 4);
        idx_shift = DTB__section__Frequency_Vector{P.isshown.id,1}(1);
        %
        ifmin = fix(xmi/df);% expressed on the full freq scale
        ifmax = fix(xma/df);
        %         df* (ifmin)
        %         df* (ifmax)
        %
        %local_idx = [ifmin:ifmax] - idx_shift +1;
        min_local_idx = ifmin - idx_shift -1;
        max_local_idx = ifmax - idx_shift +1;
        if min_local_idx < 1; min_local_idx =1; end
        if max_local_idx >size(DTB__hvsr__curve{P.isshown.id,1},1)
            max_local_idx =size(DTB__hvsr__curve{P.isshown.id,1},1);
        end
        local_idx = min_local_idx:max_local_idx;
        amax = max( DTB__hvsr__curve{P.isshown.id,1}(local_idx) );
        imax = find( DTB__hvsr__curve{P.isshown.id,1}(local_idx)== amax);
        imax = imax(1);
        imax = local_idx(imax);
        valueset = [imax, (idx_shift+imax-1),  (df*(imax+idx_shift-1)),  amax];
        %ID in section
        %ID in full curve
        %frequence
        %amplitude
        if ~isempty(DTB__hvsr__user_additional_peaks{P.isshown.id})
            for p = 1:size(DTB__hvsr__user_additional_peaks{P.isshown.id},1)
                if DTB__hvsr__user_additional_peaks{P.isshown.id}(p,2)==valueset(2); return; end
            end
        end
        newvals =  [DTB__hvsr__user_additional_peaks{P.isshown.id} ;valueset ];
        DTB__hvsr__user_additional_peaks{P.isshown.id} = sortrows(newvals, 2);
        %
        Graphic_update_hvsr_average_curve(0);
    end
    function discard_last_additional_peak()
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        %
        if isempty(DTB__hvsr__user_additional_peaks{P.isshown.id,1}); return; end
        if size(DTB__hvsr__user_additional_peaks{P.isshown.id,1},1)==1
            DTB__hvsr__user_additional_peaks{P.isshown.id,1} = [];
            Graphic_update_hvsr_average_curve(0);
        else
            DTB__hvsr__user_additional_peaks{P.isshown.id,1} = DTB__hvsr__user_additional_peaks{P.isshown.id,1}(1:end-1,:);
            Graphic_update_hvsr_average_curve(0);
        end
    end
    function deselect_additional_peak()
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        %
        DTB__hvsr__user_additional_peaks{P.isshown.id,1} = [];
        Graphic_update_hvsr_average_curve(0);
    end
    function delete_curve_set(axid)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        %
        %
        [xmi,xma, ymi,yma] = getxyrange();
        df = DTB__windows__info(P.isshown.id, 4);
        idx_shift = DTB__section__Frequency_Vector{P.isshown.id,1}(1);
        %
        ifmin = fix(xmi/df);% expressed on the full freq scale
        ifmax = fix(xma/df);
        %         df* (ifmin)
        %         df* (ifmax)
        %local_idx = [ifmin:ifmax] - idx_shift +1;
        min_local_idx = ifmin - idx_shift +1;
        max_local_idx = ifmax - idx_shift +1;
        if min_local_idx < 1; min_local_idx =1; end
        if max_local_idx >size(DTB__hvsr__curve{P.isshown.id,1},1)
            max_local_idx =size(DTB__hvsr__curve{P.isshown.id,1},1);
        end
        local_idx = min_local_idx:max_local_idx;
        %
        Nwin = DTB__windows__number(P.isshown.id,1);
        for iw = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(iw)==1)
                switch axid
                    case 1; ampl = DTB__section__HV_windows{P.isshown.id,1}(local_idx,iw);% V
                    case 2; ampl = DTB__section__EV_windows{P.isshown.id,1}(local_idx,iw);% E
                    case 3; ampl = DTB__section__NV_windows{P.isshown.id,1}(local_idx,iw);% N
                end
                %
                if any(ymi<ampl) && any(ampl<yma)  
                    DTB__windows__is_ok{P.isshown.id,1}(iw)=0;
                end
            end
        end
        %
        Graphic_update_hvsr_all_curves(0);
    end
    function resume_curve_set(axid)
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        if DTB__windows__number(P.isshown.id,1)==0; return; end
        %
        %
        [xmi,xma, ymi,yma] = getxyrange();
        df = DTB__windows__info(P.isshown.id, 4);
        idx_shift = DTB__section__Frequency_Vector{P.isshown.id,1}(1);
        %
        ifmin = fix(xmi/df);% expressed on the full freq scale
        ifmax = fix(xma/df);
        %         df* (ifmin)
        %         df* (ifmax)
        %local_idx = [ifmin:ifmax] - idx_shift +1;
        min_local_idx = ifmin - idx_shift +1;
        max_local_idx = ifmax - idx_shift +1;
        if min_local_idx < 1; min_local_idx =1; end
        if max_local_idx >size(DTB__hvsr__curve{P.isshown.id,1},1)
            max_local_idx =size(DTB__hvsr__curve{P.isshown.id,1},1);
        end
        local_idx = min_local_idx:max_local_idx;
        %
        Nwin = DTB__windows__number(P.isshown.id,1);
        for iw = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(iw)==0)
                switch axid
                    case 1; ampl = DTB__section__HV_windows{P.isshown.id,1}(local_idx,iw);%  V
                    case 2; ampl = DTB__section__EV_windows{P.isshown.id,1}(local_idx,iw);% E
                    case 3; ampl = DTB__section__NV_windows{P.isshown.id,1}(local_idx,iw);% N
                end
                %
                if any(ymi<ampl) && any(ampl<yma)  
                    DTB__windows__is_ok{P.isshown.id,1}(iw)=1;
                end
            end
        end
        %
        Graphic_update_hvsr_all_curves(0);
    end
%%    gui
    function Graphic_Gui_update_elaboration_parameters()
        if (0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))
           
            %% Tab-1 (main)
            %>> warning('In Graphic_Gui_update_elaboration_parameters: chech to show parameter value and not slider value.')
            switch DTB__status(P.isshown.id,1)
                case 0
                    set(T1_PA_id     ,'BackgroundColor','g')
                    set(T1_PA_FileID ,'BackgroundColor','g')
                    set(T1_PA_status0,'BackgroundColor','g')
                    set(T1_PA_status ,'BackgroundColor','g')
                    %
                    set(T1_PA_status ,'String','Locked')
                case 1
                    set(T1_PA_id     ,'BackgroundColor',Status_bkground_color)
                    set(T1_PA_FileID ,'BackgroundColor',Status_bkground_color)
                    set(T1_PA_status0,'BackgroundColor',Status_bkground_color)
                    set(T1_PA_status ,'BackgroundColor',Status_bkground_color)
                    %
                    set(T1_PA_status ,'String','Unlocked')
                case 2
                    set(T1_PA_id     ,'BackgroundColor','r')
                    set(T1_PA_FileID ,'BackgroundColor','r')
                    set(T1_PA_status0,'BackgroundColor','r')
                    set(T1_PA_status ,'BackgroundColor','r')
                    %
                    set(T1_PA_status ,'String','Excluded')
            end
            %
            hvstring = get(T2_PA_HV, 'String');
            hvstring = hvstring{DTB__elab_parameters__hvsr_strategy(P.isshown.id,1), 1};
            set(T1_PA_hvsr_strategy,'String', hvstring);
            
            set(T1_PA_hvsr_freq_min,'String', DTB__section__Min_Freq(P.isshown.id,1) );
            set(T1_PA_hvsr_freq_max,'String', DTB__section__Max_Freq(P.isshown.id,1) );
            set(T1_PA_windows_width,'String', DTB__elab_parameters__windows_width(P.isshown.id,1));
            set(T1_PA_windows_overlap,'String', DTB__elab_parameters__windows_overlap(P.isshown.id,1));
            set(T1_PA_windows_tapering,'String', DTB__elab_parameters__windows_tapering(P.isshown.id,1));
            set(T1_PA_windows_sta_vs_lta,'String',DTB__elab_parameters__windows_sta_vs_lta(P.isshown.id,1));
            set(T1_PA_windows_pad,'String',DTB__elab_parameters__windows_pad{P.isshown.id,1});
            set(T1_PA_smoothing_strategy,'String', DTB__elab_parameters__smoothing_strategy(P.isshown.id,1));
            %set(T1_PA_smoothing_parameter_value,'String', DTB{P.isshown.id,1}.elab_parameters.smoothing_slider_val);% shown parameter, not the slider value
            
            % % set(T3_P1_angular_samp,'Value',DTB__hvsr180__angle_id(P.isshown.id,1));%{'off','45','30','15','10','5','2.5'}, ...
            anglestring = get(T3_P1_angular_samp,'String');%% correct
            anglestring = anglestring{DTB__hvsr180__angle_id(P.isshown.id,1), 1};
            set(T1_PA_angular_sampling,'String',anglestring);
            %% Tab-2 (Windowing)
            set(T2_PA_HV,'Value',DTB__elab_parameters__hvsr_strategy(P.isshown.id,1));%         HVSR strategy
            set(T3_P1_winsize,'String', DTB__elab_parameters__windows_width(P.isshown.id,1));%             Windows width
            set(T3_P1_winoverlap,'String', DTB__elab_parameters__windows_overlap(P.isshown.id,1));%             Windows overlap
            set(T3_P1_wintstaltaratio,'String', DTB__elab_parameters__windows_sta_vs_lta(P.isshown.id,1));%             Windows sta/lta
            if ~isempty(DTB__windows__info)
                if DTB__windows__info(P.isshown.id, 2)>0
                    ns_window = DTB__windows__info(P.isshown.id, 2);
                    pad0 = 2^nextpow2(ns_window);
                    set(T2_PD_win_samplespow2, 'String',num2str(pad0))
                else
                    set(T2_PD_win_samplespow2, 'String',' ')
                end
            else
                set(T2_PD_win_samplespow2, 'String',' ')
            end
            %% Tab-3 (Computations)
            set(hT3_PA_edit_fmin,'String', DTB__section__Min_Freq(P.isshown.id,1) );%         frequence range
            set(hT3_PA_edit_fmax,'String', DTB__section__Max_Freq(P.isshown.id,1) );
            set(T3_P1_wintapering,'String',DTB__elab_parameters__windows_tapering(P.isshown.id,1));%         >>> Windows tapering
            set(T3_P1_wpadto,'String', DTB__elab_parameters__windows_pad{P.isshown.id,1});%         >>> Padding
            
            smoothstring = get(T3_PA_wsmooth_strategy, 'String');
            smoothstring = smoothstring{DTB__elab_parameters__smoothing_strategy(P.isshown.id,1), 1};
            set(T1_PA_smoothing_strategy,'String', smoothstring);
            set(T3_PA_wsmooth_amount,'String', DTB__elab_parameters__smoothing_slider_val(P.isshown.id,1));% shown parameter, not the slider value
            %
            set(T3_PA_wsmooth_strategy,'Value', DTB__elab_parameters__smoothing_strategy(P.isshown.id,1));
            set(T3_PD_smooth_slider,'Value',DTB__elab_parameters__smoothing_slider_val(P.isshown.id,1));
            setup_smoothing_value();
            %
            set(T3_P1_angular_samp, 'Value',DTB__hvsr180__angle_id(P.isshown.id,1));%{'off','45','30','15','10','5','2.5'}  
            %
            % filter
            idfilter = DTB__elab_parameters__filter_id(P.isshown.id,1);
            set(T2_PA_filter,'Value',idfilter);
            switch idfilter
                case 1% OFF
                    set(T2_PA_dattoshow,'Value',1);
                    set(T2_PA_dattoshow,'Enable','off');
                    if isnan(DTB__elab_parameters__filterFc1(P.isshown.id,1)); set(T2_PA_filter_fmin,'String',' ','Enable','off'); end
                    if isnan(DTB__elab_parameters__filterFc2(P.isshown.id,1)); set(T2_PA_filter_fmax,'String',' ','Enable','off'); end
                    set(T2_PA_filter_show,'Enable','off');
                    set(T2_PA_dattoUSE, 'Enable','off');
                case 2% BANDPASS
                    set(T2_PA_filter_fmin,'String', num2str(DTB__elab_parameters__filterFc1(P.isshown.id,1)),'Enable','on'  );
                    set(T2_PA_filter_fmax,'String', num2str(DTB__elab_parameters__filterFc2(P.isshown.id,1)),'Enable','on'  );
                    set(T2_PA_filter_show,'Enable','on');
                    set(T2_PA_dattoUSE,   'Enable','on');
                case 3% LOWPASS
                    set(T2_PA_filter_fmin,'String', ' ','Enable','on' );
                    set(T2_PA_filter_fmax,'String', num2str(DTB__elab_parameters__filterFc2(P.isshown.id,1)),'Enable','on'  );
                    set(T2_PA_filter_show,'Enable','on');
                    set(T2_PA_dattoUSE,   'Enable','on');
                case 4% HIGHPASS
                    set(T2_PA_filter_fmin,'String', ' ','Enable','on' );
                    set(T2_PA_filter_fmax,'String', num2str(DTB__elab_parameters__filterFc2(P.isshown.id,1)),'Enable','on'  );
                    set(T2_PA_filter_show,'Enable','on'  );
                    set(T2_PA_dattoUSE,   'Enable','on');
            end
            % filtered data
            if ~isempty(FDAT)
               if ~isempty(FDAT{P.isshown.id,1})
                   set(T2_PA_dattoshow,'Enable','on')
                   set(T2_PA_dattoshow,'Value',2)
               end
            end
            
            
            %
            switch DTB__elab_parameters__data_to_use(P.isshown.id,1)% [1]STA/LTA [2]spectral ratios
                case 2% use filtered data in H/V
                     set(T2_PA_dattoUSE,'Value',2);% filtered
                otherwise
                    %[1] no filter in use OR use filtered data only STA/LTA windows selection
                    set(T2_PA_dattoUSE,'Value',1);% original
            end
            %
            if DTB__windows__number(P.isshown.id,1)==0 % prevent computing when not windowed 
                set(T2_PA_HV,              'Enable','off')
                set(hT3_PA_edit_fmin,      'Enable','off')
                set(hT3_PA_edit_fmax,      'Enable','off')
                set(T3_P1_wintapering,     'Enable','off')
                set(T3_P1_wpadto,          'Enable','off')
                set(T3_PA_wsmooth_strategy,'Enable','off')
                set(T3_PA_wsmooth_amount,  'Enable','off')
                set(T3_PD_smooth_slider,   'Enable','off')
                set(T3_P1_angular_samp,    'Enable','off')
                set(T3_compute_1,'Enable','off', 'String','THIS data needs Windowing')
            else
                set(T2_PA_HV,              'Enable','on')
                set(hT3_PA_edit_fmin,      'Enable','on')
                set(hT3_PA_edit_fmax,      'Enable','on')
                set(T3_P1_wintapering,     'Enable','on')
                set(T3_P1_wpadto,          'Enable','on')
                set(T3_PA_wsmooth_strategy,'Enable','on')
                set(T3_PA_wsmooth_amount,  'Enable','on')
                set(T3_PD_smooth_slider,   'Enable','on')
                set(T3_P1_angular_samp,    'Enable','on')
                set(T3_compute_1,'Enable','on',  'String','Run computing on THIS data')
            end
            %% =========================================================
        end
    end
%%    plot: data
    function Graphic_update_data(newfigure)
        if (0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))
            is_drawing();
            if(newfigure)
                hlocal=figure('name',strcat('Microtremor: ID=',num2str(P.isshown.id)));
                hgui = hlocal;
                h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_datV);% V
                h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_datE);% E
                h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_datN);% N
            else
                hgui = H.gui;
                h_ax(1) = hAx_datV;
                h_ax(2) = hAx_datE;
                h_ax(3) = hAx_datN;
                %
                set(T2_PD_win_samples,'String',num2str( DTB__windows__info(P.isshown.id,2) )); %  ns = n of samples. [ns, ns_window, ns_overlap,  df, n-frequences];
            end
            for ii = 1:3; cla(h_ax(ii)); end            
            %
            %% Show motion components
            if get(T2_PA_dattoshow,'Value')==1
                VV = DDAT{P.isshown.id,1};
                EE = DDAT{P.isshown.id,2};
                NN = DDAT{P.isshown.id,3};
                % fprintf('Original data shown\n')
            else
                VV = FDAT{P.isshown.id,1};
                EE = FDAT{P.isshown.id,2};
                NN = FDAT{P.isshown.id,3};
                % fprintf('Filteredl data shown\n')
            end
            dt = 1/sampling_frequences(P.isshown.id);
            timevector = dt*( 0 : (length(DDAT{P.isshown.id,1})-1) );
            %% V
            set(hgui,'CurrentAxes',h_ax(1));
            hold(h_ax(1),'off')
            plot(h_ax(1),timevector,VV,'k');
            hold(h_ax(1),'on')
            ylim([min(DDAT{P.isshown.id, 1}),  max(DDAT{P.isshown.id, 1})]);
            % title('V')
            set(get(h_ax(1),'YLabel'),'Rotation',0)
            ylabel('V','fontweight','bold')
            %% E
            set(hgui,'CurrentAxes',h_ax(2));
            hold(h_ax(2),'off')
            plot(h_ax(2),timevector,EE,'b');
            hold(h_ax(2),'on')
            ylim([min(DDAT{P.isshown.id, 2}),  max(DDAT{P.isshown.id, 2})]);
            set(get(h_ax(2),'YLabel'),'Rotation',0)
            ylabel('E-W','fontweight','bold')
            %% N
            set(hgui,'CurrentAxes',h_ax(3));
            hold(h_ax(3),'off')
            plot(h_ax(3),timevector,NN,'c');
            hold(h_ax(3),'on')
            ylim([min(DDAT{P.isshown.id, 3}),  max(DDAT{P.isshown.id, 3})]); %lta_V = mean( abs(DDAT{dat_id, 1}) );
            set(get(h_ax(3),'YLabel'),'Rotation',0)
            ylabel('N-S','fontweight','bold')
            xlabel('Time [s]','fontweight','bold')
            rangeVEN = [ ...
                min(VV), max(VV); ...
                min(EE), max(EE); ...
                min(NN), max(NN)];
%             rangeVEN = [ ...
%                 min(DDAT{P.isshown.id,1}), max(DDAT{P.isshown.id,1}); ...
%                 min(DDAT{P.isshown.id,2}), max(DDAT{P.isshown.id,2}); ...
%                 min(DDAT{P.isshown.id,3}), max(DDAT{P.isshown.id,3})];
            %% Show windows
            WIDX = DTB__windows__indexes{P.isshown.id,1};
            WIOK = DTB__windows__is_ok{P.isshown.id,1};
            if(~isempty(WIDX))
                Nwin = size(WIDX,1);
                colrs = Pfunctions__get_rgb_colors(Nwin);% windows-colors
                for s = 1:3
                    set(hgui,'CurrentAxes',h_ax(s));
                    %
                    ya = rangeVEN(s,1);
                    yb = rangeVEN(s,2);
                    ypatch = [ya ya yb yb];
                    %
                    for w = 1:Nwin
                        xa =dt*( WIDX(w,1) -1);
                        xb =dt*( WIDX(w,2) -1);
                        xpatch = [xa xb xb xa];
                        if WIOK(w)==1
                            p=patch(xpatch,ypatch, colrs(w,:) );
                            %                                 set(p,'FaceAlpha',0.5);
                        else
                            p=patch(xpatch,ypatch,'w');
                        end
                        set(p,'FaceAlpha',0.5);
                    end
                end
            end
            %
            if ~isempty(P.TAB_Windowing.hori_axis_limits__time)
                xlim(h_ax(1), P.TAB_Windowing.hori_axis_limits__time);
                xlim(h_ax(2), P.TAB_Windowing.hori_axis_limits__time);
                xlim(h_ax(3), P.TAB_Windowing.hori_axis_limits__time);
                % P.TAB_Windowing.hori_axis_limits__time % Tab computations, horizontal axis limits
            else
                tlim = [min(timevector), max(timevector)];
                xlim(h_ax(1), tlim);
                xlim(h_ax(2), tlim);
                xlim(h_ax(3), tlim);
            end
            ylim(h_ax(1), rangeVEN(1,:))
            ylim(h_ax(2), rangeVEN(2,:))
            ylim(h_ax(3), rangeVEN(3,:))
            %
            drawnow
            is_done();            
        end
    end
%%    plot: spectrums
    function Graphic_update_spectrums(newfigure)%% calls various visualizations
        cla(hAx_speV);
        cla(hAx_speE);
        cla(hAx_speN);
        %
        switch P.Flags.spectrum_mode
            case 0; Graphic_update_spectrum_of_windows(newfigure);
            case 1; Graphic_update_contour_of_windows(newfigure);
            case 2; Graphic_update_hvsr_of_windows(newfigure);
            case 3; Graphic_update_hvsr_contouring_of_windows(newfigure);
            case 4; Graphic_update_hvsr_average_curve(newfigure);
            case 5; Graphic_update_hvsr_H_V_Compare(newfigure);  
            case 6; Graphic_update_hvsr_all_curves(newfigure);
            case 7; Graphic_update_hvsr_180_windows(newfigure);
            case 8; Graphic_update_hvsr_180_curves(newfigure);
            otherwise; warning('SAM: Graphic_update_spectrums: mode unespected. NO ACTION PERFORMED');
        end
        %
        %% info on interface
        Ndata = size(SURVEYS,1);
        if Ndata < 1; return; end
        %
        %
        %% main peak value
        thisff = 'n.a.';
        ii = P.isshown.id;
        if ~isnan(DTB__hvsr__user_main_peak_frequence(ii,1))
            thisff = DTB__hvsr__user_main_peak_frequence(ii,1);% user selection is always preferred
            thisff = strcat( num2str(  fix(100*thisff)/100  ), ' Hz');
        else
            if ~isnan(DTB__hvsr__auto_main_peak_frequence(ii,1))
                thisff = DTB__hvsr__auto_main_peak_frequence(ii,1);
                thisff = strcat( num2str(  round(100*thisff)/100  ), ' Hz');
            end
        end
        set(h_ThisPeakHz,'string', thisff);
        %
        %% Toggle directional
        tflag = 'off'; 
        if DTB__hvsr180__angle_id(ii,1)~=1; tflag = 'on'; end% wasperformed
        set(T3_Option_4_1,'enable',tflag)
        set(T3_Option_4_2,'enable',tflag)
        %
        is_done();
        %
    end
    function Graphic_update_spectrum_of_windows(newfigure)%0        Spectrum tile
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        %
        mi = zeros(1,3);
        ma = zeros(1,3);
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        %
        if(newfigure)
            hlocal=figure('name',strcat('Spectrum of windows: ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
%             cla(h_ax(1));
%             cla(h_ax(2));
%             cla(h_ax(3));
        end
        %
        Wids = 1:DTB__windows__number(P.isshown.id,1);
        %% V
        set(hgui,'CurrentAxes',h_ax(1));
        DD = DTB__section__V_windows{P.isshown.id,1};
        DD = DD./max(max(abs(DD)));
        mi(1) = min(min(DD)); 
        ma(1) = max(max(DD));
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(1),Wids,Fvec,DD,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(1), 'YScale', 'log')
        else
            image(Wids,Fvec,DD, 'CDataMapping','scaled')
        end
        xlabel('(V) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% E
        set(hgui,'CurrentAxes',h_ax(2));
        DD = DTB__section__E_windows{P.isshown.id,1};
        DD = DD./max(max(abs(DD)));
        mi(2) = min(min(DD)); 
        ma(2) = max(max(DD));
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(2),Wids,Fvec,DD,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(2), 'YScale', 'log')
        else
            image(Wids,Fvec,DD, 'CDataMapping','scaled')
        end
        xlabel('(E-W) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% N
        set(hgui,'CurrentAxes',h_ax(3));
        DD = DTB__section__N_windows{P.isshown.id,1};
        DD = DD./max(max(abs(DD)));
        mi(3) = min(min(DD)); 
        ma(3) = max(max(DD));
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(3),Wids,Fvec,DD,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(3), 'YScale', 'log')
        else
            image(Wids,Fvec,DD, 'CDataMapping','scaled')
        end
        xlabel('(N-S) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% Show windows
        WIDS = DTB__windows__indexes{P.isshown.id,1};
        WOKS =DTB__windows__is_ok{P.isshown.id,1};
        if(~isempty(WIDS))
            ya = min(Fvec);
            yb = max(Fvec);
            ypatch = [ya ya yb yb];
            Nwin = size(WIDS,1);
            %colrs = Pfunctions__get_rgb_colors(Nwin);% windows-colors
            for s = 1:3
                set(hgui,'CurrentAxes',h_ax(s));
                %
                for w = 1:Nwin
                    xa = Wids(w)-0.5;
                    xb = Wids(w)+0.5;
                    xpatch = [xa xb xb xa];
                    if WOKS(w)==0
                        p=patch(xpatch,ypatch,'w');
                        set(p,'FaceAlpha',0.5);
                    end
                end
            end
        end
        %
        if ~isempty(P.TAB_Computations.hori_axis_limits__windows)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__windows);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__windows)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__windows);
        end
        %% color-axis
        mi=min(mi);
        ma=max(ma);
        if isempty(P.TAB_Computations.custom_caxis_spectrum)
            set(T3_PD_mincolor,'string',num2str(mi));  
            set(T3_PD_maxcolor,'string',num2str(ma));
        else
            mi2 = P.TAB_Computations.custom_caxis_spectrum(1);
            ma2 = P.TAB_Computations.custom_caxis_spectrum(2);
            set(T3_PD_mincolor,'string',num2str(mi2));  
            set(T3_PD_maxcolor,'string',num2str(ma2));
            caxis(h_ax(1),[mi2,ma2])
            caxis(h_ax(2),[mi2,ma2])
            caxis(h_ax(3),[mi2,ma2])
        end
        %% more
        drawnow
        hold(h_ax(1),'off')
        hold(h_ax(2),'off')
        hold(h_ax(3),'off')       
    end
    function Graphic_update_contour_of_windows(newfigure)%1         Spectrum contour
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        %
        mi = zeros(1,3);
        ma = zeros(1,3);
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        if(newfigure)
            hlocal=figure('name',strcat('Contour plot of windows: ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end

        Wids = 1:DTB__windows__number(P.isshown.id,1);
        %% V
        set(hgui,'CurrentAxes',h_ax(1));
        %%%           P.WNDOWS_FFT{dat_id,cc}; %VEN
        %        contourf(xvec, zvec, DD, linspace(A(1),A(2),A(3)),'EdgeColor','none')
        DD = DTB__section__V_windows{P.isshown.id,1};
        DD = DD./max(max(abs(DD)));
        mi(1) = min(min(DD)); 
        ma(1) = max(max(DD));
        %DD = P.WNDOWS_FFT{P.isshown.id,1}(ifmin:ifmax,:);
        A = [min(min(DD)),  max(max(DD)), 20];
        contourf(Wids,Fvec,DD,linspace(A(1),A(2),A(3)),'EdgeColor','none')
        axis ij
        %             set(gca,'yscale','log')
        %set(h_ax(1),'xticks',Wid);
        %title('V')       
        xlabel('(V) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% E
        set(hgui,'CurrentAxes',h_ax(2));
        DD = DTB__section__E_windows{P.isshown.id,1};
        DD = DD./max(max(abs(DD)));
        mi(2) = min(min(DD)); 
        ma(2) = max(max(DD));
        %DD = P.WNDOWS_FFT{P.isshown.id,2}(ifmin:ifmax,:);
        A = [min(min(DD)),  max(max(DD)), 20];
        contourf(Wids,Fvec,DD,linspace(A(1),A(2),A(3)),'EdgeColor','none')
        axis ij
        %             set(gca,'yscale','log')
        %title('E-W')
        xlabel('(E-W) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% N
        set(hgui,'CurrentAxes',h_ax(3));
        DD = DTB__section__N_windows{P.isshown.id,1};
        DD = DD./max(max(abs(DD)));
        mi(3) = min(min(DD)); 
        ma(3) = max(max(DD));
        %DD = P.WNDOWS_FFT{P.isshown.id,3}(ifmin:ifmax,:);
        A = [min(min(DD)),  max(max(DD)), 20];
        contourf(Wids,Fvec,DD,linspace(A(1),A(2),A(3)),'EdgeColor','none')
        axis ij
        %             set(gca,'yscale','log')
        %title('N-S')
        xlabel('(N-S) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% Show windows
        WIDS = DTB__windows__indexes{P.isshown.id,1};
        WOKS = DTB__windows__is_ok{P.isshown.id,1};
        if(~isempty(WIDS))
            ya = min(Fvec);
            yb = max(Fvec);
            ypatch = [ya ya yb yb];
            Nwin = size(WIDS,1);
            for s = 1:3
                set(hgui,'CurrentAxes',h_ax(s));
                for w = 1:Nwin
                    xa = Wids(w)-0.5;%(P.WNDOWS_IDS{P.isshown.id,1}(w,1) -1);
                    xb = Wids(w)+0.5;%(P.WNDOWS_IDS{P.isshown.id,1}(w,2) -1);
                    xpatch = [xa xb xb xa];
                    if WOKS(w)==0
                        p=patch(xpatch,ypatch,'w');
                        set(p,'FaceAlpha',0.5);
                    end
                end
            end
        end
        %
        if ~isempty(P.TAB_Computations.hori_axis_limits__windows)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__windows);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__windows)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__windows);
        end
        %% color-axis
        mi=min(mi);
        ma=max(ma);
        if isempty(P.TAB_Computations.custom_caxis_spectrum)
            set(T3_PD_mincolor,'string',num2str(mi));  
            set(T3_PD_maxcolor,'string',num2str(ma));
        else
            mi2 = P.TAB_Computations.custom_caxis_spectrum(1);
            ma2 = P.TAB_Computations.custom_caxis_spectrum(2);
            set(T3_PD_mincolor,'string',num2str(mi2));  
            set(T3_PD_maxcolor,'string',num2str(ma2));
            caxis(h_ax(1),[mi2,ma2])
            caxis(h_ax(2),[mi2,ma2])
            caxis(h_ax(3),[mi2,ma2])
        end
        %% more
        drawnow
        hold(h_ax(1),'off')
        hold(h_ax(2),'off')
        hold(h_ax(3),'off')       
    end
    function Graphic_update_hvsr_of_windows(newfigure)%2            HVSR tile
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        %
        mi = zeros(1,3);
        ma = zeros(1,3);
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        if(newfigure)
            hlocal=figure('name',strcat('HVSR of windows: ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end
        
        Wids = 1:DTB__windows__number(P.isshown.id,1);
        HV = DTB__section__HV_windows{P.isshown.id,1};
        EV = DTB__section__EV_windows{P.isshown.id,1};
        NV = DTB__section__NV_windows{P.isshown.id,1};
        istitle='H/V';

        %% V
        set(hgui,'CurrentAxes',h_ax(1));
        DD = HV;
        DD = columnwise_norm(DD);
        mi(1) = min(min(DD)); 
        ma(1) = max(max(DD));       
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(1),Wids,Fvec,DD,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(1), 'YScale', 'log')
        else
            image(Wids,Fvec,DD, 'CDataMapping','scaled')
        end
        title(istitle)         
        xlabel('(V) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')  
        %
        %% E
        set(hgui,'CurrentAxes',h_ax(2));
        if ~isempty(EV)
            DD = EV;
            DD = columnwise_norm(DD);
            mi(2) = min(min(DD)); 
            ma(2) = max(max(DD));
            if P.Flags.SpectrumAxisMode == 0
                surf(h_ax(2),Wids,Fvec,DD,'EdgeColor','none')
                view(0, -90)
                axis tight
                set(h_ax(2), 'YScale', 'log')
            else
                image(Wids,Fvec,DD, 'CDataMapping','scaled')
            end
            xlabel('(EW/V) Window no.','fontweight','bold')
            ylabel('Frequence (Hz)','fontweight','bold')
        else
            hold(h_ax(2),'off');
            cla(h_ax(2));
        end
        %% N
        set(hgui,'CurrentAxes',h_ax(3));
        if ~isempty(NV)
            DD = NV;
            DD = columnwise_norm(DD);
            mi(3) = min(min(DD)); 
            ma(3) = max(max(DD));
            if P.Flags.SpectrumAxisMode == 0
                surf(h_ax(3),Wids,Fvec,DD,'EdgeColor','none')
                view(0, -90)
                axis tight
                set(h_ax(3), 'YScale', 'log')
            else
                image(Wids,Fvec,DD, 'CDataMapping','scaled')
            end
            xlabel('(NS/V) Window no.','fontweight','bold')
            ylabel('Frequence (Hz)','fontweight','bold')
        else
            hold(h_ax(3),'off');
            cla(h_ax(3));
        end
        %% Show windows
        WIDS = DTB__windows__indexes{P.isshown.id,1};
        WOKS = DTB__windows__is_ok{P.isshown.id,1};
        if(~isempty(WIDS))
            ya = min(Fvec);
            yb = max(Fvec);
            ypatch = [ya ya yb yb];
            Nwin = size(WIDS,1);
            nc=3;
            for s = 1:nc
                set(hgui,'CurrentAxes',h_ax(s));
                for w = 1:Nwin
                    xa = Wids(w)-0.5;%(P.WNDOWS_IDS{P.isshown.id,1}(w,1) -1);
                    xb = Wids(w)+0.5;%(P.WNDOWS_IDS{P.isshown.id,1}(w,2) -1);
                    xpatch = [xa xb xb xa];
                    if WOKS(w)==0
                        p=patch(xpatch,ypatch,'w');
                        set(p,'FaceAlpha',0.5);
                    end
                end
            end
        end
        %
        if ~isempty(P.TAB_Computations.hori_axis_limits__windows)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__windows);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__windows)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__windows);
        end                
        %% color-axis
        mi=min(mi);
        ma=max(ma);
        if isempty(P.TAB_Computations.custom_caxis_hvsr_windows)
            set(T3_PD_mincolor,'string',num2str(mi));  
            set(T3_PD_maxcolor,'string',num2str(ma));
        else
            mi2 = P.TAB_Computations.custom_caxis_hvsr_windows(1);
            ma2 = P.TAB_Computations.custom_caxis_hvsr_windows(2);
            set(T3_PD_mincolor,'string',num2str(mi2));  
            set(T3_PD_maxcolor,'string',num2str(ma2));
            caxis(h_ax(1),[mi2,ma2])
            caxis(h_ax(2),[mi2,ma2])
            caxis(h_ax(3),[mi2,ma2])
        end
        %% more
            drawnow
            hold(h_ax(1),'off')
            hold(h_ax(2),'off')
            hold(h_ax(3),'off')
    end
    function Graphic_update_hvsr_contouring_of_windows(newfigure)%3 HVSR contour
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        if(newfigure)
            hlocal=figure('name',strcat('HVSR Countour plot of windows: ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end
        %% V
        mi = zeros(1,3);
        ma = zeros(1,3);
        %
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        Wids = 1:DTB__windows__number(P.isshown.id,1);
        HV = DTB__section__HV_windows{P.isshown.id,1};
        EV = DTB__section__EV_windows{P.isshown.id,1};
        NV = DTB__section__NV_windows{P.isshown.id,1};
        
        set(hgui,'CurrentAxes',h_ax(1));
        %%%           P.WNDOWS_FFT{dat_id,cc}; %VEN
        %        contourf(xvec, zvec, DD, linspace(A(1),A(2),A(3)),'EdgeColor','none')
        DD = HV;%HV(ifmin:ifmax,:);
        DD = columnwise_norm(DD);
        mi(1) = min(min(DD)); 
        ma(1) = max(max(DD));
        A = [min(min(DD)),  max(max(DD)), 20];
        %set(h_ax(1),'yscale','log')
        contourf(Wids,Fvec,DD,linspace(A(1),A(2),A(3)),'EdgeColor','none')
        axis ij

        %set(h_ax(1),'xticks',Wid);
        %title('HVSR')
        xlabel('(H/V) Window no.','fontweight','bold')
        ylabel('Frequence (Hz)','fontweight','bold')
        %% E

        set(hgui,'CurrentAxes',h_ax(2));
        if ~isempty(EV)
            DD = EV;%(ifmin:ifmax,:);
            DD = columnwise_norm(DD);
            mi(2) = min(min(DD)); 
            ma(2) = max(max(DD));
            A = [min(min(DD)),  max(max(DD)), 20];
            contourf(Wids,Fvec,DD,linspace(A(1),A(2),A(3)),'EdgeColor','none')
            axis ij
            %                 set(h_ax(2),'yscale','log')
            %title('EW/V')
            xlabel('(EW/V) Window no.','fontweight','bold')
            ylabel('Frequence (Hz)','fontweight','bold')
        else
            hold(h_ax(2),'off');
            cla(h_ax(2));
        end
        %% N

        set(hgui,'CurrentAxes',h_ax(3));
        if ~isempty(NV)
            DD = NV;%(ifmin:ifmax,:);
            DD = columnwise_norm(DD);
            mi(3) = min(min(DD)); 
            ma(3) = max(max(DD));
            A = [min(min(DD)),  max(max(DD)), 20];
            contourf(Wids,Fvec,DD,linspace(A(1),A(2),A(3)),'EdgeColor','none')
            axis ij
            %                 set(h_ax(3),'yscale','log')
            %title('NS/V')
            xlabel('(NS/V) Window no.','fontweight','bold')
            ylabel('Frequence (Hz)','fontweight','bold')
        else
            hold(h_ax(3),'off');
            cla(h_ax(3));
        end

        %% Show windows
        WIDS = DTB__windows__indexes{P.isshown.id,1};
        WOKS = DTB__windows__is_ok{P.isshown.id,1};
        if(~isempty(WIDS))
            ya = min(Fvec);
            yb = max(Fvec);
            ypatch = [ya ya yb yb];
            Nwin = size(WIDS,1);
            nc=3;
            for s = 1:nc
                set(hgui,'CurrentAxes',h_ax(s));
                for w = 1:Nwin
                    xa = Wids(w)-0.5;%(P.WNDOWS_IDS{P.isshown.id,1}(w,1) -1);
                    xb = Wids(w)+0.5;%(P.WNDOWS_IDS{P.isshown.id,1}(w,2) -1);
                    xpatch = [xa xb xb xa];
                    if WOKS(w)==0
                        p=patch(xpatch,ypatch,'w');
                        set(p,'FaceAlpha',0.5);
                    end
                end
            end
        end
        %
        if ~isempty(P.TAB_Computations.hori_axis_limits__windows)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__windows);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__windows)
            % P.TAB_Computations.hori_axis_limits__windows % Tab computations, horizontal axis limits
            % P.TAB_Computations.hori_axis_limits__frequence
            % P.TAB_Computations.hori_axis_limits__angles
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__windows)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__windows);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__windows);
        end

        %% color-axis
        mi=min(mi);
        ma=max(ma);
        if isempty(P.TAB_Computations.custom_caxis_hvsr_windows)
            set(T3_PD_mincolor,'string',num2str(mi));  
            set(T3_PD_maxcolor,'string',num2str(ma));
        else
            mi2 = P.TAB_Computations.custom_caxis_hvsr_windows(1);
            ma2 = P.TAB_Computations.custom_caxis_hvsr_windows(2);
            set(T3_PD_mincolor,'string',num2str(mi2));  
            set(T3_PD_maxcolor,'string',num2str(ma2));
            caxis(h_ax(1),[mi2,ma2])
            caxis(h_ax(2),[mi2,ma2])
            caxis(h_ax(3),[mi2,ma2])
        end
        %% more
        drawnow
        hold(h_ax(1),'off')
        hold(h_ax(2),'off')
        hold(h_ax(3),'off')
    end
    function Graphic_update_hvsr_average_curve(newfigure)%4         H/V average        
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        cw = 0.5;
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted

        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        if(newfigure)
            hlocal=figure('name',strcat('Average HVSR (mode-1): ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end
        %
        %
        HVo = DTB__hvsr__curve_full{P.isshown.id,1};
% %                 ERo = DTB{P.isshown.id,1}.hvsr.error_full;
        HVc = DTB__hvsr__curve{P.isshown.id,1};     
% %                 ERc = DTB{P.isshown.id,1}.hvsr.error;
        EVc = DTB__hvsr__curve_EV{P.isshown.id,1};
        NVc = DTB__hvsr__curve_NV{P.isshown.id,1};
        %
        CONFo = DTB__hvsr__confidence95_full{P.isshown.id,1};% confidence 95%
        CONFc = DTB__hvsr__confidence95{P.isshown.id,1};
        %
        fmin = str2double( get(hT3_PA_edit_fmin,'string'));
        fmax = str2double( get(hT3_PA_edit_fmax,'string'));
        %
        fpeak_user = DTB__hvsr__user_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        apeak_user = DTB__hvsr__user_main_peak_amplitude(P.isshown.id,1);% user selection is always preferred
        fpeak_auto = DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        apeak_auto = DTB__hvsr__auto_main_peak_amplitude(P.isshown.id,1);% user selection is always preferred
        %P.info__curve_thickness 
        %% AXES 1
        set(hgui,'CurrentAxes',h_ax(1));
        if P.Flags.SpectrumAxisMode==0
            hold(h_ax(1),'off')
            semilogx(h_ax(1),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(1),'on')
            % 
% %                     semilogx(h_ax(1),Fvec, (HVc+ERc),'--k','LineWidth',P.error_curve_thickness);% ERROR
% %                     semilogx(h_ax(1),Fvec, (HVc-ERc),'--k','LineWidth',P.error_curve_thickness);
            semilogx(h_ax(1),Fvec, (HVc+CONFc),'Color',cw*[1,1,1],'LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            semilogx(h_ax(1),Fvec, (HVc-CONFc),'Color',cw*[1,1,1],'LineWidth',P.error_curve_thickness);
            %
            semilogx(h_ax(1),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);

            if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
                semilogx(fpeak_user*[1,1],[0,1.1*apeak_user],'diamond-g','LineWidth',P.info__curve_thickness);
            end
            if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
                semilogx(fpeak_auto*[1,1],[0,1.1*apeak_auto],'diamond-r','LineWidth',P.info__curve_thickness);
            end
            if ~isempty(DTB__hvsr__user_additional_peaks{P.isshown.id,1})
                for p = 1:size(DTB__hvsr__user_additional_peaks{P.isshown.id,1},1)
                    addF = DTB__hvsr__user_additional_peaks{P.isshown.id,1}(p, 3);
                    addA = DTB__hvsr__user_additional_peaks{P.isshown.id,1}(p, 4);
                    semilogx(addF*[1,1],[0,1.1*addA],'diamond-','Color',[1,0.7,0],'LineWidth',P.info__curve_thickness);
                end
            end
        else
            hold(h_ax(1),'off')
            plot(h_ax(1),Fvec, HVc,'r','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(1),'on')
% %                     plot(h_ax(1),Fvec, (HVc+ERc),'--k','LineWidth',P.error_curve_thickness);% ERROR
% %                     plot(h_ax(1),Fvec, (HVc-ERc),'--k','LineWidth',P.error_curve_thickness);
            plot(h_ax(1),Fvec, (HVc+CONFc),'k','LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            plot(h_ax(1),Fvec, (HVc-CONFc),'k','LineWidth',P.error_curve_thickness);
            %
            plot(h_ax(1),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
            %plot(fpeak,apeak,'diamondr')
            if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
                plot(fpeak_user*[1,1],[0,1.1*apeak_user],'diamond-g','LineWidth',P.info__curve_thickness);
            end
            if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
                plot(fpeak_auto*[1,1],[0,1.1*apeak_auto],'diamond-r','LineWidth',P.info__curve_thickness);
            end
            if ~isempty(DTB__hvsr__user_additional_peaks{P.isshown.id,1})
                for p = 1:size(DTB__hvsr__user_additional_peaks{P.isshown.id,1},1)
                    addF = DTB__hvsr__user_additional_peaks{P.isshown.id,1}(p, 3);
                    addA = DTB__hvsr__user_additional_peaks{P.isshown.id,1}(p, 4);
                    plot(h_ax(1), addF*[1,1],[0,1.1*addA],'diamond-','Color',[1,0.7,0],'LineWidth',P.info__curve_thickness);
                end
            end
            
        end
        %
        %title('Ave HVSR (clean)')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('Average HVSR (clean)','fontweight','bold')
        xlim([fmin fmax])
        hold(h_ax(1),'off')
        %
        %% AXES 2
        set(hgui,'CurrentAxes',h_ax(2));
        if P.Flags.SpectrumAxisMode==0
            hold(h_ax(2),'off')
            semilogx(Fvec, HVo,'r','LineWidth',P.hvsr__curve_thickness);%                   original
            hold(h_ax(2),'on')
            semilogx(h_ax(2),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);%       clean
            legend('Full','Cleaned')
% %                     semilogx(h_ax(2),Fvec, (HVo+ERo),'--r','LineWidth',P.error_curve_thickness);
% %                     semilogx(h_ax(2),Fvec, (HVo-ERo),'--r','LineWidth',P.error_curve_thickness);
            semilogx(h_ax(2),Fvec, (HVo+CONFo),'r','LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            semilogx(h_ax(2),Fvec, (HVo-CONFo),'r','LineWidth',P.error_curve_thickness);
            %
% %                     semilogx(h_ax(2),Fvec, (HVc+ERc),'--k','LineWidth',P.error_curve_thickness);% ERROR
% %                     semilogx(h_ax(2),Fvec, (HVc-ERc),'--k','LineWidth',P.error_curve_thickness);
            semilogx(h_ax(2),Fvec, (HVc+CONFc),'Color',cw*[1,1,1],'LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            semilogx(h_ax(2),Fvec, (HVc-CONFc),'Color',cw*[1,1,1],'LineWidth',P.error_curve_thickness);
            %
            semilogx(h_ax(2),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        else
            hold(h_ax(2),'off')
            plot(h_ax(2),Fvec, HVo,'r','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(2),'on')
            plot(h_ax(2),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            legend('Full','Cleaned')
            %
% %                     plot(h_ax(2),Fvec, (HVo+ERo),'--r','LineWidth',P.error_curve_thickness);
% %                     plot(h_ax(2),Fvec, (HVo-ERo),'--r','LineWidth',P.error_curve_thickness);
            plot(h_ax(2),Fvec, (HVo+CONFo),'k','LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            plot(h_ax(2),Fvec, (HVo-CONFo),'k','LineWidth',P.error_curve_thickness);
            %
% %                     plot(h_ax(2),Fvec, (HVc+ERc),'--k','LineWidth',P.error_curve_thickness);% ERROR
% %                     plot(h_ax(2),Fvec, (HVc-ERc),'--k','LineWidth',P.error_curve_thickness);
            plot(h_ax(2),Fvec, (HVc+CONFc),'k','LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            plot(h_ax(2),Fvec, (HVc-CONFc),'k','LineWidth',P.error_curve_thickness);
            %
            plot(h_ax(2),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        end
        %title('Ave HVSR (compared)')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('Average HVSR (comparison)','fontweight','bold')
        xlim([fmin fmax])
        hold(h_ax(2),'off')
        %% AXES 3
        set(hgui,'CurrentAxes',h_ax(3));
        if P.Flags.SpectrumAxisMode==0
            hold(h_ax(3),'off')
            semilogx(h_ax(3),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(3),'on')
            semilogx(h_ax(3),Fvec, EVc,'b','LineWidth',P.hvsr__curve_thickness);
            semilogx(h_ax(3),Fvec, NVc,'r','LineWidth',P.hvsr__curve_thickness);
            legend('H/V','E/V','N/V')
            %
            plot(h_ax(3),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        else
            hold(h_ax(3),'off')
            plot(h_ax(3),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(3),'on')
            plot(h_ax(3),Fvec, EVc,'b','LineWidth',P.hvsr__curve_thickness);
            plot(h_ax(3),Fvec, NVc,'r','LineWidth',P.hvsr__curve_thickness);
            legend('H/V','E/V','N/V')
            %
            plot(h_ax(3),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        end
        %title('Ave HVSR (for components)')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('Average HVSR (by component)','fontweight','bold')
        xlim([fmin fmax])
        hold(h_ax(3),'off')
        %
        if ~isempty(P.TAB_Computations.hori_axis_limits__frequence)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__frequence);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__frequence);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__frequence);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__frequence)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__frequence);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__frequence);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__frequence);
        end
        %
        is_done();
        drawnow
    end
    function Graphic_update_hvsr_H_V_Compare(newfigure)%5           H/V, compare V E N        
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        cw=0.5;
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        %
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        if(newfigure)
            hlocal=figure('name',strcat('Average HVSR (mode-1): ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end
        %
        %
        HVc = DTB__hvsr__curve{P.isshown.id,1};
% %                 ERc = DTB{P.isshown.id,1}.hvsr.error;
        EVc = DTB__hvsr__curve_EV{P.isshown.id,1};
        NVc = DTB__hvsr__curve_NV{P.isshown.id,1};
        CONFc = DTB__hvsr__confidence95{P.isshown.id,1};
        %
        fmin = str2double( get(hT3_PA_edit_fmin,'string'));
        fmax = str2double( get(hT3_PA_edit_fmax,'string'));
        %
        fpeak_user = DTB__hvsr__user_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        apeak_user = DTB__hvsr__user_main_peak_amplitude(P.isshown.id,1);% user selection is always preferred
        fpeak_auto = DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        apeak_auto = DTB__hvsr__auto_main_peak_amplitude(P.isshown.id,1);% user selection is always preferred
        %P.info__curve_thickness 
        %% AXES 1
        set(hgui,'CurrentAxes',h_ax(1));
        if P.Flags.SpectrumAxisMode==0
            hold(h_ax(1),'off')
            semilogx(h_ax(1),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(1),'on')
% %                     semilogx(h_ax(1),Fvec, (HVc+ERc),'--k','LineWidth',P.error_curve_thickness);% ERROR
% %                     semilogx(h_ax(1),Fvec, (HVc-ERc),'--k','LineWidth',P.error_curve_thickness);
            semilogx(h_ax(1),Fvec, (HVc+CONFc),'Color',cw*[1,1,1],'LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            semilogx(h_ax(1),Fvec, (HVc-CONFc),'Color',cw*[1,1,1],'LineWidth',P.error_curve_thickness);
            %
            semilogx(h_ax(1),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);

            if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
                semilogx(fpeak_user*[1,1],[0,1.1*apeak_user],'diamond-g','LineWidth',P.info__curve_thickness);
            end
            if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
                semilogx(fpeak_auto*[1,1],[0,1.1*apeak_auto],'diamond-r','LineWidth',P.info__curve_thickness);
            end


        else
            hold(h_ax(1),'off')
            plot(h_ax(1),Fvec, HVc,'r','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(1),'on')
% %                     plot(h_ax(1),Fvec, (HVc+ERc),'--k','LineWidth',P.error_curve_thickness);% ERROR
% %                     plot(h_ax(1),Fvec, (HVc-ERc),'--k','LineWidth',P.error_curve_thickness);
            plot(h_ax(1),Fvec, (HVc+CONFc),'k','LineWidth',P.error_curve_thickness);% CONFIDENCE 95%
            plot(h_ax(1),Fvec, (HVc-CONFc),'k','LineWidth',P.error_curve_thickness);
            %
            plot(h_ax(1),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
            %plot(fpeak,apeak,'diamondr')
            if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
                plot(fpeak_user*[1,1],[0,1.1*apeak_user],'diamond-g','LineWidth',P.info__curve_thickness);
            end
            if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
                plot(fpeak_auto*[1,1],[0,1.1*apeak_auto],'diamond-r','LineWidth',P.info__curve_thickness);
            end
        end
        %
        %title('Ave HVSR (clean)')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('Average HVSR (clean)','fontweight','bold')
        xlim([fmin fmax])
        hold(h_ax(1),'off')
        %
        %% AXES 2
        set(hgui,'CurrentAxes',h_ax(2));
        average_E = DTB__section__Average_E{P.isshown.id,1};
        average_N = DTB__section__Average_N{P.isshown.id,1};
        average_V = DTB__section__Average_V{P.isshown.id,1};
        if P.Flags.SpectrumAxisMode==0
            hold(h_ax(2),'off')
            semilogx(h_ax(2),Fvec, average_V,'r','LineWidth',P.error_curve_thickness);
            hold(h_ax(2),'on')
            semilogx(h_ax(2),Fvec, average_E,'k','LineWidth',P.error_curve_thickness);
            semilogx(h_ax(2),Fvec, average_N,'b','LineWidth',P.error_curve_thickness);
            legend('V','E','N')
        else
            hold(h_ax(2),'off')
            plot(h_ax(2),Fvec, average_V,'-r','LineWidth',P.error_curve_thickness);
            hold(h_ax(2),'on')
            plot(h_ax(2),Fvec, average_E,'k','LineWidth',P.error_curve_thickness);
            plot(h_ax(2),Fvec, average_N,'b','LineWidth',P.error_curve_thickness);
            legend('V','E','N')
        end
        %title('Ave Components (compared)')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('Components comparison','fontweight','bold')
        xlim([fmin fmax])
        hold(h_ax(2),'off')
        %% AXES 3
        set(hgui,'CurrentAxes',h_ax(3));
        if P.Flags.SpectrumAxisMode==0
            hold(h_ax(3),'off')
            semilogx(h_ax(3),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(3),'on')
            semilogx(h_ax(3),Fvec, EVc,'b','LineWidth',P.hvsr__curve_thickness);
            semilogx(h_ax(3),Fvec, NVc,'r','LineWidth',P.hvsr__curve_thickness);
            legend('H/V','E/V','N/V')
            %
            plot(h_ax(3),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        else
            hold(h_ax(3),'off')
            plot(h_ax(3),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
            hold(h_ax(3),'on')
            plot(h_ax(3),Fvec, EVc,'b','LineWidth',P.hvsr__curve_thickness);
            plot(h_ax(3),Fvec, NVc,'r','LineWidth',P.hvsr__curve_thickness);
            legend('H/V','E/V','N/V')
            %
            plot(h_ax(3),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        end
        %title('Ave HVSR (for components)')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('Average HVSR (comparison)','fontweight','bold')

        xlim([fmin fmax])
        hold(h_ax(3),'off')
        %
        if ~isempty(P.TAB_Computations.hori_axis_limits__frequence)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__frequence);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__frequence);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__frequence);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__frequence)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__frequence);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__frequence);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__frequence);
        end
        %
        drawnow
    end   
    function Graphic_update_hvsr_all_curves(newfigure)%6            H/V all curves
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        %
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        if(newfigure)
            hlocal=figure('name',strcat('Average HVSR (mode-2): ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end

        Nwin = DTB__windows__number(P.isshown.id,1);
        colrs = Pfunctions__get_rgb_colors(Nwin);% windows-colors
        %% Curves in AXIS (1)
        set(hgui,'CurrentAxes',h_ax(1));
        DD = DTB__hvsr__HV_all_windows{ii,1};
        hold(h_ax(1),'off');
        cla(h_ax(1));
        for cc = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(cc)==0)
                HVa = DD(:,cc);
                clrr = 0.8*[1 1 1];
                if P.Flags.SpectrumAxisMode==0
                    semilogx(h_ax(1),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(h_ax(1),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(h_ax(1),'on');
            end
        end
        for cc = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(cc)==1)
                HVa = DD(:,cc);
                clrr = colrs(cc,:);
                if P.Flags.SpectrumAxisMode==0
                    semilogx(h_ax(1),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(h_ax(1),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(h_ax(1),'on');
            end
        end
        %
        HVc = DTB__hvsr__curve{P.isshown.id,1};
        semilogx(h_ax(1),Fvec, HVc,'k','LineWidth',P.hvsr__curve_thickness);
        %
        plot(h_ax(1),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        %title('H/V')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('H/V','fontweight','bold')
        %% Curves in AXIS (2)
        set(hgui,'CurrentAxes',h_ax(2));
        DD = DTB__hvsr__EV_all_windows{ii,1};
        hold(h_ax(2),'off');
        cla(h_ax(2));
        for cc = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(cc)==0)
                HVa = DD(:,cc);
                clrr = 0.8*[1 1 1];
                if P.Flags.SpectrumAxisMode==0
                    semilogx(h_ax(2),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(h_ax(2),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(h_ax(2),'on');
            end
        end
        for cc = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(cc)==1)
                HVa = DD(:,cc);
                clrr = colrs(cc,:);
                if P.Flags.SpectrumAxisMode==0
                    semilogx(h_ax(2),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(h_ax(2),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(h_ax(2),'on');
            end
        end
        %
        EVc = DTB__hvsr__curve_EV{P.isshown.id,1};
        semilogx(h_ax(2),Fvec, EVc,'k','LineWidth',P.hvsr__curve_thickness);
        %
        plot(h_ax(2),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        %title('E/V')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('EW/V','fontweight','bold')
        %% Curves in AXIS (3)
        set(hgui,'CurrentAxes',h_ax(3));
        DD = DTB__hvsr__EV_all_windows{ii,1};
        hold(h_ax(3),'off');
        cla(h_ax(3));
        for cc = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(cc)==0)
                HVa = DD(:,cc);
                clrr = 0.8*[1 1 1];
                if P.Flags.SpectrumAxisMode==0
                    semilogx(h_ax(3),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(h_ax(3),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(h_ax(3),'on');
            end
        end
        for cc = 1:Nwin
            if (DTB__windows__is_ok{P.isshown.id,1}(cc)==1)
                HVa = DD(:,cc);
                clrr = colrs(cc,:);
                if P.Flags.SpectrumAxisMode==0
                    semilogx(h_ax(3),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                else
                    plot(h_ax(3),Fvec, HVa,'Color',clrr,'LineWidth',P.hvsr__curve_thickness);
                end
                hold(h_ax(3),'on');
            end
        end
        %
        NVc = DTB__hvsr__curve_NV{P.isshown.id,1};
        semilogx(h_ax(3),Fvec, NVc,'k','LineWidth',P.hvsr__curve_thickness);
        %
        plot(h_ax(3),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        %title('N/V')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel('NS/V','fontweight','bold')
        %% 
        if ~isempty(P.TAB_Computations.hori_axis_limits__frequence)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__frequence);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__frequence);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__frequence);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__frequence)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__frequence);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__frequence);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__frequence)
        end
        %
        drawnow
    end   
    function Graphic_update_hvsr_180_windows(newfigure)%7           Directional image
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be already set
        if DTB__hvsr180__angle_id(P.isshown.id,1)==1; return; end 
        %
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );
        %
        if(newfigure)
            hlocal=figure('name',strcat('Directional H/V (mode-2): ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV;
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end
        th = DTB__hvsr180__angle_step(P.isshown.id,1);
        DD = DTB__hvsr180__spectralratio{P.isshown.id,1};
        DD = [DD, DD(:,1)];
        mi = min(min(DD)); 
        ma = max(max(DD));
        maxn = max(DTB__hvsr__curve{P.isshown.id,1});      
        tcrv = 135*(DTB__hvsr__curve{P.isshown.id,1}./maxn);
        tcry =(0*tcrv + 135/maxn); 
        fpeak_user = DTB__hvsr__user_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        fpeak_auto = DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        %%
        switch USER_PREFERENCE_hvsr_directional_reference_system
            case 'compass'
                angles = 90:-th:-90;
                angles_span = [-90,90];
                tcrv = tcrv-90;
                tcry = tcry-90; 
            otherwise
                angles = 0:th:180;
                angles_span = [0,180];
                % tcrv is Ok
                % tcry is Ok
        end
       %% AXES 1: PLAIN VIEW
        set(hgui,'CurrentAxes',h_ax(1));
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(1),angles,Fvec,DD,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(1), 'YScale', 'log')
        else
            image(angles,Fvec,DD, 'CDataMapping','scaled')
        end
        hold(h_ax(1),'on');
        plot(h_ax(1),tcrv,Fvec,'w','linewidth',2)
        plot(h_ax(1),tcry,Fvec,'w','linewidth',1)
        %
        if experimental_directionality==1
            prd = DTB__hvsr180__preferred_direction{P.isshown.id,1};%  expressed in E=0 N=90
            if(strcmp(USER_PREFERENCE_hvsr_directional_reference_system,'compass'))
                % transform from theta in [E=0 N=90 W=180] to theta2 in [W=-90 N=0 E=90]:  theta2 = 90-theta  
                prd = -prd+90;
            end
            if ~isempty(prd)
                dag = delta_angle_allowed/2;
                for ff = 1:size(prd,1)
                    dangle = abs(prd(ff,4)-prd(ff,8));% angle difference (90 deg ??)
                    if dangle > 90+dag; continue; end
                    if dangle < 90-dag; continue; end
                    
                    plot(h_ax(1),prd(ff,4),Fvec(ff),'ok','MarkerFaceColor','k')
                end    
            end 
        end
       %
        if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(1), angles_span,[1,1]*fpeak_user,'w','linewidth',P.info__curve_thickness)
            text(angles_span(1),fpeak_user,'User','Color','w','fontweight','bold','FontSize',USER_PREFERENCE_interface_objects_fontsize)
        end
        if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(1), angles_span,[1,1]*fpeak_auto,'w','linewidth',P.info__curve_thickness)
            text(angles_span(1),fpeak_auto,'Auto','Color','w','fontweight','bold','FontSize',USER_PREFERENCE_interface_objects_fontsize)
        end  
        %       
        % color-axis
        if isempty(P.TAB_Computations.custom_caxis_directional)
            set(T3_PD_mincolor,'string',num2str(mi));  
            set(T3_PD_maxcolor,'string',num2str(ma));
        else
            mi2 = P.TAB_Computations.custom_caxis_directional(1);
            ma2 = P.TAB_Computations.custom_caxis_directional(2);
            set(T3_PD_mincolor,'string',num2str(mi2));  
            set(T3_PD_maxcolor,'string',num2str(ma2));
            caxis(h_ax(1),[mi2,ma2])
        end
        % more
        colorbar
        switch USER_PREFERENCE_hvsr_directional_reference_system
            case 'compass'
                xlabel(sprintf('Angle (Deg.) N=0, E=90\nHVSR-Directional'),'fontweight','bold')
            otherwise
                xlabel(sprintf('Angle (Deg.) N=90, E=0\nHVSR-Directional'),'fontweight','bold')
        end
        ylabel('Frequency (Hz)','fontweight','bold')
        %
       %% AXES 2: NORM-FREQUENCE
        set(hgui,'CurrentAxes',h_ax(2));
        hold(h_ax(3),'off');
        DD2 =  rowwise_norm(DD);
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(2),angles,Fvec,DD2,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(2), 'YScale', 'log')
        else
            image(angles,Fvec,DD2, 'CDataMapping','scaled')
        end
        hold(h_ax(2),'on');
        plot(h_ax(2),tcrv,Fvec,'w','linewidth',2)
        plot(h_ax(2),(0*tcrv + 135/maxn),Fvec,'w','linewidth',1)
        if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(2), angles_span,[1,1]*fpeak_user,'w','linewidth',1)
        end
        if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(2), angles_span,[1,1]*fpeak_auto,'w','linewidth',1)
        end 
        %
        colorbar 
        xlabel(sprintf('Angle (Deg)\nHVSR-Dir. Norm. by Frequency'),'fontweight','bold')
        ylabel('Frequency (Hz)','fontweight','bold')
        %
       %% AXES 3: NORM-ANGLE
        set(hgui,'CurrentAxes',h_ax(3));
        hold(h_ax(3),'off');
        DD2 =  columnwise_norm(DD);
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(3),angles,Fvec,DD2,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(3), 'YScale', 'log')
        else
            image(angles,Fvec,DD2, 'CDataMapping','scaled')
        end
        hold(h_ax(3),'on');
        plot(h_ax(3),tcrv,Fvec,'w','linewidth',2)
        plot(h_ax(3),tcry,Fvec,'w','linewidth',1)
        if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(3), angles_span,[1,1]*fpeak_user,'w','linewidth',1)
        end
        if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(3), angles_span,[1,1]*fpeak_auto,'w','linewidth',1)
        end 
        %
        colorbar
        xlabel(sprintf('Angle (Deg)\nHVSR-Dir. Norm. by Angle'),'fontweight','bold')
        ylabel('Frequency (Hz)','fontweight','bold')

        % axes limits
        if ~isempty(P.TAB_Computations.hori_axis_limits__angles)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__angles);
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__angles);
            xlim(h_ax(3), P.TAB_Computations.hori_axis_limits__angles)
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__angles)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__angles);
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__angles);
            ylim(h_ax(3), P.TAB_Computations.vert_axis_limits__angles)
        end
        %
        drawnow
        hold(h_ax(1),'off')
        hold(h_ax(2),'off')
        hold(h_ax(3),'off')                        
    end
    function Graphic_update_hvsr_180_curves(newfigure)%8            Directional curves
        %%
        if ~((0 < P.isshown.id) && (P.isshown.id<= size(SURVEYS,1))); return; end
        is_drawing();
        ii = P.isshown.id;
        if isempty(DTB__section__Frequency_Vector{ii,1}); return; end% Fvec must be setted
        if DTB__hvsr180__angle_id(P.isshown.id,1)==1; return; end 
        %
        df = DTB__section__Frequency_Vector{ii,1}(3);
        Fvec = df*(  (DTB__section__Frequency_Vector{ii,1}(1)-1) : (DTB__section__Frequency_Vector{ii,1}(2)-1) );

        if(newfigure)
            hlocal=figure('name',strcat('Directional H/V (mode-1): ID=',num2str(P.isshown.id)));
            hgui = hlocal;
            h_ax(1) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speV);% V
            h_ax(2) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speE);% E
            h_ax(3) = axes('Parent',hlocal,'Units', 'normalized','FontSize',USER_PREFERENCE_interface_objects_fontsize,'Position',pos_axs_speN);% N
        else
            hgui = H.gui;
            h_ax(1) = hAx_speV; 
            h_ax(2) = hAx_speE;
            h_ax(3) = hAx_speN;
            cla(h_ax(1));
            cla(h_ax(2));
            cla(h_ax(3));
        end
        th = DTB__hvsr180__angle_step(P.isshown.id,1);
        %angles = 0:th:180;
        DD = DTB__hvsr180__spectralratio{P.isshown.id,1};
        DD = [DD, DD(:,1)];
        mi = min(min(DD)); 
        ma = max(max(DD));
        %
        maxn = max(DTB__hvsr__curve{P.isshown.id,1});      
        tcrv = 135*(DTB__hvsr__curve{P.isshown.id,1}./maxn);
        tcry =(0*tcrv + 135/maxn); 
        fpeak_user = DTB__hvsr__user_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        fpeak_auto = DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1);% user selection is always preferred
        %%
         switch USER_PREFERENCE_hvsr_directional_reference_system
            case 'compass'
                angles = 90:-th:-90;
                angles_span = [-90,90];
                tcrv = tcrv-90;
                tcry = tcry-90; 
                DD=fliplr(DD);
            otherwise
                angles = 0:th:180;
                angles_span = [0,180];
                % tcrv is Ok
                % tcry is Ok
        end
        %% AXIS (1) PLAIN VIEW
        set(hgui,'CurrentAxes',h_ax(1));
        if P.Flags.SpectrumAxisMode == 0
            surf(h_ax(1),angles,Fvec,DD,'EdgeColor','none')
            view(0, -90)
            axis tight
            set(h_ax(1), 'YScale', 'log')
        else
            image(angles,Fvec,DD, 'CDataMapping','scaled')
        end
        hold(h_ax(1),'on');
        plot(h_ax(1),tcrv,Fvec,'w','linewidth',2)
        plot(h_ax(1),tcry,Fvec,'w','linewidth',1)
        %
        if ~isnan(DTB__hvsr__user_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(1), angles_span,[1,1]*fpeak_user,'w','linewidth',P.info__curve_thickness)
            text(angles_span(1),fpeak_user,'User','Color','w','fontweight','bold','FontSize',USER_PREFERENCE_interface_objects_fontsize)
        end
        if ~isnan(DTB__hvsr__auto_main_peak_frequence(P.isshown.id,1))
            plot(h_ax(1), angles_span,[1,1]*fpeak_auto,'w','linewidth',P.info__curve_thickness)
            text(angles_span(1),fpeak_auto,'Auto','Color','w','fontweight','bold','FontSize',USER_PREFERENCE_interface_objects_fontsize)
        end  
        %       
        % color-axis
        if isempty(P.TAB_Computations.custom_caxis_directional)
            set(T3_PD_mincolor,'string',num2str(mi));  
            set(T3_PD_maxcolor,'string',num2str(ma));
        else
            mi2 = P.TAB_Computations.custom_caxis_directional(1);
            ma2 = P.TAB_Computations.custom_caxis_directional(2);
            set(T3_PD_mincolor,'string',num2str(mi2));  
            set(T3_PD_maxcolor,'string',num2str(ma2));
            caxis(h_ax(1),[mi2,ma2])
        end
        % more
        colorbar
        switch USER_PREFERENCE_hvsr_directional_reference_system
            case 'compass'
                xlabel(sprintf('Angle (Deg.) N=0, E=90\nHVSR-Directional'),'fontweight','bold')
            otherwise
                xlabel(sprintf('Angle (Deg.) N=90, E=0\nHVSR-Directional'),'fontweight','bold')
        end
        ylabel('Frequency (Hz)','fontweight','bold')
        %
        %% AXIS (2) Curves
        set(hgui,'CurrentAxes',h_ax(2));
        Nwin = size(DD,2);
        colrs = Pfunctions__get_rgb_colors(Nwin);% windows-colors
        %
        hold(h_ax(2),'off');
        cla(h_ax(2));
        %
        for cc = 1:Nwin-1
            HVa = DD(:,cc);
            if P.Flags.SpectrumAxisMode==0
                semilogx(h_ax(2),Fvec, HVa,'Color',colrs(cc,:),'LineWidth',P.hvsr__curve_thickness);
            else
                plot(h_ax(2),Fvec, HVa,'Color',colrs(cc,:),'LineWidth',P.hvsr__curve_thickness);
            end
            hold(h_ax(2),'on');
        end
        plot(h_ax(2),Fvec, (0*Fvec+1),'k','LineWidth',P.info__curve_thickness);
        title('Curves')
        xlabel('Frequency (Hz)','fontweight','bold')
        ylabel(sprintf('HVSR Directional\nCurves for all computed directions'),'fontweight','bold')
        %
        %% AXIS (3)
        set(h_ax(3),'visible','off');
        %
        drawnow
        hold(h_ax(1),'off')
        hold(h_ax(2),'off')
        hold(h_ax(3),'off')                
        % more
        if ~isempty(P.TAB_Computations.hori_axis_limits__angles)
            xlim(h_ax(1), P.TAB_Computations.hori_axis_limits__angles);

        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__angles)
            ylim(h_ax(1), P.TAB_Computations.vert_axis_limits__angles);
        end

        if ~isempty(P.TAB_Computations.hori_axis_limits__angleshv)
            xlim(h_ax(2), P.TAB_Computations.hori_axis_limits__angleshv);
        end
        if ~isempty(P.TAB_Computations.vert_axis_limits__angles)
            ylim(h_ax(2), P.TAB_Computations.vert_axis_limits__angleshv);
        end
    end
    function [NN] = rowwise_norm(DD)
        NN=DD;
        for rr = 1:size(DD,1)
            NN(rr,:) = DD(rr,:)./max(abs(DD(rr,:)));
        end
    end
    function [NN] = columnwise_norm(DD)
        NN=DD;
        for cc = 1:size(DD,2)
            NN(:,cc) = DD(:,cc)./max(abs(DD(:,cc)));
        end
    end
%%    plot: 2-D
    function Graphics_2dView_hvsr_main_frequence(newfigure)
        is_drawing();
        if(newfigure)
            h_fig = figure('name','Main Resonant Frequency Map');
            h_ax= gca;%get(h_fig,'CurrentAxes');
        else
            h_fig = H.gui;
            h_ax = hAx_2DViews;
        end
        set(h_fig,'CurrentAxes',h_ax);
        if strcmp( get(H.menu.view.HoldOn,'Checked'), 'off')
            hold(h_ax,'off'); cla(h_ax);
        end
        %
        Ndata = size(SURVEYS,1);
        Xscatt = zeros(Ndata,1);
        Yscatt = zeros(Ndata,1);
        Vscatt = zeros(Ndata,1);
        Xmask = zeros(Ndata,1);
        Ymask = zeros(Ndata,1);
        d=0;
        for n = 1:Ndata
            Xmask(n) = SURVEYS{n,1}(1);
            Ymask(n) = SURVEYS{n,1}(2);
            if DTB__status(n,1)~=2
                if isnan(DTB__hvsr__auto_main_peak_amplitude(n,1)) && isnan(DTB__hvsr__user_main_peak_amplitude(n,1))
                    continue;
                end
                d=d+1;
                Xscatt(d) = SURVEYS{n,1}(1);
                Yscatt(d) = SURVEYS{n,1}(2);
                if ~isnan(DTB__hvsr__user_main_peak_frequence(n,1))
                    Vscatt(d) = DTB__hvsr__user_main_peak_frequence(n,1);% user selection is always preferred
                else
                    Vscatt(d) = DTB__hvsr__auto_main_peak_frequence(n,1);
                end
            end
        end
        Xscatt = Xscatt(1:d);
        Yscatt = Yscatt(1:d);
        Vscatt = Vscatt(1:d);
        %
        if d>2
            nx = str2double( get(T4_dx,'string') );
            ny = str2double( get(T4_dy,'string') );
            dl = 0;% percect%
            %
            colorstyle_id   = get(h_contour_color_style,'value');
            colorstyle_list = get(h_contour_color_style,'string');
            colorstyle = colorstyle_list(colorstyle_id,:);
            N_colorLevels = str2double(get(h_contour_color_levels,'String'));

            % use exra points for better interpolation
            extpt_id   = get(h_contour_extra_points,'value');
            extpt_list = get(h_contour_extra_points,'string');
            extpt_mode = extpt_list(extpt_id,:);
            %% EXTRA POINTS IN INTERPOLATION ?
    %         if strcmp(extpt_mode,'yes')
    %             if ~isempty(TOPOGRAPHY)
    %                 idb = boundary(TOPOGRAPHY(:,1),TOPOGRAPHY(:,2));
    %                 Xscatt = [Xscatt; TOPOGRAPHY(:,idb)];
    %                 Yscatt = [Yscatt; TOPOGRAPHY(:,idb)]; 
    %                 
    %                 Vscatt = [Vscatt; 100+0*TOPOGRAPHY(:,2)];
    %             end
    %         end
            %% COUNTURS
            if Matlab_Release_num <=2012.2
                %>> warning('SAM: check the exact release')
                contourf_2D_of_scattered_points__2012b(h_fig,h_ax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, N_colorLevels);% 2014
            else
                contourf_2D_of_scattered_points__ScattInterpol(h_fig,h_ax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, N_colorLevels);% 2014
            end
            hold(h_ax,'on');
            %% MASK
            if Matlab_Release_num >=2014.2
                if strcmp( get(H.menu.view.view2d_Mask,'Checked'), 'on')
                    if strcmp(extpt_mode,'yes')
                        if ~isempty(TOPOGRAPHY)
                            Xplus = [Xmask; TOPOGRAPHY(:,1)];
                            Yplus = [Ymask; TOPOGRAPHY(:,2)];
                            Pfiles__Mask_2D(h_fig,h_ax, Xplus,Yplus); 
                        else
                            Pfiles__Mask_2D(h_fig,h_ax, Xmask,Ymask); 
                        end
                    else
                        Pfiles__Mask_2D(h_fig,h_ax, Xmask,Ymask);    
                    end
                end
            else
                sprintf('**** MESSAGE ****\nMatlab version < R2014B\n impossible to generate a 2D mask.')
            end
            %
            hold(h_ax,'on')
            colorbar;
            %
            %% stations
            if strcmp( get(H.menu.view.view2d_Stations,'Checked'), 'on')    
                for d = 1:Ndata
                    clr = 'k';
                    if DTB__status(d,1) ~= 2
                        if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                            clr = 'g';
    %                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','g','MarkerFaceColor','g');% user selected
                        else
                            clr = 'r';
    %                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','r','MarkerFaceColor','r');% auto-selected
                        end
                    end
                    plot(h_ax,SURVEYS{d,1}(1),SURVEYS{d,1}(2),'o','Color',clr,'MarkerFaceColor',clr);% auto-selected
                    hold(h_ax,'on')
                end
    %             for d = 1:Ndata
                if ~isempty(TOPOGRAPHY)
                    plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
                end
            end
            %% XLIM
            Xlm = Xscatt; 
            Ylm = Yscatt;
            if strcmp(extpt_mode,'yes')
                if ~isempty(TOPOGRAPHY)
                    Xlm = [Xscatt; TOPOGRAPHY(:,1)];
                    Ylm = [Yscatt; TOPOGRAPHY(:,2)]; 
                end   
            end
            xlim([min(Xlm),  max(Xlm)]);
            ylim([min(Ylm),  max(Ylm)]);
            %% PROPORTIONS
            daspect(h_ax, P.data_aspectis_aerialmap)
            xlabel(h_ax,'X (E/W).   Colorbar: Frequency','fontweight','bold')
            ylabel(h_ax,'Y (N/S)','fontweight','bold')            
        end
        is_done();
    end
    function Graphics_2dView_hvsr_main_amplitude(newfigure)
        is_drawing();
        if(newfigure)
            h_fig = figure('name','Spectrum of Windows');
            h_ax= gca;%get(h_fig,'CurrentAxes');
        else
            h_fig = H.gui;
            h_ax = hAx_2DViews;
        end
        set(h_fig,'CurrentAxes',h_ax);
        %if get(H.menu.view.HoldOn,'UserData')==1
        if strcmp( get(H.menu.view.HoldOn,'Checked'), 'off')    
            hold(h_ax,'off'); cla(h_ax);
        end
        
        Ndata = size(SURVEYS,1);
        Xscatt = zeros(Ndata,1);
        Yscatt = zeros(Ndata,1);
        Vscatt = zeros(Ndata,1);
        Xmask = zeros(Ndata,1);
        Ymask = zeros(Ndata,1);
        d=0;
        for n = 1:Ndata
            Xmask(n) = SURVEYS{n,1}(1);
            Ymask(n) = SURVEYS{n,1}(2);
            if DTB__status(n,1) ~= 2
                if isnan(DTB__hvsr__auto_main_peak_amplitude(n,1)) && isnan(DTB__hvsr__user_main_peak_amplitude(n,1))
                    continue;
                end
                %
                d=d+1;
                Xscatt(d) = SURVEYS{n,1}(1);
                Yscatt(d) = SURVEYS{n,1}(2);
                if ~isnan(DTB__hvsr__user_main_peak_amplitude(n,1))
                    Vscatt(d) = DTB__hvsr__user_main_peak_amplitude(n,1);
                else
                    Vscatt(d) = DTB__hvsr__auto_main_peak_amplitude(n,1);
                end
            end
        end
        Xscatt = Xscatt(1:d,1);
        Yscatt = Yscatt(1:d,1);
        Vscatt = Vscatt(1:d,1);
        if d<3; return; end
        %
        %
        nx = str2double( get(T4_dx,'string') );
        ny = str2double( get(T4_dy,'string') );
        colorstyle_id   = get(h_contour_color_style,'value');
        colorstyle_list = get(h_contour_color_style,'string');
        colorstyle = colorstyle_list(colorstyle_id,:);
        N_colorLevels = str2double(get(h_contour_color_levels,'String'));
        % use exra points for better interpolation
        extpt_id   = get(h_contour_extra_points,'value');
        extpt_list = get(h_contour_extra_points,'string');
        extpt_mode = extpt_list(extpt_id,:);
        %% EXTRA POINTS IN INTERPOLATION ?
%         if strcmp(extpt_mode,'yes')
%             if ~isempty(TOPOGRAPHY)
%                 Xscatt = [Xscatt; TOPOGRAPHY(:,1)];
%                 Yscatt = [Yscatt; TOPOGRAPHY(:,2)];
%                 Vscatt = [Vscatt; 0*TOPOGRAPHY(:,1)];%<<<<<< DEVELOPMENT: what is the best value to place here??
%             end
%         end
        %% CONTOURS
        dl = 0;% extra space (not used)
        if Matlab_Release_num <=2012.2
            %>> warning('SAM: check the exact release')
            contourf_2D_of_scattered_points__2012b(h_fig,h_ax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, N_colorLevels);% 2014
        else
            contourf_2D_of_scattered_points__ScattInterpol(h_fig,h_ax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, N_colorLevels);% 2014
        end
        hold(h_ax,'on');
        if strcmp( get(H.menu.view.view2d_Stations,'Checked'), 'on')    
            for d = 1:Ndata
                clr = 'k';
                if DTB__status(d,1) ~= 2
                    if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                        clr = 'g';
%                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','g','MarkerFaceColor','g');% user selected
                    else
                        clr = 'r';
%                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','r','MarkerFaceColor','r');% auto-selected
                    end
                end
                plot(h_ax,SURVEYS{d,1}(1),SURVEYS{d,1}(2),'o','Color',clr,'MarkerFaceColor',clr);% auto-selected
                hold(h_ax,'on')
            end
%             for d = 1:Ndata
            if ~isempty(TOPOGRAPHY)
                plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
            end
%             end
        end
        %
        hold(h_ax,'on')
        colorbar;
        %
        %% stations
        if strcmp( get(H.menu.view.view2d_Stations,'Checked'), 'on')    
            for d = 1:Ndata
                clr = 'k';
                if DTB__status(d,1) ~= 2
                    if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                        clr = 'g';
%                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','g','MarkerFaceColor','g');% user selected
                    else
                        clr = 'r';
%                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','r','MarkerFaceColor','r');% auto-selected
                    end
                end
                plot(h_ax,SURVEYS{d,1}(1),SURVEYS{d,1}(2),'o','Color',clr,'MarkerFaceColor',clr);% auto-selected
                hold(h_ax,'on')
            end
%             for d = 1:Ndata
            if ~isempty(TOPOGRAPHY)
                plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
            end
%             end
        end
        %% MASK
        if Matlab_Release_num >=2014.2
            if strcmp( get(H.menu.view.view2d_Mask,'Checked'), 'on')
                if strcmp(extpt_mode,'yes')
                    if ~isempty(TOPOGRAPHY)
                        Xplus = [Xmask; TOPOGRAPHY(:,1)];
                        Yplus = [Ymask; TOPOGRAPHY(:,2)];
                        Pfiles__Mask_2D(h_fig,h_ax, Xplus,Yplus); 
                    end
                else
                    Pfiles__Mask_2D(h_fig,h_ax, Xmask,Ymask);    
                end
            end
        else
            sprintf('**** MESSAGE ****\nMatlab version < R2014B\n impossible to generate a 2D mask.')
        end



        %% XLIM
        Xlm = Xscatt; 
        Ylm = Yscatt;
        if strcmp(extpt_mode,'yes')
            if ~isempty(TOPOGRAPHY)
                Xlm = [Xscatt; TOPOGRAPHY(:,1)];
                Ylm = [Yscatt; TOPOGRAPHY(:,2)]; 
            end    
        end
        xlim([min(Xlm),  max(Xlm)]);
        ylim([min(Ylm),  max(Ylm)]);
        %% PROPORTIONS
        daspect(h_ax, P.data_aspectis_aerialmap)
        xlabel(h_ax,'X (E/W). Colorbar: Amplitude','fontweight','bold')
        ylabel(h_ax,'Y (N/S)','fontweight','bold')
        is_done();
    end
    function Graphics_2dView_hvsr_direction_at_main_peak(newfigure)
        is_drawing();
        if(newfigure)
            h_fig = figure('name','no name specified');
            h_ax= gca;%get(h_fig,'CurrentAxes');
        else
            h_fig = H.gui;
            h_ax = hAx_2DViews;
        end
        set(h_fig,'CurrentAxes',h_ax);
        scalearrows = str2double( get(T4_arrow_scale,'string') );%scale arrows as percent/100 of maximum size
        if strcmp( get(H.menu.view.HoldOn,'Checked'), 'off')
        %if get(H.menu.view.HoldOn,'UserData')==1
            hold(h_ax,'off'); cla(h_ax);
        end
        %
        Ndata  = size(SURVEYS,1);
        Xscatt = zeros(Ndata,1);
        Yscatt = zeros(Ndata,1);
        active_stations = zeros(Ndata,1);
        %
        Ampl   = zeros(Ndata,1);
        Ampl_ave   = zeros(Ndata,1);% average amplitude (f)  (at peak)
        DirectionalPeakValues = cell(Ndata,1);
        Grads = zeros(Ndata,1);
        Grads_span = zeros(Ndata,2);
        Df_Grads = cell(Ndata,1);
        Df_Ampl  = cell(Ndata,1);
        ddf =str2double( get(h_deltafmainpeak,'string') )/2;
        d=0;
        for n = 1:Ndata
            if (DTB__status(n,1) ~= 2) && (DTB__hvsr180__angle_id(n,1)>1)
                d=d+1;
                active_stations(d) = n;
                Xscatt(d) = SURVEYS{n,1}(1);
                Yscatt(d) = SURVEYS{n,1}(2);
                if ~isnan(DTB__hvsr__user_main_peak_amplitude(n,1))
                    PeakId = DTB__hvsr__user_main_peak_id_in_section(n,1);
                    PeakFr = DTB__hvsr__user_main_peak_frequence(n,1);% 20180719
                else
                    PeakId = DTB__hvsr__auto_main_peak_id_in_section(n,1);
                    PeakFr = DTB__hvsr__auto_main_peak_frequence(n,1);% 20180719
                end
                Ampl(d)= 100*DTB__hvsr180__preferred_direction{n,1}(PeakId,2)/DTB__hvsr180__preferred_direction{n,1}(PeakId,10);% 100*abs(amplimax-aver)/aver (percentual difference)
                Ampl_ave(d)=DTB__hvsr180__preferred_direction{n,1}(PeakId,10);
                % Ampl(d) is equivalent to: weight =  100*abs(prd(ff,3)-prd(ff,10))/prd(ff,10); % percent difference of maximum and average
                %
                % main peak
                DirectionalPeakValues{d,1} = DTB__hvsr180__spectralratio{n,1}(PeakId, :);
                [~,c] = find(DirectionalPeakValues{d,1}==max(DirectionalPeakValues{d,1}));
                MaindirectionId_i=c(1);%(d)=c(1);
                theta = DTB__hvsr180__angle_step(n,1);
                angles = 0:theta:(180-theta);
                Grads(d) = angles(MaindirectionId_i);%(d));
                % fprintf('[%d]  angle[%d]',n,Grads(d))
                %
                % around main peak (to be sure that not much variability is present)
                % as of 20180719 ddf is defined as percentage
                if ddf >0
                    offseti = DTB__section__Frequency_Vector{n,1}(1);
                    odf = DTB__section__Frequency_Vector{n,1}(3); 
                    ni1 = floor( (PeakFr*(1-ddf/100))/odf ) -offseti+1;%   20190330   PeakFr = (PeakId+offseti-1)*odf
                    ni2 = ceil(  (PeakFr*(1+ddf/100))/odf ) -offseti+1;%   20190330   (PeakFr +- perturbation)/odf -offseti+1 = freq.locat   ---> check: 100*(PeakFr-(ni1+offseti-1)*odf)/PeakFr

                    istr = ni1; if istr<1; istr=1; end
                    istp = ni2; if istp>size(DTB__hvsr180__preferred_direction{n,1},1); istp=PeakId; end
                    %
                    %fprintf(' Frequency ids Min/Peak/Max  [%d   %d   %d] \n', ni1,  PeakId, ni2);
                    fprintf(' Frequency  (-)[%3.2f]  Peak[%3.2f]   (+)[%3.2f]   \n',(ni1+offseti-1)*odf, PeakFr,(ni2+offseti-1)*odf);
                    %
                    ids =  istr:istp;
                    directs = DTB__hvsr180__preferred_direction{n,1}(ids,1);
                    Df_Grads{d,1} = angles(directs);
                    Df_Ampl{d,1}  = DTB__hvsr180__preferred_direction{n,1}(ids,2);
                end 
            end
        end
        if d>2
            Xscatt = Xscatt(1:d,1);
            Yscatt = Yscatt(1:d,1);
            Ampl   = Ampl(1:d,1);
            Grads  = Grads(1:d,1);
            active_stations = active_stations(1:d,1);
            Nactive = size(active_stations,1);
            %
            Dxx=(max(Xscatt)-min(Xscatt));
            Dyy=(max(Yscatt)-min(Yscatt));
            %        
            hold(h_ax,'on')
            colorbar;
            %% directions around peak (min, max,average)
            if ddf>0
                % this part is pretty stand-alone
                df_xproj_mi = zeros(Nactive,1);
                df_xproj_me = zeros(Nactive,1);
                df_xproj_ma = zeros(Nactive,1);
                df_yproj_mi = zeros(Nactive,1);
                df_yproj_me = zeros(Nactive,1);
                df_yproj_ma = zeros(Nactive,1);
                for d = 1:Nactive
                    %n = active_stations(d);
                    mim = min(Df_Grads{d,1});
                    [~,imim]= find(Df_Grads{d,1}==mim);
                    Ami = abs(min(Df_Ampl{d,1}(imim,1)) - Ampl_ave(d))/Ampl_ave(d);
                    %
                    mam = max(Df_Grads{d,1});
                    [~,imam]= find(Df_Grads{d,1}==mam);
                    Ama = abs(max(Df_Ampl{d,1}(imam,1))-Ampl_ave(d))/Ampl_ave(d);
                    %
                    mem = (mim+mam)/2;
                    df_rad = [mim; mem; mam]*pi/180;%   rr=gg*pi/180
                    Ame = (Ama+Ami)/2;
                    df_xproj = cos(df_rad);
                    df_yproj = sin(df_rad);
                    %
                    df_xproj_mi(d) = Ami*df_xproj(1);
                    df_xproj_me(d) = Ame*df_xproj(2);
                    df_xproj_ma(d) = Ama*df_xproj(3);

                    df_yproj_mi(d) = Ami*df_yproj(1);
                    df_yproj_me(d) = Ame*df_yproj(2);
                    df_yproj_ma(d) = Ama*df_yproj(3);
                    %
                    Grads_span(d,1) = mim;
                    Grads_span(d,2) = mam;
                    %
                    fprintf(' Angles:  Min[%3.2f]    Peak[%3.2f]    Max[%3.2f]\n',Grads_span(d,1), Grads(d), Grads_span(d,2));
                end
                quiver(Xscatt,Yscatt, df_xproj_mi,df_yproj_mi, scalearrows,'g')
                quiver(Xscatt,Yscatt, df_xproj_me,df_yproj_me, scalearrows,'y')
                quiver(Xscatt,Yscatt, df_xproj_ma,df_yproj_ma, scalearrows,'r')
            end
            %% main direction (at peak)
            %arrowmaxlength = scalearrows*max([ ,  ]);
            %   \  |y /(N)
            %    \ | /
            %     \|/_____x(E)
            Rads = Grads*pi/180;%   rr=gg*pi/180
            xproj = cos(Rads);%  scalearrows*Dxy  ;
            yproj = sin(Rads);
            for d = 1:Nactive
                xproj(d) = Ampl(d)*xproj(d);
                yproj(d) = Ampl(d)*yproj(d);
            end
            quiver(Xscatt,Yscatt, xproj,yproj, scalearrows,'k')
            %
            %
            hold(h_ax,'on')        
            %% measure points
            %% stations
            if strcmp( get(H.menu.view.view2d_Stations,'Checked'), 'on')    
                for d = 1:Ndata
                    clr = 'k';
                    if DTB__status(d,1) ~= 2
                        if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                            clr = 'g';
    %                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','g','MarkerFaceColor','g');% user selected
                        else
                            clr = 'r';
    %                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','r','MarkerFaceColor','r');% auto-selected
                        end
                    end
                    plot(h_ax,SURVEYS{d,1}(1),SURVEYS{d,1}(2),'o','Color',clr,'MarkerFaceColor',clr);% auto-selected
                    hold(h_ax,'on')
                end
            end
            %% extra points
            if strcmp( get(H.menu.view.view2d_ExtraPoints,'Checked'), 'on')    
                if ~isempty(TOPOGRAPHY)
                    plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
                end
            end
            %
            %% angle annotation
            if strcmp( get(H.menu.view.view2d_Angle_Annotation,'Checked'), 'on')   
                 switch USER_PREFERENCE_hvsr_directional_reference_system
                    case 'compass'
                        Grads2 = -Grads+90;
                    otherwise
                        Grads2 = Grads;
                end
                
                for d = 1:Nactive
                    tst = strcat(num2str(Grads2(d)), sprintf(char(176)));
                    text(Xscatt(d),Yscatt(d), tst  );
                end
            end
            %% station annotation
            if strcmp( get(H.menu.view.view2d_Station_Annotation,'Checked'), 'on')    
                for d = 1:Nactive
                    tst = strcat('R',num2str(active_stations(d)));
                    text(Xscatt(d),Yscatt(d), tst  );
                end
            end
            %
            mu=0.3;
            xlim([min(Xscatt)-mu*Dxx,  max(Xscatt)+mu*Dxx]);
            ylim([min(Yscatt)-mu*Dyy,  max(Yscatt)+mu*Dyy]);
            %% PROPORTIONED
            daspect(h_ax, P.data_aspectis_aerialmap)
            %xlabel(h_ax,'X (E/W)','fontweight','bold')
            switch USER_PREFERENCE_hvsr_directional_reference_system
                case 'compass'
                    xlabel(sprintf('X (E/W)\nAngle (Deg.) N=0, E=90'),'fontweight','bold')
                otherwise
                    xlabel(sprintf('X (E/W)\nAngle (Deg.) N=90, E=0'),'fontweight','bold')
            end
            ylabel(h_ax,'Y (N/S)','fontweight','bold')
            %% SAMUEL LEGEND
            xxp = get(h_ax,'xlim'); ddx = xxp(2)-xxp(1);
            yyp = get(h_ax,'ylim'); ddy = xxp(2)-xxp(1);
            text( (xxp(1)+0.85*ddx), (yyp(1)+0.05*ddy), '\leftarrow', 'Color', 'k');
            text( (xxp(1)+0.90*ddx), (yyp(1)+0.05*ddy), 'at peak');
            if ddf>0
                text( (xxp(1)+0.85*ddx), (yyp(1)+0.20*ddy), '\leftarrow', 'Color', 'g');
                text( (xxp(1)+0.90*ddx), (yyp(1)+0.20*ddy), 'minimum');
                %
                text( (xxp(1)+0.85*ddx), (yyp(1)+0.15*ddy), '\leftarrow', 'Color', 'y');
                text( (xxp(1)+0.90*ddx), (yyp(1)+0.15*ddy), 'average');
                %
                text( (xxp(1)+0.85*ddx), (yyp(1)+0.10*ddy), '\leftarrow', 'Color', 'r');
                text( (xxp(1)+0.90*ddx), (yyp(1)+0.10*ddy), 'maximum');
            end           
        end
        is_done();
    end
    function Graphics_2dView_slice_at_specific_frequence(newfigure)
        is_drawing();
        if(newfigure)
            h_fig = figure('name','Slice at specific Frequence');
            h_ax= gca;% et(h_fig,'CurrentAxes');
        else
            h_fig = H.gui;
            h_ax = hAx_2DViews;
        end
        set(h_fig,'CurrentAxes',h_ax);
        if strcmp( get(H.menu.view.HoldOn,'Checked'), 'off')
        %if get(H.menu.view.HoldOn,'UserData')==1
            hold(h_ax,'off'); cla(h_ax);
        end
        ii = P.Flags.View_2D_contour_freq_slice_id;% frequence id
        %
        Ndata = size(SURVEYS,1);
        Xscatt = zeros(Ndata,1);
        Yscatt = zeros(Ndata,1);
        Vscatt = zeros(Ndata,1);
        d=0;
        for n = 1:Ndata
            if DTB__status(n,1) ~= 2
                if isempty(DTB__hvsr__curve{ (d+1) ,1}); continue; end
                d=d+1;
                Xscatt(d) = SURVEYS{d,1}(1);
                Yscatt(d) = SURVEYS{d,1}(2);
                Vscatt(d) = DTB__hvsr__curve{d,1}(ii,1);% user selection is always preferred
            end
        end
        Xscatt = Xscatt(1:d,1);
        Yscatt = Yscatt(1:d,1);
        Vscatt = Vscatt(1:d,1);
        if d>2
            nx = str2double( get(T4_dx,'string') );
            ny = str2double( get(T4_dy,'string') );
            %
            colorstyle_id   = get(h_contour_color_style,'value');
            colorstyle_list = get(h_contour_color_style,'string');
            colorstyle = colorstyle_list(colorstyle_id,:);
            N_colorLevels = str2double(get(h_contour_color_levels,'String'));
            % use exra points for better interpolation
            extpt_id   = get(h_contour_extra_points,'value');
            extpt_list = get(h_contour_extra_points,'string');
            extpt_mode = extpt_list(extpt_id,:);
            if strcmp(extpt_mode,'yes')
                if ~isempty(TOPOGRAPHY)
                    Xscatt = [Xscatt; TOPOGRAPHY(:,1)];
                    Yscatt = [Yscatt; TOPOGRAPHY(:,2)];
                    Vscatt = [Vscatt; 0*TOPOGRAPHY(:,1)];%<< what is the best value to place here??
                end
            end
            %% contours
            dl = 0;% extra space (not used) 
            if Matlab_Release_num <=2012.2
                %>> warning('SAM: check the exact release')
                contourf_2D_of_scattered_points__2012b(h_fig,h_ax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, N_colorLevels);% 2014
            else
                contourf_2D_of_scattered_points__ScattInterpol(h_fig,h_ax,nx,ny,dl,  Xscatt,Yscatt,Vscatt, colorstyle, N_colorLevels);% 2014
            end
            hold(h_ax,'on');
            %% MASK
            if strcmp( get(H.menu.view.view2d_Mask,'Checked'), 'on')
                if Matlab_Release_num >=2014.2
                    %if get(H.menu.view.view2d_Mask,'UserData')==1
                    Pfiles__Mask_2D(h_fig,h_ax, Xscatt,Yscatt);
                else
                    sprintf('**** MESSAGE ****\nMatlab version < R2014B\n impossible to generate a 2D mask.')
                end
            end
            %% COLORBAR
            hold(h_ax,'on')
            colorbar;
            %% STATIONS 
            if strcmp( get(H.menu.view.view2d_Stations,'Checked'), 'on')    
                for d = 1:Ndata
                    clr = 'k';
                    if DTB__status(d,1) ~= 2
                        if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                            clr = 'g';
    %                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','g','MarkerFaceColor','g');% user selected
                        else
                            clr = 'r';
    %                         plot(h_ax,Xscatt(d),Yscatt(d),'o','Color','r','MarkerFaceColor','r');% auto-selected
                        end
                    end
                    plot(h_ax,SURVEYS{d,1}(1),SURVEYS{d,1}(2),'o','Color',clr,'MarkerFaceColor',clr);% auto-selected
                    hold(h_ax,'on')
                end
    %             for d = 1:Ndata
                if ~isempty(TOPOGRAPHY)
                    plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
                end
    %             end
            end        
            %% XLIM
            Xlm = Xscatt; 
            Ylm = Yscatt;
            if strcmp(extpt_mode,'yes')
                if ~isempty(TOPOGRAPHY)
                    Xlm = [Xscatt; TOPOGRAPHY(:,1)];
                    Ylm = [Yscatt; TOPOGRAPHY(:,2)]; 
                end   
            end
            xlim([min(Xlm),  max(Xlm)]);
            ylim([min(Ylm),  max(Ylm)]);        
            %% color limits
            caxis([P.Flags.Global_MIN_Amplitude,0.75*P.Flags.Global_MAX_Amplitude]);
            %% PROPORTIONED
            daspect(h_ax, P.data_aspectis_aerialmap)
            xlabel(h_ax,'X (E/W). Colorbar: Amplitude','fontweight','bold')
            ylabel(h_ax,'Y (N/S)','fontweight','bold')           
        end
        is_done();
    end
    %
    function Graphics_plot_2d_profile(newfigure)
        is_drawing();
        quantity = P.Flags.View_2D_current_submode;
        if(newfigure)
            h_fig = figure('name',strcat('HVSR-Profiling: Profile ID=',num2str(P.profile.id)));
            h_ax= gca;% et(h_fig,'CurrentAxes');
        else
            h_fig = H.gui;
            h_ax = hAx_2DViews;
        end
        set(h_fig,'CurrentAxes',h_ax);
        %
        if(isempty(P.profile_ids))
            Message = sprintf('NO PROFILES WERE CREATED\n. \nProfile Creation: (On "Main" Tab)\n1) Define profiles by right-clicking on the map.\n2) Click to set the profile''s start point.\n3) Click again to set the profile''s end point.\n4) Include stations by entering the desired distance from profile.\n5) Use add/remove buttons to include/exclude single stations.\n \nProfile Visualization: (on this Tab)\n1) Select a profile to be shown using the [-][->][+] buttons.\n2) Select a the property to be shown using buttons on the rigth.');
            msgbox(Message,'INFO')
            return;
        end
        %   
        set(h_fig,'CurrentAxes',h_ax);
        %set(h_ax,'Visible','off');
        %hold(h_ax,'off')
        %cla(h_ax)
        if strcmp( get(H.menu.view.HoldOn,'Checked'), 'off')
            hold(h_ax,'off'); cla(h_ax);
        end
        %%
        Fnew = P.Reference_Freq_scale.';
        Nf = length(Fnew);
        %% profile creation
        if P.profile.id==0; return; end
        if P.profile.id>size(P.profile_ids,1); P.profile.id=size(P.profile_ids,1); end
        Nhv   = size(P.profile_ids{P.profile.id,1},1);
        if Nhv>1
            Profile_data = zeros(Nf,Nhv);
            Delete_columns = zeros(1, size(P.profile_ids{P.profile.id,1}, 1) );
            str='---';
            %
            switch(quantity)
                case 1 % HVSR
                    for rr = 1:Nhv
                        cc = P.profile_ids{P.profile.id,1}(rr,1);% Id of hvsr curve involved in profile
                        if DTB__status(cc,1) ~= 2
                            % old
                            df = DTB__section__Frequency_Vector{cc,1}(3);
                            Fold = df*(  (DTB__section__Frequency_Vector{cc,1}(1)-1) : (DTB__section__Frequency_Vector{cc,1}(2)-1) );
                            Cold = DTB__hvsr__curve{cc,1};
                            % new
                            Cnew = spline(Fold,Cold, Fnew);
                            Profile_data(:,rr) = Cnew;
                        else
                            Delete_columns(rr)=1;
                        end
                    end
                    str='HVSR';
                case 2 % HVSR-E
                    for rr = 1:Nhv
                        cc = P.profile_ids{P.profile.id,1}(rr,1);% Id of hvsr curve involved in profile
                        if DTB__status(cc,1) ~= 2
                            % old
                            df = DTB__section__Frequency_Vector{cc,1}(3);
                            Fold = df*(  (DTB__section__Frequency_Vector{cc,1}(1)-1) : (DTB__section__Frequency_Vector{cc,1}(2)-1) );
                            Cold = DTB__hvsr__curve_EV{cc,1};
                            % new
                            Cnew = spline(Fold,Cold, Fnew);
                            Profile_data(:,rr) = Cnew;
                        else
                            Delete_columns(rr)=1;
                        end
                    end
                    str='E/V';
                case 3 % HVSR-N
                    for rr = 1:Nhv
                        cc = P.profile_ids{P.profile.id,1}(rr,1);% Id of hvsr curve involved in profile
                        if DTB__status(cc,1) ~= 2
                            % old
                            df = DTB__section__Frequency_Vector{cc,1}(3);
                            Fold = df*(  (DTB__section__Frequency_Vector{cc,1}(1)-1) : (DTB__section__Frequency_Vector{cc,1}(2)-1) );
                            Cold = DTB__hvsr__curve_NV{cc,1};
                            % new
                            Cnew = spline(Fold,Cold, Fnew);
                            Profile_data(:,rr) = Cnew;
                        else
                            Delete_columns(rr)=1;
                        end
                    end
                    str='N/V';
                case 4 % Confidence
                    for rr = 1:Nhv
                        cc = P.profile_ids{P.profile.id,1}(rr,1);% Id of hvsr curve involved in profile
                        if DTB__status(cc,1) ~= 2
                            % old
                            df = DTB__section__Frequency_Vector{cc,1}(3);
                            Fold = df*(  (DTB__section__Frequency_Vector{cc,1}(1)-1) : (DTB__section__Frequency_Vector{cc,1}(2)-1) );
                            Cold = DTB__hvsr__confidence95{cc,1};
                            % new
                            Cnew = spline(Fold,Cold, Fnew);
                            Profile_data(:,rr) = Cnew;
                        else
                            Delete_columns(rr)=1;
                        end
                    end
                    str='Confidence 95%';
            end
            %% Normalization
            switch P.profile.normalization_strategy
                %case 0; nothing to be done (normalization off)
                case 1% normalize columns according to the amplitude of peak
                    for rr = 1:Nhv
                        cc = P.profile_ids{P.profile.id,1}(rr,1);% Id of hvsr curve involved in profile
                        if ~isnan(DTB__hvsr__user_main_peak_amplitude(cc,1))
                            aa = DTB__hvsr__user_main_peak_amplitude(cc,1);
                        else
                            aa = DTB__hvsr__auto_main_peak_amplitude(cc,1);
                        end  
                        Profile_data(:,rr) = Profile_data(:,rr)./aa;
                    end
                case 2% min/max of all curves
                    if P.Flags.Global_MAX_Amplitude>0
                        Profile_data = Profile_data./P.Flags.Global_MAX_Amplitude;
                    end
                case 3% min/max of curves in the profile
                    if P.Flags.Global_MAX_Amplitude>0
                        Profile_data = Profile_data./max(max(abs(Profile_data)));
                    end
            end
            rr = P.profile_ids{P.profile.id,1}(:,2);
            zvec = Fnew;
            zmax = max(zvec);
            zz = zeros(length(rr),1)+zmax;

            %% delete Excluded
            if sum(Delete_columns)>0
                [~,keep_colums] = find(Delete_columns==0);
                Profile_data = Profile_data(:, keep_colums);
                rr = rr(keep_colums);
            end
            %str2double( get(T4_dx,'string') );
            %nyy = str2double( get(T4_dy,'string') );
            %%
            %
            imagenorm_profile(Profile_data,  rr, zvec, P.profile.N_X_points, P.profile.smoothing_strategy, P.profile.smoothing_radius);
            temporary_profile{1,1} = Profile_data;
            temporary_profile{1,2} = rr;
            temporary_profile{1,3} = zvec;
            set(gca,'yscale','log');
            %
            axis(h_ax,'xy')
            hold(h_ax,'on')
            %       
            zn = [zvec(1),zvec(end)];
            rr = P.profile_ids{P.profile.id,1}(:,2);
            for m = 1:size(P.profile_ids{P.profile.id,1},1)
                cc = P.profile_ids{P.profile.id,1}(m,1);% Id of hvsr curve involved in profile
                if DTB__status(cc,1) ~= 2
                    plot(h_ax,  rr(m)*[1,1],zn,'--','Color','g','LineWidth',1);
                    plot(h_ax,  rr,zz,'og','MarkerSize',5,'Color','g','MarkerFaceColor','g');
                else
                    plot(h_ax,  rr(m)*[1,1],zn,'--','Color','k','LineWidth',1);
                    plot(h_ax,  rr,zz,'og','MarkerSize',5,'Color','k','MarkerFaceColor','k');
                end
                lbl = strcat('R', num2str(P.profile_ids{P.profile.id,1}(m,1)));
                text(rr(m),zmax,lbl)
            end
            %
            title(str);
            xlabel('Distance','fontweight','bold')
            ylabel('Frequence (Hz)','fontweight','bold')
            %
            %% PROPORTIONED
            if ~isempty(P.data_aspectis_profile)
                daspect(h_ax, P.data_aspectis_profile)
            else
                ddx = max(rr)-min(rr);
                ddy = max(zvec)-min(zvec);
                if ddx>ddy
                    aa = 1;
                    bb = 3*ddy/ddx;
                    daspect(h_ax, [aa,bb,1])
                else
                    aa = 3*ddx/ddy;
                    bb = 1;
                    daspect(h_ax, [aa,bb,1])
                end
                
                
            end
            set(h_ax,'Visible','on');           
        else
            plot(h_ax,0,0);
            strimes = sprintf('Profile %d comprise less than 2 stations. Interpolation could not be performed.',P.profile.id);
            legend(h_ax,strimes)
        end
        is_done();
	end
%%    plot: 3-D
    function Graphics_3dView_quiver(newfigure, mode)      
        if isempty(SURVEYS); return; end
%         enforce_min_amplitude_diff_hreshold_for_reliable_directionality = 1;
%         aag = str2double( get(h_bkdots_damplitude,'String') );% bound on amplitude. Below this value is not considered;  190120 x Caputo        
        
        is_drawing();
        status = 0;
        for ss=1:size(SURVEYS,1)
            if DTB__windows__number(ss,1)~=0; status = 1; break; end
        end
        if status == 0; return; end
        %
        %
        %
        set(hT3did,'String','...');
        if strcmp(P.ExtraFeatures.debug_mode,'on')
            fprintf('Graphics_3dView_quiver: mode %d\n',mode)
        end
        cid = P.isshown.id_Vf;
        if cid==0; return; end
        if mode==3% decide if to procede
            if(isempty(DTB__hvsr180__spectralratio{cid,1}))
                Message = 'No Directional-HV was peformed for this file';
                msgbox(Message,'INFO')
                return;
            end
            if DTB__status(cid,1)==2
                Message = 'This file was marked as "EXLUDED" froom the survey';
                msgbox(Message,'INFO')
                return;
            end
            set(hT3did,'String',strcat('R',num2str(cid))); 
        end
        
        if(newfigure)
            h_fig = figure('name','no name specified');
            h_ax = gca;%get(h_fig,'CurrentAxes');
        else
            h_fig = H.gui;
            h_ax = hAx_3DViews;
        end
        set(h_fig,'CurrentAxes',h_ax);
        hold(h_ax,'off')
        cla(h_ax);
        %
        %% locations
        Ndata = size(SURVEYS,1);
        ddf =str2double( get(h_deltafmainpeak3D,'string') )/2;
        if Ndata>0
            scalearrows = str2double( get(T5_arrow_scale,'string') );%scale arrows as percent/100 of maximum size
            %surface_locations = zeros(Ndata,3);
            Xscatt = zeros(Ndata,1);
            Yscatt = zeros(Ndata,1);
            Zscatt = zeros(Ndata,1);
            active_station_ids = ones(Ndata,1);
            %% modes
            if mode==1% Z=-1/frequency, embedded surface
                %% mode 1: Z = -1/frequency
                %% embedded surface
                dd = 0;
                for d = 1:Ndata
                    if DTB__status(d,1)~=2
                        dd = dd+1;
                        active_station_ids(dd,1) =d;
                        %active_station_bools(d,1)=1;
                        surface_locations(d,1) = SURVEYS{d,1}(1);%#ok
                        surface_locations(d,2) = SURVEYS{d,1}(2);%#ok
                        if ~isnan(DTB__hvsr__user_main_peak_amplitude(d,1))
                            surface_locations(d,3) = 1/DTB__hvsr__user_main_peak_frequence(d,1);%#ok 
                            % user selection is always preferred
                        else
                            surface_locations(d,3) = 1/DTB__hvsr__auto_main_peak_frequence(d,1);%#ok
                        end                
                    end
                end
                if dd>0
                    active_station_ids = active_station_ids(1:dd,:);
                    surface_locations = surface_locations(active_station_ids,:);
                    plot_interpolated_surface(h_ax, surface_locations);
                    grid 'off'
                    %%    measure points plot
                    for d = 1:length(active_station_ids)
                        hvid = active_station_ids(d);
                        if ~isnan(DTB__hvsr__user_main_peak_amplitude(hvid,1))
                            plot3(h_ax,surface_locations(d,1),surface_locations(d,2),surface_locations(d,3),'o','Color','y','MarkerFaceColor','y');% user selected
                        else
                            plot3(h_ax,surface_locations(d,1),surface_locations(d,2),surface_locations(d,3),'o','Color','r','MarkerFaceColor','r');% auto-selected
                        end
                        hold(h_ax,'on')
                    end
                    %
                    xspan = [min(surface_locations(:,1)), max(surface_locations(:,1))];
                    if xspan(1)==xspan(2); xspan = xspan(1)*[0.9, 1.1];  end
                    %
                    yspan = [min(surface_locations(:,2)), max(surface_locations(:,2))];
                    if yspan(1)==yspan(2); yspan = yspan(1)*[0.9, 1.1];  end
                    % 
                    xlim(xspan);
                    ylim(yspan);
                    xlabel(h_ax,'X (E/W)','fontweight','bold')
                    ylabel(h_ax,'Y (N/S)','fontweight','bold')
                    zlabel(h_ax,'1/Freq. (Seconds)','fontweight','bold')
                    drawnow
                end
                %% extra points
                if strcmp( get(H.menu.view.view3d_ExtraPoints,'Checked'), 'on')    
                    if ~isempty(TOPOGRAPHY)
                        plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
                    end
                end
                %% station annotation
                if strcmp( get(H.menu.view.view3d_Station_Annotation,'Checked'), 'on')    
                    for d = 1:size(active_station_ids,1)
                        tst = strcat('R',num2str(active_station_ids(d)));
                        text(surface_locations(active_station_ids(d),1),surface_locations(active_station_ids(d),2),surface_locations(active_station_ids(d),3), tst  );
                    end
                end
            end
            if mode==2% Z=-1/frequency, XY=direction associate to main peak
                %% mode 2: Z=frequency, XY=direction associate to main peak
                %% embedded surface
                DirectionalPeakValues = cell(Ndata,1);
                MaindirectionId = zeros(Ndata,1);%#ok
                Grads = zeros(Ndata,1);
                processed_ids = zeros(Ndata,1);% id's of locations for which processing was fully performed               
                pd = 0;% count processed locations
                Ampl        = zeros(Ndata,1);% 100*(maxamplitude(f)-average(f))/average  (at peak)
                Ampl_ave = zeros(Ndata,1);% average amplitude (f)  (at peak)
                Df_Grads = cell(Ndata,1);
                Df_Ampl = cell(Ndata,1);
                clc
                d = 0;% count active locations
                for n = 1:Ndata
                    if (DTB__status(n,1) ~= 2) && (DTB__hvsr180__angle_id(n,1)>1)
                        if ~isempty(DTB__hvsr180__spectralratio{n,1})
                            if isnan(DTB__hvsr__auto_main_peak_amplitude(n,1)) && isnan(DTB__hvsr__user_main_peak_amplitude(n,1)); continue; end
                            d = d+1;
                            Xscatt(d) = SURVEYS{n,1}(1);
                            Yscatt(d) = SURVEYS{n,1}(2);
                            active_station_ids(d,1)=n;
                            %surface_locations(d,1) = SURVEYS{n,1}(1);
                            %surface_locations(d,2) = SURVEYS{n,1}(2);
                            %
                            if ~isnan(DTB__hvsr__user_main_peak_amplitude(n,1))
                                PeakId = DTB__hvsr__user_main_peak_id_in_section(n,1);
                                %surface_locations(d,3) = 1/DTB__hvsr__user_main_peak_frequence(n,1);% user selection is always preferred
                                Zscatt(d) = 1/DTB__hvsr__user_main_peak_frequence(n,1);% user selection is always preferred
                                PeakFr = DTB__hvsr__user_main_peak_frequence(n,1);% 20180719
                            else
                                PeakId = DTB__hvsr__auto_main_peak_id_in_section(n,1);
                               %surface_locations(d,3) = 1/DTB__hvsr__auto_main_peak_frequence(n,1);
                                Zscatt(d) = 1/DTB__hvsr__auto_main_peak_frequence(n,1);
                                PeakFr = DTB__hvsr__auto_main_peak_frequence(n,1);% 20180719
                            end
                            Ampl(d)= 100*DTB__hvsr180__preferred_direction{n,1}(PeakId,2)/DTB__hvsr180__preferred_direction{n,1}(PeakId,10);% 100*abs(amplimax-aver)/aver (percentual difference)
                            Ampl_ave(d)=DTB__hvsr180__preferred_direction{n,1}(PeakId,10);
                            % Ampl(d) is equivalent to: weight =  100*abs(prd(ff,3)-prd(ff,10))/prd(ff,10); % percent difference of maximum and average
                            %
                            % main peak
                            DirectionalPeakValues{d,1} = DTB__hvsr180__spectralratio{n,1}(PeakId, :);
                            [~,c] = find(DirectionalPeakValues{d}==max(DirectionalPeakValues{d}));
                            %c
                            MaindirectionId_i=c(1);
                            theta = DTB__hvsr180__angle_step(n,1);
                            angles = 0:theta:(180-theta);
                            Grads(d) = angles(MaindirectionId_i);
                            pd = pd+1;
                            processed_ids(pd) = d;
                            % fprintf('[%d]  angle[%d]',n,Grads(d))
                            %
                            % around main peak (to be sure that not much variability is present)
                            % as of 20180719 ddf is defined as percentage
                            if ddf >0
                                offseti = DTB__section__Frequency_Vector{n,1}(1);
                                odf = DTB__section__Frequency_Vector{n,1}(3); 
                                ni1 = floor( (PeakFr*(1-ddf/100))/odf ) -offseti+1;%   20190330   PeakFr = (PeakId+offseti-1)*odf
                                ni2 = ceil(  (PeakFr*(1+ddf/100))/odf ) -offseti+1;%   20190330   (PeakFr +- perturbation)/odf -offseti+1 = freq.locat   ---> check: 100*(PeakFr-(ni1+offseti-1)*odf)/PeakFr

                                istr = ni1; if istr<1; istr=1; end
                                istp = ni2; if istp>size(DTB__hvsr180__preferred_direction{n,1},1); istp=PeakId; end
                                %
                                fprintf(' Frequency ids Min/Peak/Max  [%d   %d   %d] \n', ni1,  PeakId, ni2);
                                %fprintf('   Range[%3.2f][%3.2f]',ni1*odf,ni2*odf);
                                    %
                                ids =  istr:istp;
                                directs = DTB__hvsr180__preferred_direction{n,1}(ids,1);
                                % DTB__hvsr180__preferred_direction:
                                % 1] ccmx(1)                      index(column) of the MAXimum amplitude
                                % 2] abs(amplimx-aver)     difference of max amplitude with respect to average
                                % 3] amplimx                      maximum amplitude
                                % 4] angledegmx               angle corresponding to  maximum amplitude
                                % [5-8]... followed by corresponding variables for the minimum amplitude.
                                % 9] frequency
                                %10] average_amplitude
                                Df_Grads{d,1} = angles(directs);
                                Df_Ampl{d,1}  = DTB__hvsr180__preferred_direction{n,1}(ids,2);
                            end 
                            fprintf('\n')
                        else
                            fprintf('MESSAGE: Directional HVSR was not performed for file [%d]\n',d)
                        end
                    end
                end
                if d>0
                    Xscatt = Xscatt(1:d,1);
                    Yscatt = Yscatt(1:d,1);
                    Ampl   = Ampl(1:d,1);
                    Grads  = Grads(1:d,1);
                    active_station_ids = active_station_ids(1:d,1); 
                    Nactive = size(active_station_ids,1);
                    processed_ids = processed_ids(1:pd,1);% <<<<<<
                    %surface_locations = surface_locations(1:d,:);%surface_locations = surface_locations(active_station_ids,:);                    
                    Ampl_ave=Ampl_ave(1:d,1);
                    Df_Grads{d,1} = Df_Grads{1:d,1};
                    Df_Ampl{d,1}  = Df_Ampl{1:d,1};
                    
                    plot_interpolated_surface(h_ax, [Xscatt,Yscatt,Zscatt]);
                    grid 'off'
                    %% directions around peak (min, max,average)
                    if ddf>0
                        % this part is pretty stand-alone
                        df_xproj_mi = zeros(Nactive,1);
                        df_xproj_me = zeros(Nactive,1);
                        df_xproj_ma = zeros(Nactive,1);
                        df_yproj_mi = zeros(Nactive,1);
                        df_yproj_me = zeros(Nactive,1);
                        df_yproj_ma = zeros(Nactive,1);
                        for d = 1:Nactive
                            %d = active_station_ids(n);
                            mim = min(Df_Grads{d,1});
                            [~,imim]= find(Df_Grads{d,1}==mim);
                            imim=imim(1);
                            Ami = abs(min(Df_Ampl{d,1}(imim,1))-Ampl_ave(d))/Ampl_ave(d);
                            %
                            mam = max(Df_Grads{d,1});
                            [~,imam]= find(Df_Grads{d,1}==mam);
                            imam=imam(1);
                            Ama =abs(max(Df_Ampl{d,1}(imam,1))-Ampl_ave(d))/Ampl_ave(d);
                            %
                            mem = (mim+mam)/2;
                            df_rad = [mim; mem; mam]*pi/180;%   rr=gg*pi/180
                            Ame = (Ama+Ami)/2;
%                             if enforce_min_amplitude_diff_hreshold_for_reliable_directionality% as a percentage 190120
%                                 if Ampl(d)<aag% Ampl(d) is weight =100*abs(amplimax-aver)/aver; % percent difference of maximum and average
%                                     Ami= 0;
%                                     Ame= 0;
%                                     Ama= 0;
%                                 end 
%                             end% 190120
                            df_xproj = cos(df_rad);
                            df_yproj = sin(df_rad);
                            %
                            df_xproj_mi(d) = Ami*df_xproj(1);
                            df_xproj_me(d) = Ame*df_xproj(2);
                            df_xproj_ma(d) = Ama*df_xproj(3);

                            df_yproj_mi(d) = Ami*df_yproj(1);
                            df_yproj_me(d) = Ame*df_yproj(2);
                            df_yproj_ma(d) = Ama*df_yproj(3);
                            Grads_span(d,1) = mim;%#ok
                            Grads_span(d,2) = mam;%#ok
                            %
                            fprintf(' Angles:  Min[%3.2f]    Peak[%3.2f]    Max[%3.2f]\n',Grads_span(d,1), Grads(d), Grads_span(d,2));
                        end
                        zproj = 0*Zscatt;
%                         quiver3(h_ax, surface_locations(:,1),surface_locations(:,2),surface_locations(:,3), df_xproj_mi,df_yproj_mi, zproj, scalearrows,'g')
%                         quiver3(h_ax, surface_locations(:,1),surface_locations(:,2),surface_locations(:,3), df_xproj_me,df_yproj_me, zproj, scalearrows,'y')
%                         quiver3(h_ax, surface_locations(:,1),surface_locations(:,2),surface_locations(:,3), df_xproj_ma,df_yproj_ma, zproj, scalearrows,'r')
                        quiver3(h_ax, Xscatt,Yscatt,Zscatt,   df_xproj_mi,df_yproj_mi,   zproj, scalearrows,'g')
                        quiver3(h_ax, Xscatt,Yscatt,Zscatt,   df_xproj_me,df_yproj_me, zproj, scalearrows,'y')
                        quiver3(h_ax, Xscatt,Yscatt,Zscatt,   df_xproj_ma,df_yproj_ma, zproj, scalearrows,'r')
                    end
                    %
                    %% PLOT
                    %% main direction (at peak)
                    %arrowmaxlength = scalearrows*max([ ,  ]);
                    %   \  |y /(N)
                    %    \ | /
                    %     \|/_____x(E)
                    Rads = Grads*pi/180;%   rr=gg*pi/180
                    xproj = cos(Rads);%  scalearrows*Dxy  ;
                    yproj = sin(Rads);
                    for d = 1:Nactive
%                         if enforce_min_amplitude_diff_hreshold_for_reliable_directionality% as a percentage 190120
%                             if Ampl(d)<aag% Ampl(d) is weight =100*abs(amplimax-aver)/aver; % percent difference of maximum and average
%                                 Ampl(d) = 0;
%                             end 
%                         end% 190120
                        xproj(d) = Ampl(d)*xproj(d);
                        yproj(d) = Ampl(d)*yproj(d);
                    end
                    zproj = 0*Rads;
                    %quiver3(h_ax, surface_locations(:,1),surface_locations(:,2),surface_locations(:,3), xproj(processed_ids),yproj(processed_ids),zproj(processed_ids), scalearrows,'k')
                    quiver3(h_ax,Xscatt,Yscatt,Zscatt,   xproj,yproj,zproj, scalearrows,'k')
                        
                %% measure points
                %% stations
                    hold(h_ax,'on')   
                    if strcmp( get(H.menu.view.view2d_Stations,'Checked'), 'on')    
                        for d = 1:Ndata
                            clr = 'k';
                            if DTB__status(d,1) ~= 2
                                if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                                    clr = 'g';
                                else
                                    clr = 'r';
                                end
                            end
                            plot3(h_ax,Xscatt(d),Yscatt(d),Zscatt(d),'o','Color',clr,'MarkerFaceColor',clr);% auto-selected
                            hold(h_ax,'on')
                        end
                    end
                    
                    %xlabel(h_ax,'X (E/W)','fontweight','bold')
                    switch USER_PREFERENCE_hvsr_directional_reference_system
                        case 'compass'
                            xlabel(sprintf('X (E/W)\nAngle (Deg.) N=0, E=90'),'fontweight','bold')
                        otherwise
                            xlabel(sprintf('X (E/W)\nAngle (Deg.) N=90, E=0'),'fontweight','bold')
                    end
                    ylabel(h_ax,'Y (N/S)','fontweight','bold')
                    zlabel(h_ax,'1/f (Sec.)','fontweight','bold')
                    drawnow
                    %
                    %% SAMUEL LEGEND
                    xxp = get(h_ax,'xlim'); ddx = xxp(2)-xxp(1);
                    yyp = get(h_ax,'ylim'); ddy = xxp(2)-xxp(1);
                    zzp = get(h_ax,'zlim'); ddz = zzp(2)-zzp(1);
                    text( (xxp(1)+0.85*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.05*ddz), '\leftarrow', 'Color', 'k');
                    text( (xxp(1)+0.90*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.05*ddz),'at peak');
                    if ddf>0
                        text( (xxp(1)+0.85*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.10*ddz), '\leftarrow', 'Color', 'g');
                        text( (xxp(1)+0.90*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.10*ddz), 'minimum');
                        %
                        text( (xxp(1)+0.85*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.15*ddz), '\leftarrow', 'Color', 'y');
                        text( (xxp(1)+0.90*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.15*ddz), 'average');
                        %
                        text( (xxp(1)+0.85*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.20*ddz), '\leftarrow', 'Color', 'r');
                        text( (xxp(1)+0.90*ddx), (yyp(1)+0.10*ddy), (zzp(1)+0.20*ddz), 'maximum');
                    end
                    %% extra points
                    if strcmp( get(H.menu.view.view3d_ExtraPoints,'Checked'), 'on')    
                        if ~isempty(TOPOGRAPHY)
                            plot(h_ax,TOPOGRAPHY(:,1),TOPOGRAPHY(:,2),'diamond','Color','y','MarkerFaceColor','y');
                        end
                    end
                    %% angle annotation
                    if strcmp( get(H.menu.view.view3d_Angle_Annotation,'Checked'), 'on')
                        switch USER_PREFERENCE_hvsr_directional_reference_system
                            case 'compass'
                                Grads2 = -Grads+90;
                            otherwise
                                Grads2 = Grads;
                        end
                        for d = 1:size(Zscatt,1)
                            tst = strcat(num2str(Grads2(d)), sprintf(char(176)));
                            text(Xscatt(d),Yscatt(d),Zscatt(d), tst  );
                        end
                    end
                    %% station annotation
                    if strcmp( get(H.menu.view.view3d_Station_Annotation,'Checked'), 'on')    
                        for d = 1:size(surface_locations,1)
                            tst = strcat('R',num2str(processed_ids(d)));
                            text(surface_locations(d,1),surface_locations(d,2),surface_locations(d,3), tst  );
                        end
                    end
                end% dd>0
            end
            if mode==3
                df = DTB__section__Frequency_Vector{cid,1}(3);
                Fvec = df*(  (DTB__section__Frequency_Vector{cid,1}(1)-1) : (DTB__section__Frequency_Vector{cid,1}(2)-1) );
                %
                theta = DTB__hvsr180__angle_step(cid,1);
                angles = (0:theta:(180-theta))';
                %
                Grads = angles(DTB__hvsr180__preferred_direction{cid,1}(:,1));
                Ampl= DTB__hvsr180__preferred_direction{cid,1}(:,2);

                    %arrowmaxlength = scalearrows*max([ ,  ]);
                %   \  |y /(N)
                %    \ | /
                %     \|/_____x(E)
                rads = Grads*pi/180;%   rr=gg*pi/180
                xproj = Ampl.*cos(rads);
                yproj = Ampl.*sin(rads);
                zp = Fvec'; %-1./Fvec';
                xp = SURVEYS{cid,1}(1);
                yp = SURVEYS{cid,1}(2);
                %% embedded surface
                dd = 0;
                for d = 1:Ndata
                    if DTB__status(d,1)~=2
                        dd = dd+1;
                        active_station_ids(d)=dd;
                        surface_locations(d,1) = SURVEYS{d,1}(1);
                        surface_locations(d,2) = SURVEYS{d,1}(2);
                        if ~isnan(DTB__hvsr__user_main_peak_amplitude(d,1))
                            surface_locations(d,3) = 1/DTB__hvsr__user_main_peak_frequence(d,1);% user selection is always preferred
                        else
                            surface_locations(d,3) = 1/DTB__hvsr__auto_main_peak_frequence(d,1);
                        end
                    end
                end
                if dd>0
                    active_station_ids = active_station_ids(1:dd,:);
                    surface_locations = surface_locations(active_station_ids,:);
                    plot_interpolated_surface(h_ax, surface_locations);
                    grid 'off'
                    %% main peak
                    if ~isnan(DTB__hvsr__user_main_peak_frequence(cid,1))
                        PeakId = DTB__hvsr__user_main_peak_id_in_section(cid,1);
                    else
                        PeakId = DTB__hvsr__auto_main_peak_id_in_section(cid,1);
                    end
                     
                    %% Directions
                    magnify = 0.25*sqrt( sum(  (max(surface_locations(:,1:2))-min(surface_locations(:,1:2))).^2) );
                    scalearrows = scalearrows*magnify;
                    vex = xp + scalearrows*xproj;
                    vey = yp + scalearrows*yproj;
                    %
                    hold(h_ax,'off')
                    plot3(h_ax, vex(1), vey(1), zp(1),'.k')
                    drawnow;
                    %
                    for mm = 1:size(zp,1)
                        plot3(h_ax, (xp+scalearrows*xproj(mm)*[-1;1]), (yp+scalearrows*yproj(mm)*[-1;1]), zp(mm)*[1,1],'k');                    
                        if mm==1
                            hold(h_ax,'on')
                        end
                    end
                    %% main peak line
                    if ~isnan(DTB__hvsr__user_main_peak_amplitude(cid,1))
                        plot3(h_ax, (xp+scalearrows*xproj(PeakId)*[-1,1]), (yp+scalearrows*yproj(PeakId)*[-1,1]), zp(PeakId)*[1,1],'diamond-g','LineWidth',2); 
                        plot3(h_ax, xp*[1,1], yp*[1,1], [min(zp),max(zp)],'k')
                    else
                        plot3(h_ax, (xp+scalearrows*xproj(PeakId)*[-1,1]), (yp+scalearrows*yproj(PeakId)*[-1,1]), zp(PeakId)*[1,1],'diamond-r','LineWidth',2);
                        plot3(h_ax, xp*[1,1], yp*[1,1], [min(zp),max(zp)],'k')
                    end
                    %fprintf('plot done\n')
                    hold(h_ax,'on')
                    %% measure points plot
%                     for d = 1:size(surface_locations,1)
%                         if DTB__status(d,1)~=2
%                             if ~isnan(DTB__hvsr__user_main_peak_amplitude(d,1))
%                                 plot3(h_ax,surface_locations(d,1),surface_locations(d,2),surface_locations(d,3),'oy','MarkerFaceColor','y');% user selected
%                             else
%                                 plot3(h_ax,surface_locations(d,1),surface_locations(d,2),surface_locations(d,3),'or','MarkerFaceColor','r');% auto-selected
%                             end
%                             hold(h_ax,'on')
%                         end
%                     end
                    fminb = str2double( get(T5_3D_Option3_fmin,'String') );
                    fmaxb = str2double( get(T5_3D_Option3_fmax,'String') );
                    zlim([fminb, fmaxb]) 
                    xlabel(h_ax,'X (E/W)','fontweight','bold')
                    ylabel(h_ax,'Y (N/S)','fontweight','bold')
                    zlabel('Frequency (Hz)','fontweight','bold')
                end
            end
            %
            if P.Flags.View_3D_daspect
                daspect(h_ax,[str2double(get(T5_daspect_x,'String')),str2double(get(T5_daspect_y,'String')),str2double(get(T5_daspect_z,'String'))])
            end
            if P.Flags.View_3D_box
                box(h_ax,'on')
            end
            if P.Flags.View_3D_grid
                grid(h_ax,'on')
            end
            if mode==1 || mode==2
                set(h_ax, 'Zdir', 'reverse')
            end
            view(3)
            drawnow
        end
        is_done();
    end
    function plot_interpolated_surface(h_ax, surface_locations)  
        %is_drawing();
            %% EXTRA POINTS IN INTERPOLATION ? h_bedrock_extra_points3d
            nx = P.TAB_view3d_Discretization(1);
            ny = P.TAB_view3d_Discretization(2);
            % use exra points for better interpolation
            extpt_id   = get(h_bedrock_extra_points3d,'value');
            extra_locations=[];
            topmost = 0;
            if extpt_id ==2 %strcmp(extpt_mode,'yes')
                if ~isempty(TOPOGRAPHY)
                    extra_locations = TOPOGRAPHY;
                    topmost = 0;
                else
                    extra_locations=[];
                    topmost = 0;
                end
            end
            %
            %% BEDROCK View
            viewmode_id   = get(h_view3d_mode,'value');
            if Matlab_Release_num >=2014.2
                if viewmode_id == 3
                    facecolr = 'interp'; 
                    edgecolr = 'none';
                    Pfiles__SparsePoints_to_Mesh_Surface(surface_locations,extra_locations,topmost,nx,ny, facecolr, edgecolr)% Old version using MESHGRID (mask for interpolated data is difficult)               
                end
                if viewmode_id == 2
                    facecolr = 'none'; 
                    edgecolr = 'k';
                    Pfiles__SparsePoints_to_Mesh_Surface(surface_locations,extra_locations,topmost,nx,ny, facecolr, edgecolr)% Old version using MESHGRID (mask for interpolated data is difficult)
                end
            else
                sprintf('**** MESSAGE ****\nMatlab version < R2014B\n surface visualization not available.')
            end
            hold(h_ax,'on')
            %is_done();
    end% plot_interpolated_surface
    function plots_3D_update()
        %is_drawing();
        switch P.Flags.View_3D_current_mode%  Matlab: before 2014b
            case 1
                %Graphics_3dView_plot3d(H.gui,  hAx_3DViews, P.Flags.View_3D_current_submode);
                Graphics_3dView_plot3d(P.property_23d_to_show, 0);
            case 2
                Graphics_plot_2d_profile(0)% H.gui,  hAx_2DViews, P.Flags.View_3D_current_submode);
            case 3
                Graphics_3dView_quiver(0, P.Flags.View_3D_current_submode);
        end
        %is_done();
    end
%%    Ibs-von Seht and Wolemberg
    function Graphics_IBSeW_plot_regression(newfigure)
        if ~isempty(SURVEYS)
            if(newfigure)
                h_fig = figure('name','no name specified');
                h_ax= gca;%get(h_fig,'CurrentAxes');
            else
                h_fig = H.gui;
                h_ax = hAx_IBS1;
            end
            set(h_fig,'CurrentAxes',h_ax);
            hold(h_ax,'off')
            cla(h_ax);
            %
            Fvec = logspace(-1,2,100);%P.Reference_Freq_scale;    
            %
            Hvec_computed = [];
            if ~isempty(P.regression_computed)
                aval = P.regression_computed(1); 
                bval = P.regression_computed(2);
                Hvec_computed = Pfiles__Ibs_Von_Seht_Like__HfromF(Fvec,aval,bval);
            end
            aval = P.regression_Ibs_von_Seht_1999(1); 
            bval = P.regression_Ibs_von_Seht_1999(2);
            Hvec_Ibs_von_Seht_1999 = Pfiles__Ibs_Von_Seht_Like__HfromF(Fvec,aval,bval);
            % 
            aval = P.regression_Parolai_2002(1); 
            bval = P.regression_Parolai_2002(2);
            Hvec_Parolai_2002 = Pfiles__Ibs_Von_Seht_Like__HfromF(Fvec,aval,bval);
            %
            aval = P.regression_Hinzen_2004(1); 
            bval = P.regression_Hinzen_2004(2);
            Hvec_Hinzen_2004 = Pfiles__Ibs_Von_Seht_Like__HfromF(Fvec,aval,bval);
            %
            %
            %%
            cla(h_ax)
            toshow = get(T6_PA_Regression,'value');
            if toshow==1% all regressions
                if ~isempty(P.regression_computed)
                    loglog(Fvec, Hvec_computed, 'k','linewidth',1); hold(h_ax, 'on')
                end  
                loglog(Fvec, Hvec_Ibs_von_Seht_1999,'b','linewidth',1); hold(h_ax, 'on')
                loglog(Fvec, Hvec_Parolai_2002,     'c','linewidth',1);
                loglog(Fvec, Hvec_Hinzen_2004,      'm','linewidth',1);
                %
                if ~isempty(P.regression_computed)
                    legend('Computed', 'Ibs-von Seht & Wohlemberg 1999', 'Parolai et al. 2002', 'Hinzen et al. 2004')
                else
                    legend('Ibs-von Seht & Wohlemberg 1999', 'Parolai et al. 2002', 'Hinzen et al. 2004')
                end
            end
            if toshow==2% locally computed
                if ~isempty(P.regression_computed)
                    loglog(Fvec, Hvec_computed,'k','linewidth',1);
                    hold(h_ax, 'on')   
                    legend('Computed')
                else
                    plot(0,0); hold(h_ax, 'on')
                    plot(0,0);
                    legend('Local regression not available.','See message on the Matlab''s command window.')
                    clc
                    fprintf('\n')
                    fprintf('** MESSAGE:\n')
                    fprintf('** In order to compute a local regression the depth of bedrock.\n')
                    fprintf('** must be known at a sufficient number of locations.\n')
                    fprintf('** In order for this function to run a minimum of 3 locations is required,\n')
                    fprintf('** however, a much higher number of locations is necessary for\n')
                    fprintf('** to lower the uncertainty on the regression.\n')
                    fprintf('** <<< Local regression could not be computed. >>>\n')
                    fprintf('\n')
                end
            end    
            if toshow==3% Ibs-von Seht and Wohlenberg 1999
                loglog(Fvec, Hvec_Ibs_von_Seht_1999,'k','linewidth',1);
                hold(h_ax, 'on')
                legend('Ibs-von Seht & Wohlemberg 1999')
            end
            if toshow==4% Parolai et al. (2002)	108.0	?1.551
                loglog(Fvec, Hvec_Parolai_2002,     'k','linewidth',1);
                hold(h_ax, 'on')
                legend('Parolai et al. 2002')
            end
            if toshow==5% Hinzen et al. (2004)	137.0	?1.190
                loglog(Fvec, Hvec_Hinzen_2004,      'k','linewidth',1);
                hold(h_ax, 'on')
                legend('Hinzen et al. 2004')
            end
            %%
            title('Regressions')
            xlabel('Frequency (Hz)','fontweight','bold')
            ylabel('Depth (m)','fontweight','bold')
            drawnow
        end
    end% Graphics_IBSeW_plot_regression
    function Graphics_IBSeW_plot_depths(newfigure)
        if ~isempty(SURVEYS)
            if(newfigure)
                h_fig = figure('name','no name specified');
                h_ax= gca;%
            else
                h_fig = H.gui;
                h_ax = hAx_IBS2;
            end
            set(h_fig,'CurrentAxes',h_ax);
            hold(h_ax,'off')
            cla(h_ax);
            lgnd = {};lgnd_id=0;
            %
            nx = P.TAB_IBSeW_Discretization(1);
            ny = P.TAB_IBSeW_Discretization(2);
            %
            %         
            Nhv = size(DTB__status,1);
            Xvec         = zeros(Nhv,1);
            Yvec         = zeros(Nhv,1);
            Measurements = zeros(Nhv,1);
            MaxDepths    = zeros(Nhv,1);
            Bedrock__computed    = zeros(Nhv,1);
            Bedrock__Ibs1999     = zeros(Nhv,1);
            Bedrock__Parolai2002 = zeros(Nhv,1);
            Bedrock__Hinzen2004  = zeros(Nhv,1);
            bedrock_ids = zeros(Nhv,1);
            dd=0;
            for pp = 1:Nhv
                if DTB__status(pp,1) ~= 2% all literature regressions
                    dd=dd+1;
                    bedrock_ids(dd)=pp; 
                end
                xx    = SURVEYS{pp,1}(1);
                yy    = SURVEYS{pp,1}(2);
                zt    = SURVEYS{pp,1}(3);% DEVELOPMENT
                Xvec(pp)    = xx;
                Yvec(pp)    = yy;
                Measurements(pp) = zt;
                %
                if ~isempty(P.regression_computed)
                    Bedrock__computed(pp)    = zt-DTB__well__bedrock_depth__COMPUTED{pp,1};
                end
                Bedrock__Ibs1999(pp)     = zt-DTB__well__bedrock_depth__IBS1999{pp,1};
                Bedrock__Parolai2002(pp) = zt-DTB__well__bedrock_depth__PAROLAI2002{pp,1};
                Bedrock__Hinzen2004(pp)  = zt-DTB__well__bedrock_depth__HINZEN2004{pp,1};
                MaxDepths(pp) = max( [Bedrock__computed(pp),Bedrock__Ibs1999(pp),Bedrock__Parolai2002(pp),Bedrock__Hinzen2004(pp)] );
            end
            bedrock_ids = bedrock_ids(1:dd);
            % account excluded
            if size(bedrock_ids,1)~=Nhv
                Xvec = Xvec(bedrock_ids);
                Yvec = Yvec(bedrock_ids);
                Bedrock__computed    = Bedrock__computed(bedrock_ids);
                Bedrock__Ibs1999     = Bedrock__Ibs1999(bedrock_ids);
                Bedrock__Parolai2002 = Bedrock__Parolai2002(bedrock_ids);
                Bedrock__Hinzen2004  = Bedrock__Hinzen2004(bedrock_ids);
                MaxDepths = MaxDepths(bedrock_ids);
            end
            %

            %% -====================================================================================
            %% PLOT TERRAIN SURFACE
            if Matlab_Release_num >=2014.2
                if strcmp(get(H.menu.view.IVSW_Surface,'checked'), 'on')
                    lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Surf.';
                    Nst = size(SURVEYS,1);
                    Points_on_surface = zeros(Nst,3);
                    for ii=1:Nst
                        Points_on_surface(ii,:) = SURVEYS{ii,1};
                    end
                    % use extra topography points if present
                    if ~isempty(TOPOGRAPHY)
                        Points_on_surface = [Points_on_surface;TOPOGRAPHY];
                    end
                    extra_locations = [];
                    topmost = 0;
                    facecolr = 'none';
                    edgecolr = 'k';
                    Pfiles__SparsePoints_to_Mesh_Surface(Points_on_surface,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                    hold(h_ax, 'on')
                end
            else
                sprintf('**** MESSAGE ****\nMatlab version < R2014B\n surface visualization not available.')
            end
            hold(h_ax, 'on')
            %% PLOT SELECTED BEDROCK  T6_PA_Bedrock
            if Matlab_Release_num >=2014.2
                bedrock_toshow = get(T6_PA_Bedrock,'value');
                if bedrock_toshow>1
                    extra_locations = [];
                    topmost = 0;
                    facecolr = 'interp';
                    edgecolr = 'none';
                    %
                    switch bedrock_toshow
                        case 2% locally computed
                            if ~isempty(P.regression_computed)
                                bedrock = [Xvec, Yvec, Bedrock__computed];
                                Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Custom Bedrock';
                            end
                        case 3% Ibs-von Seht and Wohlenberg 1999
                            bedrock = [Xvec, Yvec, Bedrock__Ibs1999];
                            Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                            lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Bedrock: IBS (1999)';
                        case 4% Parolai et al. (2002)	108.0	?1.551
                            bedrock = [Xvec, Yvec, Bedrock__Parolai2002];
                            Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                            lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Bedrock: Parolai (2002)';
                        case 5% Hinzen et al. (2004)	137.0	?1.190
                            bedrock = [Xvec, Yvec, Bedrock__Hinzen2004];
                            Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                            lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Bedrock: Hinzen (2004)';
                    end
                    if bedrock_toshow==6
                        if ~isempty(P.regression_computed)
                            bedrock = [Xvec, Yvec, Bedrock__computed];
                            Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                            lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Custom Bedrock';
                            hold(h_ax, 'on')
                        end
                        % Ibs-von Seht and Wohlenberg 1999
                        bedrock = [Xvec, Yvec, Bedrock__Ibs1999];
                        Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                        lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Bedrock: IBS (1999)';
                        hold(h_ax, 'on')
                        % Parolai et al. (2002)	108.0	?1.551
                        bedrock = [Xvec, Yvec, Bedrock__Parolai2002];
                        Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                        lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Bedrock: Parolai (2002)';
                        % Hinzen et al. (2004)	137.0	?1.190
                        bedrock = [Xvec, Yvec, Bedrock__Hinzen2004];
                        Pfiles__SparsePoints_to_Mesh_Surface(bedrock,extra_locations,topmost,nx,ny, facecolr, edgecolr);
                        lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Bedrock: Hinzen (2004)';
                        %daspect([1 1 10])
                    end
                    hold(h_ax, 'on')
                end
            else
                sprintf('**** MESSAGE ****\nMatlab version < R2014B\n surface visualization not available.')
            end
            hold(h_ax, 'on')   
            %% Plot regression results
            regression_toshow = get(T6_PA_Regression,'value');
            if regression_toshow==1% all regressions
                % plot3(Xvec, Yvec, Measurements,         'og','MarkerFaceColor','g','linewidth',1); hold(h_ax, 'on')
                % lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Stations';
                if ~isempty(P.regression_computed)
                    plot3(Xvec, Yvec, Bedrock__computed,    'or','MarkerFaceColor','r','linewidth',1);hold(h_ax, 'on')
                    lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Computed';
                end
                plot3(Xvec, Yvec, Bedrock__Ibs1999,     'ob','MarkerFaceColor','b','linewidth',1);hold(h_ax, 'on')
                plot3(Xvec, Yvec, Bedrock__Parolai2002, 'oc','MarkerFaceColor','c','linewidth',1);
                plot3(Xvec, Yvec, Bedrock__Hinzen2004,  'om','MarkerFaceColor','m','linewidth',1);
                %
                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Ibs-von Seht & Wohlemberg 1999';
                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Parolai et al. 2002';
                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Hinzen et al. 2004';
                legend(lgnd);
                for pp = 1:length(Xvec)
                    % if known
                    plot3(h_ax, [Xvec(pp),Xvec(pp)], [Yvec(pp),Yvec(pp)], [Measurements(pp),MaxDepths(pp)], 'k','linewidth',1);
                    hold(h_ax, 'on')
                    % if computed
                end
            end
            if regression_toshow==2 && ~isempty(P.regression_computed) % locally computed
                if ~isempty(P.regression_computed)
                    % plot3(Xvec, Yvec, Measurements, 'og','linewidth',1); hold(h_ax, 'on')
                    plot3(Xvec, Yvec, Bedrock__computed, 'or','MarkerFaceColor','r','linewidth',1);hold(h_ax, 'on')  
                    lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Computed';
                else
                    plot3(Xvec, Yvec, 0);hold(h_ax, 'on')
                    lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Locally computed bedrock not available.';
                end
                legend(lgnd);
            end    
            if regression_toshow==3% Ibs-von Seht and Wohlenberg 1999
   %             plot3(Xvec, Yvec, Measurements, 'og','linewidth',1); hold(h_ax, 'on')
                plot3(Xvec, Yvec, Bedrock__Ibs1999, 'ob','MarkerFaceColor','b','linewidth',1);hold(h_ax, 'on')
%                 legend('Stations','Ibs-von Seht & Wohlemberg 1999')
                % lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Stations';
                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Ibs-von Seht & Wohlemberg 1999';
                legend(lgnd);
            end
            if regression_toshow==4% Parolai et al. (2002)	108.0	?1.551
%                plot3(Xvec, Yvec, Measurements, 'og','linewidth',1); hold(h_ax, 'on')
                plot3(Xvec, Yvec, Bedrock__Parolai2002, 'oc','MarkerFaceColor','c','linewidth',1);hold(h_ax, 'on')
%                 legend('Stations','Parolai et al. 2002')
                % lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Stations';
                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Parolai et al. 2002';
                legend(lgnd);
            end
            if regression_toshow==5% Hinzen et al. (2004)	137.0	?1.190
%                plot3(Xvec, Yvec, Measurements, 'og','linewidth',1); hold(h_ax, 'on')
                plot3(Xvec, Yvec, Bedrock__Hinzen2004, 'om','MarkerFaceColor','m','linewidth',1);hold(h_ax, 'on')
%                 legend('Stations','Hinzen et al. 2004')
                % lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Stations';
                lgnd_id=lgnd_id+1; lgnd{lgnd_id,1}='Hinzen et al. 2004';
                legend(lgnd);
            end
            
            %% PLOT stations
            for pp = 1:Nhv
                if DTB__status(pp,1) ~= 2
                    plot3(h_ax,SURVEYS{pp,1}(1), SURVEYS{pp,1}(2), SURVEYS{pp,1}(3),'diamondg','MarkerFaceColor','g','linewidth',1); hold(h_ax, 'on')
                else
                    plot3(h_ax,SURVEYS{pp,1}(1), SURVEYS{pp,1}(2), SURVEYS{pp,1}(3),'diamondk','MarkerFaceColor','k','linewidth',1); hold(h_ax, 'on')
                end
            end
            %% more
            daspect(h_ax, P.data_aspectis_IVSeW)
            title('Bedrock depth')
            xlabel(h_ax,'X (E/W)','fontweight','bold')
            ylabel(h_ax,'Y (N/S)','fontweight','bold')
            zlabel(h_ax,'Depth (m)','fontweight','bold')
            view(3);            
        end
    end% Graphics_IBSeW_plot_depths 
    function Update_wells_info()
        Fstrid = num2str( P.isshown.id );
        starr = ['ID-',Fstrid,'   ~/',SURVEYS{P.isshown.id,2}];
        set(T6_PD_datafile_txt,'String',starr);
        %
        if ~isempty(WELLS) || ~strcmp(DTB__well__bedrock_depth_source{P.isshown.id,1},'n.a.')% there are wells enabled or manual depth
            if strcmp('n.a',DTB__well__bedrock_depth_source{P.isshown.id,1})
                %% no well present
                set(T6_PD_wellfile_txt,'String','NO WELL SELECTED FOR THIS DATA');
                set(T6_PA_BedrockDepth,'string','unknown')
                set(T6_PA_BedrockDepthSource,'string','none')
            else
                Wstrid = num2str( DTB__well__well_id(P.isshown.id,1));
                starr = ['ID-',Wstrid,'   ~/',DTB__well__well_name{P.isshown.id,1}];
                set(T6_PD_wellfile_txt,'String',starr);
                set(T6_PA_BedrockDepth,'string', num2str(DTB__well__bedrock_depth__KNOWN{P.isshown.id,1}))
                set(T6_PA_BedrockDepthSource,'string',DTB__well__bedrock_depth_source{P.isshown.id,1})
            end
        else
            set(T6_PD_wellfile_txt,'String','NO WELLS DEFINED');
            set(T6_PA_BedrockDepth,'string','n.a.')
            set(T6_PA_BedrockDepthSource,'string','none')
        end
    end    
%%    plot externally
    function plot_extern(~,~,idx)
        if isempty(SURVEYS); return; end
        switch(idx)
            case 1% MAIN: Survey Geometry
                Update_survey_locations();% no argument >> new figure
            case 2% MAIN: show profile
                Update_profile_locations()
            case 3% WINDOWING: Time data + windows
                Graphic_update_data(1);                
            case 4% COMPUTATIONS
                Graphic_update_spectrums(1)
            case 5% 2D VIEWS
                switch P.Flags.View_2D_current_mode%  Matlab: before 2014b
                    case P4_TA_buttongroup_option{1} 
                        Graphics_2dView_hvsr_main_frequence(1);
                    case P4_TA_buttongroup_option{2} 
                        Graphics_2dView_hvsr_main_amplitude(1);
                    case P4_TA_buttongroup_option{3} 
                        Graphics_2dView_hvsr_direction_at_main_peak(1);
                    case P4_TA_buttongroup_option{4} 
                        Graphics_2dView_slice_at_specific_frequence(1);   
                    case 'profile'
                        Graphics_plot_2d_profile(1);
                end
            case 6% 3D VIEWS
                switch P.Flags.View_3D_current_mode%  Matlab: before 2014b
                    case 3
                        % Z=-/F0 (with or without surface)
                        % Z=-/F0 +directional-H/V (with or without surface)
                        Graphics_3dView_quiver(1, P.Flags.View_3D_current_submode);
                end
            case 7% IBS - regression
                Graphics_IBSeW_plot_regression(1);
            case 8% IBS - subsurface
                Graphics_IBSeW_plot_depths(1);
            otherwise
                error('SAM: plot_extern: unespected option')
        end
    end
%% MATLAB MACHINE
    function create_new_tab(tabname)
        P.tab_id=P.tab_id+1;
        switch Matlab_Release
            case '2010a'
                H.TABS(P.tab_id)  = uitab('v0','Parent',hTabGroup, 'Title',tabname);
            case '2015b'
                H.TABS(P.tab_id)  = uitab('Parent',hTabGroup, 'Title',tabname);
            otherwise
                H.TABS(P.tab_id)  = uitab('Parent',hTabGroup, 'Title',tabname);
        end
    end
    function [height] = get_normalheight_on_panel(panel_handle,gui_height)
        %
        % translate normal height of with respect to full GUI
        % into a value valid for the specified panel
        %
        vecposition = get(panel_handle,'position');%,'linewidth',1);
        panel_points = G.main_h*vecposition(4);% panel height in points
        panel_over_main_ratio =  panel_points/G.main_h;%                  ratio referred to full interface
        height = gui_height/panel_over_main_ratio;%                   unitary height of objects in this pane
    end
    function spunta(handle_vector, property_value)
        % spunta for menus
        for ir = 1:length(handle_vector)
            if ir == property_value +1
                set(handle_vector(ir),'Checked','on');
            else
                set(handle_vector(ir),'Checked','off');
            end
        end
    end
    function CB_GUI_MENU_change_checked_status(hObject,~,~)%eventdata, handles)
        val = get(hObject,'Checked');
        if strcmp(val,'off')
            set(hObject,'Checked','on');
        end
        if strcmp(val,'on')
            set(hObject,'Checked','off');
        end
    end
    function [Vrange] = Get_Range_Callback(Vmi,Vma,titlestr)
        prompt = {'min','max'};
        def = {num2str(Vmi), num2str(Vma)};
        answer = inputdlg(prompt,titlestr,1,def);
        Vrange = [];
        if(~isempty(answer)) 
            A = str2double(answer{1});
            B = str2double(answer{2});
            if A<B
                Vrange=[A,B];
            end
        end
    end
    function [Range1,Range2] = Get_Range_X2_Callback(Ami,Ama,Fmi,Fma,titlestr,name1,name2)
        str1 = strcat(name1,' min');
        str2 = strcat(name1,' max');
        str3 = strcat(name2,' min');
        str4 = strcat(name2,' max');
        prompt = {str1,str2,  str3,str4};
        % Function specialized for Angle/Curve directional analisys
        % Tab: Computations
        % View: HVSR-directional: curves
        def = {num2str(Ami), num2str(Ama),num2str(Fmi), num2str(Fma)};
        answer = inputdlg(prompt,titlestr,1,def);
        Range1 = [];
        Range2 = [];
        if(~isempty(answer)) 
            A = str2double(answer{1});
            B = str2double(answer{2});
            if A<B
                Range1=[A,B];
            end
            %
            A2 = str2double(answer{3});
            B2 = str2double(answer{4});
            if A2<B2
                Range2=[A2,B2];
            end
        end
    end
    function is_busy()
        bgc = [1 0 0];
        set(ISBUSY1,'BackgroundColor', bgc, 'String', 'Working');
        set(ISBUSY2,'BackgroundColor', bgc, 'String', 'Working');
        set(ISBUSY3,'BackgroundColor', bgc, 'String', 'Working');
        set(ISBUSY4,'BackgroundColor', bgc, 'String', 'Working');
        set(ISBUSY5,'BackgroundColor', bgc, 'String', 'Working');
        set(ISBUSY6,'BackgroundColor', bgc, 'String', 'Working');
        drawnow
    end
    function is_drawing()
        bgc = [1 0.5 0.1];
        set(ISBUSY1,'BackgroundColor', bgc, 'String', 'Drawing');
        set(ISBUSY2,'BackgroundColor', bgc, 'String', 'Drawing');
        set(ISBUSY3,'BackgroundColor', bgc, 'String', 'Drawing');
        set(ISBUSY4,'BackgroundColor', bgc, 'String', 'Drawing');
        set(ISBUSY5,'BackgroundColor', bgc, 'String', 'Drawing');
        set(ISBUSY6,'BackgroundColor', bgc, 'String', 'Drawing');
        drawnow
    end
    function is_done()
        bgc = [0 0.8 0];
        set(ISBUSY1,'BackgroundColor', bgc, 'String', 'Ready');
        set(ISBUSY2,'BackgroundColor', bgc, 'String', 'Ready');
        set(ISBUSY3,'BackgroundColor', bgc, 'String', 'Ready');
        set(ISBUSY4,'BackgroundColor', bgc, 'String', 'Ready');
        set(ISBUSY5,'BackgroundColor', bgc, 'String', 'Ready');
        set(ISBUSY6,'BackgroundColor', bgc, 'String', 'Ready');
        drawnow
    end
%% DATA ELABORATION
%%    preliminars
    function check_for_data_uniformity()
        % enforces:
        % same sampling frequency
        % same length (next power of 2)
        %
        % maxtime=original maximum time (in data)
        %
        %NEWDAT = DDAT;
        Ndat = size( DDAT, 1);
        %FDAT = cell( size( DDAT,1), size( DDAT,2));
        %% check Fs
        same_fs = 1;
        if any( abs(sampling_frequences-sampling_frequences(1))>0 )% some files have a different sampling frequency
            same_fs = 0;
            fprintf('\n')
            fprintf('MESSAGE\n')
            fprintf('Data with different sampling frequences are mixed.\n')
            fprintf('MIN sampling frequence: %6.2f\n',min(sampling_frequences))
            fprintf('MAX sampling frequence: %6.2f\n',max(sampling_frequences))
        end
        %% Check length
        if same_fs ==1% check length only if all files have the same length
            L0 = size( DDAT{1,1}, 1); % n of samples of the V-component of survey 1
            for s = 2:Ndat% check the sampling frequence
                if size( DDAT{s,1}, 1)~=L0
                    fprintf('\n')
                    fprintf('MESSAGE\n')
                    fprintf('Data files has different number of SAMPLES.\n')
                    fprintf('MIN sampling frequence: %f\n',min(sampling_frequences))
                    fprintf('MAX sampling frequence: %f\n',max(sampling_frequences))
                    break;
                end
            end
        end
        %% message to the user
        if same_fs==0
            msg =[ ...
                'The project contains different sampling frequences.   '; ...
                'Data will be resampled and recording lengths uniformed'; ...
                ];
            msgbox(msg,'Warning')
        end
        
        %% CHANGING THE DATA:       
        %%   adjusting Fs
        if same_fs==0
            % interpolating to max Fs
            maxfs = max(sampling_frequences);
            mindt = 1/maxfs;
            for s = 1:Ndat
                if sampling_frequences(s)<maxfs
                    ns = size( DDAT{s,1}, 1);
                    dt = (1/sampling_frequences(s));
                    time = dt*( 0:(ns-1) ).';
                    tend =  time(end);
                    new_ns = fix( (tend+dt)/mindt );
                    new_time=mindt*( 0:(new_ns-1) ).';
                    for c=1:3
                        tdat = spline(time,DDAT{s,c},new_time);
                        DDAT{s,c} = tdat; 
                    end
                    sampling_frequences(s) = maxfs;
                end
            end
        end
        %             %% adjust length to next-power of 2
        %             lengths = zeros(1,Ndat);
        %             for s = 1:Ndat;  lengths(s) = size( TDAT{s,1}, 1); end
        %             maxL = max(lengths);
        %             newL = 2^nextpow2(maxL);
        %             T2DAT = cell(Ndat,3);
        %             for s = 1:Ndat
        %                 for c=1:3
        %                     T2DAT{s,c} = zeros(newL,1);
        %                     T2DAT{s,c}(1:lengths(s)) = TDAT{s,c};
        %                 end
        %             end
        %             %
        %             NEWDAT = T2DAT;
    end
%%    SINGLE DATA
    function compute_single_windowing(dat_id) % always using displayed parameters
        if dat_id==0; return; end
        if DTB__status(dat_id,1) == 1% if status == 0 data will not be changed
            % when new windowing is performed all elaboration info are
            % discarded
            %% discard previous elaboration if present
            %%   DTB__section.
            DTB__section__Min_Freq(dat_id,1) = 0.2;% filled runtime
            DTB__section__Max_Freq(dat_id,1) = 100;% filled runtime
            DTB__section__Frequency_Vector{dat_id,1} = [];% filled runtime
            %
            DTB__section__V_windows{dat_id,1} = [];% filled runtime
            DTB__section__E_windows{dat_id,1} = [];% filled runtime
            DTB__section__N_windows{dat_id,1} = [];% filled runtime
            %
            DTB__section__Average_V{dat_id,1} = [];% filled runtime
            DTB__section__Average_E{dat_id,1} = [];% filled runtime
            DTB__section__Average_N{dat_id,1} = [];% filled runtime                    << compute_single_hv(dat_id)
            %
            DTB__section__HV_windows{dat_id,1} = [];% filled runtime
            DTB__section__EV_windows{dat_id,1} = [];% filled runtime
            DTB__section__NV_windows{dat_id,1} = [];% filled runtime
            %%   DTB__hvsr.
            DTB__hvsr__curve_full{dat_id,1} = [];
            %T_hvsr.error_full = [];
            DTB__hvsr__confidence95_full{dat_id,1} = [];
            DTB__hvsr__curve_EV_full{dat_id,1} = [];
            DTB__hvsr__curve_NV_full{dat_id,1} = [];
            %
            DTB__hvsr__EV_all_windows{dat_id,1} = [];
            DTB__hvsr__NV_all_windows{dat_id,1} = [];
            DTB__hvsr__HV_all_windows{dat_id,1} = [];
            %
            DTB__hvsr__curve{dat_id,1} = [];
            %DTB{dat_id,1}.hvsr.error = [];
            DTB__hvsr__confidence95{dat_id,1} = [];
            DTB__hvsr__standard_deviation{dat_id,1} = [];
            DTB__hvsr__curve_EV{dat_id,1} = [];
            DTB__hvsr__curve_NV{dat_id,1} = [];
            %
            DTB__hvsr__peaks_idx{dat_id,1} = [];   %index of local maxima
            DTB__hvsr__hollows_idx{dat_id,1} = [];   %index of local minima
            %DTB{dat_id,1}.hvsr.main_peak_id = [];  %index of main peak (in the selected freq. range)
            % hvsr peaks (authomatic/user)
            DTB__hvsr__user_main_peak_frequence(dat_id,1) = NaN;
            DTB__hvsr__user_main_peak_amplitude(dat_id,1) = NaN;
            DTB__hvsr__user_main_peak_id_full_curve(dat_id,1) = NaN;
            DTB__hvsr__user_main_peak_id_in_section(dat_id,1) = NaN;

            DTB__hvsr__auto_main_peak_frequence(dat_id,1) = NaN;
            DTB__hvsr__auto_main_peak_amplitude(dat_id,1) = NaN;
            DTB__hvsr__auto_main_peak_id_full_curve(dat_id,1)= NaN;
            DTB__hvsr__auto_main_peak_id_in_section(dat_id,1) = NaN;
            %%   DTB__hvsr180.
            DTB__hvsr180__angle_id(dat_id,1) = 1;% 1 = option-1 in uicontrol: off
            DTB__hvsr180__angles{dat_id,1} = [];
            DTB__hvsr180__angle_step(dat_id,1) = 0;
            DTB__hvsr180__spectralratio{dat_id,1} = [];
            DTB__hvsr180__preferred_direction{dat_id,1} = [];
            %
            %
            %% Make new fenestration
            
            fs = sampling_frequences(dat_id);
            %% prepare filtered version of data and decide use   
            idfilter = get(T2_PA_filter,'Value');% [1]off, [2]bandpass
            DTB__elab_parameters__filter_id(dat_id,1) = idfilter;
            %% decide which data to use 
            switch get(T2_PA_dattoUSE,'Value')% [1]STA/LTA [2]spectral ratios
                case 2% use filtered data in H/V
                    DTB__elab_parameters__data_to_use(dat_id,1) = 2;% filtered
                otherwise
                    %[1] no filter in use OR use filtered data only STA/LTA windows selection
                    DTB__elab_parameters__data_to_use(dat_id,1) = 1;% original
            end
            %
            Hdd = [];
            switch idfilter
                case 1% OFF
                    DTB__elab_parameters__filter_name{dat_id,1}  = 'none';
                    DTB__elab_parameters__filter_order(dat_id,1) = NaN;%
                    DTB__elab_parameters__filterFc1(dat_id,1)    = NaN;
                    DTB__elab_parameters__filterFc2(dat_id,1)    = NaN;
                    % DTB{dat_id,1}.elab_parameters.use_of_filtered_data = NaN;%  DELETE?
                    for cc = 1:3
                        FDAT{dat_id, cc} = [];% Filtered data
                    end
                    %
                    % enable GUI controls 
                    set(T2_PA_dattoshow,'Value',1)
                    set(T2_PA_dattoshow,'Enable','off')
                    %
                case 2% BANDPASS
                    NOrdr = default_values.Bandpss_Order;
                    Fc1   = str2double(get(T2_PA_filter_fmin,'String'));
                    Fc2   = str2double(get(T2_PA_filter_fmax,'String'));
                    %
                    DTB__elab_parameters__filter_name{dat_id,1} = 'Bandpass Butterworth IIR: spec=[N,Fc1,Fc2]';
                    DTB__elab_parameters__filter_order(dat_id,1) = NOrdr;%
                    DTB__elab_parameters__filterFc1(dat_id,1) = Fc1;
                    DTB__elab_parameters__filterFc2(dat_id,1) = Fc2;
                    dd = fdesign.bandpass('N,Fc1,Fc2',NOrdr, Fc1,Fc2, fs);
                    %designmethods(dd,'SystemObject',true)
                    Hdd = design(dd,'butter');
                    for cc = 1:3
                        FDAT{dat_id, cc} = filter(Hdd, DDAT{dat_id, cc});% Filtered data
                    end
                    %
                    % enable GUI controls 
                    set(T2_PA_dattoshow,'Enable','on')
                    set(T2_PA_dattoshow,'Value',2)
                case 3% LOWPASS
                    NOrdr = default_values.Lowpss_Order;
                    Fc2   = str2double(get(T2_PA_filter_fmax,'String'));
                    
                    DTB__elab_parameters__filter_name{dat_id,1} = 'Lowpass Butterworth IIR: spec=[N,Fc]';
                    DTB__elab_parameters__filter_order(dat_id,1) = NOrdr;%
                    DTB__elab_parameters__filterFc1(dat_id,1) = NaN;
                    DTB__elab_parameters__filterFc2(dat_id,1) = Fc2; 
                    dd = fdesign.lowpass('N,Fc',NOrdr,Fc2,fs);
                    %designmethods(dd,'SystemObject',true)
                    Hdd = design(dd,'butter');
                    for cc = 1:3
                        FDAT{dat_id, cc} = filter(Hdd, DDAT{dat_id, cc});% Filtered data
                    end
                    %
                    % enable GUI controls 
                    set(T2_PA_dattoshow,'Enable','on')
                    set(T2_PA_dattoshow,'Value',2)
                case 4% HIGHPASS
                    NOrdr = default_values.Highpss_Order;
                    Fc2   = str2double(get(T2_PA_filter_fmax,'String'));
                    
                    DTB__elab_parameters__filter_name{dat_id,1} = 'Highpass Butterworth IIR: spec=[N,F3dB]';
                    DTB__elab_parameters__filter_order(dat_id,1) = NOrdr;%
                    DTB__elab_parameters__filterFc1(dat_id,1) = NaN;
                    DTB__elab_parameters__filterFc2(dat_id,1) = Fc2; 
                    dd = fdesign.highpass('N,F3dB',NOrdr,Fc2,fs);
                    %designmethods(dd,'SystemObject',true)
                    Hdd = design(dd,'butter');
                    for cc = 1:3
                        FDAT{dat_id, cc} = filter(Hdd, DDAT{dat_id, cc});% Filtered data
                    end
                    %
                    % enable GUI controls 
                    set(T2_PA_dattoshow,'Enable','on')
                    set(T2_PA_dattoshow,'Value',2)            
            end
            DTB__elab_parameters__THEfilter{dat_id,1} = Hdd;% save filter for book-keeping
            %
            % Compute windows
            window_width = str2double(get(T3_P1_winsize,'String'));
            window_overlap_pc = str2double(get(T3_P1_winoverlap,'String'));
            sta_lta_ratio = str2double(get(T3_P1_wintstaltaratio,'String'));
            %
            ns = size(DDAT{dat_id, 1},1);
            ns_window = fix(window_width * fs);
            ns_overlap   = fix(0.01*ns_window*window_overlap_pc);
            %
            STAs = str2double(get(T3_P1_winsSTA,'String'));
            ns_sta = fix(STAs * fs);
            %
            LTAs = str2double(get(T3_P1_winsLTA,'String'));
            ns_lta = fix(LTAs * fs);
            if ns_lta > fix(ns/2)
                ns_lta = fix(ns/2)-1;
                set(T3_P1_winsLTA,'String', ceil(ns_lta*(1/fs)) );
                warning('LTA window connot be greater than half of the recording length')
            end
            %
            %%
            vec = ( 1:(ns_window-ns_overlap):ns-1 )';
            winids = [vec, (vec+ns_window-1)];
            for w=1:size(winids,1)
                if(winids(w,2)>ns)
                    winids=winids(1:(w-1), :);
                    break
                end
            end
            winok  = zeros(size(winids,1),1)+1;
            Nwindows    = size(winok,1);
%             fprintf('Data width                       [%d]\n',ns)
%             fprintf('Window width                    [%d]\n',ns_window )
%             fprintf('N of Windows                    [%d]\n',Nwindows )
%             fprintf('Overlap (%f) p.c.                   [%d]\n',window_overlap_pc,ns_overlap)
%             fprintf('Sta / Lta ratio                 [%d]\n',sta_lta_ratio )
%           
            for w=1:Nwindows% check sta/lta
                a  = winids(w,1);
                b  = winids(w,2);
                %
                if ns_sta<ns_lta
                    la = b-ns_lta;
                    lb = b;
                    if la<1
                        la = a;
                        lb = a+ns_lta;    
                    end
                    if la<1
                    end
                    if lb>ns
                        lb=ns;
                    end
                    lta_V = mean( abs(DDAT{dat_id, 1}(la:lb)) ); 
                    lta_E = mean( abs(DDAT{dat_id, 2}(la:lb)) );
                    lta_N = mean( abs(DDAT{dat_id, 3}(la:lb)) );
                    %
                    iid = a:ns_sta:b;
                    nn=length(iid);
                    ida = iid(1:(nn-1));
                    idb = iid(2:nn);
                    sta_V = 0;
                    sta_E = 0;
                    sta_N = 0;
                    for jj = 1:(length(iid)-1)
                        tstupV = mean( abs(DDAT{dat_id, 1}(ida(jj):idb(jj)) ) );
                        tstupE = mean( abs(DDAT{dat_id, 2}(ida(jj):idb(jj)) ) );
                        tstupN = mean( abs(DDAT{dat_id, 3}(ida(jj):idb(jj)) ) );
                        if tstupV>sta_V; sta_V=tstupV; end
                        if tstupE>sta_E; sta_E=tstupE; end
                        if tstupN>sta_N; sta_N=tstupN; end
                    end
                    %
                    sla_vs_lta_ratio = max( [ (sta_V/lta_V) , (sta_E/lta_E) , (sta_N/lta_N) ] );
                    if sla_vs_lta_ratio > sta_lta_ratio
%                         fprintf('Window [%d] discarded\n',w)
                        winok(w,1) = 0;
%                     else
%                         fprintf('Window [%d] STA/LTA  %2.3f\n',w, sla_vs_lta_ratio)
                    end
                else
                    warning('OpenHVSR:: STA window cannot be greater than LTA. STA/LTA Fltering not performed')
                end
            end
            %            
            DTB__windows__width_sec(dat_id,1) = window_width; 
            DTB__windows__number(dat_id,1) = Nwindows;
            DTB__windows__indexes{dat_id,1} = winids;
            DTB__windows__is_ok{dat_id,1} = winok;
            DTB__windows__info(dat_id,1:6) = [ns, ns_window, ns_overlap, 0, 0, 0];
            
            DTB__elab_parameters__windows_width(dat_id,1) = window_width;
            DTB__elab_parameters__windows_overlap(dat_id,1) = window_overlap_pc;
            DTB__elab_parameters__windows_sta_vs_lta(dat_id,1) = sta_lta_ratio;
            
            %>> warning('TO DO: update display info on main: here')
            if strcmp(P.ExtraFeatures.debug_mode,'on')
                fprintf('compute_single_windowing(%d)\n',dat_id)
                fprintf('....sets:\n')
                fprintf('........DTB__windows__number(%d,1)\n',dat_id)
                fprintf('........DTB__windows__indexes{%d,1}\n',dat_id)
                fprintf('........DTB__windows__is_ok{%d,1}\n',dat_id)
                fprintf('........DTB__windows__info(%d,:) = [ns, ns_window, ns_overlap, 0, 0, 0]\n',dat_id)
                fprintf('........DTB__elab_parameters__windows_width(%d,1)\n',dat_id)
                fprintf('........DTB__elab_parameters__windows_overlap(%d,1)\n',dat_id)
                fprintf('........DTB__elab_parameters__windows_sta_vs_lta(%d,1)\n',dat_id)
            end
            %% Set progress flag
            DTB__elaboration_progress(dat_id,1) = 1;% windowing only performed
            %
            pad0 = 2^nextpow2(ns_window);
            set(T2_PD_win_samplespow2, 'String',num2str(pad0))
            %
        else
            fprintf('DATA %d IS LOCKED\n',dat_id)
        end
    end
    function [status] = database_single_computation(dat_id)
        %
        if dat_id==0; status=0; return; end
        % status = 1:   Ok
        % status = 0:   unsuccessful
        clc
        status = 1;
        if DTB__status(dat_id,1) ~= 1
            message = strcat('File [',num2str(dat_id),'] is either "Locked" or "Excluded" (See Tab-1 "Main")'); 
            msgbox(message,'MESSAGE');
            status = 0;
            return;
        else
            [perform_fft, perform_hvsr,perform_hvsr180, skip_this] = check_operations_to_perform(dat_id);
        end
        if skip_this==1% abort if windowing was not performed 
            fprintf('MESSAGE: Windowing was not peformed on file [%d],%s\n',dat_id,SURVEYS{dat_id,2})
            return; 
        end
        
        Ndata = size(SURVEYS,1);
        nok = sum(DTB__windows__is_ok{dat_id,1}); 
        if nok<5
            message = strcat('File [',num2str(dat_id),'] Not enough windows (less than 5): This data will be EXCLUDED'); 
            msgbox(message,'Warning');
            DTB__status(dat_id,1) = 2;
            status = 0;
        end
        if DTB__status(dat_id,1) == 1 && nok>=5
            %fprintf('>>> database_single_computation(data[%d])\n',dat_id)
            if perform_fft || perform_hvsr || perform_hvsr180
                fprintf('COMPUTING DATABASE for [%d] of [%d] %s\n',dat_id,Ndata,SURVEYS{dat_id,2})
                %
                %% operation 1: FFT
                if perform_fft
                    fprintf('...REDOING FFT\n')
                    compute_single_fft(dat_id);
                end
                %% operation 2: HVSR
                if perform_hvsr
                    fprintf('...REDOING HV\n')
                    compute_single_hv(dat_id);
                end
                %% operation 3: HVSR-180
                if perform_hvsr180
                    fprintf('...REDOING HV-Directional\n')
                    compute_single_hv180(dat_id);
                else
                fprintf('...SET off: HV-Directional\n')
                end
                fprintf('...DONE\n')
                fprintf('\n')
                %%
                %% update status
                P.isshown.accepted_windows = DTB__windows__is_ok{P.isshown.id,1};
            else
                fprintf('NOTHING to do for [%d] of [%d] %s\n',dat_id,Ndata,SURVEYS{dat_id,2})
                fprintf('\n')
            end
        end
    end
    function [perform_fft, perform_hvsr, perform_hvsr180, skip_this] = check_operations_to_perform(dat_id)
        fprintf('...CHECK OPERATIONS TO BE PERFORMED\n')
        perform_fft = 0;
        perform_hvsr = 0;
        perform_hvsr180 = 0;
        skip_this = 0;
        if DTB__elaboration_progress(dat_id,1) == 0 % windowing was not performed
            skip_this = 1;
            return;
        end
        %
        %% operation 1: FFT
        %% operation 2: HVSR
        %% operation 3: HVSR-180
        %% ----------------------------------------------------------------
        % related to operation 2: FFT
        ref_window_tapering = str2double(get(T3_P1_wintapering,'string'));
        % related to operation 3: hvsr
        ref_fmin = str2double( get(hT3_PA_edit_fmin,'string'));
        ref_fmax = str2double( get(hT3_PA_edit_fmax,'string'));
        %
        ref_df=DTB__windows__info(dat_id,4);
        if ref_df >0
            ref_nf=DTB__windows__info(dat_id,5);
            ref_ifmin = fix(ref_fmin/ref_df);
            if ref_ifmin==0; ref_ifmin=1; end
            ref_ifmax = fix(ref_fmax/ref_df);
            if ref_ifmax>ref_nf; ref_ifmax=ref_nf; end
        else
            ref_ifmin=0;
            ref_ifmax=0;
        end
        ref_smoothing_strategy = get(T3_PA_wsmooth_strategy,'Value');
        ref_smoothing_Slider = get(T3_PD_smooth_slider,'Value');
        %
        angle_id = get(T3_P1_angular_samp,'Value');
        if angle_id==1% is off, clean up
            perform_hvsr180 = 0;
            DTB__hvsr180__angle_id(P.isshown.id,1) = angle_id;
            DTB__hvsr180__angles{dat_id,1} = [];
            DTB__hvsr180__angle_step(dat_id,1) = 0;
            DTB__hvsr180__spectralratio{dat_id,1} = [];
            DTB__hvsr180__preferred_direction{dat_id,1} = [];
        end
        %
        %% check FFT
        if( DTB__windows__info(dat_id,4) == 0 )% never computed before
            perform_fft = 1;
        end
        if( DTB__windows__info(dat_id,5) == 0 )% never computed before
            perform_fft = 1;
        end
        if( isempty(DTB__windows__fftv{dat_id}) )% never computed before
            perform_fft = 1;
            %fprintf('check 2-04/7: fft is empty\n')
        end
        if( isempty(DTB__windows__ffte{dat_id}) )% never computed before
            perform_fft = 1;
            %fprintf('check 2-05/7: fft is empty\n')
        end
        if( isempty(DTB__windows__fftn{dat_id}) )% never computed before
            perform_fft = 1;
            %fprintf('check 2-06/7: fft is empty\n')
        end
        %
        % tapering
        if(ref_window_tapering ~= DTB__elab_parameters__windows_tapering(dat_id,1) )% was changed
            perform_fft = 1;
            %fprintf('check 2-07/7: tapering has changed\n')
        end
        % padding
        if isempty(DTB__windows__info)
            perform_fft = 1;
        end
        if DTB__windows__info(dat_id,6) == 0% [ns, ns_window, ns_overlap, 0, 0, ns_pad];
            perform_fft = 1;
        end
        %
        pad_to = get(T3_P1_wpadto     ,'string');
        pad_length_now = DTB__windows__info(dat_id,6);
        pad0 = 2^nextpow2(DTB__windows__info(dat_id,2));
        if ~strcmp(pad_to,'off')
            pad_length_in  = str2double(pad_to);
            %
            if (pad_length_in>=pad0)
                if pad_length_in~=pad_length_now
                    perform_fft = 1;
                end
            end
        else
            if pad_length_now~=pad0
                perform_fft = 1;
            end
        end
        if perform_fft
            perform_hvsr = 1;
            if angle_id==1 
                perform_hvsr180 = 0; 
            else
                perform_hvsr180 = 1;
            end
            return;
        end
        %
        %% check HVSR
        strategy_id = get(T2_PA_HV,'Value');
        if( strategy_id ~= DTB__elab_parameters__hvsr_strategy(P.isshown.id,1))
            perform_hvsr = 1;
            %fprintf('check ????: Spectral ratio strategy changed \n')
        end
        if( size(P.isshown.accepted_windows,1) ~= size(DTB__windows__is_ok{P.isshown.id,1},1))
            perform_hvsr = 1;
            %fprintf('check 3-01/9 A: fft: windowing changed \n')
        end
        if( size(P.isshown.accepted_windows,1) == size(DTB__windows__is_ok{P.isshown.id,1},1))% Acceptable windows changed.
            if( sum( P.isshown.accepted_windows-DTB__windows__is_ok{P.isshown.id,1}) ~= 0 )
                % N of windows changed: requires only HVSR computation 
                perform_hvsr = 1;
                %fprintf('check 3-01/9 B: fft: windowing changed \n')
            end
        end
        if isempty(DTB__section__Frequency_Vector{dat_id,1})% never computed before
            %fprintf('check 3-02/9: Fvec  absent\n')
            perform_hvsr = 1;
        end
        if DTB__section__Min_Freq(dat_id,1) ~= ref_fmin% was changed
            %fprintf('check 3-03/9: Fmin changed\n')
            perform_hvsr = 1;
        end
        if DTB__section__Max_Freq(dat_id,1) ~= ref_fmax% was changed
            %fprintf('check 3-05/9: Fmax changed\n')
            perform_hvsr = 1;
        end
        if ~isempty(DTB__section__Frequency_Vector{dat_id,1})
            if DTB__section__Frequency_Vector{dat_id,1}(1) ~= ref_ifmin% was changed
                %fprintf('check 3-04/9: i-Fmin changed\n')
                perform_hvsr = 1;
            end
            if DTB__section__Frequency_Vector{dat_id,1}(2) ~= ref_ifmax% was changed
                % fprintf('check 3-06/9: i-Fmax changed\n')
                perform_hvsr = 1;
            end
        else
            perform_hvsr = 1;
        end
        if(ref_smoothing_strategy ~= DTB__elab_parameters__smoothing_strategy(dat_id,1) )% was changed
            % fprintf('check 3-07/9: smoothing strategy changed\n')
            perform_hvsr = 1;
        end
        if(ref_smoothing_Slider ~= DTB__elab_parameters__smoothing_slider_val(dat_id,1))% was changed
            % fprintf('check 3-08/9: smoothing slider changed\n')
            perform_hvsr = 1;
        end
        %
        if perform_hvsr
            if angle_id>1
                perform_hvsr180 = 1;
                return;
            end
        end
        %
        %% check HVSR 180
        if angle_id>1 && angle_id ~= DTB__hvsr180__angle_id(dat_id,1)
            % fprintf('check 4-02/2: angular sampling changed\n')
            perform_hvsr180 =1;
        end
    end% function
    function compute_single_fft(dat_id)
        if DTB__status(dat_id,1) == 1% if status == 0 data will not be changed
            % ffts are defined on the full frequence scale 
            tapervalue = str2double(get(T3_P1_wintapering,'string'));
            
            %
            n_of_windows = DTB__windows__number(dat_id,1);
            DTB__windows__number_fft(dat_id,1) = n_of_windows;
            ns_window = DTB__windows__info(dat_id,2);
            fs = sampling_frequences(dat_id);%         sampling frequence
            %
            % padding
            pad_to = get(T3_P1_wpadto     ,'string');
            pad0 = 2^nextpow2(ns_window);
            if strcmp(pad_to,'off')
                npad = pad0;
            else
                npad= 2^nextpow2( str2double(pad_to) );
                if npad<pad0
                    npad = pad0;
                end
            end
            DTB__windows__info(dat_id,6) = npad;% [ns, ns_window, ns_overlap, 0, 0, ns_pad];
            %
            df = 0;
            WIDX = DTB__windows__indexes{dat_id,1};
            switch DTB__elab_parameters__data_to_use(dat_id,1)
                case 2% filtered data
                    VEN = [FDAT{dat_id, 1},FDAT{dat_id, 2},FDAT{dat_id, 3}];
                otherwise% original data
                    VEN = [DDAT{dat_id, 1},DDAT{dat_id, 2},DDAT{dat_id, 3}];
            end
            for cc = 1:3% VEN
                wdat = zeros(ns_window, n_of_windows);% windows are in columns
                %% create windows (and remove avearge)
                for w = 1:n_of_windows
                    ia = WIDX(w,1);
                    ib = WIDX(w,2);
                    Ccoponent = mean(VEN(ia:ib, cc));% remove average from each window
                    wdat(1:ns_window, w) =  VEN(ia:ib,cc) - Ccoponent;
                end% w
                %% tapering
                cosine_taper(wdat, tapervalue );    
                %% STORE Windows (only used for HV-180, stored only if necessary)
                if cc==1; DTB__windows__winv{dat_id,1} = wdat; end
                if cc==2; DTB__windows__wine{dat_id,1} = wdat; end
                if cc==3; DTB__windows__winn{dat_id,1} = wdat; end
                %% FFT
                
                [FT, df] = samfft(wdat, fs, npad);
                if cc==1; DTB__windows__fftv{dat_id,1} = 2*abs(FT); end
                if cc==2; DTB__windows__ffte{dat_id,1} = 2*abs(FT); end
                if cc==3; DTB__windows__fftn{dat_id,1} = 2*abs(FT); end
            end% cc

            DTB__windows__info(dat_id,4) = df;
            DTB__windows__info(dat_id,5) = size(FT,1);
            DTB__elab_parameters__windows_tapering(dat_id,1) = tapervalue;
            if strcmp(P.ExtraFeatures.debug_mode,'on')
                fprintf('....sets:\n')
                fprintf('........DTB__windows__number_fft(%d,1)\n',dat_id)
                fprintf('........DTB__windows__fftv{%d,1}\n',dat_id)
                fprintf('........DTB__windows__ffte{%d,1}\n',dat_id)
                fprintf('........DTB__windows__fftn{%d,1}\n',dat_id)
                %
                fprintf('........DTB__windows__info(%d,4) = df\n',dat_id)
                fprintf('........DTB__windows__info(%d,5) = size(FT,1);\n',dat_id)
            end
            %
        else
            fprintf('DATA %d IS LOCKED\n',dat_id)
        end
    end
    function compute_single_hv(dat_id)
        if DTB__status(dat_id,1) == 1% if status == 0 data will not be changed
            fmin = str2double( get(hT3_PA_edit_fmin,'string'));
            fmax = str2double( get(hT3_PA_edit_fmax,'string'));

            nf = DTB__windows__info(dat_id,5);%= [ns, ns_window, ns_overlap, 0, 0, ns_pad];
            df = DTB__windows__info(dat_id,4);
            ifmin = fix(fmin/df);
            if ifmin==0; ifmin=1; end
            ifmax = fix(fmax/df);
            if ifmax>nf; ifmax=nf; end
            %
            Smoothing_strategy = get(T3_PA_wsmooth_strategy,'Value');
            Smoothing_Slider   = get(T3_PD_smooth_slider,'Value');
            specratio_strategy = get(T2_PA_HV,'Value');
            %
            %% section of data (not necessary after 17-11-08)
            V = DTB__windows__fftv{dat_id,1}(ifmin:ifmax,:);
            E = DTB__windows__ffte{dat_id,1}(ifmin:ifmax,:);
            N = DTB__windows__fftn{dat_id,1}(ifmin:ifmax,:);
            %
            %% update DTB -I
            DTB__section__Min_Freq(dat_id,1) = fmin;
            DTB__section__Max_Freq(dat_id,1) = fmax;
            %
            %
            Fvect = df*((ifmin:ifmax)-1);
            %>> warning('SAM: check if fmax is the full frequency vector maximum')
            DTB__section__Frequency_Vector{dat_id,1} = [ifmin, ifmax, df];
            %% H/V of Windows (OPTION-A, smooth final curves. [Is the less efficient approach] )
            %         fprintf('OPTION-A\n')
            %         EV = E./V;
            %         NV = N./V;
            %         switch specratio_strategy
            %             case 1%; %fprintf('approach 1\n');
            %                 HV = sqrt(E.^2 +N.^2)./V;
            %             case 2%; %fprintf('(E+N)/2 1\n');
            %                 HV = 0.5*(E+N)./V;
            %         end
            %         [HV] =  smoothing(HV);
            %         [EV] =  smoothing(EV);
            %         [NV] =  smoothing(NV);
            %% H/V of Windows (OPTION-B, smooth components then compute curves)
            % fprintf('OPTION-B\n')
            [E] =  smoothing(E,Fvect);
            [N] =  smoothing(N,Fvect);
            [V] =  smoothing(V,Fvect);
            %
            switch specratio_strategy
                case 1%; %fprintf('approach 1\n');
                    Have = 0.707106781186547*sqrt(E.^2 +N.^2);% 1/sqrt(2)
                case 2%; %fprintf('(E+N)/2 1\n');
                    Have = 0.5*(E+N);
                case 3%; %fprintf('approach 1\n');
                    Have = sqrt(E.^2 +N.^2);
            end
            %
            EV = E./V;
            NV = N./V;
            HV = Have./V;
            %
            %
            DTB__hvsr__EV_all_windows{dat_id,1} = EV;
            DTB__hvsr__NV_all_windows{dat_id,1} = NV;
            DTB__hvsr__HV_all_windows{dat_id,1} = HV;
            %
            %% update DTB-II
            DTB__section__V_windows{dat_id,1} = V;
            DTB__section__E_windows{dat_id,1} = E;
            DTB__section__N_windows{dat_id,1} = N;

            DTB__section__HV_windows{dat_id,1} = HV;
            DTB__section__EV_windows{dat_id,1} = EV;
            DTB__section__NV_windows{dat_id,1} = NV;
            %
            DTB__elab_parameters__smoothing_strategy(dat_id,1) = Smoothing_strategy;
            DTB__elab_parameters__smoothing_slider_val(dat_id,1) = Smoothing_Slider;
            DTB__elab_parameters__hvsr_strategy(dat_id,1) = specratio_strategy;
            if strcmp(P.ExtraFeatures.debug_mode,'on')
                fprintf('....sets:\n')
                fprintf('........DTB__section__Min_Freq(%d,1) = fmin\n',dat_id)
                fprintf('........DTB__section__Max_Freq(%d,1) = fmax\n',dat_id)
                %
                fprintf('........DTB__section__Frequency_Vector{%d,1} = [ifmin, ifmax, df];\n',dat_id)
                fprintf('........DTB__section__V_windows{%d,1} = V;\n',dat_id)
                fprintf('........DTB__section__E_windows{%d,1} = E;\n',dat_id)
                fprintf('........DTB__section__N_windows{%d,1} = N;\n',dat_id)

                fprintf('........DTB__section__HV_windows{%d,1} = HV;\n',dat_id)
                fprintf('........DTB__section__EV_windows{%d,1} = EV;\n',dat_id)
                fprintf('........DTB__section__NV_windows{%d,1} = NV;\n',dat_id)
                %
                fprintf('........DTB__elab_parameters__smoothing_strategy(%d,1) = Smoothing_strategy;\n',dat_id)
                fprintf('........DTB__elab_parameters__smoothing_slider_val(%d,1) = Smoothing_Slider;\n',dat_id)
                fprintf('........DTB__elab_parameters__hvsr_strategy(%d,1) = specratio_strategy;\n',dat_id)
            end
            %% compute average H/V (full)
            nw = DTB__windows__number(dat_id,1);% [ns, ns_window, ns_overlap, 0, 0, ns_pad];
            ave_HV_full = sum(DTB__section__HV_windows{dat_id,1},2)./nw;
            ave_EV_full = sum(DTB__section__EV_windows{dat_id,1},2)./nw;
            ave_NV_full = sum(DTB__section__NV_windows{dat_id,1},2)./nw;
            %
            %% compute average H/V (clean)
            OKS = DTB__windows__is_ok{dat_id,1};
            [rr,~] = find(OKS==1);
            nw_clean = sum(OKS);
            ave_HV = sum(DTB__section__HV_windows{dat_id,1}(:,rr), 2)./nw_clean;
            ave_EV = sum(DTB__section__EV_windows{dat_id,1}(:,rr), 2)./nw_clean;
            ave_NV = sum(DTB__section__NV_windows{dat_id,1}(:,rr), 2)./nw_clean;
            %
            ave_V = sum(DTB__section__V_windows{dat_id,1}(:,rr), 2)./nw_clean;
            ave_E = sum(DTB__section__E_windows{dat_id,1}(:,rr), 2)./nw_clean;
            ave_N = sum(DTB__section__N_windows{dat_id,1}(:,rr), 2)./nw_clean;
           
            %    
            %% store results
            DTB__hvsr__curve_full{dat_id,1}    = ave_HV_full;
            DTB__hvsr__curve_EV_full{dat_id,1} = ave_EV_full;
            DTB__hvsr__curve_NV_full{dat_id,1} = ave_NV_full;
            %
            DTB__hvsr__curve{dat_id,1} = ave_HV;
            DTB__hvsr__curve_EV{dat_id,1} = ave_EV;
            DTB__hvsr__curve_NV{dat_id,1} = ave_NV;
            %
            DTB__section__Average_V{dat_id,1} = ave_V;
            DTB__section__Average_E{dat_id,1} = ave_E;
            DTB__section__Average_N{dat_id,1} = ave_N;
            if strcmp(P.ExtraFeatures.debug_mode,'on')
                fprintf('........DTB__hvsr__curve_full{%d,1}\n',dat_id)
                fprintf('........DTB__hvsr__curve_EV_full{%d,1}\n',dat_id)
                fprintf('........DTB__hvsr__curve_NV_full{%d,1}\n',dat_id)
                fprintf('........DTB__hvsr__curve{%d,1}\n',dat_id)
                fprintf('........DTB__hvsr__curve_EV{%d,1}\n',dat_id)
                fprintf('........DTB__hvsr__curve_NV{%d,1}\n',dat_id)
                fprintf('........DTB__section__Average_V{%d,1}\n',dat_id)
                fprintf('........DTB__section__Average_E{%d,1}\n',dat_id)
                fprintf('........DTB__section__Average_N{%d,1}\n',dat_id)
            end
            
            
            
            %
            %% alternative code to compute "clean" average spectral ratios           
%             ave_HV= 0*DTB__hvsr__curve_full{dat_id,1};
%             ave_EV = ave_HV;
%             ave_NV = ave_HV;
%             ave_V  = ave_HV;
%             ave_E = ave_HV;
%             ave_N = ave_HV;
%             
%             for w = 1:nw
%                 if( OKS(w)==1 )
%                     ave_HV = ave_HV+DTB__section__HV_windows{dat_id,1}(:,w);
%                     ave_EV = ave_EV+DTB__section__EV_windows{dat_id,1}(:,w);
%                     ave_NV = ave_NV+DTB__section__NV_windows{dat_id,1}(:,w);
%                     %
%                     ave_V = ave_V + DTB__section__V_windows{dat_id,1}(:,w);
%                     ave_E = ave_E + DTB__section__E_windows{dat_id,1}(:,w);
%                     ave_N = ave_N + DTB__section__N_windows{dat_id,1}(:,w);
%                 end
%             end
% 
%             DTB__hvsr__curve{dat_id,1} = ave_HV./nw_clean;
%             DTB__hvsr__curve_EV{dat_id,1} = ave_EV./nw_clean;
%             DTB__hvsr__curve_NV{dat_id,1} = ave_NV./nw_clean;
%             %
%             DTB__section__Average_V{dat_id,1} = ave_V./nw_clean;
%             DTB__section__Average_E{dat_id,1} = ave_E./nw_clean;
%             DTB__section__Average_N{dat_id,1} = ave_N./nw_clean;
            %%            %            
            %% Standard deviation
            sum_diff_squared_full = zeros(size(ave_HV_full,1),1);%0*ave_HV_full;
            sum_diff_squared_clean  = zeros(size(ave_HV_full,1),1);%0*ave_HV_full;
            for w = 1:nw
                sum_diff_squared_full = sum_diff_squared_full+(DTB__section__HV_windows{dat_id,1}(:,w)-ave_HV_full).^2;
                if( OKS(w)==1 )
                    %ave_HV is the clean curve
                    sum_diff_squared_clean = sum_diff_squared_clean+(DTB__section__HV_windows{dat_id,1}(:,w)-ave_HV).^2;
                end
            end
            standard_deviat_full = sqrt(sum_diff_squared_full/(nw-1));
            %DTB{dat_id,1}.hvsr.error_full = standard_deviat_full./ave_HV_full;% relative error
            %
            standard_deviat_clean = sqrt(sum_diff_squared_clean/(nw_clean-1));
            %DTB{dat_id,1}.hvsr.error = standard_deviat_clean./ave_HV;% relative error
            DTB__hvsr__standard_deviation{dat_id,1} = standard_deviat_clean;
            %% Confidence (95%)
            % of clean curve
            SEM_f = standard_deviat_clean./sqrt(nw_clean);% Standard error(f)
            ts = tinv(0.975, (nw_clean-1) );              % T-Score
            DTB__hvsr__confidence95{dat_id,1} = ts*SEM_f;
            % of original
            SEM_f = standard_deviat_full./sqrt(nw);% Standard error(f)
            ts = tinv(0.975, (nw-1) );             % T-Score
            DTB__hvsr__confidence95_full{dat_id,1} = ts*SEM_f;
            %
            % if strcmp(P.ExtraFeatures.debug_mode,'on')
            %     fprintf('........DTB{%d,1}.hvsr.error_full\n',dat_id)
            %     fprintf('........DTB{%d,1}.hvsr.error\n',dat_id)
            % end
            %% index of local stationary points
            nf_curve = length(ave_HV);
            maxampl = max(ave_HV);
            main_peak_id  = 0;
            for r = 1:nf_curve
                if(ave_HV(r)== maxampl)
                    main_peak_id = r;
                    break;
                end
            end
            %% peaks and hollows (DEVELOPMENT)
% %             peaks   = zeros(nf_curve,1);
% %             hollows = zeros(nf_curve,1);
% %             found_peaks   = 0;
% %             found_hollows = 0;
% %             for r = 2:nf_curve-1
% %                 p1= ave_HV(r-1);
% %                 p2= ave_HV(r);
% %                 p3= ave_HV(r+1);
% %                 if(p2>p1 && p2>p3)
% %                     found_peaks=found_peaks+1;
% %                     peaks(found_peaks) = r;
% %                     if(p2>maxampl)
% %                         main_peak_id = r;
% %                         maxampl = p2;
% %                     end
% %                 end
% %                 if(p2<p1 && p2<p3)
% %                     found_hollows=found_hollows+1;
% %                     hollows(found_hollows) = r;
% %                 end
% %             end
% %             peaks   = peaks(1:found_peaks);
% %             hollows = hollows(1:found_hollows);
% %             %
% %             DTB__hvsr__peaks_idx{dat_id,1} = peaks;
% %             DTB__hvsr__hollows_idx{dat_id,1} = hollows;
% %             if strcmp(P.ExtraFeatures.debug_mode,'on')
% %                 fprintf('........DTB__hvsr__peaks_idx{%d,1} = peaks;\n',dat_id)
% %                 fprintf('........DTB__hvsr__hollows_idx{%d,1} = hollows;\n',dat_id)
% %             end
            %% peaks and hollows [END](DEVELOPMENT)
            %% main peak
            if main_peak_id == 0
                %[main_peak_id,~] = find(ave_HV == max(ave_HV));
                main_peak_id = 1;%main_peak_id(1);
            end
            DTB__hvsr__user_main_peak_frequence(dat_id,1) = NaN;
            DTB__hvsr__user_main_peak_amplitude(dat_id,1) = NaN;
            DTB__hvsr__user_main_peak_id_full_curve(dat_id,1) = NaN;
            DTB__hvsr__user_main_peak_id_in_section(dat_id,1) = NaN;
            %
            fpeak = df*(main_peak_id + DTB__section__Frequency_Vector{dat_id,1}(1) -1);
            apeak = ave_HV(main_peak_id);
            DTB__hvsr__auto_main_peak_frequence(dat_id,1) = fpeak;
            DTB__hvsr__auto_main_peak_amplitude(dat_id,1) = apeak;
            DTB__hvsr__auto_main_peak_id_full_curve(dat_id,1)= (main_peak_id + DTB__section__Frequency_Vector{dat_id,1}(1) -1);
            DTB__hvsr__auto_main_peak_id_in_section(dat_id,1) = main_peak_id;
            %
            %% SESAME peak (DEVELOPMENT)
% %             idxp = DTB{dat_id,1}.section.Frequency_Vector(1) -1;% to change betwee id in section and global
% %             Lw = DTB{dat_id,1}.windows.width_sec;
% %             Nw = sum(DTB{dat_id,1}.windows.is_ok);
% %             %
% %             Lw10 = 10/Lw;
% %             LwNw =Lw*Nw;
% %             %
% %             peak_id = 0;
% %             for r = 2:nf_curve-1
% %                 p1= ave_HV(r-1);
% %                 p2= ave_HV(r);
% %                 p3= ave_HV(r+1);
% %                 if(p2>p1 && p2>p3)
% %                     %found_peaks=found_peaks+1;
% %                     % peaks(found_peaks) = r;
% %                     %% check sesame criteria: reliable peak
% %                     
% %                     f0 = df*(r + idxp);
% %                     %apeak = ave_HV(main_peak_id);
% %                     if f0<Lw10; % must be f0 > 10/Lw
% %                         continue;
% %                     end
% %                     
% %                     nc = LwNw*f0;
% %                     if nc<200% must be nc > 200
% %                         continue;
% %                     end
% %                     %
% %                     id05 = fix((0.5*f0)/df); if id05<1; id05=1; end 
% %                     id20 = fix((2.0*f0)/df); if id20>nf_curve; id20=nf_curve; end
% %                     SigmaAf = standard_deviat_clean(id05:id20);
% %                     if 0.5<f0
% %                         if any(SigmaAf>2);% must be SigmaAf < 2
% %                             continue;
% %                         end
% %                     end
% %                     if f0<=0.5% Hz
% %                         if any(SigmaAf>3);% must be SigmaAf < 3
% %                             continue;
% %                         end
% %                     end
% %                     % all criteria satisfied
% %                     peak_id = r;
% %                     fprintf('SESAME PEAK = %f\n',f0)
% %                     %
% %                     % keep sesame 
% %                     DTB__hvsr__auto_main_peak_frequence(dat_id,1)    = f0;
% %                     DTB__hvsr__auto_main_peak_amplitude(dat_id,1)    = ave_HV(peak_id);
% %                     DTB__hvsr__auto_main_peak_id_full_curve(dat_id,1)= (peak_id + DTB{dat_id,1}.section.Frequency_Vector(1) -1);
% %                     DTB__hvsr__auto_main_peak_id_in_section({dat_id,1}= peak_id; 
% %                     break;
% %                 end
% %             end
            %% SESAME peak [END](DEVELOPMENT)
            %% extra
%            if strcmp(P.ExtraFeatures.debug_mode,'on')
 %               fprintf('........DTB{%d,1}.hvsr.auto_main_peak_id = main_peak_id;\n',dat_id)
 %           end    
        else
            fprintf('DATA %d IS LOCKED\n',dat_id)
        end
    end
    function compute_single_hv180(dat_id)
        if DTB__status(dat_id,1) == 1% if status == 0 data will not be changed
            % conventionally nord component is display y-axis
            % and east component is the x-axis
            %
            % angle is zero at positive y-axis and increases
            % counterclockwise
            %
            angle_id = get(T3_P1_angular_samp,'Value');
            DTB__hvsr180__angle_id(dat_id,1) = angle_id;

            if angle_id>1% is off, clean up
                rtog = 180/pi;
                stgs=get(T3_P1_angular_samp,'String');
                angle_step = str2double(  stgs(angle_id,:)  );% degrees
                %
                ifmin = DTB__section__Frequency_Vector{dat_id,1}(1);
                ifmax = DTB__section__Frequency_Vector{dat_id,1}(2);
                nf_curve = ifmax-ifmin+1;
                %
                df = DTB__section__Frequency_Vector{dat_id,1}(3);
                Fvect = df*(  (ifmin-1) : (ifmax-1) );
                %
                % rr:2pi = gg:360  >> gg 2pi = rr 360 
                theta = angle_step;
                rads = pi * ( 0:theta:(180-theta) ) /180;
                HV180 = zeros(nf_curve, length(rads));
                %
                E = DTB__windows__wine{dat_id,1};
                N = DTB__windows__winn{dat_id,1};
                V = DTB__windows__winv{dat_id,1};
                %
                fs = sampling_frequences(dat_id);%         sampling frequence
                npad = DTB__windows__info(dat_id,6);% [ns, ns_window, ns_overlap, 0, 0, ns_pad];
                [FT, ~] = samfft(V, fs, npad);
                FT = FT( ifmin:ifmax, :);
                Vd = smoothing(2*abs(FT), Fvect);
                lastpc = 0;
                for th = 1:length(rads)
                    nowpc = ceil(100*(th/length(rads)));
                    if nowpc > lastpc+5
                        lastpc = nowpc;
                        fprintf('id[%d] %d pc\n',dat_id, nowpc);
                    end
                    %
                    %%
                    %                 fprintf('OPTION-A\n')
                    %                 Er = ( E*cos( rads(th) ) );
                    %                 Nr = ( N*sin( rads(th) ) );
                    %                 HVth = (Er+Nr)./V;
                    %                 HVd =  smoothing(HVth);
                    %%
                    %fprintf('OPTION-B\n')
                    Er = E.*cos( rads(th) );
                    Nr = N.*sin( rads(th) );
                    Hr = Er+Nr;
                    
                    [FT,~] = samfft(Hr, fs, npad);
                    FT = FT( ifmin:ifmax, :);
                    HHr = smoothing(2*abs(FT), Fvect);
                    HVd = HHr./Vd;
                    %% average curve
                    OKS = DTB__windows__is_ok{dat_id,1};
                    nok = sum(OKS);
                    nw = DTB__windows__number(dat_id,1);
                    ave_hv= 0*HVd(:,1);
                    for w = 1:nw
                        if( OKS(w)==1 )
                            ave_hv = ave_hv + HVd(:,w);
                        end
                    end
                    HV_curve= ave_hv/nok;
                    HV180(:,th) = HV_curve;
                end
                DTB__hvsr180__angle_step(dat_id,1) = theta;
                DTB__hvsr180__spectralratio{dat_id,1} = HV180;
                %%
                preferred_direction = zeros( size(HV180,1), 10);
                for ff=1:size(HV180,1)% run along frequences
                    line = HV180(ff,:);
                    for w=1:length(line); if isnan(line(w)); line(w)=0; end; end 
                    [~,ccmx] = find(  line == max(line) );
                    [~,ccmn] = find(  line == min(line) );
                    if ~isempty(ccmn) && ~isempty(ccmx)
                        amplimx = line(ccmx(1));
                        amplimn = line(ccmn(1));
                        aver = mean(line);
                        % rr:2pi = gg:360  >> gg 2pi = rr 360  >> gg = rr*180/pi
                        frq = Fvect(ff);
                        angledegmx = rtog * rads(ccmx(1));
                        angledegmn = rtog * rads(ccmn(1));
                        preferred_direction(ff,1:10) = [...
                            ccmx(1),abs(amplimx-aver), amplimx, angledegmx, ...
                            ccmn(1),abs(amplimn-aver), amplimn, angledegmn, ...
                            frq,aver];
                    end
                end
                DTB__hvsr180__preferred_direction{dat_id,1} = preferred_direction;
                %
                if strcmp(P.ExtraFeatures.debug_mode,'on')
                    fprintf('....sets:\n')
                    fprintf('........DTB__hvsr180__angle_id(%d,1)\n',dat_id)
                    fprintf('........DTB__hvsr180__angles{%d,1}\n',dat_id)
                    fprintf('........DTB__hvsr180__angle_step(%d,1) = theta;\n',dat_id)
                    fprintf('........DTB__hvsr180__spectralratio{%d,1}\n',dat_id)
                    fprintf('........DTB__hvsr180__preferred_direction{%d,1}\n',dat_id)


                    fprintf('NO........DTB{%d,1}.hvsr180.peaks_idx{th}\n',dat_id)
                    fprintf('NO........DTB{%d,1}.hvsr180.hollows_idx{th}\n',dat_id)
                end
            end
        else
            fprintf('DATA %d IS LOCKED\n',dat_id)
        end
    end
%%    MULTIPLE DATA
    function compute_windowing_all()
        Ndata = size(SURVEYS,1);
        if Ndata==0; return; end
        %
        clc
        % checks
        for dd = 1:Ndata
            if DTB__status(dd,1) ~= 1; continue; end
            if 0<check_filter_status(dd); return; end
        end
        %
        % windowing
        for dd = 1:Ndata
            if DTB__status(dd,1) ~= 1; continue; end
            fprintf('Windowing File[%d]: %s\n',dd,SURVEYS{dd,2})
            compute_single_windowing(dd);
        end
    end
    function status = database_compute_all()
        %
        status = 0;
        Ndata = size(SURVEYS,1);
        if Ndata==0; return; end
        %
        for dd = 1:Ndata
            % fprintf('File: %d\n',d)
            if DTB__windows__number(dd,1)==0; continue; end
            database_single_computation(dd);
            status = 1;
        end
    end
%%    more
    function [SV] =  smoothing(IV,fvec)
        SV=IV;
        smoothing_strategy = get(T3_PA_wsmooth_strategy,'Value');
        amount=smoothing_constant_fro_mslider();
        if amount>0
            switch smoothing_strategy
                case 1% Konno-Ohmachi
                    % fprintf('smooth: Konno-Ohmachi\n');
                    SV=KonnoOhmachiII(IV,fvec,amount);
                case 2
                    % smooth(y,span,method)
                    %fprintf('smooth: Average\n');
                    % amount = 5+fix(0.25*amount_slider*size(IV,1));
                    uplim = fix(0.25*size(IV,1));
                    if amount>uplim; amount=uplim; end
                    LL = size(IV,2);
                    SV=IV;
                    for cc=1:LL
                        SV(:,cc)=smooth(IV(:,cc),amount,'moving');
                    end
                otherwise; error('unknown smoothing strategy')
            end
        end
    end
    function [amount]=smoothing_constant_fro_mslider()
        amount_slider = get(T3_PD_smooth_slider,'Value');
        amount=0;
        switch get(T3_PA_wsmooth_strategy,'Value')
            case 1% Konno Ohmachi
                amount = 5 + fix(amount_slider*95);
            case 2% average
                amount= 1+fix(24*amount_slider);
        end
    end
    function setup_smoothing_value()
        amount=smoothing_constant_fro_mslider();
        switch get(T3_PA_wsmooth_strategy,'Value')
            case 1% Konno Ohmachi
                %fprintf('Konno\n')
                tempstr = strcat('b=',num2str(amount));
                set(T3_PA_wsmooth_amount,'String',tempstr)
                set(T1_PA_smoothing_parameter_value,'String',tempstr)
            case 2% average
                %fprintf('average\n')
                tempstr = strcat(num2str(amount),'%');
                set(T3_PA_wsmooth_amount,'String',tempstr)
                set(T1_PA_smoothing_parameter_value,'String',tempstr)
        end
        if isnan(amount)
            set(T3_PA_wsmooth_amount,'String','n.a.')
        end
    end
    function imagenorm_profile( DATI, Xivec,Zjvec, nx, smoothing_strategy,smoothing_radius)
        % 
        % not accounts for elevation
        %
        [XBef,ZBef] = meshgrid(Xivec,Zjvec);
        xmi = min(Xivec);
        xma = max(Xivec);
        %
        xi = linspace(xmi, xma, nx);%%  change resolution
        zi = Zjvec; %fliplr(linspace(zmi, zma, nz));%%  change resolution
        [XAft,ZAft] = meshgrid(xi,zi);
        %save debug_imagenorm.mat
        DAft = interp2(XBef,ZBef,DATI,  XAft,ZAft);
        %
        %% smoothing
        [DAft] = prfsmoothing(DAft, smoothing_strategy,smoothing_radius);
        lines1= linspace( min(min(DAft)), max(max(DAft)), 200 );
        contourf( xi, zi, DAft, lines1, 'EdgeColor','none'); 
        caxis([min(min(DATI)), max(max(DATI))]) 
        colorbar
        drawnow
    end% function
    function status = check_filter_status(dat_id)
        idfilter = get(T2_PA_filter,'Value');% [1]off, [2]bandpass [3]lowpass
        fs = sampling_frequences(dat_id);
        status = 0;
        switch idfilter
            case 1% OFF
                set(T2_PA_dattoshow,'Value',1)
                set(T2_PA_dattoshow,'Enable','off')
                %
            case 2% BANDPASS
                Fc1   = str2double(get(T2_PA_filter_fmin,'String'));
                Fc2   = str2double(get(T2_PA_filter_fmax,'String'));
                if ~( Fc1<Fc2 && Fc2<(fs/2) && Fc1>0 && Fc2>0 && fs>0 )
                    status = 1;
                    Message = sprintf('In order to test and use the Band-pass filter a frequency range [Fmin,Fmax] must be set.\nMust be:\nFmin < Fmax < (Samplig Frequency)/2\n and all values must be positive.');
                    msgbox(Message,'MESSAGE')
                end
            case 3% LOWPASS
                Fc2   = str2double(get(T2_PA_filter_fmax,'String'));
                if ~( Fc2<(fs/2) && Fc2>0 && fs>0 ) 
                    status = 1;
                    Message = sprintf('In order to test and use the Low-pass filter a maximum frequence (Fmax) must be set.\nMust be:\nFmax< (Samplig Frequency)/2\n and all values must be positive.');
                    msgbox(Message,'MESSAGE')
                end
            case 4% HIGHPASS
                Fc2   = str2double(get(T2_PA_filter_fmax,'String'));
                if ~( Fc2<(fs/2) && Fc2>0 && fs>0 ) 
                    status = 1;
                    Message = sprintf('In order to test and use the HIgh-pass filter a frequence (Fmax) must be set.\nMust be:\nFmax< (Samplig Frequency)/2\n and all values must be positive.');
                    msgbox(Message,'MESSAGE')
                end        
        end
    end
%%    save on file
    function save_hvsr_on_ascii(folder_name)
        is_exported = 0;
        if(folder_name)
            Ndata = size(SURVEYS,1);
            
            for ss = 1:Ndata
                %% write files.hv -----------------------------------------
                if ~isempty(DTB__hvsr__curve{ss,1})
                    [~,s,~]=fileparts(SURVEYS{ss,2});
                    fname = strcat(folder_name,'/',s,'.hv');
                    %
                    df = DTB__section__Frequency_Vector{ss,1}(3);
                    Fvec  = df*(  (DTB__section__Frequency_Vector{ss,1}(1)-1) : (DTB__section__Frequency_Vector{ss,1}(2)-1) ).';%% WARNING assume same frequence discretization 
                    hvsr  = DTB__hvsr__curve{ss,1};
                    hvsrNV= DTB__hvsr__curve_NV{ss,1};
                    hvsrEV= DTB__hvsr__curve_EV{ss,1};
                    STdev = DTB__hvsr__standard_deviation{ss,1};
                    Confidence95 = DTB__hvsr__confidence95{ss,1}; 
                    %
                    fid = fopen(fname,'w');
                    fprintf(fid,'# %s, %s: HVSR output\n',P.appname,P.appversion);
                    fprintf(fid,'# Original data file: %s\n',SURVEYS{ss,2});
                    fprintf(fid,'#\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'# ================= INFO =================\n');
                    fprintf(fid,'# Number of windows = %d\n',DTB__windows__number(ss,1));
                    fprintf(fid,'# Number of windows considered = %d\n',sum(DTB__windows__is_ok{ss,1}));
                    fprintf(fid,'# Automatic peak: f0 = %3.2f\n', DTB__hvsr__auto_main_peak_frequence(ss,1));
                    fprintf(fid,'# Automatic peak: Amplitude = %3.2f\n', DTB__hvsr__auto_main_peak_amplitude(ss,1));
                    if isnan(DTB__hvsr__user_main_peak_frequence(ss,1))
                        fprintf(fid,'# Manual peak: f0 = n.a.\n');
                        fprintf(fid,'# Manual peak: Amplitude = n.a.\n');
                    else
                        fprintf(fid,'# Manual peak: f0 = %3.2f\n', DTB__hvsr__user_main_peak_frequence(ss,1));
                        fprintf(fid,'# Manual peak: Amplitude = %3.2f\n', DTB__hvsr__user_main_peak_amplitude(ss,1));
                    end
                    fprintf(fid,'#\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'# ======== PROCESSING PARAMETERS =========\n');
                    fprintf(fid,'# windows width (seconds) = %3.2f\n',DTB__elab_parameters__windows_width(ss,1));
                    fprintf(fid,'# windows overlap (%%) = %3.2f\n',DTB__elab_parameters__windows_overlap(ss,1));
                    fprintf(fid,'# windows tapering (%%) = %3.2f\n',DTB__elab_parameters__windows_tapering(ss,1));
                    fprintf(fid,'# frequence delta (Hz) = %f\n',df);
                    fprintf(fid,'# STA/LTA = %f\n',DTB__elab_parameters__windows_sta_vs_lta(ss,1));
                    %
                    if strcmp(DTB__elab_parameters__windows_pad{ss,1}, 'off')
                        fprintf(fid,'# windows pad: off\n');
                    else
                        fprintf(fid,'# windows pad: %d\n',DTB__elab_parameters__windows_pad{ss,1});
                    end
                    %
                    % HV strategy
                    strategy_id = DTB__elab_parameters__hvsr_strategy(ss,1);
                    dummystring = get(T2_PA_HV,'String');
                    fprintf(fid,'# HV Ratio strategy: %s\n',dummystring{strategy_id});
                    %
                    % smoothing strategy
                    strategy_id = DTB__elab_parameters__smoothing_strategy(ss,1);
                    dummystring = get(T3_PA_wsmooth_strategy,'String');
                    fprintf(fid,'# smoothing strategy: %s\n',dummystring{strategy_id});
                    %
                    % smoothing constant
                    amount_slider=DTB__elab_parameters__smoothing_slider_val(ss,1);
                    switch strategy_id
                        case 1% Konno Ohmachi
                            amount = 5 + fix(amount_slider*95);
                            tempstr = strcat('b=',num2str(amount));
                        case 2% average
                            amount= 1+fix(24*amount_slider);
                            tempstr = strcat(num2str(amount),'%');
                    end
                    fprintf(fid,'# smoothing constant: %s\n',tempstr);
                    %
                    fprintf(fid,'#\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'# ============= DEFINITIONS ==============\n');
                    fprintf(fid,'# Standard Deviation (SD) = ( SUM(Xi-X0)/(N-1) )^1/2\n');
                    fprintf(fid,'#     Xi  = value of the i-th window\n');
                    fprintf(fid,'#     X0  = value of the mean\n');
                    fprintf(fid,'#     N   = number of windows\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'# ========= DATA COLUMNS LEGEND ==========\n');
                    fprintf(fid,'# [Frequence][HVSR][Standard Deviation][Confidence-95pc][N/V][E/V] \n');
                    fprintf(fid,'# Data_Begins_After_this_line\n');
                    
                    for ir = 1:size(Fvec,1)
                        fprintf(fid,'%f %f %f %f %f %f\n', Fvec(ir), hvsr(ir), STdev(ir), Confidence95(ir), hvsrNV(ir), hvsrEV(ir) );
                    end
                    fclose(fid);
                    is_exported = 1;
                else
                    dummystr = strcat('SAM: There is no hvsr curve computed for the data:',SURVEYS{ss,2});
                    warning(dummystr)
                end% if not empty
            end
        end
        if is_exported == 1
            fprintf('[HVSR curves Exported]\n')
        else
            fprintf('[NO HVSR CURVES TO EXPORT]\n')
        end
    end
    function save_xy_property_on_ascii(folder_name)
        no_procede = 0;
        if(folder_name)
            Ndata = size(SURVEYS,1);
            for d = 1:Ndata
                if DTB__windows__number(d,1)>0
                    no_procede = 1;  
                end
            end
            if no_procede==0
                fprintf('[NO DATA TO EXPORT]\n')
                return;
            end
            
            %
            %% get F0 and amplitude
            XY = zeros(Ndata,2);
            F0 = zeros(Ndata,1);
            A0 = zeros(Ndata,1);
            for d = 1:Ndata
                XY(d,1) = SURVEYS{d,1}(1);
                XY(d,2) = SURVEYS{d,1}(2);
                if ~isnan(DTB__hvsr__user_main_peak_frequence(d,1))
                    F0(d) = DTB__hvsr__user_main_peak_frequence(d,1);% user selection is always preferred
                    A0(d) = DTB__hvsr__user_main_peak_amplitude(d,1);% user selection is always preferred
                else
                    if ~isnan(DTB__hvsr__auto_main_peak_frequence(d,1))
                        F0(d) = DTB__hvsr__auto_main_peak_frequence(d,1);
                        A0(d) = DTB__hvsr__auto_main_peak_amplitude(d,1);
                    else
                        F0(d)=NaN;
                        A0(d)=NaN;
                    end
                end
            end
            %
            %% save on file
            %% ID_x_y_additional_peaks.txt'
            fnameFmore = strcat(folder_name,'/ID_x_y_additional_peaks.txt');
            fid = fopen(fnameFmore,'w');
            fprintf(fid,'# %s, %s\n',P.appname,P.appversion);
            fprintf(fid,'#\n');
            fprintf(fid,'# Additional peaks highlighted by the user (i.e. besides the fundamental one),\n');
            fprintf(fid,'# at different locations\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# ========= DATA COLUMNS LEGEND ==========\n');
            fprintf(fid,'# [File ID][X/East][Y/North][Frequecy-1,Amplitude1, Frequecy-2,Amplitude2, ... As many columns as the highlighted peaks] \n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Note: To make the list of additional peaks easily readable in table form, a fixed number of columns is\n');
            fprintf(fid,'#        created using as a reference the location with the highest number of additional peaks.\n');
            fprintf(fid,'#        For those location possessing a smaller number of additional peaks the dummy value "-1" is introduced.\n');
            fprintf(fid,'#        Peaks are ordered in ascending frequency order.\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Data_Begins_After_this_line\n');
            % get the number of additional peaks
            n_add_peaks = 0;
            for d = 1:Ndata
                if size(DTB__hvsr__user_additional_peaks{d,1},1)>n_add_peaks; n_add_peaks=size(DTB__hvsr__user_additional_peaks{d,1},1); end
            end
            if  n_add_peaks>0
                for d = 1:Ndata
                    F_list = -ones(1, n_add_peaks);
                    A_list = -ones(1, n_add_peaks);
                    if ~isempty(DTB__hvsr__user_additional_peaks{d,1})
                        for d2 = 1:size(DTB__hvsr__user_additional_peaks{d,1},1)
                            F_list(d2) = DTB__hvsr__user_additional_peaks{d,1}(d2, 3);
                            A_list(d2) = DTB__hvsr__user_additional_peaks{d,1}(d2, 4);
                        end
                    end
                    fprintf(fid,'%d %f %f ', d, XY(d,1), XY(d,2));
                    for d2 = 1:n_add_peaks
                        if d2<n_add_peaks
                            fprintf(fid,'%f %f ',  F_list(d2), A_list(d2) );
                        else
                            fprintf(fid,'%f %f',  F_list(d2), A_list(d2) );
                        end
                    end
                    fprintf(fid,'\n');
                end
            else
                fprintf('No additioal peaks were selected by the user\n')
            end
            fclose(fid);
            fprintf('[additional peaks saved]\n')
            %% ID_x_y_f0_A0.txt'
            fnameF0 = strcat(folder_name,'/ID_x_y_f0_A0.txt');
            fid = fopen(fnameF0,'w');
            fprintf(fid,'# %s, %s\n',P.appname,P.appversion);
            fprintf(fid,'#\n');
            fprintf(fid,'# Frequency of the Main Peak at different locations.\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# ========= DATA COLUMNS LEGEND ==========\n');
            fprintf(fid,'# [data ID][X/East][Y/North][Main Peak frequence][Main Peak Amplitude] \n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Note: when building this file, curve peaks selected by the user\n');
            fprintf(fid,'#       are preferred over the automatic choice\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Data_Begins_After_this_line\n');
            for rr = 1:Ndata
                fprintf(fid,'%d %f %f %3.2f %3.2f\n',rr, XY(rr,1), XY(rr,2), F0(rr), A0(rr));
            end
            fclose(fid);
            fprintf('[ID-X-Y-Fundamental freq.-Amplitude (at the fundamental freq.), saved]\n')
            %
            %
            %
            %% get directions (code pasted from the plot function)
            Ampl   = zeros(Ndata,1);
            DirectionalPeakValues = cell(Ndata,1);
            MaindirectionId = zeros(Ndata,1);
            Grads = zeros(Ndata,1);
            Df_Grads = cell(Ndata,1);
            Df_Ampl  = cell(Ndata,1);
            Df_info  = cell(Ndata,1);
            ddf =str2double( get(h_deltafmainpeak,'string') )/2;% as of 20180718 this value is percent (not Hz)
            if ddf==0; ddf=10; end%    20180718
            %
            for d = 1:Ndata
                if ~isnan(DTB__hvsr__user_main_peak_amplitude(d,1))
                    PeakId = DTB__hvsr__user_main_peak_id_in_section(d,1);
                    PeakFr = DTB__hvsr__user_main_peak_frequence(d,1);% 20180719
                else
                    PeakId = DTB__hvsr__auto_main_peak_id_in_section(d,1);
                    PeakFr = DTB__hvsr__auto_main_peak_frequence(d,1);% 20180719
                end
                Ampl(d)= DTB__hvsr180__preferred_direction{d,1}(PeakId,2);
                %
                % main peak
                DirectionalPeakValues{d,1} = DTB__hvsr180__spectralratio{d,1}(PeakId, :);
                [~,c] = find(DirectionalPeakValues{d}==max(DirectionalPeakValues{d}));
                %
                MaindirectionId(d)=c(1);
                theta = DTB__hvsr180__angle_step(d,1);
                angles = 0:theta:(180-theta);
                Grads(d) = angles(MaindirectionId(d));
                %
                % around main peak (to be sure that not much variability is present)
                offseti = DTB__section__Frequency_Vector{d,1}(1);
                odf = DTB__section__Frequency_Vector{d,1}(3); 
                ni1 = floor( (PeakFr*(1-ddf/100))/odf ) -offseti+1;%   20190330   PeakFr = (PeakId+offseti-1)*odf
                ni2 = ceil(  (PeakFr*(1+ddf/100))/odf ) -offseti+1;%   20190330   (PeakFr +- perturbation)/odf -offseti+1 = freq.locat   ---> check: 100*(PeakFr-(ni1+offseti-1)*odf)/PeakFr

                istr = ni1; if istr<1; istr=1; end
                istp = ni2; if istp>size(DTB__hvsr180__preferred_direction{d,1},1); istp=PeakId; end
                %
                fprintf(' Frequency  (-)[%3.2f]  Peak[%3.2f]   (+)[%3.2f]   \n',(ni1+offseti-1)*odf, PeakFr,(ni2+offseti-1)*odf);
                ids =  istr:istp;
                directs = DTB__hvsr180__preferred_direction{d,1}(ids,1);
                Df_Grads{d,1} = angles(directs);
                Df_Ampl{d,1}  = DTB__hvsr180__preferred_direction{d,1}(ids,2);
                Df_info{d,1}  = [PeakFr,   (ni1+offseti-1)*odf,   (ni2+offseti-1)*odf];
            end
            Rads = Grads*pi/180;%   rr=gg*pi/180
            %
            %% directions around peak (min, max, average)
            df_angle_mi = zeros(Ndata,1);
            df_angle_ma = zeros(Ndata,1);
            df_xproj_mi = zeros(Ndata,1);
            df_xproj_ma = zeros(Ndata,1);
            df_yproj_mi = zeros(Ndata,1);
            df_yproj_ma = zeros(Ndata,1);
            for d = 1:Ndata
                mim = min(Df_Grads{d,1});
                [~,imim]= find(Df_Grads{d,1}==mim);
                Ami = min(Df_Ampl{d,1}(imim,1));

                mam = max(Df_Grads{d,1});
                [~,imam]= find(Df_Grads{d,1}==mam);
                Ama = max(Df_Ampl{d,1}(imam,1));

                df_rad = [mim; mam]*pi/180;

                df_xproj = cos(df_rad);
                df_yproj = sin(df_rad);

                df_xproj_mi(d) = Ami*df_xproj(1);
                df_xproj_ma(d) = Ama*df_xproj(2);

                df_yproj_mi(d) = Ami*df_yproj(1);
                df_yproj_ma(d) = Ama*df_yproj(2);

                df_angle_mi(d) = mim;
                df_angle_ma(d) = mam;
            end
            %
            %% main direction (write file)
            fnameDirDf = strcat(folder_name,'/ID_x_y_direction_in_a_frequence_interval.txt');
            fid = fopen(fnameDirDf,'w');
            fprintf(fid,'# %s, %s\n',P.appname,P.appversion);
            fprintf(fid,'#\n');
            fprintf(fid,'# Direction associated to the main peak as a function of the location.\n');
            fprintf(fid,'# Here the maximum and minimum angles in a buffer of %f percent around\n',ddf);
            fprintf(fid,'# the main peak are computed.\n');
            switch USER_PREFERENCE_hvsr_directional_reference_system
                case 'compass'
                    fprintf(fid,'#\n');
                    fprintf(fid,'#  The "compass" mode is on. Output angles will be in [-90,90]\n');
                    fprintf(fid,'#  where:\n');
                    fprintf(fid,'#      West is -90\n');
                    fprintf(fid,'#      North is   0\n');
                    fprintf(fid,'#      East is  90\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'#   Axis are oriented as:\n');
                    fprintf(fid,'#       |y(N)      \n');
                    fprintf(fid,'#       | /        \n');
                    fprintf(fid,'#       |/a____x(E)\n');
                otherwise
                    fprintf(fid,'# The angle (a) is assumed countercklockwise increasing, starting at the X(East) axix\n');
                    fprintf(fid,'#       |y(N)      \n');
                    fprintf(fid,'#       | /        \n');
                    fprintf(fid,'#       |/a____x(E)\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'#      East is     0\n');
                    fprintf(fid,'#      North is   90\n');
                    fprintf(fid,'#      West is  180\n');
            end
            fprintf(fid,'# Vector magnitude represent how much the amplitude at the computed directions\n');
            fprintf(fid,'# is higher with respect to the peak amplitude averaged on all directions\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Note: default value of the frequence buffer in writing this file is 1 Hz.\n');
            fprintf(fid,'#       User may change the buffer by changing the value "Df(%%)"\n');
            fprintf(fid,'#       on tab "2D Views".\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# ========= DATA COLUMNS LEGEND ==========\n');
            fprintf(fid,'# Column  1: ID\n');
            fprintf(fid,'# Column  2: Location: X/East\n');
            fprintf(fid,'# Column  3: Location Y/North\n');

            fprintf(fid,'# Column  4: Peak frequence\n');
            fprintf(fid,'# Column  5: Minimum frequence considered\n');
            fprintf(fid,'# Column  6: Maximum frequence considered\n');

            fprintf(fid,'# Column  7: Minimum angle\n');
            fprintf(fid,'# Column  8: Direction at main peak (minimum angle), x-component\n');
            fprintf(fid,'# Column  9: Direction at main peak (minimum angle), y-component\n');
            fprintf(fid,'# Column 10: Maximum angle\n');
            fprintf(fid,'# Column 11: Direction at main peak (maximum angle), x-component\n');
            fprintf(fid,'# Column 12: Direction at main peak (maximum angle), y-component\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Note: when building this file, curve peaks selected by the user\n');
            fprintf(fid,'#       are preferred over the automatic choice\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Data_Begins_After_this_line\n');
            if(strcmp(USER_PREFERENCE_hvsr_directional_reference_system,'compass'))
                df_angle_mi2 = -df_angle_mi+90;
                df_angle_ma2 = -df_angle_ma+90;
            else
                df_angle_mi2 = df_angle_mi;
                df_angle_ma2 = df_angle_ma;
            end
            for rr = 1:Ndata
                fprintf(fid,'%d %f %f %3.2f %3.2f %3.2f %3.1f %f %f %3.1f %f %f\n', rr, XY(rr,1), XY(rr,2), ...
                    Df_info{rr,1}, ...
                    df_angle_mi2(rr), df_xproj_mi(rr), df_yproj_mi(rr), ...
                    df_angle_ma2(rr), df_xproj_ma(rr), df_yproj_ma(rr));
            end
            fclose(fid);
            fprintf('[ID-X-Y - min e max angular direction in a buffer around the main peak, saved]\n')
            %% main direction (at peak)
            %arrowmaxlength = scalearrows*max([ ,  ]);
            %   \  |y /(N)
            %    \ | /
            %     \|/_____x(E)
            xproj = cos(Rads);
            yproj = sin(Rads);
            for d = 1:Ndata
                xproj(d) = Ampl(d)*xproj(d);
                yproj(d) = Ampl(d)*yproj(d);
            end
            %% main direction (write file)
            fnameDir0 = strcat(folder_name,'/ID_x_y_direction_at_main_peak.txt');
            fid = fopen(fnameDir0,'w');
            fprintf(fid,'# %s, %s\n',P.appname,P.appversion);
            fprintf(fid,'#\n');
            fprintf(fid,'# Direction associated to the main peak as a function of the location.\n');
            fprintf(fid,'# Vector magnitude represent how much the amplitude at the preferential direction\n');
            fprintf(fid,'# is higher with respect to the peak amplitude averaged on all directions\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# ========= DATA COLUMNS LEGEND ==========\n');
            fprintf(fid,'# Column 1: ID\n');
            fprintf(fid,'# Column 2: Location: X/East\n');
            fprintf(fid,'# Column 3: Location Y/North\n');
            fprintf(fid,'# Column 4: Direction at main peak x-component\n');
            fprintf(fid,'# Column 5: Direction at main peak y-component\n');
            fprintf(fid,'#\n');
            fprintf(fid,'#       |y(N)    \n');
            fprintf(fid,'#       |        \n');
            fprintf(fid,'#       |____x(E)\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Note: when building this file, curve peaks selected by the user\n');
            fprintf(fid,'#       are preferred over the automatic choice\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Data_Begins_After_this_line\n');
            for rr = 1:Ndata
                fprintf(fid,'%d %f %f %f %f\n', rr, XY(rr,1), XY(rr,2), xproj(rr), yproj(rr));
            end
            fclose(fid);
            fprintf('[X-Y - direction associated to the peak, saved]\n')            
            %% angles only
            fnameDir0 = strcat(folder_name,'/ID_x_y_angles_around_main_peak.txt');
            fid = fopen(fnameDir0,'w');
            fprintf(fid,'# %s, %s\n',P.appname,P.appversion);
            fprintf(fid,'#\n');
            fprintf(fid,'# Direction associated to the main peak');
            fprintf(fid,'# and minimum/maximum angles in a a frequency buffer %f percent around the peak\n',ddf);
            fprintf(fid,'# Vector magnitude represent how much the amplitude at the preferential direction\n');
            fprintf(fid,'# is higher with respect to the peak amplitude averaged on all directions\n');
            switch USER_PREFERENCE_hvsr_directional_reference_system
                case 'compass'
                    fprintf(fid,'#\n');
                    fprintf(fid,'#  The "compass" mode is on. Output angles will be in [-90,90]\n');
                    fprintf(fid,'#  where angles are in degrees, and\n');
                    fprintf(fid,'#      West is -90\n');
                    fprintf(fid,'#      North is   0\n');
                    fprintf(fid,'#      East is  90\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'#   Axis are oriented as:\n');
                    fprintf(fid,'#       |y(N)      \n');
                    fprintf(fid,'#       | /        \n');
                    fprintf(fid,'#       |/a____x(E)\n');
                otherwise
                    fprintf(fid,'# The angle (a) is assumed countercklockwise increasing, starting at the X(East) axix\n');
                    fprintf(fid,'#       |y(N)      \n');
                    fprintf(fid,'#       | /        \n');
                    fprintf(fid,'#       |/a____x(E)\n');
                    fprintf(fid,'#\n');
                    fprintf(fid,'#  Angles are in degrees, and\n');
                    fprintf(fid,'#      East is     0\n');
                    fprintf(fid,'#      North is   90\n');
                    fprintf(fid,'#      West is  180\n');
            end
            fprintf(fid,'#\n');
            fprintf(fid,'# ========= DATA COLUMNS LEGEND ==========\n');
            fprintf(fid,'# Note: when building this file, curve peaks selected by the user\n');
            fprintf(fid,'#       are preferred over the automatic choice\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Column 1: ID\n');
            fprintf(fid,'# Column 2: Angle (minimum)\n');
            fprintf(fid,'# Column 3: Angle (at peak)\n');
            fprintf(fid,'# Column 4: Angle (maximum)\n');
            fprintf(fid,'# Column 5: Magnitude rappresenting neanignness\n');
            fprintf(fid,'# Column 6: Original File name\n');
            fprintf(fid,'#\n');
            fprintf(fid,'#\n');
            fprintf(fid,'# Data_Begins_After_this_line\n');
            if(strcmp(USER_PREFERENCE_hvsr_directional_reference_system,'compass'))
                    Grad2 = -Grads+90;
                    df_angle_mi2 = -df_angle_mi+90;
                    df_angle_ma2 = -df_angle_ma+90;
                    for rr = 1:Ndata
                        fprintf(fid,'%d %3.1f %3.1f %3.1f %f     %s\n', rr, df_angle_ma2(rr), Grad2(rr), df_angle_mi2(rr), Ampl(rr), SURVEYS{rr,2}  );  
                        %fprintf('Angles %3.1f   %3.1f   %3.1f   %f     %s\n', df_angle_ma2(rr), Grad2(rr), df_angle_mi2(rr), Ampl(rr), SURVEYS{rr,2}  );  
                    end
            else
                    Grad2 = Grads;
                    df_angle_mi2 = df_angle_mi;
                    df_angle_ma2 = df_angle_ma;
                    for rr = 1:Ndata
                        fprintf(fid,'%d %3.1f %3.1f %3.1f %f     %s\n', rr, df_angle_mi2(rr), Grad2(rr), df_angle_ma2(rr), Ampl(rr), SURVEYS{rr,2}  );  
                        %fprintf('Angles %3.1f   %3.1f   %3.1f   %f     %s\n', df_angle_mi2(rr), Grad2(rr), df_angle_ma2(rr), Ampl(rr), SURVEYS{rr,2}  );  
                    end
            end
            fclose(fid);
            fprintf('[Angles around the peak, saved]\n')
        
        end
    end
%  _________________________________________________________________________
end% end gui
%
% 
% 
% 
% 
% 
% 
% 
% 
%
