import 'package:flutter/material.dart';

import '../pages/ajout_evenement_menu.dart';

FloatingActionButton boutonAjout(BuildContext context, DateTime? selectedDate, specialFunction){
  return FloatingActionButton(
    heroTag: "addEvent",
    backgroundColor: Colors.blue,
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AjoutEvenementMenu(selectedDate: selectedDate)),
      );
      specialFunction();
    },
    tooltip: 'Ajouter événement',
    child: const Icon(
      color: Colors.white,
      Icons.add,
      size: 50,
    ),
  );
}

