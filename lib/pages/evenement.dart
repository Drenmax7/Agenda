import 'package:agenda/io_evenement.dart';
import 'package:agenda/utils.dart';
import 'package:agenda/widget/barre_recherche.dart';
import 'package:agenda/widget/liste_evenement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../widget/bouton_ajout.dart';

class Evenement extends StatefulWidget {
  const Evenement({super.key, this.cacheRecherche = false, this.filtreRecherche = ""});

  final bool cacheRecherche;
  final String filtreRecherche;

  @override
  State<Evenement> createState() => _Evenement();
}

class _Evenement extends State<Evenement> {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener listener = ItemPositionsListener.create();
  int indexToJumpTo = 0;
  bool atStart = true;

  DateTime dateDebutListe = DateTime.now().subtract(Duration(days: 3650));
  DateTime dateFinListe = DateTime.now().add(Duration(days: 3650));
  late Map<String,List<dynamic>> listeEvenement;
  int filtreEvenement = TypeEvenement.tout;

  @override
  void initState() {
    super.initState();

    listeEvenement = IOEvenement.getEvenement(
      debut: dateDebutListe,
      fin: dateFinListe,
      filtre: filtreEvenement,
      filtreRecherche : widget.filtreRecherche,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: indexToJumpTo, alignment: 0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: choixFiltre(),
      backgroundColor: Colors.grey[200],
      body : creeListe(),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: widget.cacheRecherche ? 80 : 150,
            right: 10,
            child: Visibility(
              visible: atStart,
              child: FloatingActionButton(
                onPressed: (){
                  setState(() {
                    itemScrollController.scrollTo(index: indexToJumpTo, alignment: 0.5, duration: Duration(milliseconds: 500));
                  });
                },
                tooltip: 'Jour actuelle',
                child: const Icon(Icons.calendar_today),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: boutonAjout(context, null),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: Visibility(
              visible: !widget.cacheRecherche,
              child: FloatingActionButton(
                onPressed: (){
                  showSearch(
                    context: context,
                    delegate: Barrerecherche(),
                  );
                },
                tooltip: 'Recherche',
                child: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar choixFiltre(){
    Map<String,int> nomOnglet = {
      "Tous" : TypeEvenement.tout,
      "Ponctuelle" : TypeEvenement.evenement,
      "Anniversaire" : TypeEvenement.anniversaire,
      "Fetes" : TypeEvenement.fete,
    };

    Map<int, FlexColumnWidth> columnWidth = {};
    for (int i = 0; i < nomOnglet.length; i++) {
      columnWidth[i] = FlexColumnWidth(nomOnglet.keys.toList()[i].length.toDouble());
    }

    return AppBar(
      toolbarHeight: 30,
      backgroundColor: Colors.deepPurple[400],
      title: Table(
        //columnWidths: columnWidth,
        children: [
          TableRow(
            children: List.generate(
                nomOnglet.length,
                    (index) {
                  Color color = Colors.grey.shade300;
                  if (nomOnglet.values.toList()[index] == filtreEvenement) {
                    color = Colors.yellow;
                  }

                  return Container(
                    color: nomOnglet.values.toList()[index] == filtreEvenement ? Colors.deepPurple[300] : Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          filtreEvenement = nomOnglet.values.toList()[index];

                          //int placeActuelle = listener.itemPositions.value.last.index;
                          //String sDateActuelle = listeEvenement.keys.toList()[placeActuelle];

                          listeEvenement = IOEvenement.getEvenement(
                            debut: dateDebutListe,
                            fin: dateFinListe,
                            filtre: filtreEvenement,
                            filtreRecherche : widget.filtreRecherche,
                          );

                          /*DateTime dateActuelle = DateFormat('dd/MM/yyyy').parse(sDateActuelle);
                      indexToJumpTo = 0;
                      if (listeEvenement.isNotEmpty) {
                        while (DateFormat('dd/MM/yyyy')
                            .parse(listeEvenement.keys.toList()[indexToJumpTo])
                            .isBefore(
                            dateActuelle)) {
                          indexToJumpTo++;
                        }
                        print("saut a $indexToJumpTo");
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          itemScrollController.jumpTo(index: indexToJumpTo, alignment: 0.5);
                        });
                      }*/
                        });
                      },
                      child: Container(
                        height: 60,
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            nomOnglet.keys.toList()[index],
                            style: TextStyle(
                              color: color,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget creeListe(){
    List<String> listeDates = listeEvenement.keys.toList();
    int i = 0;
    if (listeDates.isNotEmpty) {
      while (DateFormat('dd/MM/yyyy').parse(listeDates[i]).isBefore(
          DateTime.now())) {
        i++;
      }
    }
    indexToJumpTo = i;

    listener.itemPositions.addListener(() {
      if (listener.itemPositions.value.isEmpty){
        return;
      }

      bool newAtStart = false;
      for (ItemPosition i in listener.itemPositions.value){
        newAtStart |= i.index == indexToJumpTo;
      }
      newAtStart = !newAtStart;
      bool changement = newAtStart != atStart;

      int? ancienneTaille;
      if (listener.itemPositions.value.last.index == 0){
        changement = true;
        ancienneTaille = listeEvenement.length;
        dateDebutListe = dateDebutListe.subtract(Duration(days: 365));
      }

      if (listener.itemPositions.value.last.index == listeDates.length-1){
        changement = true;
        dateFinListe = dateFinListe.add(Duration(days: 365));
      }

      if (changement){
        listeEvenement = IOEvenement.getEvenement(
          debut: dateDebutListe,
          fin: dateFinListe,
          filtre: filtreEvenement,
          filtreRecherche : widget.filtreRecherche,
        );

        if (ancienneTaille != null){
          int ajout = listeEvenement.length - ancienneTaille;
          itemScrollController.jumpTo(index: listener.itemPositions.value.last.index + ajout + 1);
        }

        setState(() {
          atStart = newAtStart;
        });
      }
    });

    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemCount: listeEvenement.keys.length,
      itemPositionsListener: listener,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  convertDateCourtToLong(listeDates[index]),
                  style: TextStyle(
                    fontSize: 18,
                    color: isToday(listeDates[index]) ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              ListeEvenement(evenements: listeEvenement[listeDates[index]]!, jour: listeDates[index]),
            ],
          ),
        );
      },
    );
  }
}