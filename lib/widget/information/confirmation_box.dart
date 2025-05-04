import 'package:flutter/material.dart';

void confirmDeletion(BuildContext context, confirmFunction){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmer la suppression "),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              confirmFunction();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Supprimer"),
          ),
        ],
      );
    },
  );
}