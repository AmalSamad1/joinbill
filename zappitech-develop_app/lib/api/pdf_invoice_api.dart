import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:ziptech/api/pdf_api.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';
import 'package:http/http.dart' show get;
import 'package:printing/printing.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final logoImage =
        invoice.logo != "" ? await networkImage('${invoice.logo}') : null;
    final signImage =
        invoice.sign != "" ? await networkImage('${invoice.sign}') : null;
    final sealImage =
        invoice.seal != "" ? await networkImage('${invoice.seal}') : null;
     final themeColor =invoice.themeColor==null|| invoice.themeColor == 0
        ? PdfColors.red300
        : invoice.themeColor == 1
            ? PdfColors.grey300
            : PdfColors.deepOrange300;
    final pdf = Document();
     final headers = [
      'Description',
      
      'Quantity',
      'Unit Price',
      'GST',
      'Total'
    ];
    final data = invoice.items?.map((item) {
      final total = (item.unitPrice !* item.quantity!) +
          (((item.unitPrice! * item.quantity!) * item.vatType!) / 100);

      return [
        item.description,
       
        '${item.quantity}',
        'Rs ${item.unitPrice}',
        '${item.vatType} %',
        'Rs ${total.toStringAsFixed(2)}',
      ];
    }).toList();

     final paymentTerms = '${invoice.info?.dueDate?.difference(invoice.info!.date!).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
    ];
    final infoData = <String>[
      invoice.info!.number!,
      Utils.formatDate(invoice.info!.date!),
    ];
     List taxes = [];
    print('start');
    for (var i = 0; i < invoice.items!.length; i++) {
      print('for1');
      if (taxes.isEmpty) {
        print('if');
        taxes.add({
          "tax": invoice.items![i].vatType,
          "amount": ((invoice.items![i].unitPrice !* invoice.items![i].quantity!) *
                  invoice.items![i].vatType!) /
              100
        });
      } else {
        bool addLast = true;
        print("else");
        for (var j = 0; j < taxes.length; j++) {
          print("for2");
          print('${invoice.items![i].vatType} & ${taxes[j]["tax"]}');
          if ('${invoice.items![i].vatType}' == '${taxes[j]["tax"]}') {
            addLast = false;
            print('if');
            taxes[j] = {
              "tax": invoice.items![i].vatType,
              "amount": taxes[j]["amount"] +
                  (((invoice.items![i].unitPrice !* invoice.items![i].quantity!) *
                          invoice.items![i].vatType!) /
                      100)
            };
            break;
          }
        }
        if (addLast) {
          print('else');
          taxes.add({
            "tax": invoice.items![i].vatType,
            "amount":
                ((invoice.items![i].unitPrice! * invoice.items![i].quantity!) *
                        invoice.items![i].vatType!) /
                    100
          });
          continue;
        }
      }
      print('for2 end');
    }
    print('for end');
    print(taxes);

    pdf.addPage(MultiPage(
      build: (context) => [
       pw.Container(height: 1, color: PdfColors.black),
       pw.SizedBox(height: 10),
        invoice.logo == null || invoice.logo == ""
            ? pw.Container()
            : pw.Image(logoImage!, height: 100),
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(invoice.supplier!.name!, style: TextStyle(fontWeight: FontWeight.bold)),
        // SizedBox(height: 1 * PdfPageFormat.mm),
        Text(invoice.supplier!.phone!),
        //  SizedBox(height: 1 * PdfPageFormat.mm),
        Text(invoice.supplier!.address!),
        //  SizedBox(height: 1 * PdfPageFormat.mm),
        Text(invoice.supplier!.gstin!),
      ],
    ),
              pw.Container(
                  width: 1,
                  height: 50,
                  decoration: pw.BoxDecoration(border: Border.all())),
             Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = infoData[index];

        return buildText(title: title, value: value, width: 200);
      }),
    )
            ],
          ),
          pw.SizedBox(height: 20),
           pw.Container(height: 1, color: PdfColors.black),
           pw.SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bill To",
                                    style: TextStyle(color: PdfColors.grey500)),
                                SizedBox(height: 4),
          Text(invoice.customer!.name!, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(invoice.customer!.phone!),
          Text(invoice.customer!.address!),
          Text(invoice.customer!.gstin!),
        ],
      )
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 10),
         pw.Container(height: 1, color: PdfColors.black),
         pw.SizedBox(height: 10),
        
        Table.fromTextArray(
      headers: headers,
      data: data!,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: themeColor),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    ),
         pw.Container(height: 1, color: PdfColors.black),
        Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'total',
                  value: Utils.formatPrice(invoice.info!.total!),
                  unite: true,
                ),
                ...taxes
                    .map(((e) => buildText(
                          title: 'GST ${e["tax"]} %',
                          value: Utils.formatPrice(e['amount']),
                          unite: true,
                        )))
                    .toList(),
                 pw.Container(height: 1, color: PdfColors.black),
                buildText(
                  title: 'Discount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(invoice.info!.discount!),
                  unite: true,
                ),
                 pw.Container(height: 1, color: PdfColors.black),
                buildText(
                  title: 'Total amount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(invoice.info!.grandTotal!),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    ),
        pw.SizedBox(height: 20),
        pw.Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              invoice.seal == null || invoice.seal == ""
                  ? pw.Container()
                  : pw.Column(children: [
                      pw.Text("Company Seal",
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Image(sealImage!, height: 80),
                    ]),
              pw.SizedBox(width: 10),
              invoice.sign == null|| invoice.sign == ""
                  ? pw.Container()
                  : pw.Column(children: [
                      pw.Text("Company Sign",
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Image(signImage!, height: 80),
                    ]),
              pw.SizedBox(width: 10),
              invoice.tnc == null
                  ? pw.Container()
                  : pw.Column(children: [
                      pw.Text("Terms & Conditions",
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Text(invoice.tnc!),
                    ]),
            ]),
            
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           pw.Container(height: 1, color: PdfColors.black),
          //SizedBox(height: 2 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            pw.Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              
            children: [

              Text("TAX INVOICE",style: pw.TextStyle(fontWeight: FontWeight.bold)),
              pw.SizedBox(width: 2),
              pw.Container(
                padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                decoration: pw.BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: PdfColors.grey300)
                ),
                child: Text("ORIGINAL FOR RECIPIENT",style: pw.TextStyle(color: PdfColors.grey500)),
              )
            ]
          ),
          Text("ZAPPITECH",style: pw.TextStyle(color: PdfColors.red,fontWeight: FontWeight.bold))
          ])
          
          
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    String? title,
    String? value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title!, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value!),
      ],
    );
  }

  static buildText({
    String? title,
    String? value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title!, style: style)),
          Text(value!, style: unite ? style : null),
        ],
      ),
    );
  }
}
