clear all
clc

SearchData
%% 1.Block: Sucht mit Kriterium PERSON nach Satz und speichert diese ...

% es wird stichprobenartig nach einer Personenangabe getestet
% Suche nach Person 'alk'

if strcmp(sPerson,'alk') == 1

    %Testen, ob die Länge der Ergebnisliste korrekt ist
    assert(length(cPersonKriterium) == 10, 'die Ergenisliste ist nicht vollständig!')
    % Testen, ob die Sätze richtig aufgelistet wurden
    assert(~isempty(regexp(char(cPersonKriterium{19}),'then the choreographer must arbitrate','match')),'die Sätze sind nicht korrekt aufgelistet')

    % Testen, ob die Ordnerpfade korrekt aufgelistet wurden
    assert(~isempty(regexp(char(cPersonKriterium{1}),'dr3-falk0/sa1','match')),'die Ordnerpfade sind nicht korrekt aufgelistet')
end

%% Es wird keine Person eingegeben:

% Lösung aus http://arnabocean.com/frontposts/2013-10-14-matlabstrfind/
% 04.05.2015

if isempty(sPerson)
    % Testen, ob die Länge der Ergebnisliste korrekt ist
    assert(length(cPersonKriterium) == 160, 'die Ergenisliste ist nicht vollständig!')

    % Testen ob beliebiger Sprecher in der Ergebnisliste vorhanden ist
    Ordnerpfade = cPersonKriterium(1:160);
    Personensuche = 'alr';
    index = strfind(Ordnerpfade,Personensuche);
    index = find(~cellfun(@isempty,index));
    if isempty(index)
            error('Sprecher fehlt')
    end
end


%% 2. Block: Suche von Wort in "cPersonKriterium" aus 1. Block

% es wird stichprobenartig nach einer Worteingabe getestet
% Suche nach Wort 'must'

if strcmp(sWort,'must') == 1
    % Testen, ob die Länge der Ergebnisliste korrekt ist
    assert(length(cWortKriterium) == 2, 'die Ergenisliste ist nicht vollständig!')
    % Testen, ob die Sätze richtig aufgelistet wurden
    assert(~isempty(regexp(char(cWortKriterium{4}),'according to my interpretation of the problem two l...','match')),'die Sätze sind nicht korrekt aufgelistet')
    % Testen, ob die Ordnerpfade korrekt aufgelistet wurden
    assert(~isempty(regexp(char(cWortKriterium{2}),'dr8-fbcg1/sx352','match')),'die Ordnerpfade sind nicht korrekt aufgelistet')
end

%% Es wird kein Wort eingegeben:

if isempty(sWort)
    %Testen, ob die Länge der Ergebnisliste korrekt ist
    assert(length(cWortKriterium) == 160, 'die Ergebnisliste ist nicht vollständig!')

    %Testen ob beliebiges Wort in der Ergebnisliste vorhanden ist

    Saetze = strcat(cWortKriterium{:,2});
    Wortsuche = 'dark';
    index = strfind(Saetze,Wortsuche);
    index = find(~cellfun(@isempty,index));
    if isempty(index)
            error('Wort fehlt')
    end
end
%% 3. Block: Suche von Satz/Satzteil in "cWortKriterium" aus 1. Block

% es wird stichprobenartig nach einer Satzeingabe getestet
% Suche nach Satz 'maybe they will take us'

if strcmp(sSatz,'maybe they will take us') == 1
    %Testen, ob die Länge der Ergebnisliste korrekt ist
    %WO IST DER FEHLER
    assert(length(cSatzKriterium) == 1, 'die Ergenisliste ist nicht vollständig!')
    Testen, ob die Sätze richtig aufgelistet wurden
    assert(~isempty(regexp(char(cSatzKriterium{2}),'maybe they will take us','match')),'die Sätze sind nicht korrekt aufgelistet')
    Testen, ob die Ordnerpfade korrekt aufgelistet wurden
    assert(~isempty(regexp(char(cSatzKriterium{1}),'dr2-marc0/si1188','match')),'die Ordnerpfade sind nicht korrekt aufgelistet')
end

%% Es wird kein Satz eingegeben:

if isempty(sSatz)
    
    %Testen, ob die Länge der Ergebnisliste korrekt ist
    assert(length(cSatzKriterium) == 160, 'die Ergebnisliste ist nicht vollständig!')
    
    %Testen ob beliebiger Satz in der Ergebnisliste vorhanden ist
    Saetze = strcat(cSatzKriterium{:,2});
    Satzsuche = 'woe betide the interviewee if he answered vaguely';
    index = strfind(Saetze,Satzsuche);
    index = find(~cellfun(@isempty,index));
     if isempty(index)
        error('Satz fehlt')
    end
end
%% 4.Block: Sucht mit Kriterium PHONEM nach Satz und speichert diese ...
%           mit Pfad in das Array "cPhonemKriterium"



%% Suche nach dem Phonem: ''