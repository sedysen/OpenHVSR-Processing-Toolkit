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
function [fileformat, Fs, DATA_V_XE_YN, datafile_columns, datafile_separator] = Pfiles__Microtremor_File_Recognition(FileNamePath)
fileformat         = ''; 
Fs                 = [];
DATA_V_XE_YN       = []; 
datafile_columns   = []; 
datafile_separator = '';

% 
%
%
% OUTPUT:
% fileformat          the kind of file it was open
% Fs                  sampling frequence
% DATA_V_XE_YN 
% datafile_columns    Index of columns must be specified [V  EW  NS]
% datafile_separator: last header line   
% 
% 
% E = H1    (East)
% N = H2    (North)
% #       |y(N)      
% #       | /        
% #       |/a____x(E)

% tabularasa
% FileNamePath = 'test_data_for_debug/testo.txt'
% FileNamePath = 'test_data_for_debug/Mae.saf'
% %FileNamePath = 'test_data_for_debug/Grilla_to_saf.saf'
% FileNamePath = 'test_data_for_debug/Pasi_1.saf'

%

%% recognize file format and scan to recognize if it is a known
MAE_line01 = 'SESAME ASCII data format (saf) v. 1   (this line must not be modified)';%    MAE
MAE_line_B = '# -------------------------------------------------------------';%    MAE
MAE_lineC1 = '# -------------- Inizio file dati --------------';%    MAE
MAE_separator = '####-------------------------------------------------------';%<< data separation

GRI_line01 = 'SESAME ASCII data format (saf) v. 1';%                                        Grilla
GRI_lineB1 = '#';%                                        Grilla
GRI_separator = '####--------------------';%<< data separation


PAS_line01 = 'SESAME ASCII data format (saf) v. 1';%                                      Pasi 
PAS_lineA0 = '####   ###   ###  #';%                                      Pasi 
PAS_lineA1 = '#   # #   # #   # #';%                                      Pasi 
PAS_lineA2 = '#   # #   # #     #';%                                      Pasi 
PAS_lineA3 = '####  #####  ###  #';%                                      Pasi 
PAS_lineA4 = '#     #   #     # #';%                                      Pasi 
PAS_lineA5 = '#     #   # #   # #';%                                      Pasi 
PAS_lineA6 = '#     #   #  ###  #';%                                      Pasi 
PAS_separator = '####------------------------';%<< data separation

%[filepath,filename,extension] = fileparts(FileNamePath);
[~,~,extension] = fileparts(FileNamePath);
%
% value = 0;
First_line_of_data = 0;

