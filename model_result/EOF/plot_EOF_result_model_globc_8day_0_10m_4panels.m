clc;clear
file = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/etopo1_NEshelf.nc';
[LAT,LON] = meshgrid(ncread(file,'lat'),ncread(file,'lon'));
z = double(ncread(file,'Band1'));
bathy = z;
bathy(z>0) = -3.2;
bathy(z<=0) = nan;

load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_coast.mat'

mod1=1;
mod2=2;
mod3=3;

period='1978_2014';

time_8day=1:8:365; a=1:46; time_monthly=[1,1+31,1+31+28,1+31+28+31,1+31+28+31+30,1+31+28+31+30+31,1+31+28+31+30+31+30,1+31+28+31+30+31+30+31,1+31+28+31+30+31+30+31+31,1+31+28+31+30+31+30+31+31+30,1+31+28+31+30+31+30+31+31+30+31,1+31+28+31+30+31+30+31+31+30+31+30];
c=interp1(time_8day,a,time_monthly);


%load grid info
gridnc = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/gom3_gridinfo.nc';
siglev = ncread(gridnc,'siglev');
siglay = ncread(gridnc,'siglay');
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_grid.mat')

x_gom3 = mGRID.x;
y_gom3 = mGRID.y;
h_gom3 = mGRID.h;
lon_gom3 = mGRID.lon;
lat_gom3 = mGRID.lat;
hmask=h_gom3; hmask(hmask>1000 | hmask<20)=NaN; hmask(hmask<1000)=1;

file = '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/etopo1_NEshelf.nc';
[LAT,LON] = meshgrid(ncread(file,'lat'),ncread(file,'lon'));
file='/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/lon_lat_nv.nc';

lon=ncread(file,'lon');
lat=ncread(file,'lat');
nv=ncread(file,'nv');
% load EOF data % P is the data matrix; M is principal components matrix ie it has the form PC(N,TIME); r is fraction

load(['../data/M_model_8days_new_',period,'.mat'])
load(['../data/P_model_8days_new_',period,'.mat'])
load(['../data/r_model_8days_new_',period,'.mat'])
%load('./M_model_chl_8days_0_10m_1978_2014.mat');
%load('./P_model_chl_8days_0_10m_1978_2014.mat');
%load('./r_model_chl_8days_0_10m_1978_2014.mat');

load(['r_globc_8days_new_1998_2014.mat']);
load(['P_globc_8days_new_1998_2014.mat']);
load(['M_globc_8days_new_1998_2014.mat']);

color_b(1:13)=1;
color_b(14:26)=0.98:-0.08:0;

color_r(1:13)=0:0.08:1;
color_r(14:26)=1;

color_g(1:13)=0:0.08:1;
color_g(14:26)=0.98:-0.08:0;

