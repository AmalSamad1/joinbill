import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ziptech/flutter_flow/flutter_flow_util.dart';

import '../../model/invoice.dart';
import '../../utils.dart';

class InvoiceModern extends StatefulWidget {
  const InvoiceModern({Key? key}) : super(key: key);

  @override
  State<InvoiceModern> createState() => _InvoiceModernState();
}

class _InvoiceModernState extends State<InvoiceModern> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Divider(),
       Image(image: AssetImage("assets/images/logo.png"), height: 100),
        buildHeader(),
        Divider(),
        buildTitle(),
      //  buildInvoice(),
        Divider(),
      //   buildTotal( Invoice(
      
      // items: [InvoiceItem(
      // date: DateTime.now(),
      // description: "Product 1",
      // quantity: 4,
      // unitPrice: 200,
      // vat: 12,
      // vatType: 12,
      
      // ),
      // InvoiceItem(
      // date: DateTime.now(),
      // description: "Product 2",
      // quantity: 2,
      // unitPrice: 500,
      // vat: 12,
      // vatType: 12,
      
      // ),
      // ])),
        SizedBox(height: 20),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Column(children: [
                      Text("Company Seal",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                     Image(image: AssetImage("assets/images/logo.png"), height: 80),
                    ]),
              SizedBox(width: 10),
              Column(children: [
                      Text("Company Sign",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                     Image(image: AssetImage("assets/images/logo.png"), height: 80),
                    ]),
              SizedBox(width: 10),
              Column(children: [
                      Text("Terms & Conditions",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("No Discount..\nNo Return..\nPlease Check The Product.."),
                    ]),
            ]),
            buildFooter( )
      ]),
    );
  }
}

 Widget buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(),
              Container(
                  width: 1,
                  height: 50,
                  decoration: BoxDecoration(border: Border.all())),
              buildInvoiceInfo(),
            ],
          ),
          SizedBox(height: 1 ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(),
            ],
          ),
        ],
      );

   Widget buildCustomerAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer Name", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("+91 00000 00000"),
          Text("Line 1,\nLine 2,\nStreet,\nDistrict, State, India "),
          Text("GST-IN : "),
        ],
      );

   Widget buildInvoiceInfo() {
    
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
    ];
    final data = <String>[
      "Inv001",
      DateFormat("dd/MM/yyyy").format(DateTime.now()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

   Widget buildSupplierAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Capital Trade", style: TextStyle(fontWeight: FontWeight.bold)),
        // SizedBox(height: 1 * PdfPageFormat.mm),
        Text("+91 00000 00000"),
        //  SizedBox(height: 1 * PdfPageFormat.mm),
        Text("Line 1,\nLine 2,\nStreet,\nDistrict, State, India "),
        //  SizedBox(height: 1 * PdfPageFormat.mm),
        Text("GST-IN : "),
      ],
    );
  }

   Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          SizedBox(height: 0.8 ),
          Text("Sale Invoice"),
          SizedBox(height: 0.8 ),
        ],
      );

   Widget ?buildInvoice() {
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'GST',
      'Total'
    ];
    final data = Invoice(
      
      items: [InvoiceItem(
      date: DateTime.now(),
      description: "Product 1",
      quantity: 4,
      unitPrice: 200,
      vat: 12,
      vatType: 12,
      
      ),
      InvoiceItem(
      date: DateTime.now(),
      description: "Product 2",
      quantity: 2,
      unitPrice: 500,
      vat: 12,
      vatType: 12,
      
      ),
      ]).items?.map((item) {
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

    // return Table.fromTextArray(
    //   headers: headers,
    //   data: data,
    //   border: null,
    //   headerStyle: TextStyle(fontWeight: FontWeight.bold),
    //   headerDecoration: BoxDecoration(color: Colors.lightBlue),
    //   cellHeight: 30,
    //   cellAlignments: {
    //     0: Alignment.centerLeft,
    //     1: Alignment.centerRight,
    //     2: Alignment.centerRight,
    //     3: Alignment.centerRight,
    //     4: Alignment.centerRight,
    //     5: Alignment.centerRight,
    //   },
    // );
  }

   Widget buildTotal(Invoice invoice) {
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

    return Container(
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
                Divider(),
                buildText(
                  title: 'Discount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(invoice.info!.discount!),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(invoice.info!.grandTotal!),
                  unite: true,
                ),
                SizedBox(height: 2 ),
                Container(height: 1, color: Colors.grey[400]),
                SizedBox(height: 0.5),
                Container(height: 1, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
      ),
    );
  }

   Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          //SizedBox(height: 2 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 ),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

   buildSimpleText({
    String? title,
    String? value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title!, style: style),
        SizedBox(width: 2 ),
        Text(value!),
      ],
    );
  }

   buildText({
    String? title,
    String? value,
    double? width = double.infinity,
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

