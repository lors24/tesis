%Parametros

Q = 50; %capacidad maxima

n = 5; %numero de clientes
m_bar = 11; %numero de vehiculos

%Matriz de costos
d = [0 10 5 2 6 13; 10 0 20 18 6 9; 5 20 0 43 17 8; 2 18 43 0 11 7; 6 6 17 11 0 24; 13 9 8 7 24 0];

%Matriz de cantidades 
q = [20; 25; 5 ; 10; 20];

%Matriz de frecuencias
fi = [2;1;3;2;1];

%Lambda
lambda = [-2,-9,3,-8,2,0];

%mu

mu = [3,3,-9.5,-2,1,4];

Q_hat = cantidades(n, q, Q );

%Calculos con mu
[f,R,psi,R_t] = h1(n,Q_hat,m_bar,d,q,fi,mu)
[w_1,theta_1] = variables(n,fi,m_bar,q,Q_hat,mu,psi,R_t)
w = [mu(1);w_1]; 

%Evaluar en DRF

z2 = zDRF_l(n, m_bar,lambda,fi,w_1)

%Calculos con lambda
[f,R,psi,R_t] = h1(n,Q_hat,m_bar,d,q,fi,lambda)
[w_1,theta] = variables(n,fi,m_bar, q,Q_hat,lambda,psi,R_t)
w = [lambda(1);w_1]; 

%Evaluar en DRF

z1 = zDRF_l(n, m_bar,lambda,fi,w_1)


z2 >= (mu(2:end)-lambda(2:end))*theta(2:end)+z1