MAP=[color_r',color_g',color_b'];


ha=tight_subplot(2,2,[.05 .05],[.08 .12],[.08 .03]);

for kk=1:4
    axes(ha(kk));

    switch kk
    case 1
        Data4plot=P_model(mod1,:);
         plot(GOM3_coast(:,1),GOM3_coast(:,2),'-','linewidth',1,'color',[0.1 0.1 0.1]); hold on
         pcolor(LON,LAT,bathy);shading flat 
          caxis([-20 0])
colormap gray
hold on
freezeColors
title(['a. Mode 1 (model)'],'fontsize',16)
text(-67,39,['(',num2str(r_model(1)),'%)'],'fontsize',16)
    patch('Vertices',[lon,lat],'Faces',nv,'FaceColor','flat','FaceVertexCData',Data4plot'.*hmask.*120,'EdgeColor','none')
colormap(MAP)

caxis([-1 1])
box on
xlim([-76 -64]);ylim([38 46]);
xticklabel={};
yticklabel={'38^\circN','40^\circN','42^\circN','44^\circN','46^\circN'};
set(gca,'fontsize',14,'xtick',[-76,-73,-70,-67,-64],'xticklabel',xticklabel,'ytick',[38,40,42,44,46],'yticklabel',yticklabel)


    case 2
        
        Data4plot=P_globc(mod1,:);
         plot(GOM3_coast(:,1),GOM3_coast(:,2),'-','linewidth',1,'color',[0.1 0.1 0.1]); hold on
         pcolor(LON,LAT,bathy);shading flat 
          caxis([-20 0])
colormap gray
hold on
freezeColors
title(['b. Mode 1 (GlobColour)'],'fontsize',16)
text(-67,39,['(',num2str(r_globc(1)),'%)'],'fontsize',16)

    patch('Vertices',[lon,lat],'Faces',nv,'FaceColor','flat','FaceVertexCData',Data4plot'.*hmask.*120,'EdgeColor','none')
colormap(MAP)

caxis([-1 1])
box on
xlim([-76 -64]);ylim([38 46]);
xticklabel={''};
yticklabel={'38^\circN','40^\circN','42^\circN','44^\circN','46^\circN'};
set(gca,'fontsize',14,'xtick',[-76,-73,-70,-67,-64],'xticklabel',xticklabel,'ytick',[38,40,42,44,46],'yticklabel',yticklabel)

        
    case 3
  plot(GOM3_coast(:,1),GOM3_coast(:,2),'-','linewidth',1,'color',[0.1 0.1 0.1]); hold on
  pcolor(LON,LAT,bathy);shading flat 
 caxis([-20 0])
colormap gray
hold on
freezeColors

title(['c. Mode 2 (model)'],'fontsize',16)
text(-67,39,['(',num2str(r_model(2)),'%)'],'fontsize',16)

Data4plot=P_model(mod2,:);
    patch('Vertices',[lon,lat],'Faces',nv,'FaceColor','flat','FaceVertexCData',Data4plot'.*hmask.*-100,'EdgeColor','none')
colormap(MAP)

caxis([-1 1])
box on
xlim([-76 -64]);ylim([38 46]);
xticklabel={''};
text(-76-1,37.2,'76^\circW','fontsize',14)
text(-73-1,37.2,'73^\circW','fontsize',14)
text(-70-1,37.2,'70^\circW','fontsize',14)
text(-67-1,37.2,'67^\circW','fontsize',14)
text(-64-1,37.2,'64^\circW','fontsize',14)


yticklabel={'38^\circN','40^\circN','42^\circN','44^\circN','46^\circN'};
set(gca,'fontsize',14,'xtick',[-76,-73,-70,-67,-64],'xticklabel',xticklabel,'ytick',[38,40,42,44,46],'yticklabel',yticklabel)

    case 4
  plot(GOM3_coast(:,1),GOM3_coast(:,2),'-','linewidth',1,'color',[0.1 0.1 0.1]); hold on
  pcolor(LON,LAT,bathy);shading flat 
 caxis([-20 0])
colormap gray
hold on
freezeColors

title(['d. Mode 2 (GlobColour)'],'fontsize',16)
text(-67,39,['(',num2str(r_globc(2)),'%)'],'fontsize',16)

Data4plot=P_globc(mod2,:);
    patch('Vertices',[lon,lat],'Faces',nv,'FaceColor','flat','FaceVertexCData',Data4plot'.*hmask.*80,'EdgeColor','none')
colormap(MAP)

caxis([-1 1])
box on
xlim([-76 -64]);ylim([38 46]);
xticklabel={''};
%xticklabel={'-76^\circW','-74^\circW','-72^\circW','-70^\circW','-68^\circW','-66^\circW','-64^\circW'};
text(-76-1,37.2,'76^\circW','fontsize',14)
text(-73-1,37.2,'73^\circW','fontsize',14)
text(-70-1,37.2,'70^\circW','fontsize',14)
text(-67-1,37.2,'67^\circW','fontsize',14)
text(-64-1,37.2,'64^\circW','fontsize',14)


yticklabel={'38^\circN','40^\circN','42^\circN','44^\circN','46^\circN'};
set(gca,'fontsize',14,'xtick',[-76,-73,-70,-67,-64],'xticklabel',xticklabel,'ytick',[38,40,42,44,46],'yticklabel',yticklabel)

    end
end

%%%%% colorbar %%%%%
ax1 = axes;
colormap(ax1,MAP)
set(ax1,'Position',[0.12 0.78 0.8 0.2],'fontsize',16)
c1 = colorbar(ax1);
freezeColors
ax1.Visible = 'off';
set(c1,'location','north','Xtick',[-1:0.5:1])
caxis([-1 1])

%%%%% tseries 1 %%%%%
ax2 = axes;
plot(M_model(mod1,:)./120,'k','linewidth',2);
set(ax2,'Position',[0.1 0.72 0.16 0.16],'fontsize',16)
freezeColors
ax2.Visible = 'on';
xlim([1,46]);ylim([-3 3])
Xticklabel={'1','2','3','4','5','6','7','8','9','10','11','12'};
time_8day=1:8:365; a=1:46; time_monthly=[1,1+31,1+31+28,1+31+28+31,1+31+28+31+30,1+31+28+31+30+31,1+31+28+31+30+31+30,1+31+28+31+30+31+30+31,1+31+28+31+30+31+30+31+31,1+31+28+31+30+31+30+31+31+30,1+31+28+31+30+31+30+31+31+30+31,1+31+28+31+30+31+30+31+31+30+31+30];
c=interp1(time_8day,a,time_monthly);
grid on
set(gca,'Xtick',c,'Xticklabel',Xticklabel,'fontsize',10,'Ytick',[-3:1:3])
xlabel('Month','fontsize',12)


%%%%% tseries 2 %%%%%
ax3 = axes;
plot(M_globc(mod1,:)./120,'k','linewidth',2);
set(ax3,'Position',[0.57 0.72 0.16 0.16],'fontsize',16)
freezeColors
ax3.Visible = 'on';
xlim([1,46]);ylim([-3 3])
Xticklabel={'1','2','3','4','5','6','7','8','9','10','11','12'};
time_8day=1:8:365; a=1:46; time_monthly=[1,1+31,1+31+28,1+31+28+31,1+31+28+31+30,1+31+28+31+30+31,1+31+28+31+30+31+30,1+31+28+31+30+31+30+31,1+31+28+31+30+31+30+31+31,1+31+28+31+30+31+30+31+31+30,1+31+28+31+30+31+30+31+31+30+31,1+31+28+31+30+31+30+31+31+30+31+30];
c=interp1(time_8day,a,time_monthly);
grid on
set(gca,'Xtick',c,'Xticklabel',Xticklabel,'fontsize',10,'Ytick',[-3:1:3])
xlabel('Month','fontsize',12)

%%%%% tseries 3 %%%%%
ax4 = axes;
plot(M_model(mod2,:)./-100,'k','linewidth',2)
set(ax4,'Position',[0.1 0.295 0.16 0.16],'fontsize',16)
freezeColors
ax4.Visible = 'on';
xlim([1,46]);ylim([-3 3])
Xticklabel={'1','2','3','4','5','6','7','8','9','10','11','12'};
time_8day=1:8:365; a=1:46; time_monthly=[1,1+31,1+31+28,1+31+28+31,1+31+28+31+30,1+31+28+31+30+31,1+31+28+31+30+31+30,1+31+28+31+30+31+30+31,1+31+28+31+30+31+30+31+31,1+31+28+31+30+31+30+31+31+30,1+31+28+31+30+31+30+31+31+30+31,1+31+28+31+30+31+30+31+31+30+31+30];
c=interp1(time_8day,a,time_monthly);
grid on
set(gca,'Xtick',c,'Xticklabel',Xticklabel,'fontsize',10,'Ytick',[-3:1:3])
xlabel('Month','fontsize',12)


%%%%% tseries 4 %%%%%
ax5 = axes;
plot(M_globc(mod2,:)./80,'k','linewidth',2)
set(ax5,'Position',[0.57 0.295 0.16 0.16],'fontsize',16)
freezeColors
ax5.Visible = 'on';
xlim([1,46]);ylim([-3 3])
Xticklabel={'1','2','3','4','5','6','7','8','9','10','11','12'};
time_8day=1:8:365; a=1:46; time_monthly=[1,1+31,1+31+28,1+31+28+31,1+31+28+31+30,1+31+28+31+30+31,1+31+28+31+30+31+30,1+31+28+31+30+31+30+31,1+31+28+31+30+31+30+31+31,1+31+28+31+30+31+30+31+31+30,1+31+28+31+30+31+30+31+31+30+31,1+31+28+31+30+31+30+31+31+30+31+30];
c=interp1(time_8day,a,time_monthly);
grid on
set(gca,'Xtick',c,'Xticklabel',Xticklabel,'fontsize',10,'Ytick',[-3:1:3])
xlabel('Month','fontsize',12)


set(gcf,'Position',[0 0 1000 600])
saveas(gcf,['model_globc_EOF',period,'_4panels.png'])
