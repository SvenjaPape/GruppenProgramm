% Skript, um eine Datenbank nach verschiedenen Kriterien zu durchsuchen
% Usage: run(SearchData)
% Input Parameter: Suchkriterien per Benutzerabfrage
% Output:
% - Abspielen der gefundenen Sätze, wenn gewünscht
% - Anzeigen des Ordnerpfads der gefundenen Sätze und der Sätze selbst
%-------------------------------------------------------------------------
% Autoren: A. Decker, A. Morgenstern, S. Pape
% (c) IHA @ Jade Hochschule applied licence see LICENCE.md 
% VERSION 2.3
%-------------------------------------------------------------------------

clear all;

%% Abfrage und Speicherung der Suchkriterien 
% GUI für den Benutzer um Suchkriterien einzugeben, in Grundeinstellung leer
Ueberschrift = {'Sprechername:','Satz/Satzteil:','Wort:','Phonem:'};
Titel = 'Suchkriterien';
anzahlLinien = 1;
standard = {'','','',''};
answer = inputdlg(Ueberschrift,Titel,anzahlLinien,standard);

% Speichert jedes Kriterium in eigene Variable
sPerson = answer{1};
sSatz = answer{2};
sWort = answer{3};
sPhonem = answer{4};


%% 1.Block: Sucht mit Kriterium PERSON nach Satz und speichert diese ...
%           mit Pfad in das Array "cPersonKriterium"
cPersonKriterium = {};
counterPerson = 0; %Counter um Array mit Ornernamen zu füllen

dateiID = fopen('TIMIT MIT\allsenlist.txt'); 
zeile = fgetl(dateiID); %Eine Zeile wird aus "allsenlist.txt" rausgelesen
while ischar(zeile)
    pfad = zeile(1:min(strfind(zeile, char(9)))-1); %Vorderen Teil mit Pfad...
                                                    %aus Zeile ausgeschnitten
    % Wenn nach einer Person gesucht wird, werden die passenden Sätze/Pfade...
    %in "cPersonKriterium" gespeichert
    if not(isempty(sPerson)) %Wird eine Person gesucht?
        if regexp(pfad,strcat('[a-zA-Z0-9]+\-[mf]',sPerson)) %Kommt gesuchte ...
                                                             %Person in Pfad vor?
            satz = zeile(max(strfind(zeile, char(9)))+1:end); %Hinteren Teil ...
                                                              %mit Satz aus ...
                                                              %Zeile ausschneiden
            counterPerson = counterPerson + 1;  %Counter für Ergebnis-Array von Pfad + Satz
            %Hinzufügen von Leerzeichen in nächster Zeile notwendig, damit nur ...
            %ganze Worte gefunden werden
            cPersonKriterium{counterPerson,2} = strcat({' '}, satz, {' '});
            cPersonKriterium{counterPerson,1} = pfad;
        end
    % Wenn keine Person gesucht wird: Alle Sätze + Pfade in Array speichern  
    else
        satz = zeile(max(strfind(zeile, char(9)))+1:end); %Hinteren Teil mit ...
                                                          %Satz aus Zeile ausgeschnitten
        counterPerson = counterPerson + 1;  %Counter für Ergebnis-Array von Pfad + Satz
        cPersonKriterium{counterPerson,2} = strcat({' '}, satz, {' '});
        cPersonKriterium{counterPerson,1} = pfad;
    end
    zeile = fgetl(dateiID);
end
fclose(dateiID);


%% 2. Block: Suche von Wort in "cPersonKriterium" aus 1. Block
counterWort = 0;
cWortKriterium = {};

