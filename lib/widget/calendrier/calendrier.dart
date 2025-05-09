import 'package:agenda/utils.dart';
import 'package:agenda/widget/calendrier/page_calendrier.dart';
import 'package:flutter/material.dart';

import '../../pages/principale/mois.dart';

class Calendrier extends StatefulWidget {
  const Calendrier({super.key, required this.changeDate, required this.selectedDate, required this.startButtonKey});

  final Function(DateTime newDay) changeDate;
  final DateTime selectedDate;
  final GlobalKey<StartButtonState> startButtonKey;

  @override
  State<Calendrier> createState() => CalendrierState();
}

class CalendrierState extends State<Calendrier> {
  List<int> displayedMonth = List.generate(25, (index) => index-12, growable: true);

  late PageController pageController;
  late int currentPage;

  @override
  void initState() {
    super.initState();

    currentPage = displayedMonth.indexOf(0);
    pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          monthText(),
          weekDay(),
          jours(),
        ],
      ),
    );
  }

  Widget jours(){
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (int index) {
          // Cette fonction est appelée quand la page change
          setState(() {
            currentPage = index;
            if (displayedMonth[index] != 0) {
              widget.startButtonKey.currentState?.setVisibility(true);
            }
            else if (areSameDay(widget.selectedDate, DateTime.now())){
              widget.startButtonKey.currentState?.setVisibility(false);
            }
          });
        },
        itemCount: displayedMonth.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return PageCalendrier(
            moisPage: DateTime(DateTime.now().year, DateTime.now().month+displayedMonth[index],1, ),
            changeDate: (DateTime newDate) {
              DateTime now = DateTime.now();
              DateTime moisActuelle = DateTime(now.year, now.month + displayedMonth[currentPage], 1);

              if (moisActuelle.month != newDate.month || moisActuelle.year != newDate.year){
                int newPage = newDate.isBefore(moisActuelle) ? currentPage-1 : currentPage+1;
                pageController.animateToPage(newPage,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.linear);
              }

              widget.changeDate(newDate);
            },
            selectedDate: widget.selectedDate,
          );
        },
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
                  jourSemaine(index),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )
            ),
          ),
        ),
      ],
    );
  }
  
  String getMonth(int numeroPage){
    DateTime debutMois = DateTime(DateTime.now().year, DateTime.now().month+displayedMonth[numeroPage],1);
    String mois = dateFormatAnneeMoisTexte.format(debutMois);
    mois = mois[0].toUpperCase() + mois.substring(1);
    return mois;
  }

  Widget monthText(){
    return Text(
      getMonth(currentPage),
      style: TextStyle(
        color: Colors.black,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void jumpToMonth(int i) {
    pageController.animateToPage(
      displayedMonth.indexOf(i),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }


}