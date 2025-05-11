import 'package:agenda/bdd/ajout_bdd.dart';
import 'package:agenda/bdd/modification_bdd.dart';
import 'package:flutter/material.dart';

import '../../bdd/suppression_BDD.dart';
import '../../utils.dart';
import '../../widget/information/confirmation_box.dart';
import '../../widget/picker/datetime_picker.dart';
import '../../widget/information/snackbar.dart';
import '../../widget/form/text_field.dart';

class AjoutEvenement extends StatefulWidget {
  const AjoutEvenement({super.key, this.selectedDate, this.evenement, this.specialFunction});

  final DateTime? selectedDate;
  final Map<String,dynamic>? evenement;
  final void Function(VoidCallback)? specialFunction;

  @override
  State<AjoutEvenement> createState() => _AjoutEvenement();
}

class _AjoutEvenement extends State<AjoutEvenement> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();

    if (widget.evenement != null){
      controllerIntitule.text = widget.evenement!["titre"];

      if (widget.evenement!["lieu"] != null) {
        controllerLieu.text = widget.evenement!["lieu"];
      }
      if (widget.evenement!["description"] != null) {
        controllerDescription.text = widget.evenement!["description"];
      }

      controllerDateDebut.text = "${widget.evenement!["jourDebut"]} ${widget.evenement!["heureDebut"]}";
      controllerDateFin.text = "${widget.evenement!["jourFin"]} ${widget.evenement!["heureFin"]}";
    }

    if (widget.selectedDate != null){
      DateTime dateAffiche = DateTime(widget.selectedDate!.year,
          widget.selectedDate!.month, widget.selectedDate!.day,
          DateTime.now().hour, DateTime.now().minute
      );
      while (dateAffiche.minute%15 != 0){
        dateAffiche = dateAffiche.subtract(Duration(minutes: 1));
      }
      controllerDateDebut.text = dateFormatAnneeHeure.format(dateAffiche);
      controllerDateFin.text = dateFormatAnneeHeure.format(dateAffiche);
    }
  }

  TextEditingController controllerIntitule = TextEditingController();
  TextEditingController controllerLieu = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerDateDebut = TextEditingController();
  TextEditingController controllerDateFin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: widget.evenement == null ? null : AppBar(backgroundColor: Colors.grey[200],),
      floatingActionButton: confirmerEvenement(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Text(
                  widget.evenement == null ? "Ajouter un Événement" : "Detail d'un Événement",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              buildTextField(controllerIntitule, "Intitulé", mode: TextCapitalization.words, focus: focusNode),
              buildTextField(controllerLieu, "Lieu"),
              buildTextField(controllerDescription, "Description", maxLines: 3),
              _buildDatePickerFieldEvenement(controllerDateDebut, controllerDateFin, "Debut", true),
              _buildDatePickerFieldEvenement(controllerDateFin, controllerDateDebut, "Fin", false),
              if (widget.evenement != null) supprimerBouton(),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton confirmerEvenement(){
    return FloatingActionButton(
      onPressed: () {
        if (controllerDateDebut.text.isEmpty) {
          showSnackbar(context, "Veuillez indiquer une date de debut");
          return;
        }
        if (controllerDateFin.text.isEmpty) {
          showSnackbar(context, "Veuillez indiquer une date de fin");
          return;
        }
        if (controllerIntitule.text.isEmpty) {
          showSnackbar(context, "Veuillez indiquer un nom d'événement");
          return;
        }

        List<String> dateDebut = controllerDateDebut.text.split(" ")[0].split("/");
        String heureDebut = controllerDateDebut.text.split(" ")[1];
        List<String> dateFin = controllerDateFin.text.split(" ")[0].split("/");
        String heureFin = controllerDateFin.text.split(" ")[1];

        if (widget.evenement == null){
          AjoutBDD.ajouteEvenement(
              jourDebut: DateTime(int.parse(dateDebut[2]), int.parse(dateDebut[1]), int.parse(dateDebut[0])),
              heureDebut: heureDebut,
              jourFin: DateTime(int.parse(dateFin[2]), int.parse(dateFin[1]), int.parse(dateFin[0])),
              heureFin: heureFin,
              lieu: controllerLieu.text,
              titre: controllerIntitule.text,
              description: controllerDescription.text
          );
        }
        else {
          widget.specialFunction!((){
            ModificationBdd.modifierEvenement(
              id: widget.evenement!["id"],
              jourDebut: DateTime(int.parse(dateDebut[2]), int.parse(dateDebut[1]), int.parse(dateDebut[0])),
              heureDebut: heureDebut,
              jourFin: DateTime(int.parse(dateFin[2]), int.parse(dateFin[1]), int.parse(dateFin[0])),
              heureFin: heureFin,
              lieu: controllerLieu.text,
              titre: controllerIntitule.text,
              description: controllerDescription.text,
            );
          });
        }

        Navigator.pop(context);
      },
      tooltip: "Confirmer création",
      child: Icon(Icons.save),
    );
  }

  Widget _buildDatePickerFieldEvenement(TextEditingController dateController, TextEditingController otherController,  String label, bool controllerEstDebut) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: dateController,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.date_range),
        ),
        readOnly: true,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return SizedBox(
                height: 250,
                child: DateTimePicker(
                  selectedDate: dateController.text.isNotEmpty ? dateFormatAnneeHeure.parse(dateController.text) : widget.selectedDate,
                  onTimeChanged: (time) {
                    String day = time.day.toString().padLeft(2, "0");
                    String month = time.month.toString().padLeft(2, "0");
                    String year = time.year.toString().padLeft(4, "0");
                    String hour = time.hour.toString().padLeft(2, "0");
                    String minute = time.minute.toString().padLeft(2, "0");

                    dateController.text = "$day/$month/$year $hour:$minute";

                    if (otherController.text.isEmpty){
                      otherController.text = dateController.text;
                      return;
                    }

                    DateTime other = dateFormatAnnee.parse(otherController.text);
                    DateTime date = dateFormatAnnee.parse(dateController.text);


                    if (controllerEstDebut && other.isBefore(date)){
                      otherController.text = dateController.text;
                      return;
                    }

                    if (!controllerEstDebut && other.isAfter(date)){
                      otherController.text = dateController.text;
                      return;
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget supprimerBouton() {
    return TextButton.icon(
      onPressed: () {
        confirmDeletion(context, () {
          widget.specialFunction!(() {
            SuppressionBdd.supprimerEvenement(widget.evenement!["id"]);
            Navigator.pop(context);
          });
        });
      },
      icon: Icon(Icons.delete),
      label: Text(
        "Supprimer l'evenement",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}