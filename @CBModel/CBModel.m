classdef CBModel
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        l=1;
        a=0.5
        m=1;
        mh=10;
        g=9.8;
        x_stance = [0;0];
        Nstates = 4;
        Nevents = 2;
    end
    
    methods
        function CB = CBModel()
            return 
        end
        function [H,C,G] = get_mat(CB,x)
            
            m = CB.m;
            l = CB.l;
            a = CB.a;
            b = l-a;
            g = CB.g;
            mh = CB.mh;
            
            th1 = x(1);
            th2 = x(2);
            dth1 = x(3);
            dth2 = x(4);
            
            H = [m*b^2, -m*l*b*cos(th1-th2);
                0,(mh+m)*l^2+m*a^2];
            H(2,1)=H(1,2);
            C = [0, -m*l*b*sin(th1-th2)*dth1;
                -m*l*b*sin(th1-th2)*dth2, 0];
            G = [m*b*g*sin(th2); -(mh*l+m*a+m*l)*g*sin(th1)];
        end
        function dxdt = derivative(CB,t,x,u)
            [H,C,G] = CB.get_mat(x);
            B = [1;-1];
            F = -H\(B*u-C*x(3:4)-G);
            dxdt = [x(3:4);F];
        end
        
        function [value,isterminal,direction] = events(CB,t,x,y_surf)
            if x(1) < 0
                x_sw = CB.get_pos(x,'SW');
                value(1) = x_sw(2)-y_surf;
            else
                value(1) = 1;
            end
            value(2) = cos(x(1))-0.75;
            isterminal = 1;
            direction = [-1;-1];
        end
        
        function [xa,CB] = impact_map(CB,xb)
            xa = xb;
            m = CB.m;
            l = CB.l;
            a = CB.a;
            b = l-a;
            g = CB.g;
            mh = CB.mh;
            alph = (xb(2)-xb(1))/2;
            xa(1:2) = [xb(2);xb(1)];
            Q1=[-m*a*b, -m*a*b+(mh*l^2+2*m*a*l)*cos(2*alph);
                0, -m*a*b];
            Q2=[m*b*(b-l*cos(2*alph)), m*l*(l-b*cos(2*alph))+m*a^2+mh*l^2;
                m*b^2, -m*b*l*cos(2*alph)];
            xa(3:4) = Q2\Q1*xb(3:4);
            CB.x_stance = CB.get_pos(xb,'SW');
        end
        function pos = get_pos(CB,x,link)
%             x = x';
            r_st = diag(CB.x_stance)*ones(2,size(x,2));
            r_h = r_st + CB.l*[-sin(x(1,:));cos(x(1,:))];
            r_sw = r_h + CB.l*[sin(x(2,:));-cos(x(2,:))];
            switch link
                case 'SW'
                    pos = r_sw;
                case 'ST'
                    pos = r_st;
                case 'Hip'
                    pos = r_h;
            end
        end
            
    end
    
end

