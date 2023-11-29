// Trabalho de Algoritmos Genéticos

clc
clear

function pop = startPop(n)
    pop = string(zeros(1,n));
    for i = 1:n
        randomNumbers = rand(1, 40);
        binaryVector = round(randomNumbers);

        pop(i) = strcat(string(binaryVector));
    end
endfunction

function element = mutation(binary, n)
    randomNum = rand();
    
    if randomNum <= 0.005 then
        random = ceil(randomNum * n + (randomNum == 0) * 1);
        if binary(random) == '0' then
            binary(random) = '1'
        else
            binary(random) = '0';
        end
    end
    
    element = strcat(binary);
endfunction

function sons = recombinationAndMutation(newPop, n) // recombinação e mutação da população
    
    sons = string(zeros(1, n));
    for (i = 1:n)
        
        // recombinação
        father1 = newPop(i);
        father2 = newPop(modulo(i, n) + 1);
        
        randomNum = rand();
        x = ceil(((randomNum==0) * 1) + randomNum * 39);
        v1 = strsplit(father1, x);
        v2 = strsplit(father2, x);
        element = v1(1) + v2(2);
        
        // mutação 
        binary = strsplit(element);
        element = mutation(binary, n);
        
        sons(i) = element;
    end
endfunction

function selectedFather = fatherSelection(fathers, n) // seleção de pais
    soma = 0;
    
    for i = 1:n
        soma = 1/fathers(i) + soma;
    end
    
    limite = rand(1) * soma;

    i = 1;
    aux = 0;
    while (i <= n && aux < limite)
        aux = aux + 1/fathers(i);
        i = i + 1;
    end

    selectedFather = i - 1;
endfunction

function [x, y] = binaryToDecimal(binary) // transforma elementos binários da população em decimais
    v = strsplit(binary, 20);
    x = -10 + bin2dec(v(1))*(10 - (-10))/((2)^20 - 1);
    y = -10 + bin2dec(v(2))*(10 - (-10))/((2)^20 - 1);
endfunction

function result = ackleyFunction(x, y) // função de Ackley
    result = -20 * exp(-0.2 * sqrt(0.5*(x^2 + y^2))) - exp(0.5*(cos(2 * 3.14 * y)+ cos(2 * 3.14 * x))) + exp(1) + 20;
endfunction

function fathers = avaliatePop(p, n) // função que avalia a população
    fathers = zeros(1, n);
    for i = 1:n
        bin = p(i);
        [x, y] = binaryToDecimal(bin);
        element = ackleyFunction(x, y);
        fathers(i) = element;
    end
endfunction

function percentage = perRoulette(vec, ind)
    soma = 0;
    
    for i = 1:3
        soma = 1/vec(i) + soma; // [0.1 0.2 0.3]
    end
    
    percentage = 100 * ((1/ind) / soma);
endfunction

////// main

t = 0;
n = 100;
pop = startPop(n); // população original

while t < 30
    avaliation = avaliatePop(pop, n); // avaliação da população original
    
    selectedFathers = zeros(1, n); // cria um vetor que possui as posições dos elementos escolhidos para serem pais 
    
    for (i = 1:n)
        selectedFathers(i) = fatherSelection(avaliation, n);
    end

    aux = string(zeros(1, n)); // cruza a informação que o elemento carrega com a sua seleção
    for i = 1:n
        aux(i) = pop(selectedFathers(i));
    end

    aux = recombinationAndMutation(aux, n);

    auxAvaliation = avaliatePop(aux);

    disp("melhor indivíduo e sua porcentagem na roleta: ", min(auxAvaliation), perRoulette(auxAvaliation, min(auxAvaliation)));
    disp("pior indivíduo e sua porcentagem na roleta: ", max(auxAvaliation), perRoulette(auxAvaliation, max(auxAvaliation)));
    disp("média: ", sum(auxAvaliation)/n);
    
    pop = aux;
    t = t + 1;
    
end

plot(auxAvaliation);










