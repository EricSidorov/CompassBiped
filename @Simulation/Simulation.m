classdef Simulation
    %SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CB;
        Surf;
        Con;
        mod_states;
        con_states;
        mod_ev;
        con_ev;
        Nev;
        Nstates;
    end
    
    methods
        function Sim = Simulation(Model,Con,Surf)
            Sim.CB = Model;
            Sim.Con = Controller;
            Sim.Surf = Surf;
            Sim.mod_states = 1:Model.Nstates;
            Sim.con_states = (1:Con.Nstates) + Model.Nstates;
            if Model.Nevents>0
                Sim.mod_ev = 1:Model.Nevents;
            else
                Sim.mod_ev = [];
            end
            if Con.Nevents>0
                Sim.con_ev = 1:Con.Nev + Mod.Nevents;
            else
                Sim.con_ev = [];
            end
            Sim.Nev = Model.Nevents+Con.Nevents;
            Sim.Nstates = Model.Nstates+Con.Nstates;
        end
        function dxdt = derivative(Sim,t,x)
            dxdt = zeros(Sim.Nstates,1);
            u = Sim.Con.get_u(t,x);
            x_mod = x(Sim.mod_states);
            x_con = x(Sim.con_states);
            dxdt(Sim.mod_states) = Sim.CB.derivative(t,x_mod,u);
            dxdt(Sim.con_states) = Sim.Con.derivative(t,x_con,x_mod);
        end
        function [value,isterminal,direction] = events(Sim,t,x)
            value = ones(Sim.Nev,1);
            isterminal = ones(Sim.Nev,1);
            direction = ones(Sim.Nev,1);
            x_sw = Sim.CB.get_pos(x(Sim.mod_states),'SW');
            x_sw = x_sw(1);
            y_surf = Sim.Surf.getY(x_sw);
            [value(Sim.mod_ev),isterminal(Sim.mod_ev),direction(Sim.mod_ev)] =...
                Sim.CB.events(t,x(Sim.mod_states),y_surf);
            [value(Sim.con_ev),isterminal(Sim.con_ev),direction(Sim.con_ev)] =...
                Sim.Con.events(t,x(Sim.mod_states)); 
        end
        function [T,X,Te,Ye,Ie] = run(Sim,x0,Tmax,t_step)
            X = [];
            T = [];
            Te = [];
            Ye = [];
            Ie = [];
            Tlast = 0;
            stop = 0;
            opt = odeset('Events',@Sim.events);
            while Tlast<Tmax && ~stop
                [t,x,te,ye,ie] = ode45(@Sim.derivative,Tlast:t_step:Tmax,x0,opt);
                for i=1:length(ie)
                    switch ie(i)
                        case 1
                                [xa,Sim.CB] = Sim.CB.impact_map(x(end,Sim.mod_states)');
                                x(end,Sim.mod_states) = xa;
                        case 2
                            stop = 1;
                    end
                end
                                
                            
                t = t+Tlast;
                T = [T;t];
                X = [X;x];
                Te = [Te;te];
                Ye = [Ye;ye];
                Ie = [Ie;ie];
                Tlast = t(end);
                x0 = x(:,end);
            end
        end
        
    end
    
end

