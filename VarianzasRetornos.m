clc
clear all
close all

indexInstance = load('Resultados.mat', 'indexList');
openCloseInstance = load('Resultados.mat', 'openClosePrice');
macdInstace = load('Resultados.mat', 'macdMatrix');
indicesElegidos = indexInstance.indexList;
preciosApertCierre = openCloseInstance.openClosePrice;
macdMatrix = macdInstace.macdMatrix;
tam = size(preciosApertCierre);
preciosCierre = [];
inversion = 10000;

% Cogemos los precios de cierre
for k = 1 : tam(1, 2)
    for z = 1: tam(1, 1)
        vector = preciosApertCierre{z, k};
        preciosCierre(z, k) = vector(1, 2);
    end
end

% Calculamos media y verianza
medias = [];
media = 0;
varianzas = [];
varianza = 0;
porInversion = [];
buySellMatrix = [];
returnMatrix = [];
comprar = 1;
%comprar = 0 // hay que vender
%comprar = 1 // hay que comprar de nuevo
%comprar = 2 // mantenemos
investmentQ = [];
equilibradoInversion = 0;
cont = 0;

for i = 1 : 5
    indice = indicesElegidos(1, i);
    for j = tam(1, 1) : -1 : 1
        precio = preciosCierre(j, indice);
        if macdMatrix(j, indice) >= 0
            media = media + precio;
            varianza = varianza + (precio * precio);
            cont = cont + 1;
            if comprar == 1 || comprar == 0
                returnMatrix = [returnMatrix ; precio];
                comprar = 2;
            end
        else
            returnMatrix = [returnMatrix ; precio];
            comprar = 0;
        end
        if comprar == 2 && j == 1
            returnMatrix = [returnMatrix ; precio];
        end
    end
    comprar = 1;
    medias(1, i) = media / cont;
    varianzas(1, i) = (varianza / cont) - media*media;
    cont = 0;
    varianza = 0;
    media = 0;
    buySellMatrix = [buySellMatrix returnMatrix];
    returnMatrix = [];
    %calculamos las w en funcion del % que gana cada indice
    investmentQ(1, i) = ((buySellMatrix(2, i)*100/buySellMatrix(1, i)) - 100)*sqrt(varianzas(1, i));
    equilibradoInversion = equilibradoInversion + investmentQ(1, i);
end

for i = 1 : 5
   investmentQ(1, i) = 100*investmentQ(1, i)/equilibradoInversion;
end

spent = [];
wins = [];
sumaGanacias = 0;

for i = 1 : 5
    spent(1, i) =  inversion*(investmentQ(1, i)/100);
    activeNumber = spent(1, i)/buySellMatrix(1, i);
    wins(1, i) = activeNumber*buySellMatrix(2, i);
    sumaGanacias = sumaGanacias + wins(1, i);
end

save('Resultados.mat', 'varianzas', 'investmentQ', 'wins','-append');