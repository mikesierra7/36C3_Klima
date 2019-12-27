%% Animation GRID
% animate gridded data and save as animated gif
clearvars
addpath data
% atmospheric data downloaded and processed with load_DWD_grid_data.m
load atmodata
% grid of geographical coordinates to be used instead of Gauß-Krueger
load coordlatlon
[m, n, ~]=size(adata);
lat=reshape(clatlon(:,1),m,n);
lon=reshape(clatlon(:,2),m,n);
%% Germany
% whole dataset
mtp=zeros(size(adata,1),size(adata,2));
adata2=zeros(size(adata));
% Mean 1961-1990
ind=find(zp>1960 & zp<1991);
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
%% iterate over all years
% plot each year and save to single gif files
% figure is black with all grids and annotations removed
hh=figure('color',[0 0 0 ],'position',[100 100 600 1200]);
wm=worldmap([47 55.5],[5.8 15.5]);
setm(wm,'grid','off','frame','off');
set(findall(wm,'Tag','PLabel'),'visible','off')
set(findall(wm,'Tag','MLabel'),'visible','off')
% worldmap('germany')
load cmap3
filename='aniDWD.gif';
capturegif=true;
for hi=1:length(zp)
    hg=geoshow(lat,lon,adata2(:,:,hi),'displaytype','surface');
%     cb=colorbar;
%     set(get(cb,'Label'),'string','\delta Temperature / °C')
    colormap(cmap)
    caxis([-3 4.5])
    title(['\fontsize{20}{\color{white}' num2str(zp(hi,1)) '}']);
    drawnow
    if capturegif
        % Capture the plot as an image
        frame = getframe(hh);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        % Write to the GIF File
        if hi == 1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
    end
    delete(hg)    
end