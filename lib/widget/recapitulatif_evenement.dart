import 'package:agenda/pages/ajout_anniversaire.dart';
import 'package:agenda/pages/ajout_evenement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bdd/bdd.dart';
import '../pages/ajout_fete.dart';

class RecapitulatifEvenement extends StatelessWidget {
  const RecapitulatifEvenement({super.key, required this.evenement, required this.jour});

  final Map<String, dynamic> evenement;
  final String jour;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,//pour que le gesture detector puisse cliquer dessus
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => descriptifEvenement()),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Center(
                    child: decorationEvenement(),
                  ),
                ),
                VerticalDivider(
                  thickness: 3,
                  color: couleurEvenement(),
                ),
                Text(
                  previewEvenement(),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  descriptifEvenement() {
    switch (evenement["type"]!){
      case TypeEvenement.evenement :
        return AjoutEvenement(evenement: evenement,);
      case TypeEvenement.anniversaire :
        return AjoutAnniversaire(anniversaire: evenement,);
      case TypeEvenement.fete :
        return AjoutFete(fete: evenement,);
    }
  }

  Widget decorationEvenement(){
    switch (evenement["type"]!) {
      case TypeEvenement.evenement :
        double tailleHeure = 14;

        List<Widget> decoration = [];
        //L'evenement se deroule sur une seule journée
        if (jour == evenement["jourDebut"] && jour == evenement["jourFin"]){
          decoration = [
            Text(
              "${evenement["heureDebut"]}",
              style: TextStyle(
                fontSize: tailleHeure,
              ),
            ),
            Text(
              "${evenement["heureFin"]}",
              style: TextStyle(
                fontSize: tailleHeure,
              ),
            )
          ];
        }
        //L'evenement se deroule sur plusieurs jours, cette partie est celle du premier jour
        if (jour == evenement["jourDebut"] && jour != evenement["jourFin"]){
          decoration = [
            Text(
              "${evenement["heureDebut"]}",
              style: TextStyle(
                fontSize: tailleHeure,
              ),
            ),
            Text(
              "Debut",
              style: TextStyle(
                fontSize: tailleHeure,
              ),
            )
          ];
        }
        //L'evenement se deroule sur plusieurs jours, cette partie est celle du dernier jour
        if (jour != evenement["jourDebut"] && jour == evenement["jourFin"]){
          decoration = [
            Text(
              "Fin",
              style: TextStyle(
                fontSize: tailleHeure,
              ),
            ),
            Text(
              "${evenement["heureFin"]}",
              style: TextStyle(
                fontSize: tailleHeure,
              ),
            )
          ];
        }
        //L'evenement se deroule sur plusieurs jours, cette partie est entre les 2 extremités
        if (jour != evenement["jourDebut"] && jour != evenement["jourFin"]){
          decoration = [
            Text(
              "Journée entiere",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ];
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: decoration,
        );
      case TypeEvenement.anniversaire :
        return Text(
          "🎂",
          style: TextStyle(
            fontSize: 30,
          ),
        );
      case TypeEvenement.fete :
        return Text(
          evenement["deco"],
          style: TextStyle(
            fontSize: 30,
          ),
        );
    }

    return Text("n/a");
  }

  Color couleurEvenement(){
    switch (evenement["type"]!){
      case TypeEvenement.evenement:
        return Colors.blue;
      case TypeEvenement.anniversaire:
        return Colors.red;
      case TypeEvenement.fete:
        return Colors.green;
    }

    return Colors.black;
  }

  String previewEvenement(){
    switch (evenement["type"]!){
      case TypeEvenement.evenement:
        return evenement["titre"];
      case TypeEvenement.anniversaire:
        String message;

        if (evenement["naissance"] != null){
          int age = DateFormat('dd/MM/yyyy').parse(jour).year - evenement["naissance"]! as int;
          message = "$age ans";
        }
        else{
          message = "Anniversaire";
        }

        String nom = evenement["nom"];
        if ('aeiouy'.contains(nom[0].toLowerCase())) {
          message += " d'$nom";
        }
        else{
          message += " de $nom";
        }

        return message;
      case TypeEvenement.fete:
        return evenement["nom"];
    }

    return "n/a";
  }
}