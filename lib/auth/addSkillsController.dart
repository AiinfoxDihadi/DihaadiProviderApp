import 'package:get/get.dart';
import 'package:handyman_provider_flutter/auth/mockdata.dart';

class SkillsAddController extends GetxController {
  List<Category> skillsAndSpecialization = [
    Category(name: 'Cleaning', subName: [
      Skills(name: 'Full Home'),
      Skills(name: 'Bartan'),
      Skills(name: 'Toilet'),
      Skills(name: 'Stairs'),
      Skills(name: 'Cloths'),
      Skills(name: 'Other'),
    ]),
    Category(name: 'Cooking', subName: [
      Skills(name: 'Veg'),
      Skills(name: 'Non Veg'),
      Skills(name: 'Both'),
    ]),
    Category(name: 'Child Care', subName: [
      Skills(name: 'Full time'),
    ]),
    Category(name: 'Family Care', subName: [
      Skills(name: 'Fulltime'),
    ]),
  ];
  List<String> hoursList = ['Full Time','Part Time'];
  // String availableHours = <String>.obs;

  List<String> selectedSkills = <String>[].obs;

  void toggleSkillSelection(String skillName) {
    if (selectedSkills.contains(skillName)) {
      selectedSkills.remove(skillName);
    } else {
      selectedSkills.add(skillName);
    }
  }
 void addHours(String val) {
    // availableHours = val;
 }

}