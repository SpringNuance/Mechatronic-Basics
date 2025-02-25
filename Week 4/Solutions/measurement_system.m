close all
clear all

f = 5000;               %Frequency of the original signal
fx = @(x) 6*sin(f*x);   %A function representing the original signal

points_original = 300000;       %Original signal is created with a very high time resolution     
sampling_frequency = 2200;     %Sampling frequency for the measurement signal
plotting_time = 0.004;          %Time scale for plotting the signal

%Create the "sampling points" for the signals
original_sample_times = linspace(0, 0.1, (points_original*0.1+1));
measured_sample_times = linspace(0, 0.1, (sampling_frequency*0.1+1));

original_signal = feval(fx, 2*pi*original_sample_times);
measured_signal = feval(fx, 2*pi*measured_sample_times);

%Plotting
figure('Position', [200 100 1000 800])
plot(original_sample_times, original_signal, 'b')
hold on
plot(measured_sample_times, measured_signal, 'ro')
plot(measured_sample_times, measured_signal, 'r')

title(strcat('Sampling frequency: ', num2str(sampling_frequency), ' Hz'));
xlabel('Time (s)')
ylabel('Amplitude')
legend {Original signal} {Sampling points} {Measured signal}
axis([0 plotting_time -7 7])

