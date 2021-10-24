import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryService extends ChangeNotifier {
  Battery battery = Battery();
  static int level = 100;

  BatteryService() {
    battery.onBatteryStateChanged.listen((BatteryState state) {
      level = state.index;
      notifyListeners();
    });
  }

  initialCheck() async {
    level = await battery.batteryLevel;
    notifyListeners();
  }

  static bool isHealthy() {
    return (level > 30);
  }
}
