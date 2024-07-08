import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class PurchaseBillProvider extends ChangeNotifier {
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
  List ?_purchaseInvoice;
  double? _purchaseTotal = 0.00;
  List? _searchInvoices = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message;
  }

  List get purchaseInvoice {
    return _purchaseInvoice!;
  }

  List get searchInvoices {
    return this._searchInvoices!;
  }

  double get saleTotal {
    return _purchaseTotal!;
  }

  final String? _token;

  PurchaseBillProvider(this._token);

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
      final mountainImagesRef = storageRef.child("images/$name.$extention");

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

  Future<void> postpurchaseInvoice(
      {String? billingName,
      String? custId,
      String? phone,
      File? file,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      double? discount,
      String? payMode,
      double? paid,
      DateTime? date,
      String? billingNo}) async {
    try {
      setLoadingState(LoadingStates.loading);
      String? attachments = '';
      if (file != null) {
         attachments = await uploadFile(file: file, name: billingNo);
      }
      CollectionReference users =
          FirebaseFirestore.instance.collection('purchaseBill');
      final response = await users
          .add({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            "billing_no": billingNo,
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'payment_mode': payMode,
            'paid': paid,
            'discount': discount,
            'attachments': attachments,
            'type':"purchase bill",
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

  Future<void> editpurchaseInvoice(
      {String? id,
      String? billingName,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      String? payMode,
      double? discount,
      double? paid,
      DateTime? date,
      String? billingNo}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('purchaseBill');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            "billing_no": billingNo,
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'payment_mode': payMode,
            'paid': paid,
            'discount': discount,
            'type':"purchase bill",
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

  Future<void> deleteItems({
    String? id,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('purchaseBill');
      final response = await users
          .doc(id)
          .delete()
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

  Future<void> fetchpurchaseInvoice() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('purchaseBill')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._purchaseInvoice = value.docs;
        this._searchInvoices = this._purchaseInvoice;
        double amount = 0.00;
        for (var i = 0; i < _purchaseInvoice!.length; i++) {
          amount += _purchaseInvoice![i].data()["grand_total"];
        }
        this._purchaseTotal = amount;
        setLoadingState(LoadingStates.success);
      }).catchError((error) {
        setMessage('Error !');
        print(error);

        setLoadingState(LoadingStates.error);
      });
    } catch (e) {
      setMessage('Error !: $e');

      setLoadingState(LoadingStates.error);
    }
    notifyListeners();
  }

  void searchItems(String query) {
    print(query);
    _searchInvoices = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _purchaseInvoice!.length; i++) {
        print(_purchaseInvoice![i].data()['customer']);
        if (_purchaseInvoice![i].data()['customer'].contains(query.trim())) {
          this._searchInvoices!.add(_purchaseInvoice![i]);
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchInvoices = this._purchaseInvoice;
    }

    notifyListeners();
  }

  String setBill({String? prefix, String? number}) {
    int len = number!.length;
    int startNumber = int.parse(number);
    int billNumber = startNumber + this._purchaseInvoice!.length;
    return '$prefix${billNumber.toString().padLeft(len, '0')}';
  }
}
