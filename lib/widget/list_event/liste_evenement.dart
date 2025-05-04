import 'package:agenda/widget/list_event/recapitulatif_evenement.dart';
import 'package:flutter/material.dart';

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
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: colonneEvenement,
      ),
    );
  }
}