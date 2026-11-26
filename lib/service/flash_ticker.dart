import 'dart:async';

import 'package:flutter/foundation.dart';

/// One shared 1-second clock for every flash-sale countdown.
///
/// The underlying [Timer] only runs while at least one widget is listening,
/// so 100+ countdowns cost a single timer and it stops when none are on screen.
class FlashTicker extends ChangeNotifier {
  FlashTicker._();
  static final FlashTicker instance = FlashTicker._();

  Timer? _timer;
  int _listeners = 0;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (++_listeners == 1) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => notifyListeners());
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (--_listeners <= 0) {
      _listeners = 0;
      _timer?.cancel();
      _timer = null;
    }
  }
}
