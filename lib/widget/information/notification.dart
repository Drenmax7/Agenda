import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../bdd/bdd.dart';
import '../../utils.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await Permission.notification.request();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    WidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@drawable/ic_notification');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static send({required String titre, required String message,
    required DateTime moment, int numNotifJour = 0, required int idNotification}) async
  {
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'id',
        'canal',
        channelDescription: "Rappel d'anniversaire",
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: false,
      ),
    );

    tz.TZDateTime scheduledDate = tz.TZDateTime.local(moment.year, moment.month, moment.day, 10);

    scheduledDate = tz.TZDateTime.local(
        DateTime.now().year, DateTime.now().month, DateTime.now().day,
        DateTime.now().hour, DateTime.now().minute, DateTime.now().second+10);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      idNotification,
      titre,
      message,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
    print(message);
    //await flutterLocalNotificationsPlugin.show(id,titre,message,details,);
  }

  static int idNotification = 0;
  static sendAnniversary(){
    flutterLocalNotificationsPlugin.cancelAll();
    idNotification = 0;

    DateTime iDate = DateTime.now().toUtc();

    for (int i = 0; i < 365; i++){
      iDate = iDate.add(Duration(days: 1));

      String key = dateFormatMois.format(iDate);
      List<dynamic>? listAnniversaire = BDD.anniversaire[key];
      if (listAnniversaire == null){
        continue;
      }

      for (int j = 0; j < listAnniversaire.length; j++){
        Map<String, dynamic> anniv = listAnniversaire[j];

        String titre = "Anniversaire de ${anniv["nom"]}";
        String message;
        if (anniv["naissance"] != null) {
          message = "C'est l'anniversaire des ${iDate.year - anniv["naissance"]} ans de ${anniv["nom"]} aujourd'hui !";
        }
        else{
          message = "C'est l'anniversaire de ${anniv["nom"]} aujourd'hui !";
        }

        //DateFormat format = DateFormat('yyyyMMdd');
        //int id = int.parse("${format.format(moment)}$numNotifJour");

        send(
          idNotification: idNotification,
          titre: titre,
          message: message,
          moment: iDate,
          numNotifJour: j,
        );
        idNotification++;
      }
    }
  }
}