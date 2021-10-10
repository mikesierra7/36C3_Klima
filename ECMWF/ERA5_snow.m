%% ECMWF datafile access
% example for access of data in a netCDF file and interpolation of a single coordinate.
% t2m: air temperature in 2m height
% sd: snow depth expressed as a water layer covering the grid cell
% sf: snowfall expressed as a water layer
clearvars
% Leipzig
pos=[51.3 12.37];
% plot all months
plotmonths=false;
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
if plotmonths
    hh=figure('color',[1 1 1 ],'position',[100 100 600 1200]);
    wm=worldmap(double([min(lat) max(lat)]),double([min(lon) max(lon)]));
    cb=colorbar;
    caxis([0 13]);
    set(get(cb,'Label'),'string','Snow fall / mm water equiv.')
end
data=zeros(length(hzp),4);
expver=1; % new dimension in ERA5 Data 
% see https://confluence.ecmwf.int/pages/viewpage.action?pageId=173385064
for hi=1:length(hzp)
    d1=ncread(dfile,'t2m',[1 1 expver hi],[inf inf 1 1])-278.5651;
    if isnan(d1(1,1))
        expver=2;
        d1=ncread(dfile,'t2m',[1 1 expver hi],[inf inf 1 1])-278.5651;
    end
    temp=interp2(glat,glon,d1,pos(1),pos(2));
    d2=ncread(dfile,'sd',[1 1 expver hi],[inf inf 1 1]);
    sd=interp2(glat,glon,d2,pos(1),pos(2));
    d3=ncread(dfile,'sf',[1 1 expver hi],[inf inf 1 1]);
    sf=interp2(glat,glon,d3,pos(1),pos(2));
    data(hi,:)=[hzp(hi) temp sd sf];
    % Plot
    if plotmonths
        hg=geoshow(glat,glon,d3(:,:)*1000,'displaytype','surface');
        title(['\fontsize{20}{' datestr(hzp(hi),'mm/yyyy') '}']);
        drawnow
        delete(hg)
    end
end
%% Plot of data
% interpolated for given coordinate
figure('color',[1 1 1],'position',[100 100 600 1000])
subplot(3,1,1)
plot(data(:,1),data(:,2))
ylabel('°C');
datetick
title('mean air temperature in 2m');
subplot(3,1,2)
plot(data(:,1),data(:,3))
ylabel('m');
datetick
title('snow depth in m of water equivalent');
subplot(3,1,3)
plot(data(:,1),data(:,4)*1000)
ylabel('mm');
datetick
title('snow fall in mm of water equivalent');