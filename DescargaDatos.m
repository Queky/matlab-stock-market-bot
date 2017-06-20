clear all
close all
clc

% Get current date
[this_year, this_month, this_day, this_hour, this_minutes, this_seconds] = datevec(now);
eguna=num2str(this_day);
hilabetea=num2str(this_month);
urtea=num2str(this_year);
ordua=this_hour;
minutuak=this_minutes;
segunduak=this_seconds;

%Comprobar si el mercado esta abierto o cerrado
if ordua>8 && ordua<17
    horario='El mercado esta abierto, adelante con sus operaciones.';
    if ordua==17 && minutuak>30
    horario='El mercado esta cerrado, espere hasta las 9:00.';
    else
    horario='El mercado esta abierto, adelante con sus operaciones.';
    end
else
    horario='El mercado esta cerrado, espere hasta las 9:00.';
end
ordua=num2str(ordua);

%Ajustar el formato de los minutos y los segundos
if minutuak<10
    minutuak=num2str(minutuak);
    minutuak=strcat('0',minutuak);
else
    minutuak=num2str(minutuak);
end
if segunduak<10
    segunduak=num2str(segunduak);
    segunduak=strcat('0',segunduak);
else
    segunduak=num2str(segunduak);
end

%Sacar por pantalla la fecha y hora con la información de apertura
fecha=strcat('Consulta realizada el: ',32,eguna,'/',hilabetea,'/',urtea,' a las ',32,ordua,':',minutuak,':',segunduak);
esp=' ';
disp(fecha);
disp(esp);
disp(horario);
disp(esp);

%programacion bot bolsa en yahoo finance
c = yahoo;

%hay 34 indices
tickers = sort({'ABG.MC', 'ANA.MC', 'ACX.MC', 'ACS.MC', 'AENA.MC', 'AMS.MC', 'MTS.MC', 'POP.MC', 'SAB.MC', 'SAN.MC', 'BKIA.MC', 'BKT.MC', 'BBVA.MC', 'CABK.MC', 'CLNX.MC', 'DIA.MC', 'ENG.MC', 'ELE.MC', 'FER.MC', 'GAM.MC', 'GAS.MC', 'GRF.MC', 'IAG.MC', 'IBE.MC', 'ITX.MC', 'IDR.MC', 'MAP.MC', 'TL5.MC', 'MRL.MC', 'REE.MC', 'REP.MC', 'TRE.MC', 'TEF.MC', 'VIS.MC'});
indexNumber = size(tickers, 2); %numero de indices
numeroSemanas=24; %numero de semanas
dayNumber = numeroSemanas*7 - numeroSemanas*2; %dias de cotizaciones
volume = zeros(dayNumber, indexNumber);
openClosePrice{dayNumber, indexNumber} = {};
maxMinPrice{dayNumber, indexNumber} = {};
for i=1:indexNumber
    yVolume = fetch(c, tickers(1, i), 'volume',now-numeroSemanas*7,now-1);
    yOpen = fetch(c, tickers(1, i), 'open',now-numeroSemanas*7,now-1);
    yClose = fetch(c, tickers(1, i), 'close',now-numeroSemanas*7,now-1);
    yMax = fetch(c, tickers(1, i), 'high',now-numeroSemanas*7,now-1);
    yMin = fetch(c, tickers(1, i), 'low',now-numeroSemanas*7,now-1);
    for j=1:dayNumber
        volume(j, i) = yVolume(j,2); %queremos la 2 columna que contiene el volumen
        openClosePrice(j, i) = {[yOpen(j, 2), yClose(j,2)]};
        maxMinPrice(j , i) = {[yMax(j, 2), yMin(j,2)]};
    end
end
save('Resultados.mat', 'tickers','volume', 'openClosePrice', 'maxMinPrice'); % hay que guardar con '-v7' para que lo reconozca scipy