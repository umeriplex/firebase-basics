import 'dart:async';

import 'package:firebase_abcd/utils/toasts_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in.dart';

import 'add_posts.dart';
import 'auth/loginView.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref('post');
  final searchFilter = TextEditingController();
  final _post = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Post'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              ToastMessage.show("Logged out");
              Timer(const Duration(seconds: 1), () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView())); });
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: _database,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                final title = snapshot.child('post').value.toString();
                if(searchFilter.text.isEmpty) {
                  return FadeInDown(
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        elevation: 6,
                        child: ListTile(
                          title: Text(snapshot.child('post').value.toString()),
                          subtitle: Text(snapshot.child('id').value.toString()),
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
                                    _addPost(snapshot.child('post').value.toString(),snapshot.child('id').value.toString());
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
                                    _database.child(snapshot.child('id').value.toString()).remove().then((value){
                                      ToastMessage.show("Post Deleted");
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace) {
                                      ToastMessage.show(error.toString());
                                    });
                                  },
                                  leading: const Icon(Icons.delete,color:Colors.deepPurple),
                                  title: const Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                else if(title.toLowerCase().contains(searchFilter.text.toLowerCase())) {
                  return FadeInLeft(
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        elevation: 6,
                        child: ListTile(
                          title: Text(snapshot.child('post').value.toString()),
                          subtitle: Text(snapshot.child('id').value.toString()),
                        ),
                      ),
                    ),
                  );
                }else{
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostsView()));},
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
                _database.child(id).update({'post': _post.text}).then((value){
                  ToastMessage.show("Post Updated");
                  Navigator.pop(context);
                }).onError((error, stackTrace) {
                  ToastMessage.show(error.toString());
                });
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
// ====================  Fetch Data Using StreamBuilder  ===================\\
// Expanded(
// child: StreamBuilder(
// stream: _database.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if(!snapshot.hasData){
// return const Center(child: CircularProgressIndicator());
// }else{
// Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context,index){
// return ListTile(
// title:Text(list[index]['post'].toString()),
// subtitle: Text(list[index]['id'].toString()),
// );
// }
// );
// }
// },
// )
// ),
