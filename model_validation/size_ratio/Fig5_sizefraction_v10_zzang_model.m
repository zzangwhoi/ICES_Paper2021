% Calculate bimonthly climatology of the ocean results 
% 


%%
clear all
%close all
%%
clc
load('./FVCOM_bimonthly_1978t1988_0t10m_v10_benchmark_noPbury_bm.mat')
gridnc = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/gom3_gridinfo.nc';
siglev = ncread(gridnc,'siglev');
siglay = ncread(gridnc,'siglay');
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_grid.mat')

x_gom3 = mGRID.x;
y_gom3 = mGRID.y;
h_gom3 = mGRID.h;
lon_gom3 = mGRID.lon;
lat_gom3 = mGRID.lat;
%% load mesh
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/mesh.mat')

xc_gom3 = mesh.uvnode(:,1);
yc_gom3 = mesh.uvnode(:,2);

[lonc_gom3,latc_gom3] = sp_proj('1802','inverse',xc_gom3,yc_gom3,'m');
hc_gom3 = mesh.uvdepth;

TriNodes = mesh.trinodes;
%NodeZ    = [zeros(M,1),mesh.nodez'];
levels  = 46;
layers  = 45;

nodes = length(h_gom3);
NodeX = nan(size(siglev));
NodeY = nan(size(siglev));
NodeZ = nan(size(siglev));

for n = 1 : nodes
   NodeZ(n,:) = squeeze(h_gom3(n))*siglev(n,:); 
    
end

for lv = 1 : levels
    NodeX(:,lv) = x_gom3;
    NodeY(:,lv) = y_gom3;
end
%%
Lon_Min = floor(min(lon_gom3))-1;
Lon_Max = ceil(max(lon_gom3))+1;
Lat_Min = floor(min(lat_gom3))-1;
Lat_Max = ceil(max(lat_gom3))+1;

load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_coast.mat'
load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/xy_coastline.mat'
%%
% ETOPO-1 bathymetry
file = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/etopo1_NEshelf.nc';
[LAT,LON] = meshgrid(ncread(file,'lat'),ncread(file,'lon'));
z = double(ncread(file,'Band1'));

CMTS_LonLat = [-69-30.1/60, 43+44.8/60]; % Coastal Maine Time Series Station
WBTS_LonLat = [-69-51.8/60, 42+51.7/60]; % Wilkinson Basin Station

bathy = z;
bathy(z>0) = -3.2;
bathy(z<=0) = nan;

indshelfgrid = find(h_gom3 <= 1000);  
nnodes = length(indshelfgrid);

 %% all this are done under /vortexfs1/share/jilab/Project_Scallop/NPZD_runs/annual_run_v10_benchmark/mb_code_prepro/SP_LP_ratio on poseidon
%%
%}

color_b(1:26)=1;
color_b(27:51)=0.98:-0.04:0;

color_r(1:26)=0:0.04:1;
color_r(27:51)=1;

color_g(1:26)=0:0.04:1;
color_g(27:51)=0.98:-0.04:0;

MAP=[color_r',color_g',color_b'];


%% Bimonthly size ratio
for month = 1 : 6
    
    row = ceil(month/3);
    column = month - (row-1)*3; 
    
 subplot('Position',[0.1+0.29*(column-1) 0.82-row*0.35 0.27 0.3])
    plot(GOM3_coast(:,1),GOM3_coast(:,2),'k-','linewidth',1)
    hold on
    pcolor(LON,LAT,bathy); shading flat; hold on
    caxis([-10 0])
    colormap gray
    freezeColors

    scatter(lon_gom3(indshelfgrid),lat_gom3(indshelfgrid),2,100*squeeze(Ratio_bimonthly(indshelfgrid,month)),'.')
    caxis([0 100])
%    cptcmap('GMT_polar','ncol',10);
colormap(MAP)
    shading flat
    axis([-76 -63 35 46])
    set(gca,'fontsize',14)
    set(gca,'xtick',-75:5:-65)
    set(gca,'ytick',35:5:45)
    switch month
        case 1
           text(-75.8,45,'(a) Jan-Feb','fontsize',16)
        case 2
           text(-75.8,45,'(b) Mar-Apr','fontsize',16)
        case 3
           text(-75.8,45,'(c) May-Jun','fontsize',16)
        case 4
           text(-75.8,45,'(d) Jul-Aug','fontsize',16)
        case 5
           text(-75.8,45,'(e) Sep-Oct','fontsize',16)
        case 6
           text(-75.8,45,'(f) Nov-Dec','fontsize',16)
    end
    set(gca,'fontsize',14)
    set(gca,'xtick',-75:5:-65)
    set(gca,'ytick',35:5:45)
    
    if row == 2
        set(gca,'xticklabel',{'75^{o}W','70^{o}W','65^{o}W'})
    else
        set(gca,'xticklabel',[])
    end

    if column == 1
        set(gca,'yticklabel',{'35^{o}N','40^{o}N','45^{o}N'})
    else
        set(gca,'yticklabel',[])
    end    
end

subplot('Position',[0.1 0.82 0.8 0.3])
 pcolor(ones(3,3),ones(3,3),nan(3,3))
% cptcmap('GMT_polar','ncol',10);
colormap(MAP)
 caxis([0 100])
 colorbar('Location','SouthOutside','Ticks',[0 20 50 80 100],'TickLabels',{'100%','Small P dominate','50%','Large P dominate','100%'},'fontsize',14)
 set(gca,'ytick',[],'xtick',[],'xcolor','none','ycolor','none')
 annotation('textbox',[0.2 0.87 0.9 0.1],'String','Modeled bimonthly size composition (1978-1988)','edgecolor','none','fontsize',16);


saveas(gcf,'FVCOM_Bimonthly_SizeCompose_1978t1988_v10_noPbury2.png')
