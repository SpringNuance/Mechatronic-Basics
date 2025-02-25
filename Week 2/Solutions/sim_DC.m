% Clear figures and variables
clear all
close all

plot_for_Q5 = 0;   %Set to 1 for plotting graphs for question 5

%Simulation variables
b = 0.001;
K_e = 0.147;
K_t = 0.147;
R = 1.03;
L = 0.82e-3;
target_mass_vel = 2;          
r = 0.1;
m = 100;
i = 210/15;

target_ang_vel = (target_mass_vel/r)*i;     %Target angular velocity of the motor

%Inertia of the mass can be thought of as a point at the radius of the pulley
J_mass = m*r^2; % m^2 kg

%Reducing the inertia to the motor shaft
J = J_mass/(i^2); % m^2 kg

%Determine the needed voltage to move mass at 2 m/s
I=(b*target_ang_vel)/K_t;
V = K_e*target_ang_vel+R*I;                   %Voltage step

%If plotting for question 5
if plot_for_Q5
    V = 10;            
end

accuracy = 0.99;                            %Accuracy of determining steady state     

sim('motor');                               %Run the simulation

%Find the first data point where steady state is reached      
index = find(mass_velocity.data>(accuracy*target_mass_vel),1);
%Find the time when steady state is reached
final_s = mass_velocity.Time(index);

%Get screensize to plot the figures nicely
screensize = get(groot,'ScreenSize');
t_end = 2;          %time scale

%Question 4
if not(plot_for_Q5)
    figure('Name','Mass Velocity','OuterPosition',[0 40 screensize(3)/2 screensize(4)/2-20])
        h_ax=axes;
        set(gca,'FontSize',12);
        plot(mass_velocity);
        hold on;
        title('Mass velocity');
        xlabel('Time (s)');
        ylabel('Mass velocity (m/s)');
        axis([0, t_end, 0, 1.2*target_mass_vel]);
        line([final_s final_s],[0 1000],'Color','r');
        line([0 1000],[target_mass_vel target_mass_vel],'Color','g','LineStyle','--');

    figure('Name','Mass Displacement','OuterPosition',[screensize(3)/2 screensize(4)/2+20 screensize(3)/2 screensize(4)/2-20])
        set(gca,'FontSize',12);
        plot(mass_displacement);
        hold on;
        title('Displacement');
        xlabel('Time (s)');
        ylabel('Displacement (m)');
        axis([0, t_end, 0, 5]);


    figure('Name','Mass Acceleration','OuterPosition',[screensize(3)/2 40 screensize(3)/2 screensize(4)/2-20])
        set(gca,'FontSize',12);
        plot(mass_acceleration)
        title('Mass Acceleration');
        xlabel('Time (s)');
        ylabel('Acceleration (m^2/s)');
        axis([0, t_end, 0, 10]);
end
    
%Question 5
%Vectors containing the requested data for each time instant
if plot_for_Q5
    P_in = V.*current.data;                             %Input power
    P_out = motor_output_torque.data.*motor_angular_velocity.data;   %Output power
    P_res = R.*current.data.^2;                         %Resistive losses
    P_damping = motor_friction.data.*motor_angular_velocity.data;   %Friction losses, extra info
    efficiency = P_out./P_in;                           %Efficiency
    
    
    figure('Name','Powers','Position',[200 50 500 400]), hold on
        %h_ax=axes;
        %set(gca,'FontSize',12);
        plot(motor_angular_velocity.data, P_in, 'k')
        plot(motor_angular_velocity.data, P_out, 'b')
        plot(motor_angular_velocity.data, P_res, 'r')
        plot(motor_angular_velocity.data, P_damping, 'g')
        title('Powers');
        xlabel('Angular velocity (rad)');
        ylabel('Power (W)');
        legend('Input power', 'Output power', 'Resistive loss power', 'Damping loss power')

    figure('Name','Torque/Efficiency','Position',[800 50 500 400]), hold on
        %h_ax=axes;
        %set(gca,'FontSize',12);
        plot(motor_angular_velocity.data, motor_output_torque.data, 'b')
        plot(motor_angular_velocity.data, efficiency, 'r')
        title('Torque/Efficiency');
        xlabel('Angular velocity (rad)');
        ylabel('Torque/Efficiency (Nm/1)');
        legend('Torque', 'Efficiency')
end