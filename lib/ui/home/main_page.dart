import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/helpdesk_page.dart';
import 'package:wave_app/ui/home/home_page.dart';
import 'package:wave_app/ui/home/my_orders_page.dart';
import 'package:wave_app/ui/home/wave_cart_page.dart';

ValueNotifier<int> pageNotifier = ValueNotifier(0);

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.customerAuthResponseModel});

  final CustomerAuthResponseModel? customerAuthResponseModel;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
    );
    pages = [
      HomePage(customerAuthResponseModel: widget.customerAuthResponseModel),
      const MyOrderPage(),
      const WaveCartPage(),
      const HelpdeskPage()
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: pageNotifier,
        builder: (context, value, child) => pages[value],
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.3)),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(16),
          right: Radius.circular(16),
        ).r,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(15),
          right: Radius.circular(15),
        ).r,
        child: ValueListenableBuilder(
          valueListenable: pageNotifier,
          builder: (context, value, child) => BottomNavigationBar(
            elevation: 0,
            selectedItemColor: const Color(0xffDB3022),
            onTap: (val) {
              pageNotifier.value = val;
            },
            currentIndex: value,
            selectedLabelStyle: CustomTextStyles.bodySmall11,
            unselectedLabelStyle: CustomTextStyles.bodySmall11_1,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  color: value == 0 ? const Color(0xffDB3022) : null,
                  height: 45.h,
                  width: 30.w,
                  Assets.imagesHome,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  color: value == 1 ? const Color(0xffDB3022) : null,
                  height: 45.h,
                  width: 30.w,
                  Assets.imagesShoppingCart,
                ),
                label: "My Orders",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  color: value == 2 ? const Color(0xffDB3022) : null,
                  height: 45.h,
                  width: 30.w,
                  Assets.imagesShopping,
                ),
                label: "Orders",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  color: value == 3 ? const Color(0xffDB3022) : null,
                  height: 45.h,
                  width: 30.w,
                  Assets.imagesProfile,
                ),
                label: "Helpdesk",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
