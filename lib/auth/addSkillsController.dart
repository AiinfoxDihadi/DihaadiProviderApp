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
  List<String> workLocation = ['House','Office','Girls PG' , "Boys PG"];

  List<String> selectedSkills = <String>[].obs;

  var hours = ''.obs;
  var work = ''.obs;

  void toggleSkillSelection(String skillName) {
    if (selectedSkills.contains(skillName)) {
      selectedSkills.remove(skillName);
    } else {
      selectedSkills.add(skillName);
    }
  }
 void addHours(String val) {
   hours.value = val;
 }
 void addLocation(String val) {
    work.value =  val;
 }
}