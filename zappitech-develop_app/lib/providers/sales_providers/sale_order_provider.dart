import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class SaleOrderProvider extends ChangeNotifier {
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
  List ?_salesOrder;
  double? _salesTotal = 0.00;
  List ?_searchOrders = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message!;
  }

  List? get salesOrder {
    return _salesOrder;
  }

  List get searchOrders {
    return this._searchOrders!;
  }

  double get saleTotal {
    return _salesTotal!;
  }

  final String? _token;

  SaleOrderProvider(this._token);

  Future<void> postSalesOrder(
      {String? billingName,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      String? payMode,
      double? paid,
      DateTime? date,
      DateTime? dueDate}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('salesOrder');
      final response = await users
          .add({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'payment_mode': payMode,
            'paid': paid,
            'due_date':dueDate,
            'type':"sale order",
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

  Future<void> editSalesOrder(
      {String? id,
      String? billingName,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      String? payMode,
      double? paid,
      DateTime? date,
      DateTime? dueDate}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('salesOrder');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'payment_mode': payMode,
            'paid': paid,
            'due_date':dueDate,
            'type':"sale order",
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
          FirebaseFirestore.instance.collection('salesOrder');
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

  Future<void> fetchSalesOrder() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('salesOrder')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._salesOrder = value.docs;
        this._searchOrders = this._salesOrder;
        double amount = 0.00;
        for (var i = 0; i < _salesOrder!.length; i++) {
          amount += _salesOrder![i].data()["grand_total"];
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
    _searchOrders = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _salesOrder!.length; i++) {
        print(_salesOrder![i].data()['customer']);
        if (_salesOrder![i].data()['customer'].contains(query.trim())) {
          this._searchOrders!.add(_salesOrder![i]);
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchOrders = this._salesOrder;
      
    }
   

    notifyListeners();
  }

  String setBill({String? prefix, String? number}) {
    int len = number!.length;
    int startNumber = int.parse(number);
    int billNumber = startNumber + this._salesOrder!.length;
    return '$prefix${billNumber.toString().padLeft(len, '0')}';
  }
}
