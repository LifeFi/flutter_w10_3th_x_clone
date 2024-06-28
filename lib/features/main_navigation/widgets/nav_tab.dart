import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavTab extends ConsumerWidget {
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final Function onTap;

  const NavTab({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        // 컨텐츠(FaIcon) 영역뿐 아니라, 빈 공간까지도 터치 이벤트를 받도록 설정.
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: const Duration(microseconds: 300),
            opacity: isSelected ? 1 : 0.6,
            child: FaIcon(
              isSelected ? selectedIcon : icon,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
