function [Ta,Tm]=Torque(Tmin,Tmax)
Ta = (Tmax-Tmin) / 2; 
Tm = (Tmax + Tmin) / 2; 
end