import 'package:flutter/material.dart';

import '../pages/ajoutEvenement.dart';

FloatingActionButton boutonAjout(BuildContext context, DateTime? selectedDate){
  return FloatingActionButton(
    backgroundColor: Colors.blue,
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AjoutEvenement(selectedDate: selectedDate)),
      );
    },
    tooltip: 'Ajouter événement',
    child: const Icon(
      color: Colors.white,
      Icons.add,
      size: 50,
    ),
  );
}

