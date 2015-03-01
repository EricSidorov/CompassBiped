classdef ConstSlope < Surface
    %CONSTSLOPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alph
    end
    
    methods
        function Surf = ConstSlope(alph)
            Surf.alph = alph;
        end
        function y = getY(Surf,x)
            y = -tan(Surf.alph)*x;
        end
    end
    
end

