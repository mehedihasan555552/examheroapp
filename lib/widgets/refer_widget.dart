import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

Widget referWidget({required AuthController authController}) {
  return Column(
    children: [
      const SizedBox(
        height: 16,
      ),
      Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3EC),
        ),
        child: const Center(
          child: Text(
            'Refer Code',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: const Border(
            top: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: Color(0xFFefd1bf),
            ),
            bottom: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: Color(0xFFefd1bf),
            ),
            left: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: Color(0xFFefd1bf),
            ),
            right: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: Color(0xFFefd1bf),
            ),
          ),
        ),
        child: Center(
          child: Text(
            authController.profile.value.referral_code!,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              String referCode = authController.profile.value.referral_code!;
              FlutterClipboard.copy(referCode).then((value) {
                Get.snackbar(
                  'Copied',
                  referCode,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 2),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.white,
              side: const BorderSide(
                color: Colors.orangeAccent,
                width: 2,
              ),
              fixedSize: const Size(120, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Copy',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              //  Share app link
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              String packageName = packageInfo.packageName;

              String referCode = authController.profile.value.referral_code!;
              String playStoreAppUrl =
                  'https://play.google.com/store/apps/details?id=$packageName';
              String text =
                  'Name: ${authController.profile.value.full_name}\nRefer code: $referCode \n\nMission DMC: $playStoreAppUrl';

              Share.share(text);
              // try {
              //   launch("market://details?id=" + appPackageName);
              // } on PlatformException catch(e) {
              //   launch("https://play.google.com/store/apps/details?id=" + appPackageName);
              // } finally {
              //   launch("https://play.google.com/store/apps/details?id=" + appPackageName);
              // }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.white,
              side: const BorderSide(
                color: Colors.orangeAccent,
                width: 2,
              ),
              fixedSize: const Size(120, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Share',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 16,
      ),
    ],
  );
}
