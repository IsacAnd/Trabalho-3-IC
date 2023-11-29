// Trabalho de Algoritmos Genéticos

// arrumar mutação
// arrumar avaliação de forma que os menores valores ganhem destaque - OK
// arrumar a criação da população - OK
clear
clc


function pop = startPop(n)
    pop = string(zeros(1,40));
    for i = 1:n
        randomNumbers = rand(1, n);
        binaryVector = round(randomNumbers);

        pop(i) = strcat(string(binaryVector));
    end
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
    x = -10 + bin2dec(v(1))*(10 - (-10))/((2)^20 - 1);
    y = -10 + bin2dec(v(2))*(10 - (-10))/((2)^20 - 1);
endfunction

function selectedFather = fatherSelection(fathers) // seleção de pais
    soma = 0;
    
    for i = 1:40
        soma = 1/fathers(i) + soma;
    end
    
    limite = rand(1) * soma;

    i = 1;
    aux = 0;
    while (i <= 40 && aux < limite)
        aux = aux + 1/fathers(i);
        i = i + 1;
    end

    selectedFather = i - 1;
endfunction

function element = mutation(binary)
    randomNum = rand();
    
    if randomNum <= 0.005 then
        random = ceil(randomNum * 40 + (randomNum == 0) * 1);
        if binary(random) == '0' then
            binary(random) = '1'
        else
            binary(random) = '0';
        end
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
        
        // mutação 
        binary = strsplit(element);
        element = mutation(binary);
        
        sons(i) = element;
    end
endfunction

function p = elitism(v1, popAvaliation) // elitismo
    p = string(zeros(1, 10));
    for i = 1:10
        [value, ind] = min(popAvaliation);
        p(i) = v1(ind);
        popAvaliation(ind) = 10000;
    end
endfunction

function result = ackleyFunction(x, y) // função de Ackley
    auy = 2 * 3.14 * y;
    aux = 2 * 3.14 * x;
    result = -20 * exp(-0.2 * sqrt(0.5*(x^2 + y^2))) + exp(0.5*(cos(aux) + cos(auy))) + exp(1) + 20;
endfunction

/* Main */

t = 0;
p = startPop(40); // inicia população

while (t < 10)
//  ============== PAIS ================
    popAvaliation = avaliatePop(p); // cria um vetor de avaliação da população que corresponde a avaliação de cada elemento
    
    selectedFathers = zeros(1, 40); // cria um vetor que possui as posições dos elementos escolhidos para serem pais 
    for (i = 1:40)
        selectedFathers(i) = fatherSelection(popAvaliation);
    end
    
    aux = string(zeros(1, 40)); // cruza a informação que o elemento carrega com a sua seleção
    for i = 1:40
        aux(i) = p(selectedFathers(i));
    end
    
    sons = recombinationAndMutation(aux);

// ============== FILHOS ================
    sonsAvaliation = avaliatePop(sons);
    
    selectedSons = zeros(1, 40); // cria um vetor que possui as posições dos elementos escolhidos para serem pais 
    for (i = 1:40)
        selectedSons(i) = fatherSelection(sonsAvaliation);
    end

    aux2 = string(zeros(1, 40)); // cruza a informação que o elemento carrega com a sua seleção
    for i = 1:40
        aux2(i) = sons(selectedSons(i));
    end
    
    // fazer elitismo e colocar esses valores no vetor com a população
    
// ============== ELITISMO ==============
    besties = elitism(p, popAvaliation);
    
    for i = 41:50
        aux2(i) = besties(51 - i)
    end
    
    avg = sum(avaliatePop(p))/50;
    worstElement = max(avaliatePop(p));
    bestElement = min(avaliatePop(p));
    disp("Média de avaliação: ", avg);
    
    p = aux2;
    t = t + 1;
end



