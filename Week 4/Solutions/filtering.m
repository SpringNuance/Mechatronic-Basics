%Solution example for 4.1
clear all
close all

%Define variables
R=99.3;  
C=54.5e-6; 

f_max = 150;
f=linspace(0,f_max);    %Create x-axis
fc=1/(2*pi*R*C);        %Cutoff frequency

%Calculate gain. Several methods
gain = 1./(sqrt(1+(f./fc).^2)); %Calculate the output voltage with cutoff freq.
gain2 = 1./sqrt(1+(2*pi*f*R*C).^2);  %Or using the R and C (cutoff frequency equation subtituted)

%Plotting with linear scale
figure('Position', [50 300 700 500])
plot(f, gain);
axis([0 f_max 0 1]);
xlabel('frequency [Hz]');
ylabel('k   (V_{out}=kV_{in})');
title {Linear scales}

%Plotting with log frequency scale
figure('Position', [500 300 700 500])
semilogx(f, gain);
axis([0 f_max 0 1]);
xlabel('frequency [Hz] log');
ylabel('k   (V_{out}=kV_{in})');
title {Linear gain scale, logarithmic frequency scale}

%Plotting with log scale
figure('Position', [950 300 700 500])
loglog(f, gain);
axis([0 f_max 0 1]);
xlabel('frequency [Hz] log');
ylabel('k   (V_{out}=kV_{in}) log');
title {Logarithmic gain and frequency scales}




