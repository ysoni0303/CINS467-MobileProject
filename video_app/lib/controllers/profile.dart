import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../controllers/auth.dart';
import '../models/user.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    print('updateUserId');
    print(uid);
    _uid.value = uid;
    profile();
  }

  profile() async {
    List<String> thumbnails = [];
    var myVideos = await FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(AuthController.instance.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto.toString(),
      'name': name.toString(),
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(AuthController.instance.user.uid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(AuthController.instance.user.uid)
          .set({});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(AuthController.instance.user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}

class Searching {
  final Rx<List<User>> _users = Rx<List<User>>([]);
  List<User> get searchedUsers => _users.value;

  searchUser(String typedUser) async {
    print('1');
    print(typedUser);
    List<User> data = [];
    _users.bindStream(FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      for (var elem in query.docs) {
        print('2');
        data.add(User.fromSnap(elem));
      }
      print('3');
      print(data);
      return data;
    }));
  }
}
