%% unzip grid files
clearvars
addpath func\
%%
tt=dir;
cf=tt.folder;
for hi=3:size(tt,1)
    if tt(hi).isdir & ~strncmp(tt(hi).name,'func',4)
        fdir=[tt(hi).folder '\' tt(hi).name];
        files=collectfiles(fdir);
        outdir=[cf '\' tt(hi).name '_all'];
        for h2=1:size(files,1)
            gunzip([files(h2).folder '\' files(h2).name],outdir);
        end
    end
end