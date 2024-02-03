# siːkwəl: Trainee Data Engineering 🚀

Moin moin! Willkommen zum Data Engineering Trainee-Projekt – hier geht's um Docker, Python, Kaggle-API und ein paar Daten! Lies dir die Anleitung sorgsam durch und starte direkt mit dem Projekt.

## Was du brauchst

### Git

Wenn du Git nicht hast, hol's dir hier: [Git Downloads](https://git-scm.com/downloads)

### Docker Desktop

Für dieses Projekt brauchst du Docker Desktop: [Docker Desktop](https://www.docker.com/products/docker-desktop)

#### Windows-Nutzer: WSL2 Installation

Unter Windows brauchst du WSL2. Hier lang: [WSL2 Installation Guide](https://docs.docker.com/desktop/wsl/)

### VSCode

Als Entwicklungsumgebung nutzen wir einen vordefinierten Docker-Container. In diesem findest du Python und die wichtigsten Pakete bereits installiert. Damit das läuft, benötigst du VSCode. Falls du bereits eine andere IDE hast die sich mit einem Docker-Container verbindet, auch gut!

## Projekt-Setup

1. Klone das Repo:

    ```bash
    git clone https://github.com/sikwel/demo-project.git
    cd demo-project
    ```

2. Öffne das Projekt in Visual Studio Code – der Devcontainer regelt!

3. Devcontainer hat alles, was du brauchst. Falls etwas fehlt installiere es dir einfach per `pip`.

4. Du findest im Container auch einige hilfreiche Extensions für VSCode wie beispielsweise einen SQL Client. Diesen kannst du nutzen um später eine Verbindung zur Datenbank herzustellen. Auch hier gilt, hast du bereits etwas auf deinem Laptop installiert, kannst du auch diesen nutzen.

## Was wir machen

Unser Trainee-Projekt hat ein paar Aufgaben für dich vorgesehen:

1. **Kaggle-API-Zauber:**
    - Schnapp dir die [Daten](https://www.kaggle.com/datasets/usdot/flight-delays?select=flights.csv) mit der Kaggle-API.
    - Python und Kaggle-Bibliothek machen's möglich.

2. **Daten-Playtime mit Pandas:**
    - Lade Daten in ein Pandas-Datenframe und spiele ein wenig mit den Daten
    - Schau mal ob die Datentypen Sinn ergeben oder ob man noch etwas verbessern könnte.
    - Lade die einzelnen Dateien aus Kaggle per Python in eine separate Tabelle in die PostgreSQL Datenbank.

3. **PostgreSQL mit Docker:**
    - Wir haben dir einen PostgreSQL Server mit allem drum und dran in den DevContainer gelegt.
    - Die Verbindungsdaten findest du am Ende der Anleitung.

4. **SQL-Fragen beantworten:**
    - Wir haben ein paar SQL Fragen für dich vorbereitet. Schau mal was du uns zu den Daten sagen kannst die du dir eben runtergeladen hast ;)

5. **Python-Extras für Trainee-Helden:**
    - Halt den Code clean und kommentiere klug.
    - Nutze `git` um dein Projekt zu versionieren und am Ende wieder in das Repository zu pushen damit wir uns dein Ergebnis anschauen können.

## Let's Rock!

Nach dem Setup sollte die PostgreSQL-Datenbank voll sein und die SQL-Fragen beantwortet. Wir bewerten nicht nur Code-Skills, sondern auch Kreativität und den Spaß am Coden.

Viel Erfolg, und wenn du Fragen hast, sind wir da! Happy coding! 🚀✨


## Anhang

### SQL-Fragen

- Zeige die Routen, die von Ronald Reagan Washington National Airport (DCA) ausgehen. Ich möchte wissen
welche Strecken gestrichen wurden, aus welchem Grund und wann dies geschah.

- Ich möchte wissen, welches die verkehrsreichsten Strecken sind. Ich bin zudem daran interessiert, welche
Fluggesellschaften den größten Anteil an diesen Flügen haben.

- Da das Wetter die Hauptursache für Flugannullierungen ist, möchte ich wissen, sofern die Flüge
nicht gestrichen wurden, wie lang waren die Verspätungen? Auf welchen Strecken gab es die meisten Verspätungen?

- Welche Staaten haben die meisten Annullierungen. In welchem Monat werden die meisten bzw. die wenigsten Flüge annulliert?

- Was ist der Durchschnitt der Verspätung pro Airline am Ziel- bzw. Startflughafen?

- Ich möchte wissen, wie hoch der Anteil der pünktlichen und verspäteten Flüge bei den einzelnen Fluggesellschaften ist. Die FAA betrachtet es als Verspätung, wenn ein Flug mehr als 15 Minuten später als geplant ankommt. Welche Airline hat den höchsten prozentualen Anteil an sehr verspäteten Flügen (> 45 Min Delay?)

- Welche Top 10 Airlines steuern die meisten Flughäfen an? 

- Welche Flüge/Verbindungen haben prozentual am häufigsten Verspätungen? Und aus welchem Grund?

- An welchen Wochentagen gibt es die meisten bzw. größten Verspätungen – absolut und prozentual? 


### Credentials

- Datenbank:  sikwel_db
- Benutzer:   sikwel
- Passwort:   secret#s1kw3lPW
- Port:       5434
- Host:       localhost oder host.docker.internal

### Nützliche Links

[DevContainers](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-an-existing-folder-in-a-container)
