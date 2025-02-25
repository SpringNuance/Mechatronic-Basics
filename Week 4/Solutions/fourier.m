
clear all
close all
data = textread('data.txt');        %Import data to Matlab workspace
X = data-mean(data);                %Remove zero offset
Fs=11060;                           %Sample rate
NFFT=length(X);                     %number of samples

fft_X=fft(X);                       %Run fast fourier transform
abs_fft_X = abs(fft_X);             %absolute values (fft returns an complex array)


%Plotting
%plot the original data
figure;
t=linspace(0,NFFT/Fs,NFFT);         %from zero to the end of the measurement
plot(t,X);
title('Offset-fixed original data');
xlabel('time [s]');
ylabel('amplitude [mm]');

f = ((0:1/NFFT:1-1/NFFT)*Fs).';                     %frequencies for x-axis
abs_fft_X_scaled = (2/NFFT)*abs_fft_X;              %scaled amplitudes for y-axis

%plot the fft data
figure;
plot(f,abs_fft_X_scaled)
axis([0 100 0 inf]);        % frequencies from 0 to 100Hz
title('Fourier transformed data in frequency domain');
xlabel('frequency [Hz]');
ylabel('amplitude [mm]')

%plot a few periods of the original data
figure;
plot(t,X,'--');
title('Offset-fixed original data and its sinusoidal components');
xlabel('time [s]');
ylabel('amplitude [mm]');
axis([5 5.2 -inf inf]);
hold on
vaihe1=141.1;
vaihe2=106.4;
vaihe3=-35.95;
vaihe4=-144.2;
oneX=0.028*cos(10.8*t*2*pi+vaihe1/180*pi);
twoX=0.1995*cos(21.6*t*2*pi+vaihe2/180*pi);
threeX=0.01198*cos(32.4*t*2*pi+vaihe3/180*pi);
fourX=0.008849*cos(43.2*t*2*pi+vaihe4/180*pi);
plot(t, oneX);
plot(t, twoX);
plot(t, threeX);
plot(t, fourX);
plot(t, oneX+twoX+threeX+fourX,'k');
legend('original','10.8 Hz','21.6 Hz','32.4 Hz','43.2 Hz','SUM');


