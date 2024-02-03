import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:bookclub/screens/signup/signup.dart';
import 'package:provider/provider.dart';

class OurLoginScreen extends StatefulWidget {
  const OurLoginScreen({super.key});

  @override
  State<OurLoginScreen> createState() => _OurLoginScreenState();
}
enum LoginType{
  google,email,
}
class _OurLoginScreenState extends State<OurLoginScreen> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();

  void _loginUser(
      {required LoginType type,
      String? email,
      String? password,
      context})async{
    var _currentUser=Provider.of<CurrentUser>(context,listen: false);
    try{
      var _retString;
      switch (type){
        case LoginType.email:
          _retString=await _currentUser.loginUser(email!, password!);
          break;
        case LoginType.google:
          _retString=await _currentUser.loginUserWithGoogle();
          break;
        default:
      }
      if(_retString=="success"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()), (route) => true);
      }else{
        final snackBar = SnackBar(
          backgroundColor: Colors.brown,
          content: Center(child: Text(_retString,style: TextStyle(fontFamily: 'Cabin',fontWeight: FontWeight.bold),)),
          duration: Duration(seconds: 4),

        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/book.png')),
            Center(child: Text('Welcome Readers',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold,fontSize: 30,fontFamily: 'Cabin'),)),
            SizedBox(height:70,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.grey,spreadRadius: 1.0,blurRadius: 10.0,offset: Offset(4.0,4.0),)]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Text('Log-In',style: TextStyle(color: Colors.brown,fontFamily: 'Cabin',fontSize: 30,fontWeight: FontWeight.w700),)),
                    SizedBox(height: 30,),
                    Container(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          hintText: 'Email',
                          hintStyle:TextStyle(color: Colors.grey,),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 1.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.green,width: 2.0))
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: 'Password',
                          hintStyle:TextStyle(color: Colors.grey,),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 1.0)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.green,width: 2.0))
                        ),
                      ),
                    ),
                    SizedBox(height: 40,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                        child: TextButton(onPressed: (){
                          _loginUser(
                            type: LoginType.email,
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                          );

                        }, child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),))),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        _loginUser(type: LoginType.google);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFECECEC),
                        ),
                        child: TextButton(onPressed: (){
                          _loginUser(type: LoginType.google,context: context);
                        }, child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/google.png',width: 25,height: 30,),
                            SizedBox(width: 10,),
                            Text('Login with Google',style: TextStyle(color: Colors.black,fontSize: 14),),
                          ],
                        )),
                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    }, child: Text("Don't have an account? Sign-up here",style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold),),),
                    SizedBox(height: 30,),
                  ],
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
}
