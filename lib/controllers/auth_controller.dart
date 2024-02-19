import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _fileName = '';

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if(_file != null){
      return await _file.readAsBytes();
    }else{
      print('No image selected');
    }
  }

  _uploadImageToStorage(Uint8List? image) async {
    _fileName = _auth.currentUser!.uid;

    Reference ref = _storage.ref().child('profileImages').child(_fileName);

    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = ref.putData(image!, metadata);

    TaskSnapshot snapshot = await uploadTask;
    
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> createNewUser(String email, String fullname, String password, Uint8List? image) async {
    String msg = 'Some error occured';

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String downloadUrl = await _uploadImageToStorage(image);

      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
          'fullName':fullname,
          'profileImage':downloadUrl,
          'email':email,
          'buyerId':userCredential.user!.uid
        }
      );

      msg = 'Success';
    } catch (e) {
      msg = e.toString();
    }

    return msg;
  }

  Future<String> loginUser(String email, String password) async {
    String res = 'Some error occured';

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}