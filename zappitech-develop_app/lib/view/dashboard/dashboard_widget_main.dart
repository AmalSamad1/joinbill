import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ziptech/providers/authProvider.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../providers/sales_providers/sales_invoice_provider.dart';
import '../items/item_ledger.dart';
import '../people/party_ledger.dart';
import '../sales/sale_invoice_add_widget.dart';
import '../sales/sales_invoice_widget.dart';
import 'drawerWidget.dart';

class DashboardWidgetMain extends StatefulWidget {
  final bool isDrawer;
  const DashboardWidgetMain(this.isDrawer, {Key? key}) : super(key: key);

  @override
  State<DashboardWidgetMain> createState() => _DashboardWidgetMainState();
}

class _DashboardWidgetMainState extends State<DashboardWidgetMain> {
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'press back again to close the app');
      return Future.value(false);
    }
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
            onWillPop: onWillPop,
            child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              //mainAxidsSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 2, 4),
                    child: Container(
                      margin: EdgeInsets.only(right: 4),
                      //width: MediaQuery.of(context).size.width * 0.,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: Color(0x33000000),
                            offset: Offset(-2, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'To receive',
                              style:
                                  FlutterFlowTheme.of(context).bodyText1.override(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                      ),
                            ),
                            Text(
                              '₹ 0.00',
                              style:
                                  FlutterFlowTheme.of(context).bodyText1.override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF4DC412),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2, 16, 16, 4),
                    child: Container(
                      margin: EdgeInsets.only(left: 4),
                      //width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: Color(0x33000000),
                            offset: Offset(-2, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'To pay',
                              style:
                                  FlutterFlowTheme.of(context).bodyText1.override(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                      ),
                            ),
                            Text(
                              '₹ 0.00',
                              style:
                                  FlutterFlowTheme.of(context).bodyText1.override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFE4300D),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 2, 16),
                    child: GestureDetector(
                      onTap: () async {
                        widget.isDrawer
                            ? await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemLedger(true),
                                ),
                              )
                            : context
                                .read<AuthProvider>()
                                .setCurrentPage(ItemLedger(false));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 4),
                        //width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBtnText,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: Color(0x33000000),
                              offset: Offset(-2, 5),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Center(
                            child: Text(
                              'Stock Summary',
                              style:
                                  FlutterFlowTheme.of(context).subtitle2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2, 16, 16, 16),
                    child: GestureDetector(
                      onTap: () async {
                       widget.isDrawer
                            ?  await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PartyLedger(true),
                          ),
                        ): context
                                .read<AuthProvider>()
                                .setCurrentPage(PartyLedger(false));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 4),
                        //width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBtnText,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: Color(0x33000000),
                              offset: Offset(-2, 5),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Center(
                            child: Text(
                              'Party Statement',
                              style:
                                  FlutterFlowTheme.of(context).subtitle2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            FutureBuilder(
              future: Provider.of<SalesInvoiceProvider>(context, listen: false)
                  .fetchSalesInvoice(),
              builder: (context, snapShot) => Consumer<SalesInvoiceProvider>(
                builder: (context, salesData, child) => Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                          child: Text(
                            'Sales',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 16, 0),
                          child: TextButton(
                            onPressed: () async {
                            widget.isDrawer ?   await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesInvoiceWidget(true),
                                ),
                              ): context.read<AuthProvider>().setCurrentPage(SalesInvoiceWidget(false));
                            },
                            child: Text(
                              'View All',
                              style:
                                  FlutterFlowTheme.of(context).bodyText1.override(
                                        fontFamily: 'Poppins',
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: List.generate(
                        salesData.salesInvoice.length >= 3
                            ? 3
                            : salesData.salesInvoice.length,
                        (index) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
                          child: GestureDetector(
                            onTap: () async {
                              widget.isDrawer ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SaleInvoiceAddWidget(true,
                                      data:
                                          salesData.searchInvoices[index].data(),
                                      isEdit: true,
                                      id: salesData.searchInvoices[index].id),
                                ),
                              ): context.read<AuthProvider>().setCurrentPage(SaleInvoiceAddWidget(false, data:
                                          salesData.searchInvoices[index].data(),
                                      isEdit: true,
                                      id: salesData.searchInvoices[index].id));
                            },
                            child:
                            Column(
                              children:[
                                Container(
                                  decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1, color: Color(0xFFCCD8ED)),
                                    borderRadius: BorderRadius.circular(13.0),
                                  ),),
                                  // elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align( alignment: Alignment.topCenter, child:
                                            Text(salesData.searchInvoices[index]
                                                .data()["customer"],
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                fontSize: 18,
                                                  fontWeight: FontWeight.w700
                                              ),),),
                                            Column(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: salesData.searchInvoices[index]
                                                        .data()["grand_total"] <=
                                                        salesData
                                                             .searchInvoices[index]
                                                              .data()["paid"]
                                                         ? Color(0xFF72C44A)
                                                        : Colors.red,
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                        4, 4, 4, 4),
                                                    child: Text(

                                                      salesData.searchInvoices[index]
                                                          .data()[
                                                      "grand_total"] <=
                                                          salesData
                                                              .searchInvoices[index]
                                                              .data()["paid"]
                                                          ? 'Paid'
                                                          : "Unpaid",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.w700
                                                      )
                                                    ),
                                                  ),
                                                ),


                                              ],
                                            ),
                                            // Text("",
                                            //   textAlign: TextAlign.center,
                                            //   style: new TextStyle(
                                            //     fontWeight: FontWeight.w500,
                                            //
                                            //   ),),
                                          ],
                                        ),
                                        Divider(thickness: 1,),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align( alignment: Alignment.topCenter, child:
                                            Text("Mobile No",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w500),)),
                                            Text(salesData.searchInvoices[index]
                                                .data()["phone"],
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w500,)),

                                          ],
                                        ),

                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align( alignment: Alignment.topCenter, child:
                                            Text("Tax",
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w500,)),),
                                            Text("${salesData.searchInvoices[index].data()["tax"].toStringAsFixed(2)}",
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w500,) ),

                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align( alignment: Alignment.topCenter, child:
                                            Text("Balance",
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w500,) ),),
                                            Text("₹${(salesData.searchInvoices[index].data()["grand_total"] - salesData.searchInvoices[index].data()["paid"]).toStringAsFixed(2)}",
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w500,)  ),

                                          ],
                                        ),
                                        Divider(thickness: 1),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align( alignment: Alignment.topCenter, child:
                                            Text("Total Amount",
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.w500,) ),),
                                            Text("₹ ${salesData.searchInvoices[index].data()["grand_total"].toStringAsFixed(2)}",
                                                style: new TextStyle(
                                                  color: salesData.searchInvoices[index]
                                                      .data()["grand_total"] <=
                                                      salesData
                                                          .searchInvoices[index]
                                                          .data()["paid"]?Color(0xFF72C44A):Colors.red.shade900,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,) ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ),


                          ]
                            ),
                          ),
                        ),
                      ),
                    ),






                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



}
