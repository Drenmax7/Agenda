import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../pages/principale/annee.dart';

class ListeAnnee extends StatefulWidget {
  const ListeAnnee({super.key, required this.setAffichage, required this.startButtonKey,});

  final void Function(Affichage) setAffichage;
  final GlobalKey<StartButtonState> startButtonKey;

  @override
  State<ListeAnnee> createState() => ListeAnneeState();
}

class ListeAnneeState extends State<ListeAnnee> {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  void jumpToYear(int i) {

  }

  int realIndex(int controllerIndex, {bool reverse = false}){
    int ecart = 50000;
    if (reverse){
      return controllerIndex + ecart;
    }
    else {
      return controllerIndex - ecart;
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          anneeText(),
        ],
      ),
    );
  }

  Widget anneeText(){
    return GestureDetector(
      onTap: () {
        widget.setAffichage(Affichage.annee);
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          "Liste Années",
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  String getAnnee(int numeroPage){
    DateTime debutAnnee = DateTime(DateTime.now().year + realIndex(numeroPage));
    String annee = debutAnnee.year.toString();
    return annee;
  }
}