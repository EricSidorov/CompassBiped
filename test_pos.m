Mdl = CBModel();
slope = 0.5;
l=1;
Mdl.x_stance = [cos(slope);-sin(slope)]*0.0;
x = [-10;-5;0;0]*pi/180;
x0 = Mdl.get_pos(x,'ST');
x1 = Mdl.get_pos(x,'Hip');
x2 = Mdl.get_pos(x,'SW');
line([x0(1),x1(1)],[x0(2),x1(2)]);
line([x1(1),x2(1)],[x1(2),x2(2)]);
line([x0(1),x1(1)],[x0(2),x1(2)]);
line([x0(1)-l*cos(slope),x0(1)+l*cos(slope)],[x0(2)+l*sin(slope),x0(2)-l*sin(slope)],...
    'Color','g');
axis equal