import 'dart:async';
import 'package:bookclub/screens/addBook/addBook.dart';
import 'package:bookclub/screens/allBooksOfGrp/allBooksOfGrp.dart';
import 'package:bookclub/screens/joinGroup/allGroups.dart';
import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookclub/states/currentGroup.dart';
import 'package:bookclub/utils/timeLeft.dart';
import 'package:bookclub/screens/review/review.dart';
import 'package:bookclub/screens/review/othersReview.dart';
import 'package:bookclub/screens/chatting/chat.dart';
//CurrentGroup has scope only in this file unlike from CurrentUser having scope in entire main-file
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _timeUntil=['loading..','loading..'];//[0]->until-current-book is due
  //[1]->time-until next book will be revealed
  late Timer _timer;
  bool _doneOnce=false;
  bool currentBookPending=true;


  void _startTimer(CurrentGroup grp){
    _timer=Timer.periodic(Duration(seconds: 1), (timer) {
      //called after every 1 sec take diffrence from the current-time every one second
      _timeUntil=OurTimeLeft().timeLeft(grp.getCurrentGroup.currentBookDue.toDate());
      setState(() {
        if (_timeUntil[0] == "REPLACE CURRENT BOOK from below ↓↓↓↓"&&_doneOnce==false) {
          _showReplaceBookAlert();
        }

      });
    });
  }

  @override
  void initState(){
    super.initState();
    // TODO: implement didChangeDependencies
    //currentGroup and currentUser are the active-user & the active-group the user belongs to and these have state (active-living-entities) of the ap
    //as the active user and the user's group keep on changing
    //thets why each time home screen is rebuild as due to updateState method current-group changes which causes the consumer widget to re-built
    CurrentUser _currentUser=Provider.of<CurrentUser>(context,listen: false);
    CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
    _currentGrp.updateStateFromDatabase(_currentUser.getCurrentUser.groupId!,_currentUser.getCurrentUser.uid!);//method to fetch current grp & book data from db
    _startTimer(_currentGrp);
  }
  @override
  //disposes off everything once build method is over
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();//timer don't always keep on running
    super.dispose();
  }
  void _signOut(BuildContext context)async{
    var _currentUser=Provider.of<CurrentUser>(context,listen: false);
    String retVal=await _currentUser.onLogOut();
    if(retVal=="success"){
      //we want our homeScreen to be incharge of where we need to go and now auth-status has been changed to notloggedin as currentUser will be null
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()),(route)=>false);
    }
  }

  void _goToAddBook(BuildContext context){
    //go to add book screen taking with the required arguments
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OurAddBook(onGrpCreation: false,groupName:'',)));
  }

  void _goToReview(){
    CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
    //directed to OurReview page with currentGroup as currGrp
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OurReview(currentGroup: _currentGrp)));
  }
  void _goToOthersReview(){
    CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OthersReview(grpid: _currentGrp.getCurrentGroup.id!,bookid: _currentGrp.getCurrentBook.id,)));
  }
  void _showReplaceBookAlert() {
    _doneOnce=true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Replace Current Book"),
          content: Flexible(
            child: Row(
              children: [
                Text("The current book is due for replacement.\n      Add from Replace Current Book"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF679289),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.home,color: Colors.brown,size: 40,),
            Text('Home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat,color: Colors.brown,size: 40,),
        shape: CircleBorder(),
        backgroundColor: Color(0xFF679289),
        onPressed: (){
          CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(grpId: _currentGrp.getCurrentGroup.id!)));
        },
      ),
      backgroundColor: ourTheme().lightGreen,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 1),
            child: Row(
              children: [
                Icon(Icons.groups,color: Colors.brown,size: 50,),
                // Text('Welcome to the group'+)
                SizedBox(width: 10,),
                Consumer<CurrentGroup>(
                  builder: (BuildContext context, CurrentGroup value, Widget? child) {
                    // Your widget tree goes here, you can use the `value` to access the CurrentGroup
                    return Container(
                      child: Text('Group:${value.getCurrentGroup.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown
                      ),), // Example usage
                    );
                  },
                )

              ],
            ),
          ),
          SizedBox(height: 4,),
          //just for demo will remove it afterwards
          Container(
            padding: EdgeInsets.all(30),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3), // White shadow color with opacity
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: Offset(0, 3), // Offset to control shadow position
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Consumer<CurrentGroup>(
              //instead of using Provider.of() many times we can use Consumer widget where the parent of CurrentGroup Provider is HomeScreen
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Current Book Allocated',style: TextStyle(color: Color(0xFF679289),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'Cabin',decoration: TextDecoration.underline),),
                    Row(
                      children: [
                          Expanded(child: Center(child: Text(value.getCurrentBook.name??'loading...',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 30,fontFamily: 'Cabin'),))),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('Author : ',style: TextStyle(color: Colors.brown,fontSize: 26,fontWeight: FontWeight.w700,fontFamily: 'Cabin'),),
                        Expanded(child: Text(value.getCurrentBook.author??'loading...',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 26,fontFamily: 'Cabin'),)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //to avoid render-flow use expanded widget
                        Text('Due in : ',style: TextStyle(color: Colors.brown,fontSize: 26,fontWeight:FontWeight.w700),),
                        Expanded(
                          child: Text(
                            // value.getCurrentGroup.currentBookDue != null
                            //     ? DateFormat.yMMMMd('en_US').add_jms().format(value.getCurrentGroup.currentBookDue!.toDate())
                            //    : 'loading..',
                            _timeUntil[0],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                       //Expanded(child: Text((value.getCurrentGroup.currentBookDue.toString())??'loading..',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.w500),)),
                      ],
                    ),
                    SizedBox(height: 7.0,),
                    Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 80),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                      ),
                      child: TextButton(onPressed: (){
                        // // _currentGrp.notifyListeners();
                        // currentBookPending=!value.getDoneWithCurrentBook;
                        // setState(() {
                        //   //update the status of currentBookPending to false as getDoneWithCurrentBook is true
                        // });
                        value.getDoneWithCurrentBook
                            ? _goToOthersReview()
                            : _goToReview();
                        // setState(() {
                        //
                        // });
                      }, child: Text('Finish Book',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: value.getDoneWithCurrentBook?Text('View-Reviews'):Text('Add-Review'),
                      ),
                    ),
                  ],

                );
              },
            ),
          ),
          SizedBox(height: 30,),
          Consumer<CurrentGroup>(
          builder: (BuildContext context, value, Widget? child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              // color: ourTheme().lightGreen,
              height: 40.0,
              decoration: BoxDecoration(color: Color(0xFF679289).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Compeletion Status : ', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),),
                  value.getDoneWithCurrentBook ? Text('✅'):Text('❌') ,
                ],
              ),
            );
          }
          ),
