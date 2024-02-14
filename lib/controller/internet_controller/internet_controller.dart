import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  StreamSubscription? connectivity;
  var message = "".obs;

  @override
  void onInit() {
    super.onInit();
    connectivity = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        message.value = "Internet Connection Gained";
      } else {
        message.value = "Internet Connection Lost";
      }
    });
  }
}
