import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FireAuth {
  // For registering a new user
  static Future<User> registerUsingEmailPassword({
     String? name,
     String? email,
     String? password,
    String? phonenumber,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      user = userCredential.user!;
      await user.updateProfile(displayName: name);
      await user.reload();
      final prefs = await SharedPreferences
          .getInstance();
      prefs.setBool("login_status", true);
      prefs.setString("name",user.displayName.toString(),);
      prefs.setString("email", user.email.toString());
      prefs.setString("photo", user.photoURL.toString());
      print('Successfull');
      user = auth.currentUser!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user!;
  }

  // For signing in an user (have already registered)
  static Future<User> signInUsingEmailPassword({
     String? email,
     String? password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      user = userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user!;
  }

  static Future<User> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User refreshedUser = auth.currentUser!;

    return refreshedUser;
  }
}