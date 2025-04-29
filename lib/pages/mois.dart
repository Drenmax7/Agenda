import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/boutonAjout.dart';

class Mois extends StatefulWidget {
  const Mois({super.key});

  @override
  State<Mois> createState() => _Mois();
}

class _Mois extends State<Mois> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Text("page du mois"),
      floatingActionButton: boutonAjout(context, DateTime.now()),
    );
  }
}