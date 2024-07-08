import 'dart:io';

import 'package:number_to_words/number_to_words.dart';
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

class PdfInvoiceApiStd {
  static Future<File> generate(Invoice invoice) async {
    final logoImage =
        invoice.logo != "" ? await networkImage('${invoice.logo}') : null;
    final signImage =
        invoice.sign != "" ? await networkImage('${invoice.sign}') : null;
    final sealImage =
        invoice.seal != "" ? await networkImage('${invoice.seal}') : null;
    final themeColor = invoice.themeColor == null || invoice.themeColor == 0
        ? PdfColors.blue50
        : invoice.themeColor == 1
            ? PdfColors.grey300
            : PdfColors.deepOrange300;
    final pdf = Document();
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'GST',
      'Total'
    ];
    final data = invoice.items?.map((item) {
      final total = (item.unitPrice! * item.quantity!) +
          (((item.unitPrice! * item.quantity!) * item.vatType!) / 100);

      return [
        item.description,
        Utils.formatDate(item.date!),
        '${item.quantity}',
        'Rs ${item.unitPrice}',
        '${item.vatType} %',
        'Rs ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    final paymentTerms =
        '${invoice.info!.dueDate!.difference(invoice.info!.date!).inDays} days';
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
          "amount": ((invoice.items![i].unitPrice! * invoice.items![i].quantity!) *
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
                  (((invoice.items![i].unitPrice! * invoice.items![i].quantity!) *
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

    double totalQuantity = 0;
    for (var i = 0; i < invoice.items!.length; i++) {
      totalQuantity += invoice.items![i].quantity!;
    }

    pdf.addPage(MultiPage(
      build: (context) => [
        Column(children: [
          pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black)),
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 1 * PdfPageFormat.cm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        logoImage == null || logoImage == ""
                            ? pw.Container()
                            : Padding(
                                padding: EdgeInsets.all(8),
                                child: pw.Image(logoImage, height: 100),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(invoice.supplier!.name!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            // SizedBox(height: 1 * PdfPageFormat.mm),
                            Text(invoice.supplier!.phone!),
                            //  SizedBox(height: 1 * PdfPageFormat.mm),
                            Text(invoice.supplier!.address!),
                            //  SizedBox(height: 1 * PdfPageFormat.m m),
                            Text(invoice.supplier!.gstin!),
                          ],
                        ),
                        pw.Container(
                            width: 1,
                            height: 100,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(titles.length, (index) {
                                final title = titles[index];
                                final value = infoData[index];

                                return buildText(
                                    title: title, value: value, width: 200);
                              }),
                            ))
                      ],
                    ),
                    //SizedBox(height: 1 * PdfPageFormat.cm),
                    pw.Container(height: 1, color: PdfColors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bill To",
                                    style: TextStyle(color: PdfColors.grey500)),
                                SizedBox(height: 4),
                                Text(invoice.customer!.name!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(invoice.customer!.phone.toString()),
                                Text(invoice.customer!.address!),
                                Text(invoice.customer!.gstin!),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
                Column(children: [
                  pw.Container(height: 1, color: PdfColors.black),
                  pw.Container(
                      decoration: pw.BoxDecoration(color: themeColor),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text("SL. NO."),
                                )),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 3, child: Center(child: Text("ITEMS"))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2, child: Center(child: Text("HSN"))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1, child: Center(child: Text("QTY."))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1, child: Center(child: Text("MRP"))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1, child: Center(child: Text("RATE"))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1, child: Center(child: Text("DISC."))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2, child: Center(child: Text("AMOUNT"))),
                          ])),
                  pw.Container(height: 1, color: PdfColors.black),
                  Column(
                    children: List.generate(
                        invoice.items!.length,
                        (index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text("${index + 1}"),
                                      )),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 3,
                                      child: Center(
                                          child: Text(
                                              "${invoice.items![index].description}"))),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child:
                                              Text("${invoice.items![index].hsn}"))),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                              "${invoice.items![index].quantity}"))),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                              "${invoice.items![index].unitPrice !* invoice.items![index].quantity!}"))),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                              "${invoice.items![index].unitPrice}"))),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 1,
                                      child: Center(child: Text("0.0"))),
                                  pw.Container(
                                      width: 1,
                                      height: 25,
                                      decoration: pw.BoxDecoration(
                                          border: Border.all())),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text(
                                              "${data![index][5]}"))),
                                ])),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(""),
                            )),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 3, child: Center(child: Text(""))),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 2, child: Center(child: Text(""))),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 1, child: Center(child: Text(""))),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 1, child: Center(child: Text(""))),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 1, child: Center(child: Text(""))),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 1, child: Center(child: Text(""))),
                        pw.Container(
                            width: 1,
                            height: 25,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(flex: 2, child: Center(child: Text(""))),
                      ]),

                  Column(
                    children: [
                     Column(
                      children:List.generate(
                        taxes.length,
                        (index) =>
                       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(""),
                                )),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text('GST ${taxes[index]["tax"]} %',
                                        style: pw.TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text('${taxes[index]["amount"]}',
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.grey500)))),
                          ]),),),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(""),
                                )),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text("Discount",
                                        style: pw.TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                        "Rs ${invoice.info!.discount!.toInt()}",
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.grey500)))),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(""),
                                )),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text("Round off",
                                        style: pw.TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text("-",
                                        style: pw.TextStyle(
                                            color: PdfColors.grey500)))),
                            pw.Container(
                                width: 1,
                                height: 25,
                                decoration:
                                    pw.BoxDecoration(border: Border.all())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                        "Rs ${invoice.info!.grandTotal!.toInt()}",
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.grey500)))),
                          ]),
                      pw.Container(height: 1, color: PdfColors.black),
                      pw.Container(
                          decoration: pw.BoxDecoration(color: themeColor),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(""),
                                    )),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 3,
                                    child: Center(
                                        child: Text("TOTAL",
                                            style: pw.TextStyle(
                                                fontWeight: FontWeight.bold)))),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 2, child: Center(child: Text(""))),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text("${totalQuantity.toInt()}",
                                            style: pw.TextStyle(
                                                fontWeight: FontWeight.bold)))),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 1, child: Center(child: Text(""))),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 1, child: Center(child: Text(""))),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text('${invoice.info!.discount}',
                                            style: pw.TextStyle(
                                                fontWeight: FontWeight.bold)))),
                                pw.Container(
                                    width: 1,
                                    height: 25,
                                    decoration:
                                        pw.BoxDecoration(border: Border.all())),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text("Rs ${invoice.info!.grandTotal}",
                                            style: pw.TextStyle(
                                                fontWeight: FontWeight.bold)))),
                              ])),
                      pw.Container(height: 1, color: PdfColors.black),
                    ],
                  )

                  // Table.fromTextArray(
                  //   headers: headers,
                  //   data: data,
                  //   border: null,
                  //   headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  //   headerDecoration: BoxDecoration(color: PdfColors.lightBlue),
                  //   cellHeight: 30,
                  //   cellAlignments: {
                  //     0: Alignment.centerLeft,
                  //     1: Alignment.centerRight,
                  //     2: Alignment.centerRight,
                  //     3: Alignment.centerRight,
                  //     4: Alignment.centerRight,
                  //     5: Alignment.centerRight,
                  //   },
                  // )
                ])
              ])),
          SizedBox(height: 10),
          pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black)),
              child: Column(children: [
                pw.Container(
                  decoration: pw.BoxDecoration(color: themeColor),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Center(
                              child: Text("HSN"),
                            )),
                        pw.Container(
                            width: 1,
                            height: 40,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(
                            flex: 2, child: Center(child: Text("Taxable Value"))),
                        pw.Container(
                            width: 1,
                            height: 40,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(
                            flex: 2,
                            child: Column(children: [
                              Center(child: Text("GST")),
                              pw.Container(height: 1, color: PdfColors.black),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text("Rate"),
                                        )),
                                    pw.Container(
                                        width: 1,
                                        height: 25,
                                        decoration: pw.BoxDecoration(
                                            border: Border.all())),
                                    Expanded(
                                        flex: 1,
                                        child: Center(child: Text("Amount"))),
                                  ])
                            ])),
                       
                        pw.Container(
                            width: 1,
                            height: 40,
                            decoration: pw.BoxDecoration(border: Border.all())),
                        Expanded(
                            flex: 3,
                            child: Center(child: Text("Total Tax Amount"))),
                      ]),
                ),
                pw.Container(height: 1, color: PdfColors.black),
               Column(
                    children: List.generate(
                        invoice.items!.length,
                        (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Center(
                            child: Text("${invoice.items![index].hsn}"),
                          )),
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(flex: 2, child: Center(child: Text("${invoice.items![index].unitPrice! * invoice.items![index].quantity!}"))),
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Text("${invoice.items![index].vatType}%"),
                          )),
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(flex: 1, child: Center(child: Text("${(((invoice.items![index].unitPrice! * invoice.items![index].quantity!) * invoice.items![index].vatType!) / 100)}"))),
                      
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(flex: 3, child: Center(child: Text("${(((invoice.items![index].unitPrice! * invoice.items![index].quantity!) * invoice.items![index].vatType!) / 100)}"))),
                    ]),)),
                pw.Container(height: 1, color: PdfColors.black),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Center(
                            child: Text("Total",
                                style:
                                    pw.TextStyle(fontWeight: FontWeight.bold)),
                          )),
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(flex: 2, child: Center(child: Text("${invoice.info!.total}"))),
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(""),
                          )),
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(flex: 1, child: Center(child: Text("${(invoice.info!.grandTotal!+invoice.info!.discount!)-invoice.info!.total!}"))),
                     
                      pw.Container(
                          width: 1,
                          height: 25,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      Expanded(flex: 3, child: Center(child: Text("Rs ${(invoice.info!.grandTotal!+invoice.info!.discount!)-invoice.info!.total!}"))),
                    ]),
              ])),
          SizedBox(height: 10),
          pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black)),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Amount (in words)",
                                style: TextStyle(color: PdfColors.grey)),
                            pw.SizedBox(height: 4),
                            Text(
                                NumberToWord().convert('en-in',invoice.info!.grandTotal!.toInt()),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            pw.SizedBox(height: 4),
                          ],
                        ))
                  ],
                ),
                pw.Container(height: 1, color: PdfColors.black),
                pw.Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      invoice.seal == null || invoice.seal == ""
                          ? pw.Container()
                          : Padding(
                              padding: EdgeInsets.all(8),
                              child: pw.Column(children: [
                                pw.Text("Company Seal",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Image(sealImage!, height: 80),
                              ]),
                            ),
                      pw.Container(
                          width: 1,
                          height: 120,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      invoice.tnc == null
                          ? pw.Container()
                          : Padding(
                              padding: EdgeInsets.all(8),
                              child: pw.Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Terms & Conditions",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.SizedBox(height: 10),
                                    pw.Text(invoice.tnc!),
                                  ])),
                      pw.Container(
                          width: 1,
                          height: 120,
                          decoration: pw.BoxDecoration(border: Border.all())),
                      invoice.sign == null || invoice.sign == ""
                          ? pw.Container()
                          : Padding(
                              padding: EdgeInsets.all(8),
                              child: pw.Column(children: [
                                pw.Text("Company Sign",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Image(signImage!, height: 80),
                              ])),
                    ])
              ])),
        ])
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
          Text("Join Bills",style: pw.TextStyle(color: PdfColors.blue,fontWeight: FontWeight.bold))
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
