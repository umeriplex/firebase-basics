import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_abcd/utils/toasts_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../views/add_posts.dart';
import 'firestore_add_data.dart';

class FireStoreListView extends StatefulWidget {
  const FireStoreListView({Key? key}) : super(key: key);

  @override
  State<FireStoreListView> createState() => _FireStoreListViewState();
}

class _FireStoreListViewState extends State<FireStoreListView> {

  final _postRef = FirebaseFirestore.instance.collection('posts').snapshots();
  final _post = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('FireStore View'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _postRef,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting || snapshot.data!.docs.isEmpty || snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DateTime myDateTime = (snapshot.data!.docs[index]['time']).toDate();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['post']),
                            subtitle: Text(timeago.format(myDateTime)),
                            trailing: PopupMenuButton(
                              elevation: 6,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              splashRadius: 20,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: (){

                                    },
                                    leading: const Icon(Icons.edit,color:Colors.deepPurple),
                                    title: const Text('Edit'),
                                  ),
                                ),
                                const PopupMenuItem(
                                  child: Divider(),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: (){
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(snapshot.data!.docs[index].id)
                                          .delete().then((value) {
                                            ToastMessage.show('Post Deleted');
                                      }).onError((error, stackTrace) {
                                        ToastMessage.show('Error: $error');
                                      });
                                      Navigator.pop(context);
                                    },
                                    leading: const Icon(Icons.delete,color:Colors.deepPurple),
                                    title: const Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const FireStoreAddPostsView()));},
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addPost(String oldValue, String id) async {
    _post.text = oldValue;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _post,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Post',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
