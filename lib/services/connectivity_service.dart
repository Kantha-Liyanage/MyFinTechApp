import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ConnectivityService extends ChangeNotifier {
  // Create our public controller
  static ConnectivityResult connectivityResult = ConnectivityResult.none;

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t
      connectivityResult = result;
      notifyListeners();
    });
  }

  static bool isConnected() {
    return (connectivityResult != ConnectivityResult.none);
  }
}
