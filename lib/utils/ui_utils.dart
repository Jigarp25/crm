import 'package:flutter/material.dart';

SizedBox vSpace([double height = 16]) => SizedBox(height: height);
SizedBox hSpace([double width = 16]) => SizedBox(width: width);

inputDecoration({required String hint,String? label, IconData? prefixIcon, }) => InputDecoration(
  hintText: hint,
  labelText: label,
  prefixIcon: prefixIcon != null ?  Icon(prefixIcon): null,
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  )
);




