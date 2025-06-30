import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Communication{

  static Future<void> makePhoneCall(BuildContext context, String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showError(context, 'Could not launch phone app');
    }
  }

  static Future<void> sendEmail(BuildContext context, String email) async {
    if (email == 'Not Available' || email.isEmpty) {
      _showError(context, 'Email address not available');
      return;
    }
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showError(context, 'Could not launch mail app');
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
