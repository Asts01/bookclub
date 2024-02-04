import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup{
  String ?id;
  String? name;
  String ?leader;
  List<dynamic> ?members;
  dynamic groupCreated;
  String ?currentBookId;
  dynamic currentBookDue;

  OurGroup({this.id,this.name,this.leader,this.members,this.groupCreated,this.currentBookId,this.currentBookDue});

}