import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class FinishingScreen extends StatelessWidget {
  const FinishingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Text(
            'Thank you \nOnce your profile is Approved \nWe will contact you.',
            style: boldTextStyle(size: 24),textAlign: TextAlign.center),
          Spacer(),
          AppButton(
            text: languages.next,
            height: 40,
            color: primaryColor,
            textStyle: boldTextStyle(color: white),
            width: MediaQuery.sizeOf(context).width - context.navigationBarHeight,
            onTap: () {
              SignInScreen().launch(context);
            },
          ),
          30.height,
        ],
      ).paddingAll(15),
    );
  }
}