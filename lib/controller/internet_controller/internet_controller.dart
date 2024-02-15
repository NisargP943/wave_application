import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetController {
  StreamSubscription? connectivity;
  var message = "".obs;

  void checkConnectivity(void Function()? callBack, noInternetCallBack) {
    connectivity = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        callBack ?? () {};
      } else {
        noInternetCallBack ?? () {};
      }
    });
  }

  void cancelConnectivity() {
    connectivity?.cancel();
  }
}
