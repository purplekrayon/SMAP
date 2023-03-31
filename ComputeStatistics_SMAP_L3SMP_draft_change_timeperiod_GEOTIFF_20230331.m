%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Statistics of the SMAP L3SMP_E data at 9 km to be used in NDMC.  %
%                                                                         %
% Date: 04-21-2020                                                       %
% Created by: Narendra N. Das. 
% edited 03-30-2023 by Karyn Tabor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%Declare parameters
G36_R = 406; 
G36_C = 964;
G09_R = 406*4; 
G09_C = 964*4;
%EASEdir='/Users/ktabor/Documents/SMAP/DATA/';

%loading EASE grid lat lon from ascii files here
FP_anci = '/Users/ktabor/Documents/SMAP/DATA/EASE2_M09km.lats.3856x1624x1.double';
fid = fopen(FP_anci, 'r'); 
lat09km = fread(fid, [G09_C G09_R], 'float');
fclose(fid);
lat09km = lat09km';


FP_anci = '/Users/ktabor/Documents/SMAP/DATA/EASE2_M09km.lons.3856x1624x1.double';
fid = fopen(FP_anci, 'r'); 
lon09km = fread(fid, [G09_C G09_R], 'float'); 
fclose(fid);
lon09km = lon09km';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute Average soil moisture for a Week%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: this matlab program expect the SMAP L3SMP_E data is some folder or
%%%% repository

%Get Path to the repository and date that is required to create Average
%Soil moisture for a previous 1 week time.

finput = '/Users/ktabor/Documents/SMAP/DATA/L3/';
%inputdlg(prompt,dlg_title,num_lines, defaultanswer, options);
%set this to the number of characters in the folder path. 
dir_length=size(finput,2);
L3_SM_P_E_fld = finput;
%char(finput(1));

%datenum(datetime('today')) calculates excel time for today

%for d = datenum(datetime('today')) 
%change this for inout data datenum(datetime('30-June-2016'))=736511
%change this for inout data datenum(datetime('25-May-2022'))=738666
d = 738670
%d = d - 1; %L3SMP_E data has latency of 72 hours or 3 days
thedate = datestr(d, 'yyyymmdd');
selday = thedate(7:8);
selmon = thedate(5:6);
selyear = thedate(1:4);
   
% selday = '02'
% selmon = 'Dec'
% selyear = '2016'
%Form date string
t00m_str = [selday '-' selmon '-' selyear];
%Get previous 6 days
t00m = d %datenum(t00m_str);
    
for i=[1:7,8:14,1:30,8:38,1:90,8:98]
    T.(['D', num2str(i)]) = addtodate(t00m, -i, 'day');
    T.(['DS', num2str(i)]) = datestr(T.(['D', num2str(i)]),'yyyymmdd');
    %CRID_ID = '_R17000';changed here!
    CRID_ID = '_R18290';
    S.(['M', num2str(i)]) = 'Soil_Moisture_Retrieval_Data_AM';
    %changed line below to remove the '/' before SMAP_L3_SM_P_E
    L3SMPE.(['F', num2str(i)]) = [L3_SM_P_E_fld  'SMAP_L3_SM_P_E_' T.(['DS', num2str(i)]) CRID_ID '*.h5'];
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START This Week
%%
%Make all NaN arrays to hold the data.  Rows, Columns, Days
SM09_7days = NaN(G09_R, G09_C, 7);
RetF09_7days = NaN(G09_R, G09_C, 7);
LST09_7days = NaN(G09_R, G09_C, 7);
%Read data
for i=[1:7]
    thefile = L3SMPE.(['F', num2str(i)]);
    tt_struct = dir(thefile);
    if(~isempty(tt_struct));
        tt_names = char(tt_struct.name);
        %tt_names = extractfield(tt_struct, 'name');   
        %tt_names = tt_names';
        %tt_names = char(tt_names);
        ffsize = size(tt_names, 1);
        if ffsize > 1
          tt_names = tt_names(ffsize,:);
        end
        %the_L3SMPE_file = [thefile(1:dir_length) tt_names]; had to change from
        %39 to 37 becuase of directory path was smaller
        the_L3SMPE_file = [thefile(1:dir_length) tt_names];
        the_SMRD_str = S.(['M', num2str(i)]);
        [SM_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMPE_file, the_SMRD_str, 'soil_moisture');
        SM09_7days(:,:,i) = SM_temp;
        [Ret_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMPE_file, the_SMRD_str, 'retrieval_qual_flag');
        RetF09_7days(:,:,i) = Ret_temp;
        [LST_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMPE_file, the_SMRD_str, 'surface_temperature');
        LST09_7days(:,:,i) = LST_temp; 
    end
