% Testskript zum Matlab-Skript SearchData.m
% Author: A.Decker, A.Morgenstern, S. Pape
% (c) IHA @ Jade Hochschule applied licence see EOF 
% Version History:
% Ver. 0.01 initial create (empty) 04-May-2015 
% Ver. 1.0  first implementation   04-May-2015 

% Quellen: 

clear;
close all;
clc;

%------------------------------------------------------

SearchData

%% 1.Block:

% Es wird keine Person und auch nichts anderes eingegeben:

if isempty(sPerson)
    
    % Testen, ob die L�nge der Ergebnisliste korrekt ist
    assert(length(cPersonKriterium) == 160,...
        'die Ergebnisliste ist nicht vollst�ndig!')
   
    % Testen, ob der letzte Satz aus allsenlist.txt mit dem letzten Satz
    % aus cPersonKriterium �bereinstimmt:
    
     assert(~isempty(regexp(char(cPersonKriterium{320}),...
     'twenty two or twenty three','match')),...
     'die S�tze sind nicht korrekt aufgelistet')
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
   'she had your dark suit in greasy wash water all year','match'),...
   'die S�tze sind nicht korrekt aufgelistet'))
    %Testen, ob die Ordnerpfade korrekt aufgelistet wurden
    
    assert(~isempty(regexp(char(cSatzKriterium{1}),...
    'dr1-mcpm0/sa1','match'),...
    'die Ordnerpfade sind nicht korrekt aufgelistet'))  
end



