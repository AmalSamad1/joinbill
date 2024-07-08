import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class PaymentOutProvider extends ChangeNotifier {
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

  String? _message = "";
  List? _salesIn;
  double? _salesTotal = 0.00;
  List? _searchIns = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message!;
  }

  List get salesIn {
    return _salesIn!;
  }

  List get searchIns {
    return this._searchIns!;
  }

  double get saleTotal {
    return _salesTotal!;
  }

  final String? _token;

  PaymentOutProvider(this._token);

  Future<void> postSalesIn(
      {String? billingName,
      String? custId,
      String? phone,
      String? description,
      double? paid,
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('paymentOut');
      final response = await users
          .add({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            'phone': '$phone',
            'type':"payment-out",
            'date': date,
            'description': description,
            'paid': paid})
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

  Future<void> editSalesIn(
      {String? id,
      String? billingName,
      String? custId,
      String? phone,
      String? description,
      double? paid,
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('paymentOut');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            'phone': '$phone',
            'date': date,
            'description': description,
            'paid': paid,
            'type':"payment-out",
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
          FirebaseFirestore.instance.collection('paymentOut');
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

  Future<void> fetchSalesIn() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('paymentOut')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._salesIn = value.docs;
        this._searchIns = this._salesIn;
        double amount = 0.00;
        for (var i = 0; i < _salesIn!.length; i++) {
          amount += _salesIn![i].data()["paid"];
        }
        this._salesTotal = amount;
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
    _searchIns = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _salesIn!.length; i++) {
        print(_salesIn![i].data()['customer']);
        if (_salesIn![i].data()['customer'].contains(query.trim())) {
          this._searchIns!.add(_salesIn![i]);
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchIns = this._salesIn;
      
    }
   

    notifyListeners();
  }

  String setBill({String? prefix, String? number}) {
    int len = number!.length;
    int startNumber = int.parse(number);
    int billNumber = startNumber + this._salesIn!.length;
    return '$prefix${billNumber.toString().padLeft(len, '0')}';
  }
}
