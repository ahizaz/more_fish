import 'package:flutter/material.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.trim().isEmpty) {
      return _placeholder();
    }

    final assets = _mapUrlToLocalAssets(url!);
    if (assets != null && assets.isNotEmpty) {
      final chosen = _chooseAsset(url!, assets);
      return Image.asset(
        chosen,
        fit: fit,
        width: width,
        height: height,
      );
    }

    return Image.network(
      url!,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  List<String>? _mapUrlToLocalAssets(String url) {
    final s = url.toLowerCase();
    if (s.contains('temp') || s.contains('temperature')) {
      return [
        'assets/icons/poultry_temperature.png',
        'assets/icons/cattle_temperature.png',
      ];
    }
    if (s.contains('nh3') || s.contains('ammonia') || s.contains('/am') || s.contains('am-')) {
      return [
        'assets/icons/poultry_nh3.png',
        'assets/icons/clean_nh3.png',
        'assets/icons/cattle_nh3.png',
      ];
    }
    if (s.contains('ph')) {
      return [
        'assets/icons/water_quality_check.png',
      ];
    }
    if (s.contains('do') || s.contains('dissolved') || s.contains('o2') || s.contains('oxygen')) {
      return [
        'assets/icons/water_quality_check.png',
        'assets/icons/water_quality_check.png',
      ];
    }
    if (s.contains('salinity') || s.contains('sal')) {
      return [
        'assets/icons/water_quality_check.png',
      ];
    }
    if (s.contains('tds')) {
      return [
        'assets/icons/water_quality_check.png',
        'assets/icons/clean_co2.png',
      ];
    }
    if (s.contains('pm') || s.contains('pm25') || s.contains('pm10')) {
      return [
        'assets/icons/poultry_pm25.png',
        'assets/icons/poultry_pm10.png',
      ];
    }
    if (s.contains('co2') || s.contains('co')) {
      return [
        'assets/icons/poultry_co2.png',
        'assets/icons/clean_co2.png',
      ];
    }
    if (s.contains('humidity')) {
      return [
        'assets/icons/poultry_humidity.png',
      ];
    }
    if (s.contains('noise') || s.contains('sound')) {
      return [
        'assets/icons/poultry_noise.png',
      ];
    }
    return null;
  }

  String _chooseAsset(String url, List<String> assets) {
    final idx = url.hashCode.abs() % assets.length;
    return assets[idx];
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey.shade600,
      ),
    );
  }
}
