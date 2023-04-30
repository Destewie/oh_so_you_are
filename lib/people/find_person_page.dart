import 'dart:core';

import 'package:flutter/material.dart';
import 'package:oh_so_you_are/other/dropdown_items.dart';
import 'package:oh_so_you_are/other/utility.dart';

class FindPerson extends StatefulWidget {
  const FindPerson({Key? key}) : super(key: key);

  @override
  State<FindPerson> createState() => _FindPerson();
}

//funzione per aggiornare il filtro in utility solo se i campi non sono default
void updateFilter(
    String luogo,
    String sesso,
    String pelle,
    String altezza,
    String carattere,
    String corporatura,
    String coloreCapelli,
    String taglioCapelli,
    String occhiali,
    String stileVestiario,
    bool fumo,
    bool tatuaggi,
    bool piercing) {
  Map<String, dynamic> filtroTemp = {};

  if (luogo != DropdownItems.defaultValue) {
    filtroTemp['luogo'] = luogo;
  }
  if (sesso != DropdownItems.sessoItems[0]) {
    filtroTemp['sesso'] = sesso;
  }
  if (pelle != DropdownItems.defaultValue) {
    filtroTemp['pelle'] = pelle;
  }
  if (altezza != DropdownItems.altezzaItems[0]) {
    filtroTemp['altezza'] = altezza;
  }
  if (carattere != DropdownItems.defaultValue) {
    filtroTemp['carattere'] = carattere;
  }
  if (corporatura != DropdownItems.corporaturaItems[0]) {
    filtroTemp['corporatura'] = corporatura;
  }
  if (coloreCapelli != DropdownItems.defaultValue) {
    filtroTemp['coloreCapelli'] = coloreCapelli;
  }
  if (taglioCapelli != DropdownItems.defaultValue) {
    filtroTemp['taglioCapelli'] = taglioCapelli;
  }
  if (occhiali != DropdownItems.defaultValue) {
    filtroTemp['occhiali'] = occhiali;
  }
  if (stileVestiario != DropdownItems.defaultValue) {
    filtroTemp['stileVestiario'] = stileVestiario;
  }
  if (fumo != false) {
    filtroTemp['fumo'] = fumo;
  }
  if (tatuaggi != false) {
    filtroTemp['tatuaggi'] = tatuaggi;
  }
  if (piercing != false) {
    filtroTemp['piercing'] = piercing;
  }

  Utility.filter= filtroTemp;
  Utility.peopleListNotifier.value = !Utility.peopleListNotifier.value;
}

class _FindPerson extends State<FindPerson> {
  //lista dei luoghi
  Future<List<String>> luoghiItems =
      Utility.readPlacesFromFile(Utility.allPlacesFileName);

  // Initial Selected Value based on the utility.filter
  String luogoValue =
      Utility.filter['luogo'] ?? DropdownItems.defaultValue;
  String sessoValue =
      Utility.filter['sesso'] ?? DropdownItems.sessoItems[0];
  String pelleValue =
      Utility.filter['pelle'] ?? DropdownItems.pelleItems[0];
  String altezzaValue =
      Utility.filter['altezza'] ?? DropdownItems.altezzaItems[0];
  String carattereValue =
      Utility.filter['carattere'] ?? DropdownItems.carattereItems[0];
  String corporaturaValue =
      Utility.filter['corporatura'] ?? DropdownItems.corporaturaItems[0];
  String coloreCapelliValue = Utility.filter['coloreCapelli'] ??
      DropdownItems.coloreCapelliItems[0];
  String taglioCapelliValue = Utility.filter['taglioCapelli'] ??
      DropdownItems.taglioCapelliItems[0];
  String occhialiValue =
      Utility.filter['occhiali'] ?? DropdownItems.occhialiItems[0];
  String stileVestiarioValue = Utility.filter['stileVestiario'] ??
      DropdownItems.stileVestiarioItems[0];
  bool fumoValue = Utility.filter['fumo'] ?? false;
  bool tatuaggiValue = Utility.filter['tatuaggi'] ?? false;
  bool piercingValue = Utility.filter['piercing'] ?? false;

  void resetFilter() {
    Utility.filter= {};
    Utility.peopleListNotifier.value = !Utility.peopleListNotifier.value;
  }

