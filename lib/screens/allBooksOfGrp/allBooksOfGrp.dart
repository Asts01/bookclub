import 'package:bookclub/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllBooksOfGroup extends StatefulWidget {
  String grpid;
  String bookid;
  AllBooksOfGroup({required this.grpid,required this.bookid});

  @override
  State<AllBooksOfGroup> createState() => _AllBooksOfGroupState();
}

class _AllBooksOfGroupState extends State<AllBooksOfGroup> {
  bool loading=true;
  var _stream;
  @override
  void initState() {
    // TODO: implement initState
    _stream=OurDatabase().getAllbookStream(widget.grpid,);
    loading=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ourTheme().lightGreen,
        body: loading?Center(child: CircularProgressIndicator()):Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  children: [Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(Icons.arrow_back_ios,color: Colors.brown,),
                    ),
                  ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        Text('Previously Read Books',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontFamily: 'Cabin',fontSize: 20,decoration: TextDecoration.underline),),
                        Icon(Icons.book_outlined,color: Color(0xFF679289),),
                      ],
                    )],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for data
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Show an error message if something goes wrong
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    // Show a message if there is no data available
                    return Center(child:Text('No reviews available'));
                  } else {
                    final messages = snapshot.data!.docs;
                    List<BookBubble>books=[];
                    for(var msg in messages){
                      final dynamic name = msg['name'];
                      final dynamic author = msg['author'];
                      final dynamic length=msg['length'];
                      BookBubble _bubble=BookBubble(name: name,author: author,length: length,);
                      if(msg.id!=widget.bookid)books.add(_bubble);
                    }
                    return Expanded(child: ListView(
                      children: books,
                    ));
                  }
                },
              ),
            ],
          ),
        )
    );
  }
}
class BookBubble extends StatelessWidget {
  final dynamic name;
  final String author;
  final dynamic length;
  BookBubble({required this.name,required this.author,required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Book : ',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.brown),),
              Text(name,style: TextStyle(color: Color(0xFF679289,),fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            children: [
              Text('Author : ',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.brown),),
              Text(author,style: TextStyle(color: Color(0xFF679289),fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Length : ',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.brown),),
              Flexible(child: Text(length,style: TextStyle(color: Color(0xFF679289),fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }
}


