clc;clear

T=0:0.1:25;

Q10_1=1.4; Q10_2=1.7; Q10_3=2.0; Q10_4=2.3; Q10_5=2.6;

T_lim_1=(Q10_1).^(0.1.*T-2);
T_lim_2=(Q10_2).^(0.1.*T-2);
T_lim_3=(Q10_3).^(0.1.*T-2);
T_lim_4=(Q10_4).^(0.1.*T-2);
T_lim_5=(Q10_5).^(0.1.*T-2);

p1=plot(T,T_lim_1,'r','linewidth',2); hold on
p2=plot(T,T_lim_2,'g','linewidth',2); hold on
p3=plot(T,T_lim_3,'k','linewidth',2); hold on
p4=plot(T,T_lim_4,'b','linewidth',2); hold on
p5=plot(T,T_lim_5,'c','linewidth',2); hold on

grid on;

xlabel('Temp (\circC)','fontsize',16)
ylabel('{\it f}(T)','fontsize',16)

set(gca,'fontsize',16)

legend([p1 p2 p3 p4 p5],{'Q_1_0=1.4';'Q_1_0=1.7';'Q_1_0=2.0';'Q_1_0=2.3';'Q_1_0=2.6'},'location','northwest')

