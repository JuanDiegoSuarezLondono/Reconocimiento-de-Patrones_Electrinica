%load sistema.m
X = [xH;xM;xC;xE];
Y = species;
tabulate(Y);
Mdl = fitcnb(X,Y,'ClassNames',{'Resistencia','Condensador','Rele','Ceramico'})
tarjetaIndex = strcmp(Mdl.ClassNames,'Resistencia');
estimates = Mdl.DistributionParameters{tarjetaIndex,1};
figure
gscatter(X(:,1),X(:,2),Y);
h = gca;
cxlim = h.XLim;
cylim = h.YLim;
hold on
Params = cell2mat(Mdl.DistributionParameters);
Mu = Params(2*(1:4)-1,1:2); % Extract the means
Sigma = zeros(2,2,4);
for j = 1:4
    Sigma(:,:,j) = diag(Params(2*j,:)).^2; % Create diagonal covariance matrix
    xlim = Mu(j,1) + 4*[1 -1]*sqrt(Sigma(1,1,j));
    ylim = Mu(j,2) + 4*[1 -1]*sqrt(Sigma(2,2,j));
    %ezcontour(@(x1,x2)mvnpdf([x1,x2],Mu(j,:),Sigma(:,:,j)),[xlim ylim])
    fcontour(@(x1,x2)mvnpdf([x1,x2],Mu(j,:),Sigma(:,:,j)))
        % Draw contours for the multivariate normal distributions
end
h.XLim = cxlim;
h.YLim = cylim;
title('Naive Bayes Classifier')
xlabel('Petal Length (cm)')
ylabel('Petal Width (cm)')
hold off