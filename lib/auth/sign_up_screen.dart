// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/selected_item_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/user_type_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart' as launch;

bool isNew = false;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //-------------------------------- Variables -------------------------------//

  /// TextEditing controller
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();

  /// FocusNodes
  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode designationFocus = FocusNode();

  String? selectedUserTypeValue;

  List<UserTypeData> userTypeList = [UserTypeData(name: languages.selectUserType, id: -1)];

  UserTypeData? selectedUserTypeData;

  bool isAcceptedTc = false;
  Country selectedCountry = defaultCountry();

  ValueNotifier _valueNotifier = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();

    fNameCont.dispose();
    lNameCont.dispose();
    emailCont.dispose();
    userNameCont.dispose();
    mobileCont.dispose();
    passwordCont.dispose();
    designationCont.dispose();

    fNameFocus.dispose();
    lNameFocus.dispose();
    emailFocus.dispose();
    userNameFocus.dispose();
    mobileFocus.dispose();
    userTypeFocus.dispose();
    typeFocus.dispose();
    passwordFocus.dispose();
    designationFocus.dispose();
  }

  //----------------------------------- UI -----------------------------------//

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBarWidget(
          "",
          elevation: 0,
          color: context.scaffoldBackgroundColor,
          systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: getStatusBrightness(val: appStore.isDarkMode),
            statusBarColor: context.scaffoldBackgroundColor,
          ),
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }

  //------------------------------ Helper Widgets-----------------------------//
  // Build hello user With Create Your Account for Better Experience text...
  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
          child: Image.asset(profile, height: 45, width: 45, color: white),
        ),
        16.height,
        Text(languages.lblSignupTitle, style: boldTextStyle(size: 18)),
        16.height,
        Text(
          languages.lblSignupSubtitle,
          style: secondaryTextStyle(size: 14),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 32),
        32.height,
      ],
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        // First name text field...
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintFirstNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Last name text field...
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: lNameCont,
          focus: lNameFocus,
          nextFocus: userNameFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintLastNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // User name test field...
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: userNameCont,
          focus: userNameFocus,
          nextFocus: emailFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintUserNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Email text field...
        AppTextField(
          textFieldType: TextFieldType.EMAIL_ENHANCED,
          controller: emailCont,
          focus: emailFocus,
          nextFocus: mobileFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintEmailAddressTxt),
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Country code ...
            Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _valueNotifier,
                  builder: (context, value, child) => Row(
                    children: [
                      Text(
                        "+${selectedCountry.phoneCode}",
                        style: primaryTextStyle(size: 12),
                      ).paddingOnly(left: 8),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ).paddingOnly(left: 8),
                ),
              ),
            ).onTap(() => changeCountry()),
            10.width,
            // Mobile number text field...
            AppTextField(
              textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
              controller: mobileCont,
              focus: mobileFocus,
              isValidationRequired: false,
              errorThisFieldRequired: languages.hintRequired,
              nextFocus: passwordFocus,
              decoration: inputDecoration(context, hint: '${languages.hintContactNumberTxt}').copyWith(
                hintText: '${languages.lblExample}: ${selectedCountry.example}',
                hintStyle: secondaryTextStyle(),
              ),
              maxLength: 15,
              suffix: calling.iconImage(size: 10).paddingAll(14),
            ).expand(),
          ],
        ),
        8.height,
        // Designation text field...
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: designationCont,
          isValidationRequired: false,
          focus: designationFocus,
          nextFocus: passwordFocus,
          decoration: inputDecoration(context, hint: languages.lblDesignation),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // User role text field...
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                child: Text(languages.provider, style: primaryTextStyle()),
                value: USER_TYPE_PROVIDER,
              ),
              DropdownMenuItem(
                child: Text(languages.handyman, style: primaryTextStyle()),
                value: USER_TYPE_HANDYMAN,
              ),
            ],
            focusNode: userTypeFocus,
            dropdownColor: context.cardColor,
            decoration: inputDecoration(context, hint: languages.userRole),
            value: selectedUserTypeValue,
            validator: (value) {
              if (value == null) return errorThisFieldRequired;
              return null;
            },
            onChanged: (c) {
              hideKeyboard(context);
              selectedUserTypeValue = c.validate();

              userTypeList.clear();
              selectedUserTypeData = null;

              getUserType(type: selectedUserTypeValue!).then((value) {
                userTypeList = value.userTypeData.validate();

                _valueNotifier.notifyListeners();
              }).catchError((e) {
                userTypeList = [UserTypeData(name: languages.selectUserType, id: -1)];
                log(e.toString());
              });
            },
          ),
        ),
        16.height,
        // Select user type text field...
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => DropdownButtonFormField<UserTypeData>(
            onChanged: (UserTypeData? val) {
              selectedUserTypeData = val;
              _valueNotifier.notifyListeners();
            },
            validator: selectedUserTypeData == null
                ? (c) {
                    if (c == null) return errorThisFieldRequired;
                    return null;
                  }
                : null,
            value: selectedUserTypeData,
            dropdownColor: context.cardColor,
            decoration: inputDecoration(context, hint: languages.lblSelectUserType),
            items: List.generate(
              userTypeList.length,
              (index) {
                UserTypeData data = userTypeList[index];

                return DropdownMenuItem<UserTypeData>(
                  child: Text(data.name.toString(), style: primaryTextStyle()),
                  value: data,
                );
              },
            ),
          ),
        ),
        16.height,
        // Password text field...
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: passwordCont,
          focus: passwordFocus,
          suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintPassword),
          onFieldSubmitted: (s) {
            saveUser();
          },
        ),
        20.height,
        _buildTcAcceptWidget(),
        8.height,
        // Sign up button
        AppButton(
          text: languages.lblSignup,
          height: 40,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            saveUser();
          },
        ),
      ],
    );
  }

  // Termas of service and Provacy policy text
  Widget _buildTcAcceptWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
            isAcceptedTc = !isAcceptedTc;
            _valueNotifier.notifyListeners();
          }),
        ),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: '${languages.lblIAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: languages.lblTermsOfService,
              style: boldTextStyle(color: primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch.launchUrl(Uri.parse(TERMS_CONDITION_URL));
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: languages.lblPrivacyPolicy,
              style: boldTextStyle(color: primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch.launchUrl(Uri.parse(PRIVACY_POLICY_URL));
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingAll(16);
  }

  // Already have an account with sign in text
  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: "${languages.alreadyHaveAccountTxt}? ", style: secondaryTextStyle()),
            TextSpan(
              text: languages.signIn,
              style: boldTextStyle(color: primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        30.height,
      ],
    );
  }

  //----------------------------- Helper Functions----------------------------//
  // Change country code function...
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: languages.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        _valueNotifier.notifyListeners();
      },
    );
  }

  // Build mobile number with phone code and number
  String buildMobileNumber() {
    return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
  }

  // Sign up user
  void saveUser() async {
    if (formKey.currentState!.validate()) {
      if (selectedUserTypeData != null && selectedUserTypeData!.id == -1) {
        return toast(languages.pleaseSelectUserType);
      }

      formKey.currentState!.save();

      hideKeyboard(context);

      if (isAcceptedTc) {
        appStore.setLoading(true);

        var request = {
          UserKeys.firstName: fNameCont.text.trim(),
          UserKeys.lastName: lNameCont.text.trim(),
          UserKeys.userName: userNameCont.text.trim(),
          UserKeys.userType: selectedUserTypeValue,
          UserKeys.contactNumber: buildMobileNumber(),
          UserKeys.email: emailCont.text.trim(),
          UserKeys.password: passwordCont.text.trim(),
          UserKeys.designation: designationCont.text.trim(),
          UserKeys.status: 0,
        };
        print(request);

        if (selectedUserTypeValue == USER_TYPE_PROVIDER) {
          request.putIfAbsent(UserKeys.providerTypeId, () => selectedUserTypeData!.id.toString());
        } else {
          request.putIfAbsent(UserKeys.handymanTypeId, () => selectedUserTypeData!.id.toString());
        }

        log(request);

        await registerUser(request).then((userRegisterData) async {
          appStore.setLoading(false);

          toast(userRegisterData.message.validate());

          push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        }).catchError((e) {
          toast(e.toString(), print: true);
          appStore.setLoading(false);
        });
      } else {
        toast(languages.lblTermCondition);
        appStore.setLoading(false);
      }
    }
  }

  //endregion
}
