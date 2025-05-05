import 'dart:convert';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

import 'bdd.dart';

class IOEvenement{

  static Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> save() async {
    final path = await getFilePath();
    final evenementFile = File('$path/evenement.json');
    final anniversaireFile = File('$path/anniversaire.json');
    final agendaFile = File('$path/agenda.json');

    String jsonString = jsonEncode(BDD.evenement);
    await evenementFile.writeAsString(jsonString, mode: FileMode.write);

    jsonString = jsonEncode(BDD.anniversaire);
    await anniversaireFile.writeAsString(jsonString, mode: FileMode.write);

    jsonString = jsonEncode(BDD.agenda);
    await agendaFile.writeAsString(jsonString, mode: FileMode.write);
  }

  static Future<void> load() async {
    final path = await getFilePath();

    final evenementFile = File('$path/evenement.json');
    final anniversaireFile = File('$path/anniversaire.json');
    final agendaFile = File('$path/agenda.json');

    //un evenement = id -> date debut, date fin, heure debut, heure fin, lieu, titre (activite + personnes), description
    //anniversaire = jour -> une liste de personne = nom, annee naissance, detail
    //agenda = un jour associé a une liste d'id d'evenement


    //await evenementFile.writeAsString("{}", mode: FileMode.write);
    //await anniversaireFile.writeAsString("{}", mode: FileMode.write);
    //await agendaFile.writeAsString("{}", mode: FileMode.write);


    String contenu;
    if (await evenementFile.exists()) {
      contenu = await evenementFile.readAsString();
    }
    else{
      await evenementFile.writeAsString("{}", mode: FileMode.write);
      contenu = "{}";
    }
    BDD.evenement = jsonDecode(contenu);

    if (await anniversaireFile.exists()) {
      contenu = await anniversaireFile.readAsString();
    }
    else{
      await anniversaireFile.writeAsString("{}", mode: FileMode.write);
      contenu = "{}";
    }
    BDD.anniversaire = jsonDecode(contenu);

    if (await agendaFile.exists()) {
      contenu = await agendaFile.readAsString();
    }
    else{
      await agendaFile.writeAsString("{}", mode: FileMode.write);
      contenu = "{}";
    }
    BDD.agenda = jsonDecode(contenu);
  }

  static Future<File?> getExportFile() async{
    bool permissionAccorde = await Permission.manageExternalStorage.request().isGranted;
    if (!permissionAccorde){
      openAppSettings();
      return null;
    }

    String directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
    final File file = File('$directory/evenementAgenda.json');

    return file;
  }

  static Future<bool> export() async {
    File? file = await getExportFile();
    if (file == null){
      return false;
    }

    Map<String, dynamic> dataAgenda = {
      "anniversaire" : BDD.anniversaire,
      "evenement" : BDD.evenement,
      "agenda" : BDD.agenda,
    };

    String jsonString = jsonEncode(dataAgenda);
    await file.writeAsString(jsonString, mode: FileMode.write);

    return true;
  }

  static Future<bool> import() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      return false;
    }

    String? path = result.files.first.path;
    if (path == null){
      return false;
    }

    String contenu = await File(path).readAsString();
    Map<String, dynamic> dataAgenda = jsonDecode(contenu);

    BDD.anniversaire = dataAgenda["anniversaire"];
    BDD.evenement = dataAgenda["evenement"];
    BDD.agenda = dataAgenda["agenda"];

    return true;
  }
}
