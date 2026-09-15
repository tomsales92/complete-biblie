import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/bible_data.dart';
import '../models/read_entry.dart';

class BibleService {
  BibleService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _readsRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('reads');

  Future<List<ReadEntry>> getReads(String uid) async {
    final snapshot = await _readsRef(uid).get();
    return snapshot.docs.map((doc) => ReadEntry.fromMap(doc.data())).toList();
  }

  Future<ReadEntry> markAsRead(String uid, String book, int chapter) async {
    final bookInfo = findBook(book);
    if (bookInfo == null) {
      throw ArgumentError('Livro inválido.');
    }
    if (chapter < 1 || chapter > bookInfo.chapters) {
      throw ArgumentError('Capítulo inválido para este livro.');
    }

    final id = readDocId(book, chapter);
    final entry = ReadEntry(
      id: id,
      book: book,
      chapter: chapter,
      date: todayDateString(),
      readAt: DateTime.now().toIso8601String(),
    );

    await _readsRef(uid).doc(id).set(entry.toMap());
    return entry;
  }

  Future<void> unmarkRead(String uid, ReadEntry entry) {
    return _readsRef(uid).doc(entry.id).delete();
  }

  Future<void> deleteAllReads(String uid) async {
    final snapshot = await _readsRef(uid).get();
    if (snapshot.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
