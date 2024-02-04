import 'package:bookclub/screens/addBook/addBook.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({super.key});

  @override
  State<OurCreateGroup> createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  TextEditingController _groupNameController=new TextEditingController();
  //function to create grp in database
  void _goToAddBook(BuildContext context,String grpName){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>OurAddBook(onGrpCreation: true, groupName: grpName)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Column(
        children: [
          SizedBox(height: 15,),
          Padding(padding: EdgeInsets.all(20),child: Row(
            children: <Widget>[
              BackButton(
                onPressed: (){Navigator.pop(context);},
              ),
            ],
          ),),
          SizedBox(height: 260,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(top: BorderSide(width: 1),bottom: BorderSide(width: 1),left: BorderSide(width: 1),right: BorderSide(width: 1)),
                        ),
                        margin: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: _groupNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:Icon(Icons.group),
                            hintText: 'Group Name',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Change this color to your desired color
                        ),
                          onPressed: (){
                          _goToAddBook(context, _groupNameController.text);
                          }, child: Text('Add Book',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
