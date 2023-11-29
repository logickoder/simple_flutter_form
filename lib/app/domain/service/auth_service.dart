import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static String get userId {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static bool noUserPresent() {
    return FirebaseAuth.instance.currentUser == null;
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final user = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await user?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    if (result.accessToken?.token == null) {
      throw Exception(
        'Facebook login failed: ${result.status} ${result.message}',
      );
    }
    final credential = FacebookAuthProvider.credential(
      result.accessToken!.token,
    );

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
