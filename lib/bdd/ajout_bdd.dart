import 'dart:math';

import 'package:agenda/bdd/io_evenement.dart';

import '../utils.dart';
import 'bdd.dart';

class AjoutBDD{
  static void ajouteEvenement({required String titre, String lieu = "", String description = "",
    required DateTime jourDebut, required DateTime jourFin, required String heureDebut,
    required String heureFin})
  {

    if (jourFin.isBefore(jourDebut)){
      throw "jour fin est avant le jour de debut";
    }

    //determine l'id de l'evenement
    String id = "0";
    if (BDD.evenement.keys.isNotEmpty){
      id = BDD.evenement.keys.reduce((a, b) => int.parse(a) > int.parse(b) ? a : b);
      id = (int.parse(id) + 1).toString();
    }

    //cree l'evenement
    BDD.evenement[id] = {
      "titre": titre,
      "jourDebut" : dateFormatAnnee.format(jourDebut),
      "heureDebut" : heureDebut,
      "jourFin" : dateFormatAnnee.format(jourFin),
      "heureFin" : heureFin,
      "type" : TypeEvenement.evenement,
    };

    if (lieu.isNotEmpty) {
      BDD.evenement[id]["lieu"] = lieu;
    }
    if (description.isNotEmpty) {
      BDD.evenement[id]["description"] = description;
    }

    //ajoute l'evenement a l'agenda
    DateTime i = jourDebut.subtract(Duration(days: 1));
    do{
      i = i.add(Duration(days: 1));

      if (BDD.agenda[dateFormatAnnee.format(i)] == null){
        BDD.agenda[dateFormatAnnee.format(i)] = [id];
      }
      else{
        (BDD.agenda[dateFormatAnnee.format(i)] as List).add(id);
      }
    }while (i.isBefore(jourFin));

    IOEvenement.save();
  }

  static void ajouteAnniversaire({required DateTime jour, required String nom, required int naissance, required String details})
  {
    Map<String, dynamic> personne = {
      "nom" : nom,
      "type" : TypeEvenement.anniversaire,
    };
    if (naissance != 0){
      personne["naissance"] = naissance;
    }

    if (details.isNotEmpty){
      personne["details"] = details;
    }

    if (BDD.anniversaire[dateFormatMois.format(jour)] == null){
      BDD.anniversaire[dateFormatMois.format(jour)] = [personne];
    }
    else{
      (BDD.anniversaire[dateFormatMois.format(jour)] as List).add(personne);
    }

    IOEvenement.save();
  }

  static void generateSample() {
    BDD.evenement = {};
    BDD.anniversaire = {};
    BDD.agenda = {};

    Map<String, String> anniv = {
      "Clara" : "07/06/2003",
      "Quentin" : "30/01/2003",
      "Anna" : "03/02/2003",
      "Gauthier" : "22/02/2002"
    };

    for (String nom in anniv.keys){
      List<String> separationDate = anniv[nom]!.split("/");
      AjoutBDD.ajouteAnniversaire(
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

      AjoutBDD.ajouteEvenement(
          titre: titre,
          jourDebut: jourDebut,
          jourFin: jourDebut.add(Duration(days: 2)),
          heureDebut: "${(nbMinute~/60).toString().padLeft(2, '0')}:${(nbMinute%60).toString().padLeft(2, '0')}",
          heureFin: "${((fin~/60)%24).toString().padLeft(2, '0')}:${(fin%60).toString().padLeft(2, '0')}"
      );
    }
  }
}