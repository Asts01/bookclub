import 'package:bookclub/models/users.dart';
import 'package:bookclub/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Instead of displaying the manual SnackBar error msg->display the error msg
class CurrentUser extends ChangeNotifier{
  OurUser _currentUser=OurUser();
  //local state saving for email & password

  FirebaseAuth _auth=FirebaseAuth.instance;
  //async functions returns Future as return type
  Future<String> signUpUser(String email,String password,String fullName) async{
    String retval="";
    OurUser _user=OurUser();
    try{
      var authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user.uid=authResult.user!.uid;
      _user.email=authResult.user!.email;
      _user.fullName=fullName;
      String isUserIndb=await OurDatabase().createUser(_user);//created user in db
      if(isUserIndb=="success")retval="success";
    }catch(e){
      retval=e.toString();
    }
    return retval;
  }
  Future<String> onStartUp()async{
    //keep the user logged-In across the app
    //if some current user already exists in the app then the app should start from HomeScreen
    String retVal="error";
    try{
      var _firebaseUser=await _auth.currentUser;
      _currentUser.uid=_firebaseUser?.uid;
      _currentUser.email=_firebaseUser!.email;
      _currentUser=await OurDatabase().getUserInfo(_auth.currentUser!.uid);
      if(_currentUser!=null) {
        retVal = "success";
      }
    }catch(e){print(e);}
    return retVal;
  }

  Future<String> onLogOut()async{
    //log-out the already existing user
    String retVal="error";
    try{
      await _auth.signOut();
      // _currentUser.uid=null;
      // _currentUser.email=null;
      _currentUser=OurUser();//create a new instance of user
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }

  Future<String> loginUser(String email,String password) async{
    String retval="";
    try{
      var authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(authResult!=null&&authResult.user!=null){
        _currentUser.uid=authResult.user!.uid;
        _currentUser.email=authResult.user!.email;
        // retval="success";
      }
      //checking whether the user with particular email & password exists in app
      _currentUser=await OurDatabase().getUserInfo(authResult.user!.uid);
      if(_currentUser!=null){
        retval="success";
      }
      return retval;
    }catch(e){
      retval=e.toString();
    }
    return retval;
  }
  Future<String> loginUserWithGoogle() async {
    String retval = "error";
    OurUser _user=OurUser();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if(result.additionalUserInfo!.isNewUser){
      _user.uid=result.user!.uid;
      _user.email=result.user!.email;
      _user.fullName=result.user!.displayName;
      OurDatabase().createUser(_user);
    }
    _currentUser=await OurDatabase().getUserInfo(result.user!.uid);
    if(_currentUser!=null){
      retval="success";
    }
    //check whether the user is successfully created
    return retval;
  }
}