import 'package:agenda/bdd/bdd.dart';
import 'package:agenda/bdd/get_bdd.dart';
import 'package:agenda/utils.dart';
import 'package:flutter/material.dart';

class PageCalendrier extends StatefulWidget {
  const PageCalendrier({super.key, required this.moisPage, required this.changeDate, required this.selectedDate});

  final Function(DateTime newDay) changeDate;
  final DateTime moisPage;
  final DateTime selectedDate;

  @override
  State<PageCalendrier> createState() => _PageCalendrier();
}

class _PageCalendrier extends State<PageCalendrier> {

  @override
  Widget build(BuildContext context) {
    DateTime agendaStart = widget.moisPage;
    int currentMonth = agendaStart.month;

    //make it so agendaStart is a monday
    while (agendaStart.weekday != DateTime.monday){
      agendaStart = agendaStart.subtract(Duration(days: 1));
    }

    List<TableRow> agendaRows = [];
    /*do{
      agendaRows.add(
        getRows(agendaStart, currentMonth)
      );
      agendaStart = agendaStart.add(Duration(days: DateTime.daysPerWeek));
    } while (agendaStart.month == currentMonth);*/
    for (int i = 0; i < 6; i++){
      agendaRows.add(
          getRows(agendaStart, currentMonth)
      );
      agendaStart = agendaStart.add(Duration(days: DateTime.daysPerWeek));
    }

    return Table(
        children: agendaRows,
    );
  }

  Color getCouleurCercleJour(DateTime jour, int currentMonth){
    if (!areSameDay(widget.selectedDate, jour)){
      return Colors.transparent;
    }

    if (areSameDay(widget.selectedDate, DateTime.now())){
      return Colors.blue;
    }

    if (widget.selectedDate.month == currentMonth){
      return Colors.black;
    }

    return Colors.grey;
  }

  TableRow getRows(DateTime rowStart, int currentMonth){
    return TableRow(
      children: List.generate(
        DateTime.daysPerWeek, (index) {
          DateTime iJour = rowStart;
          rowStart = rowStart.add(Duration(days: 1));

          return GestureDetector(
            onTap: () {
              widget.changeDate(iJour);
            },
            child: Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: getCouleurCercleJour(iJour, currentMonth),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    texteJour(iJour, currentMonth),
                    getPastilleJour(iJour),
                    SizedBox(height: 5,)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row getPastilleJour(DateTime jour){
    Widget pastille(Color couleur){
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: couleur,
                width: 3
            )
        ),
      );
    }

    List<Widget> listeWidget = [];
    Map<String,List<dynamic>> mapEvenements = GetBdd.getEvenement(debut: jour, fin: jour);
    if (mapEvenements.isEmpty){
      listeWidget.add(pastille(Colors.transparent));
    }
    else{
      List<dynamic> evenements = mapEvenements.values.first;
      List<int> typeEvenement = List.generate(evenements.length, (index) {return evenements[index]["type"];});

      double width = 5;
      if (typeEvenement.contains(TypeEvenement.evenement)){
        listeWidget.add(pastille(Colors.blue));
        listeWidget.add(SizedBox(width: width,));
      }
      if (typeEvenement.contains(TypeEvenement.anniversaire)){
        listeWidget.add(pastille(Colors.red));
        listeWidget.add(SizedBox(width: width,));
      }
      if (typeEvenement.contains(TypeEvenement.fete)){
        listeWidget.add(pastille(Colors.green));
        listeWidget.add(SizedBox(width: width,));
      }

      listeWidget.removeLast();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listeWidget,
    );
  }

  Color getCouleurPastilleJour(DateTime jour){
    Color color = Colors.transparent;

    Map<String,List<dynamic>> mapEvenements = GetBdd.getEvenement(debut: jour, fin: jour);
    if (mapEvenements.isEmpty){
      return color;
    }
    List<dynamic> evenements = mapEvenements.values.first;

    for (Map<String, dynamic> event in evenements){
      if (event["type"] == TypeEvenement.fete){
        color = Colors.green;
      }
    }
    for (Map<String, dynamic> event in evenements){
      if (event["type"] == TypeEvenement.anniversaire){
        color = Colors.red;
      }
    }
    for (Map<String, dynamic> event in evenements){
      if (event["type"] == TypeEvenement.evenement){
        color = Colors.blue;
      }
    }
    
    return color;
  }

  Widget texteJour(DateTime jour, int currentMonth) {
    Color color = Colors.black;
    if (jour.month != currentMonth){
      color = Colors.grey;
    }
    if (areSameDay(jour, DateTime.now())){
      color = Colors.blue;
    }

    return Center(
      child: Text(
        jour.day.toString(),
        style: TextStyle(
          color: color,
          fontSize: 24,
        ),
      ),
    );
  }

}