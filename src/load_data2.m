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
function [DDAT,SURVEYS] = load_data2(working_folder,SURVEYS, datafile_columns,datafile_separator)

%% Load Input FILES
N      = size(SURVEYS,1);
DDAT= cell(N, 3);% [three components VEN]

fprintf('[Loading Field Data]\n');

fprintf('[THIS MAY TAKE A WHILE]\n');
fileformats =cell(N,1);
for id = 1:N 
    FileNameData = SURVEYS{id,2};%                                         get filename for field data
    FileNamePath = strcat(working_folder, FileNameData);%                  complete path
    fprintf('[%d]:Loading: %s ...',id,FileNameData)
    [fileformat, temp_Fs, temp_DATA, temp_datafile_columns, temp_datafile_separator] = Pfiles__Microtremor_File_Recognition(FileNamePath);
    if ~isempty(fileformat)% KNOWN FILE-FORMAT
        Fs = temp_Fs;
        datafile_columns = temp_datafile_columns;
        datafile_separator = temp_datafile_separator;
        %
        DDAT{id,1} = temp_DATA(:,1);% V
        DDAT{id,2} = temp_DATA(:,2);% E
        DDAT{id,3} = temp_DATA(:,3);% N
        
        %% READ DATA PART 
        VV = temp_DATA(:,1);% V
        EE = temp_DATA(:,2);% E
        NN = temp_DATA(:,3);% N
        %
        SURVEYS{id,3}=Fs;%  sampling frequence from file
        % >> datafile_columns WAS UPDATED
        % >> datafile_separator WAS UPDATED
        fileformats{id,1}=fileformat;
    end
    %% ALL OTHER FILES
    if isempty(fileformat)% fileformat not recognized
        if size(SURVEYS,2)>2% check if User specified the sampling frequency
            if ~isempty(SURVEYS{id,3})
            
                if(strcmp(datafile_separator,'none'))
                    fprintf('    No header/data separator selected \n'); 
                else
                    fprintf('    Header/data separator: %s\n',datafile_separator);
                end
                fprintf('    microtremor expected in column:\n');
                fprintf('    Vertical:  column [%d]\n',datafile_columns(1)); 
                fprintf('    E-W:       column [%d]\n',datafile_columns(2));
                fprintf('    N-S:       column [%d]\n',datafile_columns(3));
                %% data separator is not set
                if(strcmp(datafile_separator,'none'))
                    fileformats{id}='Manual mode Generic File, NO HEADER';
                    % fprintf('id[%d] %s.\n',id,FileNameData);
                    DATA = load(strcat(working_folder, FileNameData),'-ascii');
                end
                %% data separator is set
                if(~strcmp(datafile_separator,'none'))
                    fileformats{id}='Esotic Format';
                    EOHind = 0;

                    fid=fopen(FileNamePath,'r');
                    % fprintf('fid:[%d] load: %s\n',fid,FileNamePath)
                    % B = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');%% B contains all the contents of the opened file.
                    B = textscan(fid, '%s', 'delimiter', '\n');%% B contains all the contents of the opened file.
                    fclose(fid);
                    clear fid

                    %% HEADER.
                    % fprintf('id[%d] %s.\n',id,FileNameData);
                    % fprintf('      Header Evaluation:');
                    B=B{1,1};
                    for i = 1:size(B,1)
                        % Finding a corrispondence in header
                        % HD = separation between header and data
                        %fprintf('line[%d]  %s\n',i,B{i,1})
                        Ref_SHD = strcmp(B{i,1},datafile_separator);
                        if Ref_SHD==1
                            EOHind=i;  %%index of header end in matrix of cells "b".
                        end
                    end
                    % fprintf('  ...Done.\n');

                    if(EOHind ~= 0)
                      %% DATA.
                        % write data on a File and read again
                        % fprintf('      Data Evaluation:')
                        format long g
                        DATA = char(B(EOHind+1:size(B,1)));
                        DATA = DATA';
                        fid=fopen('DATA.mat','w');
                        for i=1:size(DATA,2)
                            fprintf(fid, '%s\n', DATA(:,i));
                        end
                        fclose(fid);
                        clear fid DATA count2 %B
                        load DATA.mat -ascii
                        % fprintf('  ...Done.\n');   
                    else
                        fileformats{id}='ERROR!!!';
                        msg =[ 'Data evaluation is not possible!  '; ...
                               'The header/data separator was not '; ...
                               'found.                            '; ...
                               'Consider to modify the file/header'; ...
                               'separator or to set it to "none"  '; ...
                               'to load just-numerical data files '; ...
                               ];

                        msgbox(msg,'Error')
                    end
                end% read file mode

                %% READ DATA PART 
                VV = DATA(:,datafile_columns(1));% V
                EE = DATA(:,datafile_columns(2));% E
                NN = DATA(:,datafile_columns(3));% N
             
            else
                errortext = sprintf('MESSAGE FROM THE DEVELOPER:\nUNSPECIFIED SAMPLING FREQUENCY for file [%s].\n You MUST specify the sampling frequency (Column 3 of the SURVEY variable).\n Check OpenHVSR-ProTO user manual about how to properly format the project-file.',SURVEYS{id,2});
                error(errortext);
            end
        else
            errortext = sprintf('MESSAGE FROM THE DEVELOPER:\nUNSPECIFIED SAMPLING FREQUENCY.\nYou MUST specify the sampling frequency (Column 3 of the SURVEY variable).\n Check OpenHVSR-ProTO user manual about how to properly format the project-file.');
            error(errortext);
        end
    end% fileformat not recognized 
    %% ROTATION
    if ~isempty(VV) && ~isempty(EE) && ~isempty(NN)
        if size(SURVEYS,2)>3% rotation is defined
            if ~isempty(SURVEYS{id,4})% entry to rotate this file
                %    [ cos   -sin]
                % R =[ sin    cos] positive angle leads to counterclockwise rotation 
                %   
                % [u' v'] = [ cos u + sin v] 
                %           [-sin u + cos v]
                %
                thg = SURVEYS{id,4};
                th = pi*thg/180;% radians
                EEr = cos(th).*EE - sin(th).*NN;
                EE  = EEr;
                NNr = sin(th).*EE + cos(th).*NN;
                NN  = NNr; 
                fprintf('\n     Rotation performed: %3.3f degrees\n',thg)
            end
        end
        DDAT{id,1} = VV;
        DDAT{id,2} = EE;
        DDAT{id,3} = NN;
    end
    fprintf('[DONE]\n')
    fprintf('\n')
end

fprintf('[FILES PROPERTIES (formats):]\n');
for id = 1:N
    fprintf('[%d] %s\n',id,fileformats{id})
end

if exist('DATA.mat','file')==2
    delete('DATA.mat')
end
fprintf('[Loading Done]\n');
end%function