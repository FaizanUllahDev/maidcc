//import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:maidcc/core/utils/utils.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  NetworkInfoImpl();

  @override
  Future<bool> get isConnected => checkConnection();

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    Utils.debug("Checking connectivity :  $connectivityResult ");
    // switch
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.bluetooth)) {
      return true;
    }
    return false;
  }
}
