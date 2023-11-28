clc
clear

function element = mutation(binary)
    randomNum = rand();
    
    if randomNum <= 0.9 then
        random = ceil(randomNum * 40 + (randomNum == 0) * 1);
        
        disp(binary(random));
        
        if binary(random) == '0' then
            binary(random) = '1'
        else
            binary(random) = '0';
        end
        
        disp(binary(random));
    end
    
    element = strcat(binary);
endfunction

element = '0000000000000000000011111111111111111111';

binary = strsplit(element);

result = mutation(binary);

disp(element);
disp(result);
