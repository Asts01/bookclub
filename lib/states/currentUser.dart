import 'package:bookclub/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//Instead of displaying the manual SnackBar error msg->display the error msg
class CurrentUser extends ChangeNotifier{
  //local state saving for email & password
  dynamic _uid;
  dynamic _email;

  String get getUid=>_uid;
  String get getEmail=>_email;

  FirebaseAuth _auth=FirebaseAuth.instance;
  //async functions returns Future as return type
  Future<String> signUpUser(String email,String password) async{
    String retval="";
    try{
      var authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(authResult.user!=null){
        retval="success";
      }
    }catch(e){
      retval=e.toString();
    }
    return retval;
  }
  Future<String> loginUser(String email,String password) async{
    String retval="";
    try{
      var authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(authResult!=null&&authResult.user!=null){
        _uid=authResult.user!.uid;
        _email=authResult.user!.email;
        retval="success";
      }
      return retval;
    }catch(e){
      retval=e.toString();
    }
    return retval;
  }
  Future<String> loginUserWithGoogle() async {
    String retval = "";
    // const List<String> scopes = <String>[
    //   'email',
    //   'https://www.googleapis.com/auth/contacts.readonly',
    // ];
    //
    // GoogleSignIn _googleSignIn = GoogleSignIn(
    //   scopes: scopes,
    // );
    // try{
    //   GoogleSignInAccount? _googleUser=await _googleSignIn.signIn();
    //   GoogleSignInAuthentication _googleAuth=await _googleUser!.authentication;
    //   final AuthCredential credential=GoogleAuthProvider.credential(idToken: _googleAuth.idToken,accessToken:_googleAuth.accessToken );
    //   var _authResult=await _auth.signInWithCredential(credential);
    //   _uid=_authResult.user!.uid;
    //   _email=_authResult.user!.email;
    //   retval="success";
    //   return retval;
    // }catch(e){retval=e.toString();}
    // return retval;
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
//get details from google-credential
    if (result != null) {
      retval="success";
    }else{
      retval="error";
    }
    return retval;
  }
}