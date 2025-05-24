import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavor_harmony_app/pages/workout/task_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/services/note_services.dart'; // FirestoreDatasource import edildi

class StreamNote extends StatelessWidget {
  final bool done;

  StreamNote(this.done, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: NoteServices()
          .stream(done), // FirestoreDatasource'tan stream metodunu kullanıyoruz
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('An error occurred: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Lets add the event!'));
        }

        final notelist = NoteServices().getNotes(
            snapshot.data!); // FirestoreDatasource'tan notları alıyoruz
        return ListView.builder(
          shrinkWrap: true,
          itemCount: notelist.length,
          itemBuilder: (context, index) {
            final note = notelist[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                NoteServices().deleteNote(note.id);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: TaskWidgets(note),
            );
          },
        );
      },
    );
  }
}
