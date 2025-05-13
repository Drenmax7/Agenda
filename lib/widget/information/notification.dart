import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import '../../bdd/bdd.dart';
import '../../utils.dart';

class NotificationManager {

  static Future<void> initialize() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    '@drawable/ic_notification';

    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_notification',
      [
        NotificationChannel(
          channelGroupKey: 'anniversaire_group',
          channelKey: 'anniversaire',
          channelName: 'Rappel anniversaire',
          channelDescription: 'Notification channel for anniversary reminder',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          enableLights: true
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'anniversaire_group',
            channelGroupName: 'Anniversaire group')
      ],
    );

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  static send({required String titre, required String message,
    required DateTime jour, int numNotifJour = 0, required int idNotification}) async
  {
    DateTime scheduleTime = DateTime(jour.year, jour.month, jour.day, 10);
    //scheduleTime = DateTime.now().add(Duration(seconds: 5));

    NotificationCalendar notificationCalendar = NotificationCalendar.fromDate(date: scheduleTime);
    notificationCalendar.allowWhileIdle = true;
    notificationCalendar.preciseAlarm = true;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: idNotification,
        channelKey: 'anniversaire',
        actionType: ActionType.Default,
        title: titre,
        body: message,
        category: NotificationCategory.Reminder,
      ),
      schedule: notificationCalendar,
    );

    print(message);
  }

  static int idNotification = 0;
  static sendAnniversary(){
    AwesomeNotifications().cancelNotificationsByChannelKey("anniversaire");
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
          jour: iDate,
          numNotifJour: j,
        );
        idNotification++;
      }
    }
  }
}

class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }
}