end

SM09_7days(SM09_7days == -9999) = NaN;
%RetF36_7days(SM36_7days == -9999) = NaN;
%RetF36_7days = bitget(RetF36_7days, 1);
%SM36_7days(RetF36_7days > 0) = NaN;
LST09_7days(LST09_7days == -9999) = NaN;

if (1 == 1)
AvgSoilMoisture_1_7 = nanmean(SM09_7days, 3);
AvgLST_1_7 = nanmean(LST09_7days, 3);

% elseif (2 < 2)
% disp('Not enough data to compute weekly average of soil moisture.');
end
%% END This Week
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START Last Week
%Make array to read the data
SM09_8_14days = NaN(G09_R, G09_C, 7);
RetF09_8_14days = NaN(G09_R, G09_C, 7);
LST09_8_14days = NaN(G09_R, G09_C, 7);

%Read data
for i=[8:14]
    thefile = L3SMPE.(['F', num2str(i)]);
    tt_struct = dir(thefile);
    if(~isempty(tt_struct))
        tt_names = char(tt_struct.name);
        ffsize = size(tt_names, 1);
        if ffsize > 1
          tt_names = tt_names(ffsize,:);
        end
        the_L3SMPE_file = [thefile(1:dir_length) tt_names];
        the_SMRD_str = S.(['M', num2str(i)]);
        [SM_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMPE_file, the_SMRD_str, 'soil_moisture');
        SM09_8_14days(:,:,i) = SM_temp;
        [Ret_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMPE_file, the_SMRD_str, 'retrieval_qual_flag');
        RetF09_8_14days(:,:,i) = Ret_temp;
        [LST_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMPE_file, the_SMRD_str, 'surface_temperature');
        LST09_8_14days(:,:,i) = LST_temp; 
    end
end

SM09_8_14days(SM09_8_14days == -9999) = NaN;
LST09_8_14days(LST09_8_14days == -9999) = NaN;

if (1 == 1)
    AvgSoilMoisture_8_14 = nanmean(SM09_8_14days, 3);
    AvgLST_8_14 = nanmean(LST09_8_14days, 3);

% elseif (2 < 2)
% disp('Not enough data to compute weekly average of soil moisture.');
end
%% END Last Week
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START This Month
%Make array to read the data
SM09_1_30days = NaN(G09_R, G09_C, 30);
RetF09_1_30days = NaN(G09_R, G09_C, 30);
LST09_1_30days = NaN(G09_R, G09_C, 30);

%Read data
for i=[1:30]
    thefile = L3SMPE.(['F', num2str(i)]);
    tt_struct = dir(thefile);
    if(~isempty(tt_struct))
        tt_names = char(tt_struct.name);
        ffsize = size(tt_names, 1);
        if ffsize > 1
          tt_names = tt_names(ffsize,:);
        end
        the_L3SMP_file = [thefile(1:dir_length) tt_names];
        the_SMRD_str = S.(['M', num2str(i)]);
        [SM_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'soil_moisture');
        SM09_1_30days(:,:,i) = SM_temp;
        [Ret_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'retrieval_qual_flag');
        RetF09_1_30days(:,:,i) = Ret_temp;
        [LST_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'surface_temperature');
        LST09_1_30days(:,:,i) = LST_temp; 
    end
end    
    
SM09_1_30days(SM09_1_30days == -9999) = NaN;
LST09_1_30days(LST09_1_30days == -9999) = NaN;

if (1 == 1)
    AvgSoilMoisture_1_30 = nanmean(SM09_1_30days, 3);
    AvgLST_1_30 = nanmean(LST09_1_30days, 3);

