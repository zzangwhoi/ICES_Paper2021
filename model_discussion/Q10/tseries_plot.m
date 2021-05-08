%% tseries plot
clc;clear

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
  mask_GOM_365=repmat(mask_GOM,[1,365]);

   h_mask=h_gom3;h_mask(h_mask<20 | h_mask >500)=NaN; h_mask(~isnan(h_mask))=1;
  mask_MAB=double(inpolygon(lon_gom3,lat_gom3,lon_MAB,lat_MAB));mask_MAB(mask_MAB~=1)=NaN;
 mask_MAB=mask_MAB.*h_mask;
 mask_MAB_365=repmat(mask_MAB,[1,365]);

 %% load sensi tests output
 
 load('./chl_Q10_1p4_top10m_daily.mat')
 load('./chl_Q10_1p7_top10m_daily.mat')
 load('./chl_Q10_2p3_top10m_daily.mat')
 load('./chl_Q10_2p6_top10m_daily.mat')
 data_name=['/Users/zhengchenzang/Documents/benchmark_noPbury2_model_result/lowremi/CHL/0_10m/chl_1978_top10m_daily.mat'];
load(data_name)
 data_Q10_1p4_GOM=nanmean(chl_Q10_1p4_top10m_daily.*mask_GOM_365,1);
 data_Q10_1p7_GOM=nanmean(chl_Q10_1p7_top10m_daily.*mask_GOM_365,1);
 data_Q10_2p3_GOM=nanmean(chl_Q10_2p3_top10m_daily.*mask_GOM_365,1);
 data_Q10_2p6_GOM=nanmean(chl_Q10_2p6_top10m_daily.*mask_GOM_365,1);
 data_Q10_2p0_GOM=nanmean(chl_1978_top10m_daily.*mask_GOM_365,1);

 
 data_Q10_1p4_GOM=gausscorr(data_Q10_1p4_GOM',8);
 data_Q10_1p7_GOM=gausscorr(data_Q10_1p7_GOM',8);
 data_Q10_2p3_GOM=gausscorr(data_Q10_2p3_GOM',8);
 data_Q10_2p6_GOM=gausscorr(data_Q10_2p6_GOM',8);
 data_Q10_2p0_GOM=gausscorr(data_Q10_2p0_GOM',8);

 
 data_Q10_1p4_MAB=nanmean(chl_Q10_1p4_top10m_daily.*mask_MAB_365,1);
 data_Q10_1p7_MAB=nanmean(chl_Q10_1p7_top10m_daily.*mask_MAB_365,1);
 data_Q10_2p3_MAB=nanmean(chl_Q10_2p3_top10m_daily.*mask_MAB_365,1);
 data_Q10_2p6_MAB=nanmean(chl_Q10_2p6_top10m_daily.*mask_MAB_365,1);
 data_Q10_2p0_MAB=nanmean(chl_1978_top10m_daily.*mask_MAB_365,1);

 
 data_Q10_1p4_MAB=gausscorr(data_Q10_1p4_MAB',8);
 data_Q10_1p7_MAB=gausscorr(data_Q10_1p7_MAB',8);
 data_Q10_2p3_MAB=gausscorr(data_Q10_2p3_MAB',8);
 data_Q10_2p6_MAB=gausscorr(data_Q10_2p6_MAB',8);
 data_Q10_2p0_MAB=gausscorr(data_Q10_2p0_MAB',8);
 

%%%%%%%%%%%%%%%%%%%%% spring bloom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1_spring=find(data_Q10_1p4_GOM(1:150)==max(data_Q10_1p4_GOM(1:150)));
t2_spring=find(data_Q10_1p7_GOM(1:150)==max(data_Q10_1p7_GOM(1:150)));
t3_spring=find(data_Q10_2p0_GOM(1:150)==max(data_Q10_2p0_GOM(1:150)));
t4_spring=find(data_Q10_2p3_GOM(1:150)==max(data_Q10_2p3_GOM(1:150)));
t5_spring=find(data_Q10_2p6_GOM(1:150)==max(data_Q10_2p6_GOM(1:150)));

m1_spring=data_Q10_1p4_GOM(t1_spring);
m2_spring=data_Q10_1p7_GOM(t2_spring); 
m3_spring=data_Q10_2p0_GOM(t3_spring); 
m4_spring=data_Q10_2p3_GOM(t4_spring); 
m5_spring=data_Q10_2p6_GOM(t5_spring); 

t6_spring=find(data_Q10_1p4_MAB(1:150)==max(data_Q10_1p4_MAB(1:150)))
t7_spring=find(data_Q10_1p7_MAB(1:150)==max(data_Q10_1p7_MAB(1:150)))
t8_spring=find(data_Q10_2p0_MAB(1:150)==max(data_Q10_2p0_MAB(1:150)))
t9_spring=find(data_Q10_2p3_MAB(1:150)==max(data_Q10_2p3_MAB(1:150)))
t10_spring=find(data_Q10_2p6_MAB(1:150)==max(data_Q10_2p6_MAB(1:150)))

m6_spring=data_Q10_1p4_MAB(t6_spring);
m7_spring=data_Q10_1p7_MAB(t7_spring) ;
m8_spring=data_Q10_2p0_MAB(t8_spring) ;
m9_spring=data_Q10_2p3_MAB(t9_spring) ;
m10_spring=data_Q10_2p6_MAB(t10_spring) ;

%%%%%%%%%%%%%%%%%%%%% fall bloom %%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1=find(data_Q10_1p4_GOM(210:360)==max(data_Q10_1p4_GOM(210:360))); t1_fall=t1+210-1;
t2=find(data_Q10_1p7_GOM(210:360)==max(data_Q10_1p7_GOM(210:360))); t2_fall=t2+210-1;
t3=find(data_Q10_2p0_GOM(210:360)==max(data_Q10_2p0_GOM(210:360))); t3_fall=t3+210-1;
t4=find(data_Q10_2p3_GOM(210:360)==max(data_Q10_2p3_GOM(210:360))); t4_fall=t4+210-1;
t5=find(data_Q10_2p6_GOM(210:360)==max(data_Q10_2p6_GOM(210:360))); t5_fall=t5+210-1;

m1_fall=data_Q10_1p4_GOM(t1_fall);
m2_fall=data_Q10_1p7_GOM(t2_fall) ;
m3_fall=data_Q10_2p0_GOM(t3_fall) ;
m4_fall=data_Q10_2p3_GOM(t4_fall) ;
m5_fall=data_Q10_2p6_GOM(t5_fall) ;

t6=find(data_Q10_1p4_MAB(210:360)==max(data_Q10_1p4_MAB(210:360))); t6_fall=t6+210-1;
t7=find(data_Q10_1p7_MAB(210:360)==max(data_Q10_1p7_MAB(210:360))); t7_fall=t7+210-1;
t8=find(data_Q10_2p0_MAB(210:360)==max(data_Q10_2p0_MAB(210:360))); t8_fall=t8+210-1;
t9=find(data_Q10_2p3_MAB(210:360)==max(data_Q10_2p3_MAB(210:360))); t9_fall=t9+210-1;
t10=find(data_Q10_2p6_MAB(210:360)==max(data_Q10_2p6_MAB(210:360))); t10_fall=t10+210-1;

m6_fall=data_Q10_1p4_MAB(t6_fall);
m7_fall=data_Q10_1p7_MAB(t7_fall) ;
m8_fall=data_Q10_2p0_MAB(t8_fall) ;
m9_fall=data_Q10_2p3_MAB(t9_fall) ;
m10_fall=data_Q10_2p6_MAB(t10_fall) ;

%%%%%%% plot %%%%%%%
ha=tight_subplot(2,2,[.1 .1],[.1 .02],[.08 .03])
Xtick=[1,32,60,91,121,152,182,213,244,274,305,335];
Xticklabel={'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12'};

for sr=1:4
switch sr
    case 1
    axes(ha(sr));
plot(data_Q10_1p4_GOM,'r','linewidth',1.5); hold on;
plot(data_Q10_1p7_GOM,'g','linewidth',1.5); hold on;
plot(data_Q10_2p0_GOM,'k','linewidth',1.5); hold on;
plot(data_Q10_2p3_GOM,'b','linewidth',1.5); hold on;
plot(data_Q10_2p6_GOM,'c','linewidth',1.5); hold on;
xlim([1 365]); ylim([0 8])
set(gca,'Xtick',Xtick,'Xticklabel',Xticklabel,'Ytick',[0:2:8],'fontsize',14)
grid on
ylabel('Chl (mg/m^3)','fontsize',14)
text(1.2,7.5,'(a) GoM','fontsize',18)
xlabel('Month','fontsize',14)

    case 2
    axes(ha(sr));
plot(data_Q10_1p4_MAB,'r','linewidth',1.5); hold on;
plot(data_Q10_1p7_MAB,'g','linewidth',1.5); hold on;
plot(data_Q10_2p0_MAB,'k','linewidth',1.5); hold on;        
plot(data_Q10_2p3_MAB,'b','linewidth',1.5); hold on;
plot(data_Q10_2p6_MAB,'c','linewidth',1.5); hold on;
xlim([1 365]); ylim([0 8])
set(gca,'Xtick',Xtick,'Xticklabel',Xticklabel,'Ytick',[0:2:8],'fontsize',14)
grid on
xlabel('Month','fontsize',14)
ylabel('Chl (mg/m^3)','fontsize',14)
text(1.2,7.5,'(b) MAB','fontsize',18)

legend({'Q_1_0=1.4 (test1)';'Q_1_0=1.7 (test2)';'Q_1_0=2.0 (benchmark)';'Q_1_0=2.3 (test3)';'Q_1_0=2.6 (test4)'},'fontsize',12)


    case 3
    axes(ha(sr));

        plot(1:5,[t1_spring,t2_spring,t3_spring,t4_spring,t5_spring],'b','linewidth',1.5); hold on
        plot(1:5,[t6_spring,t7_spring,t8_spring,t9_spring,t10_spring],'r','linewidth',1.5); hold on
        plot(1:5,[t1_fall-50,t2_fall-50,t3_fall-50,t4_fall-50,t5_fall-50],'b--','linewidth',1.5); hold on
        plot(1:5,[t6_fall-50,t7_fall-50,t8_fall-50,t9_fall-50,t10_fall-50],'r--','linewidth',1.5); hold on    
        
        plot([1,1],[150,200],'w'); hold on
        plot([1.001,1.001],[150,175],'k','linewidth',0.4); hold on
        plot([1.001,1.001],[180,200],'k','linewidth',0.4); hold on
        plot([5,5],[150,200],'w'); hold on
        plot([5,5],[150,175],'k','linewidth',0.4); hold on
        plot([5,5],[180,200],'k','linewidth',0.4); hold on        
        
        ylim([50 250])
        grid on
        set(gca,'Yticklabel',{'50';'100';'150';'250';'300'},'Xticklabel',{'1.4';'1.7';'2.0';'2.3';'2.6'},'fontsize',14)
        xlabel('Q_1_0','fontsize',14)
        ylabel('Julian Day','fontsize',14)

        text(1.01,240,'(c) Bloom Timing','fontsize',18)

    case 4
    axes(ha(sr));
        plot(1:5,[m1_spring,m2_spring,m3_spring,m4_spring,m5_spring],'b','linewidth',1.5); hold on
        plot(1:5,[m6_spring,m7_spring,m8_spring,m9_spring,m10_spring],'r','linewidth',1.5); hold on
        plot(1:5,[m1_fall,m2_fall,m3_fall,m4_fall,m5_fall],'b--','linewidth',1.5); hold on
        plot(1:5,[m6_fall,m7_fall,m8_fall,m9_fall,m10_fall],'r--','linewidth',1.5); hold on        

        grid on
        set(gca,'Xticklabel',{'1.4';'1.7';'2.0';'2.3';'2.6'},'fontsize',14)
        xlabel('Q_1_0','fontsize',14)
        ylabel('Chl (mg/m^3)','fontsize',14)
        ylim([1 7])
        text(1.01,6.7,'(d) Magnitude','fontsize',18)

legend({'Spring Bloom (GoM)';'Spring Bloom (MAB)';'Fall Bloom (GoM)';'Fall Bloom (MAB)'},'fontsize',12)

end

end
axes(gcf,'Position',[0.07,0.338,0.02,0.02])
plot([-1:1:1],[1,1.7,2.4],'k','linewidth',1.2);hold on; box off; axis off
plot([-1:1:1],[1.7,2.4,3.1],'k','linewidth',1.2);

axes(gcf,'Position',[0.465,0.338,0.02,0.02])
plot([-1:1:1],[1,1.7,2.4],'k','linewidth',1.2);hold on; box off; axis off
plot([-1:1:1],[1.7,2.4,3.1],'k','linewidth',1.2);


set(gcf,'Position',[0,0,700,500])
print(gcf,'chl_tseries_Q10test','-dpng','-r200')

