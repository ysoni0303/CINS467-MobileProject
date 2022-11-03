import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String? uid;
  String? userid;
  String? employeename;
  String? position;
  String? contactno;

  Employee(
      {this.uid,
      this.userid,
      this.employeename,
      this.position,
      this.contactno});
}
