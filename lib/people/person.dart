class Person {

  String id = '',
      soprannome = '',
      nome = '',
      cognome = '',
      storia = '', //best if brief
      luogoAssociato = '',
      sesso = '',
      pelle = '',
      altezza = '',
      carattere = '',
      corporatura = '',
      coloreCapelli = '',
      taglioCapelli = '',
      occhiali = '',
      vestiario = '';

  bool fumo = false,
    tatuaggi = false,
    piercing = false;

  //costruttore
  Person (this.id, this.soprannome, this.nome, this.cognome, this.storia, this.luogoAssociato, this.sesso, this.pelle, this.altezza, this.carattere, this.corporatura, this.coloreCapelli, this.taglioCapelli, this.occhiali, this.vestiario, this.fumo, this.tatuaggi, this.piercing);


  //getters and setters
  String get persNickname {
    return soprannome;
  }

  set persNickname(String nick) {
    soprannome = nick;
  }

  String get persName {
    return nome;
  }

  set persName(String name) {
    nome = name;
  }

  String get persSurname {
    return cognome;
  }

  set persSurname(String surname) {
    cognome = surname;
  }

  String get persStory {
    return storia;
  }

  set persStory(String story) {
    storia = story;
  }

  String get persPlace {
    return luogoAssociato;
  }
  set persPlace(String place) {
    luogoAssociato = place;
  }

  String get persSex {
    return sesso;
  }

  set persSex(String s){
    sesso = s;
  }

  String get persSkin {
    return pelle;
  }

  set persSkin(String s){
    pelle = s;
  }

  String get persHeight {
    return altezza;
  }

  set persHeight(String height) {
    altezza = height;
  }

  String get persCharacter {
    return carattere;
  }

  set persCharacter(String s){
    carattere = s;
  }

  String get persBody {
    return corporatura;
  }

  set persBody(String s){
    corporatura = s;
  }

  String get persHairColor {
    return coloreCapelli;
  }

  set persHairColor(String s){
    coloreCapelli = s;
  }

  String get persHairStyle {
    return taglioCapelli;
  }

  set persHairStyle(String s){
    taglioCapelli = s;
  }

  String get persGlasses {
    return occhiali;
  }

  set persGlasses(String s){
    occhiali = s;
  }

  String get persClothes {
    return vestiario;
  }

  set persClothes(String s){
    vestiario = s;
  }

  bool get persSmoker {
    return fumo;
  }

  set persSmoker(bool b){
    fumo = b;
  }

  bool get persTattoos {
    return tatuaggi;
  }

  set persTattoos(bool b){
    tatuaggi = b;
  }

  bool get persPiercings {
    return piercing;
  }

  set persPiercings(bool b){
    piercing = b;
  }

  //metodi ----------------------------------------------------------------------

  static String calcolaId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  //from and to json

  //non gli passi veramente una stringa json
  //devi prima decodificare quella stringa in modo da ottenere una mappa da cui puoi prendere i dati che ti interessano
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['id'],
      json['soprannome'],
      json['nome'],
      json['cognome'],
      json['storia'],
      json['luogoAssociato'],
      json['sesso'],
      json['pelle'],
      json['altezza'],
      json['carattere'],
      json['corporatura'],
      json['coloreCapelli'],
      json['taglioCapelli'],
      json['occhiali'],
      json['vestiario'],
      json['fumo'],
      json['tatuaggi'],
      json['piercing'],
    );
  }

  //non lo trasforma in un vero e proprio json
  //dalla mappa di String:dynamic devi poi fare l'encode per avere un json vero e proprio (con virgolette ecc.)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'soprannome': soprannome,
      'nome': nome,
      'cognome': cognome,
      'storia': storia,
      'luogoAssociato': luogoAssociato,
      'sesso': sesso,
      'pelle': pelle,
      'altezza': altezza,
      'carattere': carattere,
      'corporatura': corporatura,
      'coloreCapelli': coloreCapelli,
      'taglioCapelli': taglioCapelli,
      'occhiali': occhiali,
      'vestiario': vestiario,
      'fumo': fumo,
      'tatuaggi': tatuaggi,
      'piercing': piercing,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }


//funzione per vedere quali campi di una persona far uscire sulla lista di tutte le persone
  List<String> whatToShowOfAPerson() {
    List<String> paramsToShow = ["", ""];

    //best: nickname + notes
    //second best: nickname + name (and surname)
    //third  best: name (and surname) + notes
    if (soprannome.isNotEmpty) {
      paramsToShow[0] = soprannome;
      if (storia.isNotEmpty) {
        paramsToShow[1] = storia;
      } else if (nome.isNotEmpty) {
        if (cognome.isNotEmpty) {
          paramsToShow[1] = "$nome $cognome";
        } else {
          paramsToShow[1] = nome;
        }
      }
    } else {
      if (cognome.isNotEmpty) {
        paramsToShow[0] = "$nome $cognome";
      } else {
        paramsToShow[0] = nome;
      }
      paramsToShow[1] = storia;
    }

    return paramsToShow;
  }
}