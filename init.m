alt = [260*ones(1,3000), [260:0.01:280], 280*ones(1,1000), [280:-0.005:270], 270*ones(1,3000)];
alt_smoothed = smooth(alt,30);

T_s = 0.02;
t =[T_s:T_s:(length(alt))*T_s];
start_time = T_s;
stop_time = t(end);

vel = 1/T_s*diff(alt_smoothed);

linAcc = 1/T_s*diff(vel);
linAcc_in = [t;...
             0 0 linAcc']';
         
linAcc_in_noise = [t;...
                   0 0 linAcc'+0.05*randn(1,length(linAcc))]';

vel_in = [t;...
          0 vel']';
           
altEst_in = [t;...
             alt_smoothed']';
         
altEst_in_noise = [t;...
                   alt_smoothed'+0.5*randn(1,length(alt_smoothed))]';
               
altEst_in_noise_discr = discretize(altEst_in_noise,[200:0.2:300],[200.2:0.2:300]);  
            
altEst_in_nonstat_noise = [t;...
                           alt_smoothed'+2*sin(2*pi*t*0.01)+randn(1,length(alt_smoothed))]';
                       
artifact = zeros(1,length(t));
artifact(5500:5510) = [0.1 0.2 0.5 0.9 1.8 0.6 0.45 0.3 0.2 0.1 0.05]*5;

altEst_in_noise_artifact = [t;...
                           alt_smoothed'+randn(1,length(alt_smoothed))+artifact]';
                       

dec = [2:-0.02:0.12];
artifact2 = zeros(1,length(t));
artifact2(5500:5600) = [0.1 0.2 0.5 0.9 1.8 2 dec]*5;

altEst_in_noise_artifact2 = [t;...
                           alt_smoothed'+randn(1,length(alt_smoothed))+artifact2]';
  
velEst_in_vec = 1/T_s*diff(GetMedian(altEst_in(:,2),50));

velEst_in = [t;...
             0 1/T_s*diff(GetMedian(altEst_in(:,2),50))]';
         
velEst_in_noise = [t;...
             0 1/T_s*diff(GetMedian(altEst_in_noise_discr(:,2),50))]';
              
%              %Geschätzte Geschwindigkeit aus Höhe! 
%          
%% real data   
% load('stream_Do_Dez_7_2017_20_38_56.mat');
% 
% start_time = 142;
% stop_time = 158;
% 
% linAcc_real = (smm62.zAcc - mean(smm62.zAcc(1:100)))*9.81;
% altitude_real = (288.15/0.0065) .* (1-(smm62.PressureComp/101325).^(1/5.255));  % barometrische Höhenformel!! 
% 
% linAcc_in_real = [smm62.time';...
%                   linAcc_real']';
%          
% altEst_in_real = [smm62.time';...
%                   altitude_real']';
% 
% velEst_in_real = [smm62.time';...
%                   [0 diff(smm62.time').*diff(GetMedian(altEst_in_real(:,2),50))]]';
%               
% figure;
% subplot(3,1,1);
% plot(smm62.time, linAcc_in_real(:,2));y
% subplot(3,1,2);
% plot(smm62.time, velEst_in_real(:,2));
% subplot(3,1,3);
% plot(smm62.time, altEst_in_real(:,2));
