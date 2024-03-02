import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

class HelpdeskPage extends StatefulWidget {
  const HelpdeskPage({super.key});

  @override
  State<HelpdeskPage> createState() => _HelpdeskPageState();
}

class _HelpdeskPageState extends State<HelpdeskPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomImageView(
          onTap: () {
            _launchURL("https://www.wavetechservices.in");
          },
          imagePath: Assets.imagesHelpdesk,
        ),
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
