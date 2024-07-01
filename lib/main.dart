import 'package:bookclub/screens/root/root.dart';
// import 'package:bookclub/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'screens/login/login.dart';


//commited changes
//the way the CurrentUser model is provided to whole app
//The CurrentGrp model is provided to whole root
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      //all the method of CurrentUser State can be easiely accessed globally across entire project now
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ourTheme().buildTheme(),
        home: OurLoginScreen(),
      ),
    );
  }
}
