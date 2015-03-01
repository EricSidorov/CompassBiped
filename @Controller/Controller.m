classdef Controller
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nstates;
        Nevents;
    end
    
    methods
        function Con = Controller()
        end
        function dxdt = derivative(Con,t,x,u)
            dxdt = zeros(size(x));
        end
        function u = get_u(Con,t,x_con,x_mod)
            u = 0;
        end
        function [value,isterminal,direction] = events(Con,t,x)
            value=[];
            isterminal=[];
            direction=[];
        end
    end
    
end

