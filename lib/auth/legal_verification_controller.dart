
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LegalVerificationController extends GetxController {
  File? aadhaarCard;
  File? localAddress;
  File? selfie;
  bool image = false;
  bool localImage = false;
  bool selfieImage = false;
  void takeSnapshot(String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );
    if (img == null) return;
      if (type == 'aadhaar') {
        aadhaarCard = File(img.path);
        image = true;
      } else {
        localAddress = File(img.path);
        localImage = true;
      }
      update();
  }

  void selfieSnap() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
    );
    if (img == null) return;
    selfie = File(img.path);
    selfieImage = true;
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