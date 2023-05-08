cameraParams
pixels=[640,480]
R=[cameraParams.RadialDistortion(1),(-cameraParams.RadialDistortion(2));cameraParams.RadialDistortion(2),cameraParams.RadialDistortion(1)] 
T=cameraParams.TangentialDistortion
F=cameraParams.FocalLength
extrinsicParametersMatrix=[R(1,1),R(1,2),T(1);R(2,1),R(2,2),T(1);0,0,1] %matriz de parametros extrinsecos
focalDistortionMatrix=[F(1),0,0;0,F(2),0;0,0,0]
pictureParameters=[(1/pixels(1)),0,(round(cameraParams.PrincipalPoint(1)));0,(1/pixels(2)),(round(cameraParams.PrincipalPoint(2)));0,0,1]
matrixC=pictureParameters*focalDistortionMatrix*(extrinsicParametersMatrix^-1)
H=matrixC;
H(3,3)=1
%RGB(640,480,3)[0.1191 -0.3518]
%impixel(RGB, 1280, 720)
for x=1:640
    for y=1:480
        for k=1:3
            intensidad=impixel(RGB, x, y);
            nuevaPosicion=H*[x y 1]';
            nuevaMatriz(round(nuevaPosicion(1)),(round(nuevaPosicion(2))),k)=intensidad(k);
        end
    end
end

%La resolucion de la camara... en el caso en clase es: formato YuY2
%640x480-1280x720(la segunda es la tomada para el ejercicio)
%Matriz de parametros extrinsecos {{R(Distorcion radial), T(Distorcion tangencial)},{0(1x3),1}};
%Recordar que z desaparece para llevar a la patriz a 3 {x,y,'z' y 1}
%Al ser R una matriz 3x3 se hace una rotacion y se la lleva a 2x2
%{{1,0,0},{0,cosO,-senO},{0,senO,cosO}}, eliminando a x ya que es la de mayor tamaño en el formato
%Entonces queda {{cosO,-sinO},{sinO, cosO}}, siendo cosO el primer valor
%que entrega matlab y senO el segundo.
%Reemplazando {{0.1973,-0.0679,0},{0.0679,0.1973,0},{0,0,1}}
%En la matriz de distocion focal {{f,0,0,0},{0,f,0,0},{0,0,1,0}} ya que
%quitamos desde un inicio 'z' queda {{f,0,0},{0,f,0},{0,0,0}} siendo la
%primera f la distocion focal en x y la segunda en y
%los parametros de la imagen que son {{1/pu,0,u0},{0,1/pv,v0},{0,0,1}}
%siendo pu el numero de pixeles en X pv el de Y y u0, v0 el punto de
%referencia que sera la mitad de la imagen