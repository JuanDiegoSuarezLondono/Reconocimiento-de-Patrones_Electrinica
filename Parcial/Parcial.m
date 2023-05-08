%Parcial primer corte
%Juan Diego Suárez Londoño
%Primer punto
close all;
clear all;
clc;
w=0;
load data;
display('Se esta ejecutando el primer punto...')
%Primer punto-Grafique los datos utilizando un color distintivo para cada
%clase
figure
plot(data_a(1,:),data_a(2,:),'.m');
hold on;
plot(data_b(1,:),data_b(2,:),'.b');
axis([-7 9 -6 11]);
xlabel('Tonalidad');
ylabel('Textura');
title('Graficado de los datos')
legend('data_a','data_b')
%Primer punto-Determine el centro de cada clase {ua,ub}
meanA=(mean(data_a))';
meanB=(mean(data_b))';
%Primer punto-Determine las matrices de covarianza de cada clase {sum_a, sum_b}. Que se
%puede concluir?
kX=cov(data_a);
kY=cov(data_b);
%Primer punto-Determine los auto-vectores {v1,v2} y los auto-valores {landA,landB} de
%cada matriz de covarianza
autoValoresA=eig(kX);
autoValoresB=eig(kY);
[vectores_x, valores_x]=eig(kX);
[vectores_y, valores_y]=eig(kY);
%Primer punto-Determine y visualice el histograma de los datos
for n=1:1:1000
z1x(1,n)=(data_a(1,n)-(meanA(n,1)')).^2/(kX(n,n));
z2x(1,n)=(data_a(2,n)-(meanA(n,1)')).^2/(kX(n,n));
z1y(1,n)=(data_b(1,n)-(meanB(n,1)')).^2/(kY(n,n));
z2y(1,n)=(data_b(2,n)-(meanB(n,1)')).^2/(kY(n,n));

distribucion1x(n,1)=(1/(sqrt(2*pi*sqrt(kX(n,n)))))*exp((-1/2)*z1x(1,n)');
distribucion2x(n,1)=(1/(sqrt(2*pi*sqrt(kX(n,n)))))*exp((-1/2)*z2x(1,n)');
distribucion1y(n,1)=(1/(sqrt(2*pi*sqrt(kY(n,n)))))*exp((-1/2)*z1y(1,n)');
distribucion2y(n,1)=(1/(sqrt(2*pi*sqrt(kY(n,n)))))*exp((-1/2)*z2y(1,n)');
end
figure
subplot(2,5,1)
histogram(distribucion1x)
title('Histogrma distribucio1x')
subplot(2,5,2)
histogram(distribucion2x)
title('Histogrma distribucio2x')
subplot(2,5,3)
histogram(distribucion1y)
title('Histogrma distribucio1y')
subplot(2,5,4)
histogram(distribucion2y)
title('Histogrma distribucio2y')
subplot(2,5,5)
histogram(data_a)
title('Histogrma data_a')
subplot(2,5,6)
histogram(data_b)
title('Histograma data_b')
subplot(2,5,7)
histogram(meanA)
title('Histograma meanA')
subplot(2,5,8)
histogram(meanB)
title('Histograma meanB')
subplot(2,5,9)
histogram(kX)
title('Histograma kX')
subplot(2,5,10)
histogram(kY)
title('Histograma kY')

display('Presione alguna tecla para pasar al segundo punto')
display('Nota: No cierre cerrar las graficas')
while w==0
w=waitforbuttonpress;
end
w=0;
%Segundo punto
close all;
clear all;
clc;
load data2;
display('Se esta ejecutando el segundo punto...')
%Segundo punto-Divida los datos aleatoriamente en conjunto de prueba (20%)
%y de entrenamiento (80%)
w=0;
numRandom=0;
pruebaA=zeros(800,3);
entrenamientoA=zeros(3200,3);
pruebaB=zeros(800,3);
entrenamientoB=zeros(3200,3);
for i=1:1:3200
    numRandom=randi([1 4000],1,1);
    if i<=800
        for j=1:1:3
            pruebaA(i,j)=a(numRandom,j);
            numRandom=randi([1 4000],1,1);
            pruebaB(i,j)=b(numRandom,j);
            numRandom=randi([1 4000],1,1);
            entrenamientoA(i,j)=a(numRandom,j);
            numRandom=randi([1 4000],1,1);
            entrenamientoB(i,j)=b(numRandom,j);
        end 
    else
        for j=1:1:3            
            entrenamientoA(i,j)=a(numRandom,j);
            numRandom=randi([1 4000],1,1);
            entrenamientoB(i,j)=b(numRandom,j);
        end
    end
end
%Segundo punto-Visualice el conjunto de entrenamiento con un color para
%cada clase
figure
plot3(entrenamientoA(:,1),entrenamientoA(:,2),entrenamientoA(:,3),'.g');
hold on;
plot3(entrenamientoB(:,1),entrenamientoB(:,2),entrenamientoB(:,3),'.y');
axis([-7 9 -6 11]);
xlabel('Tonalidad');
ylabel('Textura');
zlabel('Otra cosa');
title('Grafica conjunto de entrenamiento ')
legend('Entrenamiento A','Entrenamiento B')
%Segundo punto-Implemente un clasificador bayesiano gaussiano
uA = mean(pruebaA);
kA = cov(pruebaA);
uB = mean(pruebaB);
kB = cov(pruebaB);
PA = 0.5;
PB = 0.5;

x = [pruebaA;pruebaB];
y = zeros(length(x(:,1,1)),1,1);
t = [zeros(length(pruebaA(:,1,1)),1,1);ones(length(pruebaB(:,1,1)),1,1)]; % Etiqueta del dato
figure
hold on;
for i = 1:length(x(:,1,1))
    PA_x = PA *(1/(sqrt(2*pi*det(kA))))*exp(-0.5*(x(i,:)-uA)*inv(kA)*(x(i,:)-uA)');
    PB_x = PB *(1/(sqrt(2*pi*det(kB))))*exp(-0.5*(x(i,:)-uB)*inv(kB)*(x(i,:)-uB)');
    if PA_x > PB_x 
        y(i) = 0;
        plot(x(i,1),x(i,2),'r.');
    else
        y(i) = 1;
        plot(x(i,1),x(i,2),'c.');
    end
end
title('Grafica clasificador bayesiano ')
legend('prueba A','prueba B')
error = sum(y~=t)/10000
%Segundo punto-Implemente un clasificador gaussiano naive
X = [pruebaA;pruebaB];
[num,Y]=xlsread('DatosSpecies.xlsx');
tabulate(Y);
Mdl = fitcnb(X,Y,'ClassNames',{'a','b'});
tarjetaIndex = strcmp(Mdl.ClassNames,'a');
estimates = Mdl.DistributionParameters{tarjetaIndex,1};
figure
plot3(pruebaA(:,1),pruebaA(:,2),pruebaA(:,3),'.k');
hold on;
plot3(pruebaB(:,1),pruebaB(:,2),pruebaB(:,3),'.r');
axis([-7 9 -6 11]);
xlabel('Tonalidad');
ylabel('Textura');
zlabel('Otra cosa');
legend('Entrenamiento A','Entrenamiento B')
h = gca;
cxlim = h.XLim;
cylim = h.YLim;
czlim = h.ZLim;
hold on
Params = cell2mat(Mdl.DistributionParameters);
Mu = Params(2*(1:2)-1,1:3); % Extract the means
Sigma = zeros(3,3,2);
for j = 1:2
    Sigma(:,:,j) = diag(Params(2*j,:)).^2; % Create diagonal covariance matrix
    xlim = Mu(j,1) + 2*[1 -1]*sqrt(Sigma(1,1,j));
    ylim = Mu(j,2) + 2*[1 -1]*sqrt(Sigma(2,2,j));
    zlim = Mu(j,3) + 2*[1 -1]*sqrt(Sigma(3,3,j));
end
%surf(X,Y,Z)
title('Grafica clasificador bayesiano native')
legend('prueba A','prueba B')
    [M P] = meshgrid(pruebaA(:,1),pruebaA(:,2)); %// all combinations of x, y
    eza = mvnpdf([M(:) P(:)],Mu(1,1:2),Sigma(1:2,1:2,1)); %// compute Gaussian pdf
    eza = reshape(eza,size(M)); %// put into same size as X, Y
    [M P] = meshgrid(pruebaB(:,1),pruebaB(:,2)); 
    ezb = mvnpdf([M(:) P(:)],Mu(2,1:2),Sigma(1:2,1:2,2));
    ezb = reshape(ezb,size(M)); 
    surf(pruebaA(:,1),pruebaA(:,2),eza)
    hold on
    surf(pruebaB(:,1),pruebaB(:,2),ezb)
h.XLim = cxlim;
h.YLim = cylim;
h.ZLim = czlim;
hold off
display('Presione alguna tecla para pasar al tercer punto')
display('Nota: No cierre cerrar las graficas')
while w==0
w=waitforbuttonpress;
end
w=0;
%Tercer punto
close all;
clc;
load data2;
display('Se esta ejecutando el tercer punto...')
%Tercer punto-Determine la transformación de R3 a R2 utilizando PCA (sobre el conjunto de entrenamiento)
[WA pcA] = pca(entrenamientoA'); 
[WB pcB] = pca(entrenamientoB'); 
pcA=pcA';
pcB=pcB';
WA=WA';
WB=WB';
plot(pcA(1,:),pcA(2,:),'.r');
plot(pcB(1,:),pcB(2,:),'.b');
title('PCA'); 
legend('Entrenamiento A','Entrenamiento B')
xlabel('PC 1'); ylabel('PC 2')
%Tercer punto-Implemente un clasificador bayesiano gaussiano sobre los datos transformados:
pccA=[pcA(:,1) pcA(:,2)];
pccB=[pcA(:,1) pcB(:,2)];
X = [pccA;pccB];
l=0;
sA=size(pccA);
sB=size(pccB);
suma=sA+sB;
k= cell(suma(1,1),1);
for i=1:sA
    l=i;
    k(i,1)={'a'};
end
for i=(l+1):suma
    k(i,1)={'b'};
end
Mdl = fitcnb(X,k,'ClassNames',{'a','b'});
tarjetaIndex = strcmp(Mdl.ClassNames,'a');
estimates = Mdl.DistributionParameters{tarjetaIndex,1};
gscatter(X(:,1),X(:,2),k);
h = gca;
cxlim = h.XLim;
cylim = h.YLim;
hold on
Params = cell2mat(Mdl.DistributionParameters);
Mu = Params(2*(1:2)-1,1:2); % Extract the means
Sigma = zeros(2,2,2);
for j = 1:2
    Sigma(:,:,j) = diag(Params(2*j,:)).^2; % Create diagonal covariance matrix
    xlim = Mu(j,1) + 2*[1 -1]*sqrt(Sigma(1,1,j));
    ylim = Mu(j,2) + 2*[1 -1]*sqrt(Sigma(2,2,j));
    fcontour(@(x1,x2)mvnpdf([x1,x2],Mu(j,:),Sigma(:,:,j)))
end
h.XLim = cxlim;
h.YLim = cylim;
title('Clasificador bayesiano naive con PCA R3 A R2') 
xlabel('Petal Length (cm)')
ylabel('Petal Width (cm)')
hold off
