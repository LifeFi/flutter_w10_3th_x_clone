import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(microseconds: 300),
            opacity: isSelected ? 1 : 0.6,
            child: FaIcon(
              isSelected ? selectedIcon : icon,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
