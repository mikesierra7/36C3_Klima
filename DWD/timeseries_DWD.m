%% DWD Data
% data directory: https://opendata.dwd.de/climate_environment/CDC/
%                         observations_germany/climate/hourly/
%                         air_temperature/historical/
% load Potsdam time series and description of all stations
% to download different station, look up filename
clearvars
addpath data func
% reload time series yes/no
%   false: preloaded data will be used
%   true : data for Potsdam will be retrieved
reloaddata=true;
sl='TU_Stundenwerte_Beschreibung_Stationen.txt';
websave(['data/' sl],'https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/air_temperature/historical/TU_Stundenwerte_Beschreibung_Stationen.txt');
%% List of Stations
% generate some statistics and map of stations
% 1. Stations_id 
% 2. von_datum 
% 3. bis_datum 
% 4. Stationshoehe
% 5. geoBreite 
% 6. geoLaenge
% 7. Stationsname
% 8. Bundesland
fid=fopen(sl);
stc=textscan(fid,'%5s %8s %8s %15f %12f %10f %36c %*98c','headerlines',2);
anzeit=datenum(stc{2},'yyyymmdd');
enzeit=datenum(stc{3},'yyyymmdd');
fclose(fid);
dt=(enzeit-anzeit)/365.25;
[ml, mi]=max(dt);
ind=find(enzeit>datenum([2019 12 1]));
%% Histogram
% length of time series and stations
figure('color',[1 1 1])
hist(dt,29);
title(['Anzahl Zeitreihen: ' num2str(size(dt,1))])
ylabel('Anzahl')
xlabel('Dauer / Jahre');
axis tight
ax=gca;
ax.FontSize=14;
%% Map of stations
lat=stc{5};
lon=stc{6};
worldmap([47 55.5],[5.8 15.5]);
geoshow('landareas.shp','FaceColor',[0.85 0.85 0.85]);
geoshow(lat(ind),lon(ind),'displaytype','point','Marker', '.', 'Color', 'red')
geoshow('worldrivers.shp', 'Color', 'blue')
setm(gca,'ffacecolor','blue')
ax=gca;
ax.FontSize=14;
%% Potsdam timeseries
% longest record available
% The filename changes annually because the name includes the end of the
% timeseries, which is always last year (e.g. 20201231) 
if reloaddata
    df='produkt_tu_stunde_18930101_20211231_03987';
    websave(['data/' df '.zip'],'https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/air_temperature/historical/stundenwerte_TU_03987_18930101_20211231_hist.zip');
    unzip(['data/' df '.zip'],'data_single');
    fid=fopen(['data_single/' df '.txt']);
    hd=textscan(fid,'%*s %s %*d %f %f %*s','headerlines',1,'delimiter',';');
    fclose(fid);
    zp=datetime(hd{1},'inputformat','yyyyMMddHH');
    zp=datenum(zp);
    tt=hd{2};
    save data/potsdamzeit tt zp
else
    load data/potsdamzeit.mat
end
%% Daily mean values
c=0;
czp=1;
mw=zeros(length(unique(floor(zp))),2);
while czp<length(zp)
    c=c+1;
    ind=find(floor(zp)==floor(zp(czp)));
    mw(c,:)=[floor(zp(czp))+0.5 mean(tt(ind))];
    czp=ind(end)+1;
end
%% Plot timeseries
% hourly and daily averages
figure
plot(zp,tt,mw(:,1),mw(:,2),'+')
hold on
datetick
%% Monthly mean values
zp2=datevec(zp);
c=0;
czp=1;
while czp<length(zp)
    c=c+1;
    ind=find((zp2(:,1)==zp2(czp,1) & zp2(:,2)==zp2(czp,2)));
    mmw(c,:)=[mean(zp(ind)) mean(tt(ind)) ];
    czp=ind(end)+1;
end
%% Annual mean value
c=0;
czp=1;
while czp<length(zp)
    c=c+1;
    ind=find(zp2(:,1)==zp2(czp,1));
    ymw(c,:)=[mean(zp(ind)) mean(tt(ind)) ];
    czp=ind(end)+1;
end
%% Plot mean value
% monthly and annual mean values
figure('color',[1 1 1],'position',[100 100 900 500])
p1=plot(mmw(:,1),mmw(:,2),'linewidth',1.2);
axis tight
datetick
grid on
ax=gca;
ax.FontSize=14;
title('monthly average');
ylabel('Temperatur / °C');
saveas(gcf,'pots_monat.png')
hold on
title('annual average');
set(p1,'color',[0.6 0.6 0.6])
plot(ymw(:,1),ymw(:,2),'linewidth',2);
saveas(gcf,'pots_jahr.png')
%% Warming stripe
% plottet from annual mean values
ind=find(ymw(:,1)>datenum([1960 1 1]) & ymw(:,1)<datenum([1990 1 1]));
% mean annual value 1960-1990 reference epoch
ymw1=mean(ymw(ind,2));
ymws=ymw(:,2)-ymw1;
zp=datevec(ymw(:,1));
zp=zp(:,1);
% Vertices and Faces for patch plot
v=[];
f=[];
for hi=1:length(zp)
    v=[v; zp(hi) 0; zp(hi)+1 0; zp(hi)+1 1; zp(hi) 1];
    f=[f; [1 2 3 4]+(hi-1)*4 ];
end
% plot (annual averages) - (mean value)
zp2=ymw(:,1)/365.25;
figure('color',[1 1 1],'position',[100 100 900 500])
subplot(2,1,1)
p1=plot(zp2,ymws,'linewidth',2);
% axis tight
ylim([-2.5 2.5]);
% datetick
grid on
ax=gca;
ax.FontSize=14;
ylabel('\delta°C');
xlim([1893 2019]);
subplot(2,1,2)

patch('Faces',f,'vertices',v,'FaceVertexCData',ymws,...
    'FaceColor','flat','edgecolor','none');
set(gca,'yticklabel',{[]})
load cmap1
colormap(cmap);
caxis([-2.5 2.5]);
axis tight
ax=gca;
ax.FontSize=14;
%% warming stripes standalone plot
figure('color',[1 1 1],'position',[100 100 1000 300])

patch('Faces',f,'vertices',v,'FaceVertexCData',ymws,...
    'FaceColor','flat','edgecolor','none');
set(gca,'yticklabel',{[]})
cb=colorbar;
set(get(cb,'Label'),'string','\delta Temperature / °C')
% cmap1: blue:red:white
% cmap2: hope:white: destruction
load cmap1
colormap(cmap);
caxis([-2.5 2.5]);
axis tight
ax=gca;
ax.FontSize=14;
saveas(gcf,'pots_streifen.png')