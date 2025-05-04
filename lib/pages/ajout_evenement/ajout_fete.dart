import 'package:flutter/material.dart';

import '../../widget/form/text_field.dart';

class AjoutFete extends StatefulWidget {
  const AjoutFete({super.key, this.selectedDate, this.fete});

  final DateTime? selectedDate;
  final Map<String,dynamic>? fete;

  @override
  State<AjoutFete> createState() => _AjoutFete();
}

class _AjoutFete extends State<AjoutFete> {
  @override
  void initState() {
    super.initState();

    if (widget.fete != null) {
      controllerNom.text = widget.fete!["nom"];
      controllerDetail.text = widget.fete!["detail"];
    }
  }

  TextEditingController controllerNom = TextEditingController();
  TextEditingController controllerDetail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fete == null ? null : AppBar(),
      floatingActionButton: confirmerFete(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Detail d'une Fête",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              buildTextField(controllerNom, "Nom de la fêtes"),
              buildTextField(controllerDetail, "Detail", maxLines: 3),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton confirmerFete(){
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: "Confirmer création",
      child: Icon(Icons.save),
    );
  }

}