import 'dart:core';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziptech/helpers/loadingStates.dart';
import 'package:ziptech/view/dashboard/dashboard_widget_main.dart';

import '../entry.dart';
import '../view/auth/sign_in/pin_code_verification_screen.dart';

class AuthProvider extends ChangeNotifier {
//handle userid and token
  String? _uid;
  String? _phone;
  Widget? _currentPage;



  //change uid
  setUid(String? id) {
    this._uid = id;
    notifyListeners();
  }

  //return error flag
  String? get uid {
    return _uid;
  }

  setPhone(String? phone) {
    this._phone = phone;
    notifyListeners();
  }

  //return error flag
  String get phone {
    return _phone!;
  }

  setCurrentPage(Widget? page) {
    this._currentPage = page;
    print("*******Page Set\n $_currentPage");
    notifyListeners();
  }

  //return error flag
  Widget? get currentPage {
    return _currentPage;
  }

  Map? _userData;

  setUserData(Map? data) {
    this._userData = data;

    notifyListeners();
  }

  String _smsCode = '';
  //return error flag
  Map? get userData {
    return _userData;
  }

  String get smsCode {
    return _smsCode;
  }

//handle loading

  LoadingStates _loadingState = LoadingStates.inactive;

  //change error flag
  setLoadingState(LoadingStates st) {
    this._loadingState = st;
    notifyListeners();
  }

  //return error flag
  LoadingStates get loadingState {
    return _loadingState;
  }

//handle messages

  String _message = "";

  setSmsCode(String code) {
    this._smsCode = code;
    notifyListeners();
  }

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message;
  }

