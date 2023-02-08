A = readmatrix('taudata.xlsx');
tau = A(:,1); 
x = A(:,2); 
% 
% figure(); 
% plot(coeff,tau,'b.'); 

%Psuedo Inverse method
n = length(tau);

y = tau;
x = [ones(n,1),x.^1,x.^2,x.^3,x.^4,x.^5];
reg_coeffs = pinv(x'*x)*x'*y; %coefficients

coeff = A(:,2); 

yhat =polyval(reg_coeffs(end:-1:1)',coeff);
figure
plot(coeff,tau,'m.')
hold on
plot(coeff,yhat,'k-')
xlabel('Control-surface-to-lifting-surface-chord ratio')
ylabel('Tau')
title('Tau vs CS-LS Ratio')
legend('Data','Regression')