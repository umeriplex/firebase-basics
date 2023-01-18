import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_abcd/utils/toasts_messages.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageView extends StatefulWidget {
  const UploadImageView({Key? key}) : super(key: key);

  @override
  State<UploadImageView> createState() => _UploadImageViewState();
}

class _UploadImageViewState extends State<UploadImageView> {

  bool? loading;
  File? image;
  final picker = ImagePicker();
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final _imageRef = FirebaseFirestore.instance.collection('posts');

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
          onTap: () async {getImage();},
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: image != null ? Image.file(image!) : const Icon(Icons.add_a_photo),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async {

            setState(() {loading = true;});

            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/images').child(DateTime.now().toString());
            firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);

            await Future.value(uploadTask).then((value) async {

              var newURL = await ref.getDownloadURL();


              _imageRef.doc().set({
                'image': newURL.toString(),
              }).then((value) {

                setState(() {loading = false;});
                ToastMessage.show('Image Uploaded');

              }).onError((error, stackTrace) {

                setState(() {loading = false;});
                ToastMessage.show('Error: $error');

              });
            }).onError((error, stackTrace) {

              setState(() {loading = false;});
              ToastMessage.show('Error: $error');

            });


          },
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: loading == true ? const CircularProgressIndicator() : const Text('Upload Image',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
          ),
      ]),
    );
  }
}
