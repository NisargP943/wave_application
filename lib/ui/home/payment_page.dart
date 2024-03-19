import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/my_cart_model.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, this.servicePaymentModel});

  final ServicePaymentModel? servicePaymentModel;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'http://wavetechservices.in/ccavenue/cpay/customerpay.php?cname=${widget.servicePaymentModel?.name}&bid=${widget.servicePaymentModel?.bid}&amts=${widget.servicePaymentModel?.amts}&addr=${widget.servicePaymentModel?.addr}&pincode=${widget.servicePaymentModel?.pincode}&mobile=${widget.servicePaymentModel?.mobile}&bservice=${widget.servicePaymentModel?.bservice}'));
  }

  @override
  void dispose() {
    controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: () {
            Get.back();
            pageNotifier.value = 0;
          },
          child: Image.asset(
            Assets.imagesBackIcon,
            scale: 1.8,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
