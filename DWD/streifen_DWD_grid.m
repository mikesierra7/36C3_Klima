%% Warming Stripes
% Plot of warming stripes for Leipzig and Germany from DWD data. The
% individual location is interpolated in the dataset
clearvars
addpath data
% atmospheric data downloaded and processed with load_DWD_grid_data.m
load atmodata
% grid of geographical coordinates to be used instead of Gauß-Krueger
load coordlatlon
[m, n, ~]=size(adata);
lat=reshape(clatlon(:,1),m,n);
lon=reshape(clatlon(:,2),m,n);
% Leipzig
pos=[51.3 12.37];
%% Plot Location and first dataset
worldmap('Germany');
geoshow('landareas.shp','FaceColor','none')
geoshow(lat,lon,adata(:,:,1),'displaytype','surface')
geoshow(pos(1),pos(2),'displaytype','point')
%% Leipzig
% Interpolate from Lat/Lon gridded data
tpos=zeros(size(zp));
hlat=lat(:);
hlon=lon(:);
parfor hi=1:length(zp)
    hh=adata(:,:,hi);
    ff=scatteredInterpolant(hlat,hlon,hh(:));
    tpos(hi,1)=ff(pos(1),pos(2));
end
% Mean 1961-1990
ind=find(zp>1960 & zp<1991);
tpos2=tpos-mean(tpos(ind));
figure
plot(zp,tpos2);
%% Vertices and Faces
% for patch plot of stripes
v=[];
f=[];
for hi=1:length(zp)
    v=[v; zp(hi) 0; zp(hi)+1 0; zp(hi)+1 1; zp(hi) 1];
    f=[f; [1 2 3 4]+(hi-1)*4 ];
end
%% Colors
% Colormap 2 in 36C3 design
% Destruction: 254 80 0
%        Hope:  0 187 49
figure('color',[1 1 1],'position',[100 100 1000 300])
ax=gca;
ax.FontSize=14;
patch('Faces',f,'vertices',v,'FaceVertexCData',tpos2,...
    'FaceColor','flat','edgecolor','none');
set(gca,'yticklabel',{[]})
cb=colorbar;
set(get(cb,'Label'),'string','\delta Temperature / °C')
% cmap1: blue:white:red
% cmap2: hope:white:destruction
load cmap1
colormap(cmap);
caxis([-2.5 2.5]);
axis tight
%% Germany
% whole dataset
mtp=zeros(size(adata,1),size(adata,2));
adata2=zeros(size(adata));
for hi=1:size(adata,1)
    for h2=1:size(adata,2)
        if isnan(adata(hi,h2,1))
            mtp(hi,h2)=NaN;
            adata2(hi,h2,:)=NaN;
        else
            mtp(hi,h2)=mean(adata(hi,h2,ind));
            adata2(hi,h2,:)=adata(hi,h2,:)-mtp(hi,h2);
        end
    end
end
tger=mean(mean(adata2,'omitnan'),'omitnan');
tger=permute(tger,[3 1 2]);
%%
figure('color',[1 1 1],'position',[100 100 1000 800])
ax=gca;
ax.FontSize=14;
subplot(2,1,1);
patch('Faces',f,'vertices',v,'FaceVertexCData',tger,...
    'FaceColor','flat','edgecolor','none');
set(gca,'yticklabel',{[]})
cb=colorbar;
set(get(cb,'Label'),'string','\delta Temperature / °C')
% cmap1: blue:white:red
% cmap2: hope:white:destruction
load cmap1
colormap(cmap);
caxis([-2.5 2.5]);
axis tight
subplot(2,1,2)
plot(zp,tger)
axis tight