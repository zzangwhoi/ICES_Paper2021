% Step-0: Plot FVCOM-GOM3 mesh etc
%
% Zhixuan Feng (zfeng@whoi.edu)
% 08-14-2018
%%
clear all
close all
%%
clc
gridnc = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/gom3_gridinfo.nc';
siglev = ncread(gridnc,'siglev');
nv = ncread(gridnc,'nv');
load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_grid.mat'

x_gom3 = mGRID.x;
y_gom3 = mGRID.y;
h_gom3 = mGRID.h;
lon_gom3 = mGRID.lon;
lat_gom3 = mGRID.lat;
% load mesh
load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/mesh.mat';

[lonc_gom3,latc_gom3] = sp_proj('1802','inverse',mesh.uvnode(:,1),mesh.uvnode(:,2),'m');
hc_gom3 = mesh.uvdepth;
%%
Lon_Min = floor(min(lon_gom3))-1;
Lon_Max = ceil(max(lon_gom3))+1;
Lat_Min = floor(min(lat_gom3))-1;
Lat_Max = ceil(max(lat_gom3))+1;

load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_coast.mat'
%load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/xy_coastline.mat'
%%%% load '/Users/fengzhixuan/Documents/GoM_Scallop_NOAA/GoogleEarth/GulfMaineDomain.dat';
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

%%%% inGoM = inpolygon(lon_gom3,lat_gom3,GulfMaineDomain(:,1),GulfMaineDomain(:,2));
%%%% IndGoM = find(inGoM == 1 & h_gom3 <= 1000);

%% Define nodes and lines for diagnosis
Select_nodes = [15101,33801,23901,15801,17101,601,13601];

%% Plot FVCOM mesh in Lon-Lat coordinate
tic % 300 s
figure
  hold on
  pcolor(LON,LAT,bathy)
  caxis([-10 0])
  colormap('gray(20)')
  freezeColors
  shading flat
  ind_triangle = find(hc_gom3>0);
%{
  for m= 1 : length(ind_triangle)
     plot([lon_gom3(mesh.trinodes(ind_triangle(m),:));lon_gom3(mesh.trinodes(ind_triangle(m),1))],[lat_gom3(mesh.trinodes(ind_triangle(m),:));lat_gom3(mesh.trinodes(ind_triangle(m),1))],'-','linewidth',0.5,'color','r')
  end
%}
patch('Vertices',[lon_gom3,lat_gom3],'Faces',nv,'FaceColor','w','EdgeColor','r'); hold on


scatter(lonc_gom3,latc_gom3,2,log(hc_gom3),'filled')
  cptcmap('GMT_ocean','flip',true)
  caxis([log(3) log(5000)])
  colorbar('Location','NorthOutside','Ticks',[log(3),log(10),log(100),log(1000),log(5000)],...
           'TickLabels',{'3 m','10','100','1,000','5,000'});
  set(gca,'fontsize',16) 
  set(gca,'xtick',-75:5:-55)
  set(gca,'xticklabel',{'75^{o}W','70^{o}W','65^{o}W','60^{o}W','55^{o}W'});
  set(gca,'ytick',34:2:46)
  set(gca,'yticklabel',{'34^{o}N','36^{o}N','38^{o}N','40^{o}N','42^{o}N','44^{o}N','46^{o}N'})
  axis([-76 -56 35 46])
  plot(GOM3_coast(:,1),GOM3_coast(:,2),'-','linewidth',1,'color',[0.1 0.1 0.1])
  title('FVCOM-GOM3 domain and mesh');
  %grid on
  box on
%{
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/MAB.txt');
lon_MAB=MAB(:,1);lat_MAB=MAB(:,2);
plot(lon_MAB,lat_MAB,'y','Linewidth',1.5)

load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/GOM.txt');
lon_GOM=GOM(:,1);lat_GOM=GOM(:,2);
plot(lon_GOM,lat_GOM,'y','Linewidth',1.5)

load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/GOM_alldepth.txt');
lon_GOM_alldepth=GOM_alldepth(:,1);lat_GOM_alldepth=GOM_alldepth(:,2);
plot(lon_GOM_alldepth,lat_GOM_alldepth,'r','Linewidth',1.5)


GB_Line_LonLat = [-68.000*ones(200,1),transpose(linspace(44.162,40.24,200))]; % George Bank
plot(GB_Line_LonLat(:,1),GB_Line_LonLat(:,2),'g','Linewidth',1.5)

LTER_Line_LonLat = [-70.88*ones(50,1), transpose(linspace(41.23,40.05,50))]; % LTER
plot(LTER_Line_LonLat(:,1),LTER_Line_LonLat(:,2),'g','Linewidth',1.5)

%}
 %   text(-63.5,44.0,'NSS','Fontsize',16,'Rotation',25)
  text(-69.2,43.0,'GoM','Fontsize',14,'Rotation',20)
  text(-68.3,41.1,'GB','Fontsize',16,'Rotation',25)
  text(-73.5,39.3,'MAB','Fontsize',16,'Rotation',40)
  text(-71,40.8,'NS','Fontsize',16,'Rotation',0)
  text(-69.3,40.4,'GSC','Fontsize',16,'Rotation',90)
  text(-66.5,42.9,'NC','Fontsize',14,'Rotation',-30)

%    text(-63.0,37.0,'NSS: Nova Scotian Shelf','Fontsize',14)
  text(-64.0,39.0,'GoM: Gulf of Maine','Fontsize',14)
  text(-64.0,38.3,'GB: Georges Bank','Fontsize',14)
  text(-64.0,37.6,'NC: Northeast Channel','Fontsize',14)
  text(-64.0,36.9,'MAB: Mid-Atlantic Bight','Fontsize',14)
  text(-64.0,36.2,'NS: Nantucket Shoals','Fontsize',14)
  text(-64.0,35.5,'GSC: Great South Channel','Fontsize',14)

  
print(gcf,'-dpng','-r200','Fig1_FVCOM_Domain_noprofile');
toc
