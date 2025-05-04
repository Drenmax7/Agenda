import 'package:agenda/bdd/ajout_bdd.dart';
import 'package:agenda/bdd/bdd.dart';
import 'package:agenda/bdd/suppression_BDD.dart';

class ModificationBdd {
  static void modifierEvenement({required String id, required String titre, required String lieu,
    required String description, required DateTime jourDebut, required DateTime jourFin,
    required String heureDebut, required String heureFin}){

    SuppressionBdd.supprimerEvenement(id);
    AjoutBDD.ajouteEvenement(titre: titre, jourDebut: jourDebut, jourFin: jourFin,
        heureDebut: heureDebut, heureFin: heureFin, lieu: lieu, description: description
    );
  }

  static void modifierAnniversaire({required String id, required String date,
    required DateTime jour, required String nom, required int naissance,
    required String details}){

    SuppressionBdd.supprimerAnniversaire(id, date);
    AjoutBDD.ajouteAnniversaire(jour: jour, nom: nom, naissance: naissance, details: details);
  }
}