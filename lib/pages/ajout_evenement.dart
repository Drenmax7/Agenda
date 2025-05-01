import 'package:agenda/widget/snackbar.dart';
import 'package:flutter/material.dart';

import '../io_evenement.dart';

class AjoutEvenement extends StatefulWidget {
  const AjoutEvenement({super.key, required this.selectedDate});

  final DateTime? selectedDate;

  @override
  State<AjoutEvenement> createState() => _AjoutEvenement();
}

class _AjoutEvenement extends State<AjoutEvenement> {
  final PageController pageController = PageController(initialPage: 0);
  int pageActuelle = 0;

  @override
  Widget build(BuildContext context) {
    IOEvenement.generateSample();

    return Scaffold(
      appBar: onglets(),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          evenement(),
          anniversaire(),
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

  TextEditingController evControllerIntitule = TextEditingController();
  TextEditingController evControllerLieu = TextEditingController();
  TextEditingController evControllerDescription = TextEditingController();
  TextEditingController evControllerDebut = TextEditingController();
  TextEditingController evControllerFin = TextEditingController();
  Widget evenement() {
    return Scaffold(
      floatingActionButton: confirmerEvenement(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Ajouter un Événement",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              _buildTextField(evControllerIntitule, "Intitulé"),
              _buildTextField(evControllerLieu, "Lieu"),
              _buildTextField(evControllerDescription, "Description", maxLines: 3),
              _buildTextField(evControllerDebut, "Debut"),
              _buildTextField(evControllerFin, "Fin"),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController anControllerNom = TextEditingController();
  TextEditingController anControllerDetail = TextEditingController();
  TextEditingController anControllerDate = TextEditingController();
  TextEditingController anControllerNaissance = TextEditingController();
  Widget anniversaire() {
    return Scaffold(
      floatingActionButton: confirmerAnniversaire(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                  child: Text(
                    "Ajouter un Anniversaire",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
              ),
              _buildTextField(anControllerNom, "Nom de la Personne"),
              _buildTextField(anControllerDetail, "Detail", maxLines: 3),
              _buildTextField(anControllerDate, "Date"),
              _buildTextField(anControllerNaissance, "Année de Naissance"),
            ],
          ),
        ),
      ),
    );
  }

  Widget parametre() {
    return Scaffold(
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
                          showSnackbar(context, "🟢 Import réussie");
                        } else {
                          showSnackbar(context, "🔴 Erreur lors de l'import");
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
                          showSnackbar(context, "🟢 Export réussie");
                        } else {
                          showSnackbar(context, "🔴 Erreur lors de l'export");
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

  FloatingActionButton confirmerEvenement(){
    return FloatingActionButton(
      onPressed: () {
        List<String> dateDebut = evControllerDebut.text.split(" ")[0].split("/");
        String heureDebut = evControllerDebut.text.split(" ")[1];
        List<String> dateFin = evControllerFin.text.split(" ")[0].split("/");
        String heureFin = evControllerFin.text.split(" ")[1];

        IOEvenement.ajouteEvenement(
            jourDebut: DateTime(int.parse(dateDebut[2]), int.parse(dateDebut[1]), int.parse(dateDebut[0])),
            heureDebut: heureDebut,
            jourFin: DateTime(int.parse(dateFin[2]), int.parse(dateFin[1]), int.parse(dateFin[0])),
            heureFin: heureFin,
            lieu: evControllerLieu.text,
            titre: evControllerIntitule.text,
            description: evControllerDescription.text
        );
        Navigator.pop(context);
      },
      tooltip: "Confirmer création",
      child: Icon(Icons.save),
    );
  }

  FloatingActionButton confirmerAnniversaire(){
    return FloatingActionButton(
      onPressed: () {
        List<String> date = anControllerDate.text.split("/");

        int naissance = 0;
        if (anControllerNaissance.text != ""){
          naissance = int.parse(anControllerNaissance.text);
        }

        IOEvenement.ajouteAnniversaire(
            jour: DateTime(0, int.parse(date[1]), int.parse(date[0])),
            nom: anControllerNom.text,
            details: anControllerDetail.text,
            naissance: naissance,
        );
        Navigator.pop(context);
      },
      tooltip: "Confirmer création",
      child: Icon(Icons.save),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: null,
      ),
    );
  }
}