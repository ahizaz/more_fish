import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/common_container.dart';
import '../../../common_widgets/common_text.dart';
import '../../../res/colors/colors.dart';
import '../controllers/fcr_calculator_controller.dart';

class FcrCalculatorView extends GetView<FcrCalculatorController> {
  const FcrCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        title: const Text('FCR Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CommonContainer(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    'Feed Conversion Ratio',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    'FCR = Total feed amount / Total weight gain',
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 14),
                  _numberInputField(
                    controller: controller.feedAmountController,
                    label: 'Total Feed Amount (kg)',
                  ),
                  const SizedBox(height: 12),
                  _numberInputField(
                    controller: controller.weightGainController,
                    label: 'Total Weight Gain (kg)',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.calculateFcr,
                          child: const Text('Calculate'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.clearAll,
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.validationMessage.value.isNotEmpty) {
                      return Text(
                        controller.validationMessage.value,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }

                    final value = controller.fcrResult.value;
                    if (value == null) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffe8f7ff),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffb2dbef)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText(
                            'Result',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 4),
                          CommonText(
                            'FCR = ${value.toStringAsFixed(2)}',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff0370c3),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
    );
  }
}
