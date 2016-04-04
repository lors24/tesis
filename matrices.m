%Funci?n crea todas las combinaciones posibles de through q routespara cada cliente

%input: el cliente para el cual se quiere calcular
%f : funci?n de q routes
%Q_hat : conjunto de todas las combinaciones posibles de cantidades 
%q: vector de cantidades para cada cliente

%Nota para optimizar: ?nicamente hacerlo para la diagonal de abajo y luego
%invertir para la diagonal de arriba 

function [C,Q,R_t] = matrices(cte, f, Q_hat, q, R)

j1 = find(Q_hat == q(cte));
n = length(Q_hat)-j1;
C = zeros(n);
Q = zeros(n);
R_t = cell(n);

for j = j1:length(Q_hat)
    for i = j1:length(Q_hat)
        C(i,j) = f(j,cte)+f(i,cte);
        Q(i,j) = Q_hat(j)+Q_hat(i)-q(cte);
        R_t{i,j} = [R{i,cte}, fliplr(R{j,cte}(1:end-1))];
    end 
end

end

