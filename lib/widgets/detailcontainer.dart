import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget{
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;

  const DetailContainer({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color:color,
        borderRadius: borderRadius,
        boxShadow: boxShadow ??
          [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: child,
    );
  }
}