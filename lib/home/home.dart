import 'dart:async';
import 'package:bookclub/screens/addBook/addBook.dart';
import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookclub/states/currentGroup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _timeUntil=['loading..','loading..'];//[0]->until-current-book is due
  //[1]->time-until next book will be revealed
  late Timer _timer;
  @override
  void initState(){
    super.initState();
    // TODO: implement didChangeDependencies
    CurrentUser _currentUser=Provider.of<CurrentUser>(context,listen: false);
    CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
    _currentGrp.updateStateFromDatabase(_currentUser.getCurrentUser.groupId!);//method to fetch current grp & book data from db

  }

  void _signOut(BuildContext context)async{
    var _currentUser=Provider.of<CurrentUser>(context,listen: false);
    String retVal=await _currentUser.onLogOut();
    if(retVal=="success"){
      //we want our homeScreen to be incharge of where we need to go
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()),(route)=>false);
    }
  }

  void _goToAddBook(BuildContext context){
    //go to add book screen taking with the required arguments
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OurAddBook(onGrpCreation: false,groupName:'',)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(30),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Consumer<CurrentGroup>(
              //instead of using Provider.of() many times we can use Consumer widget where the parent of CurrentGroup Provider if HomeScreen
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text('Book : ',style: TextStyle(color: Colors.grey,fontSize: 26,fontWeight: FontWeight.bold,fontFamily: 'Cabin'),),
                        Expanded(child: Text(value.getCurrentBook.name??'loading...',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 26,fontFamily: 'Cabin'),)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //to avoid render-flow use expanded widget
                        Text('Due in : ',style: TextStyle(color: Colors.grey,fontSize: 26,fontWeight:FontWeight.w500),),
                        Expanded(
                          child: Text(
                            // value.getCurrentGroup.currentBookDue != null
                            //     ? DateFormat.yMMMMd('en_US').add_jms().format(value.getCurrentGroup.currentBookDue!.toDate())
                            //     : 'loading..',
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
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey,
                      ),
                      child: TextButton(onPressed: (){
                      }, child: Text('Finish Book',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                    ),
                  ],

                );
              },
            ),
          ),
          SizedBox(height: 15,),

          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(17),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text('Next book \nrevealed in : ',style: TextStyle(color: Colors.grey,fontSize: 26,fontWeight: FontWeight.bold),),
                Text(_timeUntil[1],style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w700),),
              ],
            )
          ),
          Container(
            margin: EdgeInsets.all(40),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey,
            ),
            child: TextButton(onPressed: (){
              _goToAddBook(context);
            }, child: Text('Book Club History',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey,
            ),
            child: TextButton(onPressed: (){
              _signOut(context);
            }, child: Text('Sign-Out',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
          ),
        ],
      ),
    );
  }
}
