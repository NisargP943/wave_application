import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wave_app/model/customer_data.dart';
import 'package:wave_app/ui/welcome/splash_screen.dart';

Box? customerDB;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Hive Intialized
  await Hive.initFlutter();

  Hive.registerAdapter(CustomerDataAdapter());

  customerDB = await Hive.openBox<CustomerData>("customerDataBox");

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

  // This widget is the root of your application.
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