//handle auth state
  bool get isAuth {
    return _uid != null;
  }

  Future<String?> uploadFile({File? file, String? name}) async {
    String? x;
    try {
      setLoadingState(LoadingStates.loading);
      final storageRef = FirebaseStorage.instance.ref();
      List l = file!.path.split('.');
      String extention = l[l.length - 1];
// Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child("$name.$extention");

// Create a reference to 'images/mountains.jpg'
      final mountainImagesRef = storageRef.child("user/$name.$extention");

// While the file names are the same, the references point to different files
      assert(mountainsRef.name == mountainImagesRef.name);
      assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

      await mountainsRef.putFile(file).catchError((onError) {
        setMessage('Error !');
        print(onError);
        x = "error";
        setLoadingState(LoadingStates.error);
      }).then((value) async {
        x = await mountainsRef.getDownloadURL();
      });
    } catch (e) {
      setMessage('Error !');
      print(e);
      x = "error";
      setLoadingState(LoadingStates.error);
    }
    return x;
  }

  //user signup
  Future<void> signUp({
    String? emailAddress,
    String? password,
    String? name,
    DateTime? dob,
    String? address,
    String? phone,
    String? companyName,
    String? businessType,
    String? upi,
    String? terms,
    String? gstin,
    String? acc,
    String? ifsc,
    File? sign,
    File? seal,
    File? logo,
  }) async {
    try {
      print("********\nsignup\n*********");
      this.setLoadingState(LoadingStates.loading);

      String ?logos = '';
      if (logo != null) {
        logos = await uploadFile(file: logo, name: "${this._uid}_logo");
      }

      String? signature = '';
      if (sign != null) {
        signature = await uploadFile(file: sign, name: "${this._uid}_sign")!;
      }
      String? seals = '';
      if (seal != null) {
        seals = await uploadFile(file: seal, name: "${this._uid}_seal");
      }

      await userCreation(
          name: name!,
          address: address!,
          acc: acc!,
          companyName: companyName!,
          dob: dob!,
          email: emailAddress!,
          gstin: gstin!,
          ifsc: ifsc!,
          phone: phone!,
          businessType: businessType!,
          seal: seals!,
          sign: signature!,
          terms: terms!,
          upi: upi!,
          logo: logos!);

      setLoadingState(LoadingStates.success);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("********\n${e.code}\n*********");
        setMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print("********\n${e.code}\n*********");
        setMessage('The account already exists for this email.');
      } else if (e.code == 'network-request-failed') {
        print("********\n${e.code}\n*********");
        setMessage('Request failed');
      }

      setLoadingState(LoadingStates.error);
    } catch (e) {
      print(e);
      print("********\n$e\n*********");
      setMessage('$e');
      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> changeEmail({String? emailAddress, String? password}) async {
    try {
      print("********\nemailChange\n*********");
      this.setLoadingState(LoadingStates.loading);
      if (_userData!['email'] != emailAddress) {
        signIn(emailAddress: _userData!['email'], password: password!)
            .then((value) async {
          print("login success");
          final credential = await FirebaseAuth.instance.currentUser
              !.updateEmail(emailAddress!)
              .then((value) async {
            print("email updated");
            CollectionReference users =
                FirebaseFirestore.instance.collection('users');

            await users
                // existing document in 'users' collection: "uid"
                .doc('$_uid')
                .update(
              {
                'email': "$emailAddress",
              },
            ).then((_) {
              print("done");
              setLoadingState(LoadingStates.success);
            });
          }).catchError((e) {
            print("error: $e");
            setMessage('error: $e');
            setLoadingState(LoadingStates.error);
          });
        });
      } else {
        print("done");
        setLoadingState(LoadingStates.success);
      }
    } on FirebaseAuthException catch (e) {
      setMessage('error: $e');

      setLoadingState(LoadingStates.error);
    } catch (e) {
      print(e);
      print("********\n$e\n*********");
      setMessage('$e');
      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> passwordReset({
    String? emailAddress,
  }) async {
    try {
      print("********\nsignup\n*********");
      this.setLoadingState(LoadingStates.loading);
      final credential = await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: "$emailAddress",
            //actionCodeSettings: ActionCodeSettings(androidPackageName:'com.zappitech.zappi_tech',url: 'https://belstacks.com' )
          )
          .then((value) => setLoadingState(LoadingStates.success))
          .catchError((e) {
        setMessage('error: $e');
        setLoadingState(LoadingStates.error);
      });
    } on FirebaseAuthException catch (e) {
      setMessage('error: $e');
      setLoadingState(LoadingStates.error);
    } catch (e) {
      print(e);
      print("********\n$e\n*********");
      setMessage('$e');
      setLoadingState(LoadingStates.error);
    }
  }

//user creation

  Future<void> userCreation(
      {String? name,
      DateTime? dob,
      String? address,
      String? phone,
      String? companyName,
      String? gstin,
      String? acc,
      String? ifsc,
      String? email,
      String? businessType,
      String? upi,
      String? terms,
      String? sign,
      String? seal,
      String? logo}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users
          // existing document in 'users' collection: "uid"
          .doc('$_uid')
          .set(
        {
          'id': '$_uid',
          'full_name': "$name",
          'date_of_birth': dob,
          'address': '$address',
          'created_at': DateTime.now(),
          'phone_number': '$_phone',
          'expiry': DateTime.now().subtract(Duration(days: 1)),
          'company_details': {
            'logo': logo,
            'company_name': "$companyName",
            'gstin': "$gstin",
            'account_no': '$acc',
            'ifsc_code': '$ifsc',
            'business_type': businessType,
            'upi': upi,
            'terms_and_conditions': terms,
            'sign': sign,
            'seal': seal
          },
          'invoice_theme': 0,
          'theme_color': 0,
          'email': "$email",
          'is_payed': false,
          'billing_settings': {
            'sales_invoice': {
              'prefix': "",
              "starting_number": "001",
              'current_number': "001",
              'is_reset': true
            },
            'sales_return': {
              'prefix': "",
              "starting_number": "001",
              'current_number': "001",
              'is_reset': true
            },
            'sales_estimate': {
              'prefix': "",
              "starting_number": "001",
              'current_number': '001',
              'is_reset': true
            },
            'purchase_bill': {
              'prefix': "",
              "starting_number": "001",
              'current_number': "001",
              'is_reset': true
            },
            'purchase_order': {
              'prefix': "",
              "starting_number": "001",
              'current_number': "001",
              'is_reset': true
            },
            'purchase_return': {
              'prefix': "",
              "starting_number": "001",
              'current_number': '001',
              'is_reset': true
            },
          }
        },
        SetOptions(merge: true),
      ).then((value) {
        print("*****\nsuccessfully created user\n*****");
        setLoadingState(LoadingStates.success);
      }).catchError((error) {
        print("Failed to merge data: $error");
        setMessage('xxxxx\nuser creation failed\nxxxxxx');
        setLoadingState(LoadingStates.error);
      });
    } catch (e) {
      print("Failed to merge data: $e");
      setMessage('xxxxx\n$e\nxxxxxx');
      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> userEdit(
      {String? name,
      DateTime? dob,
      String? address,
      String? phone,
      String? companyName,
      String? gstin,
      String? acc,
      String? ifsc,
      String? email,
      String? businessType,
      String? upi,
      String? terms,
      File? sign,
      File? seal,
      int? themeColor,
      int? invoiceTheme,
      File? logo,
      Map? billingSettings}) async {
    try {
      String? logos = _userData!["company_details"]["logo"];
      if (logo != null) {
        logos = await uploadFile(file: logo, name: "${this._uid}_logo");
      }

      String? signature = _userData!["company_details"]["sign"];
      if (sign != null) {
        signature = await uploadFile(file: sign, name: "${this._uid}_sign");
      }
      String? seals = _userData!["company_details"]["seal"];
      if (seal != null) {
        seals = await uploadFile(file: seal, name: "${this._uid}_seal");
      }
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users
          // existing document in 'users' collection: "uid"
          .doc('$_uid')
          .update(
        {
          'id': '$_uid',
          'full_name': "$name",
          'date_of_birth': dob,
          'address': '$address',
          'phone_number': '$phone',
          'company_details': {
            'logo': logos,
            'company_name': "$companyName",
            'gstin': "$gstin",
            'account_no': '$acc',
            'ifsc_code': '$ifsc',
            'business_type': businessType,
            'upi': upi,
            'terms_and_conditions': terms,
            'sign': signature,
            'seal': seals
          },
          'invoice_theme': invoiceTheme,
          'theme_color': themeColor,
          'email': "$email",
          'billing_settings': billingSettings
        },
      ).then((value) {
        print("*****\nsuccessfully created user\n*****");
        setLoadingState(LoadingStates.success);
      }).catchError((error) {
        print("Failed to merge data: $error");
        setMessage('xxxxx\nuser creation failed\nxxxxxx');
        setLoadingState(LoadingStates.error);
      });
    } catch (e) {
      print("Failed to merge data: $e");
      setMessage('xxxxx\n$e\nxxxxxx');
      setLoadingState(LoadingStates.error);
    }
  }

  //user login
  Future<void> signIn({String? emailAddress, String? password}) async {
    try {
      print("********\nsignin\n*********");
      this.setLoadingState(LoadingStates.loading);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$emailAddress", password: "$password");
      print('*****\n${credential.user!.uid}\n*****');
      setUid(credential.user!.uid);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', '$_uid');
      setLoadingState(LoadingStates.success);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("********\n${e.code}\n*********");
        setMessage('User not found.');
      } else if (e.code == 'wrong-password') {
        print("********\n${e.code}\n*********");
        setMessage('Invalid credentials');
      } else if (e.code == 'network-request-failed') {
        print("********\n${e.code}\n*********");
        setMessage('Request failed');
      }

      setLoadingState(LoadingStates.error);
    } catch (e) {
      print(e);
      print("********\n$e\n*********");
      setMessage('$e');
      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> signInOtp({String? phone, BuildContext? context}) async {
    try {
      print("********\nsigninOtp\n*********");
      this.setLoadingState(LoadingStates.loading);
      print(phone);
      String? _verificationId = "";
      int ?_resendToken;
      FirebaseAuth auth = FirebaseAuth.instance;

      if (kIsWeb) {
        ConfirmationResult confirmationResult =
            await auth.signInWithPhoneNumber(
          phone!,
        );
        setLoadingState(LoadingStates.success);
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => PinCodeVerificationScreen(
                phoneNumber: phone,
                signin: () async {
                  setLoadingState(LoadingStates.loading);

                  UserCredential? userCredential = await confirmationResult
                      .confirm(_smsCode)
                      .then((UserCredential result) async {
                    print("--------code sent----------");
                    print(result.user!.uid);
                    print('*****\n${result.user!.uid}\n*****');
                    setUid(result.user!.uid);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('token', '$_uid');
                    if (result.additionalUserInfo!.isNewUser) {
                      await userCreation(
                          name: '',
                          address: "",
                          acc: "",
                          companyName: "",
                          dob: DateTime.now(),
                          email: "",
                          gstin: "",
                          ifsc: "",
                          phone: phone,
                          businessType: "",
                          seal: "",
                          sign: "",
                          terms: "",
                          upi: "",
                          logo: "");
                    }
                    setLoadingState(LoadingStates.success);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Entry(),
                      ),
                    );
                  }).catchError((e) {
                    setLoadingState(LoadingStates.error);
                    Fluttertoast.showToast(msg: "$e");
                  });
                }),
          ),
        );
        // UserCredential userCredential = await confirmationResult.confirm('000000');
      } else {
        final credential = await auth.verifyPhoneNumber(
          phoneNumber: '$phone',
          // verificationCompleted: (PhoneAuthCredential credential) async {
          //   print("Verifiction Completed");
          //   // ANDROID ONLY!
          //   setSmsCode(credential.smsCode);
          //   // Sign the user in (or link) with the auto-generated credential
          //   setLoadingState(LoadingStates.loading);
          //   await auth
          //       .signInWithCredential(credential)
          //       .then((UserCredential result) async {
          //     print("--------***----------");
          //     //print(result.user.uid);
          //     print(result.user.uid);

          //     print('*****\n${result.user.uid}\n*****');
          //     setUid(result.user.uid);
          //     final prefs = await SharedPreferences.getInstance();
          //     await prefs.setString('token', '$_uid');
          //     setLoadingState(LoadingStates.success);
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => Entry(),
          //       ),
          //     );
          //   }).catchError((e) {
          //     print(e);
          //     setLoadingState(LoadingStates.error);
          //     Fluttertoast.showToast(msg: "$e");
          //   });
          // },
          verificationFailed: (FirebaseAuthException e) {
            print("Verifiction Failed");
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is invalid.');
              setLoadingState(LoadingStates.error);
              Fluttertoast.showToast(msg: "$e");
            } else {
              print("--------***----------");
              print(e);
              setLoadingState(LoadingStates.error);
              Fluttertoast.showToast(msg: "$e");
            }

            // Handle other errors
          },
          codeSent: (String? verificationId, int ?resendToken) async {
            // Update the UI - wait for the user to enter the SMS code
            print("Code sent");
            _verificationId = verificationId!;
            _resendToken = resendToken!;
            setLoadingState(LoadingStates.success);
            Navigator.push(
              context!,
              MaterialPageRoute(
                builder: (context) => PinCodeVerificationScreen(
                    phoneNumber: phone!,
                    signin: () async {
                      setLoadingState(LoadingStates.loading);
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: _smsCode);

                      await auth
                          .signInWithCredential(credential)
                          .then((UserCredential result) async {
                        print("--------code sent----------");
                        print(result.user!.uid);
                        print('*****\n${result.user!.uid}\n*****');
                        setUid(result.user!.uid);
                        setPhone(phone);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('token', '$_uid');
                        await prefs.setString('phone', '$phone');
                        setLoadingState(LoadingStates.success);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Entry(),
                          ),
                        );
                      }).catchError((e) {
                        setLoadingState(LoadingStates.error);
                        Fluttertoast.showToast(msg: "$e");
                      });
                    }),
              ),
            );
            // Create a PhoneAuthCredential with the code
          },
          forceResendingToken: _resendToken,
          codeAutoRetrievalTimeout: (String verificationId) {
            print("--------retrieval timeout----------");
            print(verificationId);
            Fluttertoast.showToast(msg: "Autofetch timed out");
          }, verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("********\n${e.code}\n*********");
        setMessage('User not found.');
      } else if (e.code == 'wrong-password') {
        print("********\n${e.code}\n*********");
        setMessage('Invalid credentials');
      } else if (e.code == 'network-request-failed') {
        print("********\n${e.code}\n*********");
        setMessage('Request failed');
      }

      setLoadingState(LoadingStates.error);
    } catch (e) {
      print(e);
      print("********\n$e\n*********");
      setMessage('$e');
      setLoadingState(LoadingStates.error);
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is invalid.');
    } else {
      print("--------***----------");
      print(e);
    }

    // Handle other errors
  }

