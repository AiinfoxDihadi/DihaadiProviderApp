
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LegalVerificationController extends GetxController {
  File? aadhaarCard;
  bool image = false;
  void takeSnapshot() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );
    if (img == null) return;
      aadhaarCard = File(img.path);
      image = true;
      update();
  }
  void removeImage() async {
    if (aadhaarCard != null) {
      try {
        await aadhaarCard!.delete();
        aadhaarCard = null;
        image = false;
        update();
      } catch (e) {
        print("Error deleting image: $e");
      }
    }
  }
}