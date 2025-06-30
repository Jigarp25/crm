import 'package:crm/theme/colors.dart';
import 'package:flutter/material.dart';

Widget elevatedButton({
  required String label,
  required Future<void> Function() onPressed,
  Color ? backgroundColor ,
  Color ? textColor,
  borderRadius = 16,
  Size ? minimumSize,
  double fontSize = 20,
}) => ElevatedButton(
  onPressed: () async => await onPressed(),
  style: ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    minimumSize: minimumSize ?? Size(fontSize*6, fontSize*2.5),
  ),
  child: Text(
    label,
    style: TextStyle(color: Colors.white,fontSize:fontSize)
  )
);

Widget floatingButton({
  required Future<void> Function() onPressed,
  IconData icon = Icons.add_outlined,
  Color  backgroundColor = kPrimaryColor ,
  Color  iconColor = Colors.white,
  borderRadius = 16,
}) => FloatingActionButton(
    onPressed: () async => await onPressed(),
    backgroundColor: backgroundColor,
  child: Icon(icon,color: iconColor),
);

Widget textButton({
  required String label,
  required Future<void> Function() onPressed,
  Alignment alignment = Alignment.center,
  TextStyle? style,
}) {
  return Align(
    alignment: alignment,
    child: TextButton(onPressed: onPressed,
        child: Text(label, style: style, ),
    ),
  );
}
