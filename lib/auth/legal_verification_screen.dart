import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:handyman_provider_flutter/auth/finishing_screen.dart';
import 'package:handyman_provider_flutter/auth/legal_verification_controller.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
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
          return Stack(
            children: [
              Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.image ? null :controller.takeSnapshot('aadhaar');
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
                      controller.localImage ? null : controller.takeSnapshot('');
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: controller.localImage ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(controller.localAddress!,fit: BoxFit.cover)),
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
                      controller.selfieImage ? null :controller.selfieSnap();
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: controller.selfieImage ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(controller.selfie!,fit: BoxFit.cover)):
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
                      saveUser(context);
                    },
                  ),
                  30.height
                ],
              ).paddingAll(20),
              Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
            ],
          );
        },
      ),
    );
  }

  void saveUser(BuildContext context) async {
      hideKeyboard(context);
        appStore.setLoading(true);
        var request = {
          UserKeys.firstName: appStore.userFirstName,
          UserKeys.lastName: '',
          UserKeys.userName: appStore.userFirstName,
          UserKeys.userType: 'provider',
          UserKeys.contactNumber: '91-${appStore.userContactNumber}',
          UserKeys.email: '${appStore.userContactNumber}@gmail.com',
          UserKeys.password: '12345678',
          UserKeys.designation: 'Manager',
          UserKeys.status: 1,
          'age' : 18,
          'gender' : 'Male'
        };

        print(request);
        log(request);
        await registerUser(request).then((userRegisterData) async {
          appStore.setLoading(false);
          push(FinishingScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        }).catchError((e) {
          toast('Something went Wrong', print: true);
          appStore.setLoading(false);
        });
      }
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