% Ergebnisse in "cPersonKriterium" nach Kriterium WORT durchsuchen
if not(isempty(sWort)) %Wird ein Wort gesucht?
    for n = 1:counterPerson
        %Hinzufügen von Leerzeichen in nächster Zeile notwendig, damit nur ...
        %ganze Worte gefunden werden
        testWortVorhanden = regexp(cPersonKriterium{n,2},strcat({' '}, sWort, {' '})); 
        % Überprüft nacheinander ob gesuchtes WORT in einem Satz aus ...
        %Array "cPersonKriterium" vorkommt
        if not(cellfun(@isempty,testWortVorhanden)) 
            counterWort = counterWort + 1;  %Counter für Ergebnis-Array von Pfad + Satz
            cWortKriterium{counterWort,2} = cPersonKriterium{n,2};
            cWortKriterium{counterWort,1} = cPersonKriterium{n,1};
        end
    end
 else %Alle Sätze in "cWortKriterium" speichern wenn kein Kriterium gegeben
    cWortKriterium = cPersonKriterium;
    counterWort = counterPerson;    %Da array mit counterWort nicht durchgezählt ...
                                    %wird: alten Counter-Wert übernehmen
end


%% 3. Block: Suche von Satz/Satzteil in "cWortKriterium" aus 1. Block
counterSatz= 0;
cSatzKriterium = {};

% Ergebnisse in "cPersonKriterium" nach Kriterium SATZ durchsuchen
if not(isempty(sSatz)) %Wird ein Satz gesucht?
    for n = 1:counterWort 
        testSatzVorhanden = regexp(cWortKriterium{n,2},strcat({' '}, sSatz, {' '})); 
        % Überprüft nacheinander ob gesuchter SATZ in Array "cPersonKriterium" vorkommt
        if not(cellfun(@isempty,testSatzVorhanden)) 
            counterSatz = counterSatz + 1;  %Counter für Ergebnis-Array von Pfad + Satz
            cSatzKriterium{counterSatz,2} = cWortKriterium{n,2};
            cSatzKriterium{counterSatz,1} = cWortKriterium{n,1};
        end
    end
% Alle Sätze in "cSatzKriterium" speichern wenn kein Kriterium gegeben    
else
    cSatzKriterium = cWortKriterium;
    counterSatz = counterWort;  %Da array mit counterSatz nicht durchgezählt ...
                                %wird: alten Counter-Wert übernehmen
end


%% 4.Block: Sucht mit Kriterium PHONEM nach Satz und speichert diese ...
%           mit Pfad in das Array "cPhonemKriterium"
counterErgebnis = 0;
cSuchErgebnis = {};

% Wenn nach einem Phonem gesucht wird speichern der Pfade + Sätze in ...
%"cPhonemKriterium"
if not(isempty(sPhonem))  %Wird ein Wort gesucht?
    cPhonemKriterium = {};
    counterPhonem = 0; %Counter um Array mit gefundenen Pfaden zu füllen

    dateiID = fopen('TIMIT MIT\allphonelist.txt'); 
    zeile = fgetl(dateiID); %Eine Zeile wird aus "allphonelist.txt" rausgelesen
    while ischar(zeile)
        pfad = zeile(1:min(strfind(zeile, char(9)))-1); %Vorderen Teil mit Pfad ...
                                                        %aus Zeile ausgeschnitten
        satz = zeile(max(strfind(zeile, char(9)))+3:end-3); %Hinteren Teil mit ...
                                                            %Satz aus Zeile ausgeschnitten
        testPhonemVorhanden = regexp(satz,strcat({' '}, sPhonem, {' '}));
        % Überprüft nacheinander ob gesuchtes PHONEM in der Zeile vorkommt
        if not(cellfun(@isempty,testPhonemVorhanden)) 
            counterPhonem = counterPhonem + 1;  %Counter hochzählen
            cPhonemKriterium{counterPhonem,2} = satz;
            cPhonemKriterium{counterPhonem,1} = pfad;
        end
        zeile = fgetl(dateiID);
    end
    fclose(dateiID);
    
%%4.1 Block: Speichert alle Ordnerpfade in "cSuchErgebnis" für die ALLE Kriterien zutreffen     
    %Vergleicht Ordnerpfade in "cSatzKriterium" mit denen in ...
    %"cPhonemKriterium" und speichert die übereinstimmenden Ergebnisse
    for nSatz = 1:counterSatz
        for nPhonem = 1:counterPhonem
            if strcmp(cSatzKriterium{nSatz,1},cPhonemKriterium{nPhonem,1})
                counterErgebnis = counterErgebnis + 1;
                cSuchErgebnis{counterErgebnis,1} = cSatzKriterium{nSatz,1};
                cSuchErgebnis{counterErgebnis,2} = cSatzKriterium{nSatz,2};
                break
            end
        end
    end
