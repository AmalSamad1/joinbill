import 'package:ziptech/model/customer.dart';
import 'package:ziptech/model/supplier.dart';

class Invoice {
  final InvoiceInfo? info;
  final Supplier? supplier;
  final Customer? customer;
  final List<InvoiceItem>? items;
  final String? logo;
  final String? seal;
  final String? sign;
  final String? tnc;
  final int? themeColor;
  final int? invoiceTheme;

  const Invoice({
    this.logo,
    this.seal,
    this.sign,
    this.tnc,
    this.info,
    this.supplier,
    this.customer,
    this.items,
    this.themeColor,
    this.invoiceTheme,
  });
}

class InvoiceInfo {
  final String? description;
  final String? number;
  final DateTime? date;
  final DateTime? dueDate;
  final double? discount;
  final double? total;
  final double? grandTotal;

  const InvoiceInfo(
      {this.description,
      this.number,
      this.date,
      this.discount,
      this.dueDate,
      this.grandTotal,
      this.total});
}

class InvoiceItem {
  final String? description;
  final DateTime? date;
  final double? quantity;
  final double? vat;
  final double? vatType;
  final double? unitPrice;
  final String? hsn;

  const InvoiceItem(
      {this.description,
      this.date,
      this.quantity,
      this.vat,
      this.unitPrice,
      this.hsn,
      this.vatType});
}
