classdef PassiveCon < Controller
    %PASSIVECON Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function Con = PassiveCon()
            Con.Nstates = 0;
            Con.Nevents = 0;
        end
        function u = get_u(Con,x_con,x_mod)
            u = 0;
        end
    end
    
end

