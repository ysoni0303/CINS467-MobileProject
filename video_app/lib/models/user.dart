import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;
  String profilePhoto;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePhoto,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email ": email,
        "profilePhoto": profilePhoto,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot);
    return User(
        uid: snapshot['uid'].toString(),
        name: snapshot['name'].toString(),
        email: snapshot['email'].toString(),
        profilePhoto: snapshot['profilePhoto'].toString());
  }
}
