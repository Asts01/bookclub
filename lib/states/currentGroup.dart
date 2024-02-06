//all the info abt current grps and books within it
import 'package:bookclub/models/book.dart';
import 'package:bookclub/models/group.dart';
import 'package:bookclub/services/database.dart';
import 'package:flutter/cupertino.dart';
//extends changeNotifier bcoz it has to act as provider for lower-widgets
class CurrentGroup extends ChangeNotifier{
  OurGroup _currentGroup=OurGroup();
  OurBook _currentBook=OurBook();
  bool _doneWithCurrentBook=false;
  //way to retrieve the book and grp info and return them else-where
  OurGroup get getCurrentGroup=>_currentGroup;
  OurBook get getCurrentBook=>_currentBook;
  bool get getDoneWithCurrentBook=>_doneWithCurrentBook;
  void notifyListeners(){
    notifyListeners();
  }
  void updateStateFromDatabase(String groupId,String uid)async{
    try{
      //get the current grp-info from firebase
      //get the current book-info from firebase
      _currentGroup=await OurDatabase().getGroupInfo(groupId);
      _currentBook=await OurDatabase().getBookInfo(groupId, _currentGroup.currentBookId!);
      _doneWithCurrentBook=await OurDatabase().isUserDonewithBook(groupId, _currentGroup.currentBookId!, uid);
      notifyListeners();//listens and changes the state of the 2 local instances of book and grp
    }catch(e){print(e);}
  }
  //event to be triggered when the user presses finish-book
  void finishedBook(String uid,int rating,String review)async{
    try{
      await OurDatabase().finishedBook(_currentGroup.id!, _currentGroup.currentBookId!,uid, rating, review);
      _doneWithCurrentBook=true;
      notifyListeners();//update the local-state
    }catch(e){print(e);}
  }
}