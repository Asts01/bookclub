import 'package:cloud_firestore/cloud_firestore.dart';
class OurUser{
  String ?uid;
  String ?email;
  String ?fullName;
  dynamic ?accountCreated;//data-type defined for cloud-firestore
  String ?groupId;//allocated when user creates or joins a grp

  OurUser({this.uid,this.email,this.accountCreated,this.fullName,this.groupId});
}