import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/customer_data.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

import '../ui/auth/login_page.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage(Assets.imagesLogo2), scale: 3),
            ),
            child: Container(),
          ),
          ListTile(
            leading: CustomImageView(
              imagePath: Assets.imagesGlobe,
              height: 28.r,
              width: 28.r,
            ),
            title: const Text('About Wave'),
            onTap: () => {_launchURL("https://www.wavetechservices.in")},
          ),
          ListTile(
            leading: CustomImageView(
              imagePath: Assets.imagesTerms,
              height: 28.r,
              width: 28.r,
            ),
            title: const Text('Terms and Conditions'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: CustomImageView(
              imagePath: Assets.imagesFunds,
              height: 28.r,
              width: 28.r,
            ),
            title: const Text('Refunds and Cancellation'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: CustomImageView(
              imagePath: Assets.imagesOrders,
              height: 28.r,
              width: 28.r,
            ),
            title: const Text('My Order'),
            onTap: () => {},
          ),
          ListTile(
            leading: CustomImageView(
              imagePath: Assets.imagesHelp,
              height: 28.r,
              width: 28.r,
            ),
            title: const Text('Wave Helpdesk'),
            onTap: () => {_launchURL("https://www.wavetechservices.in")},
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              size: 28,
              color: Colors.black,
            ),
            title: const Text('Logout'),
            onTap: () {
              Get.off(const LoginOneScreen());
              customerDB?.put("isLogin", CustomerData(isLogin: false));
            },
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
