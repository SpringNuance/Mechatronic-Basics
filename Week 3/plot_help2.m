%Script for running PIDmotor.slx model and plotting its output data

%DC motor properties: maxon 167131

close all                       %Close old figures
clear                           %Clear workspace variables


%Initialize simulation parameters here
target_angular_velocity = 280;    %target velocity

%Run the simulation in Simulink. The parameter must match the filename of
%your model and the active folder in Matlab must be where the model is.
%End time for simulation, variable must used in Simulink model's time settings to have effect
t_end = 5.0;      %Change this to suit you            
%sim('PIDmotor')

%Get data from Simulink "To workspace" blocks and plot it

%Plotting parameters
screensize = get(groot,'ScreenSize');       %Store current screen size for plotting
V_max = 60;                                 %Voltage limit for plotting
V_nom = 48;                                 %nominal voltage        
settling_time_limit = 0.7;                  %Settling time limit for plotting
rise_time_limit = 0.35;                     %Rise time limit for plotting

%Plot the angular velocity
fig1 = figure('Name', 'Motor angular velocity');    %Create a new plot window
figure(fig1)                                        %Make fig1 plot window active
fig1.OuterPosition=[0 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];   %set figure position on screen
%plot(%Insert angular velocity variable here");
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
%plot("Controller output here");
hold on                   
%plot("Proportional part here", 'r');
%plot("Integral part here", 'g');
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
%plot("Torque out here");
line([0 t_end], [0 0], 'Color', 'r', 'Linestyle', '--')  %zero torque line
title('Torque');
xlabel('Time [s]');
ylabel('Torque [Nm]');

%Plot power
fig4 = figure('Name', 'Power');   
fig4.OuterPosition=[screensize(3)/2 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20];  
%plot("Power in here", 'r');
hold on;
%plot("Power out here", 'b');
%plot("Resistive loss here", 'm');
%plot("Total power here", 'k');
axis([0 t_end -200 3500])
title('Power');
legend {Input power} {Output power} {Resistive loss} {Total loss};
xlabel('Time [s]');
ylabel('Power [W]');

%Plot temperature
fig5 = figure('Name', 'Temperature');   
fig5.OuterPosition=[screensize(3)/2 40 screensize(3)/2 screensize(4)/2-20]; 
%plot("Resistive loss here if needed");
hold on;
%plot("Temperature here");
title('Temperature');
legend Temperature;
xlabel('Time [s]');
ylabel('Temperature [C]');