%% scatter plot between obs and model
clc;clear
load('obsgrd_LON1_LAT1.mat')
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/GOM.txt'); %
load('/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files_GOM_MAB/MAB.txt'); %
lon_GOM=GOM(:,1);lat_GOM=GOM(:,2);
lon_MAB=MAB(:,1);lat_MAB=MAB(:,2);


load '/Users/zhengchenzang/Desktop/Gbank/plot_script/map_station/data_files/GOM3_grid.mat'
lon_gom3 = mGRID.lon;
lat_gom3 = mGRID.lat;
  h_gom3 = mGRID.h;
  
h_obsgrd=griddata(lon_gom3,lat_gom3,h_gom3,LON1,LAT1);


ind_GOM=double(inpolygon(LON1,LAT1,lon_GOM,lat_GOM)); ind_GOM(ind_GOM==0 | h_obsgrd<20 | h_obsgrd>500 )=NaN;
ind_MAB=double(inpolygon(LON1,LAT1,lon_MAB,lat_MAB)); ind_MAB(ind_MAB==0 | h_obsgrd<20 | h_obsgrd>500 )=NaN;

load('obs_month_1.mat');load('model_month_1.mat');
load('obs_month_2.mat');load('model_month_2.mat');
load('obs_month_3.mat');load('model_month_3.mat');
load('obs_month_4.mat');load('model_month_4.mat');
load('obs_month_5.mat');load('model_month_5.mat');
load('obs_month_6.mat');load('model_month_6.mat');
load('obs_month_7.mat');load('model_month_7.mat');
load('obs_month_8.mat');load('model_month_8.mat');
load('obs_month_9.mat');load('model_month_9.mat');
load('obs_month_10.mat');load('model_month_10.mat');
load('obs_month_11.mat');load('model_month_11.mat');
load('obs_month_12.mat');load('model_month_12.mat');


%{
scatter(reshape(obs_bimonth_1,[31*20,1]),reshape(model_bimonth_1,[31*20,1]),'r'); hold on
scatter(reshape(obs_bimonth_2,[31*20,1]),reshape(model_bimonth_2,[31*20,1]),'g'); hold on
scatter(reshape(obs_bimonth_3,[31*20,1]),reshape(model_bimonth_3,[31*20,1]),'b'); hold on
scatter(reshape(obs_bimonth_4,[31*20,1]),reshape(model_bimonth_4,[31*20,1]),'k'); hold on
scatter(reshape(obs_bimonth_5,[31*20,1]),reshape(model_bimonth_5,[31*20,1]),'c'); hold on
scatter(reshape(obs_bimonth_6,[31*20,1]),reshape(model_bimonth_6,[31*20,1]),'m'); hold on
%}


for month=1:12
    eval(['GOM_model=model_month_',num2str(month),'.*ind_GOM;'])
      eval(['GOM_obs=obs_month_',num2str(month),'.*ind_GOM;'])

    eval(['MAB_model=model_month_',num2str(month),'.*ind_MAB;'])
      eval(['MAB_obs=obs_month_',num2str(month),'.*ind_MAB;'])  
      
      GOM_ratio_month_model(month)=nanmean(nanmean(GOM_model));
      std_GOM_model(month)=std(GOM_model(~isnan(GOM_model)));
      
      GOM_ratio_month_obs(month)=nanmean(nanmean(GOM_obs));
      std_GOM_obs(month)=std(GOM_obs(~isnan(GOM_obs)));

      MAB_ratio_month_model(month)=nanmean(nanmean(MAB_model));
      std_MAB_model(month)=std(MAB_model(~isnan(MAB_model)));
      
      MAB_ratio_month_obs(month)=nanmean(nanmean(MAB_obs));
      std_MAB_obs(month)=std(MAB_obs(~isnan(MAB_obs)));


end
    
%scatter(GOM_ratio_month_obs,GOM_ratio_month_model,30,'b'); hold on
%scatter(MAB_ratio_month_obs,MAB_ratio_month_model,30,'r'); hold on
figure(1)
errorbar(GOM_ratio_month_obs,GOM_ratio_month_model,std_GOM_model,std_GOM_model,std_GOM_obs,std_GOM_obs,'o','color','b','linewidth',1.2); hold on
errorbar(MAB_ratio_month_obs,MAB_ratio_month_model,std_MAB_model,std_MAB_model,std_MAB_obs,std_MAB_obs,'o','color','r','linewidth',1.2); hold on

plot([0 100],[0 100],'k','linewidth',1.3)

[R_GOM,P_GOM]=corrcoef(GOM_ratio_month_obs,GOM_ratio_month_model);
[R_MAB,P_MAB]=corrcoef(MAB_ratio_month_obs,MAB_ratio_month_model);

RMSE_GOM=sqrt(mean((GOM_ratio_month_obs-GOM_ratio_month_model).^2)); RMSE_GOM=round(RMSE_GOM.*100)./100;
RMSE_MAB=sqrt(mean((MAB_ratio_month_obs-MAB_ratio_month_model).^2)); RMSE_MAB=round(RMSE_MAB.*100)./100;

text(10,90,['{\it r}(GOM)=',num2str(round(R_GOM(1,2).*100)./100)],'color','b','fontsize',14);
text(10,85,['{\it r}(MAB)=',num2str(round(R_MAB(1,2).*100)./100),'0'],'color','r','fontsize',14);


xlabel('MARMAP(%): LP/(SP+LP)','fontsize',16)
ylabel('Model(%): LP/(SP+LP)','fontsize',16)
set(gca,'fontsize',14,'Xtick',[0:10:100],'Ytick',[0:10:100])
xlim([0 100]); ylim([0 100]);
axis on
grid on
axis square
box on
set(gcf,'Position',[0 0 600 500])
saveas(gcf,'LP_ratio_scatter.png')



figure(2)
ha=tight_subplot(2,1,[.06 .02],[.1 .02],[.1 .03])    
    
for sr=1:2

    switch sr

        case 1
            axes(ha(sr))
%plot(1:12,GOM_ratio_month_model,'k-','linewidth',1.5); hold on
errorbar(1:12,GOM_ratio_month_model,std_GOM_model,'k','linewidth',1.5); hold on
errorbar(1:12,GOM_ratio_month_obs,std_GOM_obs,'r','linewidth',1.5); hold on
text(1.2,92,['a. GoM ({\it r}=',num2str(round(R_GOM(1,2).*100)./100),'; {\it p}=',num2str(round(P_GOM(1,2).*100000)./100000),'; {\it RMSE}=',num2str(RMSE_GOM),'%)'],'fontsize',16)
set(gca,'fontsize',14,'Xticklabel',[])
ylabel('LP fraction(%)','fontsize',14)
grid on
xlim([1 12]); ylim([0 100]);
legend({'Model';'MARMAP'},'fontsize',12,'location','northeast');
        case 2
            axes(ha(sr))
errorbar(1:12,MAB_ratio_month_model,std_GOM_model,'k','linewidth',1.5); hold on
errorbar(1:12,MAB_ratio_month_obs,std_GOM_obs,'r','linewidth',1.5); hold on
text(1.2,92,['b. MAB ({\it r}=',num2str(round(R_MAB(1,2).*100)./100),'0; {\it p}<0.0001; {\it RMSE}=',num2str(RMSE_MAB),'%)'],'fontsize',16)
set(gca,'fontsize',14)
ylabel('LP fraction(%)','fontsize',14)
xlabel('Month','fontsize',14)

grid on
xlim([1 12]); ylim([0 100]);



    end   
         
print(gcf,'LP_percentage_tseries.png','-r200','-dpng');    
end

