//all the info abt current grps and books within it
import 'package:bookclub/models/book.dart';
import 'package:bookclub/models/group.dart';
import 'package:bookclub/services/database.dart';
import 'package:flutter/cupertino.dart';
//extends changeNotifier bcoz it has to act as provider for lower-widgets
class CurrentGroup extends ChangeNotifier{
  OurGroup _currentGroup=OurGroup();
  OurBook _currentBook=OurBook();
  //way to retrieve the book and grp info and return them else-where
  OurGroup get getCurrentGroup=>_currentGroup;
  OurBook get getCurrentBook=>_currentBook;

  void updateStateFromDatabase(String groupId)async{
    try{
      //get the current grp-info from firebase
      //get the current book-info from firebase
      _currentGroup=await OurDatabase().getGroupInfo(groupId);
      _currentBook=await OurDatabase().getBookInfo(groupId, _currentGroup.currentBookId!);
      notifyListeners();//listens and changes the state of the 2 local instances of book and grp
    }catch(e){}
  }

}