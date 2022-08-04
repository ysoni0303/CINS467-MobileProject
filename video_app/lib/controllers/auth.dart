import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io' as i;

import '../models/user.dart' as model;
import '../views/login.dart';
import '../views/home.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<i.File?> _pickedImage;
  late Rx<User?> _user;

  i.File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialState);
  }

  _setInitialState(User? user) {
    print('auth');
    print(user);
    if (user == null) {
      Get.offAll(Login());
    } else {
      Get.offAll(Home());
    }
  }

  void uploadImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar('Profile Photo', 'Uploaded Successfully!!');
    }
    _pickedImage = Rx<i.File?>(i.File(pickedImage!.path));
  }

  Future<String> _uploadImageToStorage(i.File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void registerUser(
      String username, String email, String password, i.File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadImageToStorage(image);
        model.User user = model.User(
            name: username,
            profilePhoto: downloadUrl,
            email: email,
            uid: cred.user!.uid);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
            'Error creating account', 'Please enter all details & image');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print('Logged in already');
        Get.offAll(Home());
      } else {
        Get.snackbar('Error logging', 'Check details');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    print(_user);
  }
}
