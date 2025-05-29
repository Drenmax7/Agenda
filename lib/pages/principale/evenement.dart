import 'package:agenda/bdd/get_bdd.dart';
import 'package:agenda/utils.dart';
import 'package:agenda/widget/form/barre_recherche.dart';
import 'package:agenda/widget/list_event/liste_evenement.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bdd/bdd.dart';
import '../../widget/bouton_ajout.dart';

class Evenement extends StatefulWidget {
  const Evenement({super.key, this.cacheRecherche = false, this.filtreRecherche = "", this.ongletRecherche = false});

  final bool ongletRecherche;
  final bool cacheRecherche;
  final String filtreRecherche;

  @override
  State<Evenement> createState() => _Evenement();
}

class _Evenement extends State<Evenement> {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener listener = ItemPositionsListener.create();
  int indexToJumpTo = 0;
  bool scrollAtStart = true;

  DateTime dateDebutListe = DateTime.now().subtract(Duration(days: 365*3));
  DateTime dateFinListe = DateTime.now().add(Duration(days: 365*3));
  late Map<String,List<dynamic>> listeEvenement;
  int filtreEvenement = TypeEvenement.tout;

  final GlobalKey<_StartButton> startButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: indexToJumpTo, alignment: 0.3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: choixFiltre(),
      backgroundColor: Colors.grey[200],
      body : Stack(
        children: [
          creeListe(),
          if (widget.ongletRecherche)
            Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black),
              ),
              padding: EdgeInsets.all(12),
              child : Text(
                "${listeEvenement.keys.length} événements",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: widget.cacheRecherche ? 80 : 150,
            right: 10,
            child: StartButton(
              key: startButtonKey,
              indexToJumpTo: indexToJumpTo,
              itemScrollController: itemScrollController,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: boutonAjout(context, null, (){
              setState(() {
                listeEvenement = GetBdd.getEvenement(
                  debut: dateDebutListe,
                  fin: dateFinListe,
                  filtre: filtreEvenement,
                  filtreRecherche : widget.filtreRecherche,
                );
              });
            }),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: Visibility(
              visible: !widget.cacheRecherche,
              child: FloatingActionButton(
                heroTag: "btn2",
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

                          listeEvenement = GetBdd.getEvenement(
                            debut: dateDebutListe,
                            fin: dateFinListe,
                            filtre: filtreEvenement,
                            filtreRecherche : widget.filtreRecherche,
                          );

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            itemScrollController.jumpTo(index: indexToJumpTo, alignment: 0.3);
                          });
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
    listeEvenement = GetBdd.getEvenement(
      debut: dateDebutListe,
      fin: dateFinListe,
      filtre: filtreEvenement,
      filtreRecherche : widget.filtreRecherche,
    );

    List<String> listeDates = listeEvenement.keys.toList();
    int i = 0;
    if (listeDates.isNotEmpty) {
      DateTime iDate = dateFormatAnnee.parse(listeDates[i]);
      while (i < listeDates.length-1 && iDate.isBefore(DateTime.now()) && !areSameDay(DateTime.now(), iDate)) {
        i++;
        iDate = dateFormatAnnee.parse(listeDates[i]);
      }
    }
    indexToJumpTo = i+1;

    listener.itemPositions.addListener(() {
      final positions = listener.itemPositions.value;

      bool present = false;
      for (var position in positions) {
        if (position.itemLeadingEdge >= 0.0 && position.itemTrailingEdge <= 1.0) {
          //print('Item ${position.index} est visible à l\'écran!');
          if (position.index != indexToJumpTo){
            continue;
          }

          present = true;
          if (scrollAtStart == false){
            scrollAtStart = true;
            startButtonKey.currentState?.toggleVisibility(!scrollAtStart);
          }
        }
      }

      if (present == false && scrollAtStart == true){
        scrollAtStart = false;
        startButtonKey.currentState?.toggleVisibility(!scrollAtStart);
      }
    });

    List<Widget> liste = List.generate(listeEvenement.keys.length, (index) {
      return Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                convertDateCourtToLong(formatCourt: listeDates[index]),
                style: TextStyle(
                  fontSize: 18,
                  color: isToday(listeDates[index]) ? Colors.blue : Colors.black,
                ),
              ),
            ),
            ListeEvenement(
              evenements: listeEvenement[listeDates[index]]!,
              jour: listeDates[index],
              specialFunction: setState,
              ongletRecherche: widget.ongletRecherche,
            ),
          ],
        ),
      );
    });

    return ScrollablePositionedList.builder(
      itemPositionsListener: listener,
      itemScrollController: itemScrollController,
      itemCount: liste.length + 2,
      itemBuilder: (context, index) {
        if (index == 0){
          return TextButton.icon(
            onPressed: () {
              setState(() {
                dateDebutListe = dateDebutListe.subtract(Duration(days: 365));
              });
            },
            icon: Icon(Icons.expand_less),
            label: Text(
              "Evenement avant le ${formatageDateLongYear.format(dateDebutListe)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          );
        }
        else if (index == liste.length + 1){
          return TextButton.icon(
            onPressed: () {
              setState(() {
                dateFinListe = dateFinListe.add(Duration(days: 365));
              });
            },
            icon: Icon(Icons.expand_more),
            label: Text(
              "Evenement apres le ${formatageDateLongYear.format(dateFinListe)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          );
        }
        else {
          return liste[index-1];
        }
      },
    );
  }
}


class StartButton extends StatefulWidget {
  const StartButton({super.key, required this.indexToJumpTo, required this.itemScrollController});

  final int indexToJumpTo;
  final ItemScrollController itemScrollController;

  @override
  State<StartButton> createState() => _StartButton();
}

class _StartButton extends State<StartButton> {
  bool visible = true;

  void toggleVisibility(bool visibility){
    setState(() {
      visible = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: FloatingActionButton(
        heroTag: "btn1",
        onPressed: (){
          setState(() {
            widget.itemScrollController.scrollTo(index: widget.indexToJumpTo, alignment: 0.3, duration: Duration(milliseconds: 500));
          });
        },
        tooltip: 'Jour actuelle',
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

}