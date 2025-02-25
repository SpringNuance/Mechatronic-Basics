%Script for running PIDmotor.slx model and plotting its output data

%DC motor properties: maxon 167131

close all                       %Close old figures
clear                           %Clear workspace variables

%Set model parameters
target_angular_velocity = 280;    %target velocity
r = 0.1;                        %conveyor drum radius
i = 14;                         %gear ratio
R = 1.03;                       %Resistance on the motor coils
L = 0.82*10^-3;                 %Inductance of the motor coils
J = r^2*100/(i^2);              %mass reduced to moment of inertia
Kt = 0.147;                     %Torque coefficient
Ke = 0.147;                     %Back-EMF coefficient
b = 1*10^-3;                    %Damping coefficient
t0 = 40;                        %Initial rotor temperature
C = 30;                          %Heat capacity of the rotor

delay = 0e-3;                   %Transport delay for the feedback loop

%Set controller gains
P = 0.2;                        %Proportional
I = 1.4;                       %Integral


%Run the simulation in Simulink. The parameter must match the filename of
%your model and the active folder in Matlab must be where the model is.
%End time for simulation, variable must used in Simulink model's time settings to have effect
t_end = 1.5;                  
sim('PIDmotor')

%Get data from Simulink "To workspace" blocks and plot it

%Plotting parameters
screensize = get(groot,'ScreenSize');       %Store current screen size for plotting
V_max = 60;                                 %Voltage limit for plotting
V_nom = 48;                                 %nominal voltage        
settling_time_limit = 0.7;                           %Settling time limit for plotting
rise_time_limit = 0.35;                               %Settling time limit for plotting

%Plot the angular velocity
fig1 = figure('Name', 'Motor angular velocity');    %Create a new plot window  
figure(fig1)                                        %Make fig1 plot window active
fig1.OuterPosition=[0 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];   %set figure position on screen
plot(motor_angular_velocity);
hold on
title('Motor angular velocity');
xlabel('Time [s]');
ylabel('Angular velocity [rad/s]');

%Plot the reference lines for velocity
line([settling_time_limit t_end], target_angular_velocity*[1.05 1.05], 'Color', 'r', 'Linestyle', '--')                   %Settling higher line
line([0 t_end], target_angular_velocity*[0.95 0.95], 'Color', 'r', 'Linestyle', '--')                   %Settling lower line
line([0 t_end], [target_angular_velocity target_angular_velocity], 'Color', 'g', 'Linestyle', '--')                    %target velocity line
line([settling_time_limit settling_time_limit], [-1*target_angular_velocity 2*target_angular_velocity], 'Color', 'b', 'Linestyle', '--')%Settling time line
line([rise_time_limit rise_time_limit], [-1*target_angular_velocity 2*target_angular_velocity], 'Color', 'r', 'Linestyle', ':')         %Settling time line
line([0 t_end], target_angular_velocity*[1.25 1.25], 'Color', 'b', 'Linestyle', '--')                   %Overshoot limit line
%Name the reference lines
text(settling_time_limit, target_angular_velocity/2, ' Settling time limit')
text(rise_time_limit, target_angular_velocity/2, ' Rise time limit')
text(rise_time_limit, target_angular_velocity*1.3, ' Overshoot limit')
text(settling_time_limit+1/10, target_angular_velocity*1.1, ' Settling amplitude limits')
%Set figure axes
axis([0 t_end target_angular_velocity*[0 1.4]])                                                         %Set plot axis [xmin xmax ymin ymax]

%Plot PI controller output
fig2 = figure('Name', 'Control');
fig2.OuterPosition=[0 40 screensize(3)/2 screensize(4)/2-20];
plot(control);
hold on                   
plot(proportional, 'r');
plot(integral, 'g');
title('PID output');
ylabel('Voltage [V]');
xlabel('Time [s]');
legend('PI control', 'Proportional part', 'Integral part');
line([0 t_end], [V_max V_max], 'Color', 'r', 'Linestyle', '--')  %max voltage line
line([0 t_end], [V_nom V_nom], 'Color', 'r', 'Linestyle', '-.')  %nominal voltage line
axis([0 t_end -V_max/2 1.5*V_max])

%Plot torque
fig3 = figure('Name', 'Torque');
fig3.OuterPosition=[screensize(3)/2 40 screensize(3)/2 screensize(4)/2-20];  
hold on;
plot(torque_out);
plot(torque_electromagnetic, 'g');      %Extra plot
line([0 t_end], [0 0], 'Color', 'r', 'Linestyle', '--')  %zero torque line
title('Torque');
xlabel('Time [s]');
ylabel('Torque out [Nm]');
legend('Torque out', 'Electromagnetic torque');

%Plot power
fig4 = figure('Name', 'Power');   
fig4.OuterPosition=[screensize(3)/2 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];  
plot(power_in, 'r');
hold on;
plot(power_out, 'b');
plot(resistive_loss_power, 'm');
plot(total_loss_power, 'k');
axis([0 t_end -200 3500])
title('Power');
legend {Input power} {Output power} {Resistive loss} {Total loss};
xlabel('Time [s]');
ylabel('Power [W]');

%Plot temperature
fig5 = figure('Name', 'Temperature');   
fig5.OuterPosition=[screensize(3)/2 40 screensize(3)/2 screensize(4)/2-20]; 
%plot(resistive_loss_energy);
hold on;
temperature = resistive_loss_energy./C+t0;
plot(temperature);
%axis([0 t_end -100 3200])
title('Temperature');
legend Temperature;
xlabel('Time [s]');
ylabel('Power [W] / Energy[J]');