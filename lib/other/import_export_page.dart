import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oh_so_you_are/other/utility.dart';
import 'package:file_picker/file_picker.dart';

import '../people/person.dart';

class UploadFromFile extends StatefulWidget {
  const UploadFromFile({super.key});

  @override
  State<UploadFromFile> createState() => _UploadFromFile();
}

@override
class _UploadFromFile extends State<UploadFromFile> {
  bool showFileContent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('persone da file'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Seleziona backup da cui ripristinare',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await Utility.chooseFile();
              if (result == null) {
                return;
              } else {
                //tramuta il testo del file in persone e aggiungile al database
                File fileBackup = File(result.files.first.path!);
                String fileText = fileBackup.readAsStringSync();
                debugPrint("testo del file che hai scelto: \n $fileText");
                try {
                  List<Person> personeDaBackup =
                  Utility.fromJsonToPeople(fileText);
                  for (Person p in personeDaBackup) {
                    await Utility.addPerson(p);
                  }
                } catch (e) {
                  debugPrint("errore nell'aggiunta delle persone dal file: $e");
                }
              }
            },
            child: const Text('Carica da file'),
          ),

          const SizedBox(
            height: 20,
          ),
          const Text(
            'Salva un backup sul dispositivo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () async {
              String? selectedDir =
              await FilePicker.platform.getDirectoryPath();
              if (selectedDir != null) {
                Utility.saveBackup(selectedDir);
              }
            },
            child: const Text('Scegli directory'),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            thickness: 2,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          //bottone per azzerare l'attuale file delle persone
          const Text(
            'COSE CHE FANNO PAURA',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              Utility.peopleListNotifier.value = !Utility.peopleListNotifier.value;
              await Utility.writeOnFile("[]", Utility.allPeopleFileName);
            },
            child: const Text('Azzera il file delle persone'),
          ),
          CheckboxListTile(
            title: const Text('Mostra contenuto attuale del file'),
            value: showFileContent,
            onChanged: (bool? value) {
              setState(() {
                showFileContent = value!;
              });
            },
          ),
          //Future builder per mostrare il file json
          ValueListenableBuilder<bool>(
            valueListenable: Utility.peopleListNotifier,
            builder: (context, value, child) {
              if (showFileContent) {
                return FutureBuilder(
                  future: Utility.readFromFile(Utility.allPeopleFileName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return const Text('Loading...');
                    }
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
