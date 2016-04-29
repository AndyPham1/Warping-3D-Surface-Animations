function main()
%set up for surface functions and create 3d mesh
xmin = -2;
ymin = -2;
ymax = 2;
xmax = 2;
x = -2.0:0.05:2.0;
y = -2.0:0.05:2.0;
[X,Y] = meshgrid(x,y)
Z1 = 2*X.^2+2*Y.^2;
Z2 = -2*X.^2+2*Y.^2;
Z3 = -2*X.^2-2*Y.^2;
Z4 = 2*X.^2-2*Y.^2;
%set up numerical Integration
function1 = @(X,Y)(2*X.^2+2*Y.^2);
num_area1 = integral2(function1,xmin,xmax,ymin,ymax)
function2 = @(X,Y)(-2*X.^2+2*Y.^2);
num_area2 = integral2(function2,xmin,xmax,ymin,ymax)
function3 = @(X,Y)(-2*X.^2-2*Y.^2);
num_area3 = integral2(function3,xmin,xmax,ymin,ymax)
function4 = @(X,Y)(2*X.^2-2*Y.^2);
num_area4 = integral2(function4,xmin,xmax,ymin,ymax)
%set up symbolic Integration
syms f1 f2 f3 f4 x y
f1=2*x^2+2*y^2;
sym_area1=eval(int(int(f1,y,ymin,ymax),x,xmin,xmax));
f2=-2*x.^2+2*y.^2;
sym_area2=eval(int(int(f2,y,ymin,ymax),x,xmin,xmax));
f3=-2*x.^2-2*y.^2
sym_area3=eval(int(int(f3,y,ymin,ymax),x,xmin,xmax));
f4=2*x.^2-2*y.^2
sym_area4=eval(int(int(f4,y,ymin,ymax),x,xmin,xmax));
%Adjust Screen
set(0,'units','pixels');
screenSizePixels=get(0,'screensize');
screenWidth=screenSizePixels(3);
screenHeight=screenSizePixels(4);
figureAspectRatio=3/4; % height to width
figureHeight=screenHeight*0.75;
figureWidth=screenHeight*1.0/figureAspectRatio;
% shift left 5% of the screen width
leftx=screenWidth*0.05;
% shift up 15% of the screen height
lefty=screenHeight*0.15;
h5=figure;
set(h5,'Position',[leftx lefty figureWidth figureHeight]);
%warp between z1,z2,z3,z4 and back to z1
warp(Z1,Z2,num_area1,num_area2,sym_area1,sym_area2,X,Y)
warp(Z2,Z3,num_area2,num_area3,sym_area2,sym_area3,X,Y)
warp(Z3,Z4,num_area3,num_area4,sym_area3,sym_area4,X,Y)
warp(Z4,Z1,num_area4,num_area1,sym_area4,sym_area1,X,Y)
end
%function to create animation given to surface function
function warp(Za,Zb,num_area1,num_area2,sym_area1,sym_area2,X,Y)
% name variables and use for axis frame
xmin = -2;
ymin = -2;
ymax = 2;
xmax = 2;
zmin = -4;
zmax = 4;
%loop through animation
for t=0.0:0.01:1.0
    Z=Za*(1-t)+Zb*(t);
    mesh(X,Y,Z)
    axis([xmin xmax ymin ymax zmin zmax]);
    %edit numeric and symbolic integration
    text(-3,2,7,['\fontsize{10} \color{cyan} ' ...
    'Numerical Integration: '...
    sprintf('%8.3f',num_area1*(1-t)+num_area2*t)]);
    text(-3,2,6,['\fontsize{10} \color{blue} ' ...
    'Symbolic Integration: '...
    sprintf('%8.3f',sym_area1*(1-t)+sym_area2*t)]);
    %relabel axis
    xlabel('X axis');
    ylabel('Y axis');
    zlabel('Z axis');
    pause(0.01);
    drawnow;
end
end
