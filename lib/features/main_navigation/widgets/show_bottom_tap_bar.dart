import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showBottomTabBarProvider = StateProvider<bool>((ref) => true);

final showBottomTabBar = ValueNotifier(true);
