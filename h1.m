function [f,R,psi,R_t,Q_hat] = h1(n,Q_hat,m_bar,d,q,fi,lambda)
%PARAMETROS

%n = numero de clientes 
%Q_hat = vector de cantidades posibles
%m_bar = numero de vehiculos 
%d = matriz de costos
%q = vector de cantidades 
%fi = matriz de frecuencias
%lambda = matriz de lambdas

clientes = 1:n;

%Lambda 
lambda_0 = lambda(1);
lambda_1 = [0,lambda(2:end)];

%Nueva matriz de costos modificados
d_tilde = zeros(size(d,1),size(d,2));

for i = 1:n+1;
        for j = 1:n+1;
            d_tilde(i,j)=d(i,j)-0.5*lambda_1(i)-0.5*lambda_1(j);
        end
end

q_n = length(Q_hat); %numero de cantidades posibles

%Inicia todo con infinito
f = Inf(q_n,n);
R = cell(q_n,n);

for i = 1:n
    k = ismember(Q_hat,q(i));
    f(k,i) = d_tilde(1,i+1);
    R{k,i} =[0,i];  %almacenan las rutas iniciales
end

d2= d_tilde(2:6,2:6); %quitamos la columna de ceros para los indices

%Inicializar las rutas

for j = 1: q_n
    qi = Q_hat(j);
    for i = 1:n
        indx = find(Q_hat == qi-q(i));
        if isempty(indx)==0
            ctes = clientes(setdiff(1:n,i));
            m = f(indx,setdiff(1:n,i))+d2(i,setdiff(1:n,i));
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
psi = Inf(q_n,n);
R_t = cell(q_n,n);

% Crear matrices para almacenar costos

X = cell(n,3); %una columna para costos, otra para cantidades y otra para rutas

for i = 1:n
        [C,Q,R2] = matrices(i,f,Q_hat,q,R);
        X{i,1} = C;
        X{i,2} = Q;
        X{i,3} = R2;
end


for j = 1: length(Q_hat)
    qi = Q_hat(j);
    for i = 1:n
        [a,~] = min(X{i,1}(ismember(X{i,2},qi)));
        if(isempty(a) == 0)
            psi(j,i) = a;
            R_t{j,i} = X{i,3}{ismember(X{i,2},qi)};
        end
    end
end

end

