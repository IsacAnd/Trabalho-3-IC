// Trabalho de Algoritmos Genéticos
clear
clc

t = 0;

function p = startPop() // função que inicializa a população
    randomNum1 = floor(rand(1, 40) * 10);
    randomNum2 = floor(rand(1, 40) * 10);

    x = dec2bin(randomNum1, 20);
    y = dec2bin(randomNum2, 20);
    
    p = x + y;
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

function [x, y] = binaryToDecimal(binary) // transforma elementos binários da população em decimais
    v = strsplit(binary, 20);
    x = -10 * bin2dec(v(1))*(10 - (-10))/(2)^20 - 1;
    y = -10 * bin2dec(v(2))*(10 - (-10))/(2)^20 - 1;
endfunction

function selectedFather = fatherSelection(fathers) // seleção de pais
    soma = sum(fathers);
    limite = rand(1) * soma;
    disp(limite);
    
    i = 1;
    aux = 0;
    while (i <= 40 && aux < limite)
        aux = aux + fathers(i);
        i = i + 1;
    end

    selectedFather = i - 1;
endfunction

function sons = recombinationAndMutation(newPop) // recombinação e mutação da população
    for (i = 1:size(newPop) - 1)
        // recombinação
        randomNum = rand();
        x = ceil(((randomNum==0) * 1) + random * 19);
        v1 = strsplit(newPop(i), x);
        v2 = strsplit(newPop(i+1), 20 - x);
        element = v1(1) + v2(2);
        
        // mutação 
        mutation = (randomNum <= 0.005) * 1;
        if (mutation)
            random = ceil(rand() * 40);
            element(random) = (element(random)==0) + 0*(element(random)==1);
        end
        
        sons = element;
    end
endfunction

function selectSurvivors(p, newPop) // seleção dos sobreviventes
    
endfunction

function result = ackleyFunction(x, y) // função de Ackley
    PI = 3.1415926;
    result = -20 * exp(-0.2 * sqrt(0.5*(x^2 + y^2)) - exp(0.5(cos(2*PI) + cos(2*PI*y)))) + exp(1) + 20
endfunction


/* Main */

p = startPop();
fathers = avaliatePop(p);

newPop = zeros(1, 40);
for (i = 1:40)
    newPop(i) = fatherSelection(fathers);
end

disp(newPop);

while (t == 4)
    fathers = avaliatePop(p);
    newPop = fatherSelection(fathers);
    sons = recombinationAndMutation(newPop);
    p = avaliatePop(sons);
    np = selectSurvivors(p, sons);
    t = t + 1;
end



