% Figure X: 
% Generate biSeasonal climatology using MARMAP Chlorophyll-a data 
% Variables: TOTAL_CHL, NET_CHL, and NANO_CHL 
% Data file is provided by Dr. Kim Hyde (NOAA) 
%
% Zhixuan Feng
% 12-10-2019

clear all
close all
%%
clc
raw_data = importdata('../benchmark_noPbury/MARMAP-SIZE_FRACTION-CHL-PROFILES-SORTED.xlsx');
load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_coast.mat'

% ETOPO-1 bathymetry
file = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/etopo1_NEshelf.nc';
[LATT,LONN] = meshgrid(ncread(file,'lat'),ncread(file,'lon'));
z = double(ncread(file,'Band1'));

bathy = z;
bathy(z>0) = -3.2;
bathy(z<=0) = nan;
%%
Cruise  = raw_data.textdata(2:end,1);
Station = raw_data.data(:,1);
Month   = raw_data.data(:,2);
Day     = raw_data.data(:,3);
Year    = raw_data.data(:,4)+1900;
Hour    = raw_data.data(:,5);
Min     = raw_data.data(:,6);
Time    = datenum(Year,Month,Day,Hour,Min,0);

LatNum  = raw_data.data(:,7);
LatNum(LatNum<0) = nan;
Lat0    = floor(LatNum/100);
Lat     = Lat0+(LatNum-Lat0*100)/60;
LonNum  = raw_data.data(:,8);
LonNum(LonNum<0) = nan;
Lon0    = floor(LonNum/100);
Lon     = -1*Lon0-(LonNum-Lon0*100)/60;
Depth   = raw_data.data(:,9);
NET_CHL = raw_data.data(:,10);
NET_PHAE= raw_data.data(:,11);
NANO_CHL= raw_data.data(:,12);
NANO_PHAE= raw_data.data(:,13);
TOTAL_CHL= raw_data.data(:,14);
TOTAL_PHAE= raw_data.data(:,15);
CRUISE    = raw_data.data(:,16);

TOTAL_CHL(TOTAL_CHL<0.01) = 0.01;
%% find KY station near New York
nSample = length(Station);

i = 0;
j = 0;
for n = 1 : nSample
    
    cruise_char = char(Cruise(n));

    if strcmp(cruise_char(1:2),'KY')
        i = i + 1;
        ind_station(i) = n;
        
    else
        j = j + 1;
        ind_profile(j)= n; 
    end


end

Station_profile   = Station(ind_profile);
Year_profile      = Year(ind_profile);
Month_profile     = Month(ind_profile);
Day_profile       = Day(ind_profile);
Time_profile      = Time(ind_profile);
Lon_profile       = Lon(ind_profile);
Lat_profile       = Lat(ind_profile);
Depth_profile     = Depth(ind_profile);
TOTAL_CHL_profile = TOTAL_CHL(ind_profile);
NET_CHL_profile   = NET_CHL(ind_profile);
NANO_CHL_profile  = NANO_CHL(ind_profile);
Cruise_profile    = CRUISE(ind_profile);
%TOTAL_CHL_profile(TOTAL_CHL_profile>=20) = nan;

profile_data = [Cruise_profile,Station_profile,Time_profile,...
                Year_profile,Month_profile,Day_profile,...
                Lon_profile,Lat_profile,Depth_profile,...
                TOTAL_CHL_profile,NET_CHL_profile,NANO_CHL_profile];

% %% Generatel GoogleEarth kml files
% 
% kml_MARMAP_stations = ge_point(Lon_profile,Lat_profile,0.1,...
%       'iconScale',0.3,...
%       'iconURL','http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png');
% ge_output('MARMAP_stations.kml',kml_MARMAP_stations);
%% Calculate Seasonal climatology

% Define vertical layer range:
DepRange = 0 : 10 : 10; 

ddeg = 0.5;

% Define Lon-Lat ranges:
LonRange = -78. : ddeg : -62.5;
LatRange = 35.: ddeg : 45.0;

[LAT, LON] = meshgrid(LatRange(1:end-1),LonRange(1:end-1));

nLon = length(LonRange)-1;
nLat = length(LatRange)-1;
nLyr = length(DepRange)-1;

F = scatteredInterpolant(LONN(:),LATT(:),z(:),'linear','none');
LocDepth =  -1*F(LON(:),LAT(:));

