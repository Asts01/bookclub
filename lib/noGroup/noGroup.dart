import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';

class NoGroup extends StatelessWidget {
  const NoGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Padding(
        padding: const EdgeInsets.only(top:220,left: 35,right: 25),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/book.png'),
              SizedBox(height: 10,),
              Text('Welcome to\n Book Club',style: TextStyle(
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
                      child: TextButton(onPressed: (){}, child: Text('Create',style: TextStyle(color: Colors.black,fontSize: 20),))),
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
                      child: TextButton(onPressed: (){}, child: Text('Join',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
