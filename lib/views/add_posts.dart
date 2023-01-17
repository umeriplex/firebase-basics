import 'package:firebase_abcd/utils/toasts_messages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../widgets/rounded_button.dart';

class AddPostsView extends StatefulWidget {
  const AddPostsView({Key? key}) : super(key: key);

  @override
  State<AddPostsView> createState() => _AddPostsViewState();
}

class _AddPostsViewState extends State<AddPostsView> {

  final postController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.ref('post');
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
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
                  databaseReference.child(id).set({
                    'id': id,
                    'post': postController.text,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage.show('Post added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage.show(error.toString());
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
