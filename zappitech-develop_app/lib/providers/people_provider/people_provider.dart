import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../helpers/loadingStates.dart';

class PeopleProvider extends ChangeNotifier {
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
  List? _people;
  List? _customers = [];
  List? _suppliers = [];
  List? _searchCustomers = [];
  List? _searchSuppliers = [];
  List? _perticulars = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  setParticular() {
    this._perticulars = [];
    notifyListeners();
  }

  //return message value
  String get message {
    return this._message;
  }

  List get particulars {
    return this._perticulars!;
  }

  List get people {
    return this._people!;
  }

  List get customers {
    return this._customers!;
  }

  List get suppliers {
    return this._suppliers!;
  }

  List get searchCustomers {
    return this._searchCustomers!;
  }

  List get searchSuppliers {
    return this._searchSuppliers!;
  }

  final String? _token;

  PeopleProvider(this._token);

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
      final mountainImagesRef = storageRef.child("people/$name.$extention");

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

  Future<void> postCustomers({
    String? name,
    String? category,
    String? gstin,
    String? balanceType,
    String? gstType,
    String? email,
    String? phone,
    String? address,
    String? state,
    double? balance,
    double? total,
    DateTime? date,
    String? pan,
    String? acc,
    String? ifsc,
    String? upi,
    double? credit,
    DateTime? expiry,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      int index =
          _people!.indexWhere((element) => element.data()['phone'] == phone);
      if (index == -1) {
        CollectionReference users =
            FirebaseFirestore.instance.collection('customers');

        final response = await users
            .add({
              'user': _token,
              'name': "$name",
              'category': category,
              'gstin': gstin,
              'gst_type': gstType,
              'email': email,
              'billing_address': address,
              'phone': phone,
              'state': state,
              'balance': balance,
              'opening_balance': balance,
              'date': date,
              'balance_type': balanceType,
              'total': total,
              "pan": pan,
              'address': address,
              'acc_number': acc,
              'ifsc': ifsc,
              'upi': upi,
              'credit_limit': credit,
              'credit_expiry': expiry,
            })
            .then((value) => setLoadingState(LoadingStates.success))
            .catchError((error) {
              setMessage('Error !');
              print(error);

              setLoadingState(LoadingStates.error);
            });
      } else {
        setMessage('Party already exists');

        setLoadingState(LoadingStates.error);
      }
    } catch (e) {
      setMessage('Error !: $e');

      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> editcutomers(
      {String? id,
      String? name,
      String? category,
      String? gstin,
      String? balanceType,
      String? gstType,
      String? email,
      String? phone,
      String? address,
      String? state,
      double? balance,
      double? total,
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('customers');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'name': "$name",
            'category': category,
            'gstin': gstin,
            'gst_type': gstType,
            'email': email,
            'billing_address': address,
            'phone': phone,
            'state': state,
            'balance': balance,
            'date': date,
            'balance_type': balanceType,
            'total': total,
            'address': address,
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

  Future<void> deletecutomers({
    String? id,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('customers');
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

  Future<void> fetchcutomers() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('customers')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._people = value.docs;
        this._customers = [];
        this._suppliers = [];
        this._searchCustomers = this._customers;
        this._searchSuppliers = this._suppliers;
        if (_people != null) {
          for (var i = 0; i < _people!.length; i++) {
            if (_people![i].data()['category'] == 'Customer') {
              this._customers?.add(_people![i]);
            } else {
              this._suppliers?.add(_people![i]);
            }
          }
          this._searchCustomers = this._customers;
          this._searchSuppliers = this._suppliers;
        }
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

  void searchcutomers(String query) {
    print(query);
    this._searchCustomers = [];
    this._searchSuppliers = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _people!.length; i++) {
        print(_people![i].data()['name']);
        if (_people![i].data()['name'].contains(query.trim())) {
          print("if2");
          if (_people![i].data()['category'] == 'Customer') {
            this._searchCustomers!.add(_people![i]);
          } else {
            this._searchSuppliers!.add(_people![i]);
          }
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchCustomers = this._customers;
      this._searchSuppliers = this._suppliers;
    }
    print(_searchCustomers);
    print(_searchSuppliers);

    notifyListeners();
  }

  Future<void> editBalance({
    String? id,
    String? custId,
    bool? isMinus,
    double? balance,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('customers');
      int ind = people.indexWhere((element) => element.id == custId);
      final response = await users
          .doc(id)
          .update({
            'balance': isMinus!
                ? (people[ind]['balance'] - balance).toStringAsFixed(2)
                : (people[ind]['balance'] + balance).toStringAsFixed(2),
            //'date': date,
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

  Future<void> fetchLedger(
      {String? customer, DateTime? from, DateTime? to}) async {
    try {
      setLoadingState(LoadingStates.loading);
      this._perticulars = [];
      List collections = [
        'salesInvoice',
        'paymentIn',
        'saleReturn',
        'paymentOut',
        'purchaseBill',
        'purchaseOrder',
        'purchaseReturn'
      ];
      var response;
      for (int i = 0; i < collections.length; i++) {
        response = await FirebaseFirestore.instance
            .collection(collections[i])
            .where('user', isEqualTo: _token)
            .where("customer_id", isEqualTo: customer)
            // .where("date", isGreaterThanOrEqualTo: from)
            // .where("date", isLessThanOrEqualTo: to)
            .get()
            .then((value) {
          print(value.docs);
          for (var i = 0; i < value.docs.length; i++) {
            if (value.docs[i].data()['date'].toDate().compareTo(from) > 0 &&
                value.docs[i].data()['date'].toDate().compareTo(to) < 0) {
              this._perticulars!.add(value.docs[i].data());
            }
          }
        }).catchError((error) {
          setMessage('Error !');
          print(error);
          setLoadingState(LoadingStates.error);
        });
      }

      this._perticulars!.sort(
        (a, b) {
          return a['date'].compareTo(b['date']);
        },
      );
      print("********\n${this._perticulars}\n**********");

      setLoadingState(LoadingStates.success);
    } catch (e) {
      setMessage('Error !: $e');

      setLoadingState(LoadingStates.error);
    }
    notifyListeners();
  }
}
