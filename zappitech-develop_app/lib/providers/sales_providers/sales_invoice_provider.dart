import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class SalesInvoiceProvider extends ChangeNotifier {
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
  List? _salesInvoice =[];
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

  double? get saleTotal {
    return _salesTotal;
  }

  final String ?_token;

  SalesInvoiceProvider(this._token);

  Future<void> postSalesInvoice(
      {String? billingName,
      String? invoiceNo,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? discount,
      double? tax,
      double? grandTotal,
      String? payMode,
      double? paid,
      DateTime? date,
      double? balance,
      String ?billNo}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('salesInvoice');
      final response = await users
          .add({
            'user': _token,
            'customer': "$billingName",
            "invoice_no":invoiceNo,
            'customer_id': "$custId",
            'bill_number':billNo,
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'payment_mode': payMode,
            'paid': paid,
            'discount': discount,
            'balance':balance,
            'type':"sale invoice",
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
      String? invoiceNo,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      double? discount,
      String? payMode,
      double? paid,
      DateTime? date,
      String? billNo
      }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('salesInvoice');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'customer': "$billingName",
            'customer_id': "$custId",
            "invoice_no":invoiceNo,
            'bill_number':billNo,
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'discount': discount,
            'payment_mode': payMode,
            'paid': paid,
            'type':"sale invoice",
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
          FirebaseFirestore.instance.collection('salesInvoice');
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
          .collection('salesInvoice')
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
