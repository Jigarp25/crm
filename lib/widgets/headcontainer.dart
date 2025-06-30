import 'package:flutter/material.dart';
import 'package:crm/theme/colors.dart';
import 'package:crm/utils/ui_utils.dart';

class HeadContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? avatarText;
  final bool showAvatar;
  final Color backgroundColor;

  const HeadContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarText,
    this.showAvatar = false,
    this.backgroundColor = kSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      width: double.infinity,
      color: backgroundColor,
      child: showAvatar
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: kCircleColor,
            child: Text(
              avatarText != null ? avatarText![0].toUpperCase() : '',
              style: const TextStyle(
                fontSize: 40,
                color: kIconTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  vSpace(4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      )
        : SizedBox(
        height: 100,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                vSpace(8),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ],
          ),
        )
      )
    );
  }
}
