**README**
----------
> Dieses Projekt bzw. Script SearchData.m dient als Framework zur Erfüllung der gestellen Aufgabe während des Studienmoduls Daten und Algorithmik. 

**Beschreibung des Projektes**
Die Aufgabe der Studierenden bestand darin anhand eines MATLAB-Scripts die MIT/TIMIT-Datenbank durchsuchen zu können. Hierbei sollen unterschiedliche Dateien bzw. Dateiausschnitte gefunden werden und mit Hilfe des Progamms auf diese zugeriffen werden können. 


Die Datenbank soll nach folgenden Kriterien durchsuchbar sein:

 - Aufnahmen einer Person/eines Sprechers
 - Aufnahmen eines Satzes/Satzteils
 - Aufnahmen eines Wortes
 - Aufnahmen eines Phonems

Zusätzlich soll auch die Möglichkeit bestehen nach Kombinationen dieser Kriterien suchen zu können. 


**Benutzungsbeispiele**
Der nachfolgende Codeausschnitt zeigt die Erstellung der Benutzerabfrage. Diese erfolgt durch Verwendung einer GUI. In diese kann der Benutzer den Namen des gesuchten Sprechers, Satzes/Satzteils, Wortes oder Phonems eingeben. Eine Komination dieser Suchkriterien ist ebenfalls möglich.

    Ueberschrift = {'Sprechername:','Satz/Satzteil:','Wort:','Phonem:'};
    Titel = 'Suchkriterien';
    anzahlLinien = 1;
    standard = {'','','',''};
    answer = inputdlg(Ueberschrift,Titel,anzahlLinien,standard);

Mit Hilfe dieses Code-Absatzes wird eine Untersuchung der gesamten Sätze eingeleitet. Dieser Abschnitt ist beispielsweise zur Überprüfung der Einstimmigkeit eines gesuchten Satzes/Satzteils zuständig. 

	counterSatz= 0;
	cSatzKriterium = {};

	if not(isempty(sSatz))
    for n = 1:counterWort 
        testSatzVorhanden = regexp(cWortKriterium{n,2},strcat({' '}, sSatz, {' '})); 
         if not(cellfun(@isempty,testSatzVorhanden)) 

            counterSatz = counterSatz + 1;  %Counter für Ergebnis-Array von Pfad + Satz
            cSatzKriterium{counterSatz,2} = cWortKriterium{n,2};
            cSatzKriterium{counterSatz,1} = cWortKriterium{n,1};
        end
    end
    cSatzKriterium = cWortKriterium;
    counterSatz = counterWort;  
    end

Wenn der Benutzer eine falsche Angabe macht, erfolgt eine Fehlermeldung.  Dabei wird auch zwischen den einzelnen Kriterien unterschieden und eine spezifische Meldung angezeigt, auf welches Kriterium sich diese bezieht.

Des Weiteren wird das vorhandene Rauschen, welches teilweise Sätze/Satzteile überlagert, beim Abspielen des Satzes vermindert bzw. gedämpft.

     if max(y) > 0.2 || max(y) < -0.2;
                cSuchErgebnis{n,1} = strcat(cSuchErgebnis{n,1},' !RAUSCHEN GEDÄMPFT');
                for counterSound = 1:length(y)
                    if y(counterSound,1) > 0.2 || y(counterSound,1) < -0.2
                        y(counterSound,1) = 0;
                    end

Als Abschluss wird eine erneute Benutzerabfrage gestellt, welche als Entscheidungshilfe für den Verwender des Skriptes dient. Hier kann der Benutzer entscheiden, ob die nach den Suchkriterien entsprechend gefundenen Sätze abgespielt oder andernfalls nur im Ausgabefeld angezeigt werden sollen.
Die Soundausgabe erfolgt hierbei über den "audioplayer".



**Dependencies  und Installationshinweise**
Nachfolgende Programmme und Dateien werden zur Verwendung dieses Scripts vorausgesetzt:

 - MATLAB 
 - MIT/TIMIT-Datenbank 

 Bei nicht Vorhandensein eines Punktes ist eine Bedienung des Skriptes nicht möglich.

**Autoren**
Die Studierenden der Jade Hochschule Oldenburg fertigten, als Aufgabe innerhalb des Studienmoduls Daten und Algorithmik, dieses MATLAB-Skript.
Andrea Decker (6007828)
Anika Morgenstern (6006711)
Svenja Pape (600)

**Änderungshistorie**

Version 1.0 -> 14.04.2015
	- Erstellen einer Benutzerabfrage, anhand einer GUI
	- Auslesen der Datenbank
	- Überprüfung der Daten auf die  geforderten Kriterien

Version 1.1 -> 17.04.2015
	 - Neue Idee zur Überprüfung der Übereinstimmung von Sätzen oder Satzteilen, mit den gesuchten Kriterien

Version 2.1 -> 28.04.2015
	 - Verbesserungen des gesamten Codes sowie der Kommentierung

Version 2.2 -> 29.04.2015
	 - Verbesserung und Ergänzung der Kommentierung des MATLAB-Codes
	 - Lösen eines Fehlers im Abfragefenster (nun richtiges Anzeigen der Anzahl der Sätze)
	 - Anzeigen der zutreffenden Sätze zusätzlich zum Dateipfad, als Ausgabe
	 
