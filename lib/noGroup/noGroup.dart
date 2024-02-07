import 'package:bookclub/screens/createGroup/createGroup.dart';
import 'package:bookclub/screens/joinGroup/allGroups.dart';
import 'package:bookclub/screens/joinGroup/joinGroup.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:bookclub/screens/root/root.dart';
import 'package:provider/provider.dart';
import 'package:bookclub/states/currentUser.dart';

class NoGroup extends StatelessWidget {
  const NoGroup({super.key});
  void _goToJoin(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OurAllGroups()));
  }
  void _goToCreate(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OurCreateGroup()));
  }
  void _signOut(BuildContext context)async{
    var _currentUser=Provider.of<CurrentUser>(context,listen: false);
    String retVal=await _currentUser.onLogOut();//will call auth.signout
    if(retVal=="success"){
      //we want our homeScreen to be incharge of where we need to go and now authStatus will be null so it would take us to login screen
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()),(route)=>false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 30,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              TextButton(onPressed: ()=>_signOut(context), child: Text('Sign-out')),
              SizedBox(height: 70,),
              Center(child: Image.asset('assets/book.png',width: 300,height: 250,)),
              SizedBox(height: 10,),
              Text('Welcome to\n Convene',style: TextStyle(
                color: Colors.grey,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cabin',
              ),),
              SizedBox(height: 20,),
              Text('Since you are not in a book club,you can select to either join a club or create a club',style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cabin',
              ),),
              SizedBox(height: 250,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                      child: TextButton(onPressed: (){
                        _goToCreate(context);
                      }, child: Text('Create',style: TextStyle(color: Colors.black,fontSize: 20),))),
                  Container(
                    width: 130,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.grey,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(onPressed: (){
                        _goToJoin(context);
                      }, child: Text('Join',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
