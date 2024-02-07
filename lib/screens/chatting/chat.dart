import 'package:bookclub/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:provider/provider.dart';
import 'package:bookclub/states/currentUser.dart';

class ChatScreen extends StatefulWidget {
  String grpId;
  ChatScreen({required this.grpId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  dynamic messageText;
  TextEditingController messageController=new TextEditingController();
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  dynamic _stream;
  dynamic _currentUserName;
  bool _loading=true;
  @override
  void getDetails(){
    _stream=OurDatabase().getMessageStream(widget.grpId);
  }
  void initState() {
    // TODO: implement initState
    getDetails();
    setState(() {
      _loading=false;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _currentUserName=Provider.of<CurrentUser>(context).getCurrentUser.fullName!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF679289),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: (){
                //cant use pop-context bcox u came from push and removed until
                Navigator.pop(context);
              },
              child: Container(decoration:BoxDecoration(color: Color(0xFFFFFACA),borderRadius: BorderRadius.circular(30)),child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.home,color: Colors.green,size: 20,)),),
            ),
          ),
        ],
        title: Row(
          children: [
            Icon(Icons.message_outlined,color: Colors.white,size: 40,),
            Text('Chat with Members :)',style: TextStyle(color: Colors.brown,fontFamily: 'Cabin',fontWeight:FontWeight.bold),),
          ],
        ),
      ),
      backgroundColor: Color(0xFFFFFACA),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  //snapshot dosent have data ->show spinner there
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFF679289), //will spin for no-data and as soon data is ready it will get destroyed.
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  List<MessageBubble>allMessages=[];
                  for(var msg in messages){
                    final dynamic _msg = msg['message'];
                    final dynamic _sender= msg['user'];
                    bool _isMe=false;
                    if(_sender==_currentUserName)_isMe=true;
                    MessageBubble _bubble=MessageBubble(msg: _msg,sender: _sender,isMe: _isMe,);
                    allMessages.add(_bubble);
                  }
                  return Expanded(
                    //take up as much space available
                    child: ListView(
                      //ListView -> alternative to Column Widget
                      reverse:
                      true, //sticky to the end->neeche se upr scroll kro
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: allMessages,
                    ),
                  );
                  // return Container();
                }),
            Container(
              decoration: ourTheme().kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //clear the TextField as soon as send button is pressed.
                        messageText = value;
                      },
                      decoration: ourTheme().kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // DateTime now = DateTime.now();
                      // createdon = now;
                      _firestore.collection('groups').doc(widget.grpId).collection('messages').add({
                        'message':messageController.text,
                        'user':_currentUserName,
                        'time':DateTime.now(),
                      });
                      messageController.clear();
                    },
                    child: Text(
                      'Send',
                      style: ourTheme().kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageBubble extends StatelessWidget {
  MessageBubble({this.msg, this.sender, this.isMe});
  final dynamic msg;
  final dynamic sender;
  final dynamic isMe;
  @override
  Widget build(BuildContext context) {
    //Material is customizable-widget
    ////We need to add padding around each MsgBubble
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text('$sender'),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
                : BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: isMe ? Color(0xFF679289) : Colors.brown,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '$msg',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


