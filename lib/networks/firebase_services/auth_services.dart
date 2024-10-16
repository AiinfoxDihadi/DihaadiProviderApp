import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/user_data.dart';
import '../../networks/rest_apis.dart';

class AuthService {
  Future<UserCredential> getFirebaseUser() async {

    print('get user funtion');
    UserCredential? userCredential;
    try {
      /// login with Firebase
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: 'robertmartin@gmail.com', password: '12345678');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        /// register user in Firebase
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "robertmartin@gmail.com", password: '12345678');
        print("================> code${e.code}");
      }
    }
    if (userCredential != null && userCredential.user == null) {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "robertmartin@gmail.com", password: '12345678');
    }

    if (userCredential != null) {
      return userCredential;
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> verifyFirebaseUser() async {
    try {
      UserCredential userCredential = await getFirebaseUser();
      print('verify firebase $userCredential');

      UserData userData = UserData();
      userData.id = appStore.userId;
      userData.email = appStore.userEmail;
      userData.firstName = appStore.userFirstName;
      userData.lastName = appStore.userLastName;
      userData.profileImage = appStore.userProfileImage;
      userData.updatedAt = Timestamp.now().toDate().toString();

      /// Check email exists in Firebase
      /// If not exists, register user in Firebase,
      /// If exists, login with Firebase
      /// Redirect to Dashboard

      /// add user data in Firestore
      userData.uid = userCredential.user!.uid;

      bool isUserExistWithUid = await userService.isUserExistWithUid(userCredential.user!.uid);

      print(isUserExistWithUid);

      if (!isUserExistWithUid) {
        userData.createdAt = Timestamp.now().toDate().toString();
        await userService.addDocumentWithCustomId(userCredential.user!.uid, userData.toFirebaseJson());
      } else {
        /// Update user details in Firebase
        await userService.updateDocument(userData.toFirebaseJson(), userCredential.user!.uid);
        print('worked');
      }

      /// Update UID & Profile Image in Laravel DB
      updateProfile({'uid': userCredential.user!.uid});

      print('===============> ${userCredential.user!.uid}');

      await appStore.setUId(userCredential.user!.uid);
    } catch (e) {
      log('verifyFirebaseUser $e');
    }
  }
}
