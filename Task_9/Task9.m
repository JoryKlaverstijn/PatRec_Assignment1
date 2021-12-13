%% ROC (5p)
% Each part of the Task can be run separately, by running respective sections.
%% 1.
clc; clear all; close all;

mean(1) = 5;
mean(2) = 7;
mean(3) = 9;
mean(4) = 11;
variance = 4;
std_dev = 2;

x(1) = 6;
x(2) = 0;
x(3) = 2;
x(4) = 8;
x(5) = 11;
x(6) = 12;

lims2 = [x(2) Inf];
lims3 = [x(3) Inf];
lims1 = [x(1) Inf];
lims4 = [x(4) Inf];
lims5 = [x(5) Inf];
lims6 = [x(6) Inf];
    
% False alarm (fa):
cp2 = normcdf(lims2, mean(1), std_dev);
fa(1) = cp2(2) - cp2(1);

cp3 = normcdf(lims3, mean(1), std_dev);
fa(2) = cp3(2) - cp3(1);

cp1 = normcdf(lims1, mean(1), std_dev);
fa(3) = cp1(2) - cp1(1);

cp4 = normcdf(lims4, mean(1), std_dev);
fa(4) = cp4(2) - cp4(1);

cp5 = normcdf(lims5, mean(1), std_dev);
fa(5) = cp4(2) - cp4(1);

cp6 = normcdf(lims6, mean(1), std_dev);
fa(6) = cp5(2) - cp5(1)

% Hit (h1):
cp22 = normcdf(lims2, mean(2), std_dev);
h(1) = cp22(2) - cp22(1);

cp33 = normcdf(lims3, mean(2), std_dev);
h(2) = cp33(2) - cp33(1);

cp11 = normcdf(lims1, mean(2), std_dev);
h(3) = cp11(2) - cp11(1);

cp44 = normcdf(lims4, mean(2), std_dev);
h(4) = cp44(2) - cp44(1);

cp55 = normcdf(lims5, mean(2), std_dev);
h(5) = cp55(2) - cp55(1);

cp66 = normcdf(lims6, mean(2), std_dev);
h(6) = cp66(2) - cp66(1)

% Hit (h2):
cp222 = normcdf(lims2, mean(3), std_dev);
h2(1) = cp222(2) - cp222(1);

cp333 = normcdf(lims3, mean(3), std_dev);
h2(2) = cp333(2) - cp333(1);

cp111 = normcdf(lims1, mean(3), std_dev);
h2(3) = cp111(2) - cp111(1);

cp444 = normcdf(lims4, mean(3), std_dev);
h2(4) = cp444(2) - cp444(1);

cp555 = normcdf(lims5, mean(3), std_dev);
h2(5) = cp555(2) - cp555(1);

cp666 = normcdf(lims6, mean(3), std_dev);
h2(6) = cp666(2) - cp666(1)

% Hit (h3):
cp2222 = normcdf(lims2, mean(4), std_dev);
h3(1) = cp2222(2) - cp2222(1);

cp3333 = normcdf(lims3, mean(4), std_dev);
h3(2) = cp3333(2) - cp3333(1);

cp1111 = normcdf(lims1, mean(4), std_dev);
h3(3) = cp1111(2) - cp1111(1);

cp4444 = normcdf(lims4, mean(4), std_dev);
h3(4) = cp4444(2) - cp4444(1);

cp5555 = normcdf(lims5, mean(4), std_dev);
h3(5) = cp5555(2) - cp5555(1);

cp6666 = normcdf(lims6, mean(4), std_dev);
h3(6) = cp6666(2) - cp6666(1)

%ROC plot
plot(fa,h,'ks-','LineWidth',2,'MarkerSize',10);
title('ROC curve');
xlabel('False Alarm (fa)');
ylabel('Hit (h)');
hold on;
plot(fa,h2,'rs-','LineWidth',2,'MarkerSize',10);
plot(fa,h3,'gs-','LineWidth',2,'MarkerSize',10);
legend('\mu_1 = 5, \mu_2 = 7','\mu_1 = 5, \mu_2 = 9','\mu_1 = 5, \mu_2 = 11','Location','southeast');

%Discriminability
d(1) = abs(mean(1) - mean(2))/std_dev;
d(2) = abs(mean(1) - mean(3))/std_dev;
d(3) = abs(mean(1) - mean(4))/std_dev
%% 2.
clc; clear all; close all;

load task_9.mat
samplesSize = size(outcomes,1);
TPcount = 0;
FNcount = 0;
FPcount = 0;
TNcount = 0;

for i = 1:samplesSize
    
    %TP (hit)
    if isequal(outcomes(i,:),[1 1])          
        TPcount = TPcount + 1;
        
    %FN   
    elseif isequal(outcomes(i,:),[1 0])      
        FNcount = FNcount + 1;
        
    %FP (false alarm)
    elseif isequal(outcomes(i,:),[0 1])      
        FPcount = FPcount + 1; 
        
    %TN
    elseif isequal(outcomes(i,:),[0 0])
        TNcount = TNcount + 1;
    
    end
   
end

P = TPcount + FNcount
N = FPcount + TNcount
hitRate = TPcount/P
falseRate = FPcount/N

% Fitting the ROC curve to the point
mean_h = 10;
mean_fa = 6;
std_dev = 1.8;
x = [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

 for i = 1:size(x,2)
     
     % False alarm:
     cp = normcdf([x(i) Inf], mean_fa, std_dev);
     fa(i) = cp(2) - cp(1);
     
     % Hit:
     cph = normcdf([x(i) Inf], mean_h, std_dev);
     h(i) = cph(2) - cph(1);
        
 end
    
%ROC plot
plot(falseRate,hitRate,'rx-','LineWidth',2,'MarkerSize',10);
hold on;
plot(fa,h,'ks-','LineWidth',2,'MarkerSize',5);
title('ROC curve');
xlabel('False Alarm (fa)');
ylabel('Hit (h)');
legend('Calculated point (fa,h)',['\mu_{hit} = ', num2str(mean_h),...
    '\mu_{false alarm} = ', num2str(mean_fa)], 'Location','southeast');

d0 = abs(mean_h - mean_fa)/std_dev
































