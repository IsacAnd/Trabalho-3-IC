clc
clear 

function result = ackleyFunction(x, y) // função de Ackley
    PI = 3.14;
    result = -20 * exp(-0.2 * sqrt(0.5*(x^2 + y^2))) + exp(0.5(cos(2*3.14) + cos(2*3.14))) + exp(1) + 20;
endfunction

function [x, y] = binaryToDecimal(binary) // transforma elementos binários da população em decimais
    v = strsplit(binary, 20);
    x = -10 + bin2dec(v(1))*(10 - (-10))/((2)^20 - 1);
    y = -10 + bin2dec(v(2))*(10 - (-10))/((2)^20 - 1);
endfunction

function fathers = avaliatePop(p) // função que avalia a população
    fathers = zeros(1, 40);
    for i = 1:40
        bin = p(i);
        [x, y] = binaryToDecimal(bin);
        element = ackleyFunction(x, y);
        fathers(i) = element;
    end
endfunction

function pop = startPop(n)
    pop = string(zeros(1,40));
    for i = 1:n
        randomNumbers = rand(1, n);
        binaryVector = round(randomNumbers);

        pop(i) = strcat(string(binaryVector));
    end
endfunction

pop = startPop(40);

result = avaliatePop(pop);

disp(result);
