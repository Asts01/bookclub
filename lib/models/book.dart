import 'package:cloud_firestore/cloud_firestore.dart';

class OurBook{
  String ?id;
  String ?name;
  dynamic length;//no of pages in book
  Timestamp ?dateCompleted;
  OurBook({
    this.id,this.name,this.length,this.dateCompleted
  });
}