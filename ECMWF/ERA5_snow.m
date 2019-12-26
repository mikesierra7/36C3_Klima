%% ECMWF datafile access
% example for access of data in a netCDF file and interpolation of a single coordinate.
clearvars
% Leipzig
pos=[51.3 12.37];
%% Datafile downloaded with ERA5_snow.py
dfile='ERA5_snow_monthly025.nc';
ncdisp(dfile)
% Latitude and longitude from the datafile
lat=ncread(dfile,'latitude');
lon=ncread(dfile,'longitude');
% grid for plots withe geoshow
[glat,glon]=meshgrid(lat,lon);
% time from datafile converted to MATLAB datenum format
hzp=ncread(dfile,'time');
hzp=cast(hzp,'double')/24+datenum('1900/01/01 00:00:00');
%% Interpolation
% temp=ncread(dfile,'t2m_0001',[1 1 1],[inf inf 1]);
hh=figure('color',[1 1 1 ],'position',[100 100 600 1200]);
wm=worldmap(double([min(lat) max(lat)]),double([min(lon) max(lon)]));
cb=colorbar;
caxis([0 13]);
set(get(cb,'Label'),'string','Snow fall / mm water equiv.')
data=zeros(length(hzp),4);
for hi=1:length(hzp)
    d1=ncread(dfile,'t2m_0001',[1 1 hi],[inf inf 1])-278.5651;
    temp=interp2(glat,glon,d1,pos(1),pos(2));
    d2=ncread(dfile,'sd_0001',[1 1 hi],[inf inf 1]);
    sd=interp2(glat,glon,d2,pos(1),pos(2));
    d3=ncread(dfile,'sf_0001',[1 1 hi],[inf inf 1]);
    sf=interp2(glat,glon,d3,pos(1),pos(2));
    data(hi,:)=[hzp(hi) temp sd sf];
    % Plot
    hg=geoshow(glat,glon,d3(:,:)*1000,'displaytype','surface');
    title(['\fontsize{20}{' datestr(hzp(hi),'mm/yyyy') '}']);
    drawnow
    delete(hg)
end
%% Plot of data
% interpolated for given coordinate
figure
subplot(3,1,1)
title('temperature');
plot(data(:,1),data(:,2))
ylabel('°C');
datetick
subplot(3,1,2)
title('snow depth in m of water equivalent');
plot(data(:,1),data(:,3))
ylabel('m');
datetick
subplot(3,1,3)
title('snow fall in mm of water equivalent');
plot(data(:,1),data(:,4)*1000)
ylabel('mm');

datetick
