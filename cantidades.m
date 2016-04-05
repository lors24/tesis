function [ Q_hat ] = cantidades(n, q, Q )
%Crear todas las combinaciones de peso

%n = numero de clientes 
%Q = capacidad maxima 
%q = vector de cantidades 

M = (dec2bin(0:(2^n)-1)=='1');
r = sort(unique(M*q));
Q_hat = r(r>=min(q) & r<=Q); %cantidades posibles


end

