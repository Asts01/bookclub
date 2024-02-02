import 'package:bookclub/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class OurDatabase{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;//new instnce of cloud firestore
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
}