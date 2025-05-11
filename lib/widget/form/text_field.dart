import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String label,
    {int maxLines = 1, TextCapitalization mode = TextCapitalization.sentences,
    FocusNode? focus, required BuildContext context}) {

  double maxWidth = MediaQuery.of(context).size.width - 32;
  final span = TextSpan(text: controller.text, style: null);
  final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
  tp.layout(maxWidth: maxWidth);
  int lineCount = (tp.size.height / tp.preferredLineHeight).ceil();

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      focusNode: focus,
      textCapitalization: mode,
      controller: controller,
      maxLines: lineCount,
      minLines: lineCount,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: null,
    ),
  );
}