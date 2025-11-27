function [kf,kfs]=Stepped_diameter(Dd,Shoulder_fillet)
DdM= [1.1,1.2,1.5];
A = [0.95120,0.97098,0.93836];
Ai = interp1(DdM, A, Dd, 'linear'); 
b= [-0.23757,-0.21796,-0.25759];
bi=interp1(DdM,b,Dd,'linear');
switch Shoulder_fillet
    case 'sharp'
        kt= Ai*(0.02^bi);
    case 'well-rounded'
        kt= Ai*(0.1^bi);
end
DdT= [1.09,1.2,1.33];
a= [0.90337,0.83425,0.84897];
ai= interp1(DdT,a,Dd,'linear');
B=[-0.12692,-0.21649,-0.23161];
Bi=interp1(DdT,B,Dd,'linear');
switch Shoulder_fillet
    case 'sharp'
        kts= ai*(0.02^Bi);
    case 'well-rounded'
        kts= ai*(0.1^Bi);
end
q=0.8;
kf= 1+q*(kt-1);
kfs=1+q*(kts-1);
end