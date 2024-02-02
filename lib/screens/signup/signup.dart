import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:provider/provider.dart';

//for using textEditingController we need to use Statefull Widget
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _confirmPasswordController=TextEditingController();

  void _signUpUser(String email,String password,String name,context) async{
    //listen for not updating ui
    var _currUser=await Provider.of<CurrentUser>(context,listen: false).signUpUser(email, password,name);
    try{
      if(_currUser=="success"){
        //send user back to loginScreen
        Navigator.pop(context);
        return;
      }
      final snackBar = SnackBar(
        backgroundColor: Colors.brown,
        content: Center(child: Text(_currUser,style: TextStyle(fontFamily: 'Cabin',fontWeight: FontWeight.bold),)),
        duration: Duration(seconds: 4),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }catch(e){

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30,vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Container(
                decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(40)),
                padding: EdgeInsets.all(2),
                child: Icon(Icons.arrow_back_ios,color: Colors.white,weight: 15.0,),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Text('Sign-Up',style: TextStyle(color: Colors.brown,fontFamily: 'Cabin',fontSize: 30,fontWeight: FontWeight.w700),)),
                    SizedBox(height: 30,),
                    Container(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.face),
                            hintText: 'User-Name',
                            hintStyle:TextStyle(color: Colors.grey,),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 1.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.green,width: 2.0))
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
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
                    SizedBox(height: 20,),
                    Container(
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: 'Confirm Password',
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
                          if(_passwordController.text==_confirmPasswordController.text){
                            _signUpUser(_emailController.text,_passwordController.text,_nameController.text,context);
                          }else{
                            final snackBar = SnackBar(
                              backgroundColor: Colors.brown,
                              content: Center(child: Text("Passwords don't match",style: TextStyle(fontFamily: 'Cabin',fontWeight: FontWeight.bold),)),
                              duration: Duration(seconds: 2),

                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }, child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30,fontFamily: 'Cabin'),))),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
