import 'package:flutter/material.dart';

class InterestButtonLarge extends StatefulWidget {
  final String interest;

  const InterestButtonLarge({
    super.key,
    required this.interest,
  });

  @override
  State<InterestButtonLarge> createState() => _InterestButtonLargeState();
}

class _InterestButtonLargeState extends State<InterestButtonLarge> {
  final bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
