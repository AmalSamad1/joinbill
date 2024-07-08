// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// // creative object (_auth) for firbaseAuth Class using instance
// FirebaseAuth _auth=FirebaseAuth.instance;
// //creative object (googleSignIn) for GoogleSignIn using Constructor of GoogleSignIn
// final GoogleSignIn googleSignIn=GoogleSignIn();
//
// // Creating Variables of the types String for get values like name,email,image from Sign In email Id
// String name;
// String email;
// String imageUrl;
// String uid;
//
// FirebaseAuth get firebaseAuth {
//   if (_auth == null) {
//     _auth = FirebaseAuth.instance;
//   }
//   return _auth;
// }
//
// Stream<User> Function() get authStateChanges => _auth.authStateChanges;
// // Creating a future method called signInWithGoogle for perfoming GoogleSignIn
// // in Your App by multiple users at same time
// Future<String> signInWithGoogle()async{
//   // First initializing Firebase in to your App
//   await Firebase.initializeApp();
//   //Calling signIn method of GoogleSignInClass  using Object of GoogleSignIn
//   // Class googleSignIn and stored in googleSignInAccount
//   final googleSignInAccount= await googleSignIn.signIn();
//   //Storing authentication details  of Signed Account Using object called
//   // googleSignInAccount and stored into googleSignInAuthentication
//   final GoogleSignInAuthentication googleSignInAuthentication=
//   await googleSignInAccount.authentication;
//   //users whether  the sign account is orginal
//   // for that verifying access token and id Tocken of that mail id with
//   // GoogleAuthProvider and check the credentials email id , password
//   // the correct and orginal and storing authCredential object of AuthCredential
//   final AuthCredential authCredential=await GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken
//   );
// //if the account verified  or orginal login the app using the UserCredential email,password and Stored the result in userResult variable
//   final UserCredential userResult=
//   await _auth.signInWithCredential(authCredential);
// //storing detials like,email name,photo from userResult to user object variable
//   final user = userResult.user;
// // if checking user detials
//   if(user!=null){
//     assert(user.displayName!=null);
//     assert(user.email!=null);
//     assert(user.photoURL!=null);
//     assert(user.uid!=null);
//     uid=user.uid;
//     name =user.displayName;
//     email =user.email;
//     imageUrl=user.photoURL;
//     if(name.contains(" ")){
//       name=name;
//     }
//     //check whether user is signed using any other methods other than email
//     assert(!user.isAnonymous);
//     // chech user get idtoken
//     assert(await user.getIdToken()!=null);
//
//     final User currentUser=_auth.currentUser;
//
//     assert(user.uid==currentUser.uid);
//
//     print("signInWithGoogle succeeded: $user");
//     final prefs = await SharedPreferences
//         .getInstance();
//     prefs.setBool("login_status", true);
//     prefs.setString("name",user.displayName.toString(),);
//     prefs.setString("email", user.email.toString());
//     prefs.setString("photo", user.photoURL.toString());
//     print('Successfull');
//
//     return '$user';
//
//   }
//   return '';
// }
//
// Future<void> signOutGoogle() async {
//   await googleSignIn.signOut();
//   print("User Signed Out");
// }
//
//
// // class auth_viewModel {
// //   final FirebaseAuth _firebaseAuth;
// //
// //   auth_viewModel(this._firebaseAuth);
// //
// //   Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();
// //
// //   User? CurrentUser() => _firebaseAuth.currentUser;
// //
// //   Future<User?> AnonymousOrCurrent() async {
// //     if (_firebaseAuth.currentUser == null) {
// //       await _firebaseAuth.signInAnonymously();
// //     }
// //     return _firebaseAuth.currentUser;
// //   }
// //
// //   Future<void> signOut() async {
// //     await _firebaseAuth.signOut();
// //   }
// //
// //   Future<UserCredential> signin({required String email, required String password}) async {
// //     try {
// //       UserCredential userCredential = await FirebaseAuth.instance
// //           .signInWithEmailAndPassword(email: email, password: password);
// //       return userCredential;
// //     } on FirebaseAuthException catch (e) {
// //       if (e.code == 'user-not-found') {
// //         print('No user found for that email.');
// //       } else if (e.code == 'wrong-password') {
// //         print('Wrong password provided for that user.');
// //       }
// //     }
// //     return signin(email: email, password: password);
// //   }
// //
// //   Future<UserCredential> signUp(
// //       {required String email,
// //         required String password,
// //         required String name,
// //         required String phoneNumber,
// //         required String image,
// //         required String uid,
// //         }) async {
// //     if (_firebaseAuth.currentUser!.isAnonymous) {
// //       try {
// //         AuthCredential credential =
// //         EmailAuthProvider.credential(email: email, password: password);
// //         UserCredential result =
// //         await _firebaseAuth.currentUser!.linkWithCredential(credential);
// //         User? user = result.user;
// //
// //         await user_info_viewModel(uid: user?.uid)
// //             .addUserData(name,phoneNumber,email,image, uid);
// //         return result;
// //       } on FirebaseAuthException catch (e) {
// //         if (e.code == 'weak-password') {
// //           print('The password provided is too weak.');
// //         } else if (e.code == 'email-already-in-use') {
// //           print('The account already exists for that email.');
// //         }
// //       } catch (e) {
// //         print(e);
// //       }
// //     } else {
// //       try {
// //         UserCredential result = await _firebaseAuth
// //             .createUserWithEmailAndPassword(email: email, password: password);
// //         User? user = result.user;
// //
// //         await user_info_viewModel(uid: user?.uid)
// //             .addUserData(name,phoneNumber,email,image, uid);
// //         return result;
// //       } on FirebaseAuthException catch (e) {
// //         if (e.code == 'weak-password') {
// //           print('The password provided is too weak.');
// //         } else if (e.code == 'email-already-in-use') {
// //           print('The account already exists for that email.');
// //         }
// //       } catch (e) {
// //         print(e);
// //       }
// //     }
// //     return signUp(email: email, password: password, name: name, phoneNumber: phoneNumber, image: image, uid: uid);
// //   }
//
// // }
