import 'package:agenda/bdd/ajout_bdd.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/date_picker.dart';
import '../widget/snackbar.dart';
import '../widget/text_field.dart';

class AjoutAnniversaire extends StatefulWidget {
  const AjoutAnniversaire({super.key, this.selectedDate, this.anniversaire});

  final DateTime? selectedDate;
  final Map<String,dynamic>? anniversaire;

  @override
  State<AjoutAnniversaire> createState() => _AjoutAnniversaire();
}

class _AjoutAnniversaire extends State<AjoutAnniversaire> {
  @override
  void initState() {
    super.initState();

    if (widget.anniversaire != null){
      controllerNom.text = widget.anniversaire!["nom"];
      controllerDate.text = widget.anniversaire!["date"];

      if (widget.anniversaire!["details"] != null) {
        controllerDetail.text = widget.anniversaire!["details"];
      }
      if (widget.anniversaire!["naissance"] != null) {
        controllerNaissance.text = "${widget.anniversaire!["naissance"]}";
      }
    }
  }

  TextEditingController controllerNom = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerNaissance = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.anniversaire == null ? null : AppBar(),
      floatingActionButton: confirmerAnniversaire(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Text(
                  widget.anniversaire == null ? "Ajouter un Anniversaire" : "Detail d'un Anniversaire",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              buildTextField(controllerNom, "Nom de la Personne"),
              buildTextField(controllerDetail, "Detail", maxLines: 3),
              _buildDatePickerFieldAnniversaire(controllerDate, controllerNaissance, "Date"),
              buildTextField(controllerNaissance, "Année de Naissance"),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton confirmerAnniversaire(){
    return FloatingActionButton(
      onPressed: () {
        if (controllerDate.text.isEmpty) {
          showSnackbar(context, "Veuillez indiquer une date d'anniversaire");
          return;
        }
        if (controllerNom.text.isEmpty) {
          showSnackbar(context, "Veuillez indiquer le nom de la personne");
          return;
        }

        List<String> date = controllerDate.text.split("/");

        int naissance = 0;
        if (controllerNaissance.text != ""){
          naissance = int.parse(controllerNaissance.text);
        }

        AjoutBDD.ajouteAnniversaire(
          jour: DateTime(0, int.parse(date[1]), int.parse(date[0])),
          nom: controllerNom.text,
          details: controllerDetail.text,
          naissance: naissance,
        );
        Navigator.pop(context);
      },
      tooltip: "Confirmer création",
      child: Icon(Icons.save),
    );
  }

  Widget _buildDatePickerFieldAnniversaire(TextEditingController dateController, TextEditingController anneeController, String label) {
    DateTime? calculSelectDate(){
      DateFormat stringToDateFormat = DateFormat('dd/MM');
      DateTime? dateMoisJour = dateController.text.isNotEmpty ? stringToDateFormat.parse(dateController.text) : widget.selectedDate;
      int year = 2000;
      if (anneeController.text.isNotEmpty){
        year = int.parse(anneeController.text);
      }

      DateTime? selectedDate;
      if (dateMoisJour != null){
        selectedDate = DateTime(year, dateMoisJour.month, dateMoisJour.day);
      }

      return selectedDate;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return SizedBox(
                height: 250,
                child: DatePicker(
                  selectedDate: calculSelectDate(),
                  onTimeChanged: (time) {
                    String day = time.day.toString().padLeft(2, "0");
                    String month = time.month.toString().padLeft(2, "0");
                    String year = time.year.toString().padLeft(4, "0");

                    dateController.text = "$day/$month";
                    if (year != "0000") {
                      anneeController.text = year;
                    }
                  },
                ),
              );
            },
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: label,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ),
    );
  }
}