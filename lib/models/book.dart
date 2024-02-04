import 'package:cloud_firestore/cloud_firestore.dart';

class OurBook{
  dynamic id;
  dynamic name;
  dynamic author;
  dynamic length;//no of pages in book
  dynamic dateCompleted;
  OurBook({
    this.id,this.name,this.author,this.length,this.dateCompleted
  });
}