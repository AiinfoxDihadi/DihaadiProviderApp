import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/auth/forgot_password_dialog.dart';
import 'package:handyman_provider_flutter/auth/sign_up_screen.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/selected_item_widget.dart';
import 'package:handyman_provider_flutter/handyman/handyman_dashboard_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/provider/provider_dashboard_screen.dart';
import 'package:handyman_provider_flutter/store/auth_store.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/validators.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/utils/otp_text_field.dart' as OTP;

import '../networks/rest_apis.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //-------------------------------- Variables -------------------------------//

  /// TextEditing controller
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  /// FocusNodes
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  /// FormKey
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// AutoValidate mode
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  bool isRemember = getBoolAsync(IS_REMEMBERED);
  AuthStore authstore = AuthStore();

  @override
  void initState() {
    super.initState();
    // init();
  }

  @override
  void dispose() {
    super.dispose();
    emailCont.dispose();
    passwordCont.dispose();
    passwordFocus.dispose();
    emailFocus.dispose();
  }

  void init() async {
    if (await isIqonicProduct) {
      emailCont.text = getStringAsync(USER_EMAIL);
      passwordCont.text = getStringAsync(USER_PASSWORD);
      setState(() {});
    }
  }

  //------------------------------------ UI ----------------------------------//

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Observer(
          builder: (BuildContext context) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
                    child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppBar().preferredSize.height),
                            // Hello again with Welcoome text
                            20.height,
                            _buildHelloAgainWithWelcomeText(),

                            AutofillGroup(
                              onDisposeAction: AutofillContextAction.commit,
                              child: Column(
                                children: [
                                  // Enter email text field.
                                  AppTextField(
                                    textStyle: secondaryTextStyle(
                                        color: authstore.isOTPVisible
                                            ? Color(0xffC6C6C6)
                                            : textSecondaryColorGlobal),
                                    textFieldType: TextFieldType.PHONE,
                                    controller: emailCont,
                                    focus: emailFocus,
                                    validator: Validator.phoneNumberValidate,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    readOnly: authstore.isOTPVisible == false ? false : true,
                                    errorThisFieldRequired: languages.hintRequired,
                                    decoration: inputDecoration(context, hint: languages.phone),
                                    suffix: authstore.isOTPVisible
                                        ? Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Observer(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              print('helllllllllllllllo');
                                              authstore.toggleVisibility();
                                            },
                                            child: Text(
                                              'Edit',
                                              style: primaryTextStyle(
                                                  color: primaryColor),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                        : ic_phone.iconImage(size: 5).paddingAll(16),
                                  ),
                                  12.height,
                                  // Enter password text field
                                  // AppTextField(
                                  //   textFieldType: TextFieldType.PASSWORD,
                                  //   controller: passwordCont,
                                  //   focus: passwordFocus,
                                  //   errorThisFieldRequired: languages.hintRequired,
                                  //   suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                                  //   suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                                  //   errorMinimumPasswordLength: "${languages.errorPasswordLength} $passwordLengthGlobal",
                                  //   decoration: inputDecoration(context, hint: languages.hintPassword),
                                  //   onFieldSubmitted: (s) {
                                  //     _handleLogin();
                                  //   },
                                  // ),
                                  Visibility(
                                      visible: authstore.isOTPVisible,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          10.height,
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text('OTP',
                                                style: boldTextStyle(size: 20)),
                                          ),
                                          15.height,
                                          Center(
                                            child: OTP.OTPTextField(
                                              cursorColor: Color(0xffE9ECEF),
                                              onCompleted: (pin) {
                                                passwordCont.text = pin;
                                              },
                                            ).fit(),
                                          ),
                                          15.height,
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0,bottom: 15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "didn’t Receive an otp? "
                                                      .toUpperCase(),
                                                  style: boldTextStyle(),
                                                ),
                                                GestureDetector(
                                                  onTap : () {
                                                    authstore.canResend ? authstore.startTimer() : null;
                                                  },
                                                  child: Text(
                                                    authstore.canResend ?  " Resend otp ".toUpperCase() : " ${authstore.remainingTime.toString()}",
                                                    style: boldTextStyle(
                                                        size: authstore.canResend ? 15 : 22,
                                                        color: primaryColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ))

                                ],
                              ),
                            ),
                            // _buildForgotRememberWidget(),
                            authstore.isOTPVisible ? 20.height: SizedBox.shrink(),
                            _buildButtonWidget(),
                            13.height,
                            // SnapHelperWidget<bool>(
                            //   future: isIqonicProduct,
                            //   onSuccess: (data) {
                            //     if (data) {
                            //       return UserDemoModeScreen(
                            //         onChanged: (email, password) {
                            //           if (email.isNotEmpty && password.isNotEmpty) {
                            //             emailCont.text = email;
                            //             passwordCont.text = password;
                            //           } else {
                            //             emailCont.clear();
                            //             passwordCont.clear();
                            //           }
                            //         },
                            //       );
                            //     }
                            //     return Offstage();
                            //   },
                            // ),
                          ],
                        )
                  )
                ),
                LoaderWidget().center().visible(appStore.isLoading)]
            );
                      },
                    ),
                  ),
                );

  }

  //region Widgets
  Widget _buildHelloAgainWithWelcomeText() {
    return Column(
      children: [
        32.height,
        Text(languages.lblLoginTitle, style: boldTextStyle(size: 18)).center(),
        16.height,
        Text(
          authstore.isOTPVisible ? 'Verify Login': languages.lblLoginSubtitle,
          style: secondaryTextStyle(size: 14),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 32).center(),
        64.height,
      ],
    );
  }

  Widget _buildForgotRememberWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                2.width,
                SelectedItemWidget(isSelected: isRemember).onTap(() async {
                  await setValue(IS_REMEMBERED, isRemember);
                  isRemember = !isRemember;
                  setState(() {});
                }),
                TextButton(
                  onPressed: () async {
                    await setValue(IS_REMEMBERED, isRemember);
                    isRemember = !isRemember;
                    setState(() {});
                  },
                  child: Text(languages.rememberMe, style: secondaryTextStyle()),
                ),
              ],
            ),
            TextButton(
              child: Text(
                languages.forgotPassword,
                style: boldTextStyle(color: primaryColor, fontStyle: FontStyle.italic),
                textAlign: TextAlign.right,
              ),
              onPressed: () {
                showInDialog(
                  context,
                  contentPadding: EdgeInsets.zero,
                  builder: (_) => ForgotPasswordScreen(),
                );
              },
            ).flexible()
          ],
        ),
        32.height,
      ],
    );
  }

  Widget _buildButtonWidget() {
    return Column(
      children: [
        AppButton(
          text: languages.signIn,
          height: 40,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: authstore.isOTPVisible
              ? () {
            if (otp.trim() == passwordCont.text.trim()) {
              _handleLogin();
            } else {
              toast('enter correct OTP',gravity: ToastGravity.TOP);
            }
          } : () {
                handleOtp();
          },
        ),
        12.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(languages.doNotHaveAccount, style: secondaryTextStyle()),
            TextButton(
              onPressed: () {
                SignUpScreen().launch(context);
              },
              child: Text(
                languages.signUp,
                style: boldTextStyle(
                  color: primaryColor,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  //endregion

  //region Methods
  void _handleLogin() {
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _handleLoginUsers();
    }
  }
  String otp = '';

  int fourDigit() {
    final Random random = Random();
    return 1000 + random.nextInt(9000);
  }

  Future<void> handleOtp() async {
    appStore.setLoading(true);
    final Dio dio = Dio();
    final String apiKey = 'Ssvpd7EcZ2LVAkjhemDwKaBW8rG4nzQU6Ogbt5xH0FITM9oPqym6CPLFA8KBanTtO7xvrwz5S2pRqhcI';
    final String url = 'https://www.fast2sms.com/dev/bulkV2';
    otp = fourDigit().toString();
    final Map<String, dynamic> queryParameters = {
      'authorization': apiKey,
      'route': 'dlt',
      'sender_id': 'NABOTP',
      'message': '171269',
      'variables_values': int.parse(otp),
      'flash': '0',
      'numbers': emailCont.text,
    };

    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        toast('Otp send Successfully');
        appStore.setLoading(false);
        authstore.toggleVisibility();
        authstore.startTimer();
      } else {
        print('Error: ${response.statusCode}');
        appStore.setLoading(false);
      }
    } catch (e) {
      print('Error fetching data: $e');
      toast('Something Went Wrong');
      appStore.setLoading(false);
    }
  }

  void _handleLoginUsers() async {
    hideKeyboard(context);
    Map<String, dynamic> request = {
      'email': 'demo@provider.com',
      'password': '12345678',
    };

    appStore.setLoading(true);
    try {
      UserData user = await loginUser(request);

      if (user.status != 1) {
        appStore.setLoading(false);
        return toast(languages.pleaseContactYourAdmin);
      }

      await setValue(USER_PASSWORD, "12345678");
      await setValue(IS_REMEMBERED, isRemember);
      await saveUserData(user);
      authService.verifyFirebaseUser();

      redirectWidget(res: user);
    } catch (e) {
      appStore.setLoading(false);
      toast(e.toString());
    }
  }

  void redirectWidget({required UserData res}) async {
    appStore.setLoading(false);
    TextInput.finishAutofillContext();

    if (res.status.validate() == 1) {
      await appStore.setToken(res.apiToken.validate());
      appStore.setTester(res.email == DEFAULT_PROVIDER_EMAIL || res.email == DEFAULT_HANDYMAN_EMAIL);

      if (res.userType.validate().trim() == USER_TYPE_PROVIDER) {
        ProviderDashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else if (res.userType.validate().trim() == USER_TYPE_HANDYMAN) {
        HandymanDashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        toast(languages.cantLogin, print: true);
      }
    } else {
      toast(languages.lblWaitForAcceptReq);
    }
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}
