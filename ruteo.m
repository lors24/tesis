%Par?metros

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
lambda_0 = -2;
lambda = [0,-5,-3,-8,9,-3];


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
R = cell(length(Q_hat),n);

for i = 1:n
    k = ismember(Q_hat,q(i));
    f(k,i) = d_tilde(1,i+1);
    R{k,i} =[0,i];  %almacenan las rutas
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
            [a,b]= min(m);
            if a ~= Inf
                f(j,i)=a;
                ant = ctes(b);
                R{j,i} = [R{indx,ant},i];
            end
        end
    end
end

%Inicia todo con infinito
psi = Inf(length(Q_hat),n);
R_t = cell(length(Q_hat),n);

% Crear matrices para almacenar costos

X = cell(n,3);

for i = 1:n
        [C,Q,R2] = matrices(i,f,Q_hat,q,R);
        X{i,1} = C;
        X{i,2} = Q;
        X{i,3} = R2;
end


for j = 1: length(Q_hat)
    qi = Q_hat(j);
    for i = 1:n
        [a,b] = min(X{i,1}(ismember(X{i,2},qi)));
        if(isempty(a) == 0)
            psi(j,i) = a;
            R_t{j,i} = X{i,3}{ismember(X{i,2},qi)};
        end
    end
end

%Crear variables w

w = ones(n,1);
rho = zeros(n);

%rho(j,i) numero de veces que el cliente j es visitado por la ruta i

for i=1:n
    [a,b]=min(psi(:,i)./Q_hat);
    w(i) = q(i)*a+lambda(i+1);
    ruta = R_t{b,i};
    for j=1:n
        rho(j,i) = sum(R_t{b,i} == j);
    end
end

%Evaluar en DRF

z_lambda = m_bar*lambda_0;

for i = 1:n
    z_lambda = z_lambda + fi(i)*w(i);
end

%Cuantas veces visita la ruta ?ptima a cada cliente


