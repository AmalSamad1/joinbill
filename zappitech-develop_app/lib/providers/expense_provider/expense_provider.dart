import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/helpers/loadingStates.dart';

class ExpenseProvider extends ChangeNotifier {
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
  List _expenses = [];
  double _expenseTotal = 0.00;
  List _searchExpenses = [];

  //change message value
  setMessage(String msg) {
    this._message = msg;
    notifyListeners();
  }

  //return message value
  String get message {
    return _message;
  }

  List get expenses {
    return this._expenses;
  }

  List get searchExpenses {
    return this._searchExpenses;
  }

  double get expenseTotal {
    return _expenseTotal;
  }

  final String? _token;

  ExpenseProvider(this._token);

  Future<void> postExpense(
      {String? type,
      String? typeId,
      double? total,
      DateTime? date,
      String? discription}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('expense');
      final response = await users
          .add({
            'user': _token,
            'type': "$type",
            'type_id': "$typeId",
            'grand_total': total,
            'date': date,
            'description': discription
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

  Future<void> editExpense(
      {String? type,
      String? typeId,
      String? id,
      double? total,
      DateTime? date,
      String? discription}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('expense');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'type': "$type",
            'type_id': "$typeId",
            'grand_total': total,
            'date': date,
            'description': discription
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
          FirebaseFirestore.instance.collection('expense');
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

  Future<void> fetchExpenses() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('expense')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._expenses = value.docs;
        this._searchExpenses = this._expenses;
        double amount = 0.00;
        for (var i = 0; i < _searchExpenses.length; i++) {
          amount += _searchExpenses[i].data()["grand_total"];
        }
        this._expenseTotal = amount;
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
    _searchExpenses = [];
    if (query == 'All Expenses') {
      print("all");
      this._searchExpenses = this._expenses;
      double amount = 0.00;
      for (var i = 0; i < _searchExpenses.length; i++) {
        amount += _searchExpenses[i].data()["grand_total"];
      }
      this._expenseTotal = amount;
      notifyListeners();
    } else if (query != null || query != '') {
      print("if");
      for (var i = 0; i < _expenses.length; i++) {
        if (_expenses[i].data()['type'].contains(query.trim())) {
          this._searchExpenses.add(_expenses[i]);
        } else {
          print("else2");
          continue;
        }
      }
      double amount = 0.00;
      if (_searchExpenses.isNotEmpty) {
        for (var i = 0; i < _searchExpenses.length; i++) {
          amount += _searchExpenses[i].data()["grand_total"];
        }
        this._expenseTotal = amount;
        notifyListeners();
      }
    } else {
      print("else");
      this._searchExpenses = this._expenses;
      double amount = 0.00;
      for (var i = 0; i < _searchExpenses.length; i++) {
        amount += _searchExpenses[i].data()["grand_total"];
      }
      this._expenseTotal = amount;
      notifyListeners();
    }

    notifyListeners();
  }

  // String setBill({String prefix, String number}) {
  //   int len = number.length;
  //   int startNumber = int.parse(number);
  //   int billNumber = startNumber + this._purchaseInvoice.length;
  //   return '$prefix${billNumber.toString().padLeft(len, '0')}';
  // }
}
