import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wave_app/model/customer_data.dart';
import 'package:wave_app/ui/home/order_details_page.dart';
import 'package:wave_app/ui/welcome/splash_screen.dart';

Box? customerDB, locationDB, nameDB, totalServiceCostDB, serviceBookingTime;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerDataAdapter());
  customerDB = await Hive.openBox<CustomerData>("customerDataBox");
  locationDB = await Hive.openBox("locationBox");
  serviceBookingTime = await Hive.openBox("serviceBox");
  nameDB = await Hive.openBox("nameBox");
  totalServiceCostDB = await Hive.openBox("priceBox");
  if (customerDB?.get("isLogin") == null) {
    customerDB?.put("isLogin", CustomerData(isLogin: false));
  }
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wave Tech Services',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
