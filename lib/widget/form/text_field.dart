import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String label,
    {int maxLines = 1, TextCapitalization mode = TextCapitalization.sentences,
    FocusNode? focus}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      focusNode: focus,
      textCapitalization: mode,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: null,
    ),
  );
}