//Add books for future studies->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          // SizedBox(height: 20,),
          // Container(
          //   padding: EdgeInsets.all(17),
          //   margin: EdgeInsets.symmetric(horizontal: 30),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(15),
          //   ),
          //   child: Row(
          //     children: [
          //       Text('Next book \nrevealed in : ',style: TextStyle(color: Colors.brown,fontSize: 26,fontWeight: FontWeight.bold),),
          //       Text(_timeUntil[1],style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w700),),
          //     ],
          //   )
          // ),
          Container(
            margin: EdgeInsets.all(40),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.brown,
            ),
            child: TextButton(onPressed: (){
              _goToAddBook(context);
            }, child: Text('Replace Current Book',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.brown,
            ),
            child: TextButton(onPressed: (){
              _signOut(context);
            }, child: Text('Sign-Out',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
          ),
          SizedBox(height: 20,),
          Center(
            child: GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurAllGroups()), (route) => false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.groups,color: Color(0xFF679289),),
                      SizedBox(width: 15,),
                      Text('Switch existing Group ',style: TextStyle(color: Color(0xFF679289),fontWeight:FontWeight.bold,decoration: TextDecoration.underline,fontSize: 18),),
                    ],
                  ),)),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history,color: Colors.brown,size: 30,),
              TextButton(onPressed: (){
                CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBooksOfGroup(grpid: _currentGrp.getCurrentGroup.id!, bookid: _currentGrp.getCurrentBook.id!)));
              }, child: Text('View Previous Books Of Group',style: TextStyle(color: Colors.brown,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'Cabin',decoration: TextDecoration.underline),)),
            ],
          ),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
}
