function [z_lambda] = zDRF_l(n, m_bar,lambda,fi,w_1)

z_lambda = m_bar*lambda(1);

for i = 1:n
    z_lambda = z_lambda + fi(i)*w_1(i);
end

end

