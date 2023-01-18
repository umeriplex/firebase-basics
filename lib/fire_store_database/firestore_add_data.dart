import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../utils/toasts_messages.dart';
import '../widgets/rounded_button.dart';

class FireStoreAddPostsView extends StatefulWidget {
  const FireStoreAddPostsView({Key? key}) : super(key: key);

  @override
  State<FireStoreAddPostsView> createState() => _FireStoreAddPostsViewState();
}

class _FireStoreAddPostsViewState extends State<FireStoreAddPostsView> {

  final postController = TextEditingController();
  bool loading = false;
  final _postRef = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore Add Post'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          FadeInDown(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: postController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Whats on your mind?',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          FadeInDown(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: RoundButton(
                loading: loading,
                title: 'Add Post',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  _postRef.doc(id).set({
                    'post': postController.text,
                    'time': DateTime.now(),
                    'id': id,
                  }).then((value) {
                      setState(() {
    loading = false;
});
                      ToastMessage.show('Post Added Successfully');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage.show('Error: $error');
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
