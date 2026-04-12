import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors/colors.dart';
import '../controllers/fish_disease_detector_controller.dart';

class FishDiseaseDetectorView extends GetView<FishDiseaseDetectorController> {
  const FishDiseaseDetectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        title: const Text('Fish Disease Detector'),
        backgroundColor: const Color(0xffd4fcfd),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: controller.selectedImage.value == null
                    ? const Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(controller.selectedImage.value!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.pickFromCamera,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.pickFromGallery,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.detectDisease,
                icon: const Icon(Icons.search),
                label: Text(
                  controller.isLoading.value
                      ? 'Detecting...'
                      : 'Detect Disease',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2f7d8b),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 18),
              if (controller.errorMessage.value.isNotEmpty)
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (controller.disease.value.isNotEmpty)
                Column(
                  children: [
                    Text(
                      controller.disease.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              if (controller.selectedImage.value != null)
                TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.clearSelection,
                  child: const Text('Clear'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
