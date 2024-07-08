import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ziptech/api/pdf_invoice_std.dart';

import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;



class ButtonWidget extends StatelessWidget {
  final String? text;
  final VoidCallback ?onClicked;

  const ButtonWidget({
    Key? key,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(40),
        ),
        child: FittedBox(
          child: Text(
            text!,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        onPressed: onClicked,
      );
}

class IconButtonWidget extends StatelessWidget {
  final String? text;
  final VoidCallback? onClicked;

  const IconButtonWidget({
    Key? key,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(Icons.picture_as_pdf,color: FlutterFlowTheme.of(context).primaryColor),
        onPressed: onClicked,
      );
}

Future<void> getPdf({
  String? customerName,
  String? customerAddress,
  String? custgst,
  String? custPhone,
  String? ourCompany,
  String? ourAddress,
  String? ourGst,
  String? ourPhone,
  DateTime? invDate,
  String? description,
  String? invNo,
  List? items,
  double? discount,
  double? total,
  double? grandTotal,
  String? logo,
  String? seal,
  String? sign,
  String? tnc,
  int? themeColor,
  int? invoiceTheme,
}) async {
  final date = invDate;
  final dueDate = date!.add(Duration(days: 7));

  final invoice = Invoice(
      invoiceTheme: invoiceTheme,
      themeColor: themeColor,
      logo: logo,
      seal: seal,
      sign: sign,
      tnc: tnc,

      supplier: Supplier(
          name: '$ourCompany',
          address: '$ourAddress',
          paymentInfo: '',
          gstin: ourGst,
          phone: ourPhone),
      customer: Customer(
          name: '$customerName',
          address: customerAddress,
          gstin: custgst,
          phone: custPhone),
      info: InvoiceInfo(
          date: invDate,
          dueDate: dueDate,
          description: '$description',
          number: '$invNo',
          discount: discount,
          grandTotal: grandTotal,
          total: total),
      items: List.generate(items!.length, (index) {
        return InvoiceItem(
          description: items[index]['item_name'].split('/')[1],
          date: invDate,
          hsn: items[index]['hsn'],
          quantity: items[index]['quantity'],
          vat: items[index]['gst_amount'],
          vatType: items[index]["gst_type"] == 'None 0.0 %' ||
                  items[index]["gst_type"] == 'Tax Included' ||
                  items[index]["gst_type"] == 'Exempted 0.0 %'
              ? 0.0
              : double.parse(items[index]["gst_type"].split('%')[1].trim()),
          unitPrice: items[index]['rate_per_unit'],
        );
      })

      //   [

      //    InvoiceItem(
      //      description: 'Water',
      //      date: DateTime.now(),
      //      quantity: 8,
      //      vat: 0.19,
      //      unitPrice: 0.99,
      //    ),
      //    InvoiceItem(
      //      description: 'Orange',
      //      date: DateTime.now(),
      //      quantity: 3,
      //      vat: 0.19,
      //      unitPrice: 2.99,
      //    ),
      //    InvoiceItem(
      //      description: 'Apple',
      //      date: DateTime.now(),
      //      quantity: 8,
      //      vat: 0.19,
      //      unitPrice: 3.99,
      //    ),
      //    InvoiceItem(
      //      description: 'Mango',
      //      date: DateTime.now(),
      //      quantity: 1,
      //      vat: 0.19,
      //      unitPrice: 1.59,
      //    ),
      //    InvoiceItem(
      //      description: 'Blue Berries',
      //      date: DateTime.now(),
      //      quantity: 5,
      //      vat: 0.19,
      //      unitPrice: 0.99,
      //    ),
      //    InvoiceItem(
      //      description: 'Lemon',
      //      date: DateTime.now(),
      //      quantity: 4,
      //      vat: 0.19,
      //      unitPrice: 1.29,
      //    ),
      //  ],
      );
  print(invoice.customer!.address);
  print(invoice.supplier!.address);
  final pdfFile = invoiceTheme == null || invoiceTheme == 0
      ? await PdfInvoiceApiStd.generate(invoice)
      : await PdfInvoiceApi.generate(invoice);
  
    PdfApi.openFile(pdfFile);
  
  
}
