import 'package:bookclub/noGroup/noGroup.dart';
import 'package:bookclub/screens/login/login.dart';
import 'package:bookclub/screens/splashScreen/splashScreen.dart';
import 'package:bookclub/states/currentGroup.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/home/home.dart';
import 'package:provider/provider.dart';
//maintain authStatus on the basis of the data provided by the provider and direct the navigator accordingly.
enum AuthStatus{unknown,notInGroup,notloggedIn,inGroup}//enum for directing the app to two different places

class OurRoot extends StatefulWidget {
  const OurRoot({super.key});

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus=AuthStatus.unknown;//start up with(loading...) splash initially when we are fetching user info via onStrtup() method
  @override

  void didChangeDependencies() async{
    super.didChangeDependencies();
    //get the current state and change AuthStatus based on that
    var currentUser=Provider.of<CurrentUser>(context,listen: false);
    //onstartUp method sets the user status through any of the Login Method
    String _returnString=await currentUser.onStartUp();
    if(_returnString=="success") { //check whether user exists
      //the user's login/sign-up method only sets the email & userName of the user onto db
      if (currentUser.getCurrentUser.groupId!.length >
          1) { //check whether grp-id exists corresponding to that user
        setState(() {
          //as soon as the dependency will change due to the change in data provided by provider the stateful widget will update its state and rerender itself with new changes and properties.
          _authStatus = AuthStatus
              .inGroup; //direct to the home-screen of the required grp
        });
      } else{
        setState(() {
          _authStatus = AuthStatus.notInGroup;
        });
    }
      //and we are not using Provider for this bcoz for this Auth File having where we need to direct  we are using only root widget & hiding it from everyone
    }else{
      //tells whether if particular instance of auth.currentUser exists inside the app
      //NO USER IF FOUND THAN THE USER NEEDS TO LOGIN INTO THE DEVICE
      //this state exists when we are not-loggedIn and presses sign-out button
      setState(() {
        _authStatus=AuthStatus.notloggedIn;
      });
    }

  }

  Widget build(BuildContext context) {
    late Widget retVal;//return the desired state according to AuthStatus
    switch(_authStatus){
      case AuthStatus.notloggedIn:
        retVal=OurLoginScreen();
        break;
      case AuthStatus.unknown:
        retVal=OurSplashScreen();
        break;
      case AuthStatus.notInGroup:
        retVal=NoGroup();
        break;
      case AuthStatus.inGroup:
        retVal=ChangeNotifierProvider(
          create: (context)=>CurrentGroup(),
            child: HomeScreen());
        break;
      default:
        retVal=OurSplashScreen();
    }
    return Container(child: retVal,);
  }
}
