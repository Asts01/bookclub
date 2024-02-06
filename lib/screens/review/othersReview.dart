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
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                SizedBox(height: 500,),
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
                      List<List<dynamic>>ratings=[];
                      for(var msg in messages){
                        final dynamic rating = msg['rating'];
                        final dynamic review = msg['review'];
                        List<dynamic>items=[];
                        items.add(rating);items.add(review);
                        ratings.add(items);
                      }
                      return Container(
                        child: Text(ratings[0][0].toString()),
                      );
                    }
                  },
                ),
              ],
            ),
          )
      );
    }
  }
// class ReviewBubble extends StatelessWidget {
//   final String rating;
//   final String review;
//   ReviewBubble({this.rating,this.rev})
//   const ReviewBubble({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(ratings[0][0].toString()),
//           SizedBox(height: 10,),
//           Text(ratings[0][1]),
//         ],
//       ),
//     );
//   }
// }

