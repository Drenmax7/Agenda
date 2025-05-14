import 'package:agenda/widget/calendrier/liste_annee/page_liste_annee.dart';
import 'package:flutter/material.dart';

import '../../../pages/principale/annee.dart';

class ListeAnnee extends StatefulWidget {
  const ListeAnnee({super.key, required this.setAffichage, required this.startButtonKey, required this.cliqueAnnee,});

  final void Function(Affichage) setAffichage;
  final GlobalKey<StartButtonState> startButtonKey;
  final void Function(int) cliqueAnnee;

  @override
  State<ListeAnnee> createState() => ListeAnneeState();
}

class ListeAnneeState extends State<ListeAnnee> {
  late PageController pageController;
  late int currentPage;

  int nbRow = 7;
  int nbColumn = 3;

  void jumpToYear(int i) {
    pageController.animateToPage(realIndex(0, reverse: true), duration: Duration(milliseconds: 500), curve: Curves.linear);
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

    currentPage = realIndex(0, reverse: true);
    pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          nomPeriode(),
          pageViewer(),
        ],
      ),
    );
  }

  int calculDebutPeriode(int page){
    int decalage = (nbRow/2).toInt() * nbColumn + (nbColumn/2).toInt();
    int index = realIndex(page);
    decalage -= nbRow * nbColumn * index;

    return DateTime.now().year - decalage;
  }

  Widget nomPeriode(){
    int debutPeriode = calculDebutPeriode(currentPage);

    return GestureDetector(
      onTap: () {
        widget.setAffichage(Affichage.annee);
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          "$debutPeriode-${debutPeriode+nbRow*nbColumn-1}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget pageViewer(){
    return Expanded(
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: pageController,
        physics: const ClampingScrollPhysics(),
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
        itemBuilder: (context, index) {
          return PageListeAnnee(
            cliqueAnnee: widget.cliqueAnnee,
            nbRow: nbRow,
            nbColumn: nbColumn,
            debutPeriode: calculDebutPeriode(index),
          );
        },
      ),
    );
  }


  String getAnnee(int numeroPage){
    DateTime debutAnnee = DateTime(DateTime.now().year + realIndex(numeroPage));
    String annee = debutAnnee.year.toString();
    return annee;
  }
}