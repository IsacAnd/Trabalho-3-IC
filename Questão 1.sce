// Trabalho de Algoritmos Genéticos
clear
clc

PI = 3.14159265359;
t = 0;

function p = startPop() // função que inicializa a população
    randomNum1 = floor(rand(1, 40) * 10);
    randomNum2 = floor(rand(1, 40) * 10);

    x = dec2bin(randomNum1, 20);
    y = dec2bin(randomNum2, 20);
    
    p = x + y;
endfunction

function [dec1, dec2] = binaryToDecimal(binary) // transforma elementos binários da população em decimais
    v = strsplit(binary, 20);
    dec1 = -10 * bin2dec(v(1))*(10 - (-10))/(2)^20 - 1;
    dec2 = -10 * bin2dec(v(2))*(10 - (-10))/(2)^20 - 1;
endfunction

function [] = avaliatePop(p) // função que avalia a população
    
endfunction

function selectedFather = fatherSelection(newPop) // seleção de pais
    soma = cumsum(newPop);
    limite = rand() * soma;
    
    aux = 0;
    for (i = 1:size(newPop) && aux < limite)
        aux = aux + newPop(i);
        i = i + 1;
    end
    selectedFather = i - 1;
endfunction

function sons = recombinationAndMutation(p) // recombinação e mutação da população
    for (i = 1:size(p) - 1)
        // recombinação
        randomNum = rand();
        x = ceil(((randomNum==0) * 1) + random * 19);
        v1 = strsplit(p(i), x);
        v2 = strsplit(p(i+1), 20 - x);
        element = v1(1) + v2(2);
        
        // mutação 
        mutation = (randomNum <= 0.005) * 1
        if (mutation)
            random = ceil(rand() * 40);
            element(random) = (element(random)==0) + 0*(element(random)==1);
        end
        
        sons = element;
    end
endfunction

function selectSurvivors(p, newPop) // seleção dos sobreviventes
    
endfunction

function result = ackeyFunction(x, y) // função de Ackey
    result = -20 * exp(-0.2 * sqrt(0.5*(x^2 + y^2)) - exp(0.5(cos(2*PI) + cos(2*PI*y)))) + exp(1) + 20
endfunction


/* Main */

p = startPop();

[x, y] = binaryToDecimal(p(30));
disp(x, y);

while (t == 4)
    fathers = avaliatePop(p);
    newPop = fatherSelection(fathers);
    sons = recombinationAndMutation(newPop);
    p = avaliatePop(sons);
    np = selectSurvivors(p, sons);
    t = t + 1;
end