  void resetValues() {
    setState(() {
      altezzaValue = DropdownItems.altezzaItems[0];
      corporaturaValue = DropdownItems.corporaturaItems[0];
      sessoValue = DropdownItems.sessoItems[0];
      pelleValue = DropdownItems.pelleItems[0];
      taglioCapelliValue = DropdownItems.taglioCapelliItems[0];
      coloreCapelliValue = DropdownItems.coloreCapelliItems[0];
      stileVestiarioValue = DropdownItems.stileVestiarioItems[0];
      occhialiValue = DropdownItems.occhialiItems[0];
      carattereValue = DropdownItems.carattereItems[0];
      fumoValue = false;
      tatuaggiValue = false;
      piercingValue = false;
      luogoValue = DropdownItems.luoghiItems[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cerca persona"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off_sharp),
            onPressed: () {
              resetValues();
              resetFilter();
            },
          )
        ],
      ),
      //floating action button per applicare il filtro
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateFilter(
              luogoValue,
              sessoValue,
              pelleValue,
              altezzaValue,
              carattereValue,
              corporaturaValue,
              coloreCapelliValue,
              taglioCapelliValue,
              occhialiValue,
              stileVestiarioValue,
              fumoValue,
              tatuaggiValue,
              piercingValue);
          //navigate to the list of people
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_forward_sharp),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          //bottone per rimuovere i filtri
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Luogo associato:      ",
                    style: TextStyle(fontSize: 17)),
                FutureBuilder<List<String>>(
                    initialData: const ["-"],
                    future: Utility.readPlacesFromFile(Utility.allPlacesFileName),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        default:
                          if (snapshot.hasError) {
                            return const Text('Errore nel reperire i luoghi :(');
                          } else {
                            return DropdownButton(
                              // Initial Value
                              value: luogoValue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: snapshot.data!.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  luogoValue = newValue!;
                                });
                              },
                            );
                          }
                      }
                    }),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'CARATTERISTICHE \nNON SCELTE',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            //altezza
            Column(
              children: [
                const Text("Sesso"),
                DropdownButton(
                  // Initial Value
                  value: sessoValue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: DropdownItems.sessoItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      sessoValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            //corporatura
            Column(
              children: [
                const Text("Pelle"),
                DropdownButton(
                  // Initial Value
                  value: pelleValue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: DropdownItems.pelleItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      pelleValue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ]),
          const SizedBox(height: 8),
          //seconda riga di dropdown
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            //altezza
            Column(
              children: [
                const Text("Altezza"),
                DropdownButton(
                  // Initial Value
                  value: altezzaValue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: DropdownItems.altezzaItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      altezzaValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            Column(
              children: [
                const Text("Carattere"),
                DropdownButton(
                  // Initial Value
                  value: carattereValue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: DropdownItems.carattereItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      carattereValue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ]),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'CARATTERISTICHE \nSCELTE',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //corporatura
              Column(
                children: [
                  const Text("Corporatura"),
                  DropdownButton(
                    // Initial Value
                    value: corporaturaValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: DropdownItems.corporaturaItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        corporaturaValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Colore capelli"),
                  DropdownButton(
                    // Initial Value
                    value: coloreCapelliValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: DropdownItems.coloreCapelliItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        coloreCapelliValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Taglio capelli"),
                  DropdownButton(
                    // Initial Value
                    value: taglioCapelliValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: DropdownItems.taglioCapelliItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        taglioCapelliValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("Occhiali"),
                  DropdownButton(
                    // Initial Value
                    value: occhialiValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: DropdownItems.occhialiItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        occhialiValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Stile vestiario"),
                  DropdownButton(
                    // Initial Value
                    value: stileVestiarioValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items:
                        DropdownItems.stileVestiarioItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        stileVestiarioValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          //check box per il fumo, i tatuaggi e i piercing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("Fumo"),
                  Checkbox(
                    value: fumoValue,
                    onChanged: (bool? value) {
                      setState(() {
                        fumoValue = value!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Tatuaggi"),
                  Checkbox(
                    value: tatuaggiValue,
                    onChanged: (bool? value) {
                      setState(() {
                        tatuaggiValue = value!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Piercing"),
                  Checkbox(
                    value: piercingValue,
                    onChanged: (bool? value) {
                      setState(() {
                        piercingValue = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
