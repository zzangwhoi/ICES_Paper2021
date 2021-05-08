%% plot (% GOM use observation; MAB use WOA data)
clc;clear

load('DIN_monthly_GOM'); load('SST_monthly_GOM');
load('DIN_monthly_MAB'); load('SST_monthly_MAB');
load('../TN_surface_WOA_MAB_monthly.mat');
%load('../TN_surface_WOA_GOM_monthly.mat');
load('monthly_obs_model_DIN_surface_obsloc_GOM.mat')
load('obs_DIN_surface_obsloc_GOM_monthly.mat')
load('obs_SST_surface_obsloc_GOM_monthly.mat')

figure(1)

f1=plot(monthly_obs_DIN_surface_obsloc_GOM,monthly_obs_SST_surface_obsloc_GOM,'b','linewidth',1.3); hold on
f2=plot(DIN_monthly_GOM,monthly_model_SST_surface_obsloc_GOM,'b--','linewidth',1.3); hold on
    
scatter(monthly_obs_DIN_surface_obsloc_GOM(1),monthly_obs_SST_surface_obsloc_GOM(1),200,'bp','filled'); hold on
scatter(monthly_obs_DIN_surface_obsloc_GOM(2:12),monthly_obs_SST_surface_obsloc_GOM(2:12),20,'b','filled'); hold on

scatter(DIN_monthly_GOM(1),monthly_model_SST_surface_obsloc_GOM(1),200,'bp'); hold on
scatter(DIN_monthly_GOM(2:12),monthly_model_SST_surface_obsloc_GOM(2:12),20,'b'); hold on



%scatter(DIN_monthly_GOM(1),SST_monthly_GOM(1),'k.'); hold on


f3=plot(N_surface_WOA_MAB_monthly,T_surface_WOA_MAB_monthly,'r','linewidth',1.3); hold on ;% 
f4=plot(DIN_monthly_MAB,SST_monthly_MAB,'r--','linewidth',1.3); hold on
scatter(N_surface_WOA_MAB_monthly(1),T_surface_WOA_MAB_monthly(1),200,'rp','filled'); hold on
scatter(N_surface_WOA_MAB_monthly(2:12),T_surface_WOA_MAB_monthly(2:12),20,'r','filled'); hold on

scatter(DIN_monthly_MAB(1),SST_monthly_MAB(1),200,'rp'); hold on
scatter(DIN_monthly_MAB(2:12),SST_monthly_MAB(2:12),20,'r'); hold on

