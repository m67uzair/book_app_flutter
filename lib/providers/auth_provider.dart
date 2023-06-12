import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_book/constants/firebase_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Status { uninitialized, authenticated, authenticating, authenticateError, authenticateCanceled }

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth;
  final SharedPreferences prefs;
  User? firebaseUser;

  GoogleSignInAccount? googleUser;
  GoogleSignInAuthentication? googleAuth;

  Status _status = Status.uninitialized;
  bool signInActivityDone = false;

  Status get status => _status;

  String? get loggedInUserId => prefs.getString(FirestoreConstants.userId);

  AuthProvider({required this.firebaseAuth, required this.prefs});

  Future<bool> isLoggedIn() async {
    if (firebaseUser != null && prefs.getString(FirestoreConstants.userId)!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //
  Future<bool> signInWithGoogle() async {
    _status = Status.authenticating;
    notifyListeners();

    googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      try {
        googleAuth = await googleUser!.authentication;
        final AuthCredential credential =
            GoogleAuthProvider.credential(accessToken: googleAuth!.accessToken, idToken: googleAuth!.idToken);

        firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
      } on PlatformException catch (e) {
        if (e.code == GoogleSignIn.kNetworkError) {
          String errorMessage =
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred.";
          print(errorMessage);
        } else {
          String errorMessage = "Something went wrong.";
          print(errorMessage);
        }
      }

      if (firebaseUser != null) {
        await prefs.setString(FirestoreConstants.userId, firebaseUser!.uid);
        await prefs.setString(FirestoreConstants.displayName, firebaseUser!.displayName.toString());
        await prefs.setString(FirestoreConstants.photoUrl, firebaseUser!.photoURL.toString() ?? "");
        await prefs.setString(FirestoreConstants.phoneNumber, firebaseUser!.phoneNumber.toString() ?? "");
        await prefs.setString(FirestoreConstants.email, firebaseUser!.email.toString());

        print("firebase user photo: ${firebaseUser!.photoURL}");

        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        //firebaseUser if condition ends and else starts
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      // google user if condition ends and else starts
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();

    if (googleSignIn.currentUser != null) {
      print("not null");
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    }
    return true;
  }

  Future<bool> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String displayName,
      required String phoneNumber}) async {
    try {
      _status = Status.authenticating;
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      firebaseUser = firebaseAuth.currentUser;

      await firebaseUser!.updateDisplayName(displayName);

      await prefs.setString(FirestoreConstants.userId, firebaseUser!.uid);
      await prefs.setString(FirestoreConstants.displayName, displayName);
      await prefs.setString(FirestoreConstants.phoneNumber, phoneNumber ?? "");
      await prefs.setString(FirestoreConstants.email, email);

      _status = Status.authenticated;
      return true;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString(), backgroundColor: Colors.grey[900]);

      _status = Status.authenticateError;
      return false;
    }
    notifyListeners();
  }

  Future<bool> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      _status = Status.authenticating;
      notifyListeners();

      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      firebaseUser = firebaseAuth.currentUser;

      await prefs.setString(FirestoreConstants.userId, firebaseUser!.uid);
      await prefs.setString(FirestoreConstants.displayName, firebaseUser!.displayName.toString());
      await prefs.setString(FirestoreConstants.phoneNumber, firebaseUser!.phoneNumber.toString() ?? "");
      await prefs.setString(FirestoreConstants.email, firebaseUser!.email.toString());
      _status = Status.authenticated;
      return true;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString(), backgroundColor: Colors.grey[900]);
      _status = Status.authenticateError;
      return false;
    }
    notifyListeners();
  }
}
