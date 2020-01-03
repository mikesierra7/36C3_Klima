%% Animation GRID
% animate gridded data with mean temperature (1960-1990) calculated for each grid
% cell individualy and subtracted from the time series of each grid cell
clear
% atmospheric data downloaded and processed with load_DWD_grid_data_oct.m
load atmodata_oct
% grid of geographical coordinates to be used instead of Gauss-Krueger
load data/coordlatlon
[m, n, ~]=size(adata);
lat=reshape(clatlon(:,1),m,n);
lon=reshape(clatlon(:,2),m,n);
%% Germany
% whole dataset
mtp=zeros(size(adata,1),size(adata,2));
adata2=zeros(size(adata));
otd2=otd;
% Mean 1961-1990
ind=find(zp>1960 & zp<1991);
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
%% iterate over all years
% plot each year 
hh=figure('color',[1 1 1],'position',[100 100 600 1200]);
load data/cmap3
for hi=1:length(zp)
    hda=adata2(:,:,hi);
    hg=mesh(lon',lat',fliplr(hda'));
    view(2)
    cb=colorbar;
    colormap(cmap)
    caxis([-3 4.5])
    title(['\fontsize{20}{' num2str(zp(hi,1)) '}']);
    drawnow
    pause(0.1)
    delete(hg)    
end