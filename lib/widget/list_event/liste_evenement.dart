import 'package:agenda/bdd/bdd.dart';
import 'package:agenda/widget/list_event/recapitulatif_evenement.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class ListeEvenement extends StatelessWidget {
  const ListeEvenement({super.key, required this.evenements, required this.jour, required this.specialFunction});

  final List<dynamic> evenements;
  final String jour;
  final void Function(VoidCallback) specialFunction;

  @override
  Widget build(BuildContext context) {
    List<Widget> colonneEvenement = [];
    
    for (int i = 0; i < evenements.length; i++){
      if (i != 0){
        colonneEvenement.add( Divider(height: 0,));
      }
      
      colonneEvenement.add(
        RecapitulatifEvenement(evenement: evenements[i], jour : jour, specialFunction: specialFunction,)
      );
    }

    if (evenements.isEmpty){
      colonneEvenement.add(
          RecapitulatifEvenement(evenement: {"type": TypeEvenement.aucun}, jour : jour, specialFunction: specialFunction,)
      );
    }
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: dateFormatAnnee.parse(jour).isBefore(DateTime.now().subtract(Duration(days: 1))) ? Colors.grey[350] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: colonneEvenement,
      ),
    );
  }
}