quiver(3,4,-1,0,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(1.2,6.2,-0.5,1.2,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(1,20,0.4,-1.6,'r','linewidth',1,'MaxHeadSize',10); hold on
quiver(3.3,10,0.4,-1.6,'r','linewidth',1,'MaxHeadSize',10); hold on

quiver(6,4,-1,0,'b','linewidth',1,'MaxHeadSize',10); hold on
quiver(4,12,1,-1,'b','linewidth',1,'MaxHeadSize',10); hold on
quiver(7,8,1,-1.5,'b','linewidth',1,'MaxHeadSize',10); hold on


legend([f1,f2,f3,f4],{'GoM(obs)';'GoM(model)';'MAB(obs)';'MAB(model)'},'fontsize',12)
text(4,7,'January','Color','r','fontsize',12)
text(7.3,6.2,'January','Color','b','fontsize',12)


xlabel('Nitrogen (mmol/m^3)','fontsize',15);
ylabel('Temp (\circC)','fontsize',15);
set(gca,'fontsize',13)
grid on
saveas(gcf,'TN_cycle.png')

%%%%%%%%%%%%%%%%%%%%%%% plot T_Lim and N_Lim %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GOM_N_Lim_SP_obs=monthly_obs_DIN_surface_obsloc_GOM./(monthly_obs_DIN_surface_obsloc_GOM+0.1);
GOM_N_Lim_LP_obs=monthly_obs_DIN_surface_obsloc_GOM./(monthly_obs_DIN_surface_obsloc_GOM+0.6);
GOM_T_Lim_SP_obs=2.^(monthly_obs_SST_surface_obsloc_GOM./10-2);
GOM_T_Lim_LP_obs=2.^(monthly_obs_SST_surface_obsloc_GOM./10-2);

GOM_N_Lim_SP_model=DIN_monthly_GOM./(DIN_monthly_GOM+0.1);
GOM_N_Lim_LP_model=DIN_monthly_GOM./(DIN_monthly_GOM+0.6);
GOM_T_Lim_SP_model=2.^(monthly_model_SST_surface_obsloc_GOM./10-2);
GOM_T_Lim_LP_model=2.^(monthly_model_SST_surface_obsloc_GOM./10-2);


MAB_N_Lim_SP_obs=N_surface_WOA_MAB_monthly./(N_surface_WOA_MAB_monthly+0.1);
MAB_N_Lim_LP_obs=N_surface_WOA_MAB_monthly./(N_surface_WOA_MAB_monthly+0.6);
MAB_T_Lim_SP_obs=2.^(T_surface_WOA_MAB_monthly./10-2);           
MAB_T_Lim_LP_obs=2.^(T_surface_WOA_MAB_monthly./10-2);           

MAB_N_Lim_SP_model=DIN_monthly_MAB./(DIN_monthly_MAB+0.1);
MAB_N_Lim_LP_model=DIN_monthly_MAB./(DIN_monthly_MAB+0.6);
MAB_T_Lim_SP_model=2.^(SST_monthly_MAB./10-2);           
MAB_T_Lim_LP_model=2.^(SST_monthly_MAB./10-2);           


figure(2) % SP

f1=plot(GOM_N_Lim_SP_obs,GOM_T_Lim_SP_obs,'b','linewidth',1.3); hold on
f2=plot(GOM_N_Lim_SP_model,GOM_T_Lim_SP_model,'b--','linewidth',1.3); hold on
    
scatter(GOM_N_Lim_SP_obs(1),GOM_T_Lim_SP_obs(1),200,'bp','filled'); hold on
scatter(GOM_N_Lim_SP_obs(2:12),GOM_T_Lim_SP_obs(2:12),20,'b','filled'); hold on

scatter(GOM_N_Lim_SP_model(1),GOM_T_Lim_SP_model(1),200,'bp'); hold on
scatter(GOM_N_Lim_SP_model(2:12),GOM_T_Lim_SP_model(2:12),20,'b'); hold on



f3=plot(MAB_N_Lim_SP_obs,MAB_T_Lim_SP_obs,'r','linewidth',1.3); hold on ;% 
f4=plot(MAB_N_Lim_SP_model,MAB_T_Lim_SP_model,'r--','linewidth',1.3); hold on

scatter(MAB_N_Lim_SP_obs(1),MAB_T_Lim_SP_obs(1),200,'rp','filled'); hold on
scatter(MAB_N_Lim_SP_obs(2:12),MAB_T_Lim_SP_obs(2:12),20,'r','filled'); hold on

scatter(MAB_N_Lim_SP_model(1),MAB_T_Lim_SP_model(1),200,'rp'); hold on
scatter(MAB_N_Lim_SP_model(2:12),MAB_T_Lim_SP_model(2:12),20,'r'); hold on

plot([0 1],[0 1],'k','linewidth',1.2); hold on
text(0.1,0.05,'Lim\_T>Lim\_N','fontsize',16)

xlim([0 1])
ylim([0 1.2])
legend([f1,f2,f3,f4],{'GoM(obs)';'GoM(model)';'MAB(obs)';'MAB(model)'},'fontsize',12,'location','northwest')
xlabel('Lim\_N','fontsize',15);
ylabel('Lim\_T','fontsize',15);
set(gca,'fontsize',13)
grid on
saveas(gcf,'SP_TN_limit_cycle.png')

figure(3) % LP

f1=plot(GOM_N_Lim_LP_obs,GOM_T_Lim_LP_obs,'b','linewidth',1.3); hold on
f2=plot(GOM_N_Lim_LP_model,GOM_T_Lim_LP_model,'b--','linewidth',1.3); hold on

scatter(GOM_N_Lim_LP_obs(1),GOM_T_Lim_LP_obs(1),200,'bp','filled'); hold on
scatter(GOM_N_Lim_LP_obs(2:12),GOM_T_Lim_LP_obs(2:12),20,'b','filled'); hold on

scatter(GOM_N_Lim_LP_model(1),GOM_T_Lim_LP_model(1),200,'bp'); hold on
scatter(GOM_N_Lim_LP_model(2:12),GOM_T_Lim_LP_model(2:12),20,'b'); hold on

f3=plot(MAB_N_Lim_LP_obs,MAB_T_Lim_LP_obs,'r','linewidth',1.3); hold on ;% 
f4=plot(MAB_N_Lim_LP_model,MAB_T_Lim_LP_model,'r--','linewidth',1.3); hold on

scatter(MAB_N_Lim_LP_obs(1),MAB_T_Lim_LP_obs(1),200,'rp','filled'); hold on
scatter(MAB_N_Lim_LP_obs(2:12),MAB_T_Lim_LP_obs(2:12),20,'r','filled'); hold on

scatter(MAB_N_Lim_LP_model(1),MAB_T_Lim_LP_model(1),200,'rp'); hold on
scatter(MAB_N_Lim_LP_model(2:12),MAB_T_Lim_LP_model(2:12),20,'r'); hold on

plot([0 1],[0 1],'k','linewidth',1.2)


xlim([0 1])
ylim([0 1.2])
legend([f1,f2,f3,f4],{'GOM(obs)';'GOM(model)';'MAB(obs)';'MAB(model)'},'fontsize',12,'location','northwest')
xlabel('Lim\_N','fontsize',15);
ylabel('Lim\_T','fontsize',15);
set(gca,'fontsize',13)
grid on
saveas(gcf,'LP_TN_limit_cycle.png')
















