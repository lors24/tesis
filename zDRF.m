function [ z] = zDRF(lambda)

Q = 50; %capacidad m?xima

n = 5; %n?mero de clientes
clientes = 1:n;
m_bar = 11; %n?mero de vehiculos

%Matriz de costos
d = [0 10 5 2 6 13; 10 0 20 18 6 9; 5 20 0 43 17 8; 2 18 43 0 11 7; 6 6 17 11 0 24; 13 9 8 7 24 0];

%Matriz de cantidades 
q = [20; 25; 5 ; 10; 20];

%Matriz de frecuencias
fi = [2;1;3;2;1];

%Lambda 
lambda_0 = lambda(1);
lambda = [0,lambda(2:end)];


%Nueva matriz de costos

d_tilde = zeros(n+1,n+1);

for i = 1:n+1;
        for j = 1:n+1;
            d_tilde(i,j)=d(i,j)-0.5*lambda(i)-0.5*lambda(j);
        end
end

%Crear todas las combinaciones de peso

M = (dec2bin(0:(2^n)-1)=='1');
r = sort(unique(M*q));
Q_hat = r(r>=min(q) & r<=Q); %cantidades posibles

%Inicia todo con infinito
f = Inf(length(Q_hat),n);

for i = 1:n
    k = ismember(Q_hat,q(i));
    f(k,i) = d_tilde(1,i+1);
end

d2= d_tilde(2:6,2:6); %quitamos la columna de ceros para los indices

%Inicializar las rutas

for j = 1: length(Q_hat)
    qi = Q_hat(j);
    for i = 1:n
        indx = find(Q_hat == qi-q(i));
        if isempty(indx)==0
            ctes = clientes(setdiff(1:length(clientes),i));
            m = f(indx,setdiff(1:size(f,2),i))+d2(i,setdiff(1:length(d2),i));
            f(j,i)= min(m);  
        end
    end
end

%Inicia todo con infinito
psi = Inf(length(Q_hat),n);

for j = 1: length(Q_hat)
    qi = Q_hat(j);
    for i = 1:n
        indx = find(Q_hat == qi-q(i));
        if isempty(indx)==0
            ctes = clientes(setdiff(1:length(clientes),i));
            m = f(indx,setdiff(1:size(f,2),i))+d2(i,setdiff(1:length(d2),i));
            f(j,i)= min(m);  
        end
    end
end

% Crear matrices para almacenar costos

X = cell(n,2);

for i = 1:n
        [C,Q] = matrices(i,f,Q_hat,q);
        X{i,1} = C;
        X{i,2} = Q;
end


for j = 1: length(Q_hat)
    qi = Q_hat(j);
    for i = 1:n
        [a,b] = min(X{i,1}(ismember(X{i,2},qi)));
        if(isempty(a) == 0)
            psi(j,i) = a;
        end
    end
end

%Crear variables w

w = ones(n,1);

for i=1:n
    [a,b]=min(psi(:,i)./Q_hat);
    w(i) = q(i)*a+lambda(i+1);
end

%Evaluar en DRF

z = m_bar*lambda_0;

for i = 1:n
    z = z + fi(i)*w(i);
end






end

