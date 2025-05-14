import 'package:agenda/widget/calendrier/annee/page_calendrier_anneee.dart';
import 'package:flutter/material.dart';

import '../../../pages/principale/annee.dart';

class CalendrierAnnee extends StatefulWidget {
  const CalendrierAnnee({super.key, required this.setAffichage, required this.startButtonKey, required this.cliqueMois, this.selectedYear});

  final void Function(Affichage) setAffichage;
  final GlobalKey<StartButtonState> startButtonKey;
  final void Function(DateTime) cliqueMois;
  final int? selectedYear;

  @override
  State<CalendrierAnnee> createState() => CalendrierAnneeState();
}

class CalendrierAnneeState extends State<CalendrierAnnee> {
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

  void jumpToYear(int i) {
    pageController.animateToPage(realIndex(0, reverse: true), duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();

    int index = 0;
    if (widget.selectedYear != null){
      index = widget.selectedYear! - DateTime.now().year;
    }

    currentPage = realIndex(index, reverse: true);
    pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          anneeText(),
          mois(),
        ],
      ),
    );
  }

  Widget anneeText(){
    return GestureDetector(
      onTap: () {
        widget.setAffichage(Affichage.listeAnnee);
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          getAnnee(currentPage),
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget mois(){
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            currentPage = index;
            if (realIndex(index) != 0) {
              widget.startButtonKey.currentState?.setVisibility(true);
            }
            else {
              widget.startButtonKey.currentState?.setVisibility(false);
            }
          });
        },
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return PageCalendrierAnnee(
            annee: DateTime.utc(DateTime.now().year + realIndex(index)),
            cliqueMois: widget.cliqueMois,
          );
        },
      ),
    );
  }

  String getAnnee(int numeroPage){
    DateTime debutAnnee = DateTime(DateTime.now().toUtc().year + realIndex(numeroPage));
    String annee = debutAnnee.year.toString();
    return annee;
  }
}