%function for simulating the system with different g values

function t=gsimulate(g)

%define spesifications:
    m=100;
    Tmax=5;
    nmax=6000;
    Jr=32*10^-4;
    p=4*10^-3;
    Js=90*10^-4;
    wmax=2*pi*(nmax/60);

    %calculate needed values for each g:
    Jred=Jr+((Js+((m*p^2)/(4*pi^2)))/g^2);

    %set the source for simulation parameters inside this function
    options=simset('SrcWorkspace','current','MaxStep','0.0001');

    %simulation for current i:
    sim('dynamics',[],options);

    %return the simulation time (last value of tout vector)
    t=tout(end);
end