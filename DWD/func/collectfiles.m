function files=collectfiles(fdir)

af=dir(fdir);
files=struct('folder',{},'name',{});
cc=0;
for hi=3:size(af,1)
    if af(hi).isdir
        sdir=[af(hi).folder '\' af(hi).name];
        files=[files; collectfiles(sdir)];
    elseif strncmp(af(hi).name(end-2:end),'.gz',3)
        cc=cc+1;
        files(cc,1).folder=af(hi).folder;
        files(cc,1).name  =af(hi).name;
    end
end