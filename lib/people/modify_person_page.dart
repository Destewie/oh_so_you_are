import 'package:flutter/material.dart';
import 'package:oh_so_you_are/people/person.dart';

import '../other/dropdown_items.dart';
import '../other/utility.dart';

final nicknameCtrl = TextEditingController();
final nameCtrl = TextEditingController();
final surnameCtrl = TextEditingController();
final storyCtrl = TextEditingController();

// Initial Selected Value
String altezzaValue = DropdownItems.altezzaItems[0];
String corporaturaValue = DropdownItems.corporaturaItems[0];
String sessoValue = DropdownItems.sessoItems[0];
String pelleValue = DropdownItems.pelleItems[0];
String taglioCapelliValue = DropdownItems.taglioCapelliItems[0];
String coloreCapelliValue = DropdownItems.coloreCapelliItems[0];
String stileVestiarioValue = DropdownItems.stileVestiarioItems[0];
String occhialiValue = DropdownItems.occhialiItems[0];
String carattereValue = DropdownItems.carattereItems[0];
bool fumoValue = false;
bool tatuaggiValue = false;
bool piercingValue = false;
String luogoValue = DropdownItems.luoghiItems[0];



class ModifyPerson extends StatefulWidget {
  const ModifyPerson({Key? key}) : super(key: key);

  @override
  State<ModifyPerson> createState() => _ModifyPerson();
}

class _ModifyPerson extends State<ModifyPerson> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool primaBuildDellaPagina = true;

  @override
  Widget build(BuildContext context) {
    Person person = ModalRoute.of(context)!.settings.arguments as Person;

    //se questa è la prima build della pagina, allora carico i dati del personaggio
    if (primaBuildDellaPagina) {
      setValues(person);
      primaBuildDellaPagina = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Modifica ${person.soprannome}"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'COME CHIAMARTI?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            //nickname and name cannot be both blank
            TextFormField(
              controller: nicknameCtrl,
              decoration: const InputDecoration(
                hintText: 'Soprannome',
              ),
              validator: (String? value) {
                debugPrint("name value: ${nameCtrl.value}");
                if ((value == null || value.isEmpty) &&
                    nameCtrl.value.text == "") {
                  return 'Inserisci un soprannome o un nome';
                }
                return null;
              },
            ),
            //spazio tra i campi
            const SizedBox(height: 8),
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(hintText: "Nome"),
              validator: (String? value) {
                debugPrint("nickname value: ${nicknameCtrl.value}");
                if ((value == null || value.isEmpty) &&
                    nicknameCtrl.value.text == "") {
                  return 'Inserisci un soprannome o un nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: surnameCtrl,
              decoration: const InputDecoration(
                hintText: 'Cognome',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: storyCtrl,
              decoration: const InputDecoration(
                hintText: 'Storia brevissima su questa persona',
              ),
            ),
            const SizedBox(height: 8),
            //todo: fix al cambiamento di luogo (da problemi con la lista e con la dimensione del widget)
            SizedBox(
              height: 50,
              child: Row(
                //alignment all left
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Luogo associato:      ",
                      style: TextStyle(fontSize: 17)),
                  FutureBuilder<List<String>>(
                      future: Utility.getAllPlaces(),
                      initialData: const ["-"],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Errore nel reperire i luoghi :(');
                        } else {
                          if (snapshot.data!.contains(person.luogoAssociato)) {
                            luogoValue = person.luogoAssociato;
                          }
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
                      items: DropdownItems.coloreCapelliItems.map((
                          String items) {
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
                      items: DropdownItems.taglioCapelliItems.map((
                          String items) {
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
            //button to submit a new person
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Person newPerson = Person(
                      person.id,
                      nicknameCtrl.text,
                      nameCtrl.text,
                      surnameCtrl.text,
                      storyCtrl.text,
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
                  Navigator.pop(context);
                  await Utility.deletePerson(person.id);
                  await Utility.addPerson(newPerson);
                }
              },
              child: const Text('Modifica', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

void setValues(Person person) {
  nicknameCtrl.text = person.soprannome;
  nameCtrl.text = person.nome;
  surnameCtrl.text = person.cognome;
  storyCtrl.text = person.storia;

  altezzaValue = person.altezza;
  corporaturaValue = person.corporatura;
  sessoValue = person.sesso;
  pelleValue = person.pelle;
  taglioCapelliValue = person.taglioCapelli;
  coloreCapelliValue = person.coloreCapelli;
  stileVestiarioValue = person.vestiario;
  occhialiValue = person.occhiali;
  carattereValue = person.carattere;
  fumoValue = person.fumo;
  tatuaggiValue = person.tatuaggi;
  piercingValue = person.piercing;
}