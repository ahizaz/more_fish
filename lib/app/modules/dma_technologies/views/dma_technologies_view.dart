// app/modules/dma_technologies/views/dma_technologies_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../service/local_storage.dart';

class DmaTechnologiesView extends StatelessWidget {
  const DmaTechnologiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffebffff),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      ),
      body: DmaTechnologiesGrid(),
    );
  }
}

/// The main DMA Technologies grid content.
///
/// Extracted so we can reuse it inside a bottom-nav shell (DMA + Social).
class DmaTechnologiesGrid extends StatelessWidget {
  const DmaTechnologiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xffebffff);
    const tileBg = Color(0xffd7f2ee);
void openPoultry() {
  Get.toNamed(Routes.POULTRY_INDEX);
}

    final tiles = <_DmaTileData>[
      _DmaTileData(
        title: 'More Fish',
        asset: 'assets/icons/dma_more_fish.png',
        onTap: () => Get.toNamed(Routes.INDEX),
      ),
       _DmaTileData(
  title: 'Poultry Care',
  asset: 'assets/icons/dma_poultry_pulse.png',
  onTap: openPoultry,
),
      _DmaTileData(
        title: 'Cattle Care',
        asset: 'assets/icons/dma_cattle_care.png',
        onTap: () => Get.toNamed(Routes.CATTLE_INDEX),
      ),
      _DmaTileData(
        title: 'Tex Care',
        asset: 'assets/icons/dma_textile.png',
        onTap: () => Get.toNamed(
          Routes.COMING_SOON,
          arguments: const {'title': 'Tex Care'},
        ),
      ),
      _DmaTileData(
        title: 'Food & Beverage Care',
        asset: 'assets/icons/dma_food_beverage.png',
        onTap: () => Get.toNamed(
          Routes.COMING_SOON,
          arguments: const {'title': 'Food & Beverage'},
        ),
      ),
      _DmaTileData(
        title: 'Pharma Care',
        asset: 'assets/icons/dma_pharmaceutical.png',
        onTap: () => Get.toNamed(
          Routes.COMING_SOON,
          arguments: const {'title': 'Pharma Care'},
        ),
      ),
      _DmaTileData(
        title: 'Air Care',
        asset: 'assets/icons/clean_air.png',
        onTap: () => Get.toNamed(Routes.CLEAN_AIR_INDEX),
      ),
      _DmaTileData(
        title: 'Crop Care',
        asset: 'assets/icons/dma_more_crops.png',
        onTap: () => Get.toNamed(
          Routes.COMING_SOON,
          arguments: const {'title': 'Crop Care'},
        ),
      ),
    ];

    return Container(
      color: bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: tileBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.black12),
                ),
                child: const Center(
                  child: Text(
                    'DMA Technologies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    itemCount: tiles.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.12,
                        ),
                    itemBuilder: (_, i) =>
                        _ServiceTile(data: tiles[i], bg: tileBg),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DmaTileData {
  final String title;
  final String asset;
  final VoidCallback onTap;
  const _DmaTileData({
    required this.title,
    required this.asset,
    required this.onTap,
  });
}

class _ServiceTile extends StatelessWidget {
  final _DmaTileData data;
  final Color bg;
  const _ServiceTile({required this.data, required this.bg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 76,
                child: Center(
                  child: Image.asset(data.asset, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
