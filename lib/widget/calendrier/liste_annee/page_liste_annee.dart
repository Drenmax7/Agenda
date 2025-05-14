import 'package:agenda/bdd/bdd.dart';
import 'package:agenda/bdd/get_bdd.dart';
import 'package:flutter/material.dart';

class PageListeAnnee extends StatefulWidget {
  const PageListeAnnee({super.key, required this.debutPeriode, required this.cliqueAnnee, required this.nbColumn, required this.nbRow});

  final int debutPeriode;
  final void Function(int) cliqueAnnee;
  final int nbRow;
  final int nbColumn;

  @override
  State<PageListeAnnee> createState() => _PageListeAnneeState();
}

class _PageListeAnneeState extends State<PageListeAnnee> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Table(
        children: List<TableRow>.generate(widget.nbRow, (iRow) {
          return TableRow(
              children: List<Widget>.generate(widget.nbColumn, (jColumn) {
                return caseAnnee(widget.debutPeriode + iRow * widget.nbColumn + jColumn);
              })
          );
        }),
      ),
    );
  }

  bool isThereEvent(int annee){
    Map<String, List<dynamic>> events = GetBdd.getEvenement(
      debut: DateTime(annee, DateTime.january, 1),
      fin: DateTime(annee, DateTime.december, 31),
      filtre: TypeEvenement.evenement,
    );

    return events.isNotEmpty;
  }

  Widget caseAnnee(int annee){
    Color shade50 = Colors.grey.shade50;
    Color shade200 = Colors.grey.shade200;
    Color shade700 = Colors.grey.shade700;

    if (isThereEvent(annee)){
      shade50 = Colors.blue.shade50;
      shade200 = Colors.blue.shade200;
      shade700 = Colors.blue.shade700;
    }

    return GestureDetector(
      onTap: () {
        widget.cliqueAnnee(annee);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
          border: Border.all(
            color: shade200,
            width: 1.5,
          ),
        ),
        child: Text(
          "$annee",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DateTime.now().year == annee ? Colors.red : shade700,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}