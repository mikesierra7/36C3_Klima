%% Warming  Octave
% Plot of warming stripes for Leipzig and Germany from DWD data. The
% individual location is interpolated in the dataset
clear
% atmospheric data downloaded and processed with load_DWD_grid_data.m
load atmodata_oct
% grid of geographical coordinates to be used instead of Gauss-Krueger
load data/coordlatlon
[m, n, ~]=size(adata);
lat=reshape(clatlon(:,1),m,n);
lon=reshape(clatlon(:,2),m,n);
% Leipzig
pos=[51.3 12.37];
%% Leipzig
% Interpolate from Lat/Lon gridded data
tpos=zeros(size(zp));
% smaller subgrid around pos for interpolation
[ind1 ind2]=find(lat>=pos(1)-0.018 & lat<=pos(1)+0.018);
[ind3 ind4]=find(lon>=pos(2)-0.018 & lon<=pos(2)+0.018);
lai=intersect(ind1,ind3);
loi=intersect(ind2,ind4);
for hi=1:length(zp)
    hh=adata(:,:,hi);
    hh(hh==-999)=NaN;
    tpos(hi,1)=griddata(lat(lai,loi),lon(lai,loi),hh(lai,loi),pos(1),pos(2));
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
patch('Faces',f,'vertices',v,'FaceVertexCData',tpos2,...
    'FaceColor','flat','edgecolor','none');
set(gca,'yticklabel',{[]})
cb=colorbar;
%set(get(cb,'Label'),'string','\delta Temperature / °C')
% cmap1: blue:white:red
% cmap2: hope:white:destruction
load data/cmap1
colormap(cmap);
caxis([-2.5 2.5]);
axis tight
title('warming stripe choosen location');
%% Germany
% whole dataset
mtp=zeros(size(adata,1),size(adata,2));
adata2=zeros(size(adata));
for hi=1:size(adata,1)
    for h2=1:size(adata,2)
        if adata(hi,h2,1)==-999
            mtp(hi,h2)=NaN;
            adata2(hi,h2,:)=NaN;
        else
            mtp(hi,h2)=mean(adata(hi,h2,ind));
            adata2(hi,h2,:)=adata(hi,h2,:)-mtp(hi,h2);            
        end
    end
end
% annual deviation to mean for whole Germany
for hi=1:length(zp)
    hh=adata2(:,:,hi);
    tger(hi,1)=mean(hh(~isnan(hh)));
end
%%
figure('color',[1 1 1],'position',[100 100 1000 800])
subplot(2,1,1);
patch('Faces',f,'vertices',v,'FaceVertexCData',tger,...
    'FaceColor','flat','edgecolor','none');
set(gca,'yticklabel',{[]})
cb=colorbar;
% cmap1: blue:white:red
% cmap2: hope:white:destruction
load data/cmap1
colormap(cmap);
caxis([-2.5 2.5]);
axis tight
subplot(2,1,2)
plot(zp,tger)
axis tight