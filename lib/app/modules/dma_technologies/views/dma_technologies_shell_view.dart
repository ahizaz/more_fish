import 'package:flutter/material.dart';

import '../../social/views/social_tab_view.dart';
import 'dma_technologies_view.dart';

/// DMA Technologies page shell with bottom navigation.
///
/// Tabs:
/// 1) DMA (the existing grid)
/// 2) Social (Firebase Auth)
class DmaTechnologiesShellView extends StatefulWidget {
  const DmaTechnologiesShellView({super.key});

  @override
  State<DmaTechnologiesShellView> createState() =>
      _DmaTechnologiesShellViewState();
}

class _DmaTechnologiesShellViewState extends State<DmaTechnologiesShellView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DmaTechnologiesGrid(),
      const SocialTabView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffebffff),
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'DMA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Social',
          ),
        ],
      ),
    );
  }
}
