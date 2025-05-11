import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class DateTimePicker extends StatefulWidget {
  final void Function(DateTime) onTimeChanged;
  final DateTime? selectedDate;

  const DateTimePicker({super.key, required this.onTimeChanged, this.selectedDate});

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late int selectedHour;
  late int selectedMinute;

  late int selectedDate;
  late DateTime selectedDay;
  int dateRange = 365;

  List<int> minutes = List.generate(4, (index) => index * 15);
  List<int> hours = List.generate(24, (index) => index);
  late List<DateTime> jour;

  @override
  void initState() {
    super.initState();

    selectedDate = 365;
    selectedHour = widget.selectedDate == null ? DateTime.now().hour : widget.selectedDate!.hour;
    selectedMinute = widget.selectedDate == null ? DateTime.now().minute ~/ 15 * 15 : widget.selectedDate!.minute ~/ 15 * 15;

    jour = [];

    DateTime milieu = widget.selectedDate ?? DateTime.now();
    DateTime iDate = milieu.subtract(Duration(days: dateRange));

    for (int index = 0; index < dateRange*2+1; index++){
      jour.add(iDate);
      iDate = iDate.add(Duration(days: 1));
    }

    selectedDay = DateTime(jour[selectedDate].year, jour[selectedDate].month, jour[selectedDate].day, selectedHour, selectedMinute);
  }

  String datetimeToString(DateTime day){
    String dateString = dateFormatJourMoisABR.format(day);
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
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
            widget.onTimeChanged(selectedDay);
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
            width: 150,
            height: 150,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedDate),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedDate = index;
                  selectedDay = DateTime(jour[selectedDate].year, jour[selectedDate].month, jour[selectedDate].day, selectedHour, selectedMinute);
                });
              },
              children: jour.map((d) => Text(datetimeToString(d))).toList(),
            )
        ),
        SizedBox(width: 20,),
        SizedBox(
            width: 100,
            height: 150,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedHour),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = hours[index % hours.length];
                  selectedDay = DateTime(jour[selectedDate].year, jour[selectedDate].month, jour[selectedDate].day, selectedHour, selectedMinute);
                });
              },
              looping: true,
              children: hours.map((h) => Text(h.toString().padLeft(2, '0'))).toList(),
            )
        ),
        Text(":", style: TextStyle(fontSize: 24)),
        SizedBox(
            width: 100,
            height: 150,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedMinute ~/ 15),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = minutes[index % minutes.length];
                  selectedDay = DateTime(jour[selectedDate].year, jour[selectedDate].month, jour[selectedDate].day, selectedHour, selectedMinute);
                });
              },
              looping: true,
              children: minutes.map((m) => Text(m.toString().padLeft(2, '0'))).toList(),
            )
        ),
      ],
    );
  }
}
