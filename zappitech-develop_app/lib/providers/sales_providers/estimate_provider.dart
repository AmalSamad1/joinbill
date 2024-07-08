import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class EstimateProvider extends ChangeNotifier {
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
  List? _salesInvoice;
  double? _salesTotal = 0.00;
  List? _searchInvoices = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message!;
  }

  List get salesInvoice {
    return _salesInvoice!;
  }

  List get searchInvoices {
    return this._searchInvoices!;
  }

  double get saleTotal {
    return _salesTotal!;
  }

  final String? _token;

  EstimateProvider(this._token);

  Future<void> postSalesInvoice(
      {String? billingName,
      String? custId,
      String? phone,
      String? invoiceNo,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('estimate');
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
            'invoice_no':invoiceNo,
            'type':"estimate",
            
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

  Future<void> editSalesInvoice(
      {String? id,
      String? billingName,
      String? custId,
      String? phone,
      List ?items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      String? invoiceNo,
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('estimate');
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
            'invoice_no':invoiceNo,
            'type':"estimate",
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
          FirebaseFirestore.instance.collection('estimate');
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

  Future<void> fetchSalesInvoice() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('estimate')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._salesInvoice = value.docs;
        this._searchInvoices = this._salesInvoice;
        double amount = 0.00;
        for (var i = 0; i < _salesInvoice!.length; i++) {
          amount += _salesInvoice![i].data()["grand_total"];
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
    _searchInvoices = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _salesInvoice!.length; i++) {
        print(_salesInvoice![i].data()['customer']);
        if (_salesInvoice![i].data()['customer'].contains(query.trim())) {
          this._searchInvoices!.add(_salesInvoice![i]);
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchInvoices = this._salesInvoice;
      
    }
   

    notifyListeners();
  }

  String setBill({String? prefix, String? number}) {
    int len = number!.length;
    int startNumber = int.parse(number);
    int billNumber = startNumber + this._salesInvoice!.length;
    return '$prefix${billNumber.toString().padLeft(len, '0')}';
  }
}
