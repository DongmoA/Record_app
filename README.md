# Leistungensammler (Record App)

**Projekt:** Leistungensammler  
**Hochschule:** THM  
**Semester:** WS 2025  

🔗 **Demo:** https://leistungensammler-demo.app  

---

## Überblick

Der Leistungensammler ist eine plattformübergreifende Flutter-App (Android, iOS, Web) zur Verwaltung und Analyse von Studienleistungen.  
Die Anwendung ermöglicht es Studierenden, ihre erbrachten Leistungen strukturiert zu erfassen und ihren Studienfortschritt transparent nachzuvollziehen.

---

## Kernfunktionen

### Leistungsverwaltung (CRUD)
- Neue Leistung anlegen  
- Bestehende Leistung bearbeiten  
- Leistung löschen (mit Bestätigung)  
- Alle Leistungen in einer Liste anzeigen  

### Statistik
- Anzahl erfasster Leistungen  
- Anzahl 50%-gewichteter Leistungen  
- Summe der Credit Points  
- Fehlende Credit Points bis zum Abschluss  
- Durchschnittsnote (gewichtete Berechnung)  

### Modulkatalog
- Auswahl eines Moduls beim Erstellen einer Leistung  
- Alphabetisch sortierte Modulliste  
- Suche nach Modulname oder Modulnummer  
- Bereits erfasste Module werden ausgeblendet  
- Auswahl kann übersprungen werden  
- Serverseitige Aktualisierung mit `If-Modified-Since` (HTTP 200 / 304)

### Contextual Action Bar (CAB)
- Mehrfachauswahl per Long-Press  
- Kontextabhängige Aktionen auf selektierte Leistungen  
- Automatisches Beenden bei leerer Auswahl  

### Teilen von Leistungen
- Weitergabe über externe Apps (z. B. E-Mail, Messenger)  
- Umsetzung über Flutter-Plugins bzw. Platform-Channels  

---

## Architektur

Die App folgt dem **Folder-by-Layer-Prinzip**:

lib/
├── main.dart
├── data/
├── models/
│ ├── record.dart
│ ├── statistic.dart
│ └── module.dart
├── repositories/
│ ├── record_repository.dart
│ └── module_repository.dart
└── pages/
├── record_list_page.dart
├── record_detail_page.dart
└── module_picker_page.dart


State-Management:
- `ChangeNotifier`
- `Provider`
- `MultiProvider`

---

## Datenmodell

### Record
- Modulnummer  
- Modulname  
- Semester + Jahr  
- Credit Points (3–15)  
- Note in % (50–100 oder null)  
- 50%-Gewichtung (bool)  

### Statistic
Berechnete Werte:
- Anzahl Leistungen  
- Anzahl 50%-Leistungen  
- Summe Credit Points  
- Fehlende Credit Points  
- Durchschnittsnote  

### Module
- number (String)  
- name (String)  
- crp (int)  

---

## Technische Grundlagen

- Flutter (Android, iOS, Web)  
- HTTP-Client für REST-Zugriffe  
- SharedPreferences für lokale Persistenz  
- Platform-Channels für plattformspezifische Funktionen  

---

## Zielgruppe

Studierende, die ihre Studienleistungen strukturiert verwalten und statistisch auswerten möchten.
