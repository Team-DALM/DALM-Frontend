import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/dalm_colors.dart';
import '../../app/theme/dalm_typography.dart';

class DalmBottomNavigationBar extends StatelessWidget {
  const DalmBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  }) : assert(
         currentIndex >= 0 && currentIndex < _items.length,
         'currentIndex가 바텀 네비게이션 범위를 벗어났습니다.',
       );

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_DalmBottomNavigationItem> _items = [
    _DalmBottomNavigationItem(
      label: '오늘',
      assetPath: 'assets/icons/nav_home.svg',
    ),
    _DalmBottomNavigationItem(
      label: '순간들',
      assetPath: 'assets/icons/nav_moments.svg',
    ),
    _DalmBottomNavigationItem(
      label: '엽서함',
      assetPath: 'assets/icons/nav_postcards.svg',
    ),
    _DalmBottomNavigationItem(
      label: '나',
      assetPath: 'assets/icons/nav_profile.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DalmColors.navigationBackground,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: DalmColors.border, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(children: List.generate(_items.length, _buildItem)),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = _items[index];
    final isSelected = currentIndex == index;

    final color = isSelected
        ? DalmColors.textPrimary
        : DalmColors.navigationInactive;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: item.label,
        child: InkWell(
          onTap: () => onTap(index),
          child: ExcludeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      item.assetPath,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.label,
                  style: DalmTypography.caption.copyWith(
                    color: color,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DalmBottomNavigationItem {
  const _DalmBottomNavigationItem({
    required this.label,
    required this.assetPath,
  });

  final String label;
  final String assetPath;
}
