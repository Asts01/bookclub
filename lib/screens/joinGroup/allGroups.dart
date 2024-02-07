import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookclub/services/database.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:bookclub/screens/root/root.dart';

class OurAllGroups extends StatefulWidget {
  const OurAllGroups({super.key});

  @override
  State<OurAllGroups> createState() => _OurAllGroupsState();
}

class _OurAllGroupsState extends State<OurAllGroups> {
  var _stream;
  @override
  void initState() {
    // TODO: implement initState
    _stream=OurDatabase().getGroupStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.transparent,
        title: Text('Existing Groups',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/teamwork.png',width: 40,height: 40,),
                  Container(margin:EdgeInsets.symmetric(horizontal: 3),child: Text('Select a group to join',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize:18,fontFamily: 'Cabin',decoration: TextDecoration.underline,textBaseline: TextBaseline.alphabetic),)),
                ],
              ),
            ),
            SizedBox(height: 7,),
            StreamBuilder(stream: _stream, builder: (context,snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Show an error message if something goes wrong
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                // Show a message if there is no data available
                return Center(child:Text('No grps available'));
              }else{
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                List<GrpBubble>groups=[];

                // Loop through each document snapshot and extract data
                for (var doc in querySnapshot.docs) {
                  String id=doc.id;
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  GrpBubble _bubble=GrpBubble(grpName: data['name'], grpLeader: data['leader'], grpId: id, currentBook: data['currentBookId'], members: data['members']);
                  groups.add(_bubble);
                }
                String members="";
                for(var x in groups[3].members){
                  members+=x+' ';
                }
                return Expanded(child: ListView(
                  children: groups,
                ));

              }
            }),
          ],
        ),
      )
    );
  }
}

class GrpBubble extends StatefulWidget {
  final dynamic grpName;
  final dynamic grpLeader;
  final dynamic grpId;
  final dynamic currentBook;
  final List<dynamic> members;

  GrpBubble({
    required this.grpName,
    required this.grpLeader,
    required this.grpId,
    required this.currentBook,
    required this.members,
  });

  @override
  State<GrpBubble> createState() => _GrpBubbleState();
}

class _GrpBubbleState extends State<GrpBubble> {
  late String leaderName;
  late String currentBookName;
  List<dynamic> membersName=[];
  bool _loading=true;
  @override
  void callNamesFromIds()async{
    leaderName=await OurDatabase().getUserName(widget.grpLeader);
    currentBookName=await OurDatabase().getBookName(widget.grpId, widget.currentBook);
    for(int i=0;i<widget.members.length;i++){
      String name=await await OurDatabase().getUserName(widget.members[i]);
      membersName.add(name);
    }
    setState(() {
      _loading=false;
    });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    callNamesFromIds();
  }
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
    return _loading?Center(child: CircularProgressIndicator(),):GestureDetector(
      onTap: (){
        _joinGrp(context, widget.grpId);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Group Name: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(child: Text(widget.grpName)),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'Group Leader: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(child: Text(leaderName)),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'Current Book: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(child: Text(currentBookName)),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'Members: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(
                  child: Text(
                    membersName.join(", "),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