//save login deatails

  Future<void> autoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token')!;
      final String? phone = prefs.getString('phone')!;
      if (token != null) {
        print("*****\n$token\n*****");
        setUid(token);
        setPhone(phone!);
      } else {
        setUid(null);
        setPhone(null);
      }
    } catch (e) {
      print('xxxxx\nfetching token error: $e\nxxxxx');
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    this._uid = null;
    this._userData = null;
    final success = await prefs.remove('token');
    setUid(null);
    setCurrentPage(null);
    notifyListeners();
  }

  Future<void> fetchUser() async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final response = await users.doc("$_uid").get().then((value) {
        if (value.exists) {
          print("*****\n${value.data()}\n*****");
          setUserData(value.data() as Map?);
          print(_userData);
          print(_userData!["company_details"]["logo"]);
          setLoadingState(LoadingStates.success);
        } else {
          setMessage('User do not exist');
          print("*********\nUser do not exist\n************");

          setLoadingState(LoadingStates.error);
        }
      });
    } catch (e) {
      setMessage('Fetching user failed: $e');

      setLoadingState(LoadingStates.error);
    }
    // notifyListeners();
  }
  Future<void> registerWithEmailAndPassword(email,password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User registration successful, you can handle the userCredential object here.
    } catch (e) {
      // Handle errors here, such as displaying error messages to the user.
      print('Error registering user: $e');
    }
  }
  Future<void> editPayed({
    bool? isPayed,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final response = await users
          .doc(_uid)
          .update({
            'is_payed': isPayed,
            'expiry': DateTime.now().add(Duration(days: 365))
          })
          .then((value) => setLoadingState(LoadingStates.success))
          .catchError((error) {
            setMessage('Error !');
            print(error);

            setLoadingState(LoadingStates.error);
          });
    } catch (e) {
      setMessage('Error !: $e');

      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> billNumberUpdate(
      {String? name,
      DateTime? dob,
      String? address,
      String? phone,
      String? companyName,
      String? gstin,
      String? acc,
      String? ifsc,
      String? email,
      bool? isPayed,
      int? themeColor,
      int? invoiceTheme,
      Map? billingSettings}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users
          // existing document in 'users' collection: "uid"
          .doc('$_uid')
          .update(
        {
          'id': '$_uid',
          'full_name': "$name",
          'date_of_birth': dob,
          'address': '$address',
          'phone_number': '+91$phone',
          'company_details': {
            'company_name': "$companyName",
            'gstin': "$gstin",
            'account_no': '$acc',
            'ifsc_code': '$ifsc',
          },
          'invoice_theme': invoiceTheme,
          'theme_color': themeColor,
          'email': "$email",
          'is_payed': isPayed,
          'billing_settings': billingSettings
        },
      ).then((value) {
        print("*****\nsuccessfully created user\n*****");
        setLoadingState(LoadingStates.success);
      }).catchError((error) {
        print("Failed to merge data: $error");
        setMessage('xxxxx\nuser creation failed\nxxxxxx');
        setLoadingState(LoadingStates.error);
      });
    } catch (e) {
      print("Failed to merge data: $e");
      setMessage('xxxxx\n$e\nxxxxxx');
      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> createQr(code) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference qrLogin =
          FirebaseFirestore.instance.collection('Qr_login');
      await qrLogin
          // existing document in 'users' collection: "uid"
          .doc(code)
          .update(
        {
          'token': '${this._uid}',
        },
      ).then((value) {
        print("*****\nsuccessfully created qr\n*****");

        setLoadingState(LoadingStates.success);
      }).catchError((error) {
        print("Failed to generate qr: $error");
        setMessage('Failed to generate qr');
        setLoadingState(LoadingStates.error);
      });
    } catch (e) {
      print("Failed to generate : $e");
      setMessage('Failed to generate qr');
      setLoadingState(LoadingStates.error);
    }
  }
}

enum Pages {
  dashboard,
  ledgerList,
  support,
  expenseList,
  expenseAdd,
  itemAdd,
  itemList,
  itemLedger,
  partyAdd,
  partyList,
  partySummery,
  accountDetails,
  accountEdit,
  companyEdit,
  invoiceThemes,
  profile,
  settings,
  paymentOutAdd,
  paymentOutList,
  purchaseBillAdd,
  purchaseBillList,
  purchaseMain,
  purchaseOrderAdd,
  purchaseOrderList,
  purchaseReturnAdd,
  purchaseReturnList,
  salesEstimateList,
  salesEstimateAdd,
  paymentInAdd,
  paymentInList,
  saleInvoiceAdd,
  saleInvoiceList,
  saleOrderAdd,
  saleOrderList,
  saleReturnAdd,
  saleReturnList,
  salesMain
}
