alt = [260*ones(1,3000), [260:0.01:280], 280*ones(1,1000), [280:-0.005:270], 270*ones(1,3000)];
alt_smoothed = smooth(alt,30);
% 
T_s = 0.02;
t =[T_s:T_s:(length(alt))*T_s];
% start_time = T_s;
% stop_time = t(end);

vel_1 = 1/T_s*diff(alt_smoothed);

linAcc = 1/T_s*diff(vel_1);
linAcc_in = [t;...
             0 0 linAcc']';
         
linAcc_in_noise = [t;...
                   0 0 linAcc'+0.05*randn(1,length(linAcc))]';

vel_in = [t;...
          0 vel_1']';
           
altEst_in = [t;...
             alt_smoothed']';
         
altEst_in_noise = [t;...
                   alt_smoothed'+0.5.*randn(1,length(alt_smoothed))]';
               
altEst_in_noise_discr = [altEst_in_noise(:,1), ...
               discretize(altEst_in_noise(:,2),[200:0.2:300],[200.2:0.2:300])];  
            
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
load('dataset1.mat');

start_time = dataset.time(1);
stop_time = dataset.time(end);
T_s = 0.0246;

stable_start = 100; % start/ende für Kov. und mean Berechnung
stable_end = 1100;

scaling = 2^(15);
linAcc_real = (dataset.zLinAcc / scaling);
% mean abziehen, um Drift zu minimieren.
linAcc_real = linAcc_real - mean(linAcc_real(stable_start:stable_end));

% barometrische Höhenformel!! 
altitude_real = (288.15/0.0065) .* (1-(dataset.PressureComp/101325).^(1/5.255));
% Werte von Barometer auf 0 anpassen. 
alt_real = altitude_real - altitude_real(1);

linAcc_in_real = [dataset.time';...
                  linAcc_real']';
         
altEst_in_real = [dataset.time';...
                  alt_real']';

velEst_in_real = [dataset.time';...
                  [0 diff(dataset.time').*diff(altEst_in_real(:,2))'] ]';

%Wert zur "kontrolle" (zweifach Ableitung von Höhe)              
accEst_in_real = [dataset.time';...
                  [0 diff(dataset.time').*diff(velEst_in_real(:,2))'] ]';
              
linVel_in_real = cumsum(linAcc_real');
linAlt_in_real = cumsum(linVel_in_real);
linAlt_in_real = linAlt_in_real;

%Kovarianzmatrizen Q und R berechnen
Est_Q = cov(linVel_in_real(stable_start:stable_end),linAlt_in_real(stable_start:stable_end))
Est_R = cov(velEst_in_real(stable_start:stable_end,2), altEst_in_real(stable_start:stable_end,2))

% %   
 close all
figure();
% subplot(3,1,1);
% plot(dataset.time, linAcc_in_real(:,2));
% hold on
% plot(dataset.time, accEst_in_real(:,2));
% subplot(3,1,2);
% plot(dataset.time, linVel_in_real);
% hold on
% plot(dataset.time, velEst_in_real(:,2));
% subplot(3,1,3);
% plot(dataset.time, linAlt_in_real);
% hold on
 plot(dataset.time, altEst_in_real(:,2));
