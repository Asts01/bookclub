import 'package:bookclub/models/users.dart';
import 'package:bookclub/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//this file contains login-Sign-up vali saari functionalities
//Instead of displaying the manual SnackBar error msg->display the error msg
class CurrentUser extends ChangeNotifier{
  //all the methods of login & sign-up sets the status of the currentUser inside the app
  //all the properties of user are clubbed in OurUser class
  OurUser _currentUser=OurUser();//_currentUser is private instance of OurUser for CurrentUser class
  //local state saving for email & password
  OurUser get getCurrentUser{return _currentUser;}
  FirebaseAuth _auth=FirebaseAuth.instance;
  //async functions returns Future as return type
  Future<String> signUpUser(String email,String password,String fullName) async{
    String retval="error";
    try{
      var authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _currentUser.uid=authResult.user!.uid;
      _currentUser.email=authResult.user!.email;
      _currentUser.fullName=fullName;
      //created the user in users collection and update the _currentUser by fetching details when logging-in
      String ?isUserIndb=await OurDatabase().createUser(_currentUser);//created user in db->add method in db
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
      // _currentUser.uid=_firebaseUser?.uid;
      // _currentUser.email=_firebaseUser!.email;
      _currentUser=await OurDatabase().getUserInfo(_firebaseUser!.uid);//using get method in db
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
      await _auth.signOut();//sign-out the current auth instance
      _currentUser.uid=null;
      _currentUser.email=null;
      _currentUser.groupId=null;
      _currentUser.fullName=null;
      _currentUser=OurUser();//create a new empty instance of user
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }

  Future<String> loginUser(String email,String password) async{
    String retval="";
    try{
      var authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
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
//1st tiem login-with google create entry in db
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