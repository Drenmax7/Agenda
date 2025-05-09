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
    do{
      agendaRows.add(
        getRows(agendaStart, currentMonth)
      );
      agendaStart = agendaStart.add(Duration(days: DateTime.daysPerWeek));
    } while (agendaStart.month == currentMonth);

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
                    pastilleJour(iJour, currentMonth),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: GetBdd.getEvenement(debut: iJour, fin: iJour).isEmpty ? Colors.transparent : Colors.blue[200]!,
                              width: 3
                          )
                      ),
                    ),
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

  Widget pastilleJour(DateTime jour, int currentMonth) {
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
          fontSize: 32,
        ),
      ),
    );
  }

}