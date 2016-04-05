function [w,theta] = variables(n,fi,m_bar, q,Q_hat,lambda,psi,R_t)
%Calcula variable w y parametro theta

%PARAMETROS

%n = numero de clientes 
%Q_hat = matriz de cantidades posibles
%q = vector de cantidades 

%Crear variables w

w = ones(n,1);
rho = zeros(n);

%rho(j,i) numero de veces que el cliente j es visitado por la ruta i

q_min = zeros(1,n);

for i=1:n
    [a,b]=min(psi(:,i)./Q_hat);
    w(i) = q(i)*a+lambda(i+1);
    q_min(i) = Q_hat(b);
    for j=1:n
        rho(j,i) = sum(R_t{b,i} == j);
    end
end

theta_1 = zeros(n,1);
theta_0 = m_bar;

for j=1:n
    aux = 0;
    for i=1:n
        aux = aux + (fi(i)*rho(j,i)*q(i))/(q_min(i));
    end
    theta_1(j) = fi(j)-aux;
    theta_0 = theta_0 - (fi(j)*q(j))/q_min(j);
end

theta = [theta_0;theta_1];

