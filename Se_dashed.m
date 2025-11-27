function [Se_dash]=Se_dashed(Sut)
if Sut<=200*10^3
    Se_dash = Sut * 0.5; % Example calculation for Sut <= 200
else
    Se_dash = 100; % Example calculation for Sut > 200
end