import 'package:bookclub/states/currentGroup.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//add review page according to rating and review-msg
class OurReview extends StatefulWidget {
  final CurrentGroup currentGroup;
  OurReview({required this.currentGroup});

  @override
  State<OurReview> createState() => _OurReviewState();
}
//REVIEW SCREEN IS NO LONGER IN THE WIDGET TREE SINCE IT IS NOT A SUB-SCREEN OF ROOT(PUSHED FROM ROOT SCREEN),IT IS BEEN PUSHED FROM HOME SCREEN
class _OurReviewState extends State<OurReview> {
  int _dropDownValue=1;
  TextEditingController _reviewContoller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Column(
        children: [
          SizedBox(height: 15,),
          Padding(padding: EdgeInsets.all(20),child: Row(
            children: <Widget>[
              ElevatedButton(
                child:Container(
                  child: Icon(Icons.arrow_back_ios),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),),
          SizedBox(height: 150,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Text('Rate book 1-5',style: TextStyle(color: Colors.grey,fontSize: 15,fontFamily: 'Cabin',fontWeight: FontWeight.bold),),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1,color: Colors.grey),
                        ),
                        child: DropdownButton<int>(
                          icon: Icon(Icons.arrow_downward_outlined),
                          underline: Container(  // Set underline to null by providing an empty container
                            height: 0,
                            color: Colors.transparent,
                          ),
                          value: _dropDownValue,
                          items: <DropdownMenuItem<int>>[
                            DropdownMenuItem<int>(
                              value: 1,
                              child: Text(' 1'),
                            ),
                            DropdownMenuItem<int>(
                              value: 2,
                              child: Text(' 2'),
                            ),
                            DropdownMenuItem<int>(
                              value: 3,
                              child: Text(' 3'),
                            ),
                            DropdownMenuItem<int>(
                              value: 4,
                              child: Text(' 4'),
                            ),
                            DropdownMenuItem<int>(
                              value: 5,
                              child: Text(' 5'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _dropDownValue= value!;
                            });
                          },
                          hint: Text('Select the rating'),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(top: BorderSide(width: 1),bottom: BorderSide(width: 1),left: BorderSide(width: 1),right: BorderSide(width: 1)),
                        ),
                        margin: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          maxLines: 6,
                          controller: _reviewContoller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:Icon(Icons.group),
                            hintText: 'Add a Review',
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Change this color to your desired color
                          ),
                          onPressed: (){
                            String uid=Provider.of<CurrentUser>(context,listen: false).getCurrentUser.uid!;
                            widget.currentGroup.finishedBook(uid, _dropDownValue,_reviewContoller.text);
                            Navigator.pop(context);
                          }, child: Text('Add Book',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