%elseif (2 < 2)
%disp('Not enough data to compute weekly average of soil moisture.');
end
%END This Month
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%START Last Month
%Make array to read the data
SM09_8_38days = NaN(G09_R, G09_C, 30);
RetF09_8_38days = NaN(G09_R, G09_C, 30);
LST09_8_38days = NaN(G09_R, G09_C, 30);

%Read data
for i=[8:38]
    thefile = L3SMPE.(['F', num2str(i)]);
    tt_struct = dir(thefile);
    if(~isempty(tt_struct))
        tt_names = char(tt_struct.name);
        ffsize = size(tt_names, 1);
        if ffsize > 1
          tt_names = tt_names(ffsize,:);
        end
        the_L3SMP_file = [thefile(1:dir_length) tt_names];
        the_SMRD_str = S.(['M', num2str(i)]);
        [SM_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'soil_moisture');
        SM09_8_38days(:,:,i) = SM_temp;
        [Ret_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'retrieval_qual_flag');
        RetF09_8_38days(:,:,i) = Ret_temp;
        [LST_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'surface_temperature');
        LST09_8_38days(:,:,i) = LST_temp; 
    end
end    

SM09_8_38days(SM09_8_38days == -9999) = NaN;
LST09_8_38days(LST09_8_38days == -9999) = NaN;

if (1 == 1)
    AvgSoilMoisture_8_38 = nanmean(SM09_8_38days, 3);
    AvgLST_8_38 = nanmean(LST09_8_38days, 3);

% elseif (2 < 2)
% disp('Not enough data to compute weekly average of soil moisture.');
end

%% END Last Month
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START This Three Month

%Make array to read the data
SM09_1_90days = NaN(G09_R, G09_C, 90);
RetF09_1_90days = NaN(G09_R, G09_C, 90);
LST09_1_90days = NaN(G09_R, G09_C, 90);

%Read data
for i=[1:90]
    thefile = L3SMPE.(['F', num2str(i)]);
    tt_struct = dir(thefile);
    if(~isempty(tt_struct))
       tt_names = char(tt_struct.name);
       ffsize = size(tt_names, 1);
        if ffsize > 1
          tt_names = tt_names(ffsize,:);
        end
        the_L3SMP_file = [thefile(1:dir_length) tt_names];
        the_SMRD_str = S.(['M', num2str(i)]);
        [SM_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'soil_moisture');
        SM09_1_90days(:,:,i) = SM_temp;
        [Ret_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'retrieval_qual_flag');
        RetF09_1_90days(:,:,i) = Ret_temp;
        [LST_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'surface_temperature');
        LST09_1_90days(:,:,i) = LST_temp; 
    end
end    

SM09_1_90days(SM09_1_90days == -9999) = NaN;
LST09_1_90days(LST09_1_90days == -9999) = NaN;

if (1 == 1)
    AvgSoilMoisture_1_90 = nanmean(SM09_1_90days, 3);
    AvgLST_1_90 = nanmean(LST09_1_90days, 3);

% elseif (2 < 2)
% disp('Not enough data to compute weekly average of soil moisture.');
end

% END This Three Month
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%START Last Three Month

%Make array to read the data
SM09_1_90days = NaN(G09_R, G09_C, 90);
RetF09_1_90days = NaN(G09_R, G09_C, 90);
LST09_1_90days = NaN(G09_R, G09_C, 90);
 
%Read data
for i=[8:98]
    thefile = L3SMPE.(['F', num2str(i)]);
    tt_struct = dir(thefile);
    if(~isempty(tt_struct))
       tt_names = char(tt_struct.name);
       ffsize = size(tt_names, 1);
        if ffsize > 1
          tt_names = tt_names(ffsize,:);
        end
        the_L3SMP_file = [thefile(1:dir_length) tt_names];
        the_SMRD_str = S.(['M', num2str(i)]);
        [SM_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'soil_moisture');
        SM09_8_98days(:,:,i) = SM_temp;
        [Ret_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'retrieval_qual_flag');
        RetF09_8_98days(:,:,i) = Ret_temp;
        [LST_temp, EZ09km_r, EZ09km_c, Comment] = ExtractSMAP_L3PE_Data(the_L3SMP_file, the_SMRD_str, 'surface_temperature');
        LST09_8_98days(:,:,i) = LST_temp; 
    end
