import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:oh_so_you_are/other/dropdown_items.dart';
import 'package:path_provider/path_provider.dart';

import '../people/person.dart';

//classe per la gestione del file
class Utility {
  static const String allPeopleFileName = "people.json";
  static const String allPlacesFileName = "places.json";

  static List<Person> ultimaListaDiPersoneLetta = [];
  static ValueNotifier<bool> placesListNotifier = ValueNotifier(false);
  static ValueNotifier<bool> peopleListNotifier = ValueNotifier(false);

  static Map<String, dynamic> filter = {};

  //--------------------------------------------------------------------------------

  //private constructor to avoid instantiation
  Utility._();

  //--------------------------------------------------------------------------------

  //funzione per scrivere su file
  static Future<void> writeOnFile(String text, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    await file.writeAsString(text);
  }

  //--------------------------------------------------------------------------------

  //funzione per leggere da file
  static Future<String> readFromFile(String fileName) async {
    String text = "";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName');
      text = await file.readAsString();
    } catch (e) {
      debugPrint("Couldn't read file");
    }

    return text;
  }

  //--------------------------------------------------------------------------------

  //funzione per scegliere un file tramite il file picker
  static Future<FilePickerResult?> chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      debugPrint(file.name);
      debugPrint(file.extension);
      debugPrint(file.path);
    } else {
      // User canceled the picker
      debugPrint('User canceled the picker');
    }

    //occhio che è null se non si sceglie nessun file
    return result;
  }

  //--------------------------------------------------------------------------------

  //funzione per leggere il file e convertirlo in una lista di persone
  static List<Person> fromJsonToPeople(String text) {
    List<Person> peopleList = [];
    List<dynamic> people = [];
    try {
      people = jsonDecode(text);
    } catch (e) {
      debugPrint("Errore nella conversione del file in json: $e");
    }
    for (var person in people) {
      try {
        peopleList.add(Person.fromJson(person));
      } catch (e) {
        debugPrint("Non sono riuscito ad aggiungere la persona: $e");
      }
    }

    ultimaListaDiPersoneLetta = peopleList;
    return peopleList;
  }

  //--------------------------------------------------------------------------------

  //funzione per creare il file di backup in base alla data e l'ora
  static String createBackupFileName() {
    DateTime now = DateTime.now();
    String fileName =
        "peopleBackup_${now.year}_${now.month}_${now.day}__${now.hour}_${now.minute}_${now.second}.json";
    return fileName;
  }

  //--------------------------------------------------------------------------------

  //funzione per salvare una copia del file json in una directory scelta dall'utente
  static Future<void> saveBackup(String dir) async {
    //prendi il file da salvare
    String text = await readFromFile(allPeopleFileName);

    //salvalo nella directory scelta
    final File file = File('$dir/${createBackupFileName()}');
    await file.writeAsString(text);
  }

  //--------------------------------------------------------------------------------

  //funzione per leggere il file e convertirlo in una lista di luoghi
  static Future<List<String>> readPlacesFromFile(String fileName) async {
    String text = await readFromFile(fileName);

    List<String> placesList = [DropdownItems.defaultValue];
    try {
      List<dynamic> places = jsonDecode(text);
      for (String place in places) {
        if (place != DropdownItems.defaultValue && !placesList.contains(place)) {
          placesList.add(place);
        }
      }
    } catch (e) {
      debugPrint("Errore nella decodifica da json a lista di luoghi: $e");
    }

    return placesList;
  }
  
  //--------------------------------------------------------------------------------
  
  //funzione per prendere tutti i luoghi da tutte le persone
static Future<List<String>> getUsedPlaces() async {
    List<String> places = [DropdownItems.luoghiItems[0]];
    List<Person> people = Utility.fromJsonToPeople(await Utility.readFromFile(Utility.allPeopleFileName));
    for (Person person in people) {
      //se il luogoassociato non è ancora presente in places, aggiungilo
      if (!places.contains(person.luogoAssociato)) {
        places.add(person.luogoAssociato);
      }
    }
    
    return places;
  }

  //--------------------------------------------------------------------------------

  //ritorna una lista che unisce i luoghi di tutte le persone e quelli già presenti nel file
static Future<List<String>> getAllPlaces() async {
    List<String> places = await readPlacesFromFile(allPlacesFileName);
    List<String> peoplePlaces = await getUsedPlaces();
    for (String place in peoplePlaces) {
      if (!places.contains(place)) {
        places.add(place);
      }
    }

    return places;
  }


  //--------------------------------------------------------------------------------

  //funzione per aggiungere una persona alla lista
  static Future<void> addPerson(Person person) async {
    String fileText = await Utility.readFromFile(Utility.allPeopleFileName);
    List<Person> people = Utility.fromJsonToPeople(fileText);
    //add person if his id is not already in the list
    if (!people.any((element) => element.id == person.id)) {
      people.add(person);
      debugPrint(
          "Aggiunta persona: nome: ${person.persName}, cognome: ${person.persSurname}, nickname: ${person.persNickname}");
      String json = jsonEncode(people);
      peopleListNotifier.value = !peopleListNotifier.value;
      await writeOnFile(json, Utility.allPeopleFileName);
    }
  }

  //--------------------------------------------------------------------------------

  //funzione per aggiungere un luogo alla lista
  static Future<void> addPlace(String place) async {
    debugPrint("adding place: $place");
    List<String> places = await Utility.readPlacesFromFile(Utility.allPlacesFileName);
    //aggiungi il luogo se non è già presente
    if (!places.contains(place)) {
      places.add(place);
      String json = jsonEncode(places);
      await writeOnFile(json, Utility.allPlacesFileName);
      placesListNotifier.value = !placesListNotifier.value;
    } else {
      debugPrint("place already present");
    }
  }

  //--------------------------------------------------------------------------------

  //funzione per eliminare un elemento dalla lista di persone attraverso l'id
  static Future<void> deletePerson(String id) async {
    String fileText = await Utility.readFromFile(Utility.allPeopleFileName);
    List<Person> people = fromJsonToPeople(fileText);
    people.removeWhere((element) => element.id == id);
    peopleListNotifier.value = !peopleListNotifier.value;
    await writeOnFile(jsonEncode(people), Utility.allPeopleFileName);
  }

  //--------------------------------------------------------------------------------

  //funzione per eliminare un elemento dalla lista di luoghi attraverso il nome
  static Future<void> deletePlace(String place) async {
    List<String> places = await readPlacesFromFile(Utility.allPlacesFileName);
    //se il nome non è nella lista torna un errore
    try {
      places.removeWhere((element) => element == place);
      await writeOnFile(jsonEncode(places), Utility.allPlacesFileName);
      placesListNotifier.value = !placesListNotifier.value;
      debugPrint("place $place deleted");
    } catch (e) {
      debugPrint("Errore nella cancellazione del luogo: $e");
    }
  }

//--------------------------------------------------------------------------------

static Future<Person> searchPerson(String id) {
    //si prende la lista delle persone dal file e ritorna quella co id uguale al parametro
    return Utility.readFromFile(Utility.allPeopleFileName).then((value) {
      List<Person> people = Utility.fromJsonToPeople(value);
      return people.firstWhere((element) => element.id == id);
    });
}

//--------------------------------------------------------------------------------

}
