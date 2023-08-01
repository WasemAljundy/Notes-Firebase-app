import 'dart:async';

import 'package:firebase_app/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


typedef FbAuthListener = void Function({required bool status});

class FbAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          if (context.mounted) {
            showSnackBar(
              context: context,
              message: 'Logged In Successfully!',
            );
          }
          return true;
        } else {
          await userCredential.user!.sendEmailVerification();
          await signOut();
          if (context.mounted) {
            showSnackBar(
              context: context,
              message: 'Email must be verified, please try again!',
              error: true,
            );
          }
        }
      }
    } on FirebaseAuthException catch (exception) {
      _controlAuthException(context: context, exception: exception);
    } catch (exception) {
      print(exception);
    }

    return false;
  }

  Future<bool> createAccount(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      signOut();
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: 'Account Created, Please Verify the email!',
        );
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _controlAuthException(context: context, exception: e);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> forgetPassword(
      {required BuildContext context, required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: 'Password reset email sent, Check your email!',
        );
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _controlAuthException(context: context, exception: e);
    } catch (e) {
      print(e);
    }

    return false;
  }

  StreamSubscription checkUserState({required FbAuthListener listener}) {
    return _firebaseAuth.authStateChanges().listen((User? user) {
      listener(status: user != null);
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void _controlAuthException(
      {required BuildContext context,
      required FirebaseAuthException exception}) {
    showSnackBar(
        context: context, message: exception.message ?? '', error: true);
    if (exception.code == 'invalid-email') {
      //
    } else if (exception.code == 'user-disabled') {
      //
    } else if (exception.code == 'user-not-found') {
      //
    } else if (exception.code == 'wrong-password') {
      //
    }
  }
}
