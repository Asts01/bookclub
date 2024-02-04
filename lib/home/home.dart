import 'package:bookclub/noGroup/noGroup.dart';
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
  @override
  void initState(){
    super.initState();
    // TODO: implement didChangeDependencies
    CurrentUser _currentUser=Provider.of<CurrentUser>(context,listen: false);
    CurrentGroup _currentGrp=Provider.of<CurrentGroup>(context,listen: false);
    _currentGrp.updateStateFromDatabase(_currentUser.getCurrentUser.groupId!);

  }

  void _signOut(BuildContext context)async{
    var _currentUser=Provider.of<CurrentUser>(context,listen: false);
    String retVal=await _currentUser.onLogOut();
    if(retVal=="success"){
      //we want our homeScreen to be incharge of where we need to go
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()),(route)=>false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Consumer<CurrentGroup>(
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text('Book : ',style: TextStyle(color: Colors.grey,fontSize: 22,fontWeight: FontWeight.w400,fontFamily: 'Cabin'),),
                        Text(value.getCurrentBook.name!,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 24,fontFamily: 'Cabin'),),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //to avoid render-flow use expanded widget
                        Text('Due in : ',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight:FontWeight.w500),),
                        Expanded(child: Text('${value.getCurrentGroup.currentBookDue!.toDate().toString()}',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.w500),)),
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
          Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Text("Harry Potter and the Sorcerer's stone",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 24,fontFamily: 'Cabin'),),
                Row(
                  children: [
                    Text('Due in : ',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight:FontWeight.w500),),
                    Text('8 Days',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.w500),),
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

            ),
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Text("Harry Potter and the Sorcerer's stone",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 24,fontFamily: 'Cabin'),),
                Row(
                  children: [
                    Text('Due in : ',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight:FontWeight.w500),),
                    Text('8 Days',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.w500),),
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

            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text('Next book revealed in : ',style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w700),),
                Text('22 Hours',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NoGroup()));
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
