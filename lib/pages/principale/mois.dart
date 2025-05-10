import 'package:flutter/material.dart';

import '../../bdd/get_bdd.dart';
import '../../utils.dart';
import '../../widget/bouton_ajout.dart';
import '../../widget/calendrier/calendrier.dart';
import '../../widget/list_event/liste_evenement.dart';

class Mois extends StatefulWidget {
  const Mois({super.key});

  @override
  State<Mois> createState() => _Mois();
}

class _Mois extends State<Mois> {
  GlobalKey<CalendrierState> calendrierKey = GlobalKey();
  GlobalKey<StartButtonState> startButtonKey = GlobalKey();
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body : Column(
        children: [
          SizedBox(
            height: 400,
            child: Calendrier(
              key: calendrierKey,
              startButtonKey : startButtonKey,
              selectedDate: selectedDate,
              changeDate: (DateTime newDate){
                setState(() {
                  selectedDate = DateTime(newDate.year, newDate.month, newDate.day);
                  startButtonKey.currentState?.setVisibility(!areSameDay(selectedDate, DateTime.now()));
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Divider(),
          ),
          Expanded(
            child: evenementJour(),
          ),
        ],
      ),
      floatingActionButton: boutons(),
    );
  }

  Widget boutons(){
    return Stack(
      children: [
        Positioned(
          bottom: 10,
          right: 10,
          child: boutonAjout(context, selectedDate, (){
            setState(() {

            });
          }),
        ),
        Positioned(
          bottom: 80,
          right: 10,
          child: StartButton(
            key: startButtonKey,
            fonction: (){
            setState(() {
              selectedDate = DateTime.now();
              calendrierKey.currentState?.jumpToMonth(0);
            });
          },),
        ),
      ],
    );
  }
  
  String getEcart(){
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int difference = selectedDate.difference(today).inDays.abs();

    String ecart;
    if (difference == 0){
      ecart = "Aujourd'hui";
    }
    else if(today.isBefore(selectedDate)){
      if (difference == 1){
        ecart = "Demain";
      }
      else {
        ecart = "Dans $difference jours";
      }
    }
    else{
      if (difference == 1){
        ecart = "Hier";
      }
      else {
        ecart = "Il y a $difference jours";
      }
    }
    
    return ecart;
  }
  
  Widget evenementJour(){
    List<dynamic> listeEvenement = GetBdd.getEvenement(
      debut: selectedDate,
      fin: selectedDate,
    ).values.toList();
    
    if (listeEvenement.isNotEmpty){
      listeEvenement = listeEvenement[0];
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                getEcart(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            ListeEvenement(evenements: listeEvenement, jour: dateFormatAnnee.format(selectedDate), specialFunction: setState,),
          ],
        ),
      ),
    );
  }
}

class StartButton extends StatefulWidget {
  const StartButton({super.key, required this.fonction});

  final Function() fonction;

  @override
  State<StartButton> createState() => StartButtonState();
}

class StartButtonState extends State<StartButton> {
  bool visible = true;
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
        onPressed: () {
          widget.fonction();
          setVisibility(false);
          timeout = DateTime.now().add(Duration(milliseconds: 500));
        },
        tooltip: 'Jour actuelle',
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

}