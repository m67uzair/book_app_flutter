import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_book/constants/firebase_constants.dart';

class SavedBooksProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore;
  bool _isBookSaved = false;
  final SharedPreferences prefs;

  SavedBooksProvider({required this.firebaseFirestore, required this.prefs});

  bool get isBookSaved => _isBookSaved;

  Future<void> addBookToSaved({required String bookId, required String bookName, required String bookImageURL}) async {
    Map<String, dynamic> book = {
      FirestoreConstants.bookId: bookId,
      FirestoreConstants.bookName: bookName,
      FirestoreConstants.bookImageURL: bookImageURL,
      FirestoreConstants.timestamp: DateTime.now().microsecondsSinceEpoch.toString()
    };

    await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(prefs.getString(FirestoreConstants.userId))
        .collection(FirestoreConstants.pathSavedCollection)
        .doc(bookId)
        .set(book);

    toggleIsBookSaved();

    notifyListeners();
  }

  Stream<QuerySnapshot> getBooksInSaved() {
    Stream<QuerySnapshot<Map<String, dynamic>>> savedBooksStream = firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(prefs.getString(FirestoreConstants.userId))
        .collection(FirestoreConstants.pathSavedCollection)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots();

    return savedBooksStream;
  }

  Future<void> removeBookFromSaved(String bookId) async {
    await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(prefs.getString(FirestoreConstants.userId))
        .collection(FirestoreConstants.pathSavedCollection)
        .doc(bookId)
        .delete();

    toggleIsBookSaved();
    notifyListeners();
  }

  void toggleIsBookSaved() {
    _isBookSaved = !_isBookSaved;
  }
}
