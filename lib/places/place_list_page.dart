import 'dart:convert';

import 'package:flutter/material.dart';

import '../other/utility.dart';
import '../people/person.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({Key? key}) : super(key: key);

  @override
  State<PlaceList> createState() => _PlaceList();
}

class _PlaceList extends State<PlaceList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Utility.placesListNotifier,
      builder: (context, value, child) {
        Utility.placesListNotifier.value = !Utility.placesListNotifier.value;
        return FutureBuilder<List<String>>(
            future: Utility.readPlacesFromFile(Utility.allPlacesFileName),
            builder: (BuildContext context,
                AsyncSnapshot<List<String>> snapshot) {
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
                  } else
                  if (snapshot.data!.isEmpty || snapshot.data!.length == 1) {
                    return Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/places_list/add_place');
                        },
                        child: const Icon(Icons.add),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              "Nessun luogo trovato... \n\nProva ad aggiungerne uno!",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/places_list/add_place');
                        },
                        child: const Icon(Icons.add),
                      ),
                      body: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            //il primo elemento della lista dei luoghi è sempre '-'
                            //non stampare il primo elemento
                            if (index != 0) {
                              return ListTile(
                                title: Text(snapshot.data![index]),
                                //bottone per eliminare la entry
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await Utility.deletePlace(
                                        snapshot.data![index]);
                                  },
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                    );
                  }
              }
            });
      },
    );
  }
}