if strcmp(extension,'.saf') || strcmp(extension,'.SAF')
    %% Import file content
    fid=fopen(FileNamePath,'r');
    % fprintf('fid:[%d] load: %s\n',fid,FileNamePath)
    B = textscan(fid, '%s', 'delimiter', '\n');%% B contains all the contents of the opened file.
    B=B{1,1};
    fclose(fid);
    clear fid
    %
    %
    found_saf_definition = 0;
    %
    is_Mae = 0;% MAE
    is_Gri = 0;% Grilla 
    is_Pas = 0;% Pasi
    %
    for ii = 1:size(B,1)
        textline = B{ii,1};
        %% MAE
        if length(textline)>=70% saf definition
            if strcmp(textline(1:70),MAE_line01); 
                is_Mae=is_Mae+1;
                found_saf_definition = 1;
            end
        end
        if length(textline)>=63
            if strcmp(textline(1:63),MAE_line_B); is_Mae=is_Mae+1; end
        end
        if length(textline)>=59 && ii>1% DATA SEPARATOR 
            if strcmp(textline(1:59),MAE_separator); 
                is_Mae=is_Mae+1; 
                if length(B{ii-1,1})>=70
                    if strcmp(B{ii-1,1}(1:70),MAE_lineC1); is_Mae=is_Mae+1; end
                end
                First_line_of_data = ii+1;
                datafile_separator = GRI_lineC2;
                if is_Mae >= 4% most probably is this format
                    fileformat = 'MAE-01';
                    %value = is_Mae;
                    break;
                end
            end
        end
        %% Grilla
        if length(textline)>=35% saf definition
            if strcmp(textline(1:35),GRI_line01); 
                is_Gri=is_Gri+1;
                found_saf_definition = 1;
            end
        end
        if length(textline)>=24% DATA SEPARATOR 
            if strcmp(textline(1:24),GRI_separator); 
                is_Gri=is_Gri+1; 
                if length(B{ii-1,1})<3 && ~isempty(B{ii-1,1})
                    if strcmp(B{ii-1,1}(1),GRI_lineB1); is_Gri=is_Gri+1; end
                    is_Gri=is_Gri+1;
                    First_line_of_data = ii+1;
                    if is_Gri >= 3% most probably is this format
                        fileformat = 'GRILLA-01';
                        datafile_separator = GRI_separator;
                        %value = is_Gri;
                        break;
                    end
                end
            end
        end        
        %% Pasi
        if length(textline)>=35% saf definition
            if strcmp(textline(1:35),PAS_line01); 
                is_Pas=is_Pas+1;
                found_saf_definition = 1;
            end
        end
        if ii>7 && length(B{ii-1,1})>=19 && length(B{ii-2,1})>=19 && length(B{ii-3,1})>=19 && length(B{ii-4,1})>=19 && length(B{ii-5,1})>=19 && length(B{ii-6,1})>=19
            if strcmp(B{ii-6}(1:19),PAS_lineA0) && strcmp(B{ii-5}(1:19),PAS_lineA1) && ...
            strcmp(B{ii-4,1}(1:19),PAS_lineA2) && strcmp(B{ii-3,1}(1:19),PAS_lineA3) && ...       
            strcmp(B{ii-2,1}(1:19),PAS_lineA4) && strcmp(B{ii-1,1}(1:19),PAS_lineA5) && strcmp(B{ii,1}(1:19),PAS_lineA6)              
                is_Pas = 10000000;
                fileformat = 'PASI-01';
            end
        end
        if length(textline)>=28% DATA SEPARATOR 
            if strcmp(textline(1:28),PAS_separator);
                is_Pas=is_Pas+1; 
                if strcmp(fileformat,'PASI-01');
                    %value = is_Pas;
                    First_line_of_data = ii+1;
                    datafile_separator = PAS_separator;
                    break;
                end
            end
        end
        
    end
    % fprintf('>>>>>>>>>>> Exited line(%d)\n',ii)
    % fprintf('>>>>>>>>>>> Fileformat(%d) %s\n',value,fileformat)
    %% Recognize info:
    % SAMP_FREQ = []
    % CH0_ID = UD 
    % CH1_ID = NS 
    % CH2_ID = EW 
    SAMP_FREQ = ''; found_SAMP_FREQ = 0;
    CH0_ID    = ''; found_CH0_ID    = 0;
    CH1_ID    = ''; found_CH1_ID    = 0;
    CH2_ID    = ''; found_CH2_ID    = 0;
    if found_saf_definition==1
        info_to_find = 4;
        for ii = 2:size(B,1)
            textline = B{ii,1};
            %% SAMP_FREQ
            if found_SAMP_FREQ == 0
                if length(textline)>12
                    if strcmp(textline(1:12),'SAMP_FREQ = ')
                        SAMP_FREQ=textline(13:end);% str2double();
                        SAMP_FREQ = SAMP_FREQ(find(~isspace(SAMP_FREQ)));
                        info_to_find = info_to_find-1;
                        found_SAMP_FREQ = 1;
                    end
                end
            end
            %% CH0_ID
            if found_CH0_ID == 0
                if length(textline)>9
                    if strcmp(textline(1:9),'CH0_ID = ')
                        CH0_ID=textline(10:end);
                        CH0_ID = CH0_ID(find(~isspace(CH0_ID)));
                        info_to_find = info_to_find-1;
                        found_CH0_ID    = 1;
                    end
                end
            end
            %% CH1_ID
            if found_CH1_ID == 0
                if length(textline)>9
                    if strcmp(textline(1:9),'CH1_ID = ')
                        CH1_ID=textline(10:end);
                        CH1_ID = CH1_ID(find(~isspace(CH1_ID)));
                        info_to_find = info_to_find-1;
                        found_CH1_ID    = 1;
                    end
                end
            end
            %% CH2_ID
            if found_CH2_ID == 0
                if length(textline)>9
                    if strcmp(textline(1:9),'CH2_ID = ')
                        CH2_ID=textline(10:end);
                        CH2_ID = CH2_ID(find(~isspace(CH2_ID)));
                        info_to_find = info_to_find-1;
                        found_CH2_ID    = 1;
                    end
                end
            end
            if info_to_find ==0; break; end
        end% ii
    end% if found_saf_definition
    % fprintf('SAMP_FREQ = %s\n',SAMP_FREQ)
    % fprintf('CH0_ID    = %s\n',CH0_ID)
    % fprintf('CH1_ID    = %s\n',CH1_ID)
    % fprintf('CH2_ID    = %s\n',CH2_ID)
    %% translate to usable values (depend on file origin)
    Fs = str2double(SAMP_FREQ);
    V_in_column  = 0;
    YN_in_column = 0;
    XE_in_column = 0;
    switch fileformat
        case 'MAE-01'
            switch CH0_ID
                case 'V';  V_in_column  = 1;
                case 'NS'; YN_in_column = 1;
                case 'EW'; XE_in_column = 1;    
            end
            switch CH1_ID
                case 'V';  V_in_column  = 2;
                case 'NS'; YN_in_column = 2;
                case 'EW'; XE_in_column = 2;    
            end
            switch CH2_ID
                case 'V';  V_in_column  = 3;
                case 'NS'; YN_in_column = 3;
                case 'EW'; XE_in_column = 3;    
            end
        case 'GRILLA-01'
            switch CH0_ID
                case 'V'; V_in_column  = 1;
                case 'N'; YN_in_column = 1;
                case 'E'; XE_in_column = 1;    
            end
            switch CH1_ID
                case 'V'; V_in_column  = 2;
                case 'N'; YN_in_column = 2;
                case 'E'; XE_in_column = 2;    
            end
            switch CH2_ID
                case 'V';  V_in_column  = 3;
                case 'N'; YN_in_column = 3;
                case 'E'; XE_in_column = 3;    
            end
        case 'PASI-01'
            switch CH0_ID
                case 'UD'; V_in_column  = 1;
                case 'NS'; YN_in_column = 1;
                case 'EW'; XE_in_column = 1;    
            end
            switch CH1_ID
                case 'UD'; V_in_column  = 2;
                case 'NS'; YN_in_column = 2;
                case 'EW'; XE_in_column = 2;    
            end
            switch CH2_ID
                case 'UD'; V_in_column  = 3;
                case 'NS'; YN_in_column = 3;
                case 'EW'; XE_in_column = 3;    
            end
    end
    
    
