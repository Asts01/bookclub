import 'package:bookclub/models/book.dart';
import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/services/database.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

//screen for updating the book of current-grp and adding book initially to a grp
//this page is being used twice in the app-one for adding a book initially when the group gets created and secondly when current book being replaces
class OurAddBook extends StatefulWidget {

  final bool onGrpCreation;
  final String groupName;
  OurAddBook({required this.onGrpCreation,required this.groupName});

  @override
  State<OurAddBook> createState() => _OurAddBookState();
}

class _OurAddBookState extends State<OurAddBook> {
  TextEditingController _bookNameController=new TextEditingController();
  TextEditingController _authorController=new TextEditingController();
  TextEditingController _lengthController=new TextEditingController();

  DateTime _selectedDate=DateTime.now();//the users sets this date and initially is current date and time as soon as user enters this page

  Future<void> selectedDate(BuildContext context)async{
    //show-date time picker and set the selected date
    final DateTime? picked=await DatePicker.showDateTimePicker(context,showTitleActions: true,locale: LocaleType.en);
    if(picked!=null&&picked!=_selectedDate){
      _selectedDate=picked;
      setState(() {

      });
    }
  }

  //function to create grp in database
  void _addBook(BuildContext context,String grpName,OurBook book) async{
    CurrentUser _currentUser=Provider.of<CurrentUser>(context,listen: false);
    //add a book also while creating a grp
    String _returnString;
    if(widget.onGrpCreation){
      //create fresh new grp with user as leader and add a book to it
        _returnString=await OurDatabase().CreateGrp(grpName, _currentUser.getCurrentUser.uid,book);
    }else{
      //change the current book alloicated for the existing grp
      _returnString=await OurDatabase().addBook(_currentUser.getCurrentUser.groupId!,book);
    }

    if(_returnString=="success"){
      //since now grpId won't be null the user will navigate to HomeScreen and then the current groups book-id will always be updated on homeScreen
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()), (route) => false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: ListView(
        children: [
          // SizedBox(height: 15,),
          Padding(padding: EdgeInsets.all(20),child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.brown,
                ),
                child: BackButton(
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all<Size>(Size(40.0,40.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: (){Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),),
          SizedBox(height: 50,),
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
                          controller: _bookNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:Icon(Icons.book),
                            hintText: 'Book Name',
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(top: BorderSide(width: 1),bottom: BorderSide(width: 1),left: BorderSide(width: 1),right: BorderSide(width: 1)),
                        ),
                        margin: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: _authorController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:Icon(Icons.face_3_rounded),
                            hintText: 'Author',
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(top: BorderSide(width: 1),bottom: BorderSide(width: 1),left: BorderSide(width: 1),right: BorderSide(width: 1)),
                        ),
                        margin: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: _lengthController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:Icon(Icons.book_online_outlined),
                            hintText: 'Length',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      //date picker
                      Text(DateFormat.yMMMMd('en_US').format(_selectedDate)),//DateFormat comes from intl package
                      Text(DateFormat('H:mm').format(_selectedDate)),//DateFormat comes from intl package
                      TextButton(onPressed: (){
                        selectedDate(context);
                      }, child: Text('Change Date',style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),)),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.brown), // Change this color to your desired color
                          ),
                          onPressed: (){
                            //brought from pvs screen
                            OurBook book=OurBook();//OurBook comes from book-model
                            book.name=_bookNameController.text;
                            book.author=_authorController.text;
                            book.length=_lengthController.text;
                            book.dateCompleted=_selectedDate;//TODO
                            _addBook(context, widget.groupName, book);
                            //todo
                          }, child: Text('Create',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
