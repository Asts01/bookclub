import 'package:cloud_firestore/cloud_firestore.dart';
class OurUser{
  String ?uid;
  String ?email;
  String ?fullName;
  Timestamp ?accountCreated;//data-type defined for cloud-firestore
  String ?groupId;

  OurUser({this.uid,this.email,this.accountCreated,this.fullName,this.groupId});
}