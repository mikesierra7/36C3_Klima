%% load data from DWD Octave Version
% - grided data is downloaded in zipped files from opendata.dwd.de
% - zipped files are unzipped in a seperate directory for ascii files and
% - ascii files are converted and saved in the MATLAB binary format to be
%   used in other scripts
#
# Ocatve:
# - requires mapping package for rasterread
clear
% url and folder on server
furl='opendata.dwd.de';
% gridded temperature in 2m height
% read the metadata! Temperature is saved as integer!
df='/climate_environment/CDC/grids_germany/annual/air_temperature_mean/';
% folder to save unzipped ascii files
ofolder='data_asc/';
ts=ftp(furl);
cd(ts,df);
mget(ts,'*.asc.gz','data');
files=dir('data/*.gz');
close(ts)
%% unzip downloaded files
for hi=1:size(files,1)
    gunzip(['data/' files(hi).name],ofolder);
end
%% convert asc files to mat
dfiles=dir([ofolder 'grids*.asc']);
adata=zeros(866,654,size(dfiles,1));
zp=zeros(size(dfiles,1),1);
for hi=1:size(dfiles,1)
    [td, gd]=rasterread([ofolder dfiles(hi).name]);
    td.data(td.data>-999)=td.data(td.data>-999)/10;
    zp(hi,1)=str2double(char(regexp(dfiles(hi).name,'\d{4}','match')));
    adata(:,:,hi)=td.data; % convert from integer to °C
    % ocatve mapping toolbox data
    otd{hi}=td;
end
save -mat7-binary atmodata_oct.mat adata zp otd gd
