import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class PurchaseReturnProvider extends ChangeNotifier {
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
  List ?_saleReturns;
  double ?_salesTotal = 0.00;
  List ?_searchReturns = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message!;
  }

  List get saleReturns {
    return _saleReturns!;
  }

  List get searchReturns {
    return this._searchReturns!;
  }

  double get saleTotal {
    return _salesTotal!;
  }

  final String? _token;

  PurchaseReturnProvider(this._token);

  Future<void> postSalesReturns(
      {String? billingName,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      String? billingNo,
      double? paid,
      DateTime? date,
      DateTime? invoiceDate,
      String? invoiceNo
      }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('purchaseReturn');
      final response = await users
          .add({
            'user': _token,
            'customer': "$billingName",
            "billing_no":billingNo,
            'customer_id': "$custId",
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'type':"purchase return",
            'paid': grandTotal!+paid!,
            'invoice_date':invoiceDate,
            'invoice_no':invoiceNo
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

  Future<void> editsaleReturn(
      {String? id,
      String? billingName,
      String? custId,
      String? phone,
      List? items,
      double? subTotal,
      double? tax,
      double? grandTotal,
      String? billingNo,
      double? paid,
      DateTime? date,
      DateTime? invoiceDate,
      String? invoiceNo}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('purchaseReturn');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'customer': "$billingName",
            "billing_no":billingNo,
            'customer_id': "$custId",
            'phone': '$phone',
            'items': items,
            'sub_total': subTotal,
            'tax': tax,
            'grand_total': grandTotal,
            'date': date,
            'type':"purchase return",
            'paid': grandTotal!+paid!,
            'invoice_date':invoiceDate,
            'invoice_no':invoiceNo
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
          FirebaseFirestore.instance.collection('purchaseReturn');
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

  Future<void> fetchsaleReturn() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('purchaseReturn')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._saleReturns = value.docs;
        this._searchReturns = this._saleReturns;
        double amount = 0.00;
        for (var i = 0; i < _saleReturns!.length; i++) {
          amount += _saleReturns![i].data()["grand_total"];
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
    _searchReturns = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _saleReturns!.length; i++) {
        print(_saleReturns![i].data()['customer']);
        if (_saleReturns![i].data()['customer'].contains(query.trim())) {
          this._searchReturns!.add(_saleReturns![i]);
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchReturns = this._saleReturns;
      
    }
   

    notifyListeners();
  }

  String setBill({String? prefix, String? number}) {
    int len = number!.length;
    int startNumber = int.parse(number!);
    int billNumber = startNumber + this._saleReturns!.length;
    return '$prefix${billNumber.toString().padLeft(len, '0')}';
  }
}
