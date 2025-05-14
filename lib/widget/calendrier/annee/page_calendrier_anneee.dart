import 'package:flutter/material.dart';

import '../../../utils.dart';

class PageCalendrierAnnee extends StatefulWidget {
  const PageCalendrierAnnee({super.key, required this.annee, required this.cliqueMois});

  final DateTime annee;
  final void Function(DateTime) cliqueMois;

  @override
  State<PageCalendrierAnnee> createState() => _PageCalendrierAnneeState();
}

class _PageCalendrierAnneeState extends State<PageCalendrierAnnee> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tableau();
  }
  
  Widget tableau(){
    int nbRow = 4;
    int nbColumn = 3;
    
    return Table(
      children: List<TableRow>.generate(nbRow, (iRow) {
        return TableRow(
          children: List<Widget>.generate(nbColumn, (jColumn) {
            return caseTableau(DateTime(widget.annee.year, iRow*nbColumn+jColumn+1, 1));
          }),
        );
      }),
    );
  }

  Widget monthText(int numMois, Color color){
    return Text(
      moisDeAnnee(numMois),
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget weekDay() {
    return Table(
      children: [
        TableRow(
          children: List.generate(
            DateTime.daysPerWeek,
            (index) => Center(
              child: Text(
                jourSemaine(index)[0],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget jour(DateTime mois){
    DateTime iDate = mois.toUtc();
    while (iDate.weekday != DateTime.monday){
      iDate = iDate.subtract(Duration(days: 1));
    }

    List<TableRow> rows = [];

    for (int i = 0; i < 6; i++) {
      rows.add(TableRow(
        children: List<Widget>.generate(DateTime.daysPerWeek, (index) {
          String jour = iDate.month == mois.month ? iDate.day.toString() : "";
          Color color = areSameDay(DateTime.now(), iDate) ? Colors.blue : Colors.black;
          iDate = iDate.add(Duration(days: 1));
          return Center(
            child: Text(
              jour,
              style: TextStyle(
                color: color,
                fontSize: 11,
              ),
            ),
          );
        }),
      ));
    }

    return Table(
      children: rows,
    );
  }

  Widget caseTableau(DateTime mois){
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, 1);
    Color color = Colors.black;
    if (now == mois){
      color = Colors.blue;
    }

    return GestureDetector(
      onTap: () {
        widget.cliqueMois(mois);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            monthText(mois.month, color),
            weekDay(),
            jour(mois),
          ],
        ),
      ),
    );
  }
}