ind_shelf = find(LocDepth<=1000);

SeasonalCHL  = nan(nLon,nLat,6);
SeasonalNET  = nan(nLon,nLat,6);
SeasonalNANO = nan(nLon,nLat,6);
   
    for m = 1: 6
       
        ind_month_layer = find(Month_profile>=m*2-1 & Month_profile<=m*2 & Depth_profile>=DepRange(1) & Depth_profile<DepRange(2));
        
        if ~isempty(ind_month_layer)
            
            Lon_temp = Lon_profile(ind_month_layer);
            Lat_temp = Lat_profile(ind_month_layer);
            CHL_temp = TOTAL_CHL_profile(ind_month_layer);
           % NET_temp = NET_CHL_profile(ind_month_layer);
           % NANO_temp = NANO_CHL_profile(ind_month_layer);
           
           ind_val = find(~isnan(CHL_temp));
           output = [Lon_temp(ind_val),Lat_temp(ind_val),CHL_temp(ind_val)];           
        
           
           [SeasonalCHL(:,:,m),~] = average_xy([Lon_profile(ind_month_layer),Lat_profile(ind_month_layer),TOTAL_CHL_profile(ind_month_layer)],LonRange,LatRange,5);
           [SeasonalNET(:,:,m),~] = average_xy([Lon_profile(ind_month_layer),Lat_profile(ind_month_layer),NET_CHL_profile(ind_month_layer)],LonRange,LatRange,5);
           [SeasonalNANO(:,:,m),~] = average_xy([Lon_profile(ind_month_layer),Lat_profile(ind_month_layer),NANO_CHL_profile(ind_month_layer)],LonRange,LatRange,5);
           
           
         %  save(['MARMAP_CHL_Mon',num2str(2*m-1),'t',num2str(2*m),'.txt'],'output','-ascii')
           
        end
            
    end

SeasonalNETRatio = SeasonalNET./(SeasonalNET+SeasonalNANO);
SeasonalNANORatio = SeasonalNANO./(SeasonalNET+SeasonalNANO);

% plot 0-50m Seasonal climatology chl-a 

%%

color_b(1:26)=1;
color_b(27:51)=0.98:-0.04:0;

color_r(1:26)=0:0.04:1;
color_r(27:51)=1;

color_g(1:26)=0:0.04:1;
color_g(27:51)=0.98:-0.04:0;

MAP=[color_r',color_g',color_b'];


figure(1)
for month = 1 : 6
    
    row = ceil(month/3);
    column = month - (row-1)*3; 
    
   subplot('Position',[0.1+0.29*(column-1) 0.82-row*0.35 0.27 0.3])
    plot_map = nan(nLon,nLat);
    plot_fraction = 100*squeeze(SeasonalNETRatio(:,:,month));
    plot_map(ind_shelf) = plot_fraction(ind_shelf);
    
    obs_mask(:,:,month)=plot_map;
    obs_mask(~isnan(obs_mask))=1;
   
    plot(GOM3_coast(:,1),GOM3_coast(:,2),'k-','linewidth',1)
    hold on
    pcolor(LONN,LATT,bathy)
    caxis([-10 0])
    colormap('gray(20)')
    freezeColors  
    pcolor(LON,LAT,plot_map)

    eval(['obs_bimonth_',num2str(month),'=plot_map'])
    eval(['save obs_bimonth_',num2str(month),' obs_bimonth_',num2str(month)])
    
    shading flat
    %cptcmap('GMT_polar','ncol',10);
colormap(MAP)
    %caxis([0 5])
    caxis([0 100])
    axis([-76 -63 35 46])
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
 %colormap('jet(40)')
% cptcmap('GMT_polar','ncol',10);
colormap(MAP)
 caxis([0 100])
 colorbar('Location','SouthOutside','Ticks',[0 20 50 80 100],'TickLabels',{'100%','Small P dominate','50%','Large P dominate','100%'},'fontsize',14)
 set(gca,'ytick',[],'xtick',[],'xcolor','w','ycolor','w')
 annotation('textbox',[0.2 0.87 0.7 0.1],'String',['MARMAP bimonthly size composition (1978-1988)'],'edgecolor','none','fontsize',16);
box off
saveas(gcf,'MARMAP_Bimonthly_SizeCompose_1978t1988_v10_bm.jpg')

save obs_mask obs_mask
