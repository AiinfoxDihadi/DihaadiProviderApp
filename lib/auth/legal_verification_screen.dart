import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:handyman_provider_flutter/auth/finishing_screen.dart';
import 'package:handyman_provider_flutter/auth/legal_verification_controller.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class LegalVerificationScreen extends StatelessWidget {
  const LegalVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LegalVerificationController lController = Get.put(LegalVerificationController());
    return Scaffold(
      appBar: appBarWidget(
        languages.legalVerification,
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness:
              getStatusBrightness(val: appStore.isDarkMode),
          statusBarColor: context.scaffoldBackgroundColor,
        ),
      ),
      body: GetBuilder(
        init: lController,
        builder: (controller) {
          return Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.image ? null :controller.takeSnapshot();
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: controller.image ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                      child: Image.file(controller.aadhaarCard!,fit: BoxFit.cover)):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/identity-card.png',scale: 10),
                      Text('Upload Aadhaar Card',style: secondaryTextStyle(size: 10))
                    ],
                  ),
                ),
              ),
              25.height,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.image ? null : controller.takeSnapshot();
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: controller.image ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(controller.aadhaarCard!,fit: BoxFit.cover)),
                      Positioned(top: 5,right:10,child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          controller.removeImage();
                        },
                          child: Icon(Icons.highlight_remove_sharp,color: Colors.white)))
                    ],
                  ):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/home.png',scale: 10),
                      Text('Upload Local address ',style: secondaryTextStyle(size: 10))
                    ],
                  ),
                ),
              ),
              25.height,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.image ? null :controller.takeSnapshot();
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: controller.image ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(controller.aadhaarCard!,fit: BoxFit.cover)):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/boy.png',scale: 12),
                      Text('Upload Selfie',style: secondaryTextStyle(size: 10))
                    ],
                  ),
                ),
              ),
              Spacer(),
              AppButton(
                text: 'Next',
                height: 40,
                color: primaryColor,
                textStyle: boldTextStyle(color: white),
                width: MediaQuery.sizeOf(context).width -
                    context.navigationBarHeight,
                onTap: () {
                  FinishingScreen().launch(context);
                },
              ),
              30.height
            ],
          ).paddingAll(20);
        },
      ),
    );
  }

  Column buildImageWidget(
      BuildContext context, String name, String image, Function? onTap) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          height: 50,
          decoration: BoxDecoration(
              color: cardColor, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: boldTextStyle()),
              Image.asset(image, scale: 3)
            ],
          ),
        ),
        20.height,
        AppButton(
          text: 'Upload',
          height: 40,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: MediaQuery.sizeOf(context).width - context.navigationBarHeight,
          onTap: onTap,
        ),
      ],
    );
  }
}