%     datafile_separator = '####------------------------';% this is the header/data separator in data files.
% datafile_columns   = [1 3 2];%                  Index of columns must be specified [V  EW  NS]
% fprintf('Columns: V[%d]  EX[%d]  NY[%d]\n',V_in_column,XE_in_column,YN_in_column)
datafile_columns   = [V_in_column XE_in_column, YN_in_column];%                  Index of columns must be specified [V  EW  NS]
end
%% ========================================================================
%% READ THE DATA
%% ========================================================================
if ~isempty(fileformat)
    if(First_line_of_data ~= 0)
        %% DATA.
        % write data on a File and read again
        % fprintf('      Data Evaluation:')
        format long g
        DATA = B(First_line_of_data:size(B,1));%DATA = char(B(First_line_of_data:size(B,1)));
        %DATA = DATA';
        fid=fopen('DATA.tmp','w');
        for ii=1:size(DATA,1)
            fprintf(fid, '%s\n', DATA{ii});
        end
        fclose(fid);
        clear fid DATA count2 %B
        DATA = load('DATA.tmp', '-ascii');
        %% Reorder data!!
        DATA_V_XE_YN = DATA;
        if V_in_column~=1 || XE_in_column~=2 || YN_in_column~=3
            DATA_V_XE_YN(:,1) = DATA(:, V_in_column );% V
            DATA_V_XE_YN(:,2) = DATA(:, XE_in_column );% E
            DATA_V_XE_YN(:,3) = DATA(:, YN_in_column );% N
        end
        
        
        
        
        % fprintf('  ...Done.\n');   
    else
        msg =[ 'Data evaluation is not possible!  '; ...
               'The header/data separator was not '; ...
               'found.                            '; ...
               'Consider to modify the file/header'; ...
               'separator or to set it to "none"  '; ...
               'to load just-numerical data files '; ...
               ];

        msgbox(msg,'Error')
    end
end% fileformat found

end% function