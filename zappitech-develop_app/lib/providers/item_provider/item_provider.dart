import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/loadingStates.dart';

class ItemProvider extends ChangeNotifier {
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
  List? _items;
  List? _products = [];
  List? _services = [];
  List? _searchProducts = [];
  List? _searchService = [];
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
    return this._message!;
  }

  List? get  items {
    return this._items;
  }

  List get products {
    return this._products!;
  }

  List get particulars {
    return this._perticulars!;
  }

  List get services {
    return this._services!;
  }

  List get searchProducts {
    return this._searchProducts!;
  }

  List get searchServices {
    return this._searchService!;
  }

  final String? _token;

  ItemProvider(this._token);

  Future<void> postItems(
      {String? itemName,
      double? mrp,
      double? minStock,
      String? itemCategory,
      String? itemCode,
      String? hsnCode,
      double? tax,
      String? taxType,
      double? salePrice,
      String? saleUnit,
      double? purchasePrice,
      String? purchaseUnit,
      double? stock,
      double? conversion,
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      int index = _items
          !.indexWhere((element) => element['item_code_or_barcode'] == itemCode);
      if (index == -1) {
        CollectionReference users =
            FirebaseFirestore.instance.collection('items');
        final response = await users
            .add({
              'user': _token,
              'item_name': "$itemName",
              'item_category': itemCategory,
              'item_code_or_barcode': "$itemCode",
              'hsn_or_sac_code': hsnCode,
              'tax': tax,
              'tax_type': taxType,
              'sale_price': salePrice,
              'primary_unit': saleUnit,
              'purchase_price': purchasePrice,
              'secondary_unit': purchaseUnit,
              'conversion': conversion,
              'stock': stock,
              "opening_stock": stock,
              'date': date,
              'mrp': mrp,
              'minimum_stock': minStock
            })
            .then((value) => setLoadingState(LoadingStates.success))
            .catchError((error) {
              setMessage('Error !');
              print(error);

              setLoadingState(LoadingStates.error);
            });
      } else {
        setMessage('Product already exists');

        setLoadingState(LoadingStates.error);
      }
    } catch (e) {
      setMessage('Error !: $e');

      setLoadingState(LoadingStates.error);
    }
  }

  Future<void> editItems(
      {String? id,
      double? minStock,
      double? mrp,
      String? itemName,
      String? itemCategory,
      String? itemCode,
      String? hsnCode,
      double? tax,
      String? taxType,
      double? salePrice,
      String? saleUnit,
      double? purchasePrice,
      String? purchaseUnit,
      double? conversion,
      double? stock,
      DateTime? date}) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('items');
      final response = await users
          .doc(id)
          .update({
            'user': _token,
            'item_name': "$itemName",
            'item_category': itemCategory,
            'item_code_or_barcode': "$itemCode",
            'hsn_or_sac_code': hsnCode,
            'tax': tax,
            'tax_type': taxType,
            'sale_price': salePrice,
            'primary_unit': saleUnit,
            'purchase_price': purchasePrice,
            'secondary_unit': purchaseUnit,
            'conversion': conversion,
            "opening_stock": stock,
            'date': date,
            'mrp': mrp,
            'minimum_stock': minStock
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

  Future<void> editStock({
    String? id,
    String? barcode,
    bool? isMinus,
    double? stock,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('items');
      int ind = items!.indexWhere((element) =>
          element.data()['item_code_or_barcode'] == barcode?.split('/')[0]);
      final response = await users
          .doc(id)
          .update({
            'stock': isMinus!
                ? items![ind]['stock'] - stock
                : items![ind]['stock'] + stock,
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

  Future<void> deleteItems({
    String? id,
  }) async {
    try {
      setLoadingState(LoadingStates.loading);
      CollectionReference users =
          FirebaseFirestore.instance.collection('items');
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

  Future<void> fetchItems() async {
    try {
      setLoadingState(LoadingStates.loading);

      final response = await FirebaseFirestore.instance
          .collection('items')
          .where('user', isEqualTo: _token)
          .get()
          .then((value) {
        print(value.docs);
        this._items = value.docs;
        this._products = [];
        this._services = [];
        this._searchProducts = this._products;
        this._searchService = this._services;
        if (_items != null) {
          for (var i = 0; i < _items!.length; i++) {
            if (_items![i].data()['item_category'] == 'Product') {
              this._products!.add(_items![i]);
            } else {
              this.services.add(_items![i]);
            }
          }
          this._searchProducts = this._products;
          this._searchService = this._services;
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

  Future<void> fetchLedger({String? itemId, DateTime? from, DateTime? to}) async {
    try {
      setLoadingState(LoadingStates.loading);
      this._perticulars = [];
      List collections = [
        'salesInvoice',
        'saleReturn',
        'purchaseBill',
        'purchaseOrder',
        'purchaseReturn'
      ];
      var response;
      for (int i = 0; i < collections.length; i++) {
        response = await FirebaseFirestore.instance
            .collection(collections[i])
            .where('user', isEqualTo: _token)

            // .where("date", isGreaterThanOrEqualTo: from)
            // .where("date", isLessThanOrEqualTo: to)
            .get()
            .then((value) {
          print(value.docs);
          for (var i = 0; i < value.docs.length; i++) {
            if (value.docs[i].data()['date'].toDate().compareTo(from) > 0 &&
                value.docs[i].data()['date'].toDate().compareTo(to) < 0) {
              for (var j = 0; j < value.docs[i].data()['items'].length; i++) {
                if (value.docs[i].data()['items'][j]["id"] == itemId) {
                  this._perticulars!.add(
                      [value.docs[i].data(), value.docs[i].data()['items'][j]]);
                }
              }
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
          return a[0]['date'].compareTo(b[0]['date']);
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

  void searchItems(String query) {
    print(query);
    this._searchProducts = [];
    this._searchService = [];
    if (query != null || query != '' || query != ' ') {
      print("if");
      for (var i = 0; i < _items!.length; i++) {
        print(_items![i].data()['item_name']);
        if (_items![i].data()['item_name'].contains(query.trim())) {
          print("if2");
          if (_items![i].data()['item_category'] == 'Product') {
            this._searchProducts!.add(_items![i]);
          } else {
            this._searchService!.add(_items![i]);
          }
        } else {
          print("else2");
          continue;
        }
      }
    } else {
      print("else");
      this._searchProducts = this._products;
      this._searchService = this._services;
    }
    print(_searchProducts);
    print(_searchService);

    notifyListeners();
  }
}
