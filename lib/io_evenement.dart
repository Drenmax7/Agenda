import 'dart:convert';
import 'dart:io';
import 'package:agenda/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class IOEvenement{
  static late Map<String, dynamic> evenement;
  static late Map<String, dynamic> anniversaire;
  static late Map<String, dynamic> agenda;

  static DateFormat dateFormatAnnee = DateFormat('dd/MM/yyyy');
  static DateFormat dateFormatMois = DateFormat('dd/MM');

  static Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> save() async {
    final path = await getFilePath();
    final evenementFile = File('$path/evenement.json');
    final anniversaireFile = File('$path/anniversaire.json');
    final agendaFile = File('$path/agenda.json');

    String jsonString = jsonEncode(evenement);
    await evenementFile.writeAsString(jsonString, mode: FileMode.write);

    jsonString = jsonEncode(anniversaire);
    await anniversaireFile.writeAsString(jsonString, mode: FileMode.write);

    jsonString = jsonEncode(agenda);
    await agendaFile.writeAsString(jsonString, mode: FileMode.write);
  }

  static Future<void> load() async {
    final path = await getFilePath();
    print(path);

    final evenementFile = File('$path/evenement.json');
    final anniversaireFile = File('$path/anniversaire.json');
    final agendaFile = File('$path/agenda.json');

    //un evenement = id -> date debut, date fin, heure debut, heure fin, lieu, titre (activite + personnes), description
    //anniversaire = jour -> une liste de personne = nom, annee naissance, detail
    //agenda = un jour associé a une liste d'id d'evenement


    //await evenementFile.writeAsString("{}", mode: FileMode.write);
    //await anniversaireFile.writeAsString("{}", mode: FileMode.write);
    //await agendaFile.writeAsString("{}", mode: FileMode.write);


    String contenu;
    if (await evenementFile.exists()) {
      contenu = await evenementFile.readAsString();
    }
    else{
      await evenementFile.writeAsString("{}", mode: FileMode.write);
      contenu = "{}";
    }
    evenement = jsonDecode(contenu);

    if (await anniversaireFile.exists()) {
      contenu = await anniversaireFile.readAsString();
    }
    else{
      await anniversaireFile.writeAsString("{}", mode: FileMode.write);
      contenu = "{}";
    }
    anniversaire = jsonDecode(contenu);

    if (await agendaFile.exists()) {
      contenu = await agendaFile.readAsString();
    }
    else{
      await agendaFile.writeAsString("{}", mode: FileMode.write);
      contenu = "{}";
    }
    agenda = jsonDecode(contenu);
  }

  static void ajouteEvenement({required String titre, String lieu = "", String description = "",
    required DateTime jourDebut, required DateTime jourFin, required String heureDebut,
    required String heureFin}) {
    if (jourFin.isBefore(jourDebut)){
      throw "jour fin est avant le jour de debut";
    }

    //determine l'id de l'evenement
    String id = "0";
    if (evenement.keys.isNotEmpty){
      id = evenement.keys.reduce((a, b) => int.parse(a) > int.parse(b) ? a : b);
      id = (int.parse(id) + 1).toString();
    }

    //cree l'evenement
    evenement[id] = {
      "titre": titre,
      "lieu": lieu,
      "description" : description,
      "jourDebut" : dateFormatAnnee.format(jourDebut),
      "heureDebut" : heureDebut,
      "jourFin" : dateFormatAnnee.format(jourFin),
      "heureFin" : heureFin,
      "type" : TypeEvenement.evenement,
    };

    //ajoute l'evenement a l'agenda
    DateTime i = jourDebut.subtract(Duration(days: 1));
    do{
      i = i.add(Duration(days: 1));

      if (agenda[dateFormatAnnee.format(i)] == null){
        agenda[dateFormatAnnee.format(i)] = [id];
      }
      else{
        (agenda[dateFormatAnnee.format(i)] as List).add(id);
      }
    }while (i.isBefore(jourFin));

    save();
  }

  static void ajouteAnniversaire({required DateTime jour, required String nom, required int naissance, required String details}){

    Map<String, dynamic> personne = {
      "nom" : nom,
      "type" : TypeEvenement.anniversaire,
    };
    if (naissance != 0){
      personne["naissance"] = naissance;
    }
    if (details != ""){
      personne["details"] = details;
    }

    if (anniversaire[dateFormatMois.format(jour)] == null){
      anniversaire[dateFormatMois.format(jour)] = [personne];
    }
    else{
      (anniversaire[dateFormatMois.format(jour)] as List).add(personne);
    }

    save();
  }

  static Map<String,List<dynamic>> getEvenement({
    required DateTime debut, required DateTime fin,
    int filtre = TypeEvenement.tout, String filtreRecherche = ""})
  {

    Map<String,List<dynamic>> listeEvenement = {};
    for (DateTime i = debut; i.isBefore(fin); i = i.add(Duration(days: 1))){
      List<dynamic> evenementJour = [];

      if (filtre == TypeEvenement.tout || filtre == TypeEvenement.anniversaire) {
        List<dynamic>? listeAnniversaire;
        listeAnniversaire = anniversaire[dateFormatMois.format(i)];
        if (listeAnniversaire != null) {
          for (int i = 0; i < listeAnniversaire.length; i++) {
            if (matchFilter(filtre : filtreRecherche, evenement : listeAnniversaire[i])) {
              evenementJour.add(listeAnniversaire[i]);
            }
          }
        }
      }

      if (filtre == TypeEvenement.tout || filtre == TypeEvenement.evenement) {
        List<dynamic>? listeIdEvenement;
        listeIdEvenement = agenda[dateFormatAnnee.format(i)];
        if (listeIdEvenement != null) {
          for (String id in listeIdEvenement) {
            if (matchFilter(filtre : filtreRecherche, evenement : evenement[id])) {
              evenementJour.add(evenement[id]);
            }
          }
        }
      }

      if (filtre == TypeEvenement.tout || filtre == TypeEvenement.fete) {
        Map<String,dynamic>? fete = getFete(i);
        if (fete != null && matchFilter(filtre : filtreRecherche, evenement : fete)){
          evenementJour.add(fete);
        }
      }

      if (evenementJour.isNotEmpty){
        listeEvenement[dateFormatAnnee.format(i)] = evenementJour;
      }
    }

    return listeEvenement;
  }


  static void generateSample() {
    evenement = {};
    anniversaire = {};
    agenda = {};
    
    Map<String, String> anniv = {
      "Clara" : "07/06/2003",
      "Quentin" : "30/01/2003",
      "Anna" : "03/02/2003",
      "Gauthier" : "22/02/2002"
    };
    
    for (String nom in anniv.keys){
      List<String> separationDate = anniv[nom]!.split("/");
      ajouteAnniversaire(
          jour: DateTime(2025, int.parse(separationDate[1]), int.parse(separationDate[0])), 
          nom: nom, naissance: int.parse(separationDate[2]), details: "ami polytech");
    }
    
    List<String> typeEvenement = ["Film","Soiree jeu","BBQ", "Heure tranquille", "Revision"];
    
    for (int i = 0; i < 100; i++){
      String titre = typeEvenement[Random().nextInt(typeEvenement.length)];

      int nbParticipant = Random().nextInt(anniv.length);
      for (int numParticipant = 0; numParticipant < nbParticipant; numParticipant++){
        titre += " ${anniv.keys.toList()[numParticipant]}";
      }

      DateTime jourDebut = DateTime(2024 + Random().nextInt(3), Random().nextInt(12), Random().nextInt(30));
      int nbMinute = Random().nextInt(720) + 360;
      int fin = nbMinute + Random().nextInt(360) + 240;

      ajouteEvenement(
          titre: titre,
          jourDebut: jourDebut,
          jourFin: jourDebut.add(Duration(days: 2)),
          heureDebut: "${(nbMinute~/60).toString().padLeft(2, '0')}:${(nbMinute%60).toString().padLeft(2, '0')}",
          heureFin: "${((fin~/60)%24).toString().padLeft(2, '0')}:${(fin%60).toString().padLeft(2, '0')}"
      );
    }
  }

  static String enleverAccents(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  static bool matchFilter({required String filtre, required Map<String,dynamic> evenement}) {
    for (String mot in filtre.split(" ")){
      bool motContenu = false;
      for (String key in evenement.keys){
        if (key == "deco"){
          continue;
        }

        mot = enleverAccents(mot).toLowerCase();
        String phrase = enleverAccents(evenement[key].toString()).toLowerCase();
        if (phrase.contains(mot)) {
          motContenu = true;
        }
      }

      if (!motContenu){
        return false;
      }
    }

    return true;
  }
  
}

class TypeEvenement{
  static const int tout = 0;
  static const int anniversaire = 1;
  static const int evenement = 2;
  static const int fete = 3;
}