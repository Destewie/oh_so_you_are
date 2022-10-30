//page where to show all info of a person

import 'package:flutter/material.dart';
import 'package:oh_so_you_are/people/person.dart';

import '../other/utility.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    //create a page to show all info of a person,
    // the navigator passes the person as argument
    Person personToShow = ModalRoute.of(context)!.settings.arguments as Person;

    String fumo = personToShow.fumo ? "Si" : "-";
    String tatuaggi = personToShow.tatuaggi ? "Si" : "-";
    String piercing = personToShow.piercing ? "Si" : "-";

    List<String> majorInfo = personToShow.whatToShowOfAPerson();

    //show all info of a person
    return Scaffold(
      appBar: AppBar(
        title: Text(personToShow.soprannome),
        actions: [
          IconButton(
            onPressed: () {
              //apri pagina per modificare una persona
              Navigator.pushNamed(context, '/modify_person', arguments: personToShow);
            },
            icon: const Icon(Icons.mode_edit_sharp),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: Utility.peopleListNotifier,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                Text(
                  majorInfo[0],
                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text(
                  majorInfo[1],
                  style: const TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 15,
                ),

                //Tutte le info della persona
                const Text(
                  'Soprannome',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.soprannome,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Nome',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.nome,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Cognome',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.cognome,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Luogo associato',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.luogoAssociato,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Sesso',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.sesso,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Pelle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.pelle,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Altezza',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.altezza,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Carattere',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.carattere,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Corporatura',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.corporatura,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Colore capelli',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.coloreCapelli,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Taglio capelli',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.taglioCapelli,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Occhiali',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.occhiali,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Stile vestiario',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  personToShow.vestiario,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Fumo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  fumo,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Tatuaggi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  tatuaggi,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Piercing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  piercing,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
