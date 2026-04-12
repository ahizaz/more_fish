import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FishDiseaseDetectorController extends GetxController {
  static const String _endpoint =
      'https://kilt-absolve-cornea.ngrok-free.dev/devices/fish-disease/detect/';
  static const String _token = '21067c389d5d27d6ecfd22dc13e0ccb792714ad6';

  final ImagePicker _picker = ImagePicker();

  final Rxn<XFile> selectedImage = Rxn<XFile>();
  final isLoading = false.obs;
  final disease = ''.obs;
  final confidencePercent = ''.obs;
  final errorMessage = ''.obs;

  Future<void> pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    _setSelectedImage(file);
  }

  Future<void> pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    _setSelectedImage(file);
  }

  Future<void> detectDisease() async {
    final image = selectedImage.value;
    if (image == null) {
      errorMessage.value = 'Please select an image first.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    disease.value = '';
    confidencePercent.value = '';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_endpoint));
      request.headers['Authorization'] = 'Bearer $_token';
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        disease.value = (data?['disease'] ?? '').toString();
        confidencePercent.value = (data?['confidence_percent'] ?? '')
            .toString();

        if (disease.value.isEmpty) {
          errorMessage.value = 'Disease not found in response.';
        }
      } else {
        errorMessage.value = 'Request failed (${streamedResponse.statusCode}).';
      }
    } catch (_) {
      errorMessage.value = 'Failed to detect disease. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearSelection() {
    selectedImage.value = null;
    disease.value = '';
    confidencePercent.value = '';
    errorMessage.value = '';
  }

  void _setSelectedImage(XFile file) {
    selectedImage.value = file;
    disease.value = '';
    confidencePercent.value = '';
    errorMessage.value = '';
  }
}
