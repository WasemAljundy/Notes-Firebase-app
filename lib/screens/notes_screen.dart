import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/controllers/fb_auth_controller.dart';
import 'package:firebase_app/controllers/fb_firestore_controller.dart';
import 'package:firebase_app/helpers/helpers.dart';
import 'package:firebase_app/models/note.dart';
import 'package:firebase_app/screens/note_screen.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helpers {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteScreen(),
              ),
            ),
            icon: const Icon(Icons.note_add),
          ),
          IconButton(
            onPressed: () async {
              await FbAuthController().signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FbFireStoreController().read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.note),
                  title: Text(documents[index].get('title')),
                  subtitle: Text(documents[index].get('details')),
                  trailing: IconButton(
                    onPressed: () async =>
                        await delete(path: documents[index].id),
                    color: Colors.red.shade800,
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          title: 'Update',
                          note: mapNote(documents[index]),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 85,
                    color: Colors.grey,
                  ),
                  Text(
                    'NO DATA!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> delete({required String path}) async {
    bool deleted = await FbFireStoreController().delete(path: path);
    String message = deleted ? 'Note Deleted Successfully' : 'Delete Failed!';
    showSnackBar(context: context, message: message, error: !deleted);
  }

  Note mapNote(QueryDocumentSnapshot snapshot) {
    Note note = Note();
    note.id = snapshot.id;
    note.title = snapshot.get('title');
    note.details = snapshot.get('details');
    return note;
  }

}
