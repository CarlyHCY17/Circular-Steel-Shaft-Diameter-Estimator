function [ka]=Surface_finish(Surface_Finishes,Sut)
switch Surface_Finishes
    case 'ground'
        ka = 1.34*(Sut^-0.085);
    case 'machined'
        ka = 2.70*(Sut^-0.265);
    case 'cold-drawn'
        ka = 2.70*(Sut^-0.265);
    case 'hot-rolled'
        ka=14.4*(Sut^-0.718);
    case 'as-forged'
        ka=39.9*(Sut^-0.995);
end