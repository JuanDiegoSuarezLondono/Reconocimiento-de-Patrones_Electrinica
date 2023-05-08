close all;
clear all;
load Bayes2D;
%% Gaussian Asumption %%
uH = mean(xH);
kH = cov(xH);
uM = mean(xM);
kM = cov(xM);
PH = 0.5;
PM = 0.5;

x = [xH;xM];
y = zeros(length(x(:,1)),1);  % Salida del clasificador bayesiano
t = [zeros(length(xH(:,1)),1);ones(length(xM(:,1)),1)]; % Etiqueta del dato
figure;
hold on;
for i = 1:length(x(:,1))
    PM_x = PM *(1/(sqrt(2*pi*det(kM))))*exp(-0.5*(x(i,:)-uM)*inv(kM)*(x(i,:)-uM)');
    PH_x = PH *(1/(sqrt(2*pi*det(kH))))*exp(-0.5*(x(i,:)-uH)*inv(kH)*(x(i,:)-uH)');
    if PM_x > PH_x
        y(i) = 1;
        plot(x(i,1),x(i,2),'r.');
    else
        y(i) = 0;
        plot(x(i,1),x(i,2),'b.');
    end
end

error = sum(y~=t)/10000



