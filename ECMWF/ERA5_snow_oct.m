%% ECMWF datafile access for Octave
% requires NetCDF package: https://octave.sourceforge.io/netcdf/index.html 
% example for access of data in a netCDF file and interpolation of a single coordinate.
% t2m: air temperature in 2m height
% sd: snow depth expressed as a water layer covering the grid cell
% sf: snowfall expressed as a water layer
clear
% Leipzig
pos=[51.3 12.37];
% plot all months
plotmonths=true;
%% Datafile downloaded with ERA5_snow.py
dfile='ERA5_snow_monthly025.nc';
%ncdisp(dfile)
% Latitude and longitude from the datafile
lat=ncread(dfile,'latitude');
lon=ncread(dfile,'longitude');
% grid for plots withe geoshow
[glat,glon]=meshgrid(lat,lon);
% time from datafile converted to MATLAB datenum format
hzp=ncread(dfile,'time');
hzp=cast(hzp,'double')/24+datenum('1900/01/01 00:00:00','yyyy/mm/dd HH:MM:SS');
%% Interpolation
if plotmonths
    hh=figure('color',[1 1 1 ],'position',[100 100 600 1200]);
end
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
    if plotmonths
        hg=surf(glat,glon,d3(:,:)*1000);
        title(['\fontsize{20}{' datestr(hzp(hi),'mm/yyyy') '}']);
        view(2);
        cb=colorbar;
        caxis([0 13]);
        drawnow
        pause(0.25)
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
plot(data(:,1),data(:,3));
ylabel('m');
datetick
title('snow depth in m of water equivalent');
subplot(3,1,3)
plot(data(:,1),data(:,4)*1000)
ylabel('mm');
datetick
title('snow fall in mm of water equivalent');
