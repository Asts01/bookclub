import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:provider/provider.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/services/database.dart';
import 'package:bookclub/screens/root/root.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  TextEditingController _groupId=new TextEditingController();


  void _joinGrp(BuildContext context,String grpId) async{
    CurrentUser _currentUser=Provider.of<CurrentUser>(context,listen: false);//currentUser hold the reference of current user present in the app
    String _returnString=await OurDatabase().JoinGrp(grpId, _currentUser.getCurrentUser.uid);
    if(_returnString=="success"){
      //since now grpId won't be null the user will navigate to HomeScreen
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()), (route) => false);
    }
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
                        margin: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(top: BorderSide(width: 1),bottom: BorderSide(width: 1),left: BorderSide(width: 1),right: BorderSide(width: 1)),
                        ),
                        child: TextFormField(
                          controller: _groupId,
                          decoration: InputDecoration(
                            prefixIcon:Icon(Icons.group),
                            border: InputBorder.none,
                            hintText: 'Group Id',
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Change this color to your desired color
                          ),
                          onPressed: (){
                            _joinGrp(context, _groupId.text);
                          }, child: Text('Join',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
