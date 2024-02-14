from kaggle.api.kaggle_api_extended import KaggleApi
import zipfile

#Vor dieser Ausführung kaggle.json in /home/vscode/.kaggel verschieben, mit chmod 600 /home/vscode/.kaggle/kaggle.json um den key zu sicher
kaggle_api = KaggleApi()
kaggle_api.authenticate()

kaggle_api.dataset_download_file('usdot/flight-delays','airlines.csv', path='/home/vscode/workspace/data')
kaggle_api.dataset_download_file('usdot/flight-delays','airports.csv', path='/home/vscode/workspace/data')
kaggle_api.dataset_download_file('usdot/flight-delays','flights.csv', path='/home/vscode/workspace/data')

#die Datei wird im zip Format gedownloadet
zip_name = '/home/vscode/workspace/data/flights.csv.zip'

# Öffnen des ZIP-Archivs im Lesemodus
with zipfile.ZipFile(zip_name, 'r') as zip_ref:
    # Extrahieren aller Dateien im ZIP-Archiv ins aktuelle Verzeichnis
    zip_ref.extractall('/home/vscode/workspace/data')