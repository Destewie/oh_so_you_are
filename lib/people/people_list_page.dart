import 'package:flutter/material.dart';

import 'person.dart';
import '../other/utility.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({Key? key}) : super(key: key);


  @override
  State<PeopleList> createState() => _PeopleList();
}

//funzione per filtrare la lista di persone
Future<List<Person>> filterPeople() async {
  Map<String, dynamic> filtro = Utility.filter;
  String fileText = await Utility.readFromFile(Utility.allPeopleFileName);
  List<Person> people = Utility.fromJsonToPeople(fileText);
  List<Person> filteredPeople = [];
  for (Person person in people) {
    //if any property is not '-', person must have it
    if ((filtro["luogo"] == null || person.luogoAssociato == filtro["luogo"]) &&
        (filtro["sesso"] == null || person.sesso == filtro["sesso"]) &&
        (filtro["pelle"] == null || person.pelle == filtro["pelle"]) &&
        (filtro["altezza"] == null || person.altezza == filtro["altezza"]) &&
        (filtro["carattere"] == null ||
            person.carattere == filtro["carattere"]) &&
        (filtro["corporatura"] == null ||
            person.corporatura == filtro["corporatura"]) &&
        (filtro["coloreCapelli"] == null ||
            person.coloreCapelli == filtro["coloreCapelli"]) &&
        (filtro["taglioCapelli"] == null ||
            person.taglioCapelli == filtro["taglioCapelli"]) &&
        (filtro["occhiali"] == null || person.occhiali == filtro["occhiali"]) &&
        (filtro["stileVestiario"] == null ||
            person.vestiario == filtro["stileVestiario"]) &&
        (filtro["fumo"] == null || person.fumo == filtro["fumo"]) &&
        (filtro["tatuaggi"] == null || person.tatuaggi == filtro["tatuaggi"]) &&
        (filtro["piercing"] == null || person.piercing == filtro["piercing"])) {
      filteredPeople.add(person);
    }
  }
  return filteredPeople;
}

class _PeopleList extends State<PeopleList> {
  int nPeople = 0;


  @override
  Widget build(BuildContext context) {
    //valuelistenablebuilder per aggiornare la lista quando cambiano i filtri in utility
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/find_person');
        },
        child: const Icon(Icons.search),
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: Utility.peopleListNotifier,
          builder: (context, value, child) {
            Future<List<Person>> filteredPeople = filterPeople();

            //Mostro la lista di persone
            return FutureBuilder<List<Person>>(
                future: filteredPeople,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Person>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text("No connection",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center);
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                      return const Text("Active",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center);
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return const Text("Error",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center);
                      } else if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Text(
                                  ":(",
                                  style: TextStyle(fontSize: 50),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "Nessuna persona trovata... \n\nProva a premere sul tasto in basso!",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        //crea una lista di persone ordinata in base al luogo e ci crea tutti i widget da mostrare
                        List<Person> people = snapshot.data!;
                        //ordino la lista in base al luogo associato
                        people.sort((a, b) =>
                            a.luogoAssociato.compareTo(b.luogoAssociato));

                        List<Widget> widgetsToShow = [];
                        List<String> paramsToShow = ["", ""];
                        String luogoPrecedente = "";

                        for (Person p in people) {
                          //se il luogo associato è diverso da quello precedente, aggiungo un widget di divider
                          if (p.luogoAssociato != luogoPrecedente) {
                            widgetsToShow.add(ListTile(
                              title: const Divider(
                                color: Colors.red,
                                thickness: 2,
                              ),
                              subtitle: Text(
                                p.luogoAssociato,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red),
                              ),
                            ));
                            luogoPrecedente = p.luogoAssociato;
                          }

                          //ora aggiungo il widget della persona
                          paramsToShow = p.whatToShowOfAPerson();

                          widgetsToShow.add(ListTile(
                            title: Text(paramsToShow[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(paramsToShow[1]),
                            //open the profile page for that entry
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/people_list/profile_page',
                                  arguments: p);
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                //chiedi la conferma prima di eliminare la persona
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String nome = "this person";
                                      if (p.soprannome.isNotEmpty) {
                                        nome = p.soprannome;
                                      } else {
                                        nome = p.nome;
                                      }
                                      return AlertDialog(
                                        title: const Text("Delete person"),
                                        content: Text(
                                            "Are you sure you want to delete $nome?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context, true);
                                              await Utility.deletePerson(p.id);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ));
                        }

                        return ListView(
                          children: widgetsToShow,
                        );
                      }
                  }
                });
          }),
    );
  }
}
