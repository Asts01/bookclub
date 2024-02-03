import 'package:bookclub/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<String> CreateGrp(String groupName,dynamic uid) async{
    String retVal="error";
    List<String> _members = [];
    try{
      _members.add(uid);
      DocumentReference _docRef=await _firestore.collection('groups').add({
        'name':groupName,
        'leader':uid,
        'members':_members,
        'groupCreated':Timestamp.now(),
      });
      //update grp id for document->user
      await _firestore.collection('users').doc(uid).update({
        'groupId':_docRef.id,
      });
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }
  Future<String> JoinGrp(String groupId,dynamic uid) async{
    String retVal="error";
    List<String>_members=[];
    try{
      //get collection groups->groupId->members.add(new uid)
      //now add the groupId of this user to users collection
      _members.add(uid);
      await _firestore.collection('groups').doc(groupId).update({
        'members':FieldValue.arrayUnion(_members),
      });
      await _firestore.collection('users').doc(uid).update({
        'groupId':groupId,
      });
      retVal="success";
    }catch(e){print(e);}
    return retVal;
  }
}