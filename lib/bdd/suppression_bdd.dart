import 'package:agenda/bdd/io_evenement.dart';

import '../utils.dart';
import 'bdd.dart';

class SuppressionBdd{
  static void supprimerEvenement(String id){
    DateTime iDate = dateFormatAnnee.parse(BDD.evenement[id]["jourDebut"]);
    DateTime fin = dateFormatAnnee.parse(BDD.evenement[id]["jourFin"]).add(Duration(days: 1));

    do{
      String date = dateFormatAnnee.format(iDate);
      (BDD.agenda[date] as List<dynamic>).remove(id);

      iDate = iDate.add(Duration(days: 1));
    }
    while (iDate.isBefore(fin));
    BDD.evenement.remove(id);

    IOEvenement.save();
  }

  static void supprimerAnniversaire(String id, String date){
    (BDD.anniversaire[date] as List<dynamic>).removeAt(int.parse(id));

    IOEvenement.save();
  }
}