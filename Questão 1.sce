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

    i = 1;
    aux = 0;
    while (i <= 40 && aux < limite)
        aux = aux + fathers(i);
        i = i + 1;
    end

    selectedFather = i - 1;
endfunction

function element = mutation(binary)
    randomNum = rand();
    
    if randomNum <= 0.9 then
        random = ceil(randomNum * 40 + (randomNum == 0) * 1);
        if binary(random) == '0' then
            binary(random) = '1'
        else
            binary(random) = '0';
        end
        disp('Ocorreu mutação no indivíduo random' + random);
    end
    
    element = strcat(binary);
endfunction

function sons = recombinationAndMutation(newPop) // recombinação e mutação da população
    
    sons = string(zeros(1, 40));
    for (i = 1:40)
        
        // recombinação
        father1 = newPop(i);
        father2 = newPop(modulo(i, 40) + 1);
        
        randomNum = rand();
        x = ceil(((randomNum==0) * 1) + randomNum * 39);
        v1 = strsplit(father1, x);
        v2 = strsplit(father2, x);
        element = v1(1) + v2(2);
        
        if (i == 39)
            disp(v1(1), v2(2));
        end
        
        // mutação 
        binary = strsplit(element);
        element = mutation(binary);
        
        sons(i) = element;
    end
endfunction

function selectSurvivors(p, newPop) // seleção dos sobreviventes
    
endfunction

function result = ackleyFunction(x, y) // função de Ackley
    PI = 3.1415926;
    result = -20 * exp(-0.2 * sqrt(0.5*(x^2 + y^2)) - exp(0.5(cos(2*PI) + cos(2*PI*y)))) + exp(1) + 20
endfunction


/* Main */

p = startPop(); // inicia população
fathers = avaliatePop(p); // cria um vetor de avaliação da população que corresponde a avaliação de cada pai  

newPop = zeros(1, 40); // cria um vetor que possui as posições dos elementos escolhidos para serem pais 
for (i = 1:40)
    newPop(i) = fatherSelection(fathers);
end

aux = string(zeros(1, 40)); // cruza a informação que o elemento carrega com a sua seleção 
for i = 1:40
    aux(i) = p(newPop(i));
end

sons = recombinationAndMutation(aux);

disp(sons);

while (t == 4)
    fathers = avaliatePop(p);
    newPop = fatherSelection(fathers);
    sons = recombinationAndMutation(newPop);
    p = avaliatePop(sons);
    np = selectSurvivors(p, sons);
    t = t + 1;
end



