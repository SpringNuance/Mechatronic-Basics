%Solution script for dynamics optimizing. Uses also implemented function 
%gsimulate.m. 
clear all
close all

%Solve the g value that minimizes the time elapsed during the task.
%fminbnd(@func,lower,upper) is a built-in function that finds the input 
%value between limits 'lower' and 'upper' that minimizes function 'func'. 
[g t]=fminbnd(@gsimulate,0,2)     

%Simulate once again to get proper plots:
m=100;
Tmax=5;
nmax=6000;
Jr=32*10^-4;
p=4*10^-3;
Js=90*10^-4;
Jred=Jr+((Js+((m*p^2)/(4*pi^2)))/g^2);
wmax=2*pi*(nmax/60);
options=simset('MaxStep','0.0001');
sim('dynamics',[],options);

%Plots
screensize = get(groot,'ScreenSize');   %get the screensize to place the plots on screen nicely
fig1=figure('Name','Velocity');
fig1.OuterPosition=[0 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];   %place the plot on screen
plot(velocity);
title('Velocity');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
axis([0 5 0 1])
fig2=figure('Name','Displacement');
fig2.OuterPosition=[0 40 screensize(3)/2 screensize(4)/2-20];
plot(displacement);
title('Displacement');
xlabel('Time [s]');
ylabel('Place [m]');