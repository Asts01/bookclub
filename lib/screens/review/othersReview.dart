import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OthersReview extends StatefulWidget {
  final String grpid;
  final String bookid;//go to reviews collection of current book
  OthersReview({required this.grpid,required this.bookid});

  @override
  State<OthersReview> createState() => _OthersReviewState();
}
//stream of data provided via StreamBuilder
class _OthersReviewState extends State<OthersReview> {
  @override
  bool loading=true;
  var _stream;
    void initialization() async{
    // TODO: implement initState
      _stream=OurDatabase().getReviewStream(widget.grpid, widget.bookid);
    }
    @override
  void initState() {
    // TODO: implement initState
      initialization();
      setState(() {
        loading=false;
      });
    super.initState();
  }
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: ourTheme().lightGreen,
          body: loading?CircularProgressIndicator():Padding(
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
                        child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('Ratings',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Cabin',fontSize: 20),)],
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
                      List<ReviewBubble>ratings=[];
                      for(var msg in messages){
                        final dynamic rating = msg['rating'];
                        final dynamic review = msg['review'];
                        final dynamic user=msg['user'];
                        final dynamic time=msg['date'];
                        ReviewBubble _bubble=ReviewBubble(rating: rating,review: review,user:user,time:time);
                        ratings.add(_bubble);
                      }
                      return Expanded(child: ListView(
                        children: ratings,
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
class ReviewBubble extends StatelessWidget {
  final dynamic rating;
  final String review;
  final dynamic user;
  final dynamic time;
  ReviewBubble({required this.rating,required this.review,required this.user,required this.time});

  @override
  Widget build(BuildContext context) {
    String stars="";
    for(int i=0;i<rating;i++){
      stars+='⭐';
    }
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
              Text('User : ',style: TextStyle(fontWeight: FontWeight.w700),),
              Text(user),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            children: [
              Text('Rated : ',style: TextStyle(fontWeight: FontWeight.w700),),
              Text(stars),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review : ',style: TextStyle(fontWeight: FontWeight.w700),),
              Flexible(child: Text(review)),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Added on : ',style: TextStyle(fontWeight: FontWeight.w700),),
              Flexible(child: Text(time.toString())),
            ],
          ),
        ],
      ),
    );
  }
}

