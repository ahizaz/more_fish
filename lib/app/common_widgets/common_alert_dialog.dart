import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common_text.dart';


class CommonAlertDialog extends StatelessWidget {
  final VoidCallback notNow;
  final VoidCallback login;

  const CommonAlertDialog({
    super.key,
    required this.notNow,
    required this.login,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CommonText(
        'login'.tr,
        color: Colors.green.shade700,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      content: CommonText(
        'please_login'.tr,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.blueGrey,
      ),
      actions: [
        TextButton(
          onPressed: notNow,
          child: Text(
            'not_now'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: login,
          child: Text(
            'login'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

