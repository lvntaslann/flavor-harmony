import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/model/note_model.dart';
import 'package:uuid/uuid.dart';

class NoteServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> addNote(String subtitle, String title, int image) async {
    try {
      var uuid = Uuid().v4();
      DateTime now = DateTime.now();
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('notes').doc(uuid).set({
        'id': uuid,
        'subtitle': subtitle,
        'isDon': false,
        'image': image,
        'time': '${now.hour}:${now.minute}',
        'title': title,
        'uid': uid, // Kullanıcı kimliğini ekliyoruz
      });
      return true;
    } catch (e) {
      print("AddNote Hatası: $e");
      return false; // Hatalı durum için false dönüyoruz
    }
  }

  List<Note> getNotes(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          data['id'],
          data['subtitle'],
          data['time'],
          data['image'],
          data['title'],
          data['isDon'],
        );
      }).toList();
    } catch (e) {
      print("GetNotes Hatası: $e");
      return []; // Hata durumunda boş bir liste dön
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    String uid = _auth.currentUser!.uid;
    return _firestore
        .collection('notes')
        .where('isDon', isEqualTo: isDone)
        .where('uid',
            isEqualTo: uid) // Sadece o kullanıcıya ait notları getiriyoruz
        .snapshots();
  }

  Future<bool> updateNote(
      String uuid, int image, String title, String subtitle) async {
    try {
      DateTime now = DateTime.now();
      await _firestore.collection('notes').doc(uuid).update({
        'time': '${now.hour}:${now.minute}',
        'subtitle': subtitle,
        'title': title,
        'image': image,
      });
      return true;
    } catch (e) {
      print("UpdateNote Hatası: $e");
      return false;
    }
  }

  Future<bool> deleteNote(String uuid) async {
    try {
      await _firestore.collection('notes').doc(uuid).delete();
      return true;
    } catch (e) {
      print("DeleteNote Hatası: $e");
      return false;
    }
  }

  Future<bool> toggleIsDone(String uuid, bool isDon) async {
    try {
      await _firestore.collection('notes').doc(uuid).update({'isDon': isDon});
      return true;
    } catch (e) {
      print("ToggleIsDone Hatası: $e");
      return false;
    }
  }
}
