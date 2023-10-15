import 'package:flutter/material.dart';
import 'package:oh_so_you_are/people/add_person_page.dart';
import 'package:oh_so_you_are/people/modify_person_page.dart';
import 'package:oh_so_you_are/places/place_list_page.dart';
import 'other/import_export_page.dart';
import 'other/utility.dart';
import 'people/find_person_page.dart';
import 'people/people_list_page.dart';
import 'people/person_profile_page.dart';
import 'places/add_place_page.dart';

void main() {
  runApp(const MyApp());
}

//--------------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oh so you are',
      routes: {
        '/add_person': (context) => const AddPerson(),
        '/find_person': (context) => const FindPerson(),
        '/people_list': (context) => const PeopleList(),
        '/people_list/profile_page': (context) => const ProfilePage(),
        '/places_list': (context) => const PlaceList(),
        '/places_list/add_place': (context) => const AddPlace(),
        '/upload_from_file': (context) => const UploadFromFile(),
        '/modify_person': (context) => const ModifyPerson(),
      },
      debugShowCheckedModeBanner:
          false, //per togliere il banner di debug in alto a destra
      theme: ThemeData(primarySwatch: Colors.red),
      home: const RootPage(),
    );
  }
}

//la RootPage è stateful perché gli attributi che definiscono il suo aspetto possono variare nel tempo
class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

//lo "state" può essere inteso come tutte quelle cose che servono per ricostruire la pagina in qualsiasi momento
class _RootPageState extends State<RootPage> {
  int currentMainPage = 0;

  List<Widget> mainPages = const [
    PeopleList(),
    AddPerson(),
    PlaceList(),
  ];

  @override //funzione che costruisce la pagina ad ogni refresh (a proposito di "state")
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ah, quindi tu sei..."),
        //button to upload people with a custom file
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pushNamed(context, '/upload_from_file');
            },
          ),
        ],
      ),
      body: mainPages[currentMainPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: "Persone"),
          NavigationDestination(
              icon: Icon(Icons.person_add_alt_1), label: "Aggiungi persona"),
          NavigationDestination(
              icon: Icon(Icons.add_location_alt_rounded), label: "Luoghi"),
        ],
        onDestinationSelected: (int index) {
          Utility.filter = {};
          setState(() {
            currentMainPage = index;
          });
        },
        selectedIndex: currentMainPage,
      ),
    );
  }
}