% Alle Sätze in "cSuchErgebnis" speichern wenn kein Kriterium gegeben   
else 
    cSuchErgebnis = cSatzKriterium; 
    counterErgebnis = counterSatz;
end


%% Error-Ausgabe wenn ein Suchbegriff nicht existiert
% Wenn ein Suchbegriff eingegeben wurde, jedoch kein Ergebnis dazu gefunden ...
%wurde: Fehlerausgabe bezüglich dieses Kriteriums
if not(isempty(sPerson)) && isempty(cPersonKriterium)
    error('Sprecher ist nicht in der Datenbank vorhanden!')
end

if not(isempty(sWort)) && isempty(cWortKriterium)
    error('Wort ist nicht in der Datenbank vorhanden!')
end

if not(isempty(sSatz)) && isempty(cSatzKriterium)
    error('Satz/Satzteil ist nicht in der Datenbank vorhanden!')
end

if not(isempty(sPhonem)) && isempty(cPhonemKriterium)
    error('Phonem ist nicht in der Datenbank vorhanden!')
end


%% Ausgabe: Abspielen der wav.-Dateien von Ordnerpfaden wenn gewünscht
% Benutzerabfrage ob gefundene Sätze abgespielt werden sollen 
Frage = ['Anzahl der gefundenen Sätze: ' num2str(counterErgebnis) ...
       '. Möchten Sie diese nun abspielen?'];
sEntscheidung = questdlg(Frage, 'Benutzerabfrage Abspielen', ...
        'Ja','Nein','Nein');

% Antwort wird verarbeitet. Ja = Abspielen & Ordnerpfad anzeigen; Nein = nur anzeigen
switch sEntscheidung
    case 'Ja'
        for n = 1:counterErgebnis
            % Datei(en) aus "cSuchErgebnis" mit Überordner und .wav ergänzen,
            sErgebnisWav = strcat('TIMIT MIT\', cSuchErgebnis{n,1}, '.wav');
            [y,Fs] = audioread(sErgebnisWav);
            %Rauschentfernungsblock----------------------------------------
            % Überprüft ob im aktuellen ein lautes Rauschen vorhanden ist
            if max(y) > 0.2 || max(y) < -0.2;
                % Macht Rauschen leiser und kennzeichnet dies beim Pfad-Namen
                cSuchErgebnis{n,1} = strcat(cSuchErgebnis{n,1},' !RAUSCHEN GEDÄMPFT');
                for counterSound = 1:length(y)
                    % Alle Amplituden größer +- 0,2 werden mit 0 ersetzt ...
                    %(bei geringerer Grenzamplitude würden Normale beeinflusst)
                    if y(counterSound,1) > 0.2 || y(counterSound,1) < -0.2
                        y(counterSound,1) = 0;
                    end
            %Rauschentfernungsblock-Ende-----------------------------------
                end
            end
            %Abspielen des Satzes
            player = audioplayer(y, Fs); %erstellt "audioplayer" Objekt
            playblocking(player); %.wav werden nacheinander abgespielt
        end
        % Ausgabe der Ordnerpfade der gefundenen Sätze und der Sätze selbst
        disp('Die Sätze die Ihren Kriterien entsprechen (mit Dateipfaden):')
        if size(cSuchErgebnis,1) == 1
            disp([cSuchErgebnis{1,1} cSuchErgebnis{1,2}])
        else 
            for n = (1:length(cSuchErgebnis))
            disp([cSuchErgebnis{n,1} cSuchErgebnis{n,2}])
            end
        end
        
    case 'Nein'
        % Ausgabe der Ordnerpfade der gefundenen Sätze und der Sätze selbst
        disp('Die Sätze die Ihren Kriterien entsprechen (mit Dateipfaden):')
        if size(cSuchErgebnis,1) == 1
            disp([cSuchErgebnis{1,1} cSuchErgebnis{1,2}]) 
        else
            for n = (1:length(cSuchErgebnis))
                disp([cSuchErgebnis{n,1} cSuchErgebnis{n,2}])
            end
        end
end