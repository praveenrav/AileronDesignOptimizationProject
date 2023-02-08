function tau = get_tau(ratio)

rat = ratio;
coeff = [-0.00717110436860474;4.40960814360647;-21.7673577838147;64.6801637600900;-89.9369900050326;46.4204608201846];

tau = coeff(6)*rat.^5+coeff(5)*rat.^4+coeff(4)*rat.^3+coeff(3)*rat.^2+coeff(2)*rat+coeff(1);

end