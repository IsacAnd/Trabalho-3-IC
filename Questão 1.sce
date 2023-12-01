/*Trabalho 3 IC
Aluno: Isac Andrade Alves - 493787
Aluno: João Paulo de Abreu Militão - 
*/

clc
clear

function pop = startPop(n)
    pop = string(zeros(1, n));
    for i = 1:n
        randomNumbers = rand(1, 40);
        binaryVector = round(randomNumbers);
        pop(i) = strcat(string(binaryVector));
    end
endfunction

function element = mutation(binary, n)
    randomNum = rand();
    if randomNum <= 0.05 then
        random = ceil(randomNum * n + (randomNum == 0) * 1);
        if binary(random) == '0' then
            binary(random) = '1';
        else
            binary(random) = '0';
        end
    end
    element = strcat(binary);
endfunction

function sons = recombinationAndMutation(newPop, n)
    sons = string(zeros(1, n));
    for (i = 1:n)
        // recombination
        father1 = newPop(i);
        father2 = newPop(modulo(i, n) + 1);
        randomNum = rand();
        x = ceil(((randomNum == 0) * 1) + randomNum * 39);
        v1 = strsplit(father1, x);
        v2 = strsplit(father2, x);
        element = v1(1) + v2(2);
        // mutation
        binary = strsplit(element);
        element = mutation(binary, n);
        sons(i) = element;
    end
endfunction

function selectedFather = fatherSelection(fathers, n)
    soma = 0;
    for i = 1:n
        soma = 1 / fathers(i) + soma;
    end
    
    limit = rand(1) * soma;
    i = 1;
    aux = 0;
    
    while (i <= n && aux < limit)
        aux = aux + 1 / fathers(i);
        i = i + 1;
    end

    selectedFather = i - 1;
endfunction

function [x, y] = binaryToDecimal(binary)
    v = strsplit(binary, 20);
    x = -10 + bin2dec(v(1)) * (10 - (-10)) / (2 ^ 20 - 1);
    y = -10 + bin2dec(v(2)) * (10 - (-10)) / (2 ^ 20 - 1);
endfunction

function result = ackleyFunction(x, y)
    result = -20 * exp(-0.2 * sqrt(0.5 * (x ^ 2 + y ^ 2))) - exp(0.5 * (cos(2 * 3.14 * y) + cos(2 * 3.14 * x))) + exp(1) + 20;
endfunction

function fathers = avaliatePop(p, n)
    fathers = zeros(1, n);
    for i = 1:n
        bin = p(i);
        [x, y] = binaryToDecimal(bin);
        element = ackleyFunction(x, y);
        fathers(i) = element;
    end
endfunction

function percentage = perRoulette(vec, ind, n)
    soma = 0;
    for i = 1:n
        soma = 1 / vec(i) + soma;
    end
    percentage = 100 * ((1 / ind) / soma);
endfunction

function [survivors, value] = elitism(pop, avaliation, n)
    survivors = string(zeros(1,n));
    for i = 1:n
        [value, ind] = min(avaliation)
        survivors(i) = pop(ind);
        avaliation(ind) = 100;
    end
endfunction

/* MAIN */

elite = 10; // quantidade de elementos que serão salvos a cada geração
n = 100 + elite; // população + quantidade de elementos que serão salvos a cada geração

pop = startPop(n); // iniciar população
iterations = 40; // difinição de gerações 

minValues = zeros(1, iterations);
maxValues = zeros(1, iterations);
avgValues = zeros(1, iterations);

for t = 1:iterations
    avaliation = avaliatePop(pop, n); // avalia população
    
    selectedFathers = zeros(1, n); // seleciona n elementos para serem pais
    for i = 1:n
        selectedFathers(i) = fatherSelection(avaliation, n);
    end

    newPop = string(zeros(1, n)); // cria um vetor com os elementos escolhidos
    for i = 1:n
        newPop(i) = pop(selectedFathers(i));
    end
    
    [survivors, value] = elitism(newPop, avaliation, elite); // elitismo

    newPop = recombinationAndMutation(newPop, n); // recombinação e mutação desses elementos escolhidos

    newPopAvaliation = avaliatePop(newPop); // avalia novamente a população 

    minValues(t) = min(newPopAvaliation); // plotagem de resultados
    maxValues(t) = max(newPopAvaliation);
    avgValues(t) = sum(newPopAvaliation) / (n);
    
    disp("==========================================================");
    disp("Geração: ", t);
    disp("Melhor indíviduo e sua porcentagem na roleta: ", minValues(t), perRoulette(newPopAvaliation, minValues(t), n));
    disp("Pior indivíduo e sua porcentagem na roleta: ", maxValues(t), perRoulette(newPopAvaliation, maxValues(t), n));
    disp("Média: ", avgValues(t));

    pop = newPop; // atribui a nova população ao vetor de população
    j = 1; 
    for i = n:elite
        pop(i) = survivors(j) // atribui os indivíduos salvos pelo elitismo
        j = j + 1;
    end
end

// plot do gráfico de convergência dos melhores/piores indivíduos e a média geral da população
clf();
plot(1:iterations, minValues, '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'w');
plot(1:iterations, maxValues, '-r', 'LineWidth', 2, 'Marker', 's', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'w');
plot(1:iterations, avgValues, '-g', 'LineWidth', 2, 'Marker', 'd', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'w');
xlabel('Iterations');
ylabel('Function Value');
legend('Min', 'Max', 'Avg');
title('Convergence Plot');
