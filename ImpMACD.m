clear all
close all
clc

% EMA(t) = EMA(t – 1) + K*[Precio(t) – EMA(t – 1)]
% primer valor una media simple
% t=valor actual
% t-1=valor previo
% K= 2 / (n + 1) (n=periodo elegido para EMA)

prices = load('Resultados.mat', 'openClosePrice');
tickers = load('Resultados.mat', 'tickers');
% 120 dias recogidos, peso: 0,016%
periodo = 120;
periodSum = periodo/10;
multiplier = (2/(periodo + 1));
names = tickers.tickers;
matrixSize = size(prices.openClosePrice);
closePriceMatrix = [];
% yahoo guarda los datos de mas reciente a mas lejano, los guardamos en
% matrices separadas ordenados de menos cercano a mas cercano
for k = 1 : matrixSize(1, 2)
    cont = 1;
    for z = 1 : matrixSize(1, 1) 
        value = prices.openClosePrice{z, k};
        closePriceMatrix(z, k) = value(1, 2);
        cont = cont + 1;
    end
end

% calculamos los valores EMA y SMA
ema = [];
emaLarge = [];
emaShort = [];
sma = [];
macdMatrix = [];
signal = [];
signalSum = 0;
sum = 0;
macdSum = 0;
for i=1 : matrixSize(1, 2)
    for j=periodSum : matrixSize(1, 1)    
        for k=j-periodSum+1 : j
            sum = sum + closePriceMatrix(k, i);
            if k == j
                sum = sum/periodSum;
                sma(k, i) = sum;
                if k == periodSum
                    ema(k, i) =sum;
                else
                    ema(k, i) = multiplier * (closePriceMatrix(k-1, i) - ema(k-1, i)) + ema(k-1, i);
                end
                if k == periodSum*2 + macdSum
                    emaShort(k , i) = ema(periodSum + macdSum, i);
                    emaLong(k, i) = ema(periodSum*2 + macdSum, i);
                    macdMatrix(k, i) = ema(periodSum + macdSum, i) - ema(periodSum*2 + macdSum, i);
                    macdSum = macdSum + 1;
                end
            end
        end
        sum = 0;
    end
    macdSum = 0;
end
%macdMatrix( ~any(macdMatrix,2), : ) = [];
save('Resultados.mat', 'macdMatrix', '-append');
%macdMatrix = -macdMatrix;
plot(macdMatrix(:,9));
hold on
figure('Name','MACD Apertura/Cierre','NumberTitle','off');
for i = 1 : matrixSize(1, 2)
    graficos = subplot(4, 9, i); 
    plot(graficos, macdMatrix(:,i));
    title(graficos, names(1, i));
end
% subplot(2,2,1)
% plot(emaShort(:,9),'xr')
% hold on
% plot(emaLong(:,9),'xb')
% plot(macdMatrix(:,9)+10,'k')
% grid on