% Testskript zum Matlab-Skript SearchData.m
% Author: A.Decker, A.Morgenstern, S. Pape
% (c) IHA @ Jade Hochschule applied licence see EOF 

% Quellen: 
% http://www.mathworks.com/matlabcentral/answers/77461-how-to-compare-two-cell-array
% 04.05.2015

clear;
close all;
clc;

%------------------------------------------------------

SearchData

%% 1.Block:

% Es wird keine Person und auch nichts anderes eingegeben:

if isempty(sPerson)
    
    % Testen, ob die Länge der Ergebnisliste korrekt ist
    assert(length(cPersonKriterium) == 160,...
        'die Ergebnisliste ist nicht vollständig!')
   
    % Testen, ob der letzte Satz aus allsenlist.txt mit dem letzten Satz
    % aus cPersonKriterium übereinstimmt:
    
     assert(~isempty(regexp(char(cPersonKriterium{320}),...
     'twenty two or twenty three','match')),...
     'die Sätze sind nicht korrekt aufgelistet')
end

%% 2. Block: 

% Es wird kein Wort eingegeben:

if isempty(sWort) 
    Vergleich_Wort = cellfun(@strcmp,cWortKriterium,cPersonKriterium);
    Nullelement_Wort = find(Vergleich_Wort == 0);
    assert(isempty(Nullelement_Wort) ,'Falsche Ergebnisliste');
end

%% 3. Block: 

% Es wird kein Satz eingegeben:

if isempty(sSatz)
    Vergleich_Satz = cellfun(@strcmp, cSatzKriterium,cWortKriterium);
    Nullelement_Satz = find(Vergleich_Satz == 0);
    assert(isempty(Nullelement_Satz) ,'Falsche Ergebnisliste');
end

%% Suche nach einer Kombination:

    % Testen, ob anhand der eingegebenen Suchkriterien
    % der erste Satz mit dem richtigen Ordnerpfad
    % aus allsenlist.txt gefunden werden kann

if strcmp(sPerson,'cpm0') == 1 && strcmp(sWort,'suit')==1 ...
    && strcmp(sSatz,'had your')== 1 && strcmp(sPhonem,'sh') == 1 

    assert(~isempty(regexp(char(cSuchErgebnis{2}),...
   'she had your dark suit in greasy wash water all year','match')),...
   'die Sätze sind nicht korrekt aufgelistet')
    
    assert(~isempty(regexp(char(cSatzKriterium{1}),...
    'dr1-mcpm0/sa1','match')),...
    'die Ordnerpfade sind nicht korrekt aufgelistet')  

    % Wenn Satz abgespielt werden soll, Test ob korrektes wav-File vor-...
    % handen und, ob audioplayer existiert
    
    if strcmp(sEntscheidung,'Ja') == 1
        assert(strcmp(sErgebnisWav,'TIMIT MIT\dr1-mcpm0/sa1.wav') == 1,...
        'Nicht das korrekte wav-File')
        assert(isa(player,'audioplayer')==1,...
        'Audioplayer wurde nicht erstellt')
    end
end

    % Testen, ob für die Sucheingabe die Rauschunterdrückung funktioniert
if strcmp(sPerson,'alk0') == 1 && strcmp(sWort,'must')
    if strcmp(sEntscheidung,'Ja') == 1
    AmplMax = find(y > 0.2);
    AmplMin = find(y < -0.2);
    assert(isempty(AmplMax) && isempty(AmplMin)== 1,...
    'keine Rauschunterdrückung')
    end
end