end    

SM09_8_98days(SM09_8_98days == -9999) = NaN;
LST09_8_98days(LST09_8_98days == -9999) = NaN;

if (1 == 1)
    AvgSoilMoisture_8_98 = nanmean(SM09_8_98days, 3);
    AvgLST_8_98 = nanmean(LST09_8_98days, 3);

% elseif (2 < 2)
% disp('Not enough data to compute weekly average of soil moisture.');
end

%% END Last Three Month
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Compute Change in Soil Moisture
Diff_Avg_SM_W1_W2 = AvgSoilMoisture_1_7 - AvgSoilMoisture_8_14;
Diff_Avg_SM_TM_LM = AvgSoilMoisture_1_30 - AvgSoilMoisture_8_38;
Diff_Avg_SM_T3_L3 = AvgSoilMoisture_1_90 - AvgSoilMoisture_8_98;

%testing data
ax(1)= axes(figure(1));
ax(2) = axes(figure(2));
ax(3)= axes(figure(3));
imagesc(ax(1),Diff_Avg_SM_W1_W2);
imagesc(ax(2),Diff_Avg_SM_TM_LM);
imagesc(ax(3),Diff_Avg_SM_T3_L3);

PathName = '/Users/ktabor/Documents/SMAP/DATA/Output/' 
currentPathName = [PathName 'current'];
    if not(isfolder([currentPathName]))
        mkdir([currentPathName]);
    end

%char(finput(1));
%FldName = [selyear selmon selday];
%added this here to avoid error when directory already exists
if not(isfolder([PathName thedate]))
    mkdir([PathName thedate]);
end

PathName = [PathName thedate];
header = [G09_C; G09_R; -17367530.4451615; -7314540.8306385500; 9008.05521025; -9999.0]; % absolute lower left header
%header = [G09_C; G09_R; -17363026.417595; -7310036.803035; 9008.05521025; -9999.0]; % lower left center header
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_CurrWeek.tif'],  AvgSoilMoisture_1_7, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_PastWeek.tif'],  AvgSoilMoisture_8_14, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_CurrMonth.tif'],  AvgSoilMoisture_1_30, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_PastMonth.tif'],  AvgSoilMoisture_8_38, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_Curr3Month.tif'],  AvgSoilMoisture_1_90, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_Past3Month.tif'],  AvgSoilMoisture_8_98, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_OneWeek.tif'],  Diff_Avg_SM_W1_W2, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_OneMonth.tif'],  Diff_Avg_SM_TM_LM, header);
SaveGeoTiff(PathName, ['/CompositeSM_' selyear selmon selday '_ThreeMonth.tif'],  Diff_Avg_SM_T3_L3, header);

%% Undated files for Current folder
SaveGeoTiff(currentPathName, '/CompositeSM_current_CurrWeek.tif',  AvgSoilMoisture_1_7, header);
SaveGeoTiff(currentPathName, '/CompositeSM_current_PastWeek.tif', AvgSoilMoisture_8_14, header);
SaveGeoTiff(currentPathName, '/CompositeSM_current_CurrMonth.tif', AvgSoilMoisture_1_30, header);
SaveGeoTiff(currentPathName, '/CompositeSM_current_PastMonth.tif', AvgSoilMoisture_8_38, header);
SaveGeoTiff(currentPathName, '/CompositeSM_current_Curr3Month.tif', AvgSoilMoisture_1_90, header);
SaveGeoTiff(currentPathName, '/CompositeSM_current_Past3Month.tif', AvgSoilMoisture_8_98, header);
SaveGeoTiff(currentPathName, '/ChangeSM_current_OneWeek.tif', Diff_Avg_SM_W1_W2, header);
SaveGeoTiff(currentPathName, '/ChangeSM_current_OneMonth.tif', Diff_Avg_SM_TM_LM, header);
SaveGeoTiff(currentPathName, '/ChangeSM_current_ThreeMonth.tif', Diff_Avg_SM_T3_L3, header);
