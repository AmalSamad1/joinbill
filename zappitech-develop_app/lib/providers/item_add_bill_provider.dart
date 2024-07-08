import 'package:flutter/material.dart';

class ItemAddBill extends ChangeNotifier {
  List _items = [];
  double? _subTotal = 0.00;
  double? _discountPercent = 0.0;
  double? _discountAmount = 0.00;
  double? _taxAmount = 0.00;

  double? _total = 0.00;
  double? _grandTotal = 0.0;
  double? _grandPrice = 0.0;
  double? _grandTax = 0.0;
  double? _grandDiscount = 0.0;

  List get items {
    return _items;
  }

  void setItem(List data) {
    print('startes');
    this._items = data;
    setGrandPrice();
    setGrandTax();
    setGrandTotal();
    notifyListeners();
  }

  void addToItem(
      {String? itemName,
      String? id,
      double? quantity,
      String? unit,
      double? ratePerUnit,
      String? taxType,
      double? subTotal,
      double? discountPercent,
      double? discountAmount,
      String? gstType,
      double? grandDiscount,
      double? gstAmount,
      double? prevStock,
      String? hsn,
      double? total}) {
    print('startes');
    int ind = -1;
    if (_items.isNotEmpty) {
      ind = _items.indexWhere((element) => element['id'] == id);
    }
    if (ind == -1) {
      this._items.add({
        'id': id,
        'item_name': itemName,
        'quantity': quantity,
        'unit': unit,
        'rate_per_unit': ratePerUnit,
        "tax_type": taxType,
        'subtotal': subTotal,
        'discount_percent': discountPercent,
        'discount_amount': discountAmount,
        'gst_type': gstType,
        'gst_amount': gstAmount,
        'prev_stock':prevStock,
        'total': total,
        'hsn': hsn,
      });
    } else {
      this._items[ind] = {
        'id': id,
        'item_name': itemName,
        'quantity': _items[ind]["quantity"] + quantity,
        'unit': unit,
        'rate_per_unit': ratePerUnit,
        "tax_type": taxType,
        'subtotal': _items[ind]["subtotal"] +subTotal,
        'discount_percent': discountPercent,
        'discount_amount': discountAmount,
        'gst_type': gstType,
        'gst_amount': _items[ind]["gst_amount"] + gstAmount,
        'total': _items[ind]["total"] + total,
        'hsn': hsn,
      };
    }

    setGrandPrice();
    setGrandTax();
    setGrandTotal();
    notifyListeners();
  }

  setSubTotal({
    double? quantity,
    double? ratePerUnit,
  }) {
    this._subTotal = ratePerUnit! * quantity!;
    notifyListeners();
  }

  double get subTotal {
    return _subTotal!;
  }

  setDiscountAmount({double? subTotal, double? percent}) {
    this._discountAmount = (percent !* subTotal!) / 100;
    notifyListeners();
  }

  double get discountAmount {
    return _discountAmount!;
  }

  setDiscountPercent({double? subTotal, double? amount}) {
    this._discountPercent = (amount! / subTotal!) * 100;
    notifyListeners();
  }

  double get discountPercent {
    return _discountPercent!;
  }

  setAmountFromGst({String? gstType, double ?subTotal}) {
    double tax = gstType == 'None 0.0 %' ||
            gstType == 'Tax Included' ||
            gstType == 'Exempted 0.0 %'
        ? 0.0
        : double.parse(gstType!.split('%')[1].trim());
    print(tax);
    this._taxAmount = (tax * subTotal!) / 100;
    notifyListeners();
  }

  double get gstAmount {
    return _taxAmount!;
  }

  setTotal({double? discount, double? subTotal}) {
    this._total = (subTotal! + _taxAmount!) - discount!;
    notifyListeners();
  }

  double get total {
    return _total!;
  }

  setGrandDiscount({double? discount}) {
    this._grandDiscount = discount!;
    setGrandTotal();
    notifyListeners();
  }

  double get grandDiscount {
    return _grandDiscount!;
  }

  void deleteFromItem(int index) {
    _items.removeAt(index);
    setGrandPrice();
    setGrandTax();
    setGrandTotal();
    notifyListeners();
  }

  void editItem(
      {String? itemName,
      String? id,
      double? quantity,
      String? unit,
      double? ratePerUnit,
      String? taxType,
      double? subTotal,
      double? discountPercent,
      double? discountAmount,
      String? gstType,
      double? gstAmount,
      double? total,
      String? hsn,
      int? index}) {
    _items[index!] = {
      'id': id,
      'item_name': itemName,
      'quantity': quantity,
      'unit': unit,
      'rate_per_unit': ratePerUnit,
      "tax_type": taxType,
      'subtotal': subTotal,
      'discount_percent': discountPercent,
      'discount_amount': discountAmount,
      'gst_type': gstType,
      'gst_amount': gstAmount,
      'total': total,
      'hsn':hsn
    };

    setGrandPrice();
    setGrandTax();
    setGrandTotal();
    notifyListeners();
  }

  setGrandTotal() {
    double amount = 0.0;
    for (var i = 0; i < _items.length; i++) {
      amount += _items[i]['total'];
    }
    this._grandTotal = amount - _grandDiscount!;
    notifyListeners();
  }

  double get grandTotal {
    return _grandTotal!;
  }

  setGrandPrice() {
    double amount = 0.0;
    for (var i = 0; i < _items.length; i++) {
      amount += _items[i]['subtotal'];
    }
    this._grandPrice = amount - _grandTax!;
    notifyListeners();
  }

  double get grandPrice {
    return _grandPrice!;
  }

  setGrandTax() {
    double amount = 0.0;
    for (var i = 0; i < _items.length; i++) {
      amount += _items[i]['gst_amount'];
    }
    this._grandTax = amount;
    notifyListeners();
  }

  double get grandTax {
    return _grandTax!;
  }

  void reset() {
    _items = [];
    _subTotal = 0.00;
    _discountPercent = 0.0;
    _discountAmount = 0.00;
    _taxAmount = 0.00;
    _total = 0.00;
    _grandTotal = 0.0;
    _grandPrice = 0.0;
    _grandTax = 0.0;
    _grandDiscount = 0.0;
    notifyListeners();
  }
}
