import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FcrCalculatorController extends GetxController {
  final feedAmountController = TextEditingController();
  final weightGainController = TextEditingController();

  final fcrResult = RxnDouble();
  final validationMessage = ''.obs;

  void calculateFcr() {
    final feedAmount = double.tryParse(feedAmountController.text.trim());
    final weightGain = double.tryParse(weightGainController.text.trim());

    if (feedAmount == null || weightGain == null) {
      validationMessage.value = 'Enter valid numeric values.';
      fcrResult.value = null;
      return;
    }

    if (feedAmount <= 0 || weightGain <= 0) {
      validationMessage.value = 'Values must be greater than zero.';
      fcrResult.value = null;
      return;
    }

    validationMessage.value = '';
    fcrResult.value = feedAmount / weightGain;
  }

  void clearAll() {
    feedAmountController.clear();
    weightGainController.clear();
    validationMessage.value = '';
    fcrResult.value = null;
  }

  @override
  void onClose() {
    feedAmountController.dispose();
    weightGainController.dispose();
    super.onClose();
  }
}
