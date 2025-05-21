import 'package:agenda/utils.dart';
import 'package:agenda/widget/calendrier/mois/page_calendrier.dart';
import 'package:flutter/material.dart';

import '../../../pages/principale/mois.dart';

class Calendrier extends StatefulWidget {
  const Calendrier({super.key, required this.changeDate, required this.selectedDate,
    required this.startButtonKey, this.selectedMonth, required this.cliqueTexte});

  final Function(DateTime newDay) changeDate;
  final DateTime selectedDate;
  final GlobalKey<StartButtonState> startButtonKey;
  final DateTime? selectedMonth;
  final void Function(int) cliqueTexte;

  @override
  State<Calendrier> createState() => CalendrierState();
}

class CalendrierState extends State<Calendrier> {
  late PageController pageController;
  late int currentPage;

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

    int initialPage(){
      if (widget.selectedMonth == null){
        return 0;
      }

      DateTime now = DateTime.now();
      if (now.year == widget.selectedMonth!.year && now.month == widget.selectedMonth!.month){
        return 0;
      }

      if (widget.selectedMonth!.isBefore(now)){
        int compte = 0;
        DateTime iDate = widget.selectedMonth!;
        while (!(now.year == iDate.year && now.month == iDate.month)){
          compte++;
          iDate = DateTime(iDate.year, iDate.month+1);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.startButtonKey.currentState!.setVisibility(true);
        });
        return -compte;
      }
      else{
        int compte = 0;
        DateTime iDate = widget.selectedMonth!;
        while (!(now.year == iDate.year && now.month == iDate.month)){
          compte++;
          iDate = DateTime(iDate.year, iDate.month-1);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.startButtonKey.currentState!.setVisibility(true);
        });
        return compte;
      }
    }

    currentPage = realIndex(initialPage(), reverse: true);
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
            if (realIndex(index) != 0) {
              widget.startButtonKey.currentState?.setVisibility(true);
            }
            else if (areSameDay(widget.selectedDate, DateTime.now())){
              widget.startButtonKey.currentState?.setVisibility(false);
            }
          });
        },
        //itemCount: displayedMonth.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return PageCalendrier(
            moisPage: DateTime.utc(DateTime.now().year, DateTime.now().month+realIndex(index),1, ),
            changeDate: (DateTime newDate) {
              DateTime now = DateTime.now();
              DateTime moisActuelle = DateTime(now.year, now.month + realIndex(currentPage), 1);

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
    DateTime debutMois = DateTime(DateTime.now().year, DateTime.now().month+realIndex(numeroPage),1);
    String mois = dateFormatAnneeMoisTexte.format(debutMois);
    mois = mois[0].toUpperCase() + mois.substring(1);
    return mois;
  }

  Widget monthText(){
    return GestureDetector(
      onTap: () {
        widget.cliqueTexte(
            DateTime(DateTime.now().year, DateTime.now().month+realIndex(currentPage),1).year,
        );
      },
      child: Text(
        getMonth(currentPage),
        style: TextStyle(
          color: Colors.black,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void jumpToMonth(int i) {
    pageController.animateToPage(
      realIndex(i, reverse:true),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }


}