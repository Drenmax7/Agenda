import '../utils.dart';
import 'bdd.dart';

class GetBdd{
  static Map<String,List<dynamic>> getEvenement({
    required DateTime debut, required DateTime fin,
    int filtre = TypeEvenement.tout, String filtreRecherche = ""})
  {

    Map<String,List<dynamic>> listeEvenement = {};
    for (DateTime i = debut; i.isBefore(fin); i = i.add(Duration(days: 1))){
      List<dynamic> evenementJour = [];

      if (filtre == TypeEvenement.tout || filtre == TypeEvenement.anniversaire) {
        List<dynamic>? listeAnniversaire;
        listeAnniversaire = BDD.anniversaire[dateFormatMois.format(i)];

        if (listeAnniversaire != null) {
          for (int id = 0; id < listeAnniversaire.length; id++) {
            Map<String, dynamic> anniversaire = Map.from(listeAnniversaire[id]);

            if (anniversaire["naissance"] > i.year){
              continue;
            }

            if (matchFilter(filtre : filtreRecherche, evenement : anniversaire)) {
              anniversaire["id"] = "$id";
              anniversaire["date"] = dateFormatMois.format(i);
              evenementJour.add(anniversaire);
            }
          }
        }
      }

      if (filtre == TypeEvenement.tout || filtre == TypeEvenement.evenement) {
        List<dynamic>? listeIdEvenement;
        listeIdEvenement = BDD.agenda[dateFormatAnnee.format(i)];
        if (listeIdEvenement != null) {
          for (String id in listeIdEvenement) {
            Map<String, dynamic> event = Map.from(BDD.evenement[id]);
            if (matchFilter(filtre : filtreRecherche, evenement : event)) {
              event["id"] = id;
              evenementJour.add(event);
            }
          }
        }
      }

      if (filtre == TypeEvenement.tout || filtre == TypeEvenement.fete) {
        Map<String,dynamic>? fete = getFete(i);
        if (fete != null && matchFilter(filtre : filtreRecherche, evenement : fete)){
          evenementJour.add(fete);
        }
      }

      if (evenementJour.isNotEmpty){
        listeEvenement[dateFormatAnnee.format(i)] = evenementJour;
      }
    }

    return listeEvenement;
  }

  static Map<String, dynamic>? getFete(DateTime jour){
    Map<String,dynamic> fete = {
      "type" : TypeEvenement.fete,
    };

    //Nouvel an
    if (jour.month == DateTime.january && jour.day == 1){
      fete["nom"] = "Nouvel An";
      fete["detail"] = "Fete de la nouvelle année";
      fete["deco"] = "🥂";
    }

    //Fete du travail
    if (jour.month == DateTime.may && jour.day == 1) {
      fete["nom"] = "Fête du Travail";
      fete["detail"] = "Célébration des travailleurs et de leurs droits";
      fete["deco"] = "💼";
    }

    //victoire 1945
    if (jour.month == DateTime.may && jour.day == 8) {
      fete["nom"] = "Victoire 1945";
      fete["detail"] = "Commémoration de la fin de la Seconde Guerre mondiale";
      fete["deco"] = "⚔️";
    }

    //14 juillet
    if (jour.month == DateTime.july && jour.day == 14) {
      fete["nom"] = "Fête Nationale";
      fete["detail"] = "Célébration de la Révolution Française et de la prise de la Bastille";
      fete["deco"] = "🎆";
    }

    //Assomption
    if (jour.month == DateTime.august && jour.day == 15) {
      fete["nom"] = "Assomption";
      fete["detail"] = "Fête religieuse célébrant l'élévation de la Vierge Marie au ciel";
      fete["deco"] = "️🙏";
    }

    //Toussaint
    if (jour.month == DateTime.november && jour.day == 1) {
      fete["nom"] = "Toussaint";
      fete["detail"] = "Commémoration de tous les saints et des défunts";
      fete["deco"] = "🕯️";
    }

    //Armistice
    if (jour.month == DateTime.november && jour.day == 11) {
      fete["nom"] = "Armistice 1918";
      fete["detail"] = "Commémoration de la fin de la Première Guerre mondiale";
      fete["deco"] = "🕊️";
    }

    //Noel
    if (jour.month == DateTime.december && jour.day == 25) {
      fete["nom"] = "Noël";
      fete["detail"] = "Célébration de la naissance de Jésus-Christ";
      fete["deco"] = "🎅";
    }

    //Paques
    DateTime pacques = getEasterDate(jour.year);
    DateTime lundiPacques = pacques.add(Duration(days: 1));
    if (jour.month == lundiPacques.month && jour.day == lundiPacques.day) {
      fete["nom"] = "Lundi de Pâques";
      fete["detail"] = "Jour férié religieux célébrant la résurrection du Christ";
      fete["deco"] = "🐇";
    }

    //Ascension (39 jours après Pâques)
    DateTime ascensionDate = pacques.add(Duration(days: 39));
    if (jour.month == ascensionDate.month && jour.day == ascensionDate.day) {
      fete["nom"] = "Ascension";
      fete["detail"] = "Fête religieuse célébrant l'ascension de Jésus au ciel";
      fete["deco"] = "🙏";
    }

    //Lundi de Pentecôte (50 jours après Pâques)
    DateTime lundiPentecoteDate = pacques.add(Duration(days: 50));
    if (jour.month == lundiPentecoteDate.month && jour.day == lundiPentecoteDate.day) {
      fete["nom"] = "Lundi de Pentecôte";
      fete["detail"] = "Jour férié religieux célébrant l'effusion du Saint-Esprit";
      fete["deco"] = "🙏";
    }

    if (fete.keys.length > 1){
      return fete;
    }
    else {
      return null;
    }
  }

  static DateTime getEasterDate(int year) {
    int a = year % 19;
    int b = year ~/ 100;
    int c = year % 100;
    int d = b ~/ 4;
    int e = b % 4;
    int f = (b + 8) ~/ 25;
    int g = (b - f + 1) ~/ 3;
    int h = (19 * a + b - d - g + 15) % 30;
    int i = c ~/ 4;
    int k = c % 4;
    int l = (32 + 2 * e + 2 * i - h - k) % 7;
    int m = (a + 11 * h + 22 * l) ~/ 451;
    int month = (h + l - 7 * m + 114) ~/ 31;
    int day = ((h + l - 7 * m + 114) % 31) + 1;

    return DateTime(year, month, day);
  }
}