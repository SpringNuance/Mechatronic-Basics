%Script for running hydraulic_motor.slx model and plotting its output data

%Hydraulic motor properties: http://www.supdie.com/publications/pdf/Threadformer_Motor_Instruction_Manual.pdf

close all                       %Close old figures
clear                           %Clear workspace variables

%Set model parameters
target_angular_velocity = 210;  %Target angular velocity
r = 0.1;                        %conveyor drum radius
i = 210/20;                     %gear ratio
J = r^2*100/(i^2);              %mass reduced to moment of inertia
b = 1e-3;                       %Damping coefficient

C = 1e-12;                      %Leakage flow conductance
Vr = 8.2e-6                     %Volume per rotation
P_max = 12.5;                   %Pressure limit for the pump [MPa]

delay = 0.0;                    %Transport delay for the feedback loop

%Set controller gains
P = 55000;                       %Proportional
I = 20000;                       %Integral


%Run the simulation in Simulink. The parameter must match the filename of
%your model and the active folder in Matlab must be where the model is.
%End time for simulation, variable must used in Simulink model's time settings to have effect
t_end = 1.5;                  
sim('hydraulic_motor')

%Get data from Simulink "To workspace" blocks and plot it

%Plotting parameters
screensize = get(groot,'ScreenSize');       %Store current screen size for plotting                            %Voltage limit for plotting
settling_time_limit = 0.7;                           %Settling time limit for plotting
rise_time_limit = 0.35;                               %Settling time limit for plotting

%Plot the angular velocity
fig1 = figure('Name', 'Motor angular velocity');                                                                
fig1.OuterPosition=[0 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];   %set figure position on screen
plot(motor_angular_velocity);                                                   
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
plot(control./1e6);
hold on                   
plot(proportional./1e6, 'r');
plot(integral./1e6, 'g');
title('PID output');
ylabel('Pressure [MPa]');
xlabel('Time [s]');
legend('PI control', 'Proportional part', 'Integral part');
line([0 t_end], [P_max P_max], 'Color', 'r', 'Linestyle', '--')  %max voltage line
axis([0 t_end -P_max/4 1.3*P_max])

%Plot torque
fig3 = figure('Name', 'Torque');
fig3.OuterPosition=[screensize(3)/2 40 screensize(3)/2 screensize(4)/2-20];  
hold on;
plot(torque_out);
plot(torque_hydraulic, 'g');      %Extra plot
line([0 t_end], [0 0], 'Color', 'r', 'Linestyle', '--')  %zero torque line
title('Torque');
xlabel('Time [s]');
ylabel('Torque out [Nm]');
legend('Torque out', 'Hydraulic torque');

%Plot power
fig4 = figure('Name', 'Power');   
fig4.OuterPosition=[screensize(3)/2 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];  
plot(power_in, 'r');
hold on;
plot(power_out, 'b');
plot(power_loss_volumetric, 'g');
plot(power_loss_hydromechanical, 'k');
axis([0 t_end -200 1000])
title('Power');
legend {Input power} {Output power} {Volumetric loss power} {Hydromechanical loss};
xlabel('Time [s]');
ylabel('Power [W]');

%Plot Efficiency
% fig4 = figure('Name', 'Efficiency');   
% fig4.OuterPosition=[screensize(3)/2 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];  
% plot(power_in.time, power_out.data./power_in.data, 'r');
% axis([0 t_end 0 1])
% title('Efficiency');
% legend Efficiency;
% xlabel('Time [s]');
% ylabel('Efficiency');
