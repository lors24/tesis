%Par?metros

Q = 50; %capacidad m?xima

n = 5; %n?mero de clientes
clientes = 1:n;

%Matriz de costos
d = [0 10 5 2 6 13; 10 0 20 18 6 9; 5 20 0 43 17 8; 2 18 43 0 11 7; 6 6 17 11 0 24; 13 9 8 7 24 0];

%Matriz de cantidades 
q = [20; 25; 5 ; 10; 20];

%Crear todas las combinaciones de peso

M = (dec2bin(0:(2^n)-1)=='1');
r = sort(unique(M*q));
Q_hat = r(r>=min(q) & r<=Q); %cantidades posibles

%Inicia todo con infinito
f = Inf(length(Q_hat),n);

for i = 1:n
    k = ismember(Q_hat,q(i));
    f(k,i) = d(1,i+1);
end

d2= d(2:6,2:6); %quitamos la columna de ceros para los indices

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