import 'package:intl/intl.dart';

DateFormat dateFormatAnnee = DateFormat('dd/MM/yyyy');
DateFormat dateFormatMois = DateFormat('dd/MM');
DateFormat heureFormat = DateFormat.Hm();
DateFormat formatageDateLongNoYear = DateFormat('EEEE d MMMM', 'fr_FR');
DateFormat formatageDateLongYear = DateFormat('EEEE d MMMM yyyy', 'fr_FR');

String convertDateCourtToLong(String formatCourt){
  DateTime date = dateFormatAnnee.parse(formatCourt);

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
  DateTime date = DateFormat('dd/MM/yyyy').parse(dateFormatCourt);
  DateTime today = DateTime.now();

  return date.year == today.year && date.month == today.month && date.day == today.day;
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