import 'package:bookclub/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookclub/models/group.dart';
import 'package:bookclub/models/book.dart';
//replace current book not showing review of current book and showing review o
class OurDatabase{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;//new instnce of cloud firestore
  //saves data to the cloud-firestore
  Future<String> createUser(OurUser user) async{
    String retVal="error";
    try{
      //craete a user in db
      await _firestore.collection('users').doc(user.uid).set(
        {
          'fullName':user.fullName,
          'email':user.email,
          'accountCreated':Timestamp.now(),
        }
      );
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }
  //tells whether user with particular uid exists in the firebase and returns the OurUser model
  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser(); // Assuming OurUser() is the constructor for your OurUser class
    try {
      DocumentSnapshot _documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (_documentSnapshot.exists) {
        // Check if the document exists
        Map<String, dynamic> data = _documentSnapshot.data() as Map<String, dynamic>;
        retVal.uid = uid;
        retVal.fullName = data['fullName'] ?? '';
        retVal.email = data['email'] ?? '';
        retVal.accountCreated = data['accountCreated'] ?? '';
        retVal.groupId=data['groupId']??'';
      } else {
        // Document does not exist
        print('Document does not exist for UID: $uid');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      // You might want to throw an exception or handle the error differently based on your app's requirements
    }
    return retVal;
  }
  //creating grp as a leader and adding a current book to be read
  Future<String> CreateGrp(String groupName,dynamic uid,OurBook initialBook) async{
    String retVal="error";
    List<String> _members = [];
    try{
      _members.add(uid);//add method return's reference of the user while set method don't
      //doc_ref have the doc-id of the particular grp
      DocumentReference _docRef=await _firestore.collection('groups').add({//RETURNS REFERENCE OF GRP-ID
        'name':groupName,
        'leader':uid,
        'members':_members,
        'groupCreated':Timestamp.now(),
      });
      //update grp id for document initially when the user logged-in grp-id was null->user and now the user will navigate to the Home Screen
      await _firestore.collection('users').doc(uid).update({
        'groupId':_docRef.id,
      });
      //add a book to the current group collections to particular grp-id
      addBook(_docRef.id, initialBook);
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }
  Future<String> JoinGrp(String groupId,dynamic uid) async{
    //existing rp ke member ne uid vala user add ho jayega
    //aur us-user ki grpid current-grp ki id set ho-jayegi
    //bug->While leaving the existing group , remove yourself from its members list
    String retVal="error";
    List<String>_members=[];
    try{
      //get collection groups->groupId->members.add(new uid)
      //now add the groupId of this user to users collection
      _members.add(uid);
      await _firestore.collection('groups').doc(groupId).update({
        'members':FieldValue.arrayUnion(_members),//take union with the pre-existing value
      });
      await _firestore.collection('users').doc(uid).update({
        'groupId':groupId,
      });
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }
  // String _leftExisting =await OurDatabase().leaveGrp(_currentGroup.id,_currentUser.getCurrentUser.fullName);
  Future<String> leaveGrp(String grpId,dynamic uid) async{
    //if a person has not joined any group yet how he will leave the existing group

    print("group id is null"+ grpId);
    String retval="error";
    List<String>_members=[];
    try{
      _members.add(uid);
      await _firestore.collection('groups').doc(grpId).update({
      //expects dynamic list of elements
        'members':FieldValue.arrayRemove(_members),
      });
      retval="success";
    }catch(e){
      print("didnt left the existing group");
    }
    if(grpId==null)retval="success";
    return retval;
  }


  Future<String> addBook(String grpId,OurBook book) async{
    String retVal="success";
    //add book to the required grp can be while creating a grp initially or later modifying it
    try{
      //will be added into the book-list of particular grp and also now this book will the current book of particular-grp
      //the current book which needs to be completed at the current instance of time
      //and is displayed on the home-screen
      DocumentReference _docRef=await _firestore.collection('groups').doc(grpId).collection('books').add({
        'name':book.name,
        'author':book.author,
        'length':book.length,
        'dateCompleted':book.dateCompleted,//set from date-time picker
      });
      //_docRef contains ref to the book-id
      //1 grp will only have 1 currentBookId
      //now change the data inside groups collection
      await _firestore.collection('groups').doc(grpId).update({
        'currentBookId':_docRef.id,
        'currentBookDue':book.dateCompleted,
      });
    }catch(e){print('book ghotala');}
    return retVal;
  }
  Future<OurGroup> getGroupInfo(String groupId)async{
    OurGroup retVal=OurGroup();
    try {
      DocumentSnapshot _documentSnapshot =
      await _firestore.collection('groups').doc(groupId).get();
        // Check if the document exists
        Map<String, dynamic> data = _documentSnapshot.data() as Map<String, dynamic>;
        retVal.id = groupId;
        retVal.name = data['name']??'';
        retVal.leader = data['leader'] ?? '';
        retVal.groupCreated = data['groupCreated'] ?? '';
        retVal.members=data['members']??'';
        retVal.currentBookId=data['currentBookId']??'';
        retVal.currentBookDue=data['currentBookDue']??'';

    } catch (e) {
      print('Error fetching grp info :$groupId');
      // You might want to throw an exception or handle the error differently based on your app's requirements
    }
    return retVal;
  }
  Future<OurBook> getBookInfo(String groupId,String bookId)async{
    OurBook retVal=OurBook();
    try {
      DocumentSnapshot _documentSnapshot =
      await FirebaseFirestore.instance.collection('groups').doc(groupId).collection('books').doc(bookId).get();
      if (_documentSnapshot.exists) {
        // Check if the document exists
        Map<String, dynamic> data = _documentSnapshot.data() as Map<String, dynamic>;
        retVal.id = bookId;
        retVal.name = data['name'] ?? '';
        retVal.length = data['length'] ?? '';
        retVal.dateCompleted = data['dateCompleted'] ?? '';
        retVal.author=data['author']??'';
      } else {
        // Document does not exist
        print('Book does not exist for grp: $groupId');
      }
    } catch (e) {
      print('Error fetching book info from grp:$bookId');
      // You might want to throw an exception or handle the error differently based on your app's requirements
    }
    return retVal;
  }
  //method to finish the current book and add rating and reviews
  Future<String>finishedBook(String grpId,String bookId,String uid,int rating,String review,String username)async{
    String _retVal="error";
    //we have used user-id here for setting the rating as multiple users can be part of same grp so with particular uid he is accessible to read the current book
    try{
      DateTime now = DateTime.now();
      String formattedDate = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}";

      await _firestore.collection('groups').doc(grpId).collection('books').doc(bookId).collection('reviews').doc(uid).set(
          {
            'rating':rating,
            'review':review,
            'user':username,
            'date':formattedDate,//the date review was added into the reviews collection of the current-book
          });
      _retVal="success";
    }catch(e){print(e);}

    return _retVal;
  }
  //check whether a book already has review property and is user id done with the book
  //here the uid is the user-id of the users collection
  Future<bool> isUserDonewithBook(String grpId,String bookId,String uid)async{
    bool _retVal=false;
    try{
      DocumentSnapshot _docRef=await _firestore.collection('groups').doc(grpId).collection('books').doc(bookId).collection('reviews').doc(uid).get();
      if(_docRef.exists){
        _retVal=true;
      }
    }catch(e){print(e);}
    return _retVal;
  }
  //review-stream
  Stream<QuerySnapshot<Map<String,dynamic>>> getReviewStream(String grpid,String bookid){
    //streams are synchoronous that's why they are streams
    var _stream=_firestore.collection('groups').doc(grpid).collection('books').doc(bookid).collection('reviews').snapshots();
    return _stream;
  }
  //get stream of all the grp-id's->to be show-cased on joinGroup Screen
  Stream<QuerySnapshot<Map<String,dynamic>>> getGroupStream(){
    //streams are synchoronous that's why they are streams
    var _stream=_firestore.collection('groups').snapshots();
    return _stream;
  }
  //get book-name and user-name from document id's
  Future<String> getUserName(String uid)async{
    String retVal="success";
    try{
      DocumentSnapshot _docref=await _firestore.collection('users').doc(uid).get();
      if (_docref.exists) {
        // Check if the document exists
        Map<String, dynamic> data = _docref.data() as Map<String, dynamic>;
        retVal= data['fullName'] ?? '';//name of the user
      }
    }catch(e){
      print('Error fetching user-name from uid');
    }

    return retVal;
  }
  Future<String> getBookName(String grpid,String bookid)async{
    String retVal="success";
    try{
      DocumentSnapshot _docref=await _firestore.collection('groups').doc(grpid).collection('books').doc(bookid).get();
      if (_docref.exists) {
        // Check if the document exists
        Map<String, dynamic> data = _docref.data() as Map<String, dynamic>;
        retVal= data['name'] ?? '';//name of current-book
      }
    }catch(e){
      print('Error fetching book-name from book-id');
    }
    return retVal;
  }
  Stream<QuerySnapshot<Map<String,dynamic>>> getMessageStream(String grpId){
    //streams are synchoronous that's why they are streams
    //JISKA TIME SBSE JYADA H VO PEHLE AAYEGA->descending:true
    var _stream=_firestore.collection('groups').doc(grpId).collection('messages').orderBy('time',descending: true).snapshots();
    return _stream;
  }
  // getAllBookStream(widget.grpid)
  Stream<QuerySnapshot<Map<String,dynamic>>> getAllbookStream(String grpid){
    //streams are synchoronous that's why they are streams
    //JISKA TIME SBSE JYADA H VO PEHLE AAYEGA->descending:true
    //to be showed in readig history of group and reviews of all the books
    var _stream=_firestore.collection('groups').doc(grpid).collection('books').snapshots();
    return _stream;
  }
}