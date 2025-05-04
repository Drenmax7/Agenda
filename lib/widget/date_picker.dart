import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final void Function(DateTime) onTimeChanged;
  final DateTime? selectedDate;

  const DatePicker({super.key, required this.onTimeChanged, this.selectedDate});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {

  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  late DateTime selectedDate;

  late List<int> jour;
  List<String> mois = [
    'janvier',
    'fevrier',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'aout',
    'septembre',
    'octobre',
    'novembre',
    'decembre'
  ];

  static const startYear = 1900;
  late List<int> annee = List.generate(DateTime.now().year-startYear+1, (index) {
    return index + startYear;
  });

  void setListeJour(){
    DateTime iDate = DateTime(selectedYear, selectedMonth, 1);
    jour = [];
    while (iDate.month == selectedMonth){
      jour.add(iDate.day);
      iDate = iDate.add(Duration(days: 1));
    }
  }

  @override
  void initState() {
    super.initState();

    selectedDay = widget.selectedDate == null ? 1 : widget.selectedDate!.day;
    selectedMonth = widget.selectedDate == null ? 1 : widget.selectedDate!.month;
    selectedYear = widget.selectedDate == null ? 2000 : widget.selectedDate!.year;

    selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);

    setListeJour();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buttons(),
        picker(),
      ],
    );
  }

  Widget buttons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Annuler',
            style: TextStyle(
              fontSize: 22,
              color: Colors.blue,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onTimeChanged(selectedDate);
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: 22,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget picker(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 100,
            height: 150,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedDay = index+1;
                  selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                });
              },
              looping: true,
              children: jour.map((d) => Text(d.toString().padLeft(2, '0'))).toList(),
            )
        ),
        SizedBox(width: 20),
        SizedBox(
            width: 150,
            height: 150,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMonth = index +1;
                  setListeJour();
                  selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                });
              },
              looping: true,
              children: mois.map((m) => Text(m)).toList(),
            )
        ),
        SizedBox(width: 20),
        SizedBox(
            width: 100,
            height: 150,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedYear - startYear),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedYear = index + startYear;
                  setListeJour();
                  selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                });
              },
              looping: true,
              children: annee.map((a) => Text(a.toString().padLeft(4, '0'))).toList(),
            )
        ),
      ],
    );
  }
}
