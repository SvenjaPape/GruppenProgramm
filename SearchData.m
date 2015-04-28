% script to ...
% Usage: run(...)
% Input parameter: None
% Output parameter: None
% Output:
% plays the sum signal
% plots the sum signal
%-------------------------------------------------------------------------%
% Authors: A. Decker, A. Morgenstern, S. Pape
% (c) IHA @ Jade Hochschule applied licence see EOF 
% Sources: 
%   - inputdlg, Matlab documentation
% function 'SinSignal' by J. Bitzer and M. Hansen, taken from the script
% 'Grundlagenpraktikum: Matlabversuche'
%-fgetl
% VERSION 2.1
%-------------------------------------------------------------------------%


%% Abfrage und Speicherung der Suchkriterien 
%GUI für den Benutzer um Suchkriterien einzugeben, in Grundeinstellung leer
prompt = {'Sprechername:','Satz/Satzteil:','Wort:','Phonem:'};
dlg_title = 'Suchkriterien';
num_lines = 1;
def = {'','','',''};
answer = inputdlg(prompt,dlg_title,num_lines,def);

%Speichert jedes Kriterium in eigene Variable
sPerson = answer{1};
sSatz = answer{2};
sWort = answer{3};
sPhonem = answer{4};


%% 1.Block: Sucht mit Kriterium PERSON/ALLEN PERSONEN  nach Satz und speichert diese mit Pfad in das Array "cPersonKriterium"
cPersonKriterium = {};
counterPerson = 0; % counter to fill array of found directory names

dateiID = fopen('TIMIT MIT\allsenlist.txt'); 
zeile = fgetl(dateiID); %Eine Zeile wird aus "allsenlist.txt" rausgelesen
while ischar(zeile)
    pfad = zeile(1:min(strfind(zeile, char(9)))-1); %vorderen Teil mit Pfad aus Zeile ausgeschnitten
    if not(isempty(sPerson))  %Wenn nach einer Person gesucht wird ...
        if regexp(pfad,strcat('[a-zA-Z0-9]+\-[mf]',sPerson)) %Kommt gesuchte Person in Pfad vor?
            satz = zeile(max(strfind(zeile, char(9)))+1:end); %hinteren Teil mit Satz aus Zeile ausgeschnitten
            counterPerson = counterPerson + 1;  %Counter für Ergebnis-Array von Pfad + Satz
            cPersonKriterium{counterPerson,2} = strcat({' '}, satz, {' '}); %Notwendig, damit einzelne Worte am Satzanfang/-ende gefunden werden können
            cPersonKriterium{counterPerson,1} = pfad;
        end
    else % Wenn nach keiner Person gesucht: Alle Sätze + Pfad in Array
        satz = zeile(max(strfind(zeile, char(9)))+1:end); %hinteren Teil mit Satz aus Zeile ausgeschnitten
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
for n = 1:counterPerson 
 if not(isempty(sWort)) %Wird ein Wort gesucht?
    testWortVorhanden = regexp(cPersonKriterium{n,2},strcat({' '}, sWort, {' '})); %Notwendig, damit nur ganze Worte gefunden werden
    if not(cellfun(@isempty,testWortVorhanden)) % Überprüft nacheinander ob gesuchtes WORT in einem Satz aus Array "cPersonKriterium" vorkommt
        counterWort = counterWort + 1;  %Counter für Ergebnis-Array von Pfad + Satz
        cWortKriterium{counterWort,2} = cPersonKriterium{n,2};
        cWortKriterium{counterWort,1} = cPersonKriterium{n,1};
    end    
 else %Alle Sätze in "cWortKriterium" speichern wenn kein Kriterium gegeben
     counterWort = counterWort + 1;  %Counter für Ergebnis-Array von Pfad + Satz
     cWortKriterium{counterWort,2} = cPersonKriterium{n,2};
     cWortKriterium{counterWort,1} = cPersonKriterium{n,1};
 end
end


%% 3. Block: Suche von Satz/Satzteil in "cPersonKriterium" aus 1. Block
%IN ORDNUNG DAS ER AUCH SATZTEILE SUCHT??? (ich glaube ja, dann muss man nicht den ganzen Satz eingeben)
counterSatz= 0;
cSatzKriterium = {};

% Ergebnisse in "cPersonKriterium" nach Kriterium SATZ durchsuchen
for n = 1:counterPerson 
 if not(isempty(sSatz)) %Wird ein Satz gesucht?
    testSatzVorhanden = regexp(cPersonKriterium{n,2},strcat({' '}, sSatz, {' '})); %Für Übersicht außerhalb der if-Abfrage definiert
    if not(cellfun(@isempty,testSatzVorhanden)) % Überprüft nacheinander ob gesuchter SATZ in Array "cPersonKriterium" vorkommt
        counterSatz = counterSatz + 1;  %Counter für Ergebnis-Array von Pfad + Satz
        cSatzKriterium{counterSatz,2} = cPersonKriterium{n,2};
        cSatzKriterium{counterSatz,1} = cPersonKriterium{n,1};
    end
 else %Alle Sätze in "cSatzKriterium" speichern wenn kein Kriterium gegeben
     counterSatz = counterSatz + 1;  %Counter für Ergebnis-Array von Pfad + Satz
     cSatzKriterium{counterSatz,2} = cPersonKriterium{n,2};
     cSatzKriterium{counterSatz,1} = cPersonKriterium{n,1};
 end
end

%% Error-Ausgabe wenn ein Suchbegriff nicht existiert
if not(isempty(sPerson)) && isempty(cPersonKriterium)
    error('Sprecher ist nicht in der Datenbank vorhanden!')
end

if not(isempty(sWort)) && isempty(cWortKriterium)
    error('Wort ist nicht in der Datenbank vorhanden!')
end

if not(isempty(sSatz)) && isempty(cSatzKriterium)
    error('Satz/Satzteil ist nicht in der Datenbank vorhanden!')
end






%% ALT!
% listing = dir('TIMIT MIT');
% cDir2seek = {}; %c DAVOR WIRKLICH FÜR EINEN CELL ARRAY??
% 
% %if-loop to check if criterion is not empty and to save directory names
% %which fit criteria
% if sPerson ~= ' '
%     for i = (1:length(listing))
%          if listing(i).isdir == 1 % checks if result is directory
%              listing(i).name
%              if regexp(listing(i).name,strcat('[a-zA-Z0-9]+\-[mf]',sPerson)) % checks if name matches
%                 cDir2seek{1,1} = listing(i).name; % saves directory name in cell array
%              end
%          end
%     end
% else
%     for i = (1:length(listing)) % if no name qualified, creates cell array of all directory names
%          if listing(i).isdir == 1 && length(listing(i).name)>4 % checks if valid directory
%              counter = counter + 1;
%              cDir2seek{1,counter} = listing(i).name;
%          end
%     end
% end


%--------------------Licence ---------------------------------------------
% Copyright (c) <2014> A. Decker, A. Morgenstern, S. Pape
% Institute for Hearing Technology and Audiology
% Jade University of Applied Sciences Oldenburg 
% Permission is hereby granted, free of charge, to any person obtaining 
% a copy of this software and associated documentation files 
% (the "Software"), to deal in the Software without restriction, including 
% without limitation the rights to use, copy, modify, merge, publish, 
% distribute, sublicense, and/or sell copies of the Software, and to 
% permit persons to whom the Software is furnished to do so, subject 
% to the following conditions:
% The above copyright notice and this permission notice shall be included 
% in all copies or substantial portions of the Software.
 % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
