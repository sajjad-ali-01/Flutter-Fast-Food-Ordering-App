import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

void addUserToFirestore(String FName, String LName, String Email, String Phone, String Password, String? DOB, String? Gender) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //var firebaseUser = await FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid;
  if (uid != null) {
    String? formattedDOB;
    if (DOB != null && DOB.isNotEmpty) {
      try {
        DateTime parsedDOB = DateFormat('dd/MM/yyyy').parse(DOB);
        formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDOB); // ISO 8601 format
      } catch (e) {
        print('Error parsing DOB: $e');
        formattedDOB = null;
      }
    }

    // Add the user if email and phone number are unique
    await users.doc(uid).set({
      'UserId': uid,
      'FName': FName,
      'LName': LName,
      'Email': Email,
      'Phone': Phone,
      'Password': Password,
      'DOB': formattedDOB,
      'Gender': Gender,
      'ImageUrl':''
    });
  } else {
    print('Error: Current user is null');
  }
}
