import 'package:agenda/pages/ajout_evenement/ajout_anniversaire.dart';
import 'package:agenda/pages/ajout_evenement/ajout_evenement.dart';
import 'package:agenda/widget/information/notification.dart';
import 'package:agenda/widget/information/snackbar.dart';
import 'package:flutter/material.dart';

import '../../bdd/io_evenement.dart';

class AjoutEvenementMenu extends StatefulWidget {
  const AjoutEvenementMenu({super.key, required this.selectedDate});

  final DateTime? selectedDate;

  @override
  State<AjoutEvenementMenu> createState() => _AjoutEvenementMenu();
}

class _AjoutEvenementMenu extends State<AjoutEvenementMenu> {
  final PageController pageController = PageController(initialPage: 0);
  int pageActuelle = 0;

  @override
  Widget build(BuildContext context) {
    //IOEvenement.generateSample();

    return Scaffold(
      appBar: onglets(),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          AjoutEvenement(selectedDate: widget.selectedDate),
          AjoutAnniversaire(selectedDate: widget.selectedDate),
          parametre(),
        ],
      )
    );
  }

  AppBar onglets(){
    List<String> nomOnglet = [
      "Evénements",
      "Anniversaire",
      "⚙️"
    ];

    Map<int, FlexColumnWidth> columnWidth = {};
    for (int i = 0; i < nomOnglet.length; i++) {
      columnWidth[i] = FlexColumnWidth(nomOnglet[i].length.toDouble());
    }

    return AppBar(
      backgroundColor: Colors.deepPurple,
      title: Table(
        columnWidths: columnWidth,
        children: [
          TableRow(
            children: List.generate(
                nomOnglet.length,
                (index) {
                  Color color = Colors.grey.shade300;
                  if (pageActuelle == index) {
                    color = Colors.yellow;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        pageActuelle = index;
                        pageController.jumpToPage(index);
                      });
                    },
                    child: Container(
                      height: 80,
                      color: pageActuelle == index ? Colors.deepPurple[700] : Colors.transparent,
                      child: Center(
                        child: Text(
                          nomOnglet[index],
                          style: TextStyle(
                            color: color,
                            fontSize: 16,
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

  Widget parametre() {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Import/Export',
              style: TextStyle(
                  fontSize: 24
              ),),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      IOEvenement.import().then((resultat) {
                        if (resultat) {
                          showSnackbar(() {return context;}(), "🟢 Import réussie"); //warning sinon
                        } else {
                          showSnackbar(() {return context;}(), "🔴 Erreur lors de l'import");
                        }
                      });
                    },
                    icon: Icon(Icons.file_download),
                    label: Text(
                      'Import',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                  ),
                  SizedBox(width: 50,),
                  ElevatedButton.icon(
                    onPressed: () {
                      IOEvenement.export().then((resultat) {
                        if (resultat) {
                          showSnackbar(() {return context;}(), "🟢 Export réussie"); //warning sinon
                        } else {
                          showSnackbar(() {return context;}(), "🔴 Erreur lors de l'export");
                        }
                      });
                    },
                    icon: Icon(Icons.file_upload),
                    label: Text(
                      'Export',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}