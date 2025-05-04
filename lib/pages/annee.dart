import 'package:flutter/material.dart';

import '../widget/bouton_ajout.dart';

class Annee extends StatefulWidget {
  const Annee({super.key});

  @override
  State<Annee> createState() => _Annee();
}

class _Annee extends State<Annee> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Text("page de l'annee"),
      floatingActionButton: boutonAjout(context, null, (){}),
    );
  }
}