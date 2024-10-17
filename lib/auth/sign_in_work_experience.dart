import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:handyman_provider_flutter/auth/addSkillsController.dart';
import 'package:handyman_provider_flutter/auth/legal_verification_screen.dart';
import 'package:handyman_provider_flutter/auth/mockdata.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInWorkExperience extends StatefulWidget {
  const SignInWorkExperience({super.key});

  @override
  State<SignInWorkExperience> createState() => _SignInWorkExperienceState();
}

class _SignInWorkExperienceState extends State<SignInWorkExperience> {
  SkillsAddController skillsAddController = Get.put(SkillsAddController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController workExpCont = TextEditingController();
  TextEditingController availableDaysCont = TextEditingController();
  TextEditingController workTypeCont = TextEditingController();
  TextEditingController statusCont = TextEditingController();
  TextEditingController emergencyCont = TextEditingController();
  TextEditingController emergencyPerson = TextEditingController();
  TextEditingController healthIssue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBarWidget(languages.workExperience,elevation: 0, color: context.scaffoldBackgroundColor,
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
                    10.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: workExpCont,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.workExperience),
                    ),
                    18.height,
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: context.scaffoldBackgroundColor,
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          isDismissible: true,
                          builder: (_) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: skillsAddController.skillsAndSpecialization.length,
                                itemBuilder: (c, categoryIndex) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        skillsAddController.skillsAndSpecialization[categoryIndex].name,
                                        style: boldTextStyle(),
                                      ),
                                      SizedBox(height: 5),
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: List.generate(
                                          skillsAddController.skillsAndSpecialization[categoryIndex].subName.length,
                                              (subNameIndex) {
                                            var subName = skillsAddController.skillsAndSpecialization[categoryIndex].subName[subNameIndex];
                                            return Obx(() {
                                              bool isSelected = skillsAddController.selectedSkills.contains(subName.name);
                                              return GestureDetector(
                                                onTap: () {
                                                  skillsAddController.toggleSkillSelection(subName.name);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? primaryColor : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(50),
                                                    border: Border.all(color: primaryColor),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        subName.name,
                                                        style: secondaryTextStyle(color: isSelected ? Colors.white : textSecondaryColorGlobal),
                                                      ),
                                                      if (isSelected) Icon(Icons.check, color: Colors.white, size: 15),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(bottom: 20);
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Text(maxLines: 2,
                                skillsAddController.selectedSkills.isNotEmpty ? skillsAddController.selectedSkills.join(', ') : languages.skillsAndSpecialization,
                                style: secondaryTextStyle(),
                              ).flexible();
                            }),
                            Icon(Icons.arrow_drop_down, color: textSecondaryColorGlobal),
                          ],
                        ).paddingOnly(left: 10, right: 10),
                      ),
                    ),
                    18.height,
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: context.scaffoldBackgroundColor,
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          isDismissible: true,
                          builder: (_) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: skillsAddController.hoursList.length,
                                itemBuilder: (c, i) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      15.height,
                                      GestureDetector(
                                        onTap: () {
                                          skillsAddController.addHours(skillsAddController.hoursList[i]);
                                          finish(context);
                                        },
                                        child: Text(
                                          skillsAddController.hoursList[i],
                                          style: boldTextStyle(),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ).paddingOnly(bottom: 20);
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Text(maxLines: 2,
                                skillsAddController.hours.value.isNotEmpty ? skillsAddController.hours.value : languages.availableHours,
                                style: secondaryTextStyle(),
                              ).flexible();
                            }),
                            Icon(Icons.arrow_drop_down, color: textSecondaryColorGlobal),
                          ],
                        ).paddingOnly(left: 10, right: 10),
                      ),
                    ),
                    18.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: availableDaysCont,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.availableDays),
                    ),
                    18.height,
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: context.scaffoldBackgroundColor,
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          isDismissible: true,
                          builder: (_) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: skillsAddController.workLocation.length,
                                itemBuilder: (c, i) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      15.height,
                                      GestureDetector(
                                        onTap: () {
                                          skillsAddController.addLocation(skillsAddController.workLocation[i]);
                                          finish(context);
                                        },
                                        child: Text(
                                          skillsAddController.workLocation[i],
                                          style: boldTextStyle(),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ).paddingOnly(bottom: 20);
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Text(maxLines: 2,
                                skillsAddController.work.value.isNotEmpty ? skillsAddController.work.value : languages.preferredWorkLocation,
                                style: secondaryTextStyle(),
                              ).flexible();
                            }),
                            Icon(Icons.arrow_drop_down, color: textSecondaryColorGlobal),
                          ],
                        ).paddingOnly(left: 10, right: 10),
                      ),
                    ),
                    18.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: workTypeCont,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.preferredWorkType),
                    ),
                    18.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: statusCont,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.availabiltyStatus),
                    ),
                    18.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: emergencyCont,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.emergencyContactNo),
                    ),
                    18.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: emergencyPerson,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.emergencyContactPersonName),
                    ),
                    18.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: healthIssue,
                      isValidationRequired: true,
                      errorThisFieldRequired: languages.hintRequired,
                      decoration: inputDecoration(context, hint: languages.healthIssueOrNot),
                    ),
                    20.height,
                    AppButton(
                      text: languages.next,
                      height: 40,
                      color: primaryColor,
                      textStyle: boldTextStyle(color: white),
                      width: MediaQuery.sizeOf(context).width - context.navigationBarHeight,
                      onTap: () {
                        if(formKey.currentState!.validate()) {
                          LegalVerificationScreen().launch(context);

                        }
                      },
                    ),
                  ],
                )
              ),
            ),
            Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
    ));
  }
}
