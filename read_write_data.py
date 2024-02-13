import pandas as pd
from sqlalchemy import create_engine, MetaData, Table, Column, Text, VARCHAR, Time, Date, Boolean, DECIMAL, SMALLINT

def convert_time(col):
    # Vorverarbeitung: Float zu String konvertieren, Dezimalteil entfernen und mit Nullen auffüllen
    preprocessed_col = col.apply(lambda x: str(int(x)).zfill(4) if not pd.isnull(x) else x)
    # Umwandlung in datetime.time unter Verwendung des vorverarbeiteten Strings
    return pd.to_datetime(preprocessed_col, format='%H%M', errors='coerce').dt.time
        

# alle spalten die in eine Zeitvariabel konvertiert werden sollen
time_columns = ['SCHEDULED_DEPARTURE', 'DEPARTURE_TIME', 'WHEELS_OFF', 'WHEELS_ON', 'SCHEDULED_ARRIVAL', 'ARRIVAL_TIME']
# Spalten deren Null Werte durch in Abhängigkeit einer Bedingung ersetzt werden sollen
delay_columns = ['AIR_SYSTEM_DELAY', 'SECURITY_DELAY', 'AIRLINE_DELAY', 'LATE_AIRCRAFT_DELAY', 'WEATHER_DELAY']
#Spalten die in ein boolean verändert werden sollen
bool_columns = ['DIVERTED', 'CANCELLED']
#url zur Verbindung mit dem Server
url = "postgresql://sikwel:secret#s1kw3lPW@host.docker.internal:5434/sikwel_db"

#Struktur der Tabellen die erstellt werden sollen
#flights enthält keine Fremdschlüssel oder Primärschlüssel die Spalten, die in Frage kommen erfüllen nicht die Bedingungen #dafür da zum Beispiel Airlines außerhalb des airline Datenset in Flight gespeichert werden
table_structure = {
    "airlines": [
        Column('iata_code', VARCHAR(2), primary_key=True, nullable=False),
        Column('airline', Text)
    ],
    "airports": [
        Column('iata_code', VARCHAR(3), primary_key=True, nullable=False),
        Column('airport', Text), 
        Column('city', Text),
        Column('state', VARCHAR(2)),
        Column('country', Text),
        Column('latitude', DECIMAL),
        Column('longitude', DECIMAL)
    ],
    "flights": [
        Column('date', Date),
        Column('day_of_week', SMALLINT),
        Column('airline', VARCHAR(2)),
        Column('flight_number', SMALLINT),
        Column('tail_number', Text),
        Column('origin_airport', VARCHAR(5)),
        Column('destination_airport', VARCHAR(5)),
        Column('scheduled_departure', Time),
        Column('departure_time', Time),
        Column('departure_delay', SMALLINT),
        Column('taxi_out', SMALLINT),
        Column('wheels_off', Time),
        Column('scheduled_time', SMALLINT),
        Column('elapsed_time', SMALLINT),
        Column('air_time', SMALLINT),
        Column('distance', SMALLINT),
        Column('wheels_on', Time),
        Column('taxi_in', SMALLINT),
        Column('scheduled_arrival', Time),
        Column('arrival_time', Time),
        Column('arrival_delay', SMALLINT),
        Column('diverted', Boolean),
        Column('cancelled', Boolean),
        Column('cancellation_reason', VARCHAR(1)),
        Column('air_system_delay', SMALLINT),
        Column('security_delay', SMALLINT),
        Column('airline_delay', SMALLINT),
        Column('late_aircraft_delay', SMALLINT),
        Column('weather_delay', SMALLINT)
    ]
}

# Einlesen der csv Dateien
airlines_df = pd.read_csv('/home/vscode/workspace/data/airlines.csv')
airports_df = pd.read_csv('/home/vscode/workspace/data//airports.csv')
flights_df = pd.read_csv('/home/vscode/workspace/data//flights.csv', low_memory=False)


# Die Spalten Year, Moth, Day werden zu einer Spalte Datum zusammengefasst
list = pd.to_datetime(flights_df[['YEAR', 'MONTH', 'DAY']])
flights_df.insert(0, 'DATE', list)
flights_df.drop(['YEAR', 'MONTH', 'DAY'], axis=1, inplace=True)

#Die convert_time Methode wird auf die Spalten aufgerufen die in Time-Datentypen konvertiert werden sollen
for column_name in time_columns:
    flights_df[column_name] = convert_time(flights_df[column_name])    

# In den Delay Spalten werden Null Werte ersetzt durch 0 wenn der Flug stattgefunden hat, wenn der Flug gecancelled wurde 
# bleiben die Zellen Null, dadurch Zellen nur Null wenn der Flug nicht stattgefunden hat
for column_name_delay in delay_columns:
    flights_df.loc[(flights_df['CANCELLED'] == 0) & (pd.isna(flights_df[column_name_delay])), column_name_delay] = 0

# In den Spalten werden True und Fals eingesetzt in Abhängikeit zur 0 oder 1
for column_name_bool in bool_columns:
     flights_df[column_name_bool] = flights_df[column_name_bool].astype(bool)





# Verbindung wird erstellt und die Tabellen werden erstelle
engine = create_engine(url)
metadata = MetaData()

for table_name, columns in table_structure.items():
    Table(table_name, metadata, *columns)
metadata.create_all(engine)

#alle Spalten werden in lower-case umgeformt dies ermöglicht eine einfachere SQL Abfrage
# da man bei Großbuchstaben bei Aufruf der Spalten diese in Anführungszeichen setzen muss
airports_df.columns = [x.lower() for x in airports_df.columns]
airlines_df.columns = [x.lower() for x in airlines_df.columns]
flights_df.columns = [x.lower() for x in flights_df.columns]

# dataframes werden in die Tabelle geschrieben, if_exists append da sonst die Struktur die vorher 
# definiert wurde überschrieben wird
airlines_df.to_sql(name='airlines',con=engine, if_exists='append', index=False)
airports_df.to_sql(name='airports',con=engine, if_exists='append', index=False)
#chunksize auf 500, da das Programm sonst abstürzt
flights_df.to_sql(name='flights', con=engine, if_exists='append', index=False, chunksize=500)
