import 'package:flutter/material.dart';

class Calendrier extends StatefulWidget {
  const Calendrier({super.key});

  @override
  State<Calendrier> createState() => _Calendrier();
}

class _Calendrier extends State<Calendrier> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text("calendrier"),
    );
  }

}