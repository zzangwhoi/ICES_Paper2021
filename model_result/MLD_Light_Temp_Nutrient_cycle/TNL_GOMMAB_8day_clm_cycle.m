%% plot the SWR, SST and nutrient 8 day clm  (haven't get nutrient data yet)
clc;clear

load SWR_8day_clm.mat
load SST_8day_clm.mat
load DIN_surface_8day_clm.mat

load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/GOM.txt'); %
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/MAB.txt'); %

lon_GOM=GOM(:,1);lat_GOM=GOM(:,2);
lon_MAB=MAB(:,1);lat_MAB=MAB(:,2);

load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_grid.mat'
lon_gom3 = mGRID.lon;
lat_gom3 = mGRID.lat;
  h_gom3 = mGRID.h;
  h_mask=h_gom3;h_mask(h_mask<20 | h_mask >500)=NaN; h_mask(~isnan(h_mask))=1;
  mask_GOM=double(inpolygon(lon_gom3,lat_gom3,lon_GOM,lat_GOM));mask_GOM(mask_GOM~=1)=NaN;
 mask_GOM=mask_GOM.*h_mask;
 mask_GOM_46=repmat(mask_GOM,[1,46]);
 
   h_mask=h_gom3;h_mask(h_mask<20 | h_mask >500)=NaN; h_mask(~isnan(h_mask))=1;
  mask_MAB=double(inpolygon(lon_gom3,lat_gom3,lon_MAB,lat_MAB));mask_MAB(mask_MAB~=1)=NaN;
 mask_MAB=mask_MAB.*h_mask;
 mask_MAB_46=repmat(mask_MAB,[1,46]);

   
SST_GOM= nanmean(SST_8day_clm .* mask_GOM_46,1);
SWR_GOM= nanmean(SWR_8day_clm .* mask_GOM_46,1);
DIN_surface_GOM= nanmean(DIN_surface_8day_clm .* mask_GOM_46,1);

SST_MAB= nanmean(SST_8day_clm .* mask_MAB_46,1);
SWR_MAB= nanmean(SWR_8day_clm .* mask_MAB_46,1);
DIN_surface_MAB= nanmean(DIN_surface_8day_clm .* mask_MAB_46,1);

N_lim_GOM_LP=DIN_surface_GOM./(DIN_surface_GOM+0.6);
N_lim_MAB_LP=DIN_surface_MAB./(DIN_surface_MAB+0.6);
N_lim_GOM_SP=DIN_surface_GOM./(DIN_surface_GOM+0.1);
N_lim_MAB_SP=DIN_surface_MAB./(DIN_surface_MAB+0.1);

T_lim_GOM=2.^(SST_GOM./10-2);
T_lim_MAB=2.^(SST_MAB./10-2);


THETA_SP_MAX=0.05;THETA_LP_MAX=0.05;
MU_SP_MAX=1.4/86400; MU_LP_MAX=3.0/86400; 
ALPHA_SP=0.00004;ALPHA_LP=0.00004;
I_GOM=SWR_GOM.*0.43;
I_MAB=SWR_MAB.*0.43;

THETA_SP_GOM=THETA_SP_MAX./(1+ALPHA_SP.*I_GOM.*THETA_SP_MAX./2./MU_SP_MAX./N_lim_GOM_SP./T_lim_GOM);
%THETA_SP_GOM=THETA_SP_MAX/20;
L_lim_GOM_SP=1-exp(-1.*ALPHA_SP.*I_GOM.*THETA_SP_GOM./MU_SP_MAX./T_lim_GOM./N_lim_GOM_SP);


load DIN_37year_tseries.mat
for yr=1:37
DIN_GOM(yr,1:46)= nanmean(squeeze(DIN_37year_tseries(yr,:,:)).*mask_GOM_46,1);
DIN_MAB(yr,1:46)= nanmean(squeeze(DIN_37year_tseries(yr,:,:)).*mask_MAB_46,1);
end
for i=1:46
DIN_GOM_std(i)=std(DIN_GOM(:,i));    
DIN_MAB_std(i)=std(DIN_MAB(:,i));    

end

load SST_37year_tseries.mat
for yr=1:37
SST_GOM_1(yr,1:46)= nanmean(squeeze(SST_37year_tseries(yr,:,:)).*mask_GOM_46,1);
SST_MAB_1(yr,1:46)= nanmean(squeeze(SST_37year_tseries(yr,:,:)).*mask_MAB_46,1);
end
for i=1:46
SST_GOM_std(i)=std(SST_GOM_1(:,i));    
SST_MAB_std(i)=std(SST_MAB_1(:,i));    

end


%{
figure(1)
plot(1:46,SST_GOM,'b'); hold on; plot(1:46,SST_MAB,'r');

figure(2)
plot(1:46,SWR_GOM,'b'); hold on; plot(1:46,SWR_MAB,'r');

figure(3)
plot(1:46,DIN_surface_GOM,'b'); hold on; plot(1:46,DIN_surface_MAB,'r');


figure(4)
plot(1:46,T_lim_GOM,'b'); hold on; plot(1:46,T_lim_MAB,'r');


figure(5)
plot(L_lim_GOM_SP)
ylim([0 1])

figure(6)
plot(1:46,N_lim_GOM_LP,'b'); hold on;
plot(1:46,N_lim_GOM_SP,'b.-'); hold on;
plot(1:46,N_lim_MAB_LP,'r');hold on; % large P
plot(1:46,N_lim_MAB_SP,'r.-'); % small P
%}
set(gcf,'Position',[0 0 1000 600])
ha=tight_subplot(2,2,[.08 .08],[.08 .03],[.07 .05])

%Xticklabel={'1','41','81','121','161','201','241','281','321','365'};
Xticklabel={'1','2','3','4','5','6','7','8','9','10','11','12'};
t1=1:46;t2=46:-1:1; t=[t1,t2];

time_8day=1:8:365; a=1:46; time_monthly=[1,1+31,1+31+28,1+31+28+31,1+31+28+31+30,1+31+28+31+30+31,1+31+28+31+30+31+30,1+31+28+31+30+31+30+31,1+31+28+31+30+31+30+31+31,1+31+28+31+30+31+30+31+31+30,1+31+28+31+30+31+30+31+31+30+31,1+31+28+31+30+31+30+31+31+30+31+30];
c=interp1(time_8day,a,time_monthly);


for i=1:4
        axes(ha(i));
    switch i
    case 1 % SST (GOM vs MAB)
plot(1:46,SST_GOM,'b','linewidth',1.2); hold on; plot(1:46,SST_MAB,'r','linewidth',1.2);

   SST_p_std_GOM=SST_GOM+SST_GOM_std;
   SST_m_std_GOM=SST_GOM-SST_GOM_std;
   SST_range=[SST_p_std_GOM,fliplr(SST_m_std_GOM)];
x1=fill(t,SST_range,'b','linestyle','none'); alpha(x1,.3)

   SST_p_std_MAB=SST_MAB+SST_MAB_std;
   SST_m_std_MAB=SST_MAB-SST_MAB_std;
   SST_range=[SST_p_std_MAB,fliplr(SST_m_std_MAB)];
x2=fill(t,SST_range,'r','linestyle','none'); alpha(x2,.3)


set(gca,'Xticklabel',[])
xlim([1 46]);
text(1,23.4,'(a)','fontsize',16)
ylabel('Temperature (^\circC)')
grid on
set(gca,'Xtick',c,'Xticklabel',Xticklabel,'fontsize',14)

legend({'GoM';'MAB'})
 xlabel('Month','fontsize',14)

    case 2 % DIN (GOM vs MAB)
        t1=1:46;t2=46:-1:1; t=[t1,t2];
plot(1:46,DIN_surface_GOM,'b','linewidth',1.2); hold on; plot(1:46,DIN_surface_MAB,'r','linewidth',1.2); hold on
   DIN_p_std_GOM=DIN_surface_GOM+DIN_GOM_std;
   DIN_m_std_GOM=DIN_surface_GOM-DIN_GOM_std;
   DIN_range=[DIN_p_std_GOM,fliplr(DIN_m_std_GOM)];
x1=fill(t,DIN_range,'b','linestyle','none'); alpha(x1,.3)

   DIN_p_std_MAB=DIN_surface_MAB+DIN_MAB_std;
   DIN_m_std_MAB=DIN_surface_MAB-DIN_MAB_std;
   DIN_range=[DIN_p_std_MAB,fliplr(DIN_m_std_MAB)];
x2=fill(t,DIN_range,'r','linestyle','none'); alpha(x2,.3)



xlim([1 46]);
text(1,9.43,'(b)','fontsize',16)
ylabel('Nitrogen (mmol/m^3)')
grid on
set(gca,'Xtick',c,'Xticklabel',Xticklabel,'fontsize',14)
 xlabel('Month','fontsize',14)
legend({'GoM';'MAB'})
   
        case 3 % T_Lim (GOM vs MAB)
plot([N_lim_GOM_SP,N_lim_GOM_SP(1)],[T_lim_GOM,T_lim_GOM(1)],'b','linewidth',1.2); hold on; plot([N_lim_MAB_SP,N_lim_MAB_SP(1)],[T_lim_MAB,T_lim_MAB(1)],'r','linewidth',1.2);

scatter(N_lim_GOM_SP(1),T_lim_GOM(1),90,'bp','filled'); hold on
scatter(N_lim_MAB_SP(1),T_lim_MAB(1),90,'rp','filled'); hold on

scatter(N_lim_GOM_SP(12),T_lim_GOM(12),50,'b^','filled'); hold on
scatter(N_lim_MAB_SP(12),T_lim_MAB(12),50,'r^','filled'); hold on

scatter(N_lim_GOM_SP(24),T_lim_GOM(24),50,'b*','linewidth',1.2); hold on
scatter(N_lim_MAB_SP(24),T_lim_MAB(24),50,'r*','linewidth',1.2); hold on

scatter(N_lim_GOM_SP(36),T_lim_GOM(36),50,'bo','filled'); hold on
scatter(N_lim_MAB_SP(36),T_lim_MAB(36),50,'ro','filled'); hold on

text(0.3,1.25,'(c)','fontsize',16)

quiver(0.93,0.58,-0.02,0.05,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.77,0.90,-0.02,0.05,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.77,1.10,0.01,0.05,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.95,0.90,0.02,-0.1,'r','linewidth',1,'MaxHeadSize',10); hold on

quiver(0.93,0.5,-0.02,0.05,'b','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.88,0.78,0.02,0.05,'b','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.97,0.70,0.02,-0.1,'b','linewidth',1,'MaxHeadSize',10); hold on

xx1=fill([0.3 1.3 1.3],[0.3 0.3 1.3],'y'); alpha(xx1,.2)
xx2=fill([0.3 1.3 0.3],[0.3 1.3 1.3],'c'); alpha(xx2,.2)

plot([0.3,1.3],[0.3,1.3],'k','linewidth',1.3); hold on
xlim([0.3 1.3]);
ylim([0.3 1.3])
text(0.35,0.4,'{\it f}(T) > {\it g}(N)','fontsize',14,'rotation',37)
text(0.38,0.33,'{\it f}(T) < {\it g}(N)','fontsize',14,'rotation',37)

text(0,0.07,'(c)','fontsize',16)
ylabel('{\it f}(T)','fontsize',14)
xlabel('{\it g}(N)','fontsize',14)
grid on
set(gca,'Xtick',[0.3,0.5,0.7,0.9,1.1,1.3],'Ytick',[0.3,0.5,0.7,0.9,1.1,1.3],'fontsize',14)
% legned

rectangle('Position',[0.97 0.85 0.32 0.4],'FaceColor','w'); hold on
plot([0.98,1.08],[1.2,1.2],'b','linewidth',1); text(1.1,1.21,'GoM (SP)','fontsize',13)
plot([0.98,1.08],[1.14,1.14],'r','linewidth',1);text(1.1,1.15,'MAB (SP)','fontsize',13)
scatter(1.01,1.09,90,'bp','filled'); text(1.1,1.09,'Jan-1','fontsize',13)
scatter(1.06,1.09,90,'rp','filled')
scatter(1.01,1.02,50,'b^','filled'); text(1.1,1.02,'Apr-1','fontsize',13)
scatter(1.06,1.02,50,'r^','filled')
scatter(1.01,0.95,50,'b*','linewidth',1.2); text(1.1,0.95,'Jul-1','fontsize',13)
scatter(1.06,0.95,50,'r*','linewidth',1.2)
scatter(1.01,0.88,50,'bo','filled'); text(1.1,0.88,'Oct-1','fontsize',13)
scatter(1.06,0.88,50,'ro','filled')
% end legend


    case 4
f1=plot([N_lim_GOM_LP,N_lim_GOM_LP(1)],[T_lim_GOM,T_lim_GOM(1)],'b','linewidth',1.2); hold on; f2=plot([N_lim_MAB_LP,N_lim_MAB_LP(1)],[T_lim_MAB,T_lim_MAB(1)],'r','linewidth',1.2);
plot([0.3,1.3],[0.3,1.3],'k','linewidth',1.3); hold on

text(0.3,1.25,'(d)','fontsize',16)


quiver(0.5,0.72,-0.05,0.05,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.33,0.95,0.02,0.1,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.60,1.1,0.04,-0.05,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.82,0.7,0.02,-0.05,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.75,0.5,-0.05,0.05,'r','linewidth',1,'MaxHeadSize',10); hold on

quiver(0.75,0.44,-0.04,0.04,'b','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.55,0.81,0.06,0.03,'b','linewidth',1,'MaxHeadSize',10); hold on
quiver(0.87,0.60,0.02,-0.05,'b','linewidth',1,'MaxHeadSize',10); hold on


xx1=fill([0.3 1.3 1.3],[0.3 0.3 1.3],'y'); alpha(xx1,.2)
xx2=fill([0.3 1.3 0.3],[0.3 1.3 1.3],'c'); alpha(xx2,.2)

f3=scatter(N_lim_GOM_LP(1),T_lim_GOM(1),90,'bp','filled'); hold on
scatter(N_lim_MAB_LP(1),T_lim_MAB(1),90,'rp','filled'); hold on

f4=scatter(N_lim_GOM_LP(12),T_lim_GOM(12),50,'b^','filled'); hold on
scatter(N_lim_MAB_LP(12),T_lim_MAB(12),50,'r^','filled'); hold on

f5=scatter(N_lim_GOM_LP(24),T_lim_GOM(24),50,'b*','linewidth',1.2); hold on
scatter(N_lim_MAB_LP(24),T_lim_MAB(24),50,'r*','linewidth',1.2); hold on

f6=scatter(N_lim_GOM_LP(36),T_lim_GOM(36),50,'bo','filled'); hold on
scatter(N_lim_MAB_LP(36),T_lim_MAB(36),50,'ro','filled'); hold on

xlim([0.3 1.3]);
ylim([0.3 1.3])

text(0.35,0.4,'{\it f}(T) > {\it g}(N)','fontsize',14,'rotation',37)
text(0.38,0.33,'{\it f}(T) < {\it g}(N)','fontsize',14,'rotation',37)

set(gca,'Xtick',[0.3,0.5,0.7,0.9,1.1,1.3],'Ytick',[0.3,0.5,0.7,0.9,1.1,1.3],'fontsize',14)
ylabel('{\it f}(T)','fontsize',14)
xlabel('{\it g}(N)','fontsize',14)
text(0,0.07,'(d)','fontsize',16)

grid on
% legned

rectangle('Position',[0.97 0.85 0.32 0.4],'FaceColor','w'); hold on
plot([0.98,1.08],[1.2,1.2],'b','linewidth',1); text(1.1,1.21,'GoM (LP)','fontsize',13)
plot([0.98,1.08],[1.14,1.14],'r','linewidth',1);text(1.1,1.15,'MAB (LP)','fontsize',13)
scatter(1.01,1.09,90,'bp','filled'); text(1.1,1.09,'Jan-1','fontsize',13)
scatter(1.06,1.09,90,'rp','filled')
scatter(1.01,1.02,50,'b^','filled'); text(1.1,1.02,'Apr-1','fontsize',13)
scatter(1.06,1.02,50,'r^','filled')
scatter(1.01,0.95,50,'b*','linewidth',1.2); text(1.1,0.95,'Jul-1','fontsize',13)
scatter(1.06,0.95,50,'r*','linewidth',1.2)
scatter(1.01,0.88,50,'bo','filled'); text(1.1,0.88,'Oct-1','fontsize',13)
scatter(1.06,0.88,50,'ro','filled')
% end legend

    end
end
set(gcf,'Position',[0 0 800 600])
saveas(gcf,'TM_limit_8day_clm_cycle.png')


%{
figure(2)
plot(1:46,SWR_GOM,'b','linewidth',1.2); hold on
plot(1:46,SWR_MAB,'r','linewidth',1.2); hold on
xlim([1 46]);
set(gca,'Xtick',[1,6,11,16,21,26,31,36,41,46],'Xticklabel',Xticklabel,'fontsize',14)
xlabel('Julian Days','fontsize',14)
ylabel('light for photosynthesis (W/m^2)','fontsize',14)
legend({'GOM';'MAB'})
grid on
saveas(gcf,'light_8day_clm.png')


%}



