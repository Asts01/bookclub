import 'package:bookclub/screens/login/login.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/home/home.dart';
import 'package:provider/provider.dart';

enum AuthStatus{notLoggedIn,loggedIn,}//enum for directing the app to two different places

class OurRoot extends StatefulWidget {
  const OurRoot({super.key});

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus=AuthStatus.notLoggedIn;//start up with not-logged in state
  @override

  void didChangeDependencies() async{
    //get the current state and change AuthStatus based on that
    var currentUser=Provider.of<CurrentUser>(context,listen: false);
    String _returnString=await currentUser.onStartUp();
    if(_returnString=="success"){
      //and we are not using Provider for this bcoz for this Auth File we are using only root widget & hiding it from everyone
      setState(() {
        _authStatus=AuthStatus.loggedIn;
      });
    }
  }

  Widget build(BuildContext context) {
    late Widget retVal;//return the desired state according to AuthStatus
    switch(_authStatus){
      case AuthStatus.loggedIn:
        retVal=HomeScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal=OurLoginScreen();
        break;
      default:
    }
    return Container(child: retVal,);
  }
}
