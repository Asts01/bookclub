import 'package:bookclub/screens/login/login.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';

class OurSplashScreen extends StatelessWidget {
  const OurSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Center(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 400,),
              Text('loading...',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              // TextButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>OurLoginScreen()));
              //   }, child: Text('Go to Login',style: TextStyle(decoration: TextDecoration.underline,color: Colors.blueAccent))),
            ],
          ),
        )
      ),
    );
  }
}
