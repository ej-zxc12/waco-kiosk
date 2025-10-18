import 'package:flutter/widgets.dart';

class Nav {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static final ValueNotifier<bool> idleEnabled = ValueNotifier<bool>(true);
}
