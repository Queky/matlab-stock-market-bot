clear all 
close all
clc

% Indice de Sharpe
% rp = w1*r1 + w2*r2 + ... + wn * rn
% donde r1, r2, ..., rn es el macd de la accion

% cargamos los datos que vamos a necesitar
macdInstance = load('Resultados.mat', 'macdMatrix');
macdMatrix = macdInstance.macdMatrix;

% redimensionamos la matriz para eliminar las filas con 0
%macdMatrix( ~any(macdMatrix,2), : ) = [];
i = size(macdMatrix);
selectedIndexes = {};
sharpeMatrix = sharpe(macdMatrix, 0);
orderedSharpe = sort(sharpeMatrix);
orderedSharpe = fliplr(orderedSharpe);
pos = 1;
indexList = [];
k = 1;
value = orderedSharpe(1, pos);
while k < i(1,2)
   if value == sharpeMatrix(1, k)
       indexList = [indexList k];
       k = 1;
       pos = pos + 1;
       value = orderedSharpe(1, pos);
       if pos == 6
           break;
       end
   end
   k = k + 1;
end
save('Resultados.mat', 'sharpeMatrix', 'indexList', '-append');