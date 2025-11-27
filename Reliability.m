function [ke]=Reliability(percentage_choice)
switch percentage_choice
    case '50%'
        ke=1;
    case '90%'
        ke=0.879;
    case '95%'
        ke=0.868;
    case '99%'
        ke= 0.814;
    case '99.9%'
        ke= 0.753;
    case '99.99%'
        ke= 0.702;
    case '99.999%'
        ke=0.659;
    case '99.9999%'
        ke= 0.620;
end