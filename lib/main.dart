import 'package:agenda/pages/principale/annee.dart';
import 'package:agenda/pages/principale/evenement.dart';
import 'package:agenda/pages/principale/mois.dart';
import 'package:agenda/widget/information/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bdd/io_evenement.dart';

main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Agenda(),
    );
  }
}

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _Agenda();
}

class _Agenda extends State<Agenda> {
  final PageController controller = PageController(initialPage: 1);

  int pageActuelle = 1;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('fr_FR');
    chargerDonnees().then((_) {
      NotificationManager.initialize().then((_) {
        NotificationManager.sendAnniversary();
      });
    });
  }

  Future<void> chargerDonnees() async {
    await IOEvenement.load();

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: onglets(),
      body: dataLoaded ? pages() : Center(child: CircularProgressIndicator()),
    );
  }

  PageView pages() {
    return PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Annee(),
        Mois(),
        Evenement(),
      ],
    );
  }

  AppBar onglets() {
    List<String> nomOnglet = [
      "Année",
      "Mois",
      "Evénements",
    ];

    Map<int, FlexColumnWidth> columnWidth = {};
    for (int i = 0; i < nomOnglet.length; i++) {
      columnWidth[i] = FlexColumnWidth(nomOnglet[i].length.toDouble());
    }

    return AppBar(
      backgroundColor: Colors.deepPurple,
      title: Table(
        //columnWidths: columnWidth,
        children: [
          TableRow(
            children: List.generate(
                nomOnglet.length,
                    (index) {
                  Color textColor = Colors.grey.shade300;
                  if (pageActuelle == index) {
                    textColor = Colors.yellow;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        pageActuelle = index;
                        controller.jumpToPage(index);
                      });
                    },
                    child: Container(
                      height: 80,
                      color: pageActuelle == index ? Colors.deepPurple[700] : Colors.transparent,
                      child: Center(
                        child: Text(
                          nomOnglet[index],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}