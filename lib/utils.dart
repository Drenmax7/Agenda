import 'package:intl/intl.dart';

DateFormat dateFormatAnnee = DateFormat('dd/MM/yyyy'); // 30/08/2003
DateFormat dateFormatAnneeMoisTexte = DateFormat('MMMM yyyy', 'fr_FR'); // Aout 2003
DateFormat dateFormatAnneeHeure = DateFormat('dd/MM/yyyy HH:mm'); // 30/08/2003 15:47
DateFormat dateFormatJourMoisABR = DateFormat('E d MMM', 'fr'); // Sam. 30 Aout.
DateFormat dateFormatMois = DateFormat('dd/MM'); // 30/08
DateFormat heureFormat = DateFormat.Hm(); // 15:47
DateFormat formatageDateLongNoYear = DateFormat('EEEE d MMMM', 'fr_FR'); // Samedi 30 Aout
DateFormat formatageDateLongYear = DateFormat('EEEE d MMMM yyyy', 'fr_FR'); // Samedi 30 Aout 2003
DateFormat dateFormatJourSemaine = DateFormat("E", "fr");

String convertDateCourtToLong({String? formatCourt, DateTime? datetime}){
  DateTime date;
  if (formatCourt != null) {
    date = dateFormatAnnee.parse(formatCourt);
  }
  else if (datetime != null){
    date = datetime;
  }
  else{
    throw Exception("formatCourt et datetime ne peuvent pas etre tous les deux null");
  }

  DateFormat formatage;
  if (DateTime.now().year == date.year){
    formatage = formatageDateLongNoYear;
  }
  else{
    formatage = formatageDateLongYear;
  }
  String formatLong = formatage.format(date);

  return formatLong[0].toUpperCase() + formatLong.substring(1);
}

bool isToday(String dateFormatCourt){
  DateTime date = dateFormatAnnee.parse(dateFormatCourt);
  DateTime today = DateTime.now();

  return date.year == today.year && date.month == today.month && date.day == today.day;
}

bool areSameDay(DateTime day1, DateTime day2){
  return day1.day == day2.day && day1.month == day2.month && day1.year == day2.year;
}

String enleverAccents(String str) {
  var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }

  return str;
}

bool matchFilter({required String filtre, required Map<String,dynamic> evenement}) {
  for (String mot in filtre.split(" ")){
    bool motContenu = false;
    for (String key in evenement.keys){
      if (key == "deco"){
        continue;
      }

      mot = enleverAccents(mot).toLowerCase();
      String phrase = enleverAccents(evenement[key].toString()).toLowerCase();
      if (phrase.contains(mot)) {
        motContenu = true;
      }
    }

    if (!motContenu){
      return false;
    }
  }

  return true;
}

String jourSemaine(index){
  DateTime jourSemaine = DateTime(2025,DateTime.may,5);
  String jour = dateFormatJourSemaine.format(jourSemaine.add(Duration(days: index)));
  return jour[0].toUpperCase() + jour.substring(1);
}