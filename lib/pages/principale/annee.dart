import 'package:agenda/widget/calendrier/annee/calendrier_annee.dart';
import 'package:agenda/widget/calendrier/liste_annee/liste_annee.dart';
import 'package:flutter/material.dart';

import '../../widget/bouton_ajout.dart';

class Annee extends StatefulWidget {
  const Annee({super.key, required this.cliqueMois});

  final void Function(DateTime) cliqueMois;

  @override
  State<Annee> createState() => _Annee();
}

enum Affichage {
  listeAnnee,
  annee,
}

class _Annee extends State<Annee> {
  Affichage affichage = Affichage.annee;
  GlobalKey<CalendrierAnneeState> calendrierKey = GlobalKey();
  GlobalKey<ListeAnneeState> listeAnneeKey = GlobalKey();
  GlobalKey<StartButtonState> startButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body : body(),
      floatingActionButton: boutons(),
    );
  }

  Widget boutons(){

    return Stack(
      children: [
        Positioned(
          bottom: 10,
          right: 10,
          child: boutonAjout(context, null, (){
            setState(() {

            });
          }),
        ),
        Positioned(
          bottom: 80,
          right: 10,
          child: switch (affichage){
            Affichage.listeAnnee => StartButton(
              key: startButtonKey,
              fonction: () {
              listeAnneeKey.currentState?.jumpToYear(0);
            },),
            Affichage.annee => StartButton(
              key: startButtonKey,
              fonction: () {
              calendrierKey.currentState?.jumpToYear(0);
            },),
          }
        ),
      ],
    );
  }

  void setAffichage(Affichage newAffichage){
    setState(() {
      affichage = newAffichage;
    });
  }

  Widget body(){
    switch (affichage){
      case Affichage.listeAnnee:
        return ListeAnnee(
          key: listeAnneeKey,
          setAffichage: setAffichage,
          startButtonKey: startButtonKey,
        );
      case Affichage.annee:
        return CalendrierAnnee(
          key: calendrierKey,
          setAffichage: setAffichage,
          startButtonKey: startButtonKey,
          cliqueMois: widget.cliqueMois,
        );
    }
  }
}


class StartButton extends StatefulWidget {
  const StartButton({super.key, required this.fonction});

  final Function() fonction;

  @override
  State<StartButton> createState() => StartButtonState();
}

class StartButtonState extends State<StartButton> {
  bool visible = false;
  DateTime timeout = DateTime.now();


  void setVisibility(bool visibility){
    if (DateTime.now().isAfter(timeout)) {
      setState(() {
        visible = visibility;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: FloatingActionButton(
        heroTag: "btn1",
        onPressed: (){
          widget.fonction();
          setVisibility(false);
          timeout = DateTime.now().add(Duration(milliseconds: 500));
        },
        tooltip: 'Annee Actuelle',